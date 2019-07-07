Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 161F3617CC
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Jul 2019 00:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfGGW3x (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 7 Jul 2019 18:29:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42180 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbfGGW3x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Jul 2019 18:29:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x67MTpWW190024
        for <linux-xfs@vger.kernel.org>; Sun, 7 Jul 2019 22:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=pFsvyT68dGZx3qwlNSdAUzLv4JUzCjh+MxtX/ZEnQQY=;
 b=Y4ajUDmIMnhZp2z6l2lVZQxO/dGsEVESDjNBu30eyhzTOpfAs4apfl6bNK0qsw69cZH8
 hWLfYzxeB2WxF+D1z1WTE3q+lJSF+bdhGNGzLtVEmKPdzfv6q2DASx+w8cwKQPi5Yac7
 SeXq3RkgIEJY4EcBXk+5yHUZ3R2mqi9DTkjNsT/By66aLKn5HQZT1HvTy0Gk9/Zo38j7
 Izc/qcYXVf+VJTH5z3cIYfG+BBzwYB0qTn4OP3wdqC5G7XogJaXLb0QYrZWPeP3L9uQQ
 HGiWarte1Elxh1iP4pRSfH9/y/c53QjTqpB0floYhFjMlxWCy5Jl2gjP+w3uwEQ4RkJ8 1w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2tjkkpbbrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 07 Jul 2019 22:29:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x67MSSjF192815
        for <linux-xfs@vger.kernel.org>; Sun, 7 Jul 2019 22:29:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2tjhpc7g1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 07 Jul 2019 22:29:51 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x67MTow7020976
        for <linux-xfs@vger.kernel.org>; Sun, 7 Jul 2019 22:29:50 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jul 2019 15:29:50 -0700
Subject: Re: [PATCH 2/3] xfs: clean up xfs_merge_ioc_xflags
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <156174692684.1557952.3770482995772643434.stgit@magnolia>
 <156174693930.1557952.9566025019367233702.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <187b53a1-ac13-f900-fb28-22a8e6cc75dc@oracle.com>
Date:   Sun, 7 Jul 2019 15:29:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <156174693930.1557952.9566025019367233702.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9311 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=988
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907070314
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9311 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907070315
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/28/19 11:35 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Clean up the calling convention since we're editing the fsxattr struct
> anyway.
> 
This one looks ok.  You can add my review:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/xfs_ioctl.c |   32 ++++++++++++++------------------
>   1 file changed, 14 insertions(+), 18 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6f55cd7eb34f..d2526d9070d2 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -829,35 +829,31 @@ xfs_ioc_ag_geometry(
>    * Linux extended inode flags interface.
>    */
>   
> -STATIC unsigned int
> +static inline void
>   xfs_merge_ioc_xflags(
> -	unsigned int	flags,
> -	unsigned int	start)
> +	struct fsxattr	*fa,
> +	unsigned int	flags)
>   {
> -	unsigned int	xflags = start;
> -
>   	if (flags & FS_IMMUTABLE_FL)
> -		xflags |= FS_XFLAG_IMMUTABLE;
> +		fa->fsx_xflags |= FS_XFLAG_IMMUTABLE;
>   	else
> -		xflags &= ~FS_XFLAG_IMMUTABLE;
> +		fa->fsx_xflags &= ~FS_XFLAG_IMMUTABLE;
>   	if (flags & FS_APPEND_FL)
> -		xflags |= FS_XFLAG_APPEND;
> +		fa->fsx_xflags |= FS_XFLAG_APPEND;
>   	else
> -		xflags &= ~FS_XFLAG_APPEND;
> +		fa->fsx_xflags &= ~FS_XFLAG_APPEND;
>   	if (flags & FS_SYNC_FL)
> -		xflags |= FS_XFLAG_SYNC;
> +		fa->fsx_xflags |= FS_XFLAG_SYNC;
>   	else
> -		xflags &= ~FS_XFLAG_SYNC;
> +		fa->fsx_xflags &= ~FS_XFLAG_SYNC;
>   	if (flags & FS_NOATIME_FL)
> -		xflags |= FS_XFLAG_NOATIME;
> +		fa->fsx_xflags |= FS_XFLAG_NOATIME;
>   	else
> -		xflags &= ~FS_XFLAG_NOATIME;
> +		fa->fsx_xflags &= ~FS_XFLAG_NOATIME;
>   	if (flags & FS_NODUMP_FL)
> -		xflags |= FS_XFLAG_NODUMP;
> +		fa->fsx_xflags |= FS_XFLAG_NODUMP;
>   	else
> -		xflags &= ~FS_XFLAG_NODUMP;
> -
> -	return xflags;
> +		fa->fsx_xflags &= ~FS_XFLAG_NODUMP;
>   }
>   
>   STATIC unsigned int
> @@ -1503,7 +1499,7 @@ xfs_ioc_setxflags(
>   		return -EOPNOTSUPP;
>   
>   	xfs_fill_fsxattr(ip, false, &fa);
> -	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, fa.fsx_xflags);
> +	xfs_merge_ioc_xflags(&fa, flags);
>   
>   	error = mnt_want_write_file(filp);
>   	if (error)
> 
