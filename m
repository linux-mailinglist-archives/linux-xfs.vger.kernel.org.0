Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CC0401031
	for <lists+linux-xfs@lfdr.de>; Sun,  5 Sep 2021 16:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbhIEO3W (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 5 Sep 2021 10:29:22 -0400
Received: from out20-87.mail.aliyun.com ([115.124.20.87]:49716 "EHLO
        out20-87.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhIEO3V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Sep 2021 10:29:21 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436299|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.337392-0.0244149-0.638193;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047207;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.LFticQR_1630852096;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.LFticQR_1630852096)
          by smtp.aliyun-inc.com(10.147.40.233);
          Sun, 05 Sep 2021 22:28:16 +0800
Date:   Sun, 5 Sep 2021 22:28:16 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: test fsx with extent size hints set on a
 realtime file
Message-ID: <YTTUALZL8On/5ynk@desktop>
References: <163045508495.769915.4859353445119566326.stgit@magnolia>
 <163045509043.769915.12768254084054792591.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163045509043.769915.12768254084054792591.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 31, 2021 at 05:11:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is a regression test for the two realtime allocator bug fixes:
> 
> xfs: adjust rt allocation minlen when extszhint > rtextsize
> xfs: retry allocations when locality-based search fails
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks fine to me, just a few minor nits inline.

> ---
>  tests/xfs/775     |  165 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/775.out |    3 +
>  2 files changed, 168 insertions(+)
>  create mode 100755 tests/xfs/775
>  create mode 100644 tests/xfs/775.out
> 
> 
> diff --git a/tests/xfs/775 b/tests/xfs/775
> new file mode 100755
> index 00000000..e8e6b728
> --- /dev/null
> +++ b/tests/xfs/775
> @@ -0,0 +1,165 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021, Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 775
> +#
> +# Regression test for commits:
> +#
> +# 9d5e8492eee0 ("xfs: adjust rt allocation minlen when extszhint > rtextsize")
> +# 676a659b60af ("xfs: retry allocations when locality-based search fails")
> +#
> +# The first bug occurs when an extent size hint is set on a realtime file.
> +# xfs_bmapi_rtalloc adjusts the offset and length of the allocation request to
> +# try to satisfy the hint, but doesn't adjust minlen to match.  If the
> +# allocator finds free space that isn't large enough to map even a single block
> +# of the original request, bmapi_write will return ENOSPC and the write fails
> +# even though there's plenty of space.
> +#
> +# The second bug occurs when an extent size hint is set on a file, we ask to
> +# allocate blocks in an empty region immediately adjacent to a previous
> +# allocation, and the nearest available free space isn't anywhere near the
> +# previous allocation, the near allocator will give up and return ENOSPC, even
> +# if there's sufficient free realtime extents to satisfy the allocation
> +# request.
> +#
> +# Both bugs can be exploited by the same user call sequence, so here's a
> +# targeted test that runs in less time than the reproducers that are listed in
> +# the fix patches themselves.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw realtime
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +}

Seems there's no need to override the default cleanup function?

> +
> +# Import common functions.
> +. ./common/filter
> +
> +# real QA test starts here

_supported_fs xfs

> +_require_scratch
> +_require_realtime
> +_require_xfs_io_command "falloc"
> +_require_xfs_io_command "fpunch"
> +_require_test_program "punch-alternating"
> +
> +fill_rtdev()
> +{
> +	file=$1
> +
> +	filesize=`_get_available_space $SCRATCH_MNT`
> +	$XFS_IO_PROG -f -c "truncate $filesize" -c "falloc 0 $filesize" $file
> +
> +	chunks=20
> +	chunksizemb=$((filesize / chunks / 1048576))
> +	seq 1 $chunks | while read f; do
> +		echo "$((f * chunksizemb)) file size $f / 20"
> +		$XFS_IO_PROG -fc "falloc -k $(( (f - 1) * chunksizemb))m ${chunksizemb}m" $file
> +	done
> +
> +	chunks=100
> +	chunksizemb=$((filesize / chunks / 1048576))
> +	seq 80 $chunks | while read f; do
> +		echo "$((f * chunksizemb)) file size $f / $chunks"
> +		$XFS_IO_PROG -fc "falloc -k $(( (f - 1) * chunksizemb))m ${chunksizemb}m" $file
> +	done
> +
> +	filesizemb=$((filesize / 1048576))
> +	$XFS_IO_PROG -fc "falloc -k 0 ${filesizemb}m" $file
> +
> +	# Try again anyway
> +	avail=`_get_available_space $SCRATCH_MNT`
> +	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" ${file}
> +}
> +
> +echo "Format and mount"
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount >> $seqres.full 2>&1
> +
> +# This is a test of the rt allocator; force all files to be created realtime
> +_xfs_force_bdev realtime $SCRATCH_MNT
> +
> +# Set the extent size hint larger than the realtime extent size.  This is
> +# necessary to exercise the minlen constraints on the realtime allocator.
> +fsbsize=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep geom.bsize | awk '{print $3}')
> +rtextsize_blks=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep geom.rtextsize | awk '{print $3}')
> +extsize=$((2 * rtextsize_blks * fsbsize))
> +
> +echo "rtextsize_blks=$rtextsize_blks extsize=$extsize" >> $seqres.full
> +_xfs_force_bdev realtime $SCRATCH_MNT

