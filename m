Return-Path: <linux-xfs+bounces-13137-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEDBA98482D
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Sep 2024 17:03:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D2461C22A62
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Sep 2024 15:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C7C11AB52F;
	Tue, 24 Sep 2024 15:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="StFb9FoB"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1679F1FDD;
	Tue, 24 Sep 2024 15:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727190197; cv=none; b=oRQxhJLzWzT8C3D+BAktIfO4csNe7hCy2G1MrpNfJwNL0lPOLD6kVSixTzhHjBoJnVVHPNLgRw4S0aPrQFzPWKyul1wJ3G1gcnJ+Qgvdb9x6BopQ4kmtbk+N9yAh57XfTPnkAYDt76lr32tD5Y6Hem8MBm3FN/V0EHoUwJrsxOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727190197; c=relaxed/simple;
	bh=fbHJ9ybr+udNypmoDs5mZsOKlu2XH/zjqlEsEqG6/Fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ezH8gBKtb2M5jZ7O2CB0hvj+K8csP2vHyq9Umk05XSwDWuwahBEl8cosVIvK0HTMhI2Y4DEFP7KJCYxSSEDD3jerKrgojsxvA9vUrl1dVCzrloABNNPhDq4rKqBNKp3QNkl5yfuEtvmBm6l51lJ7QaE5rWfmeB1iONpO3lGrCYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=StFb9FoB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB5EC4CEC4;
	Tue, 24 Sep 2024 15:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727190196;
	bh=fbHJ9ybr+udNypmoDs5mZsOKlu2XH/zjqlEsEqG6/Fo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=StFb9FoBmptK+1KcJ2SC2F1Vgk7VajFIGlL5Dvgs/GGfqWdPnyekOL+4hBb1D+3jW
	 ZxlztP/4U/QnkljVsWelCRGy5mczDFdd7M2lAXKWGtLCCsmxTVKtPb9gU8xJywBYIV
	 UYmmCSwMW3RykIRWqG3YldIiB/rNOZnhGwV0hE87VKyvb7ONf6XC7ZQnIgL+A5UV1/
	 ZPvFu3U1/QHi/6LsE9XlJh1YR34QvQODTn4VDJjFN74lasZnRNAygU+fa52fGj4CLL
	 LdIM4lKw5ngXSbXtAYZtYOB+yRqNRYDKQOXyw9fVWHayGBHYmGRUI1v/lQ4od+em1L
	 +Z06WJjfS2KRw==
Date: Tue, 24 Sep 2024 08:03:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: new EOF fragmentation tests
Message-ID: <20240924150315.GH21853@frogsfrogsfrogs>
References: <20240924084551.1802795-1-hch@lst.de>
 <20240924084551.1802795-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240924084551.1802795-2-hch@lst.de>

On Tue, Sep 24, 2024 at 10:45:48AM +0200, Christoph Hellwig wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> These tests create substantial file fragmentation as a result of
> application actions that defeat post-EOF preallocation
> optimisations. They are intended to replicate known vectors for
> these problems, and provide a check that the fragmentation levels
> have been controlled. The mitigations we make may not completely
> remove fragmentation (e.g. they may demonstrate speculative delalloc
> related extent size growth) so the checks don't assume we'll end up
> with perfect layouts and hence check for an exceptable level of
> fragmentation rather than none.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> [move to different test number, update to current xfstest APIs]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/1500     | 66 +++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1500.out |  9 ++++++
>  tests/xfs/1501     | 68 ++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1501.out |  9 ++++++
>  tests/xfs/1502     | 68 ++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1502.out |  9 ++++++
>  tests/xfs/1503     | 77 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1503.out | 33 ++++++++++++++++++++
>  8 files changed, 339 insertions(+)
>  create mode 100755 tests/xfs/1500
>  create mode 100644 tests/xfs/1500.out
>  create mode 100755 tests/xfs/1501
>  create mode 100644 tests/xfs/1501.out
>  create mode 100755 tests/xfs/1502
>  create mode 100644 tests/xfs/1502.out
>  create mode 100755 tests/xfs/1503
>  create mode 100644 tests/xfs/1503.out
> 
> diff --git a/tests/xfs/1500 b/tests/xfs/1500
> new file mode 100755
> index 000000000..de0e1df62
> --- /dev/null
> +++ b/tests/xfs/1500
> @@ -0,0 +1,66 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test xfs/500

