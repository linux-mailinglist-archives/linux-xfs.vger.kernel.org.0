Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BE0618A57
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Nov 2022 22:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiKCVMs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 3 Nov 2022 17:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiKCVMr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 17:12:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3ABDFA
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 14:12:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8716462014
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 21:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28ECC433C1;
        Thu,  3 Nov 2022 21:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667509964;
        bh=Cs0fayDVXt9gSI0uRfItOTljHJ6eMLzgLsJz/K7hU5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ShtMgjcvQK63CngWBFDLf7AOcvQLueHw/6tc7L40sIX3kwRiL6K76JuyaYm64WQ9i
         Nosb0yfyJY+tKHM1Cj7QLaVJ43KMHwQ/wzBJZBuygmX+OzbKfB42JnWQwoc7ypELgA
         OdIaugQI+LiAd4i073aSt9Sc6pSmkXjmbYrD1j2sGC69FzYsyqfsdG1c+I8bsu/oYA
         DtIKDPke7FXildaP8yqOy00vIAvcKo4fc20zluASGpvagXX1Rm0wtE1ERoP/UxRaG7
         lEuXMf9xY37werVq61v0/Nf3s2EWaLdtdXwC9tfJ6qioR8Yk+SbcGC/gF1B8zUFKC/
         Fhs3bZVC1Ts9Q==
