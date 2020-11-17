Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA612B6745
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Nov 2020 15:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgKQOWL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Nov 2020 09:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728746AbgKQOWK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 09:22:10 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A82CC0617A7;
        Tue, 17 Nov 2020 06:22:10 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id oc3so559949pjb.4;
        Tue, 17 Nov 2020 06:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+B+FaUhWVxVP3jP/Ezi3OhRiyB5nnCw1hs9LItEj2Lo=;
        b=Daul4trubwUOpk4pxuNpK+GPBvw2UduilAxNAmTQWcHXVlZf9QPB0firOt5H9r1Qby
         IQxNYFa9ROMINilIPhFmdlXJq8SLPDCK0mIOtmZRWVa+NZgxrTdrNJIUPNmRLsG+3+L9
         WHuCSrRoh0++NDNqiw3xuLNPIJWMbHzws0S57SDxueif9aeLiG3kDecMqPkragZWqX2l
         Hya91ut2sdvfAUzVT587cvslYiWKme+LHGag/+C4t8mNDdYGsD5vvPJrUFUW2XvWcOPB
         AhC0JrOmTnkksJj951J1i1YTvDpJB/U8jl5/nYTZyfF8C55feY4m5hA/4vlzfkMIH4Pa
         LXgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+B+FaUhWVxVP3jP/Ezi3OhRiyB5nnCw1hs9LItEj2Lo=;
        b=RR9wI/YAKZ7oYyw0W/C5rQIwXUlWi9+r3nEUlzrQh2PunWr0+xoDvR7iQI7trCvjG7
         bWOrbQsLK05jEuVO79FoFbiWU7CLCNRYW+3NpyzlRGjo0UgtLAEMlli6pnIATKYNrpRv
         Ij12P/IQKSsq8CJJ5mWRT/gvV1cNdMJrzivf0sAcS6g+vGs16n+u+mqj5KvLYJAeHUP9
         H/iycQrI/MEw+lLoYoLNf0O0WA1ucQPVtyRwEiVlQMFyDlbtrq7V39oXlbyqW/K06+fj
         OLr90HG+PAu5eU/aQqQTWn6b8uXW+1CEryTp94XPxrxr4M+dNWy8ppquklGgw+seEhj7
         CkHQ==
X-Gm-Message-State: AOAM533faASF4nkfPJ5yWnl2fpCXo7qncruplZuRmuCmeD3ieoUQmVbJ
        iZ79Sh8/Oau4EvNGIVLe7GY=
X-Google-Smtp-Source: ABdhPJxHpsEkZNO9d6J0zM2RRw7sw34UfsX8nJ3SWAARCS+bcgIa6XwTqgsVNZT9daTAblVM0DbWlw==
X-Received: by 2002:a17:90a:ce88:: with SMTP id g8mr4765685pju.75.1605622929782;
        Tue, 17 Nov 2020 06:22:09 -0800 (PST)