Should be "FS QA Test 1500" or at least not say "xfs/500" given the
filename.  Same for the other tests.

> +#
> +# Post-EOF preallocation defeat test for O_SYNC buffered I/O.
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto quick prealloc rw
> +
> +. ./common/rc
> +. ./common/filter
> +
> +_require_scratch
> +
> +_cleanup()
> +{
> +	# try to kill all background processes
> +	wait
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +
> +# Write multiple files in parallel using synchronous buffered writes. Aim is to
> +# interleave allocations to fragment the files. Synchronous writes defeat the
> +# open/write/close heuristics in xfs_file_release() that prevent EOF block
> +# removal, so this should fragment badly. Typical problematic behaviour shows
> +# per-file extent counts of >900 (almost worse case) whilst fixed behaviour
> +# typically shows extent counts in the low 20s.
> +#
> +# Failure is determined by golden output mismatch from _within_tolerance().
> +
> +workfile=$SCRATCH_MNT/file
> +nfiles=8
> +wsize=4096

Shouldn't this be _get_file_block_size instead of hardcoded 4k?
Same for all the other tests.

> +wcnt=1000
> +
> +write_sync_file()
> +{
> +	idx=$1
> +
> +	for ((cnt=0; cnt<$wcnt; cnt++)); do
> +		$XFS_IO_PROG -f -s -c "pwrite $((cnt * wsize)) $wsize" $workfile.$idx
> +	done
> +}
> +
> +rm -f $workfile*
> +for ((n=0; n<$nfiles; n++)); do
> +	write_sync_file $n > /dev/null 2>&1 &
> +done
> +wait
> +sync
> +
> +for ((n=0; n<$nfiles; n++)); do
> +	count=$(_count_extents $workfile.$n)
> +	# Acceptible extent count range is 1-40
> +	_within_tolerance "file.$n extent count" $count 21 19 -v
> +done
> +
> +status=0
> +exit
> diff --git a/tests/xfs/1500.out b/tests/xfs/1500.out
> new file mode 100644
> index 000000000..414df87ed
> --- /dev/null
> +++ b/tests/xfs/1500.out
> @@ -0,0 +1,9 @@
> +QA output created by 1500
> +file.0 extent count is in range
> +file.1 extent count is in range
> +file.2 extent count is in range
> +file.3 extent count is in range
> +file.4 extent count is in range
> +file.5 extent count is in range
> +file.6 extent count is in range
> +file.7 extent count is in range
> diff --git a/tests/xfs/1501 b/tests/xfs/1501
> new file mode 100755
> index 000000000..cf3cbf8b5
> --- /dev/null
> +++ b/tests/xfs/1501
> @@ -0,0 +1,68 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test xfs/501
> +#
> +# Post-EOF preallocation defeat test for buffered I/O with extent size hints.
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto quick prealloc rw
> +
> +. ./common/rc
> +. ./common/filter
> +
> +_require_scratch
> +
> +_cleanup()
> +{
> +	# try to kill all background processes
> +	wait
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +
> +# Write multiple files in parallel using buffered writes with extent size hints.
> +# Aim is to interleave allocations to fragment the files. Writes w/ extent size
> +# hints set defeat the open/write/close heuristics in xfs_file_release() that
> +# prevent EOF block removal, so this should fragment badly. Typical problematic
> +# behaviour shows per-file extent counts of 1000 (worst case!) whilst
> +# fixed behaviour should show very few extents (almost best case).
> +#
> +# Failure is determined by golden output mismatch from _within_tolerance().
> +
> +workfile=$SCRATCH_MNT/file
> +nfiles=8
> +wsize=4096
> +wcnt=1000
> +extent_size=16m
> +
> +write_extsz_file()
> +{
> +	idx=$1
> +
> +	$XFS_IO_PROG -f -c "extsize $extent_size" $workfile.$idx
> +	for ((cnt=0; cnt<$wcnt; cnt++)); do
> +		$XFS_IO_PROG -f -c "pwrite $((cnt * wsize)) $wsize" $workfile.$idx
> +	done
> +}
> +
> +rm -f $workfile*
> +for ((n=0; n<$nfiles; n++)); do
> +	write_extsz_file $n > /dev/null 2>&1 &
> +done
> +wait
> +sync
> +
> +for ((n=0; n<$nfiles; n++)); do
> +	count=$(_count_extents $workfile.$n)
> +	# Acceptible extent count range is 1-10
> +	_within_tolerance "file.$n extent count" $count 2 1 8 -v
> +done
> +
> +status=0
> +exit
> diff --git a/tests/xfs/1501.out b/tests/xfs/1501.out
> new file mode 100644
> index 000000000..a266ef74b
> --- /dev/null
> +++ b/tests/xfs/1501.out
> @@ -0,0 +1,9 @@
> +QA output created by 1501
> +file.0 extent count is in range
> +file.1 extent count is in range
> +file.2 extent count is in range
> +file.3 extent count is in range
> +file.4 extent count is in range
> +file.5 extent count is in range
> +file.6 extent count is in range
> +file.7 extent count is in range
> diff --git a/tests/xfs/1502 b/tests/xfs/1502
> new file mode 100755
> index 000000000..f4228667a
> --- /dev/null
> +++ b/tests/xfs/1502
> @@ -0,0 +1,68 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test xfs/502
> +#
> +# Post-EOF preallocation defeat test for direct I/O with extent size hints.
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto quick prealloc rw
> +
> +. ./common/rc
> +. ./common/filter
> +
> +_require_scratch

This one wants _require_odirect in case we ever disable directio for
some weird xfs config.

> +
> +_cleanup()
> +{
> +	# try to kill all background processes
> +	wait
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +
> +# Write multiple files in parallel using O_DIRECT writes w/ extent size hints.
> +# Aim is to interleave allocations to fragment the files. O_DIRECT writes defeat
> +# the open/write/close heuristics in xfs_file_release() that prevent EOF block
> +# removal, so this should fragment badly. Typical problematic behaviour shows
> +# per-file extent counts of ~1000 (worst case) whilst fixed behaviour typically
> +# shows extent counts in the low single digits (almost best case)
> +#
> +# Failure is determined by golden output mismatch from _within_tolerance().
> +
> +workfile=$SCRATCH_MNT/file
> +nfiles=8
> +wsize=4096
> +wcnt=1000
> +extent_size=16m
> +
> +write_direct_file()
> +{
> +	idx=$1
> +
> +	$XFS_IO_PROG -f -c "extsize $extent_size" $workfile.$idx
> +	for ((cnt=0; cnt<$wcnt; cnt++)); do
> +		$XFS_IO_PROG -f -d -c "pwrite $((cnt * wsize)) $wsize" $workfile.$idx
> +	done
> +}
> +
> +rm -f $workfile*
> +for ((n=0; n<$nfiles; n++)); do
> +	write_direct_file $n > /dev/null 2>&1 &
> +done
> +wait
> +sync
> +
> +for ((n=0; n<$nfiles; n++)); do
> +	count=$(_count_extents $workfile.$n)
> +	# Acceptible extent count range is 1-10
> +	_within_tolerance "file.$n extent count" $count 2 1 8 -v
> +done
> +
> +status=0
> +exit
> diff --git a/tests/xfs/1502.out b/tests/xfs/1502.out
> new file mode 100644
> index 000000000..82c8760a3
> --- /dev/null
> +++ b/tests/xfs/1502.out
> @@ -0,0 +1,9 @@
> +QA output created by 1502
> +file.0 extent count is in range
> +file.1 extent count is in range
> +file.2 extent count is in range
> +file.3 extent count is in range
> +file.4 extent count is in range
> +file.5 extent count is in range
> +file.6 extent count is in range
> +file.7 extent count is in range
> diff --git a/tests/xfs/1503 b/tests/xfs/1503
> new file mode 100755
> index 000000000..9002f87e6
> --- /dev/null
> +++ b/tests/xfs/1503
> @@ -0,0 +1,77 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test xfs/503
> +#
> +# Post-EOF preallocation defeat test with O_SYNC buffered I/O that repeatedly
> +# closes and reopens the files.
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto prealloc rw
> +
> +. ./common/rc
> +. ./common/filter
> +
> +_require_scratch
> +
> +_cleanup()
> +{
> +	# try to kill all background processes
> +	wait
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +
> +# Write multiple files in parallel using synchronous buffered writes that
> +# repeatedly close and reopen the fails. Aim is to interleave allocations to
> +# fragment the files. Assuming we've fixed the synchronous write defeat, we can
> +# still trigger the same issue with a open/read/close on O_RDONLY files. We
> +# should not be triggering EOF preallocation removal on files we don't have
> +# permission to write, so until this is fixed it should fragment badly.  Typical
> +# problematic behaviour shows per-file extent counts of 50-350 whilst fixed
> +# behaviour typically demonstrates post-eof speculative delalloc growth in
> +# extent size (~6 extents for 50MB file).
> +#
> +# Failure is determined by golden output mismatch from _within_tolerance().
> +
> +workfile=$SCRATCH_MNT/file
> +nfiles=32
> +wsize=4096
> +wcnt=1000
> +
> +write_file()
> +{
> +	idx=$1
> +
> +	$XFS_IO_PROG -f -s -c "pwrite -b 64k 0 50m" $workfile.$idx
> +}
> +
> +read_file()
> +{
> +	idx=$1
> +
> +	for ((cnt=0; cnt<$wcnt; cnt++)); do
> +		$XFS_IO_PROG -f -r -c "pread 0 28" $workfile.$idx
> +	done
> +}
> +
> +rm -f $workdir/file*
> +for ((n=0; n<$((nfiles)); n++)); do
> +	write_file $n > /dev/null 2>&1 &
> +	read_file $n > /dev/null 2>&1 &
> +done
> +wait
> +
> +for ((n=0; n<$nfiles; n++)); do
> +	count=$(_count_extents $workfile.$n)
> +	# Acceptible extent count range is 1-40
> +	_within_tolerance "file.$n extent count" $count 6 5 10 -v
> +done
> +
> +status=0
> +exit
> diff --git a/tests/xfs/1503.out b/tests/xfs/1503.out
> new file mode 100644
> index 000000000..1780b16df
> --- /dev/null
> +++ b/tests/xfs/1503.out
> @@ -0,0 +1,33 @@
> +QA output created by 1503
> +file.0 extent count is in range
> +file.1 extent count is in range
> +file.2 extent count is in range
> +file.3 extent count is in range
> +file.4 extent count is in range
> +file.5 extent count is in range
> +file.6 extent count is in range
> +file.7 extent count is in range
> +file.8 extent count is in range
> +file.9 extent count is in range
> +file.10 extent count is in range
> +file.11 extent count is in range
> +file.12 extent count is in range
> +file.13 extent count is in range
> +file.14 extent count is in range
> +file.15 extent count is in range
> +file.16 extent count is in range
> +file.17 extent count is in range
> +file.18 extent count is in range
> +file.19 extent count is in range
> +file.20 extent count is in range
> +file.21 extent count is in range
> +file.22 extent count is in range
> +file.23 extent count is in range
> +file.24 extent count is in range
> +file.25 extent count is in range
> +file.26 extent count is in range
> +file.27 extent count is in range
> +file.28 extent count is in range
> +file.29 extent count is in range
> +file.30 extent count is in range
> +file.31 extent count is in range
> -- 
> 2.45.2
> 
> 

