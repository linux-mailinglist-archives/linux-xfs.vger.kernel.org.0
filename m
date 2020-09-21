Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41DB272BB5
	for <lists+linux-xfs@lfdr.de>; Mon, 21 Sep 2020 18:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgIUQV6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 21 Sep 2020 12:21:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56634 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbgIUQV5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Sep 2020 12:21:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08LGIcnM075591;
        Mon, 21 Sep 2020 16:21:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=wcvq08ZbevWIp+J+yJz9oz39WGKj4jOo1Acl3n8wQb8=;
 b=nFenK/SK7tacf5yE/s9GtLoa3xVZhx4cELYUVCi3LYuYPI1O2n1JIBb/p3sXf1C1Px1n
 r8ZrGbKgk+0yCg+PVSYFZqPktzU0mQshgrEFCqZLixdjuwZ1XHjdG8ez8udf4xZj+afG
 gNufgl6eNkzBfC5XPtiNsi1MqJjdcU90r9Nwat+JVSRohcIDV/NAsSUVJXDs+bM7aUb6
 PwA6CUP+SjjANVMoZUievGX47aZfeM48lU+Pk7uyMI3hWynVyuunyaskmo2lnRMK0dYG
 0UD1czOxvgQ1WZYBSJ/YMClFm4nVtSOB1f3kRYDbf83+7c8Ac/8n/eDPwr7YaA11MK+p OA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33ndnu6qv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Sep 2020 16:21:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08LGKIMA053108;
        Mon, 21 Sep 2020 16:21:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 33nujkxs31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 16:21:51 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08LGLn1P010606;
        Mon, 21 Sep 2020 16:21:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 09:21:49 -0700
