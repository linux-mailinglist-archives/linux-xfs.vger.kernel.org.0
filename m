Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A2A56BC3A
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Jul 2022 17:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238472AbiGHPIP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Jul 2022 11:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237977AbiGHPIP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jul 2022 11:08:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2038361D4E;
        Fri,  8 Jul 2022 08:08:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA9D760B34;
        Fri,  8 Jul 2022 15:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0DAC341C6;
        Fri,  8 Jul 2022 15:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657292893;
        bh=upStwKqoYbxAHZuaC5eK6/9bgoaMjoYWTR1yh4xO3XM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qUq45e5A6Wa4g6AKoNhfc2U4ImiIbLWerQEungxeQjCTzye6JKwFCFr9OZcENkSmW
         mK3pBJLqfX3+DrBZme7SA6DSYUP4v3UzJWm2yRGQKtTkWWHgBW/JPlvfNq/9GSiZUD
         khFoQvZPaLqw+7kLgInS43uZkOt1XZH13d5OVWEwJqx3Mq2Avq/VCLNwAfIgv0p5kI
         rrtxDUbbjFLKo/zpWo1MWMCNDS2gT4W94iNX2SsRWPAOCy3nLtjVhvgxxyJkMJ5bCp
         sjC1u6aaFQCZmqkPhTSh+W/rsC1rCNDF7pgewF5xons8T+xJCRjdRHOCKEeWmTYHoL
         eHtx3VQ0+QTfA==
Date:   Fri, 8 Jul 2022 08:08:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: make sure that we handle empty xattr leaf
 blocks ok
Message-ID: <YshIXAFjJlym6SXV@magnolia>
References: <165705854325.2821854.10317059026052442189.stgit@magnolia>
 <165705854877.2821854.7070105861462675249.stgit@magnolia>
 <20220707120639.qoqsfcwtmdyl5duv@zlang-mailbox>
 <YsckVj+Yw4h1xeVp@magnolia>
 <20220708004916.tiidmzowad2wi3g4@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708004916.tiidmzowad2wi3g4@zlang-mailbox>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 08, 2022 at 08:49:16AM +0800, Zorro Lang wrote:
