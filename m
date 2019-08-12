Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B06BE8A38F
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 18:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfHLQmm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 12:42:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46630 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfHLQmm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:42:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGcgo9158961
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:42:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=qCLmzVqromLiNCvz31ieKazrE8jL5vUdw4zKjxxcSR8=;
 b=LYfG9NTnUnifRZxmPpjoVfmqjbE8htHvDHHDFBcpzxbqm0/omevuOJ1XzgMdYusJmtKT
 BeTXeD6thSfrQUz31T++ZLmec2xYWGiG5DyTh6qq1Z2iRMmHC7r8O1b4kidqS1XzYBcM
 XK7+6I2GZUxAuzTtxJlvtH1hTbynzvF2BgYZuy63byND3uF2ffRRISylpAPTaHGBkD7l
 pX8w3Qkpdz6/avvlEVHkWSdKUAJeFOaQ+ASb8xt35XOMOKHwONxndBVuSYj1qQDOGmD/
 bR/Qt9n5pAC1tv2ig+h5pB0fb1N+k909fsDaol8MD0VuSKCgtmZTzfxi0eBBNWYJDKAE ow== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=qCLmzVqromLiNCvz31ieKazrE8jL5vUdw4zKjxxcSR8=;
 b=4xDc6SVu/T/l1Z5mL0zUYAPND9PK2Zle/150c8Aq9DUYTecRk7bJ12pvLrI1P3F3eC6r
 bUUeSzoqVlW20Spg3PBrn56M5AwQe68HgZfIb70kYgmjM+QGjf/ycDv9+Yvss4GA2pJa
 Ke7ewUQaxs3ukanz9/iabLU1N3HloQ+d9AJc8Y2L3tbA2clXwh1HBfoPmirVd2Te9Tw3
 YKXNok92PQmsrC00kKLrXbbHYkSxkljdzRlfSdxh2cg4nj2w5WhgegcIFwZcdVfeiKlW
 9RxXXmbtGvVLRz4Qo1QUk0CWxR1px5x98rHZLRHpQ0tHdpm/i3ZfF9B/oSPEt8HZyJxY 4w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2u9nbt8v67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:42:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGd7Ng080655
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:42:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2u9m0abxbg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:42:40 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CGgdCV001932
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:42:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 09:42:39 -0700
Date:   Mon, 12 Aug 2019 09:42:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 17/18] xfs: Enable delayed attributes
Message-ID: <20190812164238.GD7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-18-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-18-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120186
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:25PM -0700, Allison Collins wrote:
> Finally enable delayed attributes in xfs_attr_set and
> xfs_attr_remove.  We only do this for v4 and up since we
> cant add new log entries to old fs versions

...you can't add new log item types to *existing* fs versions, which
includes everything through present-day v5.

This needs a separate feature bit somewhere to prevent existing xfs
drivers from crashing and burning on attri/attrd items.  Most of this
deferred attr code could exist independently from the parent pointer
feature, so I guess you could be the first person to use one of the log
incompat feature bits?  That would be one way to get wider testing of
deferred attrs while we work on parent pointers.

--D

> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 9931e50..7023734 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -506,6 +506,7 @@ xfs_attr_set(
>  	int			valuelen)
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_sb		*sbp = &mp->m_sb;
>  	struct xfs_da_args	args;
>  	struct xfs_trans_res	tres;
>  	int			rsvd = (name->type & ATTR_ROOT) != 0;
> @@ -564,7 +565,20 @@ xfs_attr_set(
>  		goto out_trans_cancel;
>  
>  	xfs_trans_ijoin(args.trans, dp, 0);
> -	error = xfs_attr_set_args(&args);
> +	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
> +		error = xfs_attr_set_args(&args);
> +	else {
> +		error = xfs_has_attr(&args);
> +
> +		if (error == -EEXIST && (name->type & ATTR_CREATE))
> +			goto out_trans_cancel;
> +
> +		if (error == -ENOATTR && (name->type & ATTR_REPLACE))
> +			goto out_trans_cancel;
> +
> +		error = xfs_attr_set_deferred(dp, args.trans, name, value,
> +					      valuelen);
> +	}
>  	if (error)
>  		goto out_trans_cancel;
>  	if (!args.trans) {
> @@ -649,6 +663,7 @@ xfs_attr_remove(
>  	struct xfs_name		*name)
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_sb		*sbp = &mp->m_sb;
>  	struct xfs_da_args	args;
>  	int			error;
>  
> @@ -690,7 +705,14 @@ xfs_attr_remove(
>  	 */
>  	xfs_trans_ijoin(args.trans, dp, 0);
>  
> -	error = xfs_attr_remove_args(&args);
> +	error = xfs_has_attr(&args);
> +	if (error == -ENOATTR)
> +		goto out;
> +
> +	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
> +		error = xfs_attr_remove_args(&args);
> +	else
> +		error = xfs_attr_remove_deferred(dp, args.trans, name);
>  	if (error)
>  		goto out;
>  
> -- 
> 2.7.4
> 
