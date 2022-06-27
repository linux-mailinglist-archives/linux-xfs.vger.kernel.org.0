Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA47755B5E8
	for <lists+linux-xfs@lfdr.de>; Mon, 27 Jun 2022 06:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiF0D7N (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 Jun 2022 23:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiF0D7M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 23:59:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39242AF2
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 20:59:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 858A461006
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 03:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C27C341C8;
        Mon, 27 Jun 2022 03:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656302351;
        bh=95rxev1f6HnRXPqHHE3piIkgKJiRZS61haOHYrcSvdM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EfEZGr/uqYVB7xwM3KO3l0pLSJ4psQpao+eGTnQ2sLVy9yx+hq5zRGdVt2269INrp
         W1UN8X5UVWjQvv9+797uFWZqAnLPUSzqu8HhSpq5P/mpw79T+pp5NSrNolBFpkIvu1
         PizturI95MHQsTiTsXrY+3++6i0zEXUcZLOrEr1EtUcl4ss+t8l6a4hY5AbXfgCUXV
         KviSHp/4cqdnFOSbkmxPN+o3CXWUcXcE8APhpeRRyFzRGCEQFnoix2ibZuaIxJIKjQ
         wdqU8ikLIn7fKz/8T6vvSP4xA/UDNDNd6G9tPh7gvhm26ATxP23IwDQvTUSaYfT+FV
         TPVI8HZBkkoHw==
Date:   Sun, 26 Jun 2022 20:59:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 1/3] xfs: empty xattr leaf header blocks are not
 corruption
Message-ID: <YrkrDtr5qQlxDoE/@magnolia>
References: <165628102728.4040423.16023948770805941408.stgit@magnolia>
 <165628103299.4040423.12298502732701682950.stgit@magnolia>
 <20220627011654.GZ227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627011654.GZ227878@dread.disaster.area>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 11:16:54AM +1000, Dave Chinner wrote:
> On Sun, Jun 26, 2022 at 03:03:53PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Every now and then we get a corruption report from the kernel or
> > xfs_repair about empty leaf blocks in the extended attribute structure.
> > We've long thought that these shouldn't be possible, but prior to 5.18
> > one would shake loose in the recoveryloop fstests about once a month.
> > 
> > A new addition to the xattr leaf block verifier in 5.19-rc1 makes this
> > happen every 7 minutes on my testing cloud.
> 
> Ok, so this is all just a long way of saying:
> 
> Revert commit 51e6104fdb95 ("xfs: detect empty attr leaf blocks in
> xfs_attr3_leaf_verify") because it was wrong.
> 
> Yes?

Yep.

> > Original-bug: 517c22207b04 ("xfs: add CRCs to attr leaf blocks")
> > Still-not-fixed: 2e1d23370e75 ("xfs: ignore leaf attr ichdr.count in verifier during log replay")
> > Removed-in: f28cef9e4dac ("xfs: don't fail verifier on empty attr3 leaf block")
> > Fixes: 51e6104fdb95 ("xfs: detect empty attr leaf blocks in xfs_attr3_leaf_verify")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_attr_leaf.c |   48 ++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 42 insertions(+), 6 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index 37e7c33f6283..be7c216ec8f2 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -311,13 +311,49 @@ xfs_attr3_leaf_verify(
> >  		return fa;
> >  
> >  	/*
> > -	 * Empty leaf blocks should never occur;  they imply the existence of a
> > -	 * software bug that needs fixing. xfs_repair also flags them as a
> > -	 * corruption that needs fixing, so we should never let these go to
> > -	 * disk.
> > +	 * Empty leaf blocks can occur under the following circumstances:
> > +	 *
> > +	 * 1. setxattr adds a new extended attribute to a file;
> > +	 * 2. The file has zero existing attributes;
> > +	 * 3. The attribute is too large to fit in the attribute fork;
> > +	 * 4. The attribute is small enough to fit in a leaf block;
> > +	 * 5. A log flush occurs after committing the transaction that creates
> > +	 *    the (empty) leaf block; and
> > +	 * 6. The filesystem goes down after the log flush but before the new
> > +	 *    attribute can be committed to the leaf block.
> > +	 *
> > +	 * xfs_repair used to flag these empty leaf blocks as corruption, but
> > +	 * aside from wasting space, they are benign.  The rest of the xattr
> > +	 * code will happily add attributes to empty leaf blocks.  Hence this
> > +	 * comment serves as a tombstone to incorrect verifier code.
> > +	 *
> > +	 * Unfortunately, this check has been added and removed multiple times
> > +	 * throughout history.  It first appeared in[1] kernel 3.10 as part of
> > +	 * the early V5 format patches.  The check was later discovered to
> > +	 * break log recovery and hence disabled[2] during log recovery in
> > +	 * kernel 4.10.  Simultaneously, the check was added[3] to xfs_repair
> > +	 * 4.9.0 to try to weed out the empty leaf blocks.  This was still not
> > +	 * correct because log recovery would recover an empty attr leaf block
> > +	 * successfully only for regular xattr operations to trip over the
> > +	 * empty block during of the block during regular operation.
> > +	 * Therefore, the check was removed entirely[4] in kernel 5.7 but
> > +	 * removal of the xfs_repair check was forgotten.  The continued
> > +	 * complaints from xfs_repair lead to us mistakenly re-adding[5] the
> > +	 * verifier check for kernel 5.19, and has been removed once again.
> > +	 *
> > +	 * [1] 517c22207b04 ("xfs: add CRCs to attr leaf blocks")
> > +	 * [2] 2e1d23370e75 ("xfs: ignore leaf attr ichdr.count in verifier
> > +	 *                    during log replay")
> > +	 * [3] f7140161 ("xfs_repair: junk leaf attribute if count == 0")
> > +	 * [4] f28cef9e4dac ("xfs: don't fail verifier on empty attr3 leaf
> > +	 *                    block")
> > +	 * [5] 51e6104fdb95 ("xfs: detect empty attr leaf blocks in
> > +	 *                    xfs_attr3_leaf_verify")
> > +	 *
> > +	 * Normally this would go in the commit message, but as we've a history
> > +	 * of getting this wrong, this now goes in the code base as a gigantic
> > +	 * comment.
> >  	 */
> 
> I still think it should be in the commit history, not here in the
> code. The reason I missed this is that the existing comment about
> empty leaf attrs is above a section that is verifying entries
> *after* various fields in the header had been validated. Hence I
> thought it was a case that the header field had not been validated
> and so I added it. Simple mistake.

<nod> ...and I wanted redundant breadcrumbs in the commit history and
the code itself because you and I keep making the same mistakes. :/

> This needs to be a comment at the head of the function, not
> associated with validity checking the entries. i.e.
> 
> /*
>  * Validate the attribute leaf.
>  *
>  * A leaf block can be empty as a result of transient state whilst
>  * creating a new leaf form attribute:
>  *
>  * 1. setxattr adds a new extended attribute to a file;
>  * 2. The file has zero existing attributes;
>  * 3. The attribute is too large to fit in the attribute fork;
>  * 4. The attribute is small enough to fit in a leaf block;
>  * 5. A log flush occurs after committing the transaction that creates
>  *    the (empty) leaf block; and
>  * 6. The filesystem goes down after the log flush but before the new
>  *    attribute can be committed to the leaf block.
>  *
>  * Hence we need to ensure that we don't fail the validation purely
>  * because the leaf is empty.
>  */

Ok done.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
