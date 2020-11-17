Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890C22B686D
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Nov 2020 16:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgKQPPu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Nov 2020 10:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728696AbgKQPPt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 10:15:49 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA57C0613CF;
        Tue, 17 Nov 2020 07:15:49 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id r6so610722pjd.1;
        Tue, 17 Nov 2020 07:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mtas/Vpm1oXbBIa+YdZnEL+2M5RfbwapeLojTxgBKeM=;
        b=iui2ZMxgh6mIKmDINFFAHLPWmPT2Mf6DnWiiojHMRuRIXB84ITt3CwG+3gYiHjlCSM
         o1YaWvz002EllP+75b94XCI5iIQjMesGB9GE2ZGRUNFHOvmJ75k5mYbLNC4kBHeYWxaJ
         2wECdXUFdpAgyOE0b4M0T9/63KceCEyOWqsBq3l2ZR1jH22SX+mr6UGT+RXFaVFBMaAt
         K/n/12ccGJU4o1rLfNqK1ZWIAbsHUpsup2liWP81wciqa1WCj6878o2kOGHv5pWmNOSH
         rVvWxCrljvumJ2iX+ON2JJSzVC3XCKT+DvkDcC6WhLZoTbAMOO1O1PhuhmuAuB0wJ6gC
         g6Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mtas/Vpm1oXbBIa+YdZnEL+2M5RfbwapeLojTxgBKeM=;
        b=Qmm4ONfYHiTYuIUwfQIOVQ+t1LlJGGvw7lHrCmzrIjae1TngKUzJsgUhD5XxKSv5YQ
         Ie2vMALnxrbrVH/9N3Se0xmM5KhY+rnOGHT7UNR0OQU2vMnXhWqrlXWPjTk/UzUexZqA
         Iu4vVySyrHQn+eSWgggvQRCtrzLcQbgtzvj2Sg61ZvfNoreEE5Qb0ziHUCP4fWvlu2n+
         TqbhVVqz4P8nsOBseGigRYLmXRv6fhEswKQDDzBAMjQmZc+228WNYxvkXzDqP/18QI5E
         u98avS7WcBFzshkg2/ziTvgmQKJ448qx+zVjtnsisC+kTGDrMNDtUpGNp2Fdiyva+/ZP
         Z1Zw==
X-Gm-Message-State: AOAM531ouhHQ6s7JJ8tkF+WTFobhvw6VrBKucrGPbNRYv98G4LTOxhHZ
        GjH6Blib2TCbLBg0S7vv4MU=
X-Google-Smtp-Source: ABdhPJyDmxIuO9yDh8Lm4/Ic3+/yobEoNl3WjBZJFtGC7H3C1m8ze0lzNa2r97LjFhGQThv2bmzgQg==
X-Received: by 2002:a17:90a:2ec8:: with SMTP id h8mr5186196pjs.51.1605626149036;
        Tue, 17 Nov 2020 07:15:49 -0800 (PST)
Received: from garuda.localnet ([122.179.49.210])
        by smtp.gmail.com with ESMTPSA id r6sm3380913pjd.39.2020.11.17.07.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 07:15:48 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/11] xfs: Check for extent overflow when writing to unwritten extent
Date:   Tue, 17 Nov 2020 20:45:45 +0530
Message-ID: <11999849.O8uJRllYaW@garuda>
In-Reply-To: <20201114003918.GH9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com> <20201113112704.28798-8-chandanrlinux@gmail.com> <20201114003918.GH9695@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 14 November 2020 6:09:18 AM IST Darrick J. Wong wrote:
> On Fri, Nov 13, 2020 at 04:56:59PM +0530, Chandan Babu R wrote:
> > This test verifies that XFS does not cause inode fork's extent count to
> > overflow when writing to an unwritten extent.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  tests/xfs/527     | 125 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/527.out |  13 +++++
> >  tests/xfs/group   |   1 +
> >  3 files changed, 139 insertions(+)
> >  create mode 100755 tests/xfs/527
> >  create mode 100644 tests/xfs/527.out
> > 
> > diff --git a/tests/xfs/527 b/tests/xfs/527
> > new file mode 100755
> > index 00000000..f040aee4
> > --- /dev/null
> > +++ b/tests/xfs/527
> > @@ -0,0 +1,125 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> > +#
> > +# FS QA Test 527
> > +#
> > +# Verify that XFS does not cause inode fork's extent count to overflow when
> > +# writing to an unwritten extent.
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
> > +	rm -f $tmp.*
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
> > +_require_scratch
> > +_require_xfs_debug
> > +_require_xfs_io_command "falloc"
> > +_require_xfs_io_error_injection "reduce_max_iextents"
> > +
> > +buffered_write_to_unwritten_extent()
> 
> This is nearly the same as the directio write test; could you combine
> them into a single function so we have fewer functions to maintain?

