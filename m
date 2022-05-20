Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E7752E072
	for <lists+linux-xfs@lfdr.de>; Fri, 20 May 2022 01:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbiESXRv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 19 May 2022 19:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343538AbiESXRt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 19:17:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C89C106A6E
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 16:17:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7A4AB828D5
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 23:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4EBC385AA;
        Thu, 19 May 2022 23:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653002260;
        bh=AF5y6oa8ZKt7Xe9rfwzsxSxjoMISZqQa/L07dw8W9CM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FO5zdIn0QW5SHYDGNQgyh74gofXSwQFuvgfhgF1cBu7I1tMPe3pWsyOKJaXNv2HdB
         +eFQkAm3/RE7Ap/+2QrH5/R9LPJp0D+tW+6jBMmhDVunTGbEWLTqEgorGxOJMoeMOG
         fJFUclBGOhSd+L9d1eUiH5UHfZZy3S6QUrt5gLdLXVJbSqS/4h/eCXslFkUbP5U3q8
         ptben4RQMc1FHVTnG874y8cxNo6alXtjMDku0ufnyfGHA6a/GnFF6jdTaWaXrMOYzK
         7JbzUe3JaQCyBXfl3BcQQAsK4kPPGECFAYrW/rFKpWtwvExpc8nOBxaaFJtjDmCKUn
         Cprx1hnyXhUWw==
Date:   Thu, 19 May 2022 16:17:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Alli <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/18] xfsprogs: Implement attr logging and replay
Message-ID: <YobQFH8O+6fY0qqs@magnolia>
References: <20220518001227.1779324-1-allison.henderson@oracle.com>
 <20220518001227.1779324-9-allison.henderson@oracle.com>
 <YoQ+RkkbPDDj0Get@magnolia>
 <8074f64681d94f506c5967869225714eeb5d9a0f.camel@oracle.com>
 <YoUmQuOAd+9mBzZH@magnolia>
 <9eaa2a04d6138bd992ac2a79768a46b8474e4f2e.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9eaa2a04d6138bd992ac2a79768a46b8474e4f2e.camel@oracle.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 19, 2022 at 04:11:10PM -0700, Alli wrote:
> On Wed, 2022-05-18 at 10:00 -0700, Darrick J. Wong wrote:
> > On Wed, May 18, 2022 at 09:38:09AM -0700, Alli wrote:
> > > On Tue, 2022-05-17 at 17:31 -0700, Darrick J. Wong wrote:
> > > > On Tue, May 17, 2022 at 05:12:17PM -0700, Allison Henderson
> > > > wrote:
> > > > > Source kernel commit: 1d08e11d04d293cb7006d1c8641be1fdd8a8e397
> > > > > 
> > > > > This patch adds the needed routines to create, log and recover
> > > > > logged
> > > > > extended attribute intents.
> > > > > 
> > > > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > > > Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > > Signed-off-by: Dave Chinner <david@fromorbit.com>
> > > > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > > > ---
> > > > >  libxfs/defer_item.c | 119
> > > > > ++++++++++++++++++++++++++++++++++++++++++++
> > > > >  libxfs/xfs_defer.c  |   1 +
> > > > >  libxfs/xfs_defer.h  |   1 +
> > > > >  libxfs/xfs_format.h |   9 +++-
> > > > >  4 files changed, 129 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
> > > > > index 1337fa5fa457..d2d12b50cce4 100644
> > > > > --- a/libxfs/defer_item.c
> > > > > +++ b/libxfs/defer_item.c
> > > > > @@ -120,6 +120,125 @@ const struct xfs_defer_op_type
> > > > > xfs_extent_free_defer_type = {
> > > > >  	.cancel_item	= xfs_extent_free_cancel_item,
> > > > >  };
> > > > >  
> > > > > +/*
> > > > > + * Performs one step of an attribute update intent and marks
> > > > > the
> > > > > attrd item
> > > > > + * dirty..  An attr operation may be a set or a remove.  Note
> > > > > that
> > > > > the
> > > > > + * transaction is marked dirty regardless of whether the
> > > > > operation
> > > > > succeeds or
> > > > > + * fails to support the ATTRI/ATTRD lifecycle rules.
> > > > > + */
> > > > > +STATIC int
> > > > > +xfs_trans_attr_finish_update(
> > > > 
> > > > This ought to have a name indicating that it's an xattr
> > > > operation,
> > > > since
> > > > defer_item.c contains stubs for what in the kernel are real
> > > > logged
> > > > operations.
> > > Sure, maybe just xfs_trans_xattr_finish_update?   Or
> > > xfs_xattr_finish_update?
> > 
> > That could work.  Or...
> > 
> > > > --D
> > > > 
> > > > > +	struct xfs_delattr_context	*dac,
> > > > > +	struct xfs_buf			**leaf_bp,
> > > > > +	uint32_t			op_flags)
> > > > > +{
> > > > > +	struct xfs_da_args		*args = dac->da_args;
> > > > > +	unsigned int			op = op_flags &
> > > > > +					     XFS_ATTR_OP_FLAGS_
> > > > > TYPE_MAS
> > > > > K;
> > > > > +	int				error;
> > > > > +
> > > > > +	switch (op) {
> > > > > +	case XFS_ATTR_OP_FLAGS_SET:
> > > > > +		error = xfs_attr_set_iter(dac, leaf_bp);
> > > > > +		break;
> > > > > +	case XFS_ATTR_OP_FLAGS_REMOVE:
> > > > > +		ASSERT(XFS_IFORK_Q(args->dp));
> > > > > +		error = xfs_attr_remove_iter(dac);
> > > > > +		break;
> > > > > +	default:
> > > > > +		error = -EFSCORRUPTED;
> > > > > +		break;
> > > > > +	}
> > 
> > ...since xfsprogs doesn't have the overhead of actually doing log
> > item
> > operations, you could just put this chunk into the _finish_item
> > function
> > directly.
> > 
> > > > > +
> > > > > +	/*
> > > > > +	 * Mark the transaction dirty, even on error. This
> > > > > ensures the
> > > > > +	 * transaction is aborted, which:
> > > > > +	 *
> > > > > +	 * 1.) releases the ATTRI and frees the ATTRD
> > > > > +	 * 2.) shuts down the filesystem
> > > > > +	 */
> > > > > +	args->trans->t_flags |= XFS_TRANS_DIRTY |
> > > > > XFS_TRANS_HAS_INTENT_DONE;
> > 
> > Also, I don't think it's necessary to mark the transaction dirty,
> > since
> > the buffers logged by xfs_attr_*_iter will do that for you.
> > 
> > I'm not sure about whether or not userspace needs to set
> > _INTENT_DONE; I
> > haven't seen the userspace port of those patches.
> 
> Ok, well it seems to run ok with out it? I dont see the other items
> setting the flags, so I suppose we are fine with out it.  Also, I am
> fine with hoisting finish_update here as long as everyone else is. 

<shrug> the other defer_item.c stubs already do that. :)

