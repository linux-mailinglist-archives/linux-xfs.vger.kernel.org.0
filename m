Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9B30A4260
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Aug 2019 07:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfHaFLh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 31 Aug 2019 01:11:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44950 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfHaFLh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 31 Aug 2019 01:11:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7V5BZRx162094;
        Sat, 31 Aug 2019 05:11:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=36Efk3NKTrPV7t1UA95TweqQgNnlT84IiYnOMidizo0=;
 b=iv3b/vGU2+8NgWLRTw1Vj+cjBoXbKUtCq6GJAREIqTjU/BFO7M9uZj5bGWEekRJB4wEA
 w+XWjxTmC6ZhbtP816jJMQDExD30YCDwYCNz+bw5/JAWxTFtIopze6Q0LPAsc6q82pfN
 4CBDlZx2Bc66BIpRQY5d2C1TDOwqyGufqv6twqnnuMpwD5bCOulP/YaXxx9ws+FlqOy1
 XofgvkH3AHFKEaFA/sAuQrCYPkXtVEqEtK1/AfdjZKfaC+gKMyhLrzOe+8LFdy7exyGJ
 71Y/KUDdcBXnt1cBQOZ8tSM+xGb4hmq1XS4YHkY1DwlubnQfWJjQT0TNCNBM6ai0Lm2X SA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2uqjh2001k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Aug 2019 05:11:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7V58kqx091222;
        Sat, 31 Aug 2019 05:11:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2uqe19xsmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 31 Aug 2019 05:11:34 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7V5BXCw024258;
        Sat, 31 Aug 2019 05:11:34 GMT
