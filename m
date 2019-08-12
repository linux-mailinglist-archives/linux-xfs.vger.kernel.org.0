Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1918A2CF
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 18:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfHLQCA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 12:02:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49376 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbfHLQCA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:02:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CFxOrs122738
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:01:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=kxFC/bOP7nftgVsSMnHsQJWDjF66P/AaqgrLWO+ysVU=;
 b=KOce/h+4mjaqXyne2v9aeWKibcEffpQVTPA0T/3y122QEfe6iuqy9ctDtzM5diJp0xtC
 AquUhA7Bupd2lzVy0Tf9G5QPztrDfOLGo7XpaEm2sw7EX3ggbYvhGDPKoM0lxEL7sCzP
 E2WxVDTGYh12Ly/joEeou05MCl4toEzdF/WrSCZ5OwDwpAOIWsRfJhNUL/4gQjCorBvb
 PU0koDUEtAEl5q6nJnzRoJ5KQuRfW6Or0/rTLss4ZUI3X02+OxfkgU+uqh+PS/QI0mM4
 N5nawIkG2XufLQgsTJL9R8mLE1+5qyJi15Ro+pko5umJQfl0CWEvZx7Zf0Sf7EtYpR4H KQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=kxFC/bOP7nftgVsSMnHsQJWDjF66P/AaqgrLWO+ysVU=;
 b=kaHB3cjvbh8Q3ztyyQgnq94ilKF/cllxn+wRaL96pzgzXtzQJnodq9kReX+cDtNBz5gK
 UIANPhAcQ6z309snILkQd/c1aUrpov7LTFqvnnEsJer+DJKQxVLmOWVn7sg+lup/2YIy
 QrcaEDtEkBDyFKHXjNlN/5+xKrVk8XspiNrAzl+e3xiTKiSWXj8FQIk66d3Vc39LlCTC
 YgoSY2H4AXu8Q9oxqF8WHHaiUjkeE4G5lT5Fpt1WTdLhxcdWAvAMZ24gDt2cVLKCNFMx
 1EQrEXpegEl3ffcd8PpRwWhuCQKZt2rKSsZAwKYCiqdxqqaL7j5g4krRYbxkQzJ7lgQ9 sQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u9nbt8mnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:01:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CFx2MK046345
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:01:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2u9nre184y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:01:57 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CG1vmh006731
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:01:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 09:01:57 -0700
Date:   Mon, 12 Aug 2019 09:01:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 06/18] xfs: Factor out new helper functions
 xfs_attr_rmtval_set
Message-ID: <20190812160156.GU7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-7-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-7-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120178
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:14PM -0700, Allison Collins wrote:
> Break xfs_attr_rmtval_set into two helper functions
> xfs_attr_rmt_find_hole and xfs_attr_rmtval_set_value.
> xfs_attr_rmtval_set rolls the transaction between the
> helpers, but delayed operations cannot.  We will use
> the helpers later when constructing new delayed
> attribute routines.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 73 +++++++++++++++++++++++++++++++----------
>  fs/xfs/libxfs/xfs_attr_remote.h |  4 ++-
>  2 files changed, 58 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 4eb30d3..c421412 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -21,6 +21,7 @@
>  #include "xfs_attr.h"
>  #include "xfs_trace.h"
>  #include "xfs_error.h"
> +#include "xfs_attr_remote.h"
>  
>  #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
>  
> @@ -430,34 +431,18 @@ xfs_attr_rmtval_set(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_inode	*dp = args->dp;
> -	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_bmbt_irec	map;
>  	xfs_dablk_t		lblkno;
>  	xfs_fileoff_t		lfileoff = 0;
> -	uint8_t			*src = args->value;
>  	int			blkcnt;
> -	int			valuelen;
>  	int			nmap;
>  	int			error;
> -	int			offset = 0;
>  
> -	trace_xfs_attr_rmtval_set(args);
> -
> -	/*
> -	 * Find a "hole" in the attribute address space large enough for
> -	 * us to drop the new attribute's value into. Because CRC enable
> -	 * attributes have headers, we can't just do a straight byte to FSB
> -	 * conversion and have to take the header space into account.
> -	 */
> -	blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
> -	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
> -						   XFS_ATTR_FORK);
> +	error = xfs_attr_rmt_find_hole(args, &blkcnt, &lfileoff);
>  	if (error)
>  		return error;
>  
> -	args->rmtblkno = lblkno = (xfs_dablk_t)lfileoff;
> -	args->rmtblkcnt = blkcnt;
> -
> +	lblkno = (xfs_dablk_t)lfileoff;
>  	/*
>  	 * Roll through the "value", allocating blocks on disk as required.
>  	 */
> @@ -498,6 +483,58 @@ xfs_attr_rmtval_set(
>  			return error;
>  	}
>  
> +	error = xfs_attr_rmtval_set_value(args);
> +	return error;
> +}
> +
> +
> +

Only need one blank line between functions.

> +int
> +xfs_attr_rmt_find_hole(
> +	struct xfs_da_args	*args,
> +	int			*blkcnt,
> +	xfs_fileoff_t		*lfileoff)
> +{
> +	struct xfs_inode        *dp = args->dp;
> +	struct xfs_mount	*mp = dp->i_mount;
> +	int			error;
> +
> +	trace_xfs_attr_rmtval_set(args);

Shouldn't this be in the xfs_attr_rmtval_set_value function?
We're not actually setting anything here, we're just looking for holes.

> +
> +	/*
> +	 * Find a "hole" in the attribute address space large enough for
> +	 * us to drop the new attribute's value into. Because CRC enable

This first sentence would make a lovely comment above this function
telling us what it does.

> +	 * attributes have headers, we can't just do a straight byte to FSB
> +	 * conversion and have to take the header space into account.
> +	 */
> +	*blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);

Can the callers be refactored to use args->rmtblkcnt to eliminate the
@blkcnt parameter?

--D

> +	error = xfs_bmap_first_unused(args->trans, args->dp, *blkcnt, lfileoff,
> +						   XFS_ATTR_FORK);
> +	if (error)
> +		return error;
> +
> +	args->rmtblkno = (xfs_dablk_t)*lfileoff;
> +	args->rmtblkcnt = *blkcnt;
> +
> +	return 0;
> +}
> +
> +int
> +xfs_attr_rmtval_set_value(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_bmbt_irec	map;
> +	xfs_dablk_t		lblkno;
> +	uint8_t			*src = args->value;
> +	int			blkcnt;
> +	int			valuelen;
> +	int			nmap;
> +	int			error;
> +	int			offset = 0;
> +
> +
>  	/*
>  	 * Roll through the "value", copying the attribute value to the
>  	 * already-allocated blocks.  Blocks are written synchronously
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index 9d20b66..2a73cd9 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -11,5 +11,7 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>  int xfs_attr_rmtval_get(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set(struct xfs_da_args *args);
>  int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> -
> +int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
> +int xfs_attr_rmt_find_hole(struct xfs_da_args *args, int *blkcnt,
> +			   xfs_fileoff_t *lfileoff);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> -- 
> 2.7.4
> 