> On Thu, Jul 07, 2022 at 11:22:14AM -0700, Darrick J. Wong wrote:
> > On Thu, Jul 07, 2022 at 08:06:39PM +0800, Zorro Lang wrote:
> > > On Tue, Jul 05, 2022 at 03:02:28PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Make sure that the kernel can handle empty xattr leaf blocks properly,
> > > > since we've screwed this up enough times.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  tests/xfs/845 |  131 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 131 insertions(+)
> > > >  create mode 100755 tests/xfs/845
> > > > 
> > > > 
> > > > diff --git a/tests/xfs/845 b/tests/xfs/845
> > > > new file mode 100755
> > > > index 00000000..4a846e57
> > > > --- /dev/null
> > > > +++ b/tests/xfs/845
> > > > @@ -0,0 +1,131 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test 845
> > > > +#
> > > > +# Make sure that XFS can handle empty leaf xattr blocks correctly.  These
> > > > +# blocks can appear in files as a result of system crashes in the middle of
> > > > +# xattr operations, which means that we /must/ handle them gracefully.
> > > > +# Check that read and write verifiers won't trip, that the get/list/setxattr
> > > > +# operations don't stumble over them, and that xfs_repair will offer to remove
> > > > +# the entire xattr fork if the root xattr leaf block is empty.
> > > > +#
> > > > +# Regression test for kernel commit:
> > > > +#
> > > > +# af866926d865 ("xfs: empty xattr leaf header blocks are not corruption")
> > > > +#
> > > > +. ./common/preamble
> > > > +_begin_fstest auto quick attr
> > > > +
> > > > +# Override the default cleanup function.
> > > > +# _cleanup()
> > > > +# {
> > > > +# 	cd /
> > > > +# 	rm -r -f $tmp.*
> > > > +# }
> > > 
> > > Remove this part directly?
> > 
> > Ok.
> > 
> > > > +
> > > > +# Import common functions.
> > > > +. ./common/filter
> > > > +. ./common/attr
> > > > +
> > > > +# real QA test starts here
> > > > +
> > > > +# Modify as appropriate.
> > >       ^^
> > >       This comment is useless
> > 
> > Oops, will delete.
> > 
> > > > +_supported_fs xfs
> > > > +_require_scratch
> > > > +_fixed_by_kernel_commit af866926d865 "xfs: empty xattr leaf header blocks are not corruption"
> > > > +
> > > > +_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
> > > > +cat $tmp.mkfs >> $seqres.full
> > > > +source $tmp.mkfs
> > > > +_scratch_mount
> > > > +
> > > > +$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 64k' $SCRATCH_MNT/largefile >> $seqres.full
> > > > +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $isize" $SCRATCH_MNT/smallfile >> $seqres.full
> > > > +
> > > > +smallfile_md5=$(md5sum < $SCRATCH_MNT/smallfile)
> > > > +largefile_md5=$(md5sum < $SCRATCH_MNT/largefile)
> > > 
> > > Hmm... is the tail '-' (printed by md5sum) as you wish? How about use the
> > > _md5_checksum() in common/rc ? (Same as below small_md5 and large_md5 part)
> > 
> > Ooh, nice suggestion.  I"ll convert the test.
> > 
> > > > +
> > > > +# Try to force the creation of a single leaf block in each of three files.
> > > > +# The first one gets a local attr, the second a remote attr, and the third
> > > > +# is left for scrub and repair to find.
> > > > +touch $SCRATCH_MNT/e0
> > > > +touch $SCRATCH_MNT/e1
> > > > +touch $SCRATCH_MNT/e2
> > > > +
> > > > +$ATTR_PROG -s x $SCRATCH_MNT/e0 < $SCRATCH_MNT/smallfile >> $seqres.full
> > > > +$ATTR_PROG -s x $SCRATCH_MNT/e1 < $SCRATCH_MNT/smallfile >> $seqres.full
> > > > +$ATTR_PROG -s x $SCRATCH_MNT/e2 < $SCRATCH_MNT/smallfile >> $seqres.full
> > > > +
> > > > +e0_ino=$(stat -c '%i' $SCRATCH_MNT/e0)
> > > > +e1_ino=$(stat -c '%i' $SCRATCH_MNT/e1)
> > > > +e2_ino=$(stat -c '%i' $SCRATCH_MNT/e2)
> > > > +
> > > > +_scratch_unmount
> > > > +
> > > > +# We used to think that it wasn't possible for empty xattr leaf blocks to
> > > > +# exist, but it turns out that setting a large xattr on a file that has no
> > > > +# xattrs can race with a log flush and crash, which results in an empty
> > > > +# leaf block being logged and recovered.  This is rather hard to trip, so we
> > > > +# use xfs_db to turn a regular leaf block into an empty one.
> > > > +make_empty_leaf() {
> > > > +	local inum="$1"
> > > > +
> > > > +	echo "editing inode $inum" >> $seqres.full
> > > > +
> > > > +	magic=$(_scratch_xfs_get_metadata_field hdr.info.magic "inode $inum" "ablock 0")
> > > > +	if [ "$magic" = "0xfbee" ]; then
> > > > +		_notrun "V4 filesystems deprecated"
> > > 
> > > Can _require_scratch_xfs_crc (at beginning) help that? Or is there a way to
> > > get a v4 leaf block when crc isn't enabled?
> > 
> > Nope, that was an oversight on my part.  I'll add
> > _require_scratch_xfs_crc to the start of the test.
> > 
> > > > +		return 1
> > > 
> > > I think _notrun will exit directly, this "return 1" never be run.
> > 
> > Yep.
> > 
> > > > +	fi
> > > > +
> > > > +	magic=$(_scratch_xfs_get_metadata_field hdr.info.hdr.magic "inode $inum" "ablock 0")
> > > > +	if [ "$magic" != "0x3bee" ]; then
> > > > +		echo "inode $inum ablock 0 is not a leaf block?"
> > > > +		_scratch_xfs_db -x -c "inode $inum" -c "ablock 0" -c print >> $seqres.full
> > > > +		return 1
> > > > +	fi
> > > > +
> > > > +	base=$(_scratch_xfs_get_metadata_field "hdr.freemap[0].base" "inode $inum" "ablock 0")
> > > > +
> > > > +	_scratch_xfs_db -x -c "inode $inum" -c "ablock 0" \
> > > > +		-c "write -d hdr.count 0" \
> > > > +		-c "write -d hdr.usedbytes 0" \
> > > > +		-c "write -d hdr.firstused $dbsize" \
> > > > +		-c "write -d hdr.freemap[0].size $((dbsize - base))" \
> > > 
> > > Nice trick:) Do we expect there's not corruption (can be found by xfs_repair)
> > > at here?
> > 
> > Right.  We're setting up the empty leaf block 0 to check that the kernel
> > and fsck tools do /not/ flag this as corruption.
> > 
> > > Or xfs_repair should blame the empty leaf block?
> > 
> > ...though repair run in not-dryrun mode will free the empty leaf block 0
> > if it finds one.
> > 
> > > > +		-c print >> $seqres.full
> > > > +}
> > > > +
> > > > +make_empty_leaf $e0_ino || exit
> > > 
> > > How about call _fail() directly in make_empty_leaf, if [ "$magic" != "0x3bee" ]
> > 
> > _require_scratch_xfs_crc should take care of that.
> 
> Hmm... I think _require_scratch_xfs_crc will help this:
> 
>   magic=$(_scratch_xfs_get_metadata_field hdr.info.magic "inode $inum" "ablock 0")
>   if [ "$magic" = "0xfbee" ]; then
> 
> but can't help this part:
> 
>  magic=$(_scratch_xfs_get_metadata_field hdr.info.hdr.magic "inode $inum" "ablock 0")
>  if [ "$magic" != "0x3bee" ]; then
> 
> due to ablock 0 might be 0x3ebe (XFS_DA3_NODE_MAGIC) besides 0x3bee, although
> it looks nearly not impossible in this test, as you only create one attr equal
> to inode size :) So if we make sure it never be a node block, it's fine to
> remove this judgement, or you can keep it for sure.

