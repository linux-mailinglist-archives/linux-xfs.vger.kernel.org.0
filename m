Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37D4321F69
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 23:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfEQVMA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 17:12:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54392 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfEQVMA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 17:12:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4HKxMES009653;
        Fri, 17 May 2019 21:11:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=wC1r00kBDCCKjuTVXA95zrLyRZq57ZpyfSnNGDkZ514=;
 b=jj7jYa8v7F4cIpW7YcFn8gqO5qhPDxkg0iIkNYEWtan2WIbUefJ2yAakSzHMtNIcv5Ir
 CHbQBAlHq6Lc++bpzY4ebSPvXHWuqf294NmTSWfPTaZ9mzic8AtqQWflzzvgDYSjs4aG
 uvqQS6iGVnlnmapoG/RzswCQoScn8DXr5qwLrnszudwqcfQHKbrmuuzO84VqXx7wI08R
 JK7i2j+fRTyRVoECJ7DBNo3rcd60DbVER8z8YLko/kBLilK7Hb+xPKo0h1lj05vPV1B3
 OjK9lSQznqoE/vrbycVN8PLaUm4LjTM+9HfoVcBtpqugGVKW7x95RVwJgvTxXHq+jRNn 7g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2sdq1r41de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 21:11:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4HL9ilX048729;
        Fri, 17 May 2019 21:09:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2shh5h9k1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 21:09:44 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4HL9bV7000946;
        Fri, 17 May 2019 21:09:38 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 May 2019 14:09:37 -0700
Subject: Re: [PATCH 3/3] xfsprogs: remove unused flags arg from getsb
 interfaces
To:     Eric Sandeen <sandeen@sandeen.net>,
        Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
 <9807c398-8bfe-367f-3f45-0ff3d5ad84f9@sandeen.net>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <cb1ff021-c170-1c4b-a94a-5e8ca84f281a@oracle.com>
