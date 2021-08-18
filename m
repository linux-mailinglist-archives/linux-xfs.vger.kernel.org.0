Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3823F088D
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Aug 2021 17:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbhHRP4C (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Aug 2021 11:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239990AbhHRP4B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Aug 2021 11:56:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5C836103E;
        Wed, 18 Aug 2021 15:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629302126;
        bh=PZAmhWywQpSAcyawhcUKAEdKY5gMnbv8yVFrQ7N9Hk4=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=V2k+jNb7HxNCZ4P1f/7ZK3e5sxIESyX2FW9vfAhPdTq6TU+8foFxEZwDEbRWhluJF
         NDiL/AD4ONGV6pucVi6cnePHfUQfgDP6XNRshtl0whzIPTP4FcuKYwie3Yet3Mxszp
         TURQKqWrk/86Ws+TnF4TYuQNz+9qkUnBK2dMRmnQPDs7sO0DHG9/mqte8AmjkpCgM9
         UE0UxSYeYpZeQuoACkZ5H6+EqeN+0UYaWszmie9NXcpOaBvqhG6x6RWSXSTNBMF9Ci
         GpSdoODAdGrF57GriBhDCE/8LH6B1JntpaOJ848s+f7JVHhh1W21QqoaFqugFp1iRJ
         Pd3kq1E+qxxqQ==
Date:   Wed, 18 Aug 2021 08:55:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/2] generic: test shutdowns of a nested filesystem
Message-ID: <20210818155526.GH12640@magnolia>
References: <162924439425.779465.16029390956507261795.stgit@magnolia>
 <162924440518.779465.6907507760500586987.stgit@magnolia>
 <20210818070654.hmhq7g5t4u3xueaj@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818070654.hmhq7g5t4u3xueaj@fedora>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 18, 2021 at 03:06:54PM +0800, Zorro Lang wrote:
> On Tue, Aug 17, 2021 at 04:53:25PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > generic/475, but we're running fsstress on a disk image inside the
> > scratch filesystem
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> Good to me, thanks for this helpful test case. Just one question,
> is it better to use xfs_metadump with "-o" option by default?

_xfs_metadump already passes -a and -o.

--D

> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> >  common/rc             |   20 +++++++
> >  tests/generic/725     |  136 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/725.out |    2 +
> >  3 files changed, 158 insertions(+)
> >  create mode 100755 tests/generic/725
> >  create mode 100644 tests/generic/725.out
> > 
> > 
> > diff --git a/common/rc b/common/rc
> > index 84757fc1..473bfb0a 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -631,6 +631,26 @@ _ext4_metadump()
> >  		$DUMP_COMPRESSOR -f "$dumpfile" &>> "$seqres.full"
> >  }
> >  
> > +# Capture the metadata of a filesystem in a dump file for offline analysis
> > +_metadump_dev() {
> > +	local device="$1"
> > +	local dumpfile="$2"
> > +	local compressopt="$3"
> > +
> > +	case "$FSTYP" in
> > +	ext*)
> > +		_ext4_metadump $device $dumpfile $compressopt
> > +		;;
> > +	xfs)
> > +		_xfs_metadump $dumpfile $device none $compressopt
> > +		;;
> > +	*)
> > +		echo "Don't know how to metadump $FSTYP"
> > +		return 1
> > +		;;
> > +	esac
> > +}
> > +
> >  _test_mkfs()
> >  {
> >      case $FSTYP in
> > diff --git a/tests/generic/725 b/tests/generic/725
> > new file mode 100755
> > index 00000000..ac008fdb
> > --- /dev/null
> > +++ b/tests/generic/725
> > @@ -0,0 +1,136 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 725
> > +#
> > +# Test nested log recovery with repeated (simulated) disk failures.  We kick
> > +# off fsstress on a loopback filesystem mounted on the scratch fs, then switch
> > +# out the underlying scratch device with dm-error to see what happens when the
> > +# disk goes down.  Having taken down both fses in this manner, remount them and
> > +# repeat.  This test simulates VM hosts crashing to try to shake out CoW bugs
> > +# in writeback on the host that cause VM guests to fail to recover.
> > +#
> > +. ./common/preamble
> > +_begin_fstest shutdown auto log metadata eio recoveryloop
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> > +	wait
> > +	if [ -n "$loopmnt" ]; then
> > +		$UMOUNT_PROG $loopmnt 2>/dev/null
> > +		rm -r -f $loopmnt
> > +	fi
> > +	rm -f $tmp.*
> > +	_dmerror_unmount
> > +	_dmerror_cleanup
> > +}
> > +
> > +# Import common functions.
> > +. ./common/dmerror
> > +. ./common/reflink
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +
> > +_require_scratch_reflink
> > +_require_cp_reflink
> > +_require_dm_target error
> > +_require_command "$KILLALL_PROG" "killall"
> > +
> > +echo "Silence is golden."
> > +
> > +_scratch_mkfs >> $seqres.full 2>&1
> > +_require_metadata_journaling $SCRATCH_DEV
> > +_dmerror_init
> > +_dmerror_mount
> > +
> > +# Create a fs image consuming 1/3 of the scratch fs
> > +scratch_freesp_bytes=$(_get_available_space $SCRATCH_MNT)
> > +loopimg_bytes=$((scratch_freesp_bytes / 3))
> > +
> > +loopimg=$SCRATCH_MNT/testfs
> > +truncate -s $loopimg_bytes $loopimg
> > +_mkfs_dev $loopimg
> > +
> > +loopmnt=$tmp.mount
> > +mkdir -p $loopmnt
> > +
> > +scratch_aliveflag=$tmp.runsnap
> > +snap_aliveflag=$tmp.snapping
> > +
> > +snap_loop_fs() {
> > +	touch "$snap_aliveflag"
> > +	while [ -e "$scratch_aliveflag" ]; do
> > +		rm -f $loopimg.a
> > +		_cp_reflink $loopimg $loopimg.a
> > +		sleep 1
> > +	done
> > +	rm -f "$snap_aliveflag"
> > +}
> > +
> > +fsstress=($FSSTRESS_PROG $FSSTRESS_AVOID -d "$loopmnt" -n 999999 -p "$((LOAD_FACTOR * 4))")
> > +
> > +for i in $(seq 1 $((25 * TIME_FACTOR)) ); do
> > +	touch $scratch_aliveflag
> > +	snap_loop_fs >> $seqres.full 2>&1 &
> > +
> > +	if ! _mount $loopimg $loopmnt -o loop; then
> > +		rm -f $scratch_aliveflag
> > +		_metadump_dev $loopimg $seqres.loop.$i.md
> > +		_fail "iteration $i loopimg mount failed"
> > +		break
> > +	fi
> > +
> > +	("${fsstress[@]}" >> $seqres.full &) > /dev/null 2>&1
> > +
> > +	# purposely include 0 second sleeps to test shutdown immediately after
> > +	# recovery
> > +	sleep $((RANDOM % (3 * TIME_FACTOR) ))
> > +	rm -f $scratch_aliveflag
> > +
> > +	# This test aims to simulate sudden disk failure, which means that we
> > +	# do not want to quiesce the filesystem or otherwise give it a chance
> > +	# to flush its logs.  Therefore we want to call dmsetup with the
> > +	# --nolockfs parameter; to make this happen we must call the load
> > +	# error table helper *without* 'lockfs'.
> > +	_dmerror_load_error_table
> > +
> > +	ps -e | grep fsstress > /dev/null 2>&1
> > +	while [ $? -eq 0 ]; do
> > +		$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> > +		wait > /dev/null 2>&1
> > +		ps -e | grep fsstress > /dev/null 2>&1
> > +	done
> > +	for ((i = 0; i < 10; i++)); do
> > +		test -e "$snap_aliveflag" || break
> > +		sleep 1
> > +	done
> > +
> > +	# Mount again to replay log after loading working table, so we have a
> > +	# consistent fs after test.
> > +	$UMOUNT_PROG $loopmnt
> > +	_dmerror_unmount || _fail "iteration $i scratch unmount failed"
> > +	_dmerror_load_working_table
> > +	if ! _dmerror_mount; then
> > +		_metadump_dev $DMERROR_DEV $seqres.scratch.$i.md
> > +		_fail "iteration $i scratch mount failed"
> > +	fi
> > +done
> > +
> > +# Make sure the fs image file is ok
> > +if [ -f "$loopimg" ]; then
> > +	if _mount $loopimg $loopmnt -o loop; then
> > +		$UMOUNT_PROG $loopmnt &> /dev/null
> > +	else
> > +		_metadump_dev $DMERROR_DEV $seqres.scratch.final.md
> > +		echo "final scratch mount failed"
> > +	fi
> > +	SCRATCH_RTDEV= SCRATCH_LOGDEV= _check_scratch_fs $loopimg
> > +fi
> > +
> > +# success, all done; let the test harness check the scratch fs
> > +status=0
> > +exit
> > diff --git a/tests/generic/725.out b/tests/generic/725.out
> > new file mode 100644
> > index 00000000..ed73a9fc
> > --- /dev/null
> > +++ b/tests/generic/725.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 725
> > +Silence is golden.
> > 
> 
