Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E4D65248D
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Dec 2022 17:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiLTQUL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 20 Dec 2022 11:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbiLTQUI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 11:20:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9DA1A3B5
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 08:20:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D609461309
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 16:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A9AC433EF;
        Tue, 20 Dec 2022 16:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671553204;
        bh=Fmum8od/3UmkckjIh3dKqg4bg4xyamlrJZdYjf8vPos=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EGDPPDqQDK/ETuKP/PBeAmd3r6/TypbGpET1v+uN5G63k0kbeVKORIkRamzTgrXD+
         lacwe2qJWTlpOht/keEDwWNYC7WCr2qsCilmnDPhtdrDfq3ncEnsD/+09vSa5bNynI
         VB5/2PCkUZqQe8H/DE+4tNtptc7qVsfL7meOdaMGldiUqV4/wRj/uwvjk0jHbvwM44
         ot1DgcODgnDyBd29UbjJtAXKm8ZuxPw5rR4rPFqi29CHZgfd53ZIJB4goemxxzyEsl
         EAO2CZRzVUBtwVKaEnCZfRQ61BUM2Pm8TY5/Wqp+MR0xKbtba/AvGnHmF4Q0s2w/cm
         rbzS1rYWsoToQ==
Date:   Tue, 20 Dec 2022 08:20:03 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: fix off-by-one error in
 xfs_btree_space_to_height
Message-ID: <Y6HfiWz4R55RbW5G@magnolia>
References: <167149469744.336919.13748690081866673267.stgit@magnolia>
 <167149471987.336919.3277522603824048839.stgit@magnolia>
 <20221220050001.GK1971568@dread.disaster.area>
 <Y6HeYJXVhamT589A@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6HeYJXVhamT589A@magnolia>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 20, 2022 at 08:10:08AM -0800, Darrick J. Wong wrote:
> On Tue, Dec 20, 2022 at 04:00:01PM +1100, Dave Chinner wrote:
> > On Mon, Dec 19, 2022 at 04:05:19PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Lately I've been stress-testing extreme-sized rmap btrees by using the
> > > (new) xfs_db bmap_inflate command to clone bmbt mappings billions of
> > > times and then using xfs_repair to build new rmap and refcount btrees.
> > > This of course is /much/ faster than actually FICLONEing a file billions
> > > of times.
> > > 
> > > Unfortunately, xfs_repair fails in xfs_btree_bload_compute_geometry with
> > > EOVERFLOW, which indicates that xfs_mount.m_rmap_maxlevels is not
> > > sufficiently large for the test scenario.  For a 1TB filesystem (~67
> > > million AG blocks, 4 AGs) the btheight command reports:
> > > 
> > > $ xfs_db -c 'btheight -n 4400801200 -w min rmapbt' /dev/sda
> > > rmapbt: worst case per 4096-byte block: 84 records (leaf) / 45 keyptrs (node)
> > > level 0: 4400801200 records, 52390491 blocks
> > > level 1: 52390491 records, 1164234 blocks
> > > level 2: 1164234 records, 25872 blocks
> > > level 3: 25872 records, 575 blocks
> > > level 4: 575 records, 13 blocks
> > > level 5: 13 records, 1 block
> > > 6 levels, 53581186 blocks total
> > > 
> > > The AG is sufficiently large to build this rmap btree.  Unfortunately,
> > > m_rmap_maxlevels is 5.  Augmenting the loop in the space->height
> > > function to report height, node blocks, and blocks remaining produces
> > > this:
> > > 
> > > ht 1 node_blocks 45 blockleft 67108863
> > > ht 2 node_blocks 2025 blockleft 67108818
> > > ht 3 node_blocks 91125 blockleft 67106793
> > > ht 4 node_blocks 4100625 blockleft 67015668
> > > final height: 5
> > > 
> > > The goal of this function is to compute the maximum height btree that
> > > can be stored in the given number of ondisk fsblocks.  Starting with the
> > > top level of the tree, each iteration through the loop adds the fanout
> > > factor of the next level down until we run out of blocks.  IOWs, maximum
> > > height is achieved by using the smallest fanout factor that can apply
> > > to that level.
> > > 
> > > However, the loop setup is not correct.  Top level btree blocks are
> > > allowed to contain fewer than minrecs items, so the computation is
> >   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > Ah, that's the critical piece of information I was looking for. I
> > couldn't work out from the code change below what was wrong with
> > limits[1]. So....
> > 
> > > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > > index 4c16c8c31fcb..8d11d3f5e529 100644
> > > --- a/fs/xfs/libxfs/xfs_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_btree.c
> > > @@ -4666,7 +4666,11 @@ xfs_btree_space_to_height(
> > >  	const unsigned int	*limits,
> > >  	unsigned long long	leaf_blocks)
> > >  {
> > > -	unsigned long long	node_blocks = limits[1];
> > > +	/*
> > > +	 * The root btree block can have a fanout between 2 and maxrecs because
> > > +	 * the tree might not be big enough to fill it.
> > > +	 */
> > 
> > Can you change this comment to say something like:
> > 
> > 	/*
> > 	 * The root btree block can have less than minrecs pointers
> > 	 * in it because the tree might not be big enough to require
> > 	 * that amount of fanout. Hence it has a minimum size of
> > 	 * 2 pointers, not limits[1].
> > 	 */
> 
> Done.  Thanks for the reviews! :)
> 
> --D
> 
> > 
> > Otherwise it looks good.
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > 
> > > +	unsigned long long	node_blocks = 2;
> > >  	unsigned long long	blocks_left = leaf_blocks - 1;
> > >  	unsigned int		height = 1;
> > 
> > For future consideration, we don't use maxrecs in this calculation
> > at all - should we just pass minrecs into the function rather than
> > an array of limits?

I prefer to replace all those mxr/mnr array constructs with an explicit
structure:

struct xfs_btblock_geometry {
	uint16_t	leaf_maxrecs;
	uint16_t	leaf_minrecs;

	uint16_t	node_maxrecs;
	uint16_t	node_minrecs;
};

and get rid of all the mp->m_rmap_mxr[leaf != 0] stuff that slows me
down every time I have to read it.

--D

> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
