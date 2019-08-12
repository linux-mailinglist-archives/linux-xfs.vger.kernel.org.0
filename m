Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76CF48A28F
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 17:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfHLPod (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 11:44:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48946 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfHLPod (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 11:44:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CFhRqJ135107
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 15:44:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=PCk4CyX5HtR6WdQftrdzfhPKxSnxkLeOKyodYLip678=;
 b=oix3kjW5VgeOifWCJKlbi9OewE4FmRipfTAvZrDOMq87BdzckELBQQu9JQlQDCmxmky7
 tUjBFxukR5RQZ3JGO3jHAPSntrQ14sgnN+Ubabtgw17FzQDEbNXSCbvgVsUaGu3IELVI
 FOiBBvVlXIymqT2yoSq0cEQdhsULxkMi+lYsDX9j2+xEiLxcMjFPUNCfjo874Ryix8aN
 l1oJmi9lW4gEhtNC2/CgRx87O7vm+2l3PZM5KurDhA8n3eTdo/aTphhyChyLkn5Tn8TK
 +Zq2eoi/kpMzW/h5mZ2ZsVJoCjcb2x6x2Pw9SskpHKxmHEJ+ooXZjJU4VOstva0mAA+w eQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=PCk4CyX5HtR6WdQftrdzfhPKxSnxkLeOKyodYLip678=;
 b=FvQM+dFZrR9R77lh6XiM6DGdtyudd5McWsyQHRRPP23B/Ayj0HdMFx/M0iuuhsvuHynO
 58wwQB4FPXoFAKRVaJvdHCJRrcGTex5RcUDfO3Y0UdFZM2N1QEpMDRseLpubHZmXrtKH
 rZIW4te/44AuOO6hiGUEqWVqfQKHydr0Mf0BKRxDt0ajyuvDZfCcVsw0hCfjmR5PMbw8
 wvkW6PredItdRUf9GueJouGPZk2oLscj3VpdZjJOA2nBpPlM6G3OaERElHW8GbN3YwL+
 jKLwxWbQDOhW9GmAK4Is0rocqnrTWRCQhOUd32p3ME50lgFO9AefVbHr5QeRpzs9GOzJ GQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u9nvp0h4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 15:44:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CFgZ5k008902
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 15:44:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2u9nre0pxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 15:44:31 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CFiUNY016574
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 15:44:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 08:44:30 -0700
Date:   Mon, 12 Aug 2019 08:44:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 04/18] xfs: Add xfs_attr_set_deferred and
 xfs_attr_remove_deferred
Message-ID: <20190812154429.GS7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-5-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-5-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:12PM -0700, Allison Collins wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> These routines set up set and start a new deferred attribute
> operation.  These functions are meant to be called by other
> code needing to initiate a deferred attribute operation.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr.h |  5 ++++
>  2 files changed, 79 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 1f76618..a2fba0c 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -25,6 +25,7 @@
>  #include "xfs_trans_space.h"
>  #include "xfs_trace.h"
>  #include "xfs_attr_item.h"
> +#include "xfs_attr.h"
>  
>  /*
>   * xfs_attr.c
> @@ -399,6 +400,48 @@ xfs_attr_set(
>  	goto out_unlock;
>  }
>  
> +/* Sets an attribute for an inode as a deferred operation */
> +int
> +xfs_attr_set_deferred(
> +	struct xfs_inode	*dp,
> +	struct xfs_trans	*tp,
> +	struct xfs_name		*name,
> +	const unsigned char	*value,
> +	unsigned int		valuelen)
> +{
> +
> +	struct xfs_attr_item	*new;
> +	char			*name_value;
> +
> +	/*
> +	 * All set operations must have a name but not necessarily a value.
> +	 */
> +	if (!name->len) {
> +		ASSERT(0);
> +		return -EINVAL;
> +	}
> +
> +	new = kmem_alloc_large(XFS_ATTR_ITEM_SIZEOF(name->len, valuelen),
> +			 KM_SLEEP|KM_NOFS);
> +	name_value = ((char *)new) + sizeof(struct xfs_attr_item);
> +	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(name->len, valuelen));
> +	new->xattri_ip = dp;
> +	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_SET;
> +	new->xattri_name_len = name->len;
> +	new->xattri_value_len = valuelen;
> +	new->xattri_flags = name->type;
> +	memcpy(&name_value[0], name->name, name->len);
> +	new->xattri_name = name_value;
> +	new->xattri_value = name_value + name->len;
> +
> +	if (valuelen > 0)
> +		memcpy(&name_value[name->len], value, valuelen);
> +
> +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> +
> +	return 0;
> +}
> +
>  /*
>   * Generic handler routine to remove a name from an attribute list.
>   * Transitions attribute list from Btree to shortform as necessary.
> @@ -480,6 +523,37 @@ xfs_attr_remove(
>  	return error;
>  }
>  
> +/* Removes an attribute for an inode as a deferred operation */
> +int
> +xfs_attr_remove_deferred(
> +	struct xfs_inode        *dp,
> +	struct xfs_trans	*tp,
> +	struct xfs_name		*name)
> +{
> +
> +	struct xfs_attr_item	*new;
> +	char			*name_value;
> +
> +	if (!name->len) {
> +		ASSERT(0);
> +		return -EINVAL;
> +	}
> +
> +	new = kmem_alloc(XFS_ATTR_ITEM_SIZEOF(name->len, 0), KM_SLEEP|KM_NOFS);
> +	name_value = ((char *)new) + sizeof(struct xfs_attr_item);
> +	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(name->len, 0));
> +	new->xattri_ip = dp;
> +	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_REMOVE;
> +	new->xattri_name_len = name->len;
> +	new->xattri_value_len = 0;
> +	new->xattri_flags = name->type;
> +	memcpy(name_value, name->name, name->len);
> +
> +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);

Can the common parts of these two functions be refactored into a single
initialization function called from xfs_attr_{set,remove}_deferred,
similar to what xfs_rmap.c does for all the various deferred rmap calls?

--D

> +
> +	return 0;
> +}
> +
>  /*========================================================================
>   * External routines when attribute list is inside the inode
>   *========================================================================*/
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 9132d4f..0bade83 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -177,5 +177,10 @@ bool xfs_attr_namecheck(const void *name, size_t length);
>  int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
>  		       struct xfs_name *name);
>  int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
> +int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
> +			  struct xfs_name *name, const unsigned char *value,
> +			  unsigned int valuelen);
> +int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
> +			    struct xfs_name *name);
>  
>  #endif	/* __XFS_ATTR_H__ */
> -- 
> 2.7.4
> 
