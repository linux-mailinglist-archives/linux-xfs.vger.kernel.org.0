Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D62D275C5C
	for <lists+linux-xfs@lfdr.de>; Wed, 23 Sep 2020 17:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgIWPsL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 23 Sep 2020 11:48:11 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48098 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWPsK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 11:48:10 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NFhaZD117710;
        Wed, 23 Sep 2020 15:48:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xUXoPPCVEhZk7H63JKFGHW9mEBbN4V087mxfozKinoI=;
 b=SYCMmrUm5DW3Ky9NI+o+TcsFvaK9DNtuoVgsLRm1KJJ9hmhJeIKEsHNym1K1milR4r6l
 7OmYmoyxhZsWvfW7KqYqqSGEl1254pGXI8fPUFaoOjZQ7TTmv4X0yISU+xBeiraZ01l5
 6u7YjhFAtYTFL53og3xomtI0cUlWyv/5eIqQpi/HMGNXi0u77oyPNu8xJzxYCU6NDhwO
 Z1E2KIDb2H3tEE40HUxpVrDP6FGBaaUgGZ2rVzDSCxHLAPur63jXMi12f8U61XdP8iMH
 ncdfydqe5KtxQxUI0Dnt75FGgNzRqj3a1QZcGKmPG2eTgnrqgLKxBdckeffJbzutLMnc 3g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33qcpu08bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 15:48:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NFjR4P114977;
        Wed, 23 Sep 2020 15:46:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33nux1b4e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 15:46:04 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08NFk3Q8031812;
        Wed, 23 Sep 2020 15:46:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 08:46:03 -0700
Date:   Wed, 23 Sep 2020 08:46:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: proper replay of deferred ops queued during log
 recovery
Message-ID: <20200923154602.GN7955@magnolia>
References: <160031334050.3624461.17900718410309670962.stgit@magnolia>
 <160031334683.3624461.7162765986332930241.stgit@magnolia>
 <20200923074816.GA31918@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923074816.GA31918@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=5 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230125
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 23, 2020 at 08:48:16AM +0100, Christoph Hellwig wrote:
> On Wed, Sep 16, 2020 at 08:29:07PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When we replay unfinished intent items that have been recovered from the
> > log, it's possible that the replay will cause the creation of more
> > deferred work items.  As outlined in commit 509955823cc9c ("xfs: log
> > recovery should replay deferred ops in order"), later work items have an
> > implicit ordering dependency on earlier work items.  Therefore, recovery
> > must replay the items (both recovered and created) in the same order
> > that they would have been during normal operation.
> > 
> > For log recovery, we enforce this ordering by using an empty transaction
> > to collect deferred ops that get created in the process of recovering a
> > log intent item to prevent them from being committed before the rest of
> > the recovered intent items.  After we finish committing all the
> > recovered log items, we allocate a transaction with an enormous block
> > reservation, splice our huge list of created deferred ops into that
> > transaction, and commit it, thereby finishing all those ops.
> > 
> > This is /really/ hokey -- it's the one place in XFS where we allow
> > nested transactions; the splicing of the defer ops list is is inelegant
> > and has to be done twice per recovery function; and the broken way we
> > handle inode pointers and block reservations cause subtle use-after-free
> > and allocator problems that will be fixed by this patch and the two
> > patches after it.
> > 
> > Therefore, replace the hokey empty transaction with a structure designed
> > to capture each chain of deferred ops that are created as part of
> > recovering a single unfinished log intent.  Finally, refactor the loop
> > that replays those chains to do so using one transaction per chain.
> 
> Wow, that is a massive change, but I really like the direction.
> 
> 
> > +int
> >  xfs_defer_capture(
> > +	struct xfs_trans		*tp,
> > +	struct xfs_defer_capture	**dfcp)
> >  {
> > +	struct xfs_defer_capture	*dfc = NULL;
> > +
> > +	if (!list_empty(&tp->t_dfops)) {
> > +		dfc = kmem_zalloc(sizeof(*dfc), KM_NOFS);
> > +
> > +		xfs_defer_create_intents(tp);
> > +
> > +		INIT_LIST_HEAD(&dfc->dfc_list);
> > +		INIT_LIST_HEAD(&dfc->dfc_dfops);
> > +
> > +		/* Move the dfops chain and transaction state to the freezer. */
> > +		list_splice_init(&tp->t_dfops, &dfc->dfc_dfops);
> > +		dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
> > +		xfs_defer_reset(tp);
> > +	}
> > +
> > +	*dfcp = dfc;
> > +	return xfs_trans_commit(tp);
> 
> Don't we need to free the structure if xfs_trans_commit fails?

They'll all get passed up to xlog_recover_process_intents (even with the
error code) and cancelled by xlog_cancel_defer_ops.

But you're right, this should maintain the principle of not creating
more state for callers to deal with when we're just going to error out
anyway.

> Wouldn't a saner calling convention would to pass the list_head into
> ->iop_recover and this function, and just add it to the list here
> instead of passing it around as an output pointer argument.

Sure, that works too.  I sort of hate passing around generic list_head
but I could say the same of double pointers. :)

