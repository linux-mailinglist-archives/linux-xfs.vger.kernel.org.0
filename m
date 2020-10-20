Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3CE286AB0
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Oct 2020 00:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgJGWFx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Oct 2020 18:05:53 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46932 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728649AbgJGWFw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 18:05:52 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097LmE8D137697;
        Wed, 7 Oct 2020 22:05:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=qdGKpyu4OZxeiTA6CHUVDy1/MmDPky7MC58vEE3yBus=;
 b=XAX9Ry7Sk2H+pH4XPIgVF6cxpwPdeDMYXm7PFQkVdCVHkYcUAPl13mxF7LHQ7UnaPixt
 2ls6A1OPqc8NcrtZ+SmLkOC06s9uaFqRn7HQWjw2KVDDy7xRE1gHUgQS2biHusn4ddwV
 vgltHjdzRU+cssXl2S4iNK3OkRBKMV/ylgQDwnu4PfqXVxJf0pfoJLDRBe2UyMc+kU72
 EtTem5x496vcBCem1BOtvGev4aluJvPVXU5JS01kGii0xy8piX+X9p/wC8M1diomqRTW
 dJIxAnfrlj0MEyfqhyMJxnLwJE/dot0tgNDidW3ldion4l43rCaXtETo5xDGN0PuDTRp 1Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33xetb4scg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 07 Oct 2020 22:05:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 097LoEdU132282;
        Wed, 7 Oct 2020 22:04:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33y3804knr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Oct 2020 22:04:59 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 097M4vmA007401;
        Wed, 7 Oct 2020 22:04:57 GMT
Received: from localhost (/10.159.134.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Oct 2020 15:04:57 -0700
Date:   Wed, 7 Oct 2020 15:04:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v3 4/5] xfs: check tp->t_dqinfo value instead of the
 XFS_TRANS_DQ_DIRTY flag
Message-ID: <20201007220456.GC6540@magnolia>
References: <1602082272-20242-1-git-send-email-kaixuxia@tencent.com>
 <1602082272-20242-5-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602082272-20242-5-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=3 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=3 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070139
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 07, 2020 at 10:51:11PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Nowadays the only things that the XFS_TRANS_DQ_DIRTY flag seems to do
> are indicates the tp->t_dqinfo->dqs[XFS_QM_TRANS_{USR,GRP,PRJ}] values
> changed and check in xfs_trans_apply_dquot_deltas() and the unreserve
> variant xfs_trans_unreserve_and_mod_dquots(). Actually, we also can
> use the tp->t_dqinfo value instead of the XFS_TRANS_DQ_DIRTY flag, that
> is to say, we allocate the new tp->t_dqinfo only when the qtrx values
> changed, so the tp->t_dqinfo value isn't NULL equals the XFS_TRANS_DQ_DIRTY
> flag is set, we only need to check if tp->t_dqinfo == NULL in
> xfs_trans_apply_dquot_deltas() and its unreserve variant to determine
> whether lock all of the dquots and join them to the transaction.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/libxfs/xfs_shared.h |  1 -
>  fs/xfs/xfs_inode.c         |  8 +-------
>  fs/xfs/xfs_trans_dquot.c   | 17 ++---------------
>  3 files changed, 3 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index c795ae47b3c9..8c61a461bf7b 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -62,7 +62,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>  #define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
>  #define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
>  #define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
> -#define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
>  #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
>  #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
>  #define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 49624973eecc..9108eed0ea45 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -941,7 +941,6 @@ xfs_dir_ialloc(
>  	xfs_buf_t	*ialloc_context = NULL;
>  	int		code;
>  	void		*dqinfo;
> -	uint		tflags;
>  
>  	tp = *tpp;
>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> @@ -1000,12 +999,9 @@ xfs_dir_ialloc(
>  		 * and attach it to the next transaction.
>  		 */
>  		dqinfo = NULL;
> -		tflags = 0;
>  		if (tp->t_dqinfo) {
>  			dqinfo = (void *)tp->t_dqinfo;
>  			tp->t_dqinfo = NULL;
> -			tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
> -			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
>  		}
>  
>  		code = xfs_trans_roll(&tp);
> @@ -1013,10 +1009,8 @@ xfs_dir_ialloc(
>  		/*
>  		 * Re-attach the quota info that we detached from prev trx.
>  		 */
> -		if (dqinfo) {
> +		if (dqinfo)
>  			tp->t_dqinfo = dqinfo;
> -			tp->t_flags |= tflags;
> -		}
>  
>  		if (code) {
>  			xfs_buf_relse(ialloc_context);
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 1b56065c9ff1..0ebfd7930382 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -84,13 +84,6 @@ xfs_trans_dup_dqinfo(
>  
>  	xfs_trans_alloc_dqinfo(ntp);
>  
> -	/*
> -	 * Because the quota blk reservation is carried forward,
> -	 * it is also necessary to carry forward the DQ_DIRTY flag.
> -	 */
> -	if (otp->t_flags & XFS_TRANS_DQ_DIRTY)
> -		ntp->t_flags |= XFS_TRANS_DQ_DIRTY;
> -
>  	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
>  		oqa = otp->t_dqinfo->dqs[j];
>  		nqa = ntp->t_dqinfo->dqs[j];
> @@ -270,8 +263,6 @@ xfs_trans_mod_dquot(
>  
>  	if (delta)
>  		trace_xfs_trans_mod_dquot_after(qtrx);
> -
> -	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
>  }
>  
>  
> @@ -348,7 +339,7 @@ xfs_trans_apply_dquot_deltas(
>  	int64_t			totalbdelta;
>  	int64_t			totalrtbdelta;
>  
> -	if (!(tp->t_flags & XFS_TRANS_DQ_DIRTY))
> +	if (!tp->t_dqinfo)
>  		return;
>  
>  	ASSERT(tp->t_dqinfo);
> @@ -490,7 +481,7 @@ xfs_trans_unreserve_and_mod_dquots(
>  	struct xfs_dqtrx	*qtrx, *qa;
>  	bool			locked;
>  
> -	if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
> +	if (!tp->t_dqinfo)
>  		return;
>  
>  	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
> @@ -695,7 +686,6 @@ xfs_trans_dqresv(
>  	 * because we don't have the luxury of a transaction envelope then.
>  	 */
>  	if (tp) {
> -		ASSERT(tp->t_dqinfo);
>  		ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>  		if (nblks != 0)
>  			xfs_trans_mod_dquot(tp, dqp,
> @@ -749,9 +739,6 @@ xfs_trans_reserve_quota_bydquots(
>  	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
>  		return 0;
>  
> -	if (tp && tp->t_dqinfo == NULL)
> -		xfs_trans_alloc_dqinfo(tp);
> -

This also should be a separate patch (or I guess the previous one?)
in which the commit log points out that the allocation is already
covered by the chain xfs_trans_reserve_quota_bydquots ->
xfs_trans_dqresv -> xfs_trans_mod_dquot.

--D

>  	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>  
>  	if (udqp) {
> -- 
> 2.20.0
> 
