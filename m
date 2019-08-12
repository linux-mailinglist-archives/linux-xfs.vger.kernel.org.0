Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF7DA8A2D4
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 18:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbfHLQDr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 12:03:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51934 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfHLQDr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:03:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CFxIU4122670
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=eJ+tqhp3NgJHC6xrftUyvQtCPZ44Q1QfvwQCmNx66yI=;
 b=bNG8+9WXLicKlUyThNI+AZz3WNQq6BYULMjbZN/qLvEOEBJ3Q4uZtL0mHxnlleprtHEy
 cf4TAalBSxOmAxSc9qy+6vYb/ViYnqv3BlvfKdWBMdv+dwZXZdYf6gzclP4tOAhuVH84
 3xJ1KpcucyarRdaX3zo4KyKG8xb+QTq98uwsnwOqVuajrmGDGwBC7j4aN89E+zNKK+Z/
 3FEItnVx1XmO7Zsaa4ZkcUuji4YxugD7Go9ctc8TIvV5zGRwl6IWgB8a+xpnliJ8l+I8
 OKEh8ztJf57QOfysojqix7rxvTuCCXixci0XO0GluP8Jt/M6Z5fVwJMqJrjtzqIoaoQs Jw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=eJ+tqhp3NgJHC6xrftUyvQtCPZ44Q1QfvwQCmNx66yI=;
 b=IX0ZXBo4M2SWyaplkVvVjNMwgWKszhswymyCmhTa72pFN+aiJSnK3ZY1ZjbNhskXJ+Lh
 jLcrVjkxymoIUbeB4HlziOUzi2r5qm773XMNp0/PChqBJmsEF+mS2y+KWjLxTS/XK+NQ
 Q1SxfDYZ2osC58jzL3PZ9zIKAHUWzJMU5e6IoKMHRUeYhfx7U6X/p0uKs3V/QNUBlKZB
 zgihiVO9m7TO01ZXUAoDWmmcxWtn+gntVGaypUuuBo+kv0FIUty0lIaFA8bWk9Jc4l46
 R7Rr5EmS64/PQ/UgXuDUSbWqNxvawjBRJYSD6ReuqykiON1QgqAommxWJX3P62UEAIBO Zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2u9nbt8n2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:03:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CG2f7m177570
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:03:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2u9m0aareq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:03:45 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CG2rNo022351
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:02:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 09:02:53 -0700
Date:   Mon, 12 Aug 2019 09:02:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 07/18] xfs: Factor up trans handling in
 xfs_attr3_leaf_flipflags
Message-ID: <20190812160252.GV7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-8-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-8-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120179
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

On Fri, Aug 09, 2019 at 02:37:15PM -0700, Allison Collins wrote:
> Since delayed operations cannot roll transactions, factor
> up the transaction handling into the calling function
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c      | 10 ++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.c |  5 -----
>  2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 72af8e2..f36c792 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -752,6 +752,11 @@ xfs_attr_leaf_addname(
>  		error = xfs_attr3_leaf_flipflags(args);
>  		if (error)
>  			return error;
> +		/*
> +		 * Commit the flag value change and start the next trans in
> +		 * series.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>  
>  		/*
>  		 * Dismantle the "old" attribute/value pair by removing
> @@ -1090,6 +1095,11 @@ xfs_attr_node_addname(
>  		error = xfs_attr3_leaf_flipflags(args);
>  		if (error)
>  			goto out;
> +		/*
> +		 * Commit the flag value change and start the next trans in
> +		 * series
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>  
>  		/*
>  		 * Dismantle the "old" attribute/value pair by removing
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 8d2e11f..8a6f5df 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2891,10 +2891,5 @@ xfs_attr3_leaf_flipflags(
>  			 XFS_DA_LOGRANGE(leaf2, name_rmt, sizeof(*name_rmt)));
>  	}
>  
> -	/*
> -	 * Commit the flag value change and start the next trans in series.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
> -
>  	return error;
>  }
> -- 
> 2.7.4
> 