Date:   Mon, 21 Sep 2020 09:21:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/2] xfs: periodically relog deferred intent items
Message-ID: <20200921162148.GB7955@magnolia>
References: <160039574052.20335.5971639583254011729.stgit@magnolia>
 <160039575350.20335.983504069788744026.stgit@magnolia>
 <20200921125958.GA2116390@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921125958.GA2116390@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0 suspectscore=5
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009210115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9751 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=5 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009210115
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 21, 2020 at 08:59:58AM -0400, Brian Foster wrote:
> On Thu, Sep 17, 2020 at 07:22:33PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > There's a subtle design flaw in the deferred log item code that can lead
> > to pinning the log tail.  Taking up the defer ops chain examples from
> > the previous commit, we can get trapped in sequences like this:
> > 
> > Caller hands us a transaction t0 with D0-D3 attached.  The defer ops
> > chain will look like the following if the transaction rolls succeed:
> > 
> > t1: D0(t0), D1(t0), D2(t0), D3(t0)
> > t2: d4(t1), d5(t1), D1(t0), D2(t0), D3(t0)
> > t3: d5(t1), D1(t0), D2(t0), D3(t0)
> > ...
> > t9: d9(t7), D3(t0)
> > t10: D3(t0)
> > t11: d10(t10), d11(t10)
> > t12: d11(t10)
> > 
> > In transaction 9, we finish d9 and try to roll to t10 while holding onto
> > an intent item for D3 that we logged in t0.
> > 
> > The previous commit changed the order in which we place new defer ops in
> > the defer ops processing chain to reduce the maximum chain length.  Now
> > make xfs_defer_finish_noroll capable of relogging the entire chain
> > periodically so that we can always move the log tail forward.  We do
> > this every seven loops, having observed that while most chains never
> > exceed seven items in length, the rest go far over that and seem to
> > be involved in most of the stall problems.
> > 
> > Callers are now required to ensure that the transaction reservation is
> > large enough to handle logging done items and new intent items for the
> > maximum possible chain length.  Most callers are careful to keep the
> > chain lengths low, so the overhead should be minimal.
> > 
> > The decision to relog an intent item is made based on whether or not the
> > intent was added to the current checkpoint.  If so, the checkpoint is
> > still open and there's no point in relogging.  Otherwise, the old
> > checkpoint is closed and we relog the intent to add it to the current
> > one.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> ...
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 84a70edd0da1..288649ca5821 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> ...
> > @@ -361,6 +362,40 @@ xfs_defer_cancel_list(
> >  	}
> >  }
> >  
> > +/*
> > + * Prevent a log intent item from pinning the tail of the log by logging a
> > + * done item to release the intent item; and then log a new intent item.
> > + * The caller should provide a fresh transaction and roll it after we're done.
> > + */
> > +static int
> > +xfs_defer_relog(
> > +	struct xfs_trans		**tpp,
> > +	struct list_head		*dfops)
> > +{
> > +	struct xfs_defer_pending	*dfp;
> > +
> > +	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> > +
> > +	list_for_each_entry(dfp, dfops, dfp_list) {
> > +		/*
> > +		 * If the log intent item for this deferred op is in a
> > +		 * different checkpoint, relog it to keep the log tail moving
> > +		 * forward.  We're ok with this being racy because an incorrect
> > +		 * decision means we'll be a little slower at pushing the tail.
> > +		 */
> > +		if (dfp->dfp_intent == NULL ||
> > +		    xfs_log_item_in_current_chkpt(dfp->dfp_intent))
> > +			continue;
> 
> I'm curious why we'd change over to using much more crude relog logic
> from what was in the previous version..? Hmm.. I see that Dave suggested
> this approach in v1, but that was in reply to the hardcoded 'if
> (!(++nr_rolls % 7))' thing which was immediately removed in the next
> patch. Was that missed in the review feedback?

No, I got confused and thought Dave wanted me to replace all that logic
with the single call to _in_current_chkpt.  I had wondered, since it
seemed to me that we only need to relog intents if they've passed out of
the current checkpoint /and/ we've used up a lot of log space, but...

> I can certainly see favoring this logic over the roll count thing, but
> doing this over the push logic doesn't make a lot of sense to me. The
> logic isn't doesn't seem any more simple, we're calling a log helper to
> do some LSN checking in either case, but the resulting behavior seems
> far less predictable when we consider external factors such as workload
> (fsyncs?), log size, size of the op chain, etc. It also looks like we're
> now far more likely to relog the entire chain over and over in certain
> cases (as it grows) as opposed to just the intents that have been
> sitting around waiting to be processed and pinning the tail of the log.
> 
> ISTM that the ideal approach is to 1. use the push logic to determine if
> an item needs relogging in the first place and then 2. use this sort of
> checkpoint checking logic to filter out subsequent relogs once an intent
> has been relogged and committed to the CIL, but has not yet checkpointed
> to the log (and so hasn't moved on disk)... hm?

...yeah, it looks like we're in agreement, at least.  I'll re-add the
threshold checking. :)

--D

> 
> Brian
> 
> > +
> > +		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
> > +		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
> > +	}
> > +
> > +	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
> > +		return xfs_defer_trans_roll(tpp);
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Log an intent-done item for the first pending intent, and finish the work
> >   * items.
> > @@ -447,6 +482,11 @@ xfs_defer_finish_noroll(
> >  		if (error)
> >  			goto out_shutdown;
> >  
> > +		/* Every few rolls we relog all the intent items. */
> > +		error = xfs_defer_relog(tp, &dop_pending);
> > +		if (error)
> > +			goto out_shutdown;
> > +
> >  		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
> >  				       dfp_list);
> >  		error = xfs_defer_finish_one(*tp, dfp);
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index 008436ef5bce..6317fdf4a3a0 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -532,6 +532,32 @@ xfs_bui_item_match(
> >  	return BUI_ITEM(lip)->bui_format.bui_id == intent_id;
> >  }
> >  
> > +/* Relog an intent item to push the log tail forward. */
> > +static struct xfs_log_item *
> > +xfs_bui_item_relog(
> > +	struct xfs_log_item		*intent,
> > +	struct xfs_trans		*tp)
> > +{
> > +	struct xfs_bud_log_item		*budp;
> > +	struct xfs_bui_log_item		*buip;
> > +	struct xfs_map_extent		*extp;
> > +	unsigned int			count;
> > +
> > +	count = BUI_ITEM(intent)->bui_format.bui_nextents;
> > +	extp = BUI_ITEM(intent)->bui_format.bui_extents;
> > +
> > +	tp->t_flags |= XFS_TRANS_DIRTY;
> > +	budp = xfs_trans_get_bud(tp, BUI_ITEM(intent));
> > +	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
> > +
> > +	buip = xfs_bui_init(tp->t_mountp);
> > +	memcpy(buip->bui_format.bui_extents, extp, count * sizeof(*extp));
> > +	atomic_set(&buip->bui_next_extent, count);
> > +	xfs_trans_add_item(tp, &buip->bui_item);
> > +	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
> > +	return &buip->bui_item;
> > +}
> > +
> >  static const struct xfs_item_ops xfs_bui_item_ops = {
> >  	.iop_size	= xfs_bui_item_size,
> >  	.iop_format	= xfs_bui_item_format,
> > @@ -539,6 +565,7 @@ static const struct xfs_item_ops xfs_bui_item_ops = {
> >  	.iop_release	= xfs_bui_item_release,
> >  	.iop_recover	= xfs_bui_item_recover,
> >  	.iop_match	= xfs_bui_item_match,
> > +	.iop_relog	= xfs_bui_item_relog,
> >  };
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> > index 337fae015bca..30a53f3913d1 100644
> > --- a/fs/xfs/xfs_extfree_item.c
> > +++ b/fs/xfs/xfs_extfree_item.c
> > @@ -642,6 +642,34 @@ xfs_efi_item_match(
> >  	return EFI_ITEM(lip)->efi_format.efi_id == intent_id;
> >  }
> >  
> > +/* Relog an intent item to push the log tail forward. */
> > +static struct xfs_log_item *
> > +xfs_efi_item_relog(
> > +	struct xfs_log_item		*intent,
> > +	struct xfs_trans		*tp)
> > +{
> > +	struct xfs_efd_log_item		*efdp;
> > +	struct xfs_efi_log_item		*efip;
> > +	struct xfs_extent		*extp;
> > +	unsigned int			count;
> > +
> > +	count = EFI_ITEM(intent)->efi_format.efi_nextents;
> > +	extp = EFI_ITEM(intent)->efi_format.efi_extents;
> > +
> > +	tp->t_flags |= XFS_TRANS_DIRTY;
> > +	efdp = xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
> > +	efdp->efd_next_extent = count;
> > +	memcpy(efdp->efd_format.efd_extents, extp, count * sizeof(*extp));
> > +	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
> > +
> > +	efip = xfs_efi_init(tp->t_mountp, count);
> > +	memcpy(efip->efi_format.efi_extents, extp, count * sizeof(*extp));
> > +	atomic_set(&efip->efi_next_extent, count);
> > +	xfs_trans_add_item(tp, &efip->efi_item);
> > +	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
> > +	return &efip->efi_item;
> > +}
> > +
> >  static const struct xfs_item_ops xfs_efi_item_ops = {
> >  	.iop_size	= xfs_efi_item_size,
> >  	.iop_format	= xfs_efi_item_format,
> > @@ -649,6 +677,7 @@ static const struct xfs_item_ops xfs_efi_item_ops = {
> >  	.iop_release	= xfs_efi_item_release,
> >  	.iop_recover	= xfs_efi_item_recover,
> >  	.iop_match	= xfs_efi_item_match,
> > +	.iop_relog	= xfs_efi_item_relog,
> >  };
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> > index c78412755b8a..cf0205fdc607 100644
> > --- a/fs/xfs/xfs_refcount_item.c
> > +++ b/fs/xfs/xfs_refcount_item.c
> > @@ -560,6 +560,32 @@ xfs_cui_item_match(
> >  	return CUI_ITEM(lip)->cui_format.cui_id == intent_id;
> >  }
> >  
> > +/* Relog an intent item to push the log tail forward. */
> > +static struct xfs_log_item *
> > +xfs_cui_item_relog(
> > +	struct xfs_log_item		*intent,
> > +	struct xfs_trans		*tp)
> > +{
> > +	struct xfs_cud_log_item		*cudp;
> > +	struct xfs_cui_log_item		*cuip;
> > +	struct xfs_phys_extent		*extp;
> > +	unsigned int			count;
> > +
> > +	count = CUI_ITEM(intent)->cui_format.cui_nextents;
> > +	extp = CUI_ITEM(intent)->cui_format.cui_extents;
> > +
> > +	tp->t_flags |= XFS_TRANS_DIRTY;
> > +	cudp = xfs_trans_get_cud(tp, CUI_ITEM(intent));
> > +	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
> > +
> > +	cuip = xfs_cui_init(tp->t_mountp, count);
> > +	memcpy(cuip->cui_format.cui_extents, extp, count * sizeof(*extp));
> > +	atomic_set(&cuip->cui_next_extent, count);
> > +	xfs_trans_add_item(tp, &cuip->cui_item);
> > +	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
> > +	return &cuip->cui_item;
> > +}
> > +
> >  static const struct xfs_item_ops xfs_cui_item_ops = {
> >  	.iop_size	= xfs_cui_item_size,
> >  	.iop_format	= xfs_cui_item_format,
> > @@ -567,6 +593,7 @@ static const struct xfs_item_ops xfs_cui_item_ops = {
> >  	.iop_release	= xfs_cui_item_release,
> >  	.iop_recover	= xfs_cui_item_recover,
> >  	.iop_match	= xfs_cui_item_match,
> > +	.iop_relog	= xfs_cui_item_relog,
> >  };
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> > index c1a1fd62ca74..3237243d375d 100644
> > --- a/fs/xfs/xfs_rmap_item.c
> > +++ b/fs/xfs/xfs_rmap_item.c
> > @@ -583,6 +583,32 @@ xfs_rui_item_match(
> >  	return RUI_ITEM(lip)->rui_format.rui_id == intent_id;
> >  }
> >  
> > +/* Relog an intent item to push the log tail forward. */
> > +static struct xfs_log_item *
> > +xfs_rui_item_relog(
> > +	struct xfs_log_item		*intent,
> > +	struct xfs_trans		*tp)
> > +{
> > +	struct xfs_rud_log_item		*rudp;
> > +	struct xfs_rui_log_item		*ruip;
> > +	struct xfs_map_extent		*extp;
> > +	unsigned int			count;
> > +
> > +	count = RUI_ITEM(intent)->rui_format.rui_nextents;
> > +	extp = RUI_ITEM(intent)->rui_format.rui_extents;
> > +
> > +	tp->t_flags |= XFS_TRANS_DIRTY;
> > +	rudp = xfs_trans_get_rud(tp, RUI_ITEM(intent));
> > +	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
> > +
> > +	ruip = xfs_rui_init(tp->t_mountp, count);
> > +	memcpy(ruip->rui_format.rui_extents, extp, count * sizeof(*extp));
> > +	atomic_set(&ruip->rui_next_extent, count);
> > +	xfs_trans_add_item(tp, &ruip->rui_item);
> > +	set_bit(XFS_LI_DIRTY, &ruip->rui_item.li_flags);
> > +	return &ruip->rui_item;
> > +}
> > +
> >  static const struct xfs_item_ops xfs_rui_item_ops = {
> >  	.iop_size	= xfs_rui_item_size,
> >  	.iop_format	= xfs_rui_item_format,
> > @@ -590,6 +616,7 @@ static const struct xfs_item_ops xfs_rui_item_ops = {
> >  	.iop_release	= xfs_rui_item_release,
> >  	.iop_recover	= xfs_rui_item_recover,
> >  	.iop_match	= xfs_rui_item_match,
> > +	.iop_relog	= xfs_rui_item_relog,
> >  };
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index a3a35a2d8ed9..362c155be525 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -2533,6 +2533,7 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_create_intent);
> >  DEFINE_DEFER_PENDING_EVENT(xfs_defer_cancel_list);
> >  DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
> >  DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
> > +DEFINE_DEFER_PENDING_EVENT(xfs_defer_relog_intent);
> >  
> >  #define DEFINE_BMAP_FREE_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
> >  DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_defer);
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index 995c1513693c..e838e8327510 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -78,6 +78,8 @@ struct xfs_item_ops {
> >  	int (*iop_recover)(struct xfs_log_item *lip,
> >  			   struct xfs_defer_capture **dfcp);
> >  	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
> > +	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
> > +			struct xfs_trans *tp);
> >  };
> >  
> >  /*
> > @@ -239,4 +241,12 @@ void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
> >  
> >  extern kmem_zone_t	*xfs_trans_zone;
> >  
> > +static inline struct xfs_log_item *
> > +xfs_trans_item_relog(
> > +	struct xfs_log_item	*lip,
> > +	struct xfs_trans	*tp)
> > +{
> > +	return lip->li_ops->iop_relog(lip, tp);
> > +}
> > +
> >  #endif	/* __XFS_TRANS_H__ */
> > 
> 