Ok. I will do that.

> 
> --D
> 
> > +{
> > +	echo "* Buffered write to unwritten extent"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> > +
> > +	bsize=$(_get_block_size $SCRATCH_MNT)
> > +
> > +	testfile=${SCRATCH_MNT}/testfile
> > +
> > +	nr_blks=15
> > +
> > +	echo "Fallocate $nr_blks blocks"
> > +	xfs_io -f -c "falloc 0 $((nr_blks * bsize))" $testfile >> $seqres.full
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c "inject reduce_max_iextents" $SCRATCH_MNT
> > +
> > +	echo "Buffered write to every other block of fallocated space"
> > +	for i in $(seq 1 2 $((nr_blks - 1))); do
> > +		xfs_io -f -c "pwrite $((i * bsize)) $bsize" -c fsync $testfile \
> > +		       >> $seqres.full 2>&1
> > +		[[ $? != 0 ]] && break
> > +	done
> > +
> > +	testino=$(stat -c "%i" $testfile)
> > +
> > +	_scratch_unmount >> $seqres.full
> > +
> > +	echo "Verify \$testfile's extent count"
> > +
> > +	nextents=$(_scratch_get_iext_count $testino data || \
> > +			_fail "Unable to obtain inode fork's extent count")
> > +	if (( $nextents > 10 )); then
> > +		echo "Extent count overflow check failed: nextents = $nextents"
> > +	fi
> > +}
> > +
> > +direct_write_to_unwritten_extent()
> > +{
> > +	echo "* Direct I/O write to unwritten extent"
> > +
> > +	echo "Format and mount fs"
> > +	_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full
> > +	_scratch_mount >> $seqres.full
> > +
> > +	bsize=$(_get_block_size $SCRATCH_MNT)
> > +
> > +	testfile=${SCRATCH_MNT}/testfile
> > +
> > +	nr_blks=15
> > +
> > +	echo "Fallocate $nr_blks blocks"
> > +	xfs_io -f -c "falloc 0 $((nr_blks * bsize))" $testfile >> $seqres.full
> > +
> > +	echo "Inject reduce_max_iextents error tag"
> > +	xfs_io -x -c "inject reduce_max_iextents" $SCRATCH_MNT
> > +
> > +	echo "Direct I/O write to every other block of fallocated space"
> > +	for i in $(seq 1 2 $((nr_blks - 1))); do
> > +		xfs_io -f -d -c "pwrite $((i * bsize)) $bsize" $testfile \
> > +		       >> $seqres.full 2>&1
> > +		[[ $? != 0 ]] && break
> > +	done
> > +
> > +	testino=$(stat -c "%i" $testfile)
> > +
> > +	_scratch_unmount >> $seqres.full
> > +
> > +	echo "Verify \$testfile's extent count"
> > +
> > +	nextents=$(_scratch_get_iext_count $testino data || \
> > +			_fail "Unable to obtain inode fork's extent count")
> > +	if (( $nextents > 10 )); then
> > +		echo "Extent count overflow check failed: nextents = $nextents"
> > +	fi
> > +}
> > +
> > +buffered_write_to_unwritten_extent
> > +direct_write_to_unwritten_extent
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/527.out b/tests/xfs/527.out
> > new file mode 100644
> > index 00000000..6aa5e9ed
> > --- /dev/null
> > +++ b/tests/xfs/527.out
> > @@ -0,0 +1,13 @@
> > +QA output created by 527
> > +* Buffered write to unwritten extent
> > +Format and mount fs
> > +Fallocate 15 blocks
> > +Inject reduce_max_iextents error tag
> > +Buffered write to every other block of fallocated space
> > +Verify $testfile's extent count
> > +* Direct I/O write to unwritten extent
> > +Format and mount fs
> > +Fallocate 15 blocks
> > +Inject reduce_max_iextents error tag
> > +Direct I/O write to every other block of fallocated space
> > +Verify $testfile's extent count
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index d089797b..627813fe 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -524,3 +524,4 @@
> >  524 auto quick punch zero insert collapse
> >  525 auto quick attr
> >  526 auto quick dir hardlink symlink
> > +527 auto quick
> 


-- 
chandan



