Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2831F32C4E0
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Mar 2021 01:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355006AbhCDASE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 3 Mar 2021 19:18:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:46310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243297AbhCCSLw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 13:11:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C106C64EBD;
        Wed,  3 Mar 2021 18:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614794954;
        bh=zkh+bLLUQ922vNoEox2vXpi+ai1SHSNnkY9ZrRLHi0o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PlzClEg7lgJCJVyfmKH2/bdnAvQRLXrKp2LI/5b/51A0XRZwq9EMJ8mSYTr0XktXP
         ubQCz8b4O1p1gEa80R7y5S6PSCGoivEOdOzESj0TgXF6KU9OofpztoFam9ApRwHNqg
         Z9MucMKvUlJh3FoMwEbCb/NiGMuDJIIp9RgAGuY0/pWDyXhGj6FW3ys1rFMjBEqDPD
         Dd0nuIPLq4tSxPI25T849yhlINSN1FxGvSoSz0vQSp1Lf1V6B5G53oaXfJ5FTeJ1JN
         oqtsjDcqROS1m4Sge+ZyfVLnVJ8fNb1BSL6j4FNuLppQohOsAOxiOxv1Y7qOYKhXiG
         V+FViI6FGHOgQ==
Date:   Wed, 3 Mar 2021 10:09:14 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH V4 09/11] xfs: Check for extent overflow when remapping
 an extent
Message-ID: <20210303180914.GQ7269@magnolia>
References: <20210118062022.15069-1-chandanrlinux@gmail.com>
 <20210118062022.15069-10-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118062022.15069-10-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 11:50:20AM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when remapping extents from one file's inode fork to another.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/529     | 82 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/529.out |  8 +++++
>  tests/xfs/group   |  1 +
>  3 files changed, 91 insertions(+)
>  create mode 100755 tests/xfs/529
>  create mode 100644 tests/xfs/529.out
> 
> diff --git a/tests/xfs/529 b/tests/xfs/529
> new file mode 100755
> index 00000000..f6a5922f
> --- /dev/null
> +++ b/tests/xfs/529
> @@ -0,0 +1,82 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 529
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# remapping extents from one file's inode fork to another.
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
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/reflink
> +. ./common/inject
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_scratch_reflink
> +_require_xfs_debug
> +_require_xfs_io_command "reflink"
> +_require_xfs_io_error_injection "reduce_max_iextents"
> +
> +echo "* Reflink remap extents"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +srcfile=${SCRATCH_MNT}/srcfile
> +dstfile=${SCRATCH_MNT}/dstfile
> +
> +nr_blks=15
> +
> +echo "Create \$srcfile having an extent of length $nr_blks blocks"
> +$XFS_IO_PROG -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
> +       -c fsync $srcfile >> $seqres.full
> +
> +echo "Create \$dstfile having an extent of length $nr_blks blocks"
> +$XFS_IO_PROG -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
> +       -c fsync $dstfile >> $seqres.full
> +
> +echo "Inject reduce_max_iextents error tag"
> +_scratch_inject_error reduce_max_iextents 1
> +
> +echo "Reflink every other block from \$srcfile into \$dstfile"
> +for i in $(seq 1 2 $((nr_blks - 1))); do
> +	$XFS_IO_PROG -f -c "reflink $srcfile $((i * bsize)) $((i * bsize)) $bsize" \
> +	       $dstfile >> $seqres.full 2>&1

_reflink_range?

--D

> +done
> +
> +echo "Verify \$dstfile's extent count"
> +nextents=$($XFS_IO_PROG -c 'stat' $dstfile | grep nextents)
> +nextents=${nextents##fsxattr.nextents = }
> +if (( $nextents > 10 )); then
> +	echo "Extent count overflow check failed: nextents = $nextents"
> +	exit 1
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/529.out b/tests/xfs/529.out
> new file mode 100644
> index 00000000..687a8bd2
> --- /dev/null
> +++ b/tests/xfs/529.out
> @@ -0,0 +1,8 @@
> +QA output created by 529
> +* Reflink remap extents
> +Format and mount fs
> +Create $srcfile having an extent of length 15 blocks
> +Create $dstfile having an extent of length 15 blocks
> +Inject reduce_max_iextents error tag
> +Reflink every other block from $srcfile into $dstfile
> +Verify $dstfile's extent count
> diff --git a/tests/xfs/group b/tests/xfs/group
> index c85aac6b..bc3958b3 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -526,3 +526,4 @@
>  526 auto quick dir hardlink symlink
>  527 auto quick
>  528 auto quick reflink
> +529 auto quick reflink
> -- 
> 2.29.2
> 
