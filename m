Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEA520FB1F
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jun 2020 19:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389222AbgF3Rzq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Jun 2020 13:55:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37170 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgF3Rzp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 13:55:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHqBkm045795;
        Tue, 30 Jun 2020 17:55:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5CtrI4OsaEAT5JtZ6JMutKH+KNHil8jewbgweAwvLDQ=;
 b=dygS1CZBbFhhPcKCwoqpd7BXH3itdPD+4ghzHd4enMZQ15t81ZI6EZamAg1MPnUd1PoZ
 QZ9+Fv0hXrKEFMO2ANDy5Xrd+VkuGdidImK1Y6sLPDCVzPhip7DRLvLhLbobEvhyfRet
 DwDmMVlWFYRvKev3jxNuMFepojb/CDYy7L9kaSwf4NFjD/PHBDNjiWoV3oHDXwQqCfZq
 NxIlyUGGWbBbNjflDCgJIkXBAmIr+mGJq1zR0LxYe/WbzSLNuJUriqgQNZqDyV2oF5FT
 X5sQb7YK9PdRC67jGIzB4+dkDFDpCbdna/jw0C0nBoJL0BJ17ZeQS4v/ylevS0wwEHcn 5g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31wxrn61q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 17:55:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UHrkGX163493;
        Tue, 30 Jun 2020 17:55:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 31xg1x55r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 17:55:42 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05UHtf83020807;
        Tue, 30 Jun 2020 17:55:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 17:55:41 +0000
Date:   Tue, 30 Jun 2020 10:55:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/15] xfs: move the di_dmevmask field to struct xfs_inode
Message-ID: <20200630175540.GK7606@magnolia>
References: <20200620071102.462554-1-hch@lst.de>
 <20200620071102.462554-15-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200620071102.462554-15-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=5 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 20, 2020 at 09:11:01AM +0200, Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the
> dmevmask field into the containing xfs_inode structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Easy conversion,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 4 ++--
>  fs/xfs/libxfs/xfs_inode_buf.h | 1 -
>  fs/xfs/xfs_inode.c            | 4 ++--
>  fs/xfs/xfs_inode.h            | 1 +
>  fs/xfs/xfs_inode_item.c       | 2 +-
>  fs/xfs/xfs_log_recover.c      | 2 +-
>  6 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index af595ee23635aa..d361803102d0e1 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -246,7 +246,7 @@ xfs_inode_from_disk(
>  	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
>  	ip->i_extsize = be32_to_cpu(from->di_extsize);
>  	ip->i_forkoff = from->di_forkoff;
> -	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
> +	ip->i_dmevmask	= be32_to_cpu(from->di_dmevmask);
>  	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
>  	ip->i_diflags	= be16_to_cpu(from->di_flags);
>  
> @@ -312,7 +312,7 @@ xfs_inode_to_disk(
>  	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
>  	to->di_forkoff = ip->i_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
> -	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> +	to->di_dmevmask = cpu_to_be32(ip->i_dmevmask);
>  	to->di_dmstate = cpu_to_be16(from->di_dmstate);
>  	to->di_flags = cpu_to_be16(ip->i_diflags);
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 2a8e7a7ed8d18d..0cfc1aaff6c6f3 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -16,7 +16,6 @@ struct xfs_dinode;
>   * format specific structures at the appropriate time.
>   */
>  struct xfs_icdinode {
> -	uint32_t	di_dmevmask;	/* DMIG event mask */
>  	uint16_t	di_dmstate;	/* DMIG state info */
>  };
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 59f11314750a46..db48c910c8d7b0 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -833,7 +833,7 @@ xfs_ialloc(
>  	inode->i_ctime = tv;
>  
>  	ip->i_extsize = 0;
> -	ip->i_d.di_dmevmask = 0;
> +	ip->i_dmevmask = 0;
>  	ip->i_d.di_dmstate = 0;
>  	ip->i_diflags = 0;
>  
> @@ -2755,7 +2755,7 @@ xfs_ifree(
>  	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
>  	ip->i_diflags = 0;
>  	ip->i_diflags2 = 0;
> -	ip->i_d.di_dmevmask = 0;
> +	ip->i_dmevmask = 0;
>  	ip->i_forkoff = 0;		/* mark the attr fork not in use */
>  	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
>  
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 106a8d6cc010cb..e64df2e7438aa0 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -67,6 +67,7 @@ typedef struct xfs_inode {
>  	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
>  	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
>  	struct timespec64	i_crtime;	/* time created */
> +	uint32_t		i_dmevmask;	/* DMIG event mask */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index dff3bc6a33720a..9b7860025c497d 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -330,7 +330,7 @@ xfs_inode_to_log_dinode(
>  	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
>  	to->di_forkoff = ip->i_forkoff;
>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
> -	to->di_dmevmask = from->di_dmevmask;
> +	to->di_dmevmask = ip->i_dmevmask;
>  	to->di_dmstate = from->di_dmstate;
>  	to->di_flags = ip->i_diflags;
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index ec015df55b77a9..d096b8c4013814 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2720,7 +2720,7 @@ xlog_recover_process_one_iunlink(
>  	 * Prevent any DMAPI event from being sent when the reference on
>  	 * the inode is dropped.
>  	 */
> -	ip->i_d.di_dmevmask = 0;
> +	ip->i_dmevmask = 0;
>  
>  	xfs_irele(ip);
>  	return agino;
> -- 
> 2.26.2
> 