Date:   Fri, 17 May 2019 14:09:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <9807c398-8bfe-367f-3f45-0ff3d5ad84f9@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9260 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905170125
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9260 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905170125
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/16/19 10:46 AM, Eric Sandeen wrote:
> The flags value is always* passed as 0 so remove the argument.
> 
> *mkfs.xfs is the sole exception; it passes a flag to fail on read
> error, but we can easily detect the error and exit from main()
> manually instead.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok to me.

Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
> 
> (This one might actually come in via a libxfs merge instead)
> 
> diff --git a/include/xfs_trans.h b/include/xfs_trans.h
> index d32acc9e..953da5d1 100644
> --- a/include/xfs_trans.h
> +++ b/include/xfs_trans.h
> @@ -87,7 +87,7 @@ void	xfs_trans_cancel(struct xfs_trans *);
>   /* cancel dfops associated with a transaction */
>   void xfs_defer_cancel(struct xfs_trans *);
>   
> -struct xfs_buf *xfs_trans_getsb(struct xfs_trans *, struct xfs_mount *, int);
> +struct xfs_buf *xfs_trans_getsb(struct xfs_trans *, struct xfs_mount *);
>   
>   void	xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
>   void	xfs_trans_log_inode (struct xfs_trans *, struct xfs_inode *,
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index 8fa2c2c5..4dc4d5f3 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -177,7 +177,7 @@ extern void	libxfs_putbuf (xfs_buf_t *);
>   
>   extern void	libxfs_readbuf_verify(struct xfs_buf *bp,
>   			const struct xfs_buf_ops *ops);
> -extern xfs_buf_t *xfs_getsb(struct xfs_mount *, int);
> +extern xfs_buf_t *xfs_getsb(struct xfs_mount *);
>   extern void	libxfs_bcache_purge(void);
>   extern void	libxfs_bcache_free(void);
>   extern void	libxfs_bcache_flush(void);
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 8d6f958a..132ed0a9 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -476,10 +476,10 @@ libxfs_trace_putbuf(const char *func, const char *file, int line, xfs_buf_t *bp)
>   
>   
>   xfs_buf_t *
> -xfs_getsb(xfs_mount_t *mp, int flags)
> +xfs_getsb(xfs_mount_t *mp)
>   {
>   	return libxfs_readbuf(mp->m_ddev_targp, XFS_SB_DADDR,
> -				XFS_FSS_TO_BB(mp, 1), flags, &xfs_sb_buf_ops);
> +				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
>   }
>   
>   kmem_zone_t			*xfs_buf_zone;
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 5ef0c055..9e49def0 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -628,8 +628,7 @@ xfs_trans_get_buf_map(
>   xfs_buf_t *
>   xfs_trans_getsb(
>   	xfs_trans_t		*tp,
> -	xfs_mount_t		*mp,
> -	int			flags)
> +	xfs_mount_t		*mp)
>   {
>   	xfs_buf_t		*bp;
>   	xfs_buf_log_item_t	*bip;
> @@ -637,7 +636,7 @@ xfs_trans_getsb(
>   	DEFINE_SINGLE_BUF_MAP(map, XFS_SB_DADDR, len);
>   
>   	if (tp == NULL)
> -		return xfs_getsb(mp, flags);
> +		return xfs_getsb(mp);
>   
>   	bp = xfs_trans_buf_item_match(tp, mp->m_dev, &map, 1);
>   	if (bp != NULL) {
> @@ -648,7 +647,7 @@ xfs_trans_getsb(
>   		return bp;
>   	}
>   
> -	bp = xfs_getsb(mp, flags);
> +	bp = xfs_getsb(mp);
>   #ifdef XACT_DEBUG
>   	fprintf(stderr, "trans_get_sb buffer %p, transaction %p\n", bp, tp);
>   #endif
> diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
> index f1e2ba57..a1857e10 100644
> --- a/libxfs/xfs_sb.c
> +++ b/libxfs/xfs_sb.c
> @@ -915,7 +915,7 @@ xfs_log_sb(
>   	struct xfs_trans	*tp)
>   {
>   	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp, 0);
> +	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp);
>   
>   	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
>   	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> @@ -1045,7 +1045,7 @@ xfs_sync_sb_buf(
>   	if (error)
>   		return error;
>   
> -	bp = xfs_trans_getsb(tp, mp, 0);
> +	bp = xfs_trans_getsb(tp, mp);
>   	xfs_log_sb(tp);
>   	xfs_trans_bhold(tp, bp);
>   	xfs_trans_set_sync(tp);
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 09106648..647e2bc2 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -4123,7 +4123,11 @@ main(
>   	/*
>   	 * Mark the filesystem ok.
>   	 */
> -	buf = libxfs_getsb(mp, LIBXFS_EXIT_ON_FAILURE);
> +	buf = libxfs_getsb(mp);
> +	if (!buf) {
> +		fprintf(stderr, _("couldn't get superblock\n"));
> +		exit(1);
> +	}
>   	(XFS_BUF_TO_SBP(buf))->sb_inprogress = 0;
>   	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
>   
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 0f6a8395..8ad32365 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -2177,7 +2177,7 @@ sync_sb(xfs_mount_t *mp)
>   {
>   	xfs_buf_t	*bp;
>   
> -	bp = libxfs_getsb(mp, 0);
> +	bp = libxfs_getsb(mp);
>   	if (!bp)
>   		do_error(_("couldn't get superblock\n"));
>   
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 9657503f..4000b3e6 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -1044,7 +1044,7 @@ _("Warning:  project quota information would be cleared.\n"
>   	/*
>   	 * Clear the quota flags if they're on.
>   	 */
> -	sbp = libxfs_getsb(mp, 0);
> +	sbp = libxfs_getsb(mp);
>   	if (!sbp)
>   		do_error(_("couldn't get superblock\n"));
>   
> 