Date:   Thu, 3 Nov 2022 14:12:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: mask key comparisons for keyspace fill scans
Message-ID: <Y2QuzIy11bUn5g4c@magnolia>
References: <166473481572.1084209.5434516873607335909.stgit@magnolia>
 <166473481626.1084209.13610255473278160434.stgit@magnolia>
 <20221102021626.GU3600936@dread.disaster.area>
 <Y2MUfJzf/com/y2d@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2MUfJzf/com/y2d@magnolia>
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 02, 2022 at 06:08:12PM -0700, Darrick J. Wong wrote:
> On Wed, Nov 02, 2022 at 01:16:26PM +1100, Dave Chinner wrote:
> > On Sun, Oct 02, 2022 at 11:20:16AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > For keyspace fullness scans, we want to be able to mask off the parts of
> > > the key that we don't care about.  For most btree types we /do/ want the
> > > full keyspace, but for checking that a given space usage also has a full
> > > complement of rmapbt records (even if different/multiple owners) we need
> > > this masking so that we only track sparseness of rm_startblock, not the
> > > whole keyspace (which is extremely sparse).
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > ....
> > > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > > index edea6db8d8e4..6fbce2f3c17e 100644
> > > --- a/fs/xfs/libxfs/xfs_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_btree.c
> > > @@ -5020,12 +5020,33 @@ struct xfs_btree_scan_keyfill {
> > >  	union xfs_btree_key	start_key;
> > >  	union xfs_btree_key	end_key;
> > >  
> > > +	/* Mask for key comparisons, if desired. */
> > > +	union xfs_btree_key	*key_mask;
> > 
> > How does this mask work? i.e. the way it is supposed to be used it
> > not documented in either the commit message or the code....
> 
> When I merge all of this into _diff_two_keys, I'll add this to its
> description:
> 
> "Normally, each btree type's _diff_two_keys implementation will use all
> available btree key fields to compare the given keys.  However, some
> callers may prefer to ignore some part of the btree record keyspace when
> performing the comparison.
> 
> These callers should create a union xfs_btree_key object, set the fields
> that *should* be a part of the comparison to any nonzero value, and
> leave the rest zeroed.  That object should be passed in as the @key_mask
> value."
> 
> For a concrete example, take the rmap space scanning function below.  If
> we only want to know if a certain range of physical blocks has zero rmap
> records, enough rmap records to account for every block in the range, or
> some records in between, we'd initialize the key mask as follows:
> 
> 	union xfs_btree_key	km = {
> 		.rmap.rm_startblock = 1,
> 	};
> 
> and the _scan_keyfill function will only look that far into the key
> comparisons.
> 
> > 
> > > +STATIC int64_t
> > > +xfs_btree_diff_two_masked_keys(
> > > +	struct xfs_btree_cur		*cur,
> > > +	const union xfs_btree_key	*key1,
> > > +	const union xfs_btree_key	*key2,
> > > +	const union xfs_btree_key	*mask)
> > > +{
> > > +	union xfs_btree_key		mk1, mk2;
> > > +
> > > +	if (likely(!mask))
> > > +		return cur->bc_ops->diff_two_keys(cur, key1, key2);
> > > +
> > > +	cur->bc_ops->mask_key(cur, &mk1, key1, mask);
> > > +	cur->bc_ops->mask_key(cur, &mk2, key2, mask);
> > > +
> > > +	return cur->bc_ops->diff_two_keys(cur, &mk1, &mk2);
> > > +}
> > 
> > This seems .... very abstract.
> 
> Yes, I've gone unusually deep into database theory here...
> 
> > Why not just add a mask pointer to xfs_btree_diff_two_keys(),
> > and in each of the btree implementations of ->diff_two_keys()
> > change them to:
> > 
> > 	if (mask) {
> > 		/* mask keys */
> > 	}
> > 	/* run existing diff on two keys */
> > 
> > That gets rid of all these function pointer calls, and we only need
> > a single "diff two keys" api to be defined...
> 
> Ok, I'll look into combining mask_key into diff_two_keys.
> 
> > > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > > index 58a05f0d1f1b..99baa8283049 100644
> > > --- a/fs/xfs/libxfs/xfs_btree.h
> > > +++ b/fs/xfs/libxfs/xfs_btree.h
> > > @@ -158,10 +158,17 @@ struct xfs_btree_ops {
> > >  				const union xfs_btree_rec *r1,
> > >  				const union xfs_btree_rec *r2);
> > >  
> > > +	/* mask a key for us */
> > > +	void	(*mask_key)(struct xfs_btree_cur *cur,
> > > +			    union xfs_btree_key *out_key,
> > > +			    const union xfs_btree_key *in_key,
> > > +			    const union xfs_btree_key *mask);
> > > +
> > >  	/* decide if there's a gap in the keyspace between two keys */
> > >  	bool	(*has_key_gap)(struct xfs_btree_cur *cur,
> > >  			       const union xfs_btree_key *key1,
> > > -			       const union xfs_btree_key *key2);
> > > +			       const union xfs_btree_key *key2,
> > > +			       const union xfs_btree_key *mask);
> > >  };
> > >  
> > >  /*
> > > @@ -552,6 +559,7 @@ typedef bool (*xfs_btree_key_gap_fn)(struct xfs_btree_cur *cur,
> > >  int xfs_btree_scan_keyfill(struct xfs_btree_cur *cur,
> > >  		const union xfs_btree_irec *low,
> > >  		const union xfs_btree_irec *high,
> > > +		const union xfs_btree_irec *mask,
> > >  		enum xfs_btree_keyfill *outcome);
> > >  
> > >  bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
> > > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > index fd48b95b4f4e..d429ca8d9dd8 100644
> > > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > @@ -384,11 +384,14 @@ STATIC bool
> > >  xfs_inobt_has_key_gap(
> > >  	struct xfs_btree_cur		*cur,
> > >  	const union xfs_btree_key	*key1,
> > > -	const union xfs_btree_key	*key2)
> > > +	const union xfs_btree_key	*key2,
> > > +	const union xfs_btree_key	*mask)
> > >  {
> > >  	xfs_agino_t			next;
> > >  
> > > -	next = be32_to_cpu(key1->inobt.ir_startino) + XFS_INODES_PER_CHUNK;
> > > +	ASSERT(!mask || mask->inobt.ir_startino);
> > > +
> > > +	next = be32_to_cpu(key1->inobt.ir_startino) + 1;
> > >  	return next != be32_to_cpu(key2->inobt.ir_startino);
> > >  }
> > 
> > I think you just fixed the issue I noticed in the last patch....
> 
> Oops, I clearly committed this to the wrong patch.  Sorry about that.
> 
> > > diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> > > index 08d47cbf4697..4c123b6dd080 100644
> > > --- a/fs/xfs/libxfs/xfs_rmap.c
> > > +++ b/fs/xfs/libxfs/xfs_rmap.c
> > > @@ -2685,13 +2685,18 @@ xfs_rmap_scan_keyfill(
> > >  {
> > >  	union xfs_btree_irec	low;
> > >  	union xfs_btree_irec	high;
> > > +	union xfs_btree_irec	mask;
> > > +
> > > +	/* Only care about space scans here */
> > > +	memset(&mask, 0, sizeof(low));
> > 
> > sizeof(mask)?
> 
> Yep.
> 
> > > diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> > > index d64143a842ce..9ca60f709c4b 100644
> > > --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> > > @@ -433,16 +433,55 @@ xfs_rmapbt_recs_inorder(
> > >  	return 0;
> > >  }
> > >  
> > > +STATIC void
> > > +xfs_rmapbt_mask_key(
> > > +	struct xfs_btree_cur		*cur,
> > > +	union xfs_btree_key		*out_key,
> > > +	const union xfs_btree_key	*in_key,
> > > +	const union xfs_btree_key	*mask)
> > > +{
> > > +	memset(out_key, 0, sizeof(union xfs_btree_key));
> > > +
> > > +	if (mask->rmap.rm_startblock)
> > > +		out_key->rmap.rm_startblock = in_key->rmap.rm_startblock;
> > > +	if (mask->rmap.rm_owner)
> > > +		out_key->rmap.rm_owner = in_key->rmap.rm_owner;
> > > +	if (mask->rmap.rm_offset)
> > > +		out_key->rmap.rm_offset = in_key->rmap.rm_offset;
> > > +}
> > 
> > So the mask fields are just used as boolean state to select what
> > should be copied into the masked key?
> 
> Yes.  A zeroed keymask field will be ignored, a nonzero keymask field
> will be retained.
> 
> > > +
> > >  STATIC bool
> > >  xfs_rmapbt_has_key_gap(
> > >  	struct xfs_btree_cur		*cur,
> > >  	const union xfs_btree_key	*key1,
> > > -	const union xfs_btree_key	*key2)
> > > +	const union xfs_btree_key	*key2,
> > > +	const union xfs_btree_key	*mask)
> > >  {
> > > -	xfs_agblock_t			next;
> > > +	bool				reflink = xfs_has_reflink(cur->bc_mp);
> > > +	uint64_t			x, y;
> > >  
> > > -	next = be32_to_cpu(key1->rmap.rm_startblock) + 1;
> > > -	return next != be32_to_cpu(key2->rmap.rm_startblock);
> > > +	if (mask->rmap.rm_offset) {
> > > +		x = be64_to_cpu(key1->rmap.rm_offset) + 1;
> > > +		y = be64_to_cpu(key2->rmap.rm_offset);
> > > +		if ((reflink && x < y) || (!reflink && x != y))
> > > +			return true;
> > > +	}
> > > +
> > > +	if (mask->rmap.rm_owner) {
> > > +		x = be64_to_cpu(key1->rmap.rm_owner) + 1;
> > > +		y = be64_to_cpu(key2->rmap.rm_owner);
> > > +		if ((reflink && x < y) || (!reflink && x != y))
> > > +			return true;
> > > +	}
> > > +
> > > +	if (mask->rmap.rm_startblock) {
> > > +		x = be32_to_cpu(key1->rmap.rm_startblock) + 1;
> > > +		y = be32_to_cpu(key2->rmap.rm_startblock);
> > > +		if ((reflink && x < y) || (!reflink && x != y))
> > > +			return true;
> > > +	}
> > > +
> > > +	return false;
> > 
> > Urk. That needs a comment explaining what all the mystery reflink
> > logic is doing.

I decided to fix this in the "_scan_keyfill" patch by changing the
->keys_contiguous function to return if the keys are contiguous, have a
gap, or overlap.  That way, I could make _has_records detect improperly
overlapping records and return EFSCORRUPTED.  Having done that, it's no
longer necessary to have all this reflink logic to handle rmaps for
shared blocks.

Then I thought about the complexity of this patch, and realized that
there's only one user of the btree key masks, and that is
xfs_rmapbt_has_records.  That single user masks off everything in the
xfs_btree_key except for rm_startblock.  All other callers do not
provide masks at all.

IOWs, I could avoid introducing all this untestable complexity by
dropping this patch entirely.  That would leave the function incomplete,
but that makes things simpler for now because I no longer have to worry
about making the comparison handle numeric gaps in the keyspace where
it's never possible to have keys (e.g. detecting records for a bmbt
block and skipping the offset comparison).

So.  I'm dropping this patch.

--D

> > It also needs to explain the order of precedence on
> > the mask checks and why that order is important (or not!).
> 
> For the purpose of comparing two keys to decide if there's a gap in the
> keyspace, we do the comparisons in order of most sensitive to least
> sensitive.  This is the opposite order of diff_two_keys -- if two keys
> have the same startblock and inode but discontiguous file offsets,
> there's a gap.  If two keys have the same startblock but different
> owners, there's a gap regardless of the offset.  What that means is a
> bit murky, since the only user of this functionality passes a mask so
> that we only compare the perag parts fo the keys.
>
> Except for the masking, I think the comparison logic all got committed
> to the wrong patch.  :(
> 
> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