Already done above, could be removed?

Thanks,
Eryu

> +$XFS_IO_PROG -c "extsize $extsize" $SCRATCH_MNT
> +
> +# Compute the geometry of the test files we're going to create.  Realtime
> +# volumes are simple, which means that we can control the space allocations
> +# exactly to exploit bugs!
> +#
> +# Since this is a test of the near rt allocator, we need to set up the test to
> +# have a victim file with at least one rt extent allocated to it and enough
> +# free space to allocate at least one more rt extent at an adjacent file
> +# offset.  The free space must not be immediately adjacent to the the first
> +# extent that we allocate to the victim file, and it must not be large enough
> +# to satisfy the entire allocation request all at once.
> +#
> +# Our free space fragmentation strategy is the usual fallocate-and-punch swiss
> +# cheese file, which means the free space is split into five sections:
> +#
> +# The first will be remapped into the victim file.
> +#
> +# The second section exists to prevent the free extents from being adjacent to
> +# the first section.  It will be very large, since we allocate all the rt
> +# space.
> +#
> +# The last three sections will have every other rt extent punched out to create
> +# some free space.
> +remap_sz=$((extsize * 2))
> +required_sz=$((5 * remap_sz))
> +free_rtspace=$(_get_available_space $SCRATCH_MNT)
> +if [ $free_rtspace -lt $required_sz ]; then
> +	_notrun "Insufficient free space on rt volume.  Needed $required_sz, saw $free_rtspace."
> +fi
> +
> +# Allocate all the space on the rt volume so that we can control space
> +# allocations exactly.
> +fill_rtdev $SCRATCH_MNT/bigfile &>> $seqres.full
> +
> +# We need at least 4 remap sections to proceed
> +bigfile_sz=$(stat -c '%s' $SCRATCH_MNT/bigfile)
> +if [ $bigfile_sz -lt $required_sz ]; then
> +	_notrun "Free space control file needed $required_sz bytes, got $bigfile_sz."
> +fi
> +
> +# Remap the first remap section to a victim file.
> +$XFS_IO_PROG -c "fpunch 0 $remap_sz" $SCRATCH_MNT/bigfile
> +$XFS_IO_PROG -f -c "truncate $required_sz" -c "falloc 0 $remap_sz" $SCRATCH_MNT/victim
> +
> +# Punch out every other extent of the last two sections, to fragment free space.
> +frag_sz=$((remap_sz * 3))
> +punch_off=$((bigfile_sz - frag_sz))
> +$here/src/punch-alternating $SCRATCH_MNT/bigfile -o $((punch_off / fsbsize)) -i $((rtextsize_blks * 2)) -s $rtextsize_blks
> +
> +# Make sure we have some free rtextents.
> +free_rtx=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | grep counts.freertx | awk '{print $3}')
> +if [ $free_rtx -eq 0 ]; then
> +	echo "Expected fragmented free rt space, found none."
> +fi
> +
> +# Try to double the amount of blocks in the victim file.  On a buggy kernel,
> +# the rt allocator will fail immediately with ENOSPC even though we left enough
> +# free space for the write will complete fully.
> +echo "Try to write a bunch of stuff to the fragmented rt space"
> +$XFS_IO_PROG -c "pwrite -S 0x63 -b $remap_sz $remap_sz $remap_sz" -c stat $SCRATCH_MNT/victim >> $seqres.full
> +
> +# The victim file should own at least two sections' worth of blocks.
> +victim_sectors=$(stat -c '%b' $SCRATCH_MNT/victim)
> +victim_space_usage=$((victim_sectors * 512))
> +expected_usage=$((remap_sz * 2))
> +
> +if [ $victim_space_usage -lt $expected_usage ]; then
> +	echo "Victim file should be using at least $expected_usage bytes, saw $victim_space_usage."
> +fi
> +
> +status=0
> +exit
> diff --git a/tests/xfs/775.out b/tests/xfs/775.out
> new file mode 100644
> index 00000000..f5a72156
> --- /dev/null
> +++ b/tests/xfs/775.out
> @@ -0,0 +1,3 @@
> +QA output created by 775
> +Format and mount
> +Try to write a bunch of stuff to the fragmented rt space
