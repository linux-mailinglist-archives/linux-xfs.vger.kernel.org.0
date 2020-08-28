Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E67255375
	for <lists+linux-xfs@lfdr.de>; Fri, 28 Aug 2020 06:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbgH1EIj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Aug 2020 00:08:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38312 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgH1EIg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Aug 2020 00:08:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S412Mc025791;
        Fri, 28 Aug 2020 04:08:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=hAUqByWKYQ9JXw8XsmPN0S2yUt331wuwYEEo/Rzuyp0=;
 b=QbmdpW141wyHDTmbMcMGCNkasL39UHSjI6WMfBg9D1whD0B2HAtxanQo7ShXYOsd1Pkt
 y77CrxI0ISLa3ALovV3AdAJb+GDgjaIMDq+gxWaV0VU81UnechAUOABOZ4s1WL5cGwZG
 dMUr4n+qlILmN2tIouK3L6Gi+2+k9Mt2Uq7UaiWVW9pND1RRsARzJp9MekgFjmRpQDzF
 hUmDqGOkXXWjC3Xy/Zjv2y8jXLFL7Wk7pjT5KrUbwZd9SY41Vgq278SjhxES6HA1JQxs
 AWFxjXM+OCVjj/G9sOhot2Y0yrfCTvCO6EThAAlVxlW0KXMgwpmP0V4KbcKUd6yqHYB6 aQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 336ht3hvtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 28 Aug 2020 04:08:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07S40vl2085724;
        Fri, 28 Aug 2020 04:08:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 333r9p757c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 04:08:17 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07S48H1e031445;
        Fri, 28 Aug 2020 04:08:17 GMT
Received: from [192.168.1.226] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 21:08:17 -0700
Subject: Re: [PATCH 02/11] xfs: refactor quota expiration timer modification
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com,
        hch@infradead.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847951097.2601708.4996467759505702991.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <614b6621-bd67-a19a-3b2d-1c96d5c23a8d@oracle.com>
