Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0465E21FAF
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 23:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfEQVhQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 17:37:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:35942 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfEQVhP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 17:37:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4HLSvtU029646;
        Fri, 17 May 2019 21:36:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=vmfuDHWSAT0cWUzSurMNVOISwPttPxr3C1qsN+aaizk=;
 b=y4BhtuUuKaBqcVaRpVMdYh3rGpuaVnsTvVGokd5vlCQr8xNobhWnoOct2UypgqGS2Msu
 3Mdxzh86IXXAKyypwO8/N0dzhWk+5MldH7okerC90lOCb5XLRvcc2Gjrqj7/UZ66fOvm
 mK7fbXTOhTXIvYTSWngwr2dF7MdKVoEdNm55TIlS+PyDy7PUraE7ktGM8DxADmE/E5xI
 xCVxegr3iVskLHLb5uqS4AQ7Vb/2gmi9RnI/7dVUc0SvTm0SsVyn5NbS2jkn7iqZZROa
 WDc1RXKPRXXhmOr4P4QPGBQ+2plfEUCw9bPjlBs6n6P4FAlX2Py3w8TEkubv/gUbU1fw PA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2sdkweccju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 21:36:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4HLaJQu113376;
        Fri, 17 May 2019 21:36:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2sgkx4wu1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 21:36:52 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4HLapk1028956;
        Fri, 17 May 2019 21:36:51 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 May 2019 21:36:51 +0000
Subject: Re: [PATCH 4/3] libxfs: Remove XACT_DEBUG #ifdefs
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
 <0266b879-a0a6-2788-72c2-d3fd94e755e1@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <0b4b7122-82fd-d2e6-c4b2-4d920a653c5d@oracle.com>
Date:   Fri, 17 May 2019 14:36:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <0266b879-a0a6-2788-72c2-d3fd94e755e1@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9260 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905170128
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9260 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905170128
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/16/19 1:38 PM, Eric Sandeen wrote:
> Remove XACT_DEBUG #ifdefs to reduce more cosmetic differences
> between userspace & kernelspace libxfs.  Add in some corresponding
> (stubbed-out) tracepoint calls.
> 
> If these are felt to be particularly useful, the tracepoint calls
> could be fleshed out to provide similar information.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok.  It seems a shame to loose the extra tracing, but I confess 
most of the time when I'm chasing a particular bug I end up adding my 
own temporary traces anyway.  So I think trying to synchronize the code 
spaces is more important.  Do you think the stubs might be something to 
add to the kernel space side too?

Allison

