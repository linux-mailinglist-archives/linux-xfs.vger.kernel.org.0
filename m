Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7303F2148AE
	for <lists+linux-xfs@lfdr.de>; Sat,  4 Jul 2020 22:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgGDUlW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 4 Jul 2020 16:41:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55440 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbgGDUlW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 4 Jul 2020 16:41:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 064KbXL5057667
        for <linux-xfs@vger.kernel.org>; Sat, 4 Jul 2020 20:41:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=3RLvv6YlqSARwMgi0T7GXR+rzKl4j7sqwGZPidIW0HA=;
 b=W1+CopM6oeqXPHZ0lNA4ALbWh63pVpjqOA6TLXj96jjwrrrBFGLRcpOSg8aN2Rmd7kZ5
 USXrMBExFi/WxQ+8yA96kV3nfqrWvR4PABzj75XehbVhEJK3lju/m3klNI8iXyv7kf+o
 9XFwpwWbVwsMk+3JKbcjDB/VIH2KZmVJ5WX5wjISjzCMjMbS/GmX62p0QCxNM3BfTM3n
 /3ciVV3omCwbzQQZZINlhbuXKvP+YZsHVH0ynEtLT/9eK5oeU0W/v+fhVMxRn6aBCUdk
 aL3kv2r+GPQYyOYnm96b4sp/k8H3fEn/LFq0mUzlQH8pR10JIcxgyiUCMkVGxR9xoeEC 5Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 322h6r1kq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 04 Jul 2020 20:41:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 064Kcvki092258
        for <linux-xfs@vger.kernel.org>; Sat, 4 Jul 2020 20:41:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 322hk1fswd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 04 Jul 2020 20:41:18 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 064KfHWE016945
        for <linux-xfs@vger.kernel.org>; Sat, 4 Jul 2020 20:41:17 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 04 Jul 2020 13:41:16 -0700
Subject: Re: [PATCH 18/18] xfs: add more dquot tracepoints
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353182503.2864738.13936001087522113609.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <7d62d283-de6c-ff30-d58d-751184af52ce@oracle.com>
Date:   Sat, 4 Jul 2020 13:41:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <159353182503.2864738.13936001087522113609.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9672 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007040146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9672 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 impostorscore=0
 cotscore=-2147483648 malwarescore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007040146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 6/30/20 8:43 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add all the xfs_dquot fields to the tracepoint for that type; add a new