Date:   Thu, 27 Aug 2020 21:08:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159847951097.2601708.4996467759505702991.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008280032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1011 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008280032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/26/20 3:05 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Define explicit limits on the range of quota grace period expiration
> timeouts and refactor the code that modifies the timeouts into helpers
> that clamp the values appropriately.  Note that we'll refactor the
> default grace period timer separately.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Ok, looks ok
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_format.h |   24 ++++++++++++++++++++++++
>   fs/xfs/xfs_dquot.c         |   22 ++++++++++++++++++----
>   fs/xfs/xfs_dquot.h         |    2 ++
>   fs/xfs/xfs_qm.c            |    2 ++
>   fs/xfs/xfs_qm.h            |    4 ++++
>   fs/xfs/xfs_qm_syscalls.c   |   16 +++++++++++-----
>   6 files changed, 61 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index e57360a8fd16..cb316053d3db 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1199,6 +1199,30 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>   
>   #define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK)
>   
> +/*
> + * XFS Quota Timers
> + * ================
> + *
> + * Traditional quota grace period expiration timers are an unsigned 32-bit
> + * seconds counter; time zero is the Unix epoch, Jan  1 00:00:01 UTC 1970.
> + * Note that an expiration value of zero means that the quota limit has not
> + * been reached, and therefore no expiration has been set.  Therefore, the
> + * ondisk min and max defined here can be used directly to constrain the incore
> + * quota expiration timestamps on a Unix system.
> + */
> +
> +/*
> + * Smallest possible ondisk quota expiration value with traditional timestamps.
> + * This corresponds exactly with the incore expiration Jan  1 00:00:01 UTC 1970.
> + */
> +#define XFS_DQ_LEGACY_EXPIRY_MIN	((int64_t)1)
> +
> +/*
> + * Largest possible ondisk quota expiration value with traditional timestamps.
> + * This corresponds exactly with the incore expiration Feb  7 06:28:15 UTC 2106.
> + */
> +#define XFS_DQ_LEGACY_EXPIRY_MAX	((int64_t)U32_MAX)
> +
>   /*
>    * This is the main portion of the on-disk representation of quota information
>    * for a user.  We pad this with some more expansion room to construct the on
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index bcd73b9c2994..f34841f98d44 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -98,12 +98,25 @@ xfs_qm_adjust_dqlimits(
>   		xfs_dquot_set_prealloc_limits(dq);
>   }
>   
> +/* Set the expiration time of a quota's grace period. */
> +time64_t
> +xfs_dquot_set_timeout(
> +	struct xfs_mount	*mp,
> +	time64_t		timeout)
> +{
> +	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> +
> +	return clamp_t(time64_t, timeout, qi->qi_expiry_min,
> +					  qi->qi_expiry_max);
> +}
> +
>   /*
>    * Determine if this quota counter is over either limit and set the quota
>    * timers as appropriate.
>    */
>   static inline void
>   xfs_qm_adjust_res_timer(
> +	struct xfs_mount	*mp,
>   	struct xfs_dquot_res	*res,
>   	struct xfs_quota_limits	*qlim)
>   {
> @@ -112,7 +125,8 @@ xfs_qm_adjust_res_timer(
>   	if ((res->softlimit && res->count > res->softlimit) ||
>   	    (res->hardlimit && res->count > res->hardlimit)) {
>   		if (res->timer == 0)
> -			res->timer = ktime_get_real_seconds() + qlim->time;
> +			res->timer = xfs_dquot_set_timeout(mp,
> +					ktime_get_real_seconds() + qlim->time);
>   	} else {
>   		if (res->timer == 0)
>   			res->warnings = 0;
> @@ -145,9 +159,9 @@ xfs_qm_adjust_dqtimers(
>   	ASSERT(dq->q_id);
>   	defq = xfs_get_defquota(qi, xfs_dquot_type(dq));
>   
> -	xfs_qm_adjust_res_timer(&dq->q_blk, &defq->blk);
> -	xfs_qm_adjust_res_timer(&dq->q_ino, &defq->ino);
> -	xfs_qm_adjust_res_timer(&dq->q_rtb, &defq->rtb);
> +	xfs_qm_adjust_res_timer(dq->q_mount, &dq->q_blk, &defq->blk);
> +	xfs_qm_adjust_res_timer(dq->q_mount, &dq->q_ino, &defq->ino);
> +	xfs_qm_adjust_res_timer(dq->q_mount, &dq->q_rtb, &defq->rtb);
>   }
>   
>   /*
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 282a65da93c7..0e449101c861 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -237,4 +237,6 @@ typedef int (*xfs_qm_dqiterate_fn)(struct xfs_dquot *dq,
>   int xfs_qm_dqiterate(struct xfs_mount *mp, xfs_dqtype_t type,
>   		xfs_qm_dqiterate_fn iter_fn, void *priv);
>   
> +time64_t xfs_dquot_set_timeout(struct xfs_mount *mp, time64_t timeout);
> +
>   #endif /* __XFS_DQUOT_H__ */
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index be67570badf8..b83a12ecfc35 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -661,6 +661,8 @@ xfs_qm_init_quotainfo(
>   	/* Precalc some constants */
>   	qinf->qi_dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
>   	qinf->qi_dqperchunk = xfs_calc_dquots_per_chunk(qinf->qi_dqchunklen);
> +	qinf->qi_expiry_min = XFS_DQ_LEGACY_EXPIRY_MIN;
> +	qinf->qi_expiry_max = XFS_DQ_LEGACY_EXPIRY_MAX;
>   
>   	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
>   
> diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
> index 9c078c35d924..e3dabab44097 100644
> --- a/fs/xfs/xfs_qm.h
> +++ b/fs/xfs/xfs_qm.h
> @@ -65,6 +65,10 @@ struct xfs_quotainfo {
>   	struct xfs_def_quota	qi_grp_default;
>   	struct xfs_def_quota	qi_prj_default;
>   	struct shrinker		qi_shrinker;
> +
> +	/* Minimum and maximum quota expiration timestamp values. */
> +	time64_t		qi_expiry_min;
> +	time64_t		qi_expiry_max;
>   };
>   
>   static inline struct radix_tree_root *
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 1c542b4a5220..750f775ae915 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -479,13 +479,19 @@ xfs_setqlim_warns(
>   
>   static inline void
>   xfs_setqlim_timer(
> +	struct xfs_mount	*mp,
>   	struct xfs_dquot_res	*res,
>   	struct xfs_quota_limits	*qlim,
>   	s64			timer)
>   {
> -	res->timer = timer;
> -	if (qlim)
> +	if (qlim) {
> +		/* Set the length of the default grace period. */
> +		res->timer = timer;
>   		qlim->time = timer;
> +	} else {
> +		/* Set the grace period expiration on a quota. */
> +		res->timer = xfs_dquot_set_timeout(mp, timer);
> +	}
>   }
>   
>   /*
> @@ -574,7 +580,7 @@ xfs_qm_scall_setqlim(
>   	if (newlim->d_fieldmask & QC_SPC_WARNS)
>   		xfs_setqlim_warns(res, qlim, newlim->d_spc_warns);
>   	if (newlim->d_fieldmask & QC_SPC_TIMER)
> -		xfs_setqlim_timer(res, qlim, newlim->d_spc_timer);
> +		xfs_setqlim_timer(mp, res, qlim, newlim->d_spc_timer);
>   
>   	/* Blocks on the realtime device. */
>   	hard = (newlim->d_fieldmask & QC_RT_SPC_HARD) ?
> @@ -590,7 +596,7 @@ xfs_qm_scall_setqlim(
>   	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
>   		xfs_setqlim_warns(res, qlim, newlim->d_rt_spc_warns);
>   	if (newlim->d_fieldmask & QC_RT_SPC_TIMER)
> -		xfs_setqlim_timer(res, qlim, newlim->d_rt_spc_timer);
> +		xfs_setqlim_timer(mp, res, qlim, newlim->d_rt_spc_timer);
>   
>   	/* Inodes */
>   	hard = (newlim->d_fieldmask & QC_INO_HARD) ?
> @@ -606,7 +612,7 @@ xfs_qm_scall_setqlim(
>   	if (newlim->d_fieldmask & QC_INO_WARNS)
>   		xfs_setqlim_warns(res, qlim, newlim->d_ino_warns);
>   	if (newlim->d_fieldmask & QC_INO_TIMER)
> -		xfs_setqlim_timer(res, qlim, newlim->d_ino_timer);
> +		xfs_setqlim_timer(mp, res, qlim, newlim->d_ino_timer);
>   
>   	if (id != 0) {
>   		/*
> 
