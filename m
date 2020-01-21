Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1916A144807
	for <lists+linux-xfs@lfdr.de>; Wed, 22 Jan 2020 00:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgAUXIC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 Jan 2020 18:08:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:33260 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbgAUXIC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 18:08:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LMmgN3009650
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:08:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=c1gkTdtzgMLBW8C6m61VMTFEhoiNIwwQzfNfLVkPQkA=;
 b=JayA1oU33sXbLgve/Dah7VL758+NCsmDMZJ7bXGBsUPtwV26gFCx1b/oCZm3mRc2Bk2m
 yX7hFgkN3MQwy1rsCjv4X7Ty8+EUYPYhVgoz1nqkunVT4UWMTbmWJ8/sIpRGudAEdUqJ
 bn/o+NmgYV71PByd9C7B4nTvINv0v418WcHamfxbkfZ6m8klpcFj7MSHqU55W/mQINcj
 8XpSnM90tZe/8dZN/fyPig/+ophpxdztGrQtq8KcFSTioYOK/f57mejwvOR1iF2gxBAb
 5uixer6LXa81Fx3XjVhwMVbqkFDs12ksIIgc7UAv8D8/Eugi2SH1+2rGVzpD4zev/SPN QQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnr86bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:08:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LMmeKm143982
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:07:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xnpegq8cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:07:59 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LN7vh1031401
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jan 2020 23:07:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 15:07:57 -0800
Date:   Tue, 21 Jan 2020 15:07:56 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6 07/16] xfs: Refactor xfs_attr_try_sf_addname
Message-ID: <20200121230756.GJ8247@magnolia>
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-8-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200118225035.19503-8-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 18, 2020 at 03:50:26PM -0700, Allison Collins wrote:
> To help pre-simplify xfs_attr_set_args, we need to hoist transacation
> handling up, while modularizing the adjacent code down into helpers. In
> this patch, hoist the commit in xfs_attr_try_sf_addname up into the
> calling function, and also pull the attr list creation down.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 9ed7e94..c15361a 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -227,8 +227,13 @@ xfs_attr_try_sf_addname(
>  	struct xfs_da_args	*args)
>  {
>  
> -	struct xfs_mount	*mp = dp->i_mount;
> -	int			error, error2;
> +	int			error;
> +
> +	/*
> +	 * Build initial attribute list (if required).
> +	 */
> +	if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
> +		xfs_attr_shortform_create(args);
>  
>  	error = xfs_attr_shortform_addname(args);
>  	if (error == -ENOSPC)
> @@ -241,12 +246,10 @@ xfs_attr_try_sf_addname(
>  	if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
>  		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
>  
> -	if (mp->m_flags & XFS_MOUNT_WSYNC)
> +	if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
>  		xfs_trans_set_sync(args->trans);
>  
> -	error2 = xfs_trans_commit(args->trans);
> -	args->trans = NULL;
> -	return error ? error : error2;
> +	return error;
>  }
>  
>  /*
> @@ -258,7 +261,7 @@ xfs_attr_set_args(
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_buf          *leaf_bp = NULL;
> -	int			error;
> +	int			error, error2 = 0;
>  
>  	/*
>  	 * If the attribute list is non-existent or a shortform list,
> @@ -269,17 +272,14 @@ xfs_attr_set_args(
>  	     dp->i_d.di_anextents == 0)) {
>  
>  		/*
> -		 * Build initial attribute list (if required).
> -		 */
> -		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
> -			xfs_attr_shortform_create(args);
> -
> -		/*
>  		 * Try to add the attr to the attribute list in the inode.
>  		 */
>  		error = xfs_attr_try_sf_addname(dp, args);
> -		if (error != -ENOSPC)
> -			return error;
> +		if (error != -ENOSPC) {
> +			error2 = xfs_trans_commit(args->trans);

/me wonders if there's really a point in committing the transaction for
things like EEXIST and ENOMEM, but I guess this is a straight
conversion and the current code really does this...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +			args->trans = NULL;
> +			return error ? error : error2;
> +		}
>  
>  		/*
>  		 * It won't fit in the shortform, transform to a leaf block.
> -- 
> 2.7.4
> 