That's actually a good point, I should print out something if the magic
number isn't 0x3bee, because that means a test precondition was not
satisfied.

(Granted, anything other than a leaf block and the _set commands will
spray errors, but we could be explicit about not finding the leaf block
we expected to see.)

--D

> Thanks,
> Zorro
> 
> > 
> > > > +make_empty_leaf $e1_ino
> > > > +make_empty_leaf $e2_ino
> > > > +
> > > > +_scratch_mount
> > > > +
> > > > +# Check that listxattr/getxattr/removexattr do nothing.
> > > > +$ATTR_PROG -l $SCRATCH_MNT/e0 2>&1 | _filter_scratch
> > > > +$ATTR_PROG -g x $SCRATCH_MNT/e0 2>&1 | _filter_scratch
> > > > +$ATTR_PROG -r x $SCRATCH_MNT/e0 2>&1 | _filter_scratch
> > > > +
> > > > +# Add a small attr to e0
> > > > +$ATTR_PROG -s x $SCRATCH_MNT/e0 < $SCRATCH_MNT/smallfile > /dev/null
> > > > +$ATTR_PROG -l $SCRATCH_MNT/e0 2>&1 | sed -e 's/\([0-9]*\) byte/XXX byte/g' | _filter_scratch
> > > > +small_md5="$($GETFATTR_PROG -n user.x --absolute-names --only-values $SCRATCH_MNT/e0 | md5sum)"
> > > > +test "$small_md5" = "$smallfile_md5" || \
> > > > +	echo "smallfile $smallfile_md5 does not match small attr $small_md5"
> > > > +
> > > > +# Add a large attr to e1
> > > > +$ATTR_PROG -s x $SCRATCH_MNT/e1 < $SCRATCH_MNT/largefile > /dev/null
> > > > +$ATTR_PROG -l $SCRATCH_MNT/e1 2>&1 | _filter_scratch
> > > > +large_md5="$($GETFATTR_PROG -n user.x --absolute-names --only-values $SCRATCH_MNT/e1 | md5sum)"
> > > > +test "$large_md5" = "$largefile_md5" || \
> > > > +	echo "largefile $largefile_md5 does not match large attr $large_md5"
> > > > +
> > > > +
> > > > +# Leave e2 to try to trip the repair tools, since xfs_repair used to flag
> > > > +# empty leaf blocks incorrectly too.
> > > 
> > > So we expect there's not corruption at here, and the empty leaf block can
> > > be used properly?
> > 
> > Correct.
> > 
> > --D
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > > +
> > > > +# success, all done
> > > > +status=0
> > > > +exit
> > > > 
> > > 
> > 
> 
