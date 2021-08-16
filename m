Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D973EDB06
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Aug 2021 18:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbhHPQf5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Aug 2021 12:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229836AbhHPQf5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Aug 2021 12:35:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D48C61038;
        Mon, 16 Aug 2021 16:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629131725;
        bh=nonwatu411sNGJGh4z3mNdxhOfx+7YWn6hXH2ngInqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SS9r9ppsi+27Za6XMA6emsHoEU+5VvfMxocnkan3AeD9jqhlj9EgpccDrl2thPP1C
         9LASvp7gN6tP+t4qnrRUSsKUAsch9a9dC2whDF76VQCCG0KS1AGT6W4lB59b4e0oNG
         3bz0j3XCztvWvXVYbhAkPJ/3rKXW2isjyWmQJ0nbU/h/bOQAZTPNKu7cco1Jmt8Iwj
         AFdbCjKOiY2EAS0IHph2mM2LCeuU2FvHPztQzi5F0kyS2Px/MeH8cR61Btf1fj5agC
         5GJL38tZidySBrYhukW5FmCGp1WqGrvHs9XZR5M/fmk5JR6eif+rv+M4BF8z7G0kJG
         RyLiEArkCS2Ww==
Date:   Mon, 16 Aug 2021 09:35:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/3] generic: test shutdowns of a nested filesystem
Message-ID: <20210816163524.GA12640@magnolia>
References: <162743101932.3428896.8510279402246446036.stgit@magnolia>
 <162743103024.3428896.8525632218517299015.stgit@magnolia>
 <YRlApOTms4XPbwke@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRlApOTms4XPbwke@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 16, 2021 at 12:28:20AM +0800, Eryu Guan wrote:
> On Tue, Jul 27, 2021 at 05:10:30PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > generic/475, but we're running fsstress on a disk image inside the
> > scratch filesystem
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/generic/725     |  136 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/725.out |    2 +
> >  2 files changed, 138 insertions(+)
> >  create mode 100755 tests/generic/725
> >  create mode 100644 tests/generic/725.out
> > 
> > 
> > diff --git a/tests/generic/725 b/tests/generic/725
> > new file mode 100755
> > index 00000000..f43bcb37
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
> 
> It currently fails for me on btrfs, the loop mount failed in 2nd
> iteration, seems like a bug in btrfs.

Yep.  Until recently (aka the Big Xfs Log Recovery Bughunt of 2021) it
wouldn't pass xfs either. :/

> > +#
> > +. ./common/preamble
> > +_begin_fstest shutdown auto log metadata eio
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> > +	wait
> > +	if [ -n "$loopmnt" ]; then
> > +		umount $loopmnt 2>/dev/null
> 
> $UMOUNT_PROG
> 
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
> > +scratch_freesp_bytes=$(stat -f -c '%a * %S' $SCRATCH_MNT | bc)
> 
> _get_available_space $SCRATCH_MNT ?
> 
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
> > +		_fail "loop mount failed"
> 
> I found it a bit easier to debug if print $i here.

Ok, I'll change it to "loop $i mount failed".

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
> > +	# consistent XFS after test.
> 
> This is a generic test, fix the XFS specific comments?

Oops.  "...a consistent fs after test."

> > +	$UMOUNT_PROG $loopmnt
> > +	_dmerror_unmount || _fail "unmount failed"
> > +	_dmerror_load_working_table
> > +	if ! _dmerror_mount; then
> > +		dmsetup table | tee -a /dev/ttyprintk
> > +		lsblk | tee -a /dev/ttyprintk
> > +		$XFS_METADUMP_PROG -a -g -o $DMERROR_DEV $seqres.dmfail.md
> 
> Above logs all should go to $seqres.full ?

Oops, yeah.  I'll remove them since I was only using them to check the
system state.

> And $XFS_METADUMP_PROG is not suitable for a generic test.

I'll create _metadump_dev so that this at least works for the two
filesystems for which we have dump creation helpers (ext* and xfs).

> > +		_fail "mount failed"
> > +	fi
> > +done
> > +
> > +# Make sure the fs image file is ok
> > +if [ -f "$loopimg" ]; then
> > +	if _mount $loopimg $loopmnt -o loop; then
> > +		$UMOUNT_PROG $loopmnt &> /dev/null
> > +	else
> > +		echo "final loop mount failed"
> > +	fi
> > +	_check_xfs_filesystem $loopimg none none
> 
> Same here, use _check_scratch_fs?

$loopimg is a file within the scratch fs.

--D

> Thanks,
> Eryu
> 
> > +fi
> > +
> > +# success, all done
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
