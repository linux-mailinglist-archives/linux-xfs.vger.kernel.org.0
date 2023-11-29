Return-Path: <linux-xfs+bounces-251-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E3587FCF32
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 07:34:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E94AB216D3
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 06:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E08AD101C0;
	Wed, 29 Nov 2023 06:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NoFywrii"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E03101C6
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 06:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D5AC433C7;
	Wed, 29 Nov 2023 06:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701239674;
	bh=gi+butBnjxFbdfipltyeJ8FK1caOXBc4/I7P659ZPfE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NoFywriiasU8itLSU9EpPZQ/kSoZlfUodkVhK0ezxHYU1qjnO7ONdm1WVcn0qzqmq
	 ezxl9xTLIigFrWTlpl7ELkU2HSm7ZOjFDoEt69qE2WE1UQA8v/QpZkozfkKjf/Dc/e
	 eTCEjpmHSO3h2Zd0Q0D0kF6zOVg1OCTXB8vppEPSR/jHFXijMHYTHGN+ftg2FIHf5J
	 5KZ/xorJsEHKNBl5rdiqVD94/BWuoFPtaqttStoABr2Or7XTyaRUzrZjTHAxl9IoWd
	 3s4MnEHtkxZF14X52rc0+3Uq91+AGWo1Ukie8vUPaxo8bQJxovocf+zb0wWTznT5ox
	 gU+bIb0LvpJOQ==
Date: Tue, 28 Nov 2023 22:34:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>, Ben Myers <bpm@sgi.com>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	xieyongji@bytedance.com, me@jcix.top
Subject: Re: [PATCH 2/2] xfs: update dir3 leaf block metadata after swap
Message-ID: <20231129063433.GD361584@frogsfrogsfrogs>
References: <20231128053202.29007-1-zhangjiachen.jaycee@bytedance.com>
 <20231128053202.29007-3-zhangjiachen.jaycee@bytedance.com>
 <ZWZ0qGWpBTW6Iynt@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWZ0qGWpBTW6Iynt@dread.disaster.area>

On Wed, Nov 29, 2023 at 10:15:52AM +1100, Dave Chinner wrote:
> On Tue, Nov 28, 2023 at 01:32:02PM +0800, Jiachen Zhang wrote:
> > From: Zhang Tianci <zhangtianci.1997@bytedance.com>
> > 
> > xfs_da3_swap_lastblock() copy the last block content to the dead block,
> > but do not update the metadata in it. We need update some metadata
> > for some kinds of type block, such as dir3 leafn block records its
> > blkno, we shall update it to the dead block blkno. Otherwise,
> > before write the xfs_buf to disk, the verify_write() will fail in
> > blk_hdr->blkno != xfs_buf->b_bn, then xfs will be shutdown.
> > 
> > We will get this warning:
> > 
> >   XFS (dm-0): Metadata corruption detected at xfs_dir3_leaf_verify+0xa8/0xe0 [xfs], xfs_dir3_leafn block 0x178
> >   XFS (dm-0): Unmount and run xfs_repair
> >   XFS (dm-0): First 128 bytes of corrupted metadata buffer:
> >   00000000e80f1917: 00 80 00 0b 00 80 00 07 3d ff 00 00 00 00 00 00  ........=.......
> >   000000009604c005: 00 00 00 00 00 00 01 a0 00 00 00 00 00 00 00 00  ................
> >   000000006b6fb2bf: e4 44 e3 97 b5 64 44 41 8b 84 60 0e 50 43 d9 bf  .D...dDA..`.PC..
> >   00000000678978a2: 00 00 00 00 00 00 00 83 01 73 00 93 00 00 00 00  .........s......
> >   00000000b28b247c: 99 29 1d 38 00 00 00 00 99 29 1d 40 00 00 00 00  .).8.....).@....
> >   000000002b2a662c: 99 29 1d 48 00 00 00 00 99 49 11 00 00 00 00 00  .).H.....I......
> >   00000000ea2ffbb8: 99 49 11 08 00 00 45 25 99 49 11 10 00 00 48 fe  .I....E%.I....H.
> >   0000000069e86440: 99 49 11 18 00 00 4c 6b 99 49 11 20 00 00 4d 97  .I....Lk.I. ..M.
> >   XFS (dm-0): xfs_do_force_shutdown(0x8) called from line 1423 of file fs/xfs/xfs_buf.c.  Return address = 00000000c0ff63c1
> >   XFS (dm-0): Corruption of in-memory data detected.  Shutting down filesystem
> >   XFS (dm-0): Please umount the filesystem and rectify the problem(s)
> > 
> > From the log above, we know xfs_buf->b_no is 0x178, but the block's hdr record
> > its blkno is 0x1a0.
> > 
> > Fixes: 24df33b45ecf ("xfs: add CRC checking to dir2 leaf blocks")
> > Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
> > ---
> >  fs/xfs/libxfs/xfs_da_btree.c | 12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> > index e576560b46e9..35f70e4c6447 100644
> > --- a/fs/xfs/libxfs/xfs_da_btree.c
> > +++ b/fs/xfs/libxfs/xfs_da_btree.c
> > @@ -2318,8 +2318,18 @@ xfs_da3_swap_lastblock(
> >  	 * Copy the last block into the dead buffer and log it.
> >  	 */
> >  	memcpy(dead_buf->b_addr, last_buf->b_addr, args->geo->blksize);
> > -	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
> >  	dead_info = dead_buf->b_addr;
> > +	/*
> > +	 * Update the moved block's blkno if it's a dir3 leaf block
> > +	 */
> > +	if (dead_info->magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
> > +	    dead_info->magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC) ||
> > +	    dead_info->magic == cpu_to_be16(XFS_ATTR3_LEAF_MAGIC)) {

On second thought, does this code have to handle XFS_DA3_NODE_MAGIC as
well?

> 
> a.k.a.
> 
> 	if (xfs_has_crc(mp)) {
> 
> i.e. this is not specific to the buffer type being processed, it's
> specific to v4 vs v5 on-disk format. Hence it's a fs-feature check,
> not a block magic number check.

in which case Dave's comment is correct, yes?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

