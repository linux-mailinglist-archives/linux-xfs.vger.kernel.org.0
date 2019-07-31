Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA7A7C049
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Jul 2019 13:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfGaLnK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 31 Jul 2019 07:43:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44068 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfGaLnK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Jul 2019 07:43:10 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 883FB3091753;
        Wed, 31 Jul 2019 11:43:09 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E7532600CC;
        Wed, 31 Jul 2019 11:43:08 +0000 (UTC)
Date:   Wed, 31 Jul 2019 07:43:07 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: test new v5 bulkstat commands
Message-ID: <20190731114306.GC34040@bfoster>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
 <156394161882.1850833.4351446431166375360.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156394161882.1850833.4351446431166375360.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 31 Jul 2019 11:43:09 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 23, 2019 at 09:13:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check that the new v5 bulkstat commands do everything the old one do,
> and then make sure the new functionality actually works.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/xfs                 |    6 +
>  src/Makefile               |    2 
>  src/bulkstat_null_ocount.c |   61 +++++++++
>  tests/xfs/085              |    2 
>  tests/xfs/086              |    2 
>  tests/xfs/087              |    2 
>  tests/xfs/088              |    2 
>  tests/xfs/089              |    2 
>  tests/xfs/091              |    2 
>  tests/xfs/093              |    2 
>  tests/xfs/097              |    2 
>  tests/xfs/130              |    2 
>  tests/xfs/235              |    2 
>  tests/xfs/271              |    2 
>  tests/xfs/744              |  212 +++++++++++++++++++++++++++++++
>  tests/xfs/744.out          |  297 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/745              |   44 +++++++
>  tests/xfs/745.out          |    2 
>  tests/xfs/group            |    2 
>  19 files changed, 636 insertions(+), 12 deletions(-)
>  create mode 100644 src/bulkstat_null_ocount.c
>  create mode 100755 tests/xfs/744
>  create mode 100644 tests/xfs/744.out
>  create mode 100755 tests/xfs/745
>  create mode 100644 tests/xfs/745.out
> 
> 
> diff --git a/common/xfs b/common/xfs
> index 2b38e94b..1bce3c18 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -878,3 +878,9 @@ _force_xfsv4_mount_options()
>  	fi
>  	echo "MOUNT_OPTIONS = $MOUNT_OPTIONS" >>$seqres.full
>  }
> +
> +# Find AG count of mounted filesystem
> +_xfs_mount_agcount()
> +{
> +	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
> +}

This and the associated changes to existing tests should probably be a
separate patch.

...
> diff --git a/tests/xfs/744 b/tests/xfs/744
> new file mode 100755
> index 00000000..ef605301
> --- /dev/null
> +++ b/tests/xfs/744
> @@ -0,0 +1,212 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
> +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 744
> +#
> +# Use the xfs_io bulkstat utility to verify bulkstat finds all inodes in a
> +# filesystem.  Test under various inode counts, inobt record layouts and
> +# bulkstat batch sizes.  Test v1 and v5 ioctls explicitly, as well as the
> +# ioctl version autodetection code in libfrog.
> +#

Apparently I don't have xfs_io bulkstat support. Is that posted
somewhere? At a glance the test looks mostly fine..

> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +bstat_versions()
> +{
> +	echo "default"
> +	echo "v1 -v1"
> +	if [ -n "$has_v5" ]; then
> +		echo "v5 -v5"
> +	else
> +		echo "v5"
> +	fi
> +}
> +
> +# print the number of inodes counted by bulkstat
> +bstat_count()
> +{
> +	local batchsize="$1"
> +	local tag="$2"
> +
> +	bstat_versions | while read v_tag v_flag; do
> +		echo "$tag($v_tag): passing \"$v_flag\" to bulkstat" >> $seqres.full
> +		echo -n "bulkstat $tag($v_tag): "
> +		$XFS_IO_PROG -c "bulkstat -n $batchsize $vflag" $SCRATCH_MNT | grep ino | wc -l

s/vflag/v_flag/ ?

> +	done
> +}
> +
> +# print the number of inodes counted by per-ag bulkstat
> +bstat_perag_count()
> +{
> +	local batchsize="$1"
> +	local tag="$2"
> +
> +	local agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
> +
> +	bstat_versions | while read v_tag v_flag; do
> +		echo -n "bulkstat $tag($v_tag): "
> +		seq 0 $((agcount - 1)) | while read ag; do
> +			$XFS_IO_PROG -c "bulkstat -a $ag -n $batchsize $v_flag" $SCRATCH_MNT
> +		done | grep ino | wc -l
> +	done
> +}
> +
> +# Sum the number of allocated inodes in each AG in a fs.
> +inumbers_ag()
> +{
> +	local agcount="$1"
> +	local batchsize="$2"
> +	local mount="$3"
> +	local v_flag="$4"
> +
> +	seq 0 $((agcount - 1)) | while read ag; do
> +		$XFS_IO_PROG -c "inumbers -a $ag -n $batchsize $v_flag" $mount
> +	done | grep alloccount | awk '{x += $3} END { print(x) }'
> +}
> +
> +# Sum the number of allocated inodes in the whole fs all at once.
> +inumbers_fs()
> +{
> +	local dir="$1"
> +	local v_flag="$2"
> +
> +	$XFS_IO_PROG -c "inumbers $v_flag" "$dir" | grep alloccount | \
> +		awk '{x += $3} END { print(x) }'
> +}
> +
> +# print the number of inodes counted by inumbers
> +inumbers_count()
> +{
> +	local expect="$1"
> +
> +	# There probably aren't more than 10 hidden inodes, right?
> +	local tolerance=10
> +
> +	# Force all background inode cleanup

Comment took me a second to grok. This refers to unlinked inode cleanup,
right?

> +	_scratch_cycle_mount
> +
> +	bstat_versions | while read v_tag v_flag; do
> +		echo -n "inumbers all($v_tag): "
> +		nr=$(inumbers_fs $SCRATCH_MNT $v_flag)
> +		_within_tolerance "inumbers" $nr $expect $tolerance -v
> +
> +		local agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
> +		for batchsize in 64 2 1; do

Perhaps we should stuff a value > than the per-record inode count in
here as well.

> +			echo -n "inumbers $batchsize($v_tag): "
> +			nr=$(inumbers_ag $agcount $batchsize $SCRATCH_MNT $v_flag)
> +			_within_tolerance "inumbers" $nr $expect $tolerance -v
> +		done
> +	done
> +}
> +
> +# compare the src/bstat output against the xfs_io bstat output

This compares actual inode numbers, right? If so, I'd point that out in
the comment.

> +bstat_compare()
> +{
> +	bstat_versions | while read v_tag v_flag; do
> +		diff -u <(./src/bstat $SCRATCH_MNT | grep ino | awk '{print $2}') \
> +			<($XFS_IO_PROG -c "bulkstat $v_flag" $SCRATCH_MNT | grep ino | awk '{print $3}')
> +	done
> +}
> +
...
> diff --git a/tests/xfs/745 b/tests/xfs/745
> new file mode 100755
> index 00000000..6931d46b
> --- /dev/null
> +++ b/tests/xfs/745
> @@ -0,0 +1,44 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 745
> +#
> +# Regression test for a long-standing bug in BULKSTAT and INUMBERS where
> +# the kernel fails to write thew new @lastip value back to userspace if
> +# @ocount is NULL.
> +#

I think it would be helpful to reference the upstream fix here, which
IIRC is commit f16fe3ecde62 ("xfs: bulkstat should copy lastip whenever
userspace supplies one"). Otherwise this test looks fine to me.

Brian

> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +_require_test_program "bulkstat_null_ocount"
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_supported_os Linux
> +
> +rm -f $seqres.full
> +
> +echo "Silence is golden."
> +src/bulkstat_null_ocount $TEST_DIR
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/745.out b/tests/xfs/745.out
> new file mode 100644
> index 00000000..ce947de2
> --- /dev/null
> +++ b/tests/xfs/745.out
> @@ -0,0 +1,2 @@
> +QA output created by 745
> +Silence is golden.
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 270d82ff..ef0cf92c 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -506,3 +506,5 @@
>  506 auto quick health
>  507 clone
>  508 auto quick quota
> +744 auto ioctl quick
> +745 auto ioctl quick
> 
