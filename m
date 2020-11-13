Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1CD2B17FE
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Nov 2020 10:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgKMJQM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 13 Nov 2020 04:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgKMJQL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 04:16:11 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BA2C0613D1
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:16:09 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id j5so4274337plk.7
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ARLkvclA912xLWWV2Yu1pU0+n7W3mbdqGrEUYonr4U=;
        b=f7S4MWTd/KxT1MC8w2bWnNmV4OwJ3xXQWkj1gtFez7qb5c/9zM70PNVAbwM4OfJjNB
         xc612qmzqxpqWHMegn1OmLZESjz8QG/qCMN3rcdyF/FTnPptT3cklKsqcq6ZCTfEIENi
         nH6eTxjligcIAHWmYGHQUsWB8ziJfAWg4rqqCwSIDnOLMblo0aBmO5pGUdc6sCx2unY0
         ufJgpw5LoZBXuMqAx0P2Yn+sqeEKOovtCkWY7yXKzQI+LdeQhxe00nxykaH0SgWyLJtM
         vkTnoQ/pxgR9i/R8twB3/5kCFZvF/mR8Svc3LbUdADn0zZnvFy7/YElpEIejPmpDe+3N
         4yIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ARLkvclA912xLWWV2Yu1pU0+n7W3mbdqGrEUYonr4U=;
        b=VndG25nj07rpZAxGYjYN22io90tDJCuOx+SSBr/ayVD0pKSPP2ymG5j0EkxoAGfNfW
         VyGngG8Cmc7t/4rAE3Aumyz2I0ORE6nt+IgNLQPp46Fb/7ZZPEsPkjnvIDcgn1YDZ6m3
         IGohnMVYIywj2iLMiyoftQXkCn+i2W2cuovrsSLm0n+kbMoysvQVaGUT4CppKivDtBD8
         +2zwMVR7XXp9uafUMQAoCzz971gC5bXjqFvN0jWLXsfBVtHbJIXaKm98RNBnurbcuZ1C
         BIsx/p+LnQL2T1xxEHYubAkhxb7tRbcQGUj/a7uuMgtPKTSm7U4JYWiKmtxBvgFnm6Rk
         babA==
X-Gm-Message-State: AOAM530XGF6lf03FyP4xy0W8HAg7xo6/ZoWCnPv068soBWFZbkrLNLPA
        4M4fH0iL3PR+JnDihw6AM/Q=
X-Google-Smtp-Source: ABdhPJyO5QCP4eR5TwmyKOAomd4qMPLghQdJtNd3aCsX7eu7zET3Id4LBYyU2dy9xNrcnXnRN3mk2Q==
X-Received: by 2002:a17:902:c084:b029:d6:b04a:b091 with SMTP id j4-20020a170902c084b02900d6b04ab091mr1477681pld.14.1605258969046;
        Fri, 13 Nov 2020 01:16:09 -0800 (PST)
Received: from garuda.localnet ([122.172.185.167])
        by smtp.gmail.com with ESMTPSA id c15sm10775200pjc.43.2020.11.13.01.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 01:16:08 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v13 03/10] xfs: Add delay ready attr set routines
