Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D214F617CB
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Jul 2019 00:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbfGGW3s (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 7 Jul 2019 18:29:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41388 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbfGGW3r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Jul 2019 18:29:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x67MTjYT100860
        for <linux-xfs@vger.kernel.org>; Sun, 7 Jul 2019 22:29:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=OHBngkXwk+fCVIZgaDCee5b6lZ5BBNqglRhhI6reJHY=;
 b=fr48TrwQQfQ0VTjlAx/iFNCJTjXZKpAtI4lFCVzS8/SOikOsQUTPM1lGoWEtUNsKLRac
 x0R5y+OjXE+T2U0BBnFCoFqk/2klW9qGtyLbW6bCh+AbYFOWd7lGSK5zskhdpIIL5NmU
 abiX7uSeaW6dheX+UmfDJjDbmFrmIiNfjK67TpbCapwviRP+gK7vduNvBOhVvSYXbhE7
 V8lFNij0MMn+yZ37TGZTw/ueJPkFJRttPr3YqQ0YY/Lc6lKRLxc8ZoPR91btmoLMw1Jg
 bZmrN1xJQy3SKJxbHpJ51BPuOlxCEN0J4KWu2QLf9NPi6xV0hWadS26YmldVRGN6ESIi ag== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tjm9qbape-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 07 Jul 2019 22:29:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x67MSvCX134452
        for <linux-xfs@vger.kernel.org>; Sun, 7 Jul 2019 22:29:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tjjyjxg2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 07 Jul 2019 22:29:45 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x67MTiZg011837
        for <linux-xfs@vger.kernel.org>; Sun, 7 Jul 2019 22:29:44 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jul 2019 15:29:43 -0700
Subject: Re: [PATCH 1/3] xfs: refactor setflags to use setattr code directly
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <156174692684.1557952.3770482995772643434.stgit@magnolia>
 <156174693300.1557952.1660572699951099381.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <75ea899b-f1db-1f32-e7e4-ad3b001a8592@oracle.com>
Date:   Sun, 7 Jul 2019 15:29:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <156174693300.1557952.1660572699951099381.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9311 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
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
> Refactor the SETFLAGS implementation to use the SETXATTR code directly
> instead of partially constructing a struct fsxattr and calling bits and
> pieces of the setxattr code.  This reduces code size with no functional
> change.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/xfs_ioctl.c |   48 +++---------------------------------------------
>   1 file changed, 3 insertions(+), 45 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 552f18554c48..6f55cd7eb34f 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1490,11 +1490,8 @@ xfs_ioc_setxflags(
>   	struct file		*filp,
>   	void			__user *arg)
>   {
> -	struct xfs_trans	*tp;
>   	struct fsxattr		fa;
> -	struct fsxattr		old_fa;
>   	unsigned int		flags;
> -	int			join_flags = 0;
>   	int			error;
>   
>   	if (copy_from_user(&flags, arg, sizeof(flags)))
> @@ -1505,52 +1502,13 @@ xfs_ioc_setxflags(
>   		      FS_SYNC_FL))
>   		return -EOPNOTSUPP;
>   
> -	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
> +	xfs_fill_fsxattr(ip, false, &fa);

While reviewing this patch, it looks like xfs_fill_fsxattr comes in with 
a different set?  Not sure if you meant to stack them that way.  I may 
come back to this patch later if there is a dependency.  Or maybe it 
might make sense to move this patch into the set it depends on?

Allison

> +	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, fa.fsx_xflags);
>   
>   	error = mnt_want_write_file(filp);
>   	if (error)
>   		return error;
> -
> -	error = xfs_ioctl_setattr_drain_writes(ip, &fa, &join_flags);
> -	if (error) {
> -		xfs_iunlock(ip, join_flags);
> -		goto out_drop_write;
> -	}
> -
> -	/*
> -	 * Changing DAX config may require inode locking for mapping
> -	 * invalidation. These need to be held all the way to transaction commit
> -	 * or cancel time, so need to be passed through to
> -	 * xfs_ioctl_setattr_get_trans() so it can apply them to the join call
> -	 * appropriately.
> -	 */
> -	error = xfs_ioctl_setattr_dax_invalidate(ip, &fa, &join_flags);
> -	if (error) {
> -		xfs_iunlock(ip, join_flags);
> -		goto out_drop_write;
> -	}
> -
> -	tp = xfs_ioctl_setattr_get_trans(ip, join_flags);
> -	if (IS_ERR(tp)) {
> -		error = PTR_ERR(tp);
> -		goto out_drop_write;
> -	}
> -
> -	xfs_fill_fsxattr(ip, false, &old_fa);
> -	error = vfs_ioc_fssetxattr_check(VFS_I(ip), &old_fa, &fa);
> -	if (error) {
> -		xfs_trans_cancel(tp);
> -		goto out_drop_write;
> -	}
> -
> -	error = xfs_ioctl_setattr_xflags(tp, ip, &fa);
> -	if (error) {
> -		xfs_trans_cancel(tp);
> -		goto out_drop_write;
> -	}
> -
> -	error = xfs_trans_commit(tp);
> -out_drop_write:
> +	error = xfs_ioctl_setattr(ip, &fa);
>   	mnt_drop_write_file(filp);
>   	return error;
>   }
> 
