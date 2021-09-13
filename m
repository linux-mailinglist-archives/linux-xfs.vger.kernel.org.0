Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D63E409BA7
	for <lists+linux-xfs@lfdr.de>; Mon, 13 Sep 2021 20:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346243AbhIMSDe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 Sep 2021 14:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235547AbhIMSD2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 14:03:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B1FB60F3A;
        Mon, 13 Sep 2021 18:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631556132;
        bh=CXGrSYrvXbSjAhBZz/ioaY92Lqtf3GiV+Nw/n7acYkk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lcHHxFzVsxzw7SbjxuJdZ3hkGrH0zIKCmVCpbkqxhB/i8ruN1obKkw1ytJpi1gVsf
         p4lNE99HpK4VFFAiMI601bMiZ4K4VV8b3LzZqo2knZMbPxlWT/MfISZdrPKJMm3tBn
         FermF35RGtX9IHYsqs+68qfAsFjfv2YIGt2ROUMK8prD4ROYJvRYks39J/IqB+bUH+
         9AR9ageRdjcuupf2RaLPRwe196B9iUAF08d0LKr4GEVgBT589UvrHcHYqYxhkJ9Da3
         qLKBj3+tWm5tkCZEL0NtbqkO53kgYhNir+TbaoMPzuLlNq/w0gTPfl/wpOaGgYHtHx
         MKdic1hNJulTg==
Date:   Mon, 13 Sep 2021 11:02:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: test adding realtime sections to filesystem
Message-ID: <20210913180211.GD638503@magnolia>
References: <163045508495.769915.4859353445119566326.stgit@magnolia>
 <163045510141.769915.9334618845276733225.stgit@magnolia>
 <YTTWbQiNR8Dm5iC/@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTTWbQiNR8Dm5iC/@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 05, 2021 at 10:38:37PM +0800, Eryu Guan wrote:
> On Tue, Aug 31, 2021 at 05:11:41PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add a functional test to exercise using "xfs_growfs -e XXX -r" to add a
> > realtime section to a filesystem while changing the extent size.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/779     |  112 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/779.out |    2 +
> >  2 files changed, 114 insertions(+)
> >  create mode 100755 tests/xfs/779
> >  create mode 100644 tests/xfs/779.out
> > 
> > 
> > diff --git a/tests/xfs/779 b/tests/xfs/779
> > new file mode 100755
> > index 00000000..f064879c
> > --- /dev/null
> > +++ b/tests/xfs/779
> > @@ -0,0 +1,112 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 779
> > +#
> > +# Test for xfs_growfs to make sure that we can add a realtime device and set
> > +# its extent size hint at the same time.  This also checks for the presence of
> > +# these patches:
> > +#
> > +#	xfs: improve FSGROWFSRT precondition checking
> > +#	xfs: fix an integer overflow error in xfs_growfs_rt
> > +#	xfs: correct the narrative around misaligned rtinherit/extszinherit dirs
> > +#	xfs: don't expose misaligned extszinherit hints to userspace
> 
> The patches are now merged, include their commit ids as well?

