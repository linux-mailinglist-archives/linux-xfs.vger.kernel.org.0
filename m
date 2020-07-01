Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8C2211428
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Jul 2020 22:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgGAUQK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Jul 2020 16:16:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47490 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGAUQK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 16:16:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061K8FZW188280
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jul 2020 20:16:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=J4E5NJ35Ch07SHoImXVxFql+bDALgyuU/t5rLPUDM4M=;
 b=nyJHibHHIVxGiw4Yjc0MAeLMVuR37DxpassmxFscKfD/APfQLEOi4xlVZJQGwBs0Y2jJ
 PZABPvOwrij8HJClHf8szCFY7cE249wl3DsCexHWAlApdUvqAuXPFX9KlqB8Csd/ZTkT
 sUE3pCQ1lg9wxKTEuTfjLxPkBjdnGeeH5G+FbPVtr9ToZXo3npvEoigHnWFCR7x5CNtJ
 9wgvh4UFegWtcndcwbFy2r4p2GRMfvuTyTJ8frOx6FSEDU/X5aAbi/cpeztaqPQ2det8
 eiESYmgXmc7hNHnDnvsPgN1XAAAHmZcj9u3eEHgXiW+Am4/rtliX8wcHzxjiYfsRli41 Mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31wxrncq9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2020 20:16:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061KClFE155195
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jul 2020 20:16:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31xg175wtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2020 20:16:07 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 061KG6fL026150
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jul 2020 20:16:06 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 20:16:06 +0000
Subject: Re: [PATCH 06/18] xfs: use a per-resource struct for incore dquot
 data
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353174945.2864738.16786596402939892293.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <0bb535ba-3ec8-344c-a8d8-6d878e584604@oracle.com>
Date:   Wed, 1 Jul 2020 13:16:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <159353174945.2864738.16786596402939892293.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007010142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/30/20 8:42 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce a new struct xfs_dquot_res that we'll use to track all the
> incore data for a particular resource type (block, inode, rt block).
> This will help us (once we've eliminated q_core) to declutter quota
> functions that currently open-code field access or pass around fields
> around explicitly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Looks ok
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_dquot.c       |    6 +++---
>   fs/xfs/xfs_dquot.h       |   18 +++++++++++-------
>   fs/xfs/xfs_iomap.c       |    6 +++---
>   fs/xfs/xfs_qm.c          |    6 +++---
>   fs/xfs/xfs_qm_bhv.c      |    8 ++++----
>   fs/xfs/xfs_qm_syscalls.c |    6 +++---
>   fs/xfs/xfs_trace.h       |    2 +-
>   fs/xfs/xfs_trans_dquot.c |   42 +++++++++++++++++++++---------------------
>   8 files changed, 49 insertions(+), 45 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 76b35888e726..03624a8f0566 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -552,9 +552,9 @@ xfs_dquot_from_disk(
>   	 * Reservation counters are defined as reservation plus current usage
>   	 * to avoid having to add every time.
>   	 */
> -	dqp->q_res_bcount = be64_to_cpu(ddqp->d_bcount);
> -	dqp->q_res_icount = be64_to_cpu(ddqp->d_icount);
> -	dqp->q_res_rtbcount = be64_to_cpu(ddqp->d_rtbcount);
> +	dqp->q_blk.reserved = be64_to_cpu(ddqp->d_bcount);
> +	dqp->q_ino.reserved = be64_to_cpu(ddqp->d_icount);
> +	dqp->q_rtb.reserved = be64_to_cpu(ddqp->d_rtbcount);
>   
>   	/* initialize the dquot speculative prealloc thresholds */
>   	xfs_dquot_set_prealloc_limits(dqp);
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 5ea1f1515979..cb20df1e774f 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -27,6 +27,11 @@ enum {
>   	XFS_QLOWSP_MAX
>   };
>   
> +struct xfs_dquot_res {
> +	/* Total resources allocated and reserved. */
> +	xfs_qcnt_t		reserved;
> +};
> +
>   /*
>    * The incore dquot structure
>    */
> @@ -40,14 +45,13 @@ struct xfs_dquot {
>   	xfs_daddr_t		q_blkno;
>   	xfs_fileoff_t		q_fileoffset;
>   
> +	struct xfs_dquot_res	q_blk;	/* regular blocks */
> +	struct xfs_dquot_res	q_ino;	/* inodes */
> +	struct xfs_dquot_res	q_rtb;	/* realtime blocks */
> +
>   	struct xfs_disk_dquot	q_core;
>   	struct xfs_dq_logitem	q_logitem;
> -	/* total regular nblks used+reserved */
> -	xfs_qcnt_t		q_res_bcount;
> -	/* total inos allocd+reserved */
> -	xfs_qcnt_t		q_res_icount;
> -	/* total realtime blks used+reserved */
> -	xfs_qcnt_t		q_res_rtbcount;
> +
>   	xfs_qcnt_t		q_prealloc_lo_wmark;
>   	xfs_qcnt_t		q_prealloc_hi_wmark;
>   	int64_t			q_low_space[XFS_QLOWSP_MAX];
> @@ -138,7 +142,7 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
>   {
>   	int64_t freesp;
>   
> -	freesp = be64_to_cpu(dqp->q_core.d_blk_hardlimit) - dqp->q_res_bcount;
> +	freesp = be64_to_cpu(dqp->q_core.d_blk_hardlimit) - dqp->q_blk.reserved;
>   	if (freesp < dqp->q_low_space[XFS_QLOWSP_1_PCNT])
>   		return true;
>   
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index b9a8c3798e08..f60a6e44363b 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -307,7 +307,7 @@ xfs_quota_need_throttle(
>   		return false;
>   
>   	/* under the lo watermark, no throttle */
> -	if (dq->q_res_bcount + alloc_blocks < dq->q_prealloc_lo_wmark)
> +	if (dq->q_blk.reserved + alloc_blocks < dq->q_prealloc_lo_wmark)
>   		return false;
>   
>   	return true;
> @@ -326,13 +326,13 @@ xfs_quota_calc_throttle(
>   	struct xfs_dquot *dq = xfs_inode_dquot(ip, type);
>   
>   	/* no dq, or over hi wmark, squash the prealloc completely */
> -	if (!dq || dq->q_res_bcount >= dq->q_prealloc_hi_wmark) {
> +	if (!dq || dq->q_blk.reserved >= dq->q_prealloc_hi_wmark) {
>   		*qblocks = 0;
>   		*qfreesp = 0;
>   		return;
>   	}
>   
> -	freesp = dq->q_prealloc_hi_wmark - dq->q_res_bcount;
> +	freesp = dq->q_prealloc_hi_wmark - dq->q_blk.reserved;
>   	if (freesp < dq->q_low_space[XFS_QLOWSP_5_PCNT]) {
>   		shift = 2;
>   		if (freesp < dq->q_low_space[XFS_QLOWSP_3_PCNT])
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 95e51186bd57..6ce3a4402041 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1096,14 +1096,14 @@ xfs_qm_quotacheck_dqadjust(
>   	 * resource usage.
>   	 */
>   	be64_add_cpu(&dqp->q_core.d_icount, 1);
> -	dqp->q_res_icount++;
> +	dqp->q_ino.reserved++;
>   	if (nblks) {
>   		be64_add_cpu(&dqp->q_core.d_bcount, nblks);
> -		dqp->q_res_bcount += nblks;
> +		dqp->q_blk.reserved += nblks;
>   	}
>   	if (rtblks) {
>   		be64_add_cpu(&dqp->q_core.d_rtbcount, rtblks);
> -		dqp->q_res_rtbcount += rtblks;
> +		dqp->q_rtb.reserved += rtblks;
>   	}
>   
>   	/*
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index fc2fa418919f..94b2b4b0fc17 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -29,8 +29,8 @@ xfs_fill_statvfs_from_dquot(
>   	if (limit && statp->f_blocks > limit) {
>   		statp->f_blocks = limit;
>   		statp->f_bfree = statp->f_bavail =
> -			(statp->f_blocks > dqp->q_res_bcount) ?
> -			 (statp->f_blocks - dqp->q_res_bcount) : 0;
> +			(statp->f_blocks > dqp->q_blk.reserved) ?
> +			 (statp->f_blocks - dqp->q_blk.reserved) : 0;
>   	}
>   
>   	limit = dqp->q_core.d_ino_softlimit ?
> @@ -39,8 +39,8 @@ xfs_fill_statvfs_from_dquot(
>   	if (limit && statp->f_files > limit) {
>   		statp->f_files = limit;
>   		statp->f_ffree =
> -			(statp->f_files > dqp->q_res_icount) ?
> -			 (statp->f_files - dqp->q_res_icount) : 0;
> +			(statp->f_files > dqp->q_ino.reserved) ?
> +			 (statp->f_files - dqp->q_ino.reserved) : 0;
>   	}
>   }
>   
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 90a11e7daf92..56fe80395679 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -625,8 +625,8 @@ xfs_qm_scall_getquota_fill_qc(
>   		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_blk_softlimit));
>   	dst->d_ino_hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
>   	dst->d_ino_softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
> -	dst->d_space = XFS_FSB_TO_B(mp, dqp->q_res_bcount);
> -	dst->d_ino_count = dqp->q_res_icount;
> +	dst->d_space = XFS_FSB_TO_B(mp, dqp->q_blk.reserved);
> +	dst->d_ino_count = dqp->q_ino.reserved;
>   	dst->d_spc_timer = be32_to_cpu(dqp->q_core.d_btimer);
>   	dst->d_ino_timer = be32_to_cpu(dqp->q_core.d_itimer);
>   	dst->d_ino_warns = be16_to_cpu(dqp->q_core.d_iwarns);
> @@ -635,7 +635,7 @@ xfs_qm_scall_getquota_fill_qc(
>   		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_rtb_hardlimit));
>   	dst->d_rt_spc_softlimit =
>   		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_rtb_softlimit));
> -	dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_res_rtbcount);
> +	dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_rtb.reserved);
>   	dst->d_rt_spc_timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
>   	dst->d_rt_spc_warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
>   
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 78d9dbc7614d..71567ed367f2 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -879,7 +879,7 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
>   		__entry->id = dqp->q_id;
>   		__entry->flags = dqp->dq_flags;
>   		__entry->nrefs = dqp->q_nrefs;
> -		__entry->res_bcount = dqp->q_res_bcount;
> +		__entry->res_bcount = dqp->q_blk.reserved;
>   		__entry->bcount = be64_to_cpu(dqp->q_core.d_bcount);
>   		__entry->icount = be64_to_cpu(dqp->q_core.d_icount);
>   		__entry->blk_hardlimit =
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index a2656ec6ea76..469bf7946d3d 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -409,11 +409,11 @@ xfs_trans_apply_dquot_deltas(
>   
>   				if (qtrx->qt_blk_res != blk_res_used) {
>   					if (qtrx->qt_blk_res > blk_res_used)
> -						dqp->q_res_bcount -= (xfs_qcnt_t)
> +						dqp->q_blk.reserved -= (xfs_qcnt_t)
>   							(qtrx->qt_blk_res -
>   							 blk_res_used);
>   					else
> -						dqp->q_res_bcount -= (xfs_qcnt_t)
> +						dqp->q_blk.reserved -= (xfs_qcnt_t)
>   							(blk_res_used -
>   							 qtrx->qt_blk_res);
>   				}
> @@ -426,7 +426,7 @@ xfs_trans_apply_dquot_deltas(
>   				 * deliberately skip quota reservations.
>   				 */
>   				if (qtrx->qt_bcount_delta) {
> -					dqp->q_res_bcount +=
> +					dqp->q_blk.reserved +=
>   					      (xfs_qcnt_t)qtrx->qt_bcount_delta;
>   				}
>   			}
> @@ -437,17 +437,17 @@ xfs_trans_apply_dquot_deltas(
>   				if (qtrx->qt_rtblk_res != qtrx->qt_rtblk_res_used) {
>   					if (qtrx->qt_rtblk_res >
>   					    qtrx->qt_rtblk_res_used)
> -					       dqp->q_res_rtbcount -= (xfs_qcnt_t)
> +					       dqp->q_rtb.reserved -= (xfs_qcnt_t)
>   						       (qtrx->qt_rtblk_res -
>   							qtrx->qt_rtblk_res_used);
>   					else
> -					       dqp->q_res_rtbcount -= (xfs_qcnt_t)
> +					       dqp->q_rtb.reserved -= (xfs_qcnt_t)
>   						       (qtrx->qt_rtblk_res_used -
>   							qtrx->qt_rtblk_res);
>   				}
>   			} else {
>   				if (qtrx->qt_rtbcount_delta)
> -					dqp->q_res_rtbcount +=
> +					dqp->q_rtb.reserved +=
>   					    (xfs_qcnt_t)qtrx->qt_rtbcount_delta;
>   			}
>   
> @@ -458,20 +458,20 @@ xfs_trans_apply_dquot_deltas(
>   				ASSERT(qtrx->qt_ino_res >=
>   				       qtrx->qt_ino_res_used);
>   				if (qtrx->qt_ino_res > qtrx->qt_ino_res_used)
> -					dqp->q_res_icount -= (xfs_qcnt_t)
> +					dqp->q_ino.reserved -= (xfs_qcnt_t)
>   						(qtrx->qt_ino_res -
>   						 qtrx->qt_ino_res_used);
>   			} else {
>   				if (qtrx->qt_icount_delta)
> -					dqp->q_res_icount +=
> +					dqp->q_ino.reserved +=
>   					    (xfs_qcnt_t)qtrx->qt_icount_delta;
>   			}
>   
> -			ASSERT(dqp->q_res_bcount >=
> +			ASSERT(dqp->q_blk.reserved >=
>   				be64_to_cpu(dqp->q_core.d_bcount));
> -			ASSERT(dqp->q_res_icount >=
> +			ASSERT(dqp->q_ino.reserved >=
>   				be64_to_cpu(dqp->q_core.d_icount));
> -			ASSERT(dqp->q_res_rtbcount >=
> +			ASSERT(dqp->q_rtb.reserved >=
>   				be64_to_cpu(dqp->q_core.d_rtbcount));
>   		}
>   	}
> @@ -516,7 +516,7 @@ xfs_trans_unreserve_and_mod_dquots(
>   			if (qtrx->qt_blk_res) {
>   				xfs_dqlock(dqp);
>   				locked = true;
> -				dqp->q_res_bcount -=
> +				dqp->q_blk.reserved -=
>   					(xfs_qcnt_t)qtrx->qt_blk_res;
>   			}
>   			if (qtrx->qt_ino_res) {
> @@ -524,7 +524,7 @@ xfs_trans_unreserve_and_mod_dquots(
>   					xfs_dqlock(dqp);
>   					locked = true;
>   				}
> -				dqp->q_res_icount -=
> +				dqp->q_ino.reserved -=
>   					(xfs_qcnt_t)qtrx->qt_ino_res;
>   			}
>   
> @@ -533,7 +533,7 @@ xfs_trans_unreserve_and_mod_dquots(
>   					xfs_dqlock(dqp);
>   					locked = true;
>   				}
> -				dqp->q_res_rtbcount -=
> +				dqp->q_rtb.reserved -=
>   					(xfs_qcnt_t)qtrx->qt_rtblk_res;
>   			}
>   			if (locked)
> @@ -602,7 +602,7 @@ xfs_trans_dqresv(
>   		timer = be32_to_cpu(dqp->q_core.d_btimer);
>   		warns = be16_to_cpu(dqp->q_core.d_bwarns);
>   		warnlimit = defq->bwarnlimit;
> -		resbcountp = &dqp->q_res_bcount;
> +		resbcountp = &dqp->q_blk.reserved;
>   	} else {
>   		ASSERT(flags & XFS_TRANS_DQ_RES_RTBLKS);
>   		hardlimit = be64_to_cpu(dqp->q_core.d_rtb_hardlimit);
> @@ -614,7 +614,7 @@ xfs_trans_dqresv(
>   		timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
>   		warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
>   		warnlimit = defq->rtbwarnlimit;
> -		resbcountp = &dqp->q_res_rtbcount;
> +		resbcountp = &dqp->q_rtb.reserved;
>   	}
>   
>   	if ((flags & XFS_QMOPT_FORCE_RES) == 0 && dqp->q_id &&
> @@ -675,11 +675,11 @@ xfs_trans_dqresv(
>   
>   	/*
>   	 * Change the reservation, but not the actual usage.
> -	 * Note that q_res_bcount = q_core.d_bcount + resv
> +	 * Note that q_blk.reserved = q_core.d_bcount + resv
>   	 */
>   	(*resbcountp) += (xfs_qcnt_t)nblks;
>   	if (ninos != 0)
> -		dqp->q_res_icount += (xfs_qcnt_t)ninos;
> +		dqp->q_ino.reserved += (xfs_qcnt_t)ninos;
>   
>   	/*
>   	 * note the reservation amt in the trans struct too,
> @@ -700,9 +700,9 @@ xfs_trans_dqresv(
>   					    XFS_TRANS_DQ_RES_INOS,
>   					    ninos);
>   	}
> -	ASSERT(dqp->q_res_bcount >= be64_to_cpu(dqp->q_core.d_bcount));
> -	ASSERT(dqp->q_res_rtbcount >= be64_to_cpu(dqp->q_core.d_rtbcount));
> -	ASSERT(dqp->q_res_icount >= be64_to_cpu(dqp->q_core.d_icount));
> +	ASSERT(dqp->q_blk.reserved >= be64_to_cpu(dqp->q_core.d_bcount));
> +	ASSERT(dqp->q_rtb.reserved >= be64_to_cpu(dqp->q_core.d_rtbcount));
> +	ASSERT(dqp->q_ino.reserved >= be64_to_cpu(dqp->q_core.d_icount));
>   
>   	xfs_dqunlock(dqp);
>   	return 0;
> 