> It's not clear to me if Eric uses these, or if he has his own method
> for doing these ports.

Usually I port the libxfs parts from for-next and pull in whatever other
changes to the utilities that I can find on the list.  Later, Eric will
do the same, and then we quietly discuss the discrepancies.  Usually
Eric spends more time on his port and the resulting changes are better
thought through.

> But I mostly just wanted to build up enough of
> the infrastructure to get the new log printing working and reviewed
> since we'll need them for test cases.  Thanks!

There are *some* parts of xfs_repair that can use deferred AGFL frees,
deferred bmap intents, and deferred rmap intents.  I think that's it
though.

--D

> Allison  
> > 
> > --D
> > 
> > > > > +
> > > > > +	return error;
> > > > > +}
> > > > > +
> > > > > +/* Get an ATTRI. */
> > > > > +static struct xfs_log_item *
> > > > > +xfs_attr_create_intent(
> > > > > +	struct xfs_trans		*tp,
> > > > > +	struct list_head		*items,
> > > > > +	unsigned int			count,
> > > > > +	bool				sort)
> > > > > +{
> > > > > +	return NULL;
> > > > > +}
> > > > > +
> > > > > +/* Abort all pending ATTRs. */
> > > > > +STATIC void
> > > > > +xfs_attr_abort_intent(
> > > > > +	struct xfs_log_item		*intent)
> > > > > +{
> > > > > +}
> > > > > +
> > > > > +/* Get an ATTRD so we can process all the attrs. */
> > > > > +static struct xfs_log_item *
> > > > > +xfs_attr_create_done(
> > > > > +	struct xfs_trans		*tp,
> > > > > +	struct xfs_log_item		*intent,
> > > > > +	unsigned int			count)
> > > > > +{
> > > > > +	return NULL;
> > > > > +}
> > > > > +
> > > > > +/* Process an attr. */
> > > > > +STATIC int
> > > > > +xfs_attr_finish_item(
> > > > > +	struct xfs_trans		*tp,
> > > > > +	struct xfs_log_item		*done,
> > > > > +	struct list_head		*item,
> > > > > +	struct xfs_btree_cur		**state)
> > > > > +{
> > > > > +	struct xfs_attr_item		*attr;
> > > > > +	int				error;
> > > > > +	struct xfs_delattr_context	*dac;
> > > > > +
> > > > > +	attr = container_of(item, struct xfs_attr_item,
> > > > > xattri_list);
> > > > > +	dac = &attr->xattri_dac;
> > > > > +
> > > > > +	/*
> > > > > +	 * Always reset trans after EAGAIN cycle
> > > > > +	 * since the transaction is new
> > > > > +	 */
> > > > > +	dac->da_args->trans = tp;
> > > > > +
> > > > > +	error = xfs_trans_attr_finish_update(dac, &dac-
> > > > > >leaf_bp,
> > > > > +					     attr-
> > > > > >xattri_op_flags);
> > > > > +	if (error != -EAGAIN)
> > > > > +		kmem_free(attr);
> > > > > +
> > > > > +	return error;
> > > > > +}
> > > > > +
> > > > > +/* Cancel an attr */
> > > > > +STATIC void
> > > > > +xfs_attr_cancel_item(
> > > > > +	struct list_head		*item)
> > > > > +{
> > > > > +	struct xfs_attr_item		*attr;
> > > > > +
> > > > > +	attr = container_of(item, struct xfs_attr_item,
> > > > > xattri_list);
> > > > > +	kmem_free(attr);
> > > > > +}
> > > > > +
> > > > > +const struct xfs_defer_op_type xfs_attr_defer_type = {
> > > > > +	.max_items	= 1,
> > > > > +	.create_intent	= xfs_attr_create_intent,
> > > > > +	.abort_intent	= xfs_attr_abort_intent,
> > > > > +	.create_done	= xfs_attr_create_done,
> > > > > +	.finish_item	= xfs_attr_finish_item,
> > > > > +	.cancel_item	= xfs_attr_cancel_item,
> > > > > +};
> > > > > +
> > > > >  /*
> > > > >   * AGFL blocks are accounted differently in the reserve pools
> > > > > and
> > > > > are not
> > > > >   * inserted into the busy extent list.
> > > > > diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
> > > > > index 3a2576c14ee9..259ae39f90b5 100644
> > > > > --- a/libxfs/xfs_defer.c
> > > > > +++ b/libxfs/xfs_defer.c
> > > > > @@ -180,6 +180,7 @@ static const struct xfs_defer_op_type
> > > > > *defer_op_types[] = {
> > > > >  	[XFS_DEFER_OPS_TYPE_RMAP]	=
> > > > > &xfs_rmap_update_defer_type,
> > > > >  	[XFS_DEFER_OPS_TYPE_FREE]	=
> > > > > &xfs_extent_free_defer_type,
> > > > >  	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	=
> > > > > &xfs_agfl_free_defer_type,
> > > > > +	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
> > > > >  };
> > > > >  
> > > > >  static bool
> > > > > diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
> > > > > index c3a540345fae..f18494c0d791 100644
> > > > > --- a/libxfs/xfs_defer.h
> > > > > +++ b/libxfs/xfs_defer.h
> > > > > @@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
> > > > >  	XFS_DEFER_OPS_TYPE_RMAP,
> > > > >  	XFS_DEFER_OPS_TYPE_FREE,
> > > > >  	XFS_DEFER_OPS_TYPE_AGFL_FREE,
> > > > > +	XFS_DEFER_OPS_TYPE_ATTR,
> > > > >  	XFS_DEFER_OPS_TYPE_MAX,
> > > > >  };
> > > > >  
> > > > > diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
> > > > > index d665c04e69dd..302b50bc5830 100644
> > > > > --- a/libxfs/xfs_format.h
> > > > > +++ b/libxfs/xfs_format.h
> > > > > @@ -388,7 +388,9 @@ xfs_sb_has_incompat_feature(
> > > > >  	return (sbp->sb_features_incompat & feature) != 0;
> > > > >  }
> > > > >  
> > > > > -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
> > > > > +#define XFS_SB_FEAT_INCOMPAT_LOG_XATTRS   (1 << 0)	/*
> > > > > Delayed
> > > > > Attributes */
> > > > > +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
> > > > > +	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
> > > > >  #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_IN
> > > > > COMPAT_L
> > > > > OG_ALL
> > > > >  static inline bool
> > > > >  xfs_sb_has_incompat_log_feature(
> > > > > @@ -413,6 +415,11 @@ xfs_sb_add_incompat_log_features(
> > > > >  	sbp->sb_features_log_incompat |= features;
> > > > >  }
> > > > >  
> > > > > +static inline bool xfs_sb_version_haslogxattrs(struct xfs_sb
> > > > > *sbp)
> > > > > +{
> > > > > +	return xfs_sb_is_v5(sbp) && (sbp-
> > > > > >sb_features_log_incompat &
> > > > > +		 XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
> > > > > +}
> > > > >  
> > > > >  static inline bool
> > > > >  xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
> > > > > -- 
> > > > > 2.25.1
> > > > > 
> 