Oops, sorry, this one slipped through when I tried to correct all that. :(

> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick realtime growfs
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> 
> _supported_fs xfs

Fixed, thanks.

> > +_require_realtime
> > +_require_scratch
> > +
> > +# Format scratch fs with no realtime section.
> > +SCRATCH_RTDEV="" _scratch_mkfs | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
> > +_scratch_mount
> > +
> > +# Check that there's no realtime section.
> > +source $tmp.mkfs
> > +test $rtblocks -eq 0 || echo "expected 0 rtblocks, got $rtblocks"
> > +
> > +# Compute a new rt extent size and a separate rt extent size hint to exercise
> > +# the code that ignores hints that aren't a multiple of the extent size.
> > +XFS_MAX_RTEXTSIZE=$((1024 * 1024 * 1024))
> > +new_rtextsz=$((rtextsz + dbsize))
> > +if [ $new_rtextsz -gt $XFS_MAX_RTEXTSIZE ]; then
> > +	new_rtextsz=$((rtextsz - dbsize))
> > +fi
> > +new_rtextsz_blocks=$(( new_rtextsz / dbsize ))
> > +
> > +new_extszhint=$((rtextsz * 2))
> > +if [ $new_extszhint -eq $new_rtextsz ]; then
> > +	new_extszhint=$((rtextsz * 3))
> > +fi
> > +
> > +# Set the inheritable extent size hint and rt status.
> > +$XFS_IO_PROG -c 'chattr +t' -c "extsize $new_extszhint" $SCRATCH_MNT
> > +
> > +# Check that the hint was set correctly
> > +after_extszhint=$($XFS_IO_PROG -c 'stat' $SCRATCH_MNT | \
> > +	grep 'fsxattr.extsize' | cut -d ' ' -f 3)
> > +test $after_extszhint -eq $new_extszhint || \
> > +	echo "expected extszhint $new_extszhint, got $after_extszhint"
> > +
> > +# Add a realtime section and change the extent size.
> > +echo $XFS_GROWFS_PROG -e $new_rtextsz_blocks -r $SCRATCH_MNT >> $seqres.full
> > +$XFS_GROWFS_PROG -e $new_rtextsz_blocks -r $SCRATCH_MNT >> $seqres.full 2> $tmp.growfs
> > +res=$?
> > +cat $tmp.growfs
> > +
> > +# If the growfs failed, skip the post-test check because the scratch fs does
> > +# not have SCRATCH_RTDEV configured.  If the kernel didn't support adding the
> > +# rt volume, skip everything else.
> > +if [ $res -ne 0 ]; then
> > +	rm -f ${RESULT_DIR}/require_scratch
> > +	if grep -q "Operation not supported" $tmp.growfs; then
> > +		_notrun "growfs not supported on rt volume"
> > +	fi
> > +fi
> > +
> > +# Now that the root directory's extsize hint is no longer aligned to the rt
> > +# extent size, check that we don't report it to userspace any more.
> > +grow_extszhint=$($XFS_IO_PROG -c 'stat' $SCRATCH_MNT | \
> > +	grep 'fsxattr.extsize' | cut -d ' ' -f 3)
> > +test $grow_extszhint -eq 0 || \
> > +	echo "expected post-grow extszhint 0, got $grow_extszhint"
> > +
> > +# Check that we now have rt extents.
> > +rtextents=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | \
> > +	grep 'geom.rtextents' | cut -d ' ' -f 3)
> > +test $rtextents -gt 0 || echo "expected rtextents > 0"
> > +
> > +# Check the new rt extent size.
> > +after_rtextsz_blocks=$($XFS_IO_PROG -c 'statfs' $SCRATCH_MNT | \
> > +	grep 'geom.rtextsize' | cut -d ' ' -f 3)
> > +test $after_rtextsz_blocks -eq $new_rtextsz_blocks || \
> > +	echo "expected rtextsize $new_rtextsz_blocks, got $after_rtextsz_blocks"
> > +
> > +# Create a new realtime file to prove that we can.
> > +echo moo > $SCRATCH_MNT/a
> > +sync
> 
> A global sync is a bit heavy, fsync the file or syncfs $SCRATCH_MNT ?

Ok, I'll make that "sync -f $SCRATCH_MNT".

--D

> Thanks,
> Eryu
> 
> > +$XFS_IO_PROG -c 'lsattr -v' $SCRATCH_MNT/a | \
> > +	cut -d ' ' -f 1 | \
> > +	grep -q realtime || \
> > +	echo "$SCRATCH_MNT/a is not a realtime file?"
> > +
> > +# Check that the root directory's hint (which was aligned before the grow and
> > +# misaligned after) did not propagate to the new realtime file.
> > +file_extszhint=$($XFS_IO_PROG -c 'stat' $SCRATCH_MNT/a | \
> > +	grep 'fsxattr.extsize' | cut -d ' ' -f 3)
> > +test $file_extszhint -eq 0 || \
> > +	echo "expected file extszhint 0, got $file_extszhint"
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/779.out b/tests/xfs/779.out
> > new file mode 100644
> > index 00000000..1f79fae2
> > --- /dev/null
> > +++ b/tests/xfs/779.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 779
> > +Silence is golden
