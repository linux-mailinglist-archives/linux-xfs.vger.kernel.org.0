Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389104E43EF
	for <lists+linux-xfs@lfdr.de>; Tue, 22 Mar 2022 17:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbiCVQLc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 22 Mar 2022 12:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236170AbiCVQLb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 12:11:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E244E0D6;
        Tue, 22 Mar 2022 09:10:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47485B81CD8;
        Tue, 22 Mar 2022 16:10:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4070C340EC;
        Tue, 22 Mar 2022 16:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647965400;
        bh=BMrZx6anWPfNRof+TaWHL4ka4caW61TTbB+ssZrMtJ4=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=WOndqxzKW3mQTmWPYoCaoisZ8g7QqGqvn+k6MaT97E7Itz8HmWpV1wFkYi+rxMFgf
         /cJzGHdkDgeXceSAdN31w2S/yxCJOBZw7Hx1hQY2tW4LAS4tTbJuFr9WPQyhyIyY9y
         NacqGyVXFoqAM2pswQSPIgt2oRLGgvyYp2cmOId2n6+91T0sxvxNQZkiZ0o1k9b66G
         x6kgd2hiyPVOXaCA99tBqE0jcHIXpQYWkWoBaqhy5cfKw9lshTSIxX+YQPSXV4HDhf
         hvR1Ku5bgvEMlPP4ZPCKBATucsN1uiyfOaDyy2iOljVU8rqgxGgESep/M7JRZCaAjX
         LHF8qqSMXwPrw==
Date:   Tue, 22 Mar 2022 09:10:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/420: fix occasional test failures due to
 pagecache readahead
Message-ID: <20220322161000.GN8200@magnolia>
References: <164740140348.3371628.12967562090320741592.stgit@magnolia>
 <164740142033.3371628.11850774504699213977.stgit@magnolia>
 <20220322051354.yys6zipuxjfvkkgn@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322051354.yys6zipuxjfvkkgn@zlang-mailbox>
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 22, 2022 at 01:13:54PM +0800, Zorro Lang wrote:
> On Tue, Mar 15, 2022 at 08:30:20PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Every now and then, this test fails with this golden output:
> > 
> > --- xfs/420.out
> > +++ xfs/420.out.bad
> > @@ -29,7 +29,7 @@
> >  Whence Result
> >  DATA   0
> >  HOLE   131072
> > -DATA   196608
> > +DATA   192512
> >  HOLE   262144
> >  Compare files
> >  c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-420/file1
> 
> Looks like this part easy to cause `git am` misunderstanding[1], Hmm...
> any method to deal with that?

LOL.  Um.  I guess I'll edit the commit message to omit the diff header.

--D

> [1]
> Applying: xfs/420: fix occasional test failures due to pagecache readahead
> error: 420.out: does not exist in index
> Patch failed at 0001 xfs/420: fix occasional test failures due to pagecache readahead
> hint: Use 'git am --show-current-patch=diff' to see the failed patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
> 
> > 
> > Curiously, the file checksums always match, and it's not *forbidden* for
> > the page cache to have a page backing an unwritten extent that hasn't
> > been written.
> > 
> > The condition that this test cares about is that block 3 (192k-256k) are
> > reported by SEEK_DATA as data even if the data fork has a hole and the
> > COW fork has an unwritten extent.  Matthew Wilcox thinks this is a side
> > effect of readahead.
> > 
> > To fix this occasional false failure, call SEEK_DATA and SEEK_HOLE only
> > on the offsets that we care about.
> > 
> > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/420 |   33 +++++++++++++++++++++------------
> >  1 file changed, 21 insertions(+), 12 deletions(-)
> > 
> > 
> > diff --git a/tests/xfs/420 b/tests/xfs/420
> > index 12b17588..d38772c9 100755
> > --- a/tests/xfs/420
> > +++ b/tests/xfs/420
> > @@ -50,6 +50,24 @@ _scratch_mount >> $seqres.full 2>&1
> >  testdir=$SCRATCH_MNT/test-$seq
> >  mkdir $testdir
> >  
> > +# pagecache readahead can sometimes cause extra pages to be inserted into the
> > +# file mapping where we have an unwritten extent in the COW fork.  Call lseek
> > +# on each $blksz offset that interests us (as opposed to the whole file) so
> > +# that these extra pages are not disclosed.
> > +#
> > +# The important thing we're testing is that SEEK_DATA reports block 3 as data
> > +# when the COW fork has an unwritten mapping and the data fork has a hole.
> > +exercise_lseek() {
> > +	echo "Seek holes and data in file1"
> > +	$XFS_IO_PROG -c "seek -d 0" $testdir/file1
> > +	$XFS_IO_PROG -c "seek -h $((2 * blksz))" $testdir/file1 | sed -e '/Whence/d'
> > +	echo "Seek holes and data in file2"
> > +	$XFS_IO_PROG -c "seek -d 0" $testdir/file2
> > +	$XFS_IO_PROG -c "seek -h $((2 * blksz))" $testdir/file2 | sed -e '/Whence/d'
> > +	$XFS_IO_PROG -c "seek -d $((3 * blksz))" $testdir/file2 | sed -e '/Whence/d'
> > +	$XFS_IO_PROG -c "seek -h $((4 * blksz))" $testdir/file2 | sed -e '/Whence/d'
> > +}
> > +
> >  blksz=65536
> >  nr=8
> >  filesize=$((blksz * nr))
> > @@ -83,10 +101,7 @@ $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
> >  $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
> >  $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
> >  
> > -echo "Seek holes and data in file1"
> > -$XFS_IO_PROG -c "seek -a -r 0" $testdir/file1
> > -echo "Seek holes and data in file2"
> > -$XFS_IO_PROG -c "seek -a -r 0" $testdir/file2
> > +exercise_lseek
> >  
> >  echo "Compare files"
> >  md5sum $testdir/file1 | _filter_scratch
> > @@ -102,10 +117,7 @@ $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
> >  $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
> >  $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
> >  
> > -echo "Seek holes and data in file1"
> > -$XFS_IO_PROG -c "seek -a -r 0" $testdir/file1
> > -echo "Seek holes and data in file2"
> > -$XFS_IO_PROG -c "seek -a -r 0" $testdir/file2
> > +exercise_lseek
> >  
> >  echo "Compare files"
> >  md5sum $testdir/file1 | _filter_scratch
> > @@ -121,10 +133,7 @@ $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
> >  $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
> >  $XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
> >  
> > -echo "Seek holes and data in file1"
> > -$XFS_IO_PROG -c "seek -a -r 0" $testdir/file1
> > -echo "Seek holes and data in file2"
> > -$XFS_IO_PROG -c "seek -a -r 0" $testdir/file2
> > +exercise_lseek
> >  
> >  echo "Compare files"
> >  md5sum $testdir/file1 | _filter_scratch
> > 
> 