Received: from garuda.localnet ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id q200sm21952812pfq.95.2020.11.17.06.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 06:22:08 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs: Check for extent overflow when trivally adding a new extent
Date:   Tue, 17 Nov 2020 19:52:06 +0530
Message-ID: <11823615.CjnnEh1UFN@garuda>
In-Reply-To: <20201114001813.GC9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com> <20201113112704.28798-4-chandanrlinux@gmail.com> <20201114001813.GC9695@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 14 November 2020 5:48:13 AM IST Darrick J. Wong wrote:
> > Subject: xfs: Check for extent overflow when trivally adding a new extent
> 
> Why does patch 3 have the same subject as patch 2?  This confused
> my quiltish scripts. :(

Sorry, The tests in patch 2 and 3 test the functionality associated with
XFS_IEXT_ADD_NOSPLIT_CNT. I had decided to separate these tests from those in
patch 2 since the tests here required creating an RT volume. I will fix the
subject line before posting the next version.

> 
> On Fri, Nov 13, 2020 at 04:56:55PM +0530, Chandan Babu R wrote:
> > Verify that XFS does not cause inode fork's extent count to overflow
> > when adding a single extent while there's no possibility of splitting an
> > existing mapping (limited to realtime files only).
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  tests/xfs/523     | 176 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/523.out |  18 +++++
> >  tests/xfs/group   |   1 +
> >  3 files changed, 195 insertions(+)
> >  create mode 100755 tests/xfs/523
> >  create mode 100644 tests/xfs/523.out
> > 
> > diff --git a/tests/xfs/523 b/tests/xfs/523
> > new file mode 100755
> > index 00000000..4f5b3584
> > --- /dev/null
> > +++ b/tests/xfs/523
> > @@ -0,0 +1,176 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> > +#
> > +# FS QA Test 523
> > +#
> > +# Verify that XFS does not cause inode fork's extent count to overflow when
> > +# adding a single extent while there's no possibility of splitting an existing
> > +# mapping (limited to realtime files only).
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	_scratch_unmount >> $seqres.full 2>&1
> > +	test -e "$rtdev" && losetup -d $rtdev >> $seqres.full 2>&1
> > +	rm -f $tmp.* $TEST_DIR/$seq.rtvol
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/inject
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +_supported_fs xfs
> > +_require_test
> > +_require_xfs_debug
> > +_require_test_program "punch-alternating"
> > +_require_xfs_io_error_injection "reduce_max_iextents"
> > +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
> > +_require_scratch_nocheck
> > +
> > +grow_rtinodes()
> > +{
> > +	echo "* Test extending rt inodes"
> > +
> > +	_scratch_mkfs | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
> > +	. $tmp.mkfs
> > +
> > +	echo "Create fake rt volume"
> > +	nr_bitmap_blks=25
> > +	nr_bits=$((nr_bitmap_blks * dbsize * 8))
> > +	rtextsz=$dbsize
> > +	rtdevsz=$((nr_bits * rtextsz))
> > +	truncate -s $rtdevsz $TEST_DIR/$seq.rtvol
> > +	rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
> > +
> > +	echo "Format and mount rt volume"
> > +	export USE_EXTERNAL=yes
> > +	export SCRATCH_RTDEV=$rtdev
> 
> I'm frankly wondering if it's time to just turn this into a
> _scratch_synthesize_rtvol helper or something.

Ok. I will write the helper and invoke it from appropriate places in xfstests.

> 
> > +	_scratch_mkfs -d size=$((1024 * 1024 * 1024)) \
> > +		      -r size=2M,extsize=${rtextsz} >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> > +
> > +	testfile=$SCRATCH_MNT/testfile
> > +
> > +	echo "Consume free space"
> > +	dd if=/dev/zero of=${testfile} bs=${dbsize} >> $seqres.full 2>&1
> 
> Can you accomplish this with fallocate?  Or better yet _fill_fs()?

Hmm. _fill_fs() would be a better candidate. I can then invoke
punch-alternating on all the files in the directory (passed as 2nd argument to
_fill_fs()) to create a fragmented filesystem. Thanks for the suggestion.

> 
> > +	sync
> > +
> > +	echo "Create fragmented filesystem"
> > +	$here/src/punch-alternating $testfile >> $seqres.full
> > +	sync
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> > +
> > +	echo "Inject bmap_alloc_minlen_extent error tag"
> > +	xfs_io -x -c 'inject bmap_alloc_minlen_extent' $SCRATCH_MNT
> > +
> > +	echo "Grow realtime volume"
> > +	xfs_growfs -r $SCRATCH_MNT >> $seqres.full 2>&1
> 
> $XFS_GROWFS_PROG, not xfs_growfs

Ok. I will fix this.

> 
> > +	if [[ $? == 0 ]]; then
> > +		echo "Growfs succeeded; should have failed."
> > +		exit 1
> > +	fi
> > +
> > +	_scratch_unmount >> $seqres.full
> > +
> > +	echo "Verify rbmino's and rsumino's extent count"
> > +	for rtino in rbmino rsumino; do
> > +		ino=$(_scratch_xfs_db -c sb -c "print $rtino")
> > +		ino=${ino##${rtino} = }
> > +		echo "$rtino = $ino" >> $seqres.full
> > +
> > +		nextents=$(_scratch_get_iext_count $ino data || \
> > +				_fail "Unable to obtain inode fork's extent count")
> 
> Aha, you use this helper for the rt inodes too.  Ok, disregard my
> comments for patch 1.
> 
> > +		if (( $nextents > 10 )); then
> > +			echo "Extent count overflow check failed: nextents = $nextents"
> > +			exit 1
> > +		fi
> > +	done
> > +
> > +	echo "Check filesystem"
> > +	_check_xfs_filesystem $SCRATCH_DEV none $rtdev
> > +
> > +	losetup -d $rtdev
> > +	rm -f $TEST_DIR/$seq.rtvol
> > +
> > +	export USE_EXTERNAL=""
> > +	export SCRATCH_RTDEV=""
> > +}
> > +
> > +rtfile_extend()
> > +{
> > +	echo "* Test extending an rt file"
> > +
> > +	_scratch_mkfs | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
> > +	. $tmp.mkfs
> 
> Are these separate functionality tests?  If so, should they be in
> separate test files?

Actually I will drop the rtfile_extend() test functionality since it takes the
same code path as the direct IO file operation tested in patch 2.

> 
> > +
> > +	echo "Create fake rt volume"
> > +	nr_blks=$((15 * 2))
> > +	rtextsz=$dbsize
> > +	rtdevsz=$((2 * nr_blks * rtextsz))
> > +	truncate -s $rtdevsz $TEST_DIR/$seq.rtvol
> > +	rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
> > +
> > +	echo "Format and mount rt volume"
> > +	export USE_EXTERNAL=yes
> > +	export SCRATCH_RTDEV=$rtdev
> > +	_scratch_mkfs -d size=$((1024 * 1024 * 1024)) \
> > +		      -r size=$rtdevsz >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> 
> $XFS_IO_PROG, not xfs_io.

Ok. I will fix this in all the test scripts in this patchset.

> 
> --D
> 
> > +
> > +	echo "Create fragmented file on rt volume"
> > +	testfile=$SCRATCH_MNT/testfile
> > +	for i in $(seq 0 2 $((nr_blks - 1))); do
> > +		xfs_io -Rf -c "pwrite $((i * dbsize)) $dbsize" -c fsync \
> > +		       $testfile >> $seqres.full 2>&1
> > +		[[ $? != 0 ]] && break
> > +	done
> > +
> > +	testino=$(stat -c "%i" $testfile)
> > +
> > +	_scratch_unmount >> $seqres.full
> > +
> > +	echo "Verify \$testfile's extent count"
> > +	nextents=$(_scratch_get_iext_count $testino data || \
> > +			_fail "Unable to obtain inode fork's extent count")
> > +	if (( $nextents > 10 )); then
> > +		echo "Extent count overflow check failed: nextents = $nextents"
> > +		exit 1
> > +	fi
> > +
> > +	echo "Check filesystem"
> > +	_check_xfs_filesystem $SCRATCH_DEV none $rtdev
> > +
> > +	losetup -d $rtdev
> > +	rm -f $TEST_DIR/$seq.rtvol
> > +
> > +	export USE_EXTERNAL=""
> > +	export SCRATCH_RTDEV=""
> > +}
> > +
> > +grow_rtinodes
> > +rtfile_extend
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/523.out b/tests/xfs/523.out
> > new file mode 100644
> > index 00000000..16b4e0ad
> > --- /dev/null
> > +++ b/tests/xfs/523.out
> > @@ -0,0 +1,18 @@
> > +QA output created by 523
> > +* Test extending rt inodes
> > +Create fake rt volume
> > +Format and mount rt volume
> > +Consume free space
> > +Create fragmented filesystem
> > +Inject reduce_max_iextents error tag
> > +Inject bmap_alloc_minlen_extent error tag
> > +Grow realtime volume
> > +Verify rbmino's and rsumino's extent count
> > +Check filesystem
> > +* Test extending an rt file
> > +Create fake rt volume
> > +Format and mount rt volume
> > +Inject reduce_max_iextents error tag
> > +Create fragmented file on rt volume
> > +Verify $testfile's extent count
> > +Check filesystem
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 1831f0b5..018c70ef 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -520,3 +520,4 @@
> >  520 auto quick reflink
> >  521 auto quick realtime growfs
> >  522 auto quick quota
> > +523 auto quick realtime growfs
> 


-- 
chandan



