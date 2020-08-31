Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BB6257EE7
	for <lists+linux-xfs@lfdr.de>; Mon, 31 Aug 2020 18:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgHaQiD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 31 Aug 2020 12:38:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47484 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728527AbgHaQiC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 12:38:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGZXWc089405;
        Mon, 31 Aug 2020 16:37:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=GkSiRWBFxdpsJo3PVCnJNb0h3lD6k/+HX+51driiuDg=;
 b=DoIOH/nad697c+23qUDkeYLnJjBd8iKOfOC8FlvgRg7YPGgtAgwdBOCSfYMTTySucFXA
 2XQbnJ15m8gLVBqsW2bQyDdsYlgLKL9FYOyvFCGclQh9HoN2K11wQmigf2BWZ1TRvd2V
 N8KBlqVwmhvpXnquSCYvag77Rqjj9JQb2XT/tqS/4/KrG6I6kfS1XE0S/xhJLY/y2cj7
 5Cw5dTICtVfZ6rQ6BEceAPrprYY0MLJcis3+gfNlfVYeGARAIDJHdlHOSqMzFzqYXPpz
 fiJp+zUjrMfZUgZoOGSGZ+5QMPK8YxaI7PM3LNRTnt2efmKkyloYRwlkS2oTolTqfTLs dA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 337qrheb7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 16:37:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VGZdvN034060;
        Mon, 31 Aug 2020 16:37:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3380xv0t0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 16:37:56 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VGbtN0001013;
        Mon, 31 Aug 2020 16:37:55 GMT
Received: from localhost (/10.159.252.155)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 09:37:55 -0700
Date:   Mon, 31 Aug 2020 09:37:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 04/10] xfs: Check for extent overflow when
 adding/removing xattrs
Message-ID: <20200831163759.GM6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
 <20200820054349.5525-5-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820054349.5525-5-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 suspectscore=1 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310099
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 11:13:43AM +0530, Chandan Babu R wrote:
> Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to be
> added. One extra extent for dabtree in case a local attr is large enough
> to cause a double split.  It can also cause extent count to increase
> proportional to the size of a remote xattr's value.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c       | 13 +++++++++++++
>  fs/xfs/libxfs/xfs_inode_fork.h |  9 +++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d4583a0d1b3f..c481389da40f 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -396,6 +396,7 @@ xfs_attr_set(
>  	struct xfs_trans_res	tres;
>  	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
>  	int			error, local;
> +	int			rmt_blks = 0;
>  	unsigned int		total;
>  
>  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
> @@ -442,11 +443,15 @@ xfs_attr_set(
>  		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>  		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>  		total = args->total;
> +
> +		if (!local)
> +			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
>  	} else {
>  		XFS_STATS_INC(mp, xs_attr_remove);
>  
>  		tres = M_RES(mp)->tr_attrrm;
>  		total = XFS_ATTRRM_SPACE_RES(mp);
> +		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
>  	}
>  
>  	/*
> @@ -460,6 +465,14 @@ xfs_attr_set(
>  
>  	xfs_ilock(dp, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(args->trans, dp, 0);
> +
> +	if (args->value || xfs_inode_hasattr(dp)) {
> +		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
> +				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));

What happens if the free space is fragmented and each of these rmt
blocks results in a separate allocation?

I'm also not sure why we'd need to account for the remote blocks if
we're removing an attr?  Those mappings simply go away, right?

--D

> +		if (error)
> +			goto out_trans_cancel;
> +	}
> +
>  	if (args->value) {
>  		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index 2642e4847ee0..aae8e6e80b71 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -45,6 +45,15 @@ struct xfs_ifork {
>   * i.e. | Old extent | Hole | Old extent |
>   */
>  #define XFS_IEXT_REMOVE_CNT		(1)
> +/*
> + * Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to
> + * be added. One extra extent for dabtree in case a local attr is
> + * large enough to cause a double split.  It can also cause extent
> + * count to increase proportional to the size of a remote xattr's
> + * value.
> + */
> +#define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
> +	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
>  
>  /*
>   * Fork handling.
> -- 
> 2.28.0
> 
