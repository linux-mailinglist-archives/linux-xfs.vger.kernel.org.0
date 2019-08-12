Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34FAB8A2EC
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 18:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfHLQG7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 12:06:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56340 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbfHLQG7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:06:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CG42uH127740
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:06:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=iACC1TTOKPP6/wTwLi8yer24u8nLGR8PEHscSseN+Jg=;
 b=N0np7QFrJRz9Lbga/zWdio47sSM9irY8akrivGvOKCXcfmH6CMYZh5OrUvmOZOF7bzOE
 iKyZr/uoPUF5XxxmPvH7LaTuZYx/WzLtx7KCUBUSzWYTmefeXiRomtcEV6a9H9SWBkTL
 PUmLl12fF87C4xaMQehVki0I/VmDW0y7z6ZzivkkG+MN8zG6cvtjrmLTAcUeD4fRMJed
 ogQ14Ky8T/hZOgjqJGHRi2xqD67orIrf8tN28aiCLBjiIdrqe1ByQ36BC+mvKnqpmn/M
 CKQ3f32lJZ9WztkOZM4cmPE22I3gay/dr5uEnjlTOJTp4wvoIXz5iUD502/MRc8P9UdG Hw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=iACC1TTOKPP6/wTwLi8yer24u8nLGR8PEHscSseN+Jg=;
 b=gOmzKgydtycTAcq+FoeYwWybrp5agpZbj2xa1JFPecjfzQOAKTpn7bDuVk3tdS6Mx+/n
 rqsJmnCbc+jhEmQXzQqmCkqJLQjalryPz22eBXCTK8fZ3Zxh5UEVqMy6brG+WXw2O4Lu
 OCjrfcqhNYXkU6CJGipwTzdzQMJfwnP9YCS0dqWPEbhQ2iJdF3n70hb35K9q66FxEfL8
 +YbsF6FQmUAtVcmqzx4gjp3vz4ckOjAMqNMQcXBpC2YxYvqRebpeXJaJ/Tw6w8rcdSUU
 7vMjeJjzjk46WlaP0QQ8I3LX2dIxCR8YcN/YetM0jg6+C9xh4Uza3QLJTK+IdoXSCw0r Og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbt8nqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:06:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CG2fss189060
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:06:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2u9n9h1epb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:06:57 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CG6uW7010182
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:06:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 09:06:56 -0700
Date:   Mon, 12 Aug 2019 09:06:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 08/18] xfs: Factor out xfs_attr_leaf_addname helper
Message-ID: <20190812160655.GW7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-9-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-9-allison.henderson@oracle.com>
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
 definitions=main-1908120179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:16PM -0700, Allison Collins wrote:
> Factor out new helper function xfs_attr_leaf_try_add.
> Because new delayed attribute routines cannot roll
> transactions, we carve off the parts of
> xfs_attr_leaf_addname that we can use.  This will help
> to reduce repetitive code later when we introduce
> delayed attributes.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 43 +++++++++++++++++++++++++++++--------------
>  1 file changed, 29 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index f36c792..f9d5e28 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -635,19 +635,12 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>   * External routines when attribute list is one block
>   *========================================================================*/
>  
> -/*
> - * Add a name to the leaf attribute list structure
> - *
> - * This leaf block cannot have a "remote" value, we only call this routine
> - * if bmap_one_block() says there is only one block (ie: no remote blks).
> - */
>  STATIC int
> -xfs_attr_leaf_addname(
> -	struct xfs_da_args	*args)
> +xfs_attr_leaf_try_add(
> +	struct xfs_da_args	*args,
> +	struct xfs_buf		*bp)
>  {
> -	struct xfs_buf		*bp;
> -	int			retval, error, forkoff;
> -	struct xfs_inode	*dp = args->dp;
> +	int			retval, error;
>  
>  	trace_xfs_attr_leaf_addname(args);
>  
> @@ -692,13 +685,35 @@ xfs_attr_leaf_addname(
>  	retval = xfs_attr3_leaf_add(bp, args);
>  	if (retval == -ENOSPC) {
>  		/*
> -		 * Promote the attribute list to the Btree format, then
> -		 * Commit that transaction so that the node_addname() call
> -		 * can manage its own transactions.
> +		 * Promote the attribute list to the Btree format,

Why does the sentence end with a comma?

>  		 */
>  		error = xfs_attr3_leaf_to_node(args);
>  		if (error)
>  			return error;
> +	}
> +	return retval;
> +}
> +
> +
> +/*
> + * Add a name to the leaf attribute list structure
> + *
> + * This leaf block cannot have a "remote" value, we only call this routine
> + * if bmap_one_block() says there is only one block (ie: no remote blks).
> + */
> +STATIC int
> +xfs_attr_leaf_addname(struct xfs_da_args	*args)
> +{
> +	int retval, error, forkoff;

Indentation problem here.

--D

> +	struct xfs_buf		*bp = NULL;
> +	struct xfs_inode	*dp = args->dp;
> +
> +	retval = xfs_attr_leaf_try_add(args, bp);
> +	if (retval == -ENOSPC) {
> +		/*
> +		 * Commit that transaction so that the node_addname() call
> +		 * can manage its own transactions.
> +		 */
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
>  			return error;
> -- 
> 2.7.4
> 