> tracepoint type for the qtrx structure (dquot transaction deltas); and
> use our new tracepoints.  This makes it easier for the author to trace
> changes to dquot counters for debugging.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Alrighty, seems helpful
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_trace.h       |  140 +++++++++++++++++++++++++++++++++++++++++++++-
>   fs/xfs/xfs_trans_dquot.c |   21 +++++++
>   2 files changed, 159 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 851f97dfe9e3..35b9dfd3984f 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -36,6 +36,7 @@ struct xfs_owner_info;
>   struct xfs_trans_res;
>   struct xfs_inobt_rec_incore;
>   union xfs_btree_ptr;
> +struct xfs_dqtrx;
>   
>   #define XFS_ATTR_FILTER_FLAGS \
>   	{ XFS_ATTR_ROOT,	"ROOT" }, \
> @@ -867,37 +868,59 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
>   		__field(unsigned, flags)
>   		__field(unsigned, nrefs)
>   		__field(unsigned long long, res_bcount)
> +		__field(unsigned long long, res_rtbcount)
> +		__field(unsigned long long, res_icount)
> +
>   		__field(unsigned long long, bcount)
> +		__field(unsigned long long, rtbcount)
>   		__field(unsigned long long, icount)
> +
>   		__field(unsigned long long, blk_hardlimit)
>   		__field(unsigned long long, blk_softlimit)
> +		__field(unsigned long long, rtb_hardlimit)
> +		__field(unsigned long long, rtb_softlimit)
>   		__field(unsigned long long, ino_hardlimit)
>   		__field(unsigned long long, ino_softlimit)
> -	), \
> +	),
>   	TP_fast_assign(
>   		__entry->dev = dqp->q_mount->m_super->s_dev;
>   		__entry->id = dqp->q_id;
>   		__entry->flags = dqp->dq_flags;
>   		__entry->nrefs = dqp->q_nrefs;
> +
>   		__entry->res_bcount = dqp->q_blk.reserved;
> +		__entry->res_rtbcount = dqp->q_rtb.reserved;
> +		__entry->res_icount = dqp->q_ino.reserved;
> +
>   		__entry->bcount = dqp->q_blk.count;
> +		__entry->rtbcount = dqp->q_rtb.count;
>   		__entry->icount = dqp->q_ino.count;
> +
>   		__entry->blk_hardlimit = dqp->q_blk.hardlimit;
>   		__entry->blk_softlimit = dqp->q_blk.softlimit;
> +		__entry->rtb_hardlimit = dqp->q_rtb.hardlimit;
> +		__entry->rtb_softlimit = dqp->q_rtb.softlimit;
>   		__entry->ino_hardlimit = dqp->q_ino.hardlimit;
>   		__entry->ino_softlimit = dqp->q_ino.softlimit;
>   	),
> -	TP_printk("dev %d:%d id 0x%x flags %s nrefs %u res_bc 0x%llx "
> +	TP_printk("dev %d:%d id 0x%x flags %s nrefs %u "
> +		  "res_bc 0x%llx res_rtbc 0x%llx res_ic 0x%llx "
>   		  "bcnt 0x%llx bhardlimit 0x%llx bsoftlimit 0x%llx "
> +		  "rtbcnt 0x%llx rtbhardlimit 0x%llx rtbsoftlimit 0x%llx "
>   		  "icnt 0x%llx ihardlimit 0x%llx isoftlimit 0x%llx]",
>   		  MAJOR(__entry->dev), MINOR(__entry->dev),
>   		  __entry->id,
>   		  __print_flags(__entry->flags, "|", XFS_DQ_FLAGS),
>   		  __entry->nrefs,
>   		  __entry->res_bcount,
> +		  __entry->res_rtbcount,
> +		  __entry->res_icount,
>   		  __entry->bcount,
>   		  __entry->blk_hardlimit,
>   		  __entry->blk_softlimit,
> +		  __entry->rtbcount,
> +		  __entry->rtb_hardlimit,
> +		  __entry->rtb_softlimit,
>   		  __entry->icount,
>   		  __entry->ino_hardlimit,
>   		  __entry->ino_softlimit)
> @@ -928,6 +951,119 @@ DEFINE_DQUOT_EVENT(xfs_dqrele);
>   DEFINE_DQUOT_EVENT(xfs_dqflush);
>   DEFINE_DQUOT_EVENT(xfs_dqflush_force);
>   DEFINE_DQUOT_EVENT(xfs_dqflush_done);
> +DEFINE_DQUOT_EVENT(xfs_trans_apply_dquot_deltas_before);
> +DEFINE_DQUOT_EVENT(xfs_trans_apply_dquot_deltas_after);
> +
> +#define XFS_QMOPT_FLAGS \
> +	{ XFS_QMOPT_UQUOTA,		"UQUOTA" }, \
> +	{ XFS_QMOPT_PQUOTA,		"PQUOTA" }, \
> +	{ XFS_QMOPT_FORCE_RES,		"FORCE_RES" }, \
> +	{ XFS_QMOPT_SBVERSION,		"SBVERSION" }, \
> +	{ XFS_QMOPT_GQUOTA,		"GQUOTA" }, \
> +	{ XFS_QMOPT_INHERIT,		"INHERIT" }, \
> +	{ XFS_QMOPT_RES_REGBLKS,	"RES_REGBLKS" }, \
> +	{ XFS_QMOPT_RES_RTBLKS,		"RES_RTBLKS" }, \
> +	{ XFS_QMOPT_BCOUNT,		"BCOUNT" }, \
> +	{ XFS_QMOPT_ICOUNT,		"ICOUNT" }, \
> +	{ XFS_QMOPT_RTBCOUNT,		"RTBCOUNT" }, \
> +	{ XFS_QMOPT_DELBCOUNT,		"DELBCOUNT" }, \
> +	{ XFS_QMOPT_DELRTBCOUNT,	"DELRTBCOUNT" }, \
> +	{ XFS_QMOPT_RES_INOS,		"RES_INOS" }
> +
> +TRACE_EVENT(xfs_trans_mod_dquot,
> +	TP_PROTO(struct xfs_trans *tp, struct xfs_dquot *dqp,
> +		 unsigned int field, int64_t delta),
> +	TP_ARGS(tp, dqp, field, delta),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(unsigned int, dqflags)
> +		__field(unsigned int, dqid)
> +		__field(unsigned int, field)
> +		__field(int64_t, delta)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = tp->t_mountp->m_super->s_dev;
> +		__entry->dqflags = dqp->dq_flags;
> +		__entry->dqid = dqp->q_id;
> +		__entry->field = field;
> +		__entry->delta = delta;
> +	),
> +	TP_printk("dev %d:%d dquot %s id 0x%x %s delta %lld",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		   __print_flags(__entry->dqflags, "|", XFS_DQ_FLAGS),
> +		  __entry->dqid,
> +		   __print_flags(__entry->field, "|", XFS_QMOPT_FLAGS),
> +		  __entry->delta)
> +);
> +
> +DECLARE_EVENT_CLASS(xfs_dqtrx_class,
> +	TP_PROTO(struct xfs_dqtrx *qtrx),
> +	TP_ARGS(qtrx),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(unsigned int, dqflags)
> +		__field(u32, dqid)
> +
> +		__field(uint64_t, blk_res)
> +		__field(int64_t,  bcount_delta)
> +		__field(int64_t,  delbcnt_delta)
> +
> +		__field(uint64_t, rtblk_res)
> +		__field(uint64_t, rtblk_res_used)
> +		__field(int64_t,  rtbcount_delta)
> +		__field(int64_t,  delrtb_delta)
> +
> +		__field(uint64_t, ino_res)
> +		__field(uint64_t, ino_res_used)
> +		__field(int64_t,  icount_delta)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = qtrx->qt_dquot->q_mount->m_super->s_dev;
> +		__entry->dqflags = qtrx->qt_dquot->dq_flags;
> +		__entry->dqid = qtrx->qt_dquot->q_id;
> +
> +		__entry->blk_res = qtrx->qt_blk_res;
> +		__entry->bcount_delta = qtrx->qt_bcount_delta;
> +		__entry->delbcnt_delta = qtrx->qt_delbcnt_delta;
> +
> +		__entry->rtblk_res = qtrx->qt_rtblk_res;
> +		__entry->rtblk_res_used = qtrx->qt_rtblk_res_used;
> +		__entry->rtbcount_delta = qtrx->qt_rtbcount_delta;
> +		__entry->delrtb_delta = qtrx->qt_delrtb_delta;
> +
> +		__entry->ino_res = qtrx->qt_ino_res;
> +		__entry->ino_res_used = qtrx->qt_ino_res_used;
> +		__entry->icount_delta = qtrx->qt_icount_delta;
> +	),
> +	TP_printk("dev %d:%d dquot %s id 0x%x "
> +		  "blk_res %llu bcount_delta %lld delbcnt_delta %lld "
> +		  "rtblk_res %llu rtblk_res_used %llu rtbcount_delta %lld delrtb_delta %lld "
> +		  "ino_res %llu ino_res_used %llu icount_delta %lld",
> +		MAJOR(__entry->dev), MINOR(__entry->dev),
> +		__print_flags(__entry->dqflags, "|", XFS_DQ_FLAGS),
> +		__entry->dqid,
> +
> +		__entry->blk_res,
> +		__entry->bcount_delta,
> +		__entry->delbcnt_delta,
> +
> +		__entry->rtblk_res,
> +		__entry->rtblk_res_used,
> +		__entry->rtbcount_delta,
> +		__entry->delrtb_delta,
> +
> +		__entry->ino_res,
> +		__entry->ino_res_used,
> +		__entry->icount_delta)
> +)
> +
> +#define DEFINE_DQTRX_EVENT(name) \
> +DEFINE_EVENT(xfs_dqtrx_class, name, \
> +	TP_PROTO(struct xfs_dqtrx *qtrx), \
> +	TP_ARGS(qtrx))
> +DEFINE_DQTRX_EVENT(xfs_trans_apply_dquot_deltas);
> +DEFINE_DQTRX_EVENT(xfs_trans_mod_dquot_before);
> +DEFINE_DQTRX_EVENT(xfs_trans_mod_dquot_after);
>   
>   DECLARE_EVENT_CLASS(xfs_loggrant_class,
>   	TP_PROTO(struct xlog *log, struct xlog_ticket *tic),
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 701923ea6c04..5689d9f1b748 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -15,6 +15,7 @@
>   #include "xfs_trans_priv.h"
>   #include "xfs_quota.h"
>   #include "xfs_qm.h"
> +#include "xfs_trace.h"
>   
>   STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
>   
> @@ -203,6 +204,11 @@ xfs_trans_mod_dquot(
>   	if (qtrx->qt_dquot == NULL)
>   		qtrx->qt_dquot = dqp;
>   
> +	if (delta) {
> +		trace_xfs_trans_mod_dquot_before(qtrx);
> +		trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
> +	}
> +
>   	switch (field) {
>   
>   		/*
> @@ -266,6 +272,10 @@ xfs_trans_mod_dquot(
>   	      default:
>   		ASSERT(0);
>   	}
> +
> +	if (delta)
> +		trace_xfs_trans_mod_dquot_after(qtrx);
> +
>   	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
>   }
>   
> @@ -391,6 +401,13 @@ xfs_trans_apply_dquot_deltas(
>   				qtrx->qt_delbcnt_delta;
>   			totalrtbdelta = qtrx->qt_rtbcount_delta +
>   				qtrx->qt_delrtb_delta;
> +
> +			if (totalbdelta != 0 || totalrtbdelta != 0 ||
> +			    qtrx->qt_icount_delta != 0) {
> +				trace_xfs_trans_apply_dquot_deltas_before(dqp);
> +				trace_xfs_trans_apply_dquot_deltas(qtrx);
> +			}
> +
>   #ifdef DEBUG
>   			if (totalbdelta < 0)
>   				ASSERT(dqp->q_blk.count >= -totalbdelta);
> @@ -410,6 +427,10 @@ xfs_trans_apply_dquot_deltas(
>   			if (totalrtbdelta)
>   				dqp->q_rtb.count += totalrtbdelta;
>   
> +			if (totalbdelta != 0 || totalrtbdelta != 0 ||
> +			    qtrx->qt_icount_delta != 0)
> +				trace_xfs_trans_apply_dquot_deltas_after(dqp);
> +
>   			/*
>   			 * Get any default limits in use.
>   			 * Start/reset the timer(s) if needed.
> 
