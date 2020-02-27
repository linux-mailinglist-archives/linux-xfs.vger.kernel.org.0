Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA8D172BC7
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Feb 2020 23:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbgB0Wyn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Feb 2020 17:54:43 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34956 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbgB0Wym (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 17:54:42 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RMre5S001752;
        Thu, 27 Feb 2020 22:54:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=+PNlNHT8rnWFe2go8aWUbZgYGeerrOB9ULd0D1aY638=;
 b=IZMgULe+XcyX3vSQ8kPCeodI/4AORKfrFjAg6LWrL3oHmnmtK08TDt7EpSBk03xRkUlm
 D38ssHaQHbNgy2a2Y9edgO01zmWAVzzwAH9WInk3FBCVBQDByqmV6S0D8Ol1PF/5IuVL
 TFlYdZE9rlTVgaapWxInqQZ6Re/FUSrUCLBcygdV7xmUwO3hDRh00WRuOktHTwVK5jXX
 iHrHJc1DkBj73sCx1tUdENSjT45grVIcsML49T6RSMlFWpsFs8INh1nzgysEbWkj+PR9
 x07lyFLujrMJQpD8v5f5w6vG9RIAdQechjQukV3gA6MAGKGQRY6+7eui5RRvaBRGi1M+ Yg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ydcsnp4jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 22:54:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RMmLoa129947;
        Thu, 27 Feb 2020 22:54:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ydcsb5eft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 22:54:37 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01RMsbNu029739;
        Thu, 27 Feb 2020 22:54:37 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 14:54:36 -0800
Subject: Re: [RFC v5 PATCH 5/9] xfs: automatic log item relog mechanism
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-6-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <658c83cb-22c8-6fc9-9e0e-1507cfa29d5b@oracle.com>
Date:   Thu, 27 Feb 2020 15:54:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200227134321.7238-6-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=2 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9544 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 suspectscore=2 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/27/20 6:43 AM, Brian Foster wrote:
> Now that relog reservation is available and relog state tracking is
> in place, all that remains to automatically relog items is the relog
> mechanism itself. An item with relogging enabled is basically pinned
> from writeback until relog is disabled. Instead of being written
> back, the item must instead be periodically committed in a new
> transaction to move it in the physical log. The purpose of moving
> the item is to avoid long term tail pinning and thus avoid log
> deadlocks for long running operations.
> 
> The ideal time to relog an item is in response to tail pushing
> pressure. This accommodates the current workload at any given time
> as opposed to a fixed time interval or log reservation heuristic,
> which risks performance regression. This is essentially the same
> heuristic that drives metadata writeback. XFS already implements
> various log tail pushing heuristics that attempt to keep the log
> progressing on an active fileystem under various workloads.
> 
> The act of relogging an item simply requires to add it to a
> transaction and commit. This pushes the already dirty item into a
> subsequent log checkpoint and frees up its previous location in the
> on-disk log. Joining an item to a transaction of course requires
> locking the item first, which means we have to be aware of
> type-specific locks and lock ordering wherever the relog takes
> place.
> 
> Fundamentally, this points to xfsaild as the ideal location to
> process relog enabled items. xfsaild already processes log resident
> items, is driven by log tail pushing pressure, processes arbitrary
> log item types through callbacks, and is sensitive to type-specific
> locking rules by design. The fact that automatic relogging
> essentially diverts items between writeback or relog also suggests
> xfsaild as an ideal location to process items one way or the other.
> 
> Of course, we don't want xfsaild to process transactions as it is a
> critical component of the log subsystem for driving metadata
> writeback and freeing up log space. Therefore, similar to how
> xfsaild builds up a writeback queue of dirty items and queues writes
> asynchronously, make xfsaild responsible only for directing pending
> relog items into an appropriate queue and create an async
> (workqueue) context for processing the queue. The workqueue context
> utilizes the pre-reserved relog ticket to drain the queue by rolling
> a permanent transaction.
> 
> Update the AIL pushing infrastructure to support a new RELOG item
> state. If a log item push returns the relog state, queue the item
> for relog instead of writeback. On completion of a push cycle,
> schedule the relog task at the same point metadata buffer I/O is
> submitted. This allows items to be relogged automatically under the
> same locking rules and pressure heuristics that govern metadata
> writeback.
>  > Signed-off-by: Brian Foster <bfoster@redhat.com>
Ok, I followed it through, and didn't notice any logic errors

Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> ---
>   fs/xfs/xfs_trace.h      |   1 +
>   fs/xfs/xfs_trans.h      |   1 +
>   fs/xfs/xfs_trans_ail.c  | 103 +++++++++++++++++++++++++++++++++++++++-
>   fs/xfs/xfs_trans_priv.h |   3 ++
>   4 files changed, 106 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index a066617ec54d..df0114ec66f1 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1063,6 +1063,7 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
>   DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
>   DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
>   DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
> +DEFINE_LOG_ITEM_EVENT(xfs_ail_relog);
>   DEFINE_LOG_ITEM_EVENT(xfs_relog_item);
>   DEFINE_LOG_ITEM_EVENT(xfs_relog_item_cancel);
>   
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index fc4c25b6eee4..1637df32c64c 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -99,6 +99,7 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
>   #define XFS_ITEM_PINNED		1
>   #define XFS_ITEM_LOCKED		2
>   #define XFS_ITEM_FLUSHING	3
> +#define XFS_ITEM_RELOG		4
>   
>   /*
>    * Deferred operation item relogging limits.
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index a3fb64275baa..71a47faeaae8 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -144,6 +144,75 @@ xfs_ail_max_lsn(
>   	return lsn;
>   }
>   
> +/*
> + * Relog log items on the AIL relog queue.
> + */
> +static void
> +xfs_ail_relog(
> +	struct work_struct	*work)
> +{
> +	struct xfs_ail		*ailp = container_of(work, struct xfs_ail,
> +						     ail_relog_work);
> +	struct xfs_mount	*mp = ailp->ail_mount;
> +	struct xfs_trans_res	tres = {};
> +	struct xfs_trans	*tp;
> +	struct xfs_log_item	*lip;
> +	int			error;
> +
> +	/*
> +	 * The first transaction to submit a relog item contributed relog
> +	 * reservation to the relog ticket before committing. Create an empty
> +	 * transaction and manually associate the relog ticket.
> +	 */
> +	error = xfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);
> +	ASSERT(!error);
> +	if (error)
> +		return;
> +	tp->t_log_res = M_RES(mp)->tr_relog.tr_logres;
> +	tp->t_log_count = M_RES(mp)->tr_relog.tr_logcount;
> +	tp->t_flags |= M_RES(mp)->tr_relog.tr_logflags;
> +	tp->t_ticket = xfs_log_ticket_get(ailp->ail_relog_tic);
> +
> +	spin_lock(&ailp->ail_lock);
> +	while ((lip = list_first_entry_or_null(&ailp->ail_relog_list,
> +					       struct xfs_log_item,
> +					       li_trans)) != NULL) {
> +		/*
> +		 * Drop the AIL processing ticket reference once the relog list
> +		 * is emptied. At this point it's possible for our transaction
> +		 * to hold the only reference.
> +		 */
> +		list_del_init(&lip->li_trans);
> +		if (list_empty(&ailp->ail_relog_list))
> +			xfs_log_ticket_put(ailp->ail_relog_tic);
> +		spin_unlock(&ailp->ail_lock);
> +
> +		xfs_trans_add_item(tp, lip);
> +		set_bit(XFS_LI_DIRTY, &lip->li_flags);
> +		tp->t_flags |= XFS_TRANS_DIRTY;
> +		/* XXX: include ticket owner task fix */
> +		error = xfs_trans_roll(&tp);
> +		ASSERT(!error);
> +		if (error)
> +			goto out;
> +		spin_lock(&ailp->ail_lock);
> +	}
> +	spin_unlock(&ailp->ail_lock);
> +
> +out:
> +	/* XXX: handle shutdown scenario */
> +	/*
> +	 * Drop the relog reference owned by the transaction separately because
> +	 * we don't want the cancel to release reservation if this isn't the
> +	 * final reference. The relog ticket and associated reservation needs
> +	 * to persist so long as relog items are active in the log subsystem.
> +	 */
> +	xfs_trans_ail_relog_put(mp);
> +
> +	tp->t_ticket = NULL;
> +	xfs_trans_cancel(tp);
> +}
> +
>   /*
>    * The cursor keeps track of where our current traversal is up to by tracking
>    * the next item in the list for us. However, for this to be safe, removing an
> @@ -364,7 +433,7 @@ static long
>   xfsaild_push(
>   	struct xfs_ail		*ailp)
>   {
> -	xfs_mount_t		*mp = ailp->ail_mount;
> +	struct xfs_mount	*mp = ailp->ail_mount;
>   	struct xfs_ail_cursor	cur;
>   	struct xfs_log_item	*lip;
>   	xfs_lsn_t		lsn;
> @@ -426,6 +495,23 @@ xfsaild_push(
>   			ailp->ail_last_pushed_lsn = lsn;
>   			break;
>   
> +		case XFS_ITEM_RELOG:
> +			/*
> +			 * The item requires a relog. Add to the pending relog
> +			 * list and set the relogged bit to prevent further
> +			 * relog requests. The relog bit and ticket reference
> +			 * can be dropped from the item at any point, so hold a
> +			 * relog ticket reference for the pending relog list to
> +			 * ensure the ticket stays around.
> +			 */
> +			trace_xfs_ail_relog(lip);
> +			ASSERT(list_empty(&lip->li_trans));
> +			if (list_empty(&ailp->ail_relog_list))
> +				xfs_log_ticket_get(ailp->ail_relog_tic);
> +			list_add_tail(&lip->li_trans, &ailp->ail_relog_list);
> +			set_bit(XFS_LI_RELOGGED, &lip->li_flags);
> +			break;
> +
>   		case XFS_ITEM_FLUSHING:
>   			/*
>   			 * The item or its backing buffer is already being
> @@ -492,6 +578,9 @@ xfsaild_push(
>   	if (xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list))
>   		ailp->ail_log_flush++;
>   
> +	if (!list_empty(&ailp->ail_relog_list))
> +		queue_work(ailp->ail_relog_wq, &ailp->ail_relog_work);
> +
>   	if (!count || XFS_LSN_CMP(lsn, target) >= 0) {
>   out_done:
>   		/*
> @@ -922,15 +1011,24 @@ xfs_trans_ail_init(
>   	spin_lock_init(&ailp->ail_lock);
>   	INIT_LIST_HEAD(&ailp->ail_buf_list);
>   	init_waitqueue_head(&ailp->ail_empty);
> +	INIT_LIST_HEAD(&ailp->ail_relog_list);
> +	INIT_WORK(&ailp->ail_relog_work, xfs_ail_relog);
> +
> +	ailp->ail_relog_wq = alloc_workqueue("xfs-relog/%s", WQ_FREEZABLE, 0,
> +					     mp->m_super->s_id);
> +	if (!ailp->ail_relog_wq)
> +		goto out_free_ailp;
>   
>   	ailp->ail_task = kthread_run(xfsaild, ailp, "xfsaild/%s",
>   			ailp->ail_mount->m_super->s_id);
>   	if (IS_ERR(ailp->ail_task))
> -		goto out_free_ailp;
> +		goto out_destroy_wq;
>   
>   	mp->m_ail = ailp;
>   	return 0;
>   
> +out_destroy_wq:
> +	destroy_workqueue(ailp->ail_relog_wq);
>   out_free_ailp:
>   	kmem_free(ailp);
>   	return -ENOMEM;
> @@ -944,5 +1042,6 @@ xfs_trans_ail_destroy(
>   
>   	ASSERT(ailp->ail_relog_tic == NULL);
>   	kthread_stop(ailp->ail_task);
> +	destroy_workqueue(ailp->ail_relog_wq);
>   	kmem_free(ailp);
>   }
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index d1edec1cb8ad..33a724534869 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -63,6 +63,9 @@ struct xfs_ail {
>   	int			ail_log_flush;
>   	struct list_head	ail_buf_list;
>   	wait_queue_head_t	ail_empty;
> +	struct work_struct	ail_relog_work;
> +	struct list_head	ail_relog_list;
> +	struct workqueue_struct	*ail_relog_wq;
>   	struct xlog_ticket	*ail_relog_tic;
>   };
>   
> 