Received: from [192.168.1.9] (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 22:11:33 -0700
Subject: Re: [PATCH 6/9] libfrog: create online fs geometry converters
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <156713882070.386621.8501281965010809034.stgit@magnolia>
 <156713886338.386621.8386764562465509319.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <78fe4231-da82-1bfa-62a6-b8827e73d5be@oracle.com>
Date:   Fri, 30 Aug 2019 22:11:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <156713886338.386621.8386764562465509319.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908310057
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908310058
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/29/19 9:21 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create helper functions to perform unit conversions against a runtime
> filesystem, then remove the open-coded versions in scrub.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Looks good.  I think the helpers make the logic more readable.

Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   include/xfrog.h    |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   libfrog/fsgeom.c   |    1 +
>   scrub/fscounters.c |    4 ++--
>   scrub/inodes.c     |    4 ++--
>   scrub/phase3.c     |    6 +++--
>   scrub/phase5.c     |    4 ++--
>   scrub/phase6.c     |    3 ++-
>   scrub/phase7.c     |    6 +++--
>   8 files changed, 72 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/include/xfrog.h b/include/xfrog.h
> index 008cc155..a08f6464 100644
> --- a/include/xfrog.h
> +++ b/include/xfrog.h
> @@ -42,6 +42,9 @@ struct xfs_fd {
>   
>   	/* log2 of sb_inopblock */
>   	unsigned int		inopblog;
> +
> +	/* bits for agino in inum */
> +	unsigned int		aginolog;
>   };
>   
>   /* Static initializers */
> @@ -51,4 +54,58 @@ struct xfs_fd {
>   int xfd_prepare_geometry(struct xfs_fd *xfd);
>   int xfd_close(struct xfs_fd *xfd);
>   
> +/* Convert AG number and AG inode number into fs inode number. */
> +static inline uint64_t
> +cvt_agino_to_ino(
> +	const struct xfs_fd	*xfd,
> +	uint32_t		agno,
> +	uint32_t		agino)
> +{
> +	return ((uint64_t)agno << xfd->aginolog) + agino;
> +}
> +
> +/* Convert fs inode number into AG number. */
> +static inline uint32_t
> +cvt_ino_to_agno(
> +	const struct xfs_fd	*xfd,
> +	uint64_t		ino)
> +{
> +	return ino >> xfd->aginolog;
> +}
> +
> +/* Convert fs inode number into AG inode number. */
> +static inline uint32_t
> +cvt_ino_to_agino(
> +	const struct xfs_fd	*xfd,
> +	uint64_t		ino)
> +{
> +	return ino & ((1ULL << xfd->aginolog) - 1);
> +}
> +
> +/*
> + * Convert a linear fs block offset number into bytes.  This is the runtime
> + * equivalent of XFS_FSB_TO_B, which means that it is /not/ for segmented fsbno
> + * format (= agno | agbno) that we use internally for the data device.
> + */
> +static inline uint64_t
> +cvt_off_fsb_to_b(
> +	const struct xfs_fd	*xfd,
> +	uint64_t		fsb)
> +{
> +	return fsb << xfd->blocklog;
> +}
> +
> +/*
> + * Convert bytes into a (rounded down) linear fs block offset number.  This is
> + * the runtime equivalent of XFS_B_TO_FSBT.  It does not produce segmented
> + * fsbno numbers (= agno | agbno).
> + */
> +static inline uint64_t
> +cvt_b_to_off_fsbt(
> +	const struct xfs_fd	*xfd,
> +	uint64_t		bytes)
> +{
> +	return bytes >> xfd->blocklog;
> +}
> +
>   #endif	/* __XFROG_H__ */
> diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
> index b8873598..cf9323c1 100644
> --- a/libfrog/fsgeom.c
> +++ b/libfrog/fsgeom.c
> @@ -113,6 +113,7 @@ xfd_prepare_geometry(
>   	xfd->blocklog = highbit32(xfd->fsgeom.blocksize);
>   	xfd->inodelog = highbit32(xfd->fsgeom.inodesize);
>   	xfd->inopblog = xfd->blocklog - xfd->inodelog;
> +	xfd->aginolog = xfd->agblklog + xfd->inopblog;
>   	return 0;
>   }
>   
> diff --git a/scrub/fscounters.c b/scrub/fscounters.c
> index ac898764..ea6af156 100644
> --- a/scrub/fscounters.c
> +++ b/scrub/fscounters.c
> @@ -91,8 +91,8 @@ xfs_count_ag_inodes(
>   				minor(ctx->fsinfo.fs_datadev),
>   				agno);
>   
> -	ag_ino = (__u64)agno << (ctx->mnt.inopblog + ctx->mnt.agblklog);
> -	next_ag_ino = (__u64)(agno + 1) << (ctx->mnt.inopblog + ctx->mnt.agblklog);
> +	ag_ino = cvt_agino_to_ino(&ctx->mnt, agno, 0);
> +	next_ag_ino = cvt_agino_to_ino(&ctx->mnt, agno + 1, 0);
>   
>   	moveon = xfs_count_inodes_range(ctx, descr, ag_ino, next_ag_ino - 1,
>   			&ci->counters[agno]);
> diff --git a/scrub/inodes.c b/scrub/inodes.c
> index 873ad425..700e5200 100644
> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -228,8 +228,8 @@ xfs_scan_ag_inodes(
>   				minor(ctx->fsinfo.fs_datadev),
>   				agno);
>   
> -	ag_ino = (__u64)agno << (ctx->mnt.inopblog + ctx->mnt.agblklog);
> -	next_ag_ino = (__u64)(agno + 1) << (ctx->mnt.inopblog + ctx->mnt.agblklog);
> +	ag_ino = cvt_agino_to_ino(&ctx->mnt, agno, 0);
> +	next_ag_ino = cvt_agino_to_ino(&ctx->mnt, agno + 1, 0);
>   
>   	moveon = xfs_iterate_inodes_range(ctx, descr, ctx->fshandle, ag_ino,
>   			next_ag_ino - 1, si->fn, si->arg);
> diff --git a/scrub/phase3.c b/scrub/phase3.c
> index 579e08c3..8c02f1cb 100644
> --- a/scrub/phase3.c
> +++ b/scrub/phase3.c
> @@ -52,8 +52,8 @@ xfs_scrub_inode_vfs_error(
>   	xfs_agino_t		agino;
>   	int			old_errno = errno;
>   
> -	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
> -	agino = bstat->bs_ino % (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
> +	agno = cvt_ino_to_agno(&ctx->mnt, bstat->bs_ino);
> +	agino = cvt_ino_to_agino(&ctx->mnt, bstat->bs_ino);
>   	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
>   			(uint64_t)bstat->bs_ino, agno, agino);
>   	errno = old_errno;
> @@ -77,7 +77,7 @@ xfs_scrub_inode(
>   	int			error;
>   
>   	xfs_action_list_init(&alist);
> -	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
> +	agno = cvt_ino_to_agno(&ctx->mnt, bstat->bs_ino);
>   	background_sleep();
>   
>   	/* Try to open the inode to pin it. */
> diff --git a/scrub/phase5.c b/scrub/phase5.c
> index 36ec27b3..f3ee22e6 100644
> --- a/scrub/phase5.c
> +++ b/scrub/phase5.c
> @@ -239,8 +239,8 @@ xfs_scrub_connections(
>   	int			fd = -1;
>   	int			error;
>   
> -	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
> -	agino = bstat->bs_ino % (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
> +	agno = cvt_ino_to_agno(&ctx->mnt, bstat->bs_ino);
> +	agino = cvt_ino_to_agino(&ctx->mnt, bstat->bs_ino);
>   	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
>   			(uint64_t)bstat->bs_ino, agno, agino);
>   	background_sleep();
> diff --git a/scrub/phase6.c b/scrub/phase6.c
> index 48971270..5628b926 100644
> --- a/scrub/phase6.c
> +++ b/scrub/phase6.c
> @@ -547,7 +547,8 @@ xfs_estimate_verify_work(
>   	if (!moveon)
>   		return moveon;
>   
> -	*items = ((d_blocks - d_bfree) + (r_blocks - r_bfree)) << ctx->mnt.blocklog;
> +	*items = cvt_off_fsb_to_b(&ctx->mnt,
> +			(d_blocks - d_bfree) + (r_blocks - r_bfree));
>   	*nr_threads = disk_heads(ctx->datadev);
>   	*rshift = 20;
>   	return moveon;
> diff --git a/scrub/phase7.c b/scrub/phase7.c
> index 41a77356..8a028e19 100644
> --- a/scrub/phase7.c
> +++ b/scrub/phase7.c
> @@ -148,11 +148,11 @@ xfs_scan_summary(
>   	 * filesystem treats them as "free", but since we scanned
>   	 * them, we'll consider them used.
>   	 */
> -	d_bfree -= totalcount.agbytes >> ctx->mnt.blocklog;
> +	d_bfree -= cvt_b_to_off_fsbt(&ctx->mnt, totalcount.agbytes);
>   
>   	/* Report on what we found. */
> -	used_data = (d_blocks - d_bfree) << ctx->mnt.blocklog;
> -	used_rt = (r_blocks - r_bfree) << ctx->mnt.blocklog;
> +	used_data = cvt_off_fsb_to_b(&ctx->mnt, d_blocks - d_bfree);
> +	used_rt = cvt_off_fsb_to_b(&ctx->mnt, r_blocks - r_bfree);
>   	used_files = f_files - f_free;
>   	stat_data = totalcount.dbytes;
>   	stat_rt = totalcount.rbytes;
> 