Date:   Fri, 13 Nov 2020 14:46:05 +0530
Message-ID: <20322189.3UhRF6KiVz@garuda>
In-Reply-To: <f386c199-3bb8-f6b7-6ef7-1e08d2b35b8a@oracle.com>
References: <20201023063435.7510-1-allison.henderson@oracle.com> <20201110215702.GH9695@magnolia> <f386c199-3bb8-f6b7-6ef7-1e08d2b35b8a@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 13 November 2020 7:03:13 AM IST Allison Henderson wrote:
> 
> On 11/10/20 2:57 PM, Darrick J. Wong wrote:
> > On Tue, Oct 27, 2020 at 07:02:55PM +0530, Chandan Babu R wrote:
> >> On Friday 23 October 2020 12:04:28 PM IST Allison Henderson wrote:
> >>> This patch modifies the attr set routines to be delay ready. This means
> >>> they no longer roll or commit transactions, but instead return -EAGAIN
> >>> to have the calling routine roll and refresh the transaction.  In this
> >>> series, xfs_attr_set_args has become xfs_attr_set_iter, which uses a
> >>> state machine like switch to keep track of where it was when EAGAIN was
> >>> returned. See xfs_attr.h for a more detailed diagram of the states.
> >>>
> >>> Two new helper functions have been added: xfs_attr_rmtval_set_init and
> >>> xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
> >>> xfs_attr_rmtval_set, but they store the current block in the delay attr
> >>> context to allow the caller to roll the transaction between allocations.
> >>> This helps to simplify and consolidate code used by
> >>> xfs_attr_leaf_addname and xfs_attr_node_addname. xfs_attr_set_args has
> >>> now become a simple loop to refresh the transaction until the operation
> >>> is completed.  Lastly, xfs_attr_rmtval_remove is no longer used, and is
> >>> removed.
> >>
> >> One nit. xfs_attr_rmtval_remove()'s prototype declaration needs to be removed
> >> from xfs_attr_remote.h.
> Alrighty, will pull out
> 
> >>
> >>>
> >>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> >>> ---
> >>>   fs/xfs/libxfs/xfs_attr.c        | 370 ++++++++++++++++++++++++++--------------
> >>>   fs/xfs/libxfs/xfs_attr.h        | 126 +++++++++++++-
> >>>   fs/xfs/libxfs/xfs_attr_remote.c |  99 +++++++----
> >>>   fs/xfs/libxfs/xfs_attr_remote.h |   4 +
> >>>   fs/xfs/xfs_trace.h              |   1 -
> >>>   5 files changed, 439 insertions(+), 161 deletions(-)
> >>>
> >>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> >>> index 6ca94cb..95c98d7 100644
> >>> --- a/fs/xfs/libxfs/xfs_attr.c
> >>> +++ b/fs/xfs/libxfs/xfs_attr.c
> >>> @@ -44,7 +44,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
> >>>    * Internal routines when attribute list is one block.
> >>>    */
> >>>   STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
> >>> -STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> >>> +STATIC int xfs_attr_leaf_addname(struct xfs_delattr_context *dac);
> >>>   STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> >>>   STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
> >>>   
> >>> @@ -52,12 +52,15 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
> >>>    * Internal routines when attribute list is more than one block.
> >>>    */
> >>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> >>> -STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> >>> +STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
> >>>   STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *dac);
> >>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> >>>   				 struct xfs_da_state **state);
> >>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> >>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> >>> +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
> >>> +STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
> >>> +			     struct xfs_buf **leaf_bp);
> >>>   
> >>>   int
> >>>   xfs_inode_hasattr(
> >>> @@ -218,8 +221,11 @@ xfs_attr_is_shortform(
> >>>   
> >>>   /*
> >>>    * Attempts to set an attr in shortform, or converts short form to leaf form if
> >>> - * there is not enough room.  If the attr is set, the transaction is committed
> >>> - * and set to NULL.
> >>> + * there is not enough room.  This function is meant to operate as a helper
> >>> + * routine to the delayed attribute functions.  It returns -EAGAIN to indicate
> >>> + * that the calling function should roll the transaction, and then proceed to
> >>> + * add the attr in leaf form.  This subroutine does not expect to be recalled
> >>> + * again like the other delayed attr routines do.
> >>>    */
> >>>   STATIC int
> >>>   xfs_attr_set_shortform(
> >>> @@ -227,16 +233,16 @@ xfs_attr_set_shortform(
> >>>   	struct xfs_buf		**leaf_bp)
> >>>   {
> >>>   	struct xfs_inode	*dp = args->dp;
> >>> -	int			error, error2 = 0;
> >>> +	int			error = 0;
> >>>   
> >>>   	/*
> >>>   	 * Try to add the attr to the attribute list in the inode.
> >>>   	 */
> >>>   	error = xfs_attr_try_sf_addname(dp, args);
> >>> +
> >>> +	/* Should only be 0, -EEXIST or ENOSPC */
> >>>   	if (error != -ENOSPC) {
> >>> -		error2 = xfs_trans_commit(args->trans);
> >>> -		args->trans = NULL;
> >>> -		return error ? error : error2;
> >>> +		return error;
> >>>   	}
> >>>   	/*
> >>>   	 * It won't fit in the shortform, transform to a leaf block.  GROT:
> >>> @@ -249,18 +255,10 @@ xfs_attr_set_shortform(
> >>>   	/*
> >>>   	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
> >>>   	 * push cannot grab the half-baked leaf buffer and run into problems
> >>> -	 * with the write verifier. Once we're done rolling the transaction we
> >>> -	 * can release the hold and add the attr to the leaf.
> >>> +	 * with the write verifier.
> >>>   	 */
> >>>   	xfs_trans_bhold(args->trans, *leaf_bp);
> >>> -	error = xfs_defer_finish(&args->trans);
> >>> -	xfs_trans_bhold_release(args->trans, *leaf_bp);
> >>> -	if (error) {
> >>> -		xfs_trans_brelse(args->trans, *leaf_bp);
> >>> -		return error;
> >>> -	}
> >>> -
> >>> -	return 0;
> >>> +	return -EAGAIN;
> >>>   }
> >>>   
> >>>   /*
> >>> @@ -268,7 +266,7 @@ xfs_attr_set_shortform(
> >>>    * also checks for a defer finish.  Transaction is finished and rolled as
> >>>    * needed, and returns true of false if the delayed operation should continue.
> >>>    */
> >>> -int
> >>> +STATIC int
> >>>   xfs_attr_trans_roll(
> >>>   	struct xfs_delattr_context	*dac)
> >>>   {
> >>> @@ -297,61 +295,130 @@ int
> >>>   xfs_attr_set_args(
> >>>   	struct xfs_da_args	*args)
> >>>   {
> >>> -	struct xfs_inode	*dp = args->dp;
> >>> -	struct xfs_buf          *leaf_bp = NULL;
> >>> -	int			error = 0;
> >>> +	struct xfs_buf			*leaf_bp = NULL;
> >>> +	int				error = 0;
> >>> +	struct xfs_delattr_context	dac = {
> >>> +		.da_args	= args,
> >>> +	};
> >>> +
> >>> +	do {
> >>> +		error = xfs_attr_set_iter(&dac, &leaf_bp);
> >>> +		if (error != -EAGAIN)
> >>> +			break;
> >>> +
> >>> +		error = xfs_attr_trans_roll(&dac);
> >>> +		if (error)
> >>> +			return error;
> >>> +
> >>> +		if (leaf_bp) {
> >>> +			xfs_trans_bjoin(args->trans, leaf_bp);
> >>> +			xfs_trans_bhold(args->trans, leaf_bp);
> >>> +		}
> >>
> >> When xfs_attr_set_iter() causes a "short form" attribute list to be converted
> >> to "leaf form", leaf_bp would point to an xfs_buf which has been added to the
> >> transaction and also XFS_BLI_HOLD flag is set on the buffer (last statement in
> >> xfs_attr_set_shortform()). XFS_BLI_HOLD flag makes sure that the new
> >> transaction allocated by xfs_attr_trans_roll() would continue to have leaf_bp
> >> in the transaction's item list. Hence I think the above calls to
> >> xfs_trans_bjoin() and xfs_trans_bhold() are not required.
> Sorry, I just noticed Chandans commentary for this patch.  Apologies. I 
> think we can get away with out this now, but yes this routine disappears 
> at the end of the set now.  Will clean out anyway for bisecting reasons 
> though. :-)

No problem. As an aside, I stopped reviewing the patchset after I noticed
Brian's review comments for "[PATCH v13 02/10] xfs: Add delay ready attr
remove routines" suggesting some more code refactoring work.

> 
> > 
> > I /think/ the defer ops will rejoin the buffer each time it rolls, which
> > means that xfs_attr_trans_roll returns with the buffer already joined to
> > the transaction?  And I think you're right that the bhold isn't needed,
> > because holding is dictated by the lower levels (i.e. _set_iter).
> > 
> >> Please let me know if I am missing something obvious here.
> > 
> > The entire function goes away by the end of the series. :)
> > 
> > --D
> > 
> >>
> >>
> >>
> >>
> 


-- 
chandan



