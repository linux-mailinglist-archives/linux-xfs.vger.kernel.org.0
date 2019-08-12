Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2DDF8A20B
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 17:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbfHLPNV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 11:13:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36508 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfHLPNV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 11:13:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CF8e1M101470
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 15:13:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Bl3UppcVxhxVGHNyVMK7BeC66Ded/zK4KwDL6mSJzAA=;
 b=YKN4VCH5tz1Gfv+WWNpFcpK19u+MK5kptTdnFTQT2/pEd0LT6Duw461Kj+PGWlfrH85n
 kihtlrFHoPNWkwfK6gE7QmUdipSv2tpFC+2tYQ88musQ2BGI/iuFHmsPkIcD+lek02O4
 M9PFzy7SFzr76EJv+uKsLr8n165b+VIOxMXBJFsBus99GTxwneLGnsuIXCVZuLsucmQp
 XRkRTmqYQoe1c9XJqm7dM8I9FwGy+dkT9fJs+biXOaRjXndgSSooKvqcyOGFlsgH7RHm
 XgUUfYEowA29X7gCIcIWCr3kvj2VEYRN9+iZbHM1bthlrIRV9SwjsP6lVXUPsr9hHeI3 Iw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Bl3UppcVxhxVGHNyVMK7BeC66Ded/zK4KwDL6mSJzAA=;
 b=pM2Jy2SHyjwE8c++7Qi6Hin6InkdN1nmTQK1LObP8OSLhfP4+s9OOdCQ/AeHIvFanluG
 cWzlV5AlQXSXCYXXM1y1IA1/Ij50Rorz2isrk9xqiE3ptJLuNYdLgdiB4bZERQcOSsii
 zzYJpmjwTpYCaQE13BcHEZGTdiMlIJZiGvOHaF3U4EbkZCBJvt5YIwPar50ywjxXBGW9
 QcwreNQ2tHt3TL+BkV6/NFqAywge4oLci3R0hHs4x5pyPgMrDRHQfgXkWXg7JSph0Emg
 b8y6r5phXMWncHlajR0rMxgECkt3jcjasgzqOJrMRQL/f7wiPtCeQ5Dk1q0pc2kd6nPM Og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2u9nvp0asj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 15:13:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CF8Txf017495
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 15:13:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2u9n9gyc9u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 15:13:18 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CFDH0k026303
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 15:13:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 08:13:17 -0700
Date:   Mon, 12 Aug 2019 08:13:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 02/18] xfs: Replace attribute parameters with struct
 xfs_name
Message-ID: <20190812151316.GR7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-3-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-3-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:10PM -0700, Allison Collins wrote:
> This patch replaces the attribute name, length and flags parameters with a
> single struct xfs_name parameter.  This helps to clean up the numbers of
> parameters being passed around and pre-simplifies the code some.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 40 ++++++++++++++++------------------------
>  fs/xfs/libxfs/xfs_attr.h | 12 +++++-------
>  fs/xfs/xfs_acl.c         | 26 +++++++++++++-------------
>  fs/xfs/xfs_ioctl.c       | 26 ++++++++++++++++----------
>  fs/xfs/xfs_iops.c        | 10 ++++++----
>  fs/xfs/xfs_xattr.c       | 21 +++++++++------------
>  6 files changed, 65 insertions(+), 70 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 7761925..0c91116 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -61,9 +61,7 @@ STATIC int
>  xfs_attr_args_init(
>  	struct xfs_da_args	*args,
>  	struct xfs_inode	*dp,
> -	const unsigned char	*name,
> -	size_t			namelen,
> -	int			flags)
> +	struct xfs_name		*name)
>  {
>  
>  	if (!name)
> @@ -73,9 +71,9 @@ xfs_attr_args_init(
>  	args->geo = dp->i_mount->m_attr_geo;
>  	args->whichfork = XFS_ATTR_FORK;
>  	args->dp = dp;
> -	args->flags = flags;
> -	args->name = name;
> -	args->namelen = namelen;
> +	args->flags = name->type;
> +	args->name = name->name;
> +	args->namelen = name->len;

/me wonders if you ought to just have an xfs_name embedded in the
xfs_da_args struct, seeing as the directory code uses it too.

>  	if (args->namelen >= MAXNAMELEN)
>  		return -EFAULT;		/* match IRIX behaviour */
>  

<skipping a bunch of changes that look fine to me>

> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index b1b7b1b..bdf925c 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -46,13 +46,15 @@ xfs_initxattrs(
>  {
>  	const struct xattr	*xattr;
>  	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_name		name;
>  	int			error = 0;
>  
>  	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
> -		error = xfs_attr_set(ip, xattr->name,
> -				     strlen(xattr->name),
> -				     xattr->value, xattr->value_len,
> -				     ATTR_SECURE);
> +		name.name = xattr->name;
> +		name.len = strlen(xattr->name);
> +		name.type = ATTR_SECURE;

You might as well declare and initialize name in the loop body.

> +		error = xfs_attr_set(ip, &name,
> +				     xattr->value, xattr->value_len);

Does the attr value need a similar structure encapsulation too?

>  		if (error < 0)
>  			break;
>  	}
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index fe12d11..3c63930 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -20,18 +20,17 @@ static int
>  xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
>  		struct inode *inode, const char *name, void *value, size_t size)
>  {
> -	int xflags = handler->flags;
>  	struct xfs_inode *ip = XFS_I(inode);
>  	int error, asize = size;
> -	size_t namelen = strlen(name);
> +	struct xfs_name xname = {name, strlen(name), handler->flags};

I think the preferred format for this is to use the structure field
names explicity during assignment...

	struct xfs_name		xname = {
		.name		= name,
		.namelen	= strlen(name),
		.type		= handler->flags,
	};

Also, please fix the variable/argument declaration indentation style of
this function to match the rest of xfs. :)

--D

>  
>  	/* Convert Linux syscall to XFS internal ATTR flags */
>  	if (!size) {
> -		xflags |= ATTR_KERNOVAL;
> +		xname.type |= ATTR_KERNOVAL;
>  		value = NULL;
>  	}
>  
> -	error = xfs_attr_get(ip, name, namelen, value, &asize, xflags);
> +	error = xfs_attr_get(ip, &xname, value, &asize);
>  	if (error)
>  		return error;
>  	return asize;
> @@ -64,23 +63,21 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
>  		struct inode *inode, const char *name, const void *value,
>  		size_t size, int flags)
>  {
> -	int			xflags = handler->flags;
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	int			error;
> -	size_t			namelen = strlen(name);
> +	struct xfs_name		xname = {name, strlen(name), handler->flags};
>  
>  	/* Convert Linux syscall to XFS internal ATTR flags */
>  	if (flags & XATTR_CREATE)
> -		xflags |= ATTR_CREATE;
> +		xname.type |= ATTR_CREATE;
>  	if (flags & XATTR_REPLACE)
> -		xflags |= ATTR_REPLACE;
> +		xname.type |= ATTR_REPLACE;
>  
>  	if (!value)
> -		return xfs_attr_remove(ip, name,
> -				       namelen, xflags);
> -	error = xfs_attr_set(ip, name, namelen, (void *)value, size, xflags);
> +		return xfs_attr_remove(ip, &xname);
> +	error = xfs_attr_set(ip, &xname, (void *)value, size);
>  	if (!error)
> -		xfs_forget_acl(inode, name, xflags);
> +		xfs_forget_acl(inode, name, xname.type);
>  
>  	return error;
>  }
> -- 
> 2.7.4
> 