> ---
>   include/xfs_trace.h | 13 +++++++
>   libxfs/trans.c      | 85 ++++++++++++---------------------------------
>   2 files changed, 35 insertions(+), 63 deletions(-)
> 
> diff --git a/include/xfs_trace.h b/include/xfs_trace.h
> index 793ac56e..43720040 100644
> --- a/include/xfs_trace.h
> +++ b/include/xfs_trace.h
> @@ -161,6 +161,19 @@
>   #define trace_xfs_perag_get_tag(a,b,c,d) ((c) = (c))
>   #define trace_xfs_perag_put(a,b,c,d)	((c) = (c))
>   
> +#define trace_xfs_trans_alloc(a,b)		((void) 0)
> +#define trace_xfs_trans_cancel(a,b)		((void) 0)
> +#define trace_xfs_trans_brelse(a)		((void) 0)
> +#define trace_xfs_trans_binval(a)		((void) 0)
> +#define trace_xfs_trans_bjoin(a)		((void) 0)
> +#define trace_xfs_trans_bhold(a)		((void) 0)
> +#define trace_xfs_trans_get_buf(a)		((void) 0)
> +#define trace_xfs_trans_getsb_recur(a)		((void) 0)
> +#define trace_xfs_trans_getsb(a)		((void) 0)
> +#define trace_xfs_trans_read_buf_recur(a)	((void) 0)
> +#define trace_xfs_trans_read_buf(a)		((void) 0)
> +#define trace_xfs_trans_commit(a,b)		((void) 0)
> +
>   #define trace_xfs_defer_cancel(a,b)		((void) 0)
>   #define trace_xfs_defer_pending_commit(a,b)	((void) 0)
>   #define trace_xfs_defer_pending_abort(a,b)	((void) 0)
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 9e49def0..6967a1de 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -18,6 +18,7 @@
>   #include "xfs_trans.h"
>   #include "xfs_sb.h"
>   #include "xfs_defer.h"
> +#include "xfs_trace.h"
>   
>   static void xfs_trans_free_items(struct xfs_trans *tp);
>   STATIC struct xfs_trans *xfs_trans_dup(struct xfs_trans *tp);
> @@ -269,9 +270,9 @@ xfs_trans_alloc(
>   		xfs_trans_cancel(tp);
>   		return error;
>   	}
> -#ifdef XACT_DEBUG
> -	fprintf(stderr, "allocated new transaction %p\n", tp);
> -#endif
> +
> +	trace_xfs_trans_alloc(tp, _RET_IP_);
> +
>   	*tpp = tp;
>   	return 0;
>   }
> @@ -317,23 +318,16 @@ void
>   xfs_trans_cancel(
>   	struct xfs_trans	*tp)
>   {
> -#ifdef XACT_DEBUG
> -	struct xfs_trans	*otp = tp;
> -#endif
> +	trace_xfs_trans_cancel(tp, _RET_IP_);
> +
>   	if (tp == NULL)
> -		goto out;
> +		return;
>   
>   	if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
>   		xfs_defer_cancel(tp);
>   
>   	xfs_trans_free_items(tp);
>   	xfs_trans_free(tp);
> -
> -out:
> -#ifdef XACT_DEBUG
> -	fprintf(stderr, "## cancelled transaction %p\n", otp);
> -#endif
> -	return;
>   }
>   
>   void
> @@ -353,10 +347,6 @@ xfs_trans_ijoin(
>   	iip->ili_lock_flags = lock_flags;
>   
>   	xfs_trans_add_item(tp, (xfs_log_item_t *)(iip));
> -
> -#ifdef XACT_DEBUG
> -	fprintf(stderr, "ijoin'd inode %llu, transaction %p\n", ip->i_ino, tp);
> -#endif
>   }
>   
>   void
> @@ -388,9 +378,6 @@ xfs_trans_log_inode(
>   	uint			flags)
>   {
>   	ASSERT(ip->i_itemp != NULL);
> -#ifdef XACT_DEBUG
> -	fprintf(stderr, "dirtied inode %llu, transaction %p\n", ip->i_ino, tp);
> -#endif
>   
>   	tp->t_flags |= XFS_TRANS_DIRTY;
>   	set_bit(XFS_LI_DIRTY, &ip->i_itemp->ili_item.li_flags);
> @@ -434,9 +421,6 @@ xfs_trans_dirty_buf(
>   	ASSERT(bp->b_transp == tp);
>   	ASSERT(bip != NULL);
>   
> -#ifdef XACT_DEBUG
> -	fprintf(stderr, "dirtied buffer %p, transaction %p\n", bp, tp);
> -#endif
>   	tp->t_flags |= XFS_TRANS_DIRTY;
>   	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
>   }
> @@ -501,15 +485,14 @@ xfs_trans_brelse(
>   	xfs_buf_t		*bp)
>   {
>   	xfs_buf_log_item_t	*bip;
> -#ifdef XACT_DEBUG
> -	fprintf(stderr, "released buffer %p, transaction %p\n", bp, tp);
> -#endif
>   
>   	if (tp == NULL) {
>   		ASSERT(bp->b_transp == NULL);
>   		libxfs_putbuf(bp);
>   		return;
>   	}
> +
> +	trace_xfs_trans_brelse(bip);
>   	ASSERT(bp->b_transp == tp);
>   	bip = bp->b_log_item;
>   	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
> @@ -536,13 +519,12 @@ xfs_trans_binval(
>   	xfs_buf_t		*bp)
>   {
>   	xfs_buf_log_item_t	*bip = bp->b_log_item;
> -#ifdef XACT_DEBUG
> -	fprintf(stderr, "binval'd buffer %p, transaction %p\n", bp, tp);
> -#endif
>   
>   	ASSERT(bp->b_transp == tp);
>   	ASSERT(bip != NULL);
>   
> +	trace_xfs_trans_binval(bip);
> +
>   	if (bip->bli_flags & XFS_BLI_STALE)
>   		return;
>   	XFS_BUF_UNDELAYWRITE(bp);
> @@ -563,14 +545,12 @@ xfs_trans_bjoin(
>   	xfs_buf_log_item_t	*bip;
>   
>   	ASSERT(bp->b_transp == NULL);
> -#ifdef XACT_DEBUG
> -	fprintf(stderr, "bjoin'd buffer %p, transaction %p\n", bp, tp);
> -#endif
>   
>   	xfs_buf_item_init(bp, tp->t_mountp);
>   	bip = bp->b_log_item;
>   	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
>   	bp->b_transp = tp;
> +	trace_xfs_trans_bjoin(bp->b_log_item);
>   }
>   
>   void
> @@ -582,11 +562,9 @@ xfs_trans_bhold(
>   
>   	ASSERT(bp->b_transp == tp);
>   	ASSERT(bip != NULL);
> -#ifdef XACT_DEBUG
> -	fprintf(stderr, "bhold'd buffer %p, transaction %p\n", bp, tp);
> -#endif
>   
>   	bip->bli_flags |= XFS_BLI_HOLD;
> +	trace_xfs_trans_bhold(bip);
>   }
>   
>   xfs_buf_t *
> @@ -615,13 +593,11 @@ xfs_trans_get_buf_map(
>   	bp = libxfs_getbuf_map(btp, map, nmaps, 0);
>   	if (bp == NULL)
>   		return NULL;
> -#ifdef XACT_DEBUG
> -	fprintf(stderr, "trans_get_buf buffer %p, transaction %p\n", bp, tp);
> -#endif
>   
>   	xfs_trans_bjoin(tp, bp);
>   	bip = bp->b_log_item;
>   	bip->bli_recur = 0;
> +	trace_xfs_trans_get_buf(bp->b_log_item);
>   	return bp;
>   }
>   
> @@ -644,17 +620,16 @@ xfs_trans_getsb(
>   		bip = bp->b_log_item;
>   		ASSERT(bip != NULL);
>   		bip->bli_recur++;
> +		trace_xfs_trans_getsb_recur(bip);
>   		return bp;
>   	}
>   
>   	bp = xfs_getsb(mp);
> -#ifdef XACT_DEBUG
> -	fprintf(stderr, "trans_get_sb buffer %p, transaction %p\n", bp, tp);
> -#endif
>   
>   	xfs_trans_bjoin(tp, bp);
>   	bip = bp->b_log_item;
>   	bip->bli_recur = 0;
> +	trace_xfs_trans_getsb(bp->b_log_item);
>   	return bp;
>   }
>   
> @@ -691,6 +666,7 @@ xfs_trans_read_buf_map(
>   		ASSERT(bp->b_log_item != NULL);
>   		bip = bp->b_log_item;
>   		bip->bli_recur++;
> +		trace_xfs_trans_read_buf_recur(bip);
>   		goto done;
>   	}
>   
> @@ -701,14 +677,11 @@ xfs_trans_read_buf_map(
>   	if (bp->b_error)
>   		goto out_relse;
>   
> -#ifdef XACT_DEBUG
> -	fprintf(stderr, "trans_read_buf buffer %p, transaction %p\n", bp, tp);
> -#endif
> -
>   	xfs_trans_bjoin(tp, bp);
>   	bip = bp->b_log_item;
>   	bip->bli_recur = 0;
>   done:
> +	trace_xfs_trans_read_buf(bp->b_log_item);
>   	*bpp = bp;
>   	return 0;
>   out_relse:
> @@ -824,10 +797,6 @@ inode_item_done(
>   	}
>   
>   	libxfs_writebuf(bp, 0);
> -#ifdef XACT_DEBUG
> -	fprintf(stderr, "flushing dirty inode %llu, buffer %p\n",
> -			ip->i_ino, bp);
> -#endif
>   free:
>   	xfs_inode_item_put(iip);
>   }
> @@ -845,13 +814,8 @@ buf_item_done(
>   	bp->b_transp = NULL;			/* remove xact ptr */
>   
>   	hold = (bip->bli_flags & XFS_BLI_HOLD);
> -	if (bip->bli_flags & XFS_BLI_DIRTY) {
> -#ifdef XACT_DEBUG
> -		fprintf(stderr, "flushing/staling buffer %p (hold=%d)\n",
> -			bp, hold);
> -#endif
> +	if (bip->bli_flags & XFS_BLI_DIRTY)
>   		libxfs_writebuf_int(bp, 0);
> -	}
>   
>   	bip->bli_flags &= ~XFS_BLI_HOLD;
>   	xfs_buf_item_put(bip);
> @@ -937,6 +901,8 @@ __xfs_trans_commit(
>   	struct xfs_sb		*sbp;
>   	int			error = 0;
>   
> +	trace_xfs_trans_commit(tp, _RET_IP_);
> +
>   	if (tp == NULL)
>   		return 0;
>   
> @@ -952,12 +918,8 @@ __xfs_trans_commit(
>   			goto out_unreserve;
>   	}
>   
> -	if (!(tp->t_flags & XFS_TRANS_DIRTY)) {
> -#ifdef XACT_DEBUG
> -		fprintf(stderr, "committed clean transaction %p\n", tp);
> -#endif
> +	if (!(tp->t_flags & XFS_TRANS_DIRTY))
>   		goto out_unreserve;
> -	}
>   
>   	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
>   		sbp = &(tp->t_mountp->m_sb);
> @@ -972,9 +934,6 @@ __xfs_trans_commit(
>   		xfs_log_sb(tp);
>   	}
>   
> -#ifdef XACT_DEBUG
> -	fprintf(stderr, "committing dirty transaction %p\n", tp);
> -#endif
>   	trans_committed(tp);
>   
>   	/* That's it for the transaction structure.  Free it. */
> 
