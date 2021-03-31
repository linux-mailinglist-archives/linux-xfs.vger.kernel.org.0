Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C468034569A
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Mar 2021 05:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhCWEPz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Mar 2021 00:15:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhCWEPd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 00:15:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBD8F619AD;
        Tue, 23 Mar 2021 04:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616472933;
        bh=j+WSoMA+MV49RUOb/SgC+Mro94JV8/HEf6DCTrD3wwE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uB45lOBF1TIDKD5wuLDQl3zl+DkAACSF7/wcSCDV2s4POuirjiEXpIA8vXUpbjdY8
         2Oh9jev/SsIwaLU2BTGJ5pNidNojW14VNraeE30nKEHEykIFY8z4Q2q/jZgd3wAry9
         khfTgNd2W0rJ9q12YH5LJhwqNp2D878tOgJ0IpPMj7xMVT017wgvh2Bz90Mve3bcrW
         VeH+F2Jnj34nAnMyZE+osGbwIDcOqCv7QQZqx3m4CneESV3apMMqQM0syuYF2pLe9J
         bAJxRgrlpsD7RjUYnhn6V1nSCh1LmRnK3jTsN+cYa51yR6gplGmN5amIFhPKcy1nD3
         AnQ0vgINpYY7A==
Date:   Mon, 22 Mar 2021 21:15:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 03/10] xfs: test rtalloc alignment and math errors
Message-ID: <20210323041532.GI1670408@magnolia>
References: <161526480371.1214319.3263690953532787783.stgit@magnolia>
 <161526482015.1214319.6227125326960502859.stgit@magnolia>
 <87mtvaceaf.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtvaceaf.fsf@garuda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 11, 2021 at 01:28:32PM +0530, Chandan Babu R wrote:
> On 09 Mar 2021 at 10:10, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Add a couple of regression tests for "xfs: make sure the rt allocator
> > doesn't run off the end" and "xfs: ensure that fpunch, fcollapse, and
> > finsert operations are aligned to rt extent size".
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/759     |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/759.out |    2 +
> >  tests/xfs/760     |   68 ++++++++++++++++++++++++++++++++++++
> >  tests/xfs/760.out |    9 +++++
> >  tests/xfs/group   |    2 +
> >  5 files changed, 181 insertions(+)
> >  create mode 100755 tests/xfs/759
> >  create mode 100644 tests/xfs/759.out
> >  create mode 100755 tests/xfs/760
> >  create mode 100644 tests/xfs/760.out
> >
> >
> > diff --git a/tests/xfs/759 b/tests/xfs/759
> > new file mode 100755
> > index 00000000..8558fe30
> > --- /dev/null
> > +++ b/tests/xfs/759
> > @@ -0,0 +1,100 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 759
> > +#
> > +# This is a regression test for commit 2a6ca4baed62 ("xfs: make sure the rt
> > +# allocator doesn't run off the end") which fixes an overflow error in the
> > +# _near realtime allocator.  If the rt bitmap ends exactly at the end of a
> > +# block and the number of rt extents is large enough to allow an allocation
> > +# request larger than the maximum extent size, it's possible that during a
> > +# large allocation request, the allocator will fail to constrain maxlen on the
> > +# second run through the loop, and the rt bitmap range check will run right off
> > +# the end of the rtbitmap file.  When this happens, xfs triggers a verifier
> > +# error and returns EFSCORRUPTED.
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
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
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch
> > +_require_realtime
> > +_require_test_program "punch-alternating"
> > +
> > +rm -f $seqres.full
> > +
> > +# Format filesystem to get the block size
> > +_scratch_mkfs > $seqres.full
> > +_scratch_mount >> $seqres.full
> > +
> > +blksz=$(_get_block_size $SCRATCH_MNT)
> > +rextsize=$($XFS_INFO_PROG $SCRATCH_MNT | grep realtime.*extsz | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
> > +rextblks=$((rextsize / blksz))
> > +
> > +echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
> > +
> > +_scratch_unmount
> > +
> > +# Format filesystem with a realtime volume whose size fits the following:
> > +# 1. Longer than (XFS MAXEXTLEN * blocksize) bytes.
> 
> Shouldn't the multiplier be RT extent size rather than FS block size?

No, because reproducing the bug requires a large enough allocation
request that we can't fit it all in a single data fork extent mapping
and have to call back into the allocator to get more space.  bmbt
mappings are always in units of fsblocks, not rt extents.

> > +# 2. Exactly a multiple of (NBBY * blksz * rextsize) bytes.
> 
> i.e The bits in one rt bitmap block map (NBBY * blksz * rextsize) bytes of an
> rt device. Hence to have the bitmap end at a fs block boundary the
> corresponding rt device size should be a multiple of this product. Is my
> understanding correct?

Right.

(I swear I responded to this but who knows these days...)

--D

> 
> > +
> > +rtsize1=$((2097151 * blksz))
> > +rtsize2=$((8 * blksz * rextsize))
> > +rtsize=$(( $(blockdev --getsz $SCRATCH_RTDEV) * 512 ))
> > +
> > +echo "rtsize1 $rtsize1 rtsize2 $rtsize2 rtsize $rtsize" >> $seqres.full
> > +
> > +test $rtsize -gt $rtsize1 || \
> > +	_notrun "scratch rt device too small, need $rtsize1 bytes"
> > +test $rtsize -gt $rtsize2 || \
> > +	_notrun "scratch rt device too small, need $rtsize2 bytes"
> > +
> > +rtsize=$((rtsize - (rtsize % rtsize2)))
> > +
> 
> --
> chandan