> > +/*
> > + * Freeze any deferred ops and commit the transaction.  This is the last step
> > + * needed to finish a log intent item that we recovered from the log.
> > + */
> > +int
> > +xlog_recover_trans_commit(
> > +	struct xfs_trans		*tp,
> > +	struct xfs_defer_capture	**dfcp)
> > +{
> > +	return xfs_defer_capture(tp, dfcp);
> > +}
> 
> I don't think this wrapper is very helpful.  I think a direct call
> to xfs_defer_capture captures the intent better than pretending it just
> is another commit.

It's not particularly enlightening right now, but later (in the bmap
use-after-free series) I'll enlarge this helper to be able to stash
inodes and whatnot.  The end result is that all the log intent item
recovery functions can call this at the bottom and it'll clean up the
transaction and inodes that were used in recovery.

(Or hide them away for later.)

> > +
> >  /* Take all the collected deferred ops and finish them in order. */
> >  static int
> >  xlog_finish_defer_ops(
> > +	struct xfs_mount	*mp,
> > +	struct list_head	*dfops_freezers)
> >  {
> > +	struct xfs_defer_capture *dfc, *next;
> >  	struct xfs_trans	*tp;
> >  	int64_t			freeblks;
> > +	uint64_t		resblks;
> > +	int			error = 0;
> >  
> > +	list_for_each_entry_safe(dfc, next, dfops_freezers, dfc_list) {
> > +		/*
> > +		 * We're finishing the defer_ops that accumulated as a result
> > +		 * of recovering unfinished intent items during log recovery.
> > +		 * We reserve an itruncate transaction because it is the
> > +		 * largest permanent transaction type.  Since we're the only
> > +		 * user of the fs right now, take 93% (15/16) of the available
> > +		 * free blocks.  Use weird math to avoid a 64-bit division.
> > +		 */
> > +		freeblks = percpu_counter_sum(&mp->m_fdblocks);
> > +		if (freeblks <= 0) {
> > +			error = -ENOSPC;
> > +			break;
> > +		}
> >  
> > +		resblks = min_t(uint64_t, UINT_MAX, freeblks);
> > +		resblks = (resblks * 15) >> 4;
> > +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
> > +				0, XFS_TRANS_RESERVE, &tp);
> 
> This isn't actually new, but how did we end up with the truncate
> reservation here?

itruncate is the largest reservation, so it ended up here (and a few
other places) as a standin for "big enough to avoid failing log recovery
on a reservation overflow".

> > +		if (error)
> > +			break;
> > +
> > +		/* transfer all collected dfops to this transaction */
> > +		list_del_init(&dfc->dfc_list);
> > +		xfs_defer_continue(dfc, tp);
> > +
> > +		error = xfs_trans_commit(tp);
> > +		xfs_defer_capture_free(mp, dfc);
> > +		if (error)
> > +			break;
> 
> I'd just do direct returns and return 0 outside the loop, but that is
> just nitpicking.

Ok.

> >  /* Is this log item a deferred action intent? */
> > @@ -2528,28 +2566,16 @@ STATIC int
> >  xlog_recover_process_intents(
> >  	struct xlog		*log)
> >  {
> > +	LIST_HEAD(dfops_freezers);
> >  	struct xfs_ail_cursor	cur;
> > +	struct xfs_defer_capture *freezer = NULL;
> >  	struct xfs_log_item	*lip;
> >  	struct xfs_ail		*ailp;
> > +	int			error = 0;
> >  #if defined(DEBUG) || defined(XFS_WARN)
> >  	xfs_lsn_t		last_lsn;
> >  #endif
> >  
> >  	ailp = log->l_ailp;
> >  	spin_lock(&ailp->ail_lock);
> >  	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> > @@ -2578,26 +2604,31 @@ xlog_recover_process_intents(
> >  
> >  		/*
> >  		 * NOTE: If your intent processing routine can create more
> > +		 * deferred ops, you /must/ attach them to the freezer in
> >  		 * this routine or else those subsequent intents will get
> >  		 * replayed in the wrong order!
> >  		 */
> >  		if (!test_and_set_bit(XFS_LI_RECOVERED, &lip->li_flags)) {
> >  			spin_unlock(&ailp->ail_lock);
> > +			error = lip->li_ops->iop_recover(lip, &freezer);
> >  			spin_lock(&ailp->ail_lock);
> >  		}
> > +		if (freezer) {
> > +			list_add_tail(&freezer->dfc_list, &dfops_freezers);
> > +			freezer = NULL;
> > +		}
> >  		if (error)
> > +			break;
> > +
> >  		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> 
> The code flow looks really very odd (though correct) to me, what do you
> think of something like:
> 
>   	spin_lock(&ailp->ail_lock);
> 	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> 	     lip;
> 	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
> 		if (test_and_set_bit(XFS_LI_RECOVERED, &lip->li_flags))
> 			continue;
> 
> 		spin_unlock(&ailp->ail_lock);
> 		error = lip->li_ops->iop_recover(lip, &dfops_freezers);
> 		spin_lock(&ailp->ail_lock);
> 		if (error)
> 			break;
> 	}
>   	xfs_trans_ail_cursor_done(&cur);
>   	spin_unlock(&ailp->ail_lock);

Yeah, I like that better.  Thanks for the suggestions.

--D
