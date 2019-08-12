Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8536E8A70E
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 21:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfHLT2o (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 15:28:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42796 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfHLT2n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 15:28:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJECZ6113057
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:28:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=MwzMrqc+Y+XXPHSyComOBMQz5Ci+jElj8PkRwTbuoe8=;
 b=WVSqAYPM+p5+j9O/BfsZTMZLIFZEDAb/dbOgQLG/P+8XOXkJegOX3Muu3UrGOuZ2GKpT
 1x0GTRXxqJQGh8Ijqyom78SeYKx9SeEar3Kyryvw4hTnfDEubWINKo9uLQedKj7x37Fh
 aDZnoG3flbRFFrTlE8Q16UyQ0zbCTw3z/eLQZCbn/ZvP8sCxpadUVzOdHqtMeSjbRU2s
 vXfndRzbO99xRc+O1APRO0G03yCx37XET2nBMtlyummfaGoGA4lCFxDVWPlV+bW8ytmS
 lmkokpfgPcIx5GO9L4RM/P5rzmK7g9tPAjPb0/jvty4K1xNhjer77daQ0W4Yq/j7G3bV Tg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=MwzMrqc+Y+XXPHSyComOBMQz5Ci+jElj8PkRwTbuoe8=;
 b=4WJrSyfeaKcxTp0/LMJ9w8NuqOH4DCkVy+0c4j9VIwTFXEmXuAcO3qIiamORbhtdXi3F
 9IVMhWN1LfawSe6Rzz11jZhSxesBCmjmXZYLvL7xZk16gUy1VffIoplS2NYlWjSVg+su
 +ZswHedXjZ3YeeHzPWOM+LN+mpQGb4qjLik4Uyco3gdchgBQvhyHDb6tzX3APhZNHxdq
 hvWdBJZj8TEAO6gsnTK/deMvlNXh7AI8KOc5T8/VvNmbIDYul303iewpEQS+6ref9BD0
 RD13DbsClxmuhOA9UI0PpPg17CAxbGCNbjG/drFikvPxfPf1ouK3YFv46oCd8an8m/ex pQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u9pjq9n1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:28:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJDLS7147987
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:28:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2u9n9h88h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:28:42 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CJSfDr011347
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:28:41 GMT
Received: from [192.168.1.9] (/174.18.98.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 12:28:41 -0700
From:   Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v2 04/18] xfs: Add xfs_attr_set_deferred and
 xfs_attr_remove_deferred
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-5-allison.henderson@oracle.com>
 <20190812154429.GS7138@magnolia>
Message-ID: <c13158c2-d588-7f39-887a-186bf64fc1eb@oracle.com>
Date:   Mon, 12 Aug 2019 12:28:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812154429.GS7138@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/12/19 8:44 AM, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:37:12PM -0700, Allison Collins wrote:
>> From: Allison Henderson <allison.henderson@oracle.com>
>>
>> These routines set up set and start a new deferred attribute
>> operation.  These functions are meant to be called by other
>> code needing to initiate a deferred attribute operation.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr.h |  5 ++++
>>   2 files changed, 79 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 1f76618..a2fba0c 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -25,6 +25,7 @@
>>   #include "xfs_trans_space.h"
>>   #include "xfs_trace.h"
>>   #include "xfs_attr_item.h"
>> +#include "xfs_attr.h"
>>   
>>   /*
>>    * xfs_attr.c
>> @@ -399,6 +400,48 @@ xfs_attr_set(
>>   	goto out_unlock;
>>   }
>>   
>> +/* Sets an attribute for an inode as a deferred operation */
>> +int
>> +xfs_attr_set_deferred(
>> +	struct xfs_inode	*dp,
>> +	struct xfs_trans	*tp,
>> +	struct xfs_name		*name,
>> +	const unsigned char	*value,
>> +	unsigned int		valuelen)
>> +{
>> +
>> +	struct xfs_attr_item	*new;
>> +	char			*name_value;
>> +
>> +	/*
>> +	 * All set operations must have a name but not necessarily a value.
>> +	 */
>> +	if (!name->len) {
>> +		ASSERT(0);
>> +		return -EINVAL;
>> +	}
>> +
>> +	new = kmem_alloc_large(XFS_ATTR_ITEM_SIZEOF(name->len, valuelen),
>> +			 KM_SLEEP|KM_NOFS);
>> +	name_value = ((char *)new) + sizeof(struct xfs_attr_item);
>> +	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(name->len, valuelen));
>> +	new->xattri_ip = dp;
>> +	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_SET;
>> +	new->xattri_name_len = name->len;
>> +	new->xattri_value_len = valuelen;
>> +	new->xattri_flags = name->type;
>> +	memcpy(&name_value[0], name->name, name->len);
>> +	new->xattri_name = name_value;
>> +	new->xattri_value = name_value + name->len;
>> +
>> +	if (valuelen > 0)
>> +		memcpy(&name_value[name->len], value, valuelen);
>> +
>> +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
>> +
>> +	return 0;
>> +}
>> +
>>   /*
>>    * Generic handler routine to remove a name from an attribute list.
>>    * Transitions attribute list from Btree to shortform as necessary.
>> @@ -480,6 +523,37 @@ xfs_attr_remove(
>>   	return error;
>>   }
>>   
>> +/* Removes an attribute for an inode as a deferred operation */
>> +int
>> +xfs_attr_remove_deferred(
>> +	struct xfs_inode        *dp,
>> +	struct xfs_trans	*tp,
>> +	struct xfs_name		*name)
>> +{
>> +
>> +	struct xfs_attr_item	*new;
>> +	char			*name_value;
>> +
>> +	if (!name->len) {
>> +		ASSERT(0);
>> +		return -EINVAL;
>> +	}
>> +
>> +	new = kmem_alloc(XFS_ATTR_ITEM_SIZEOF(name->len, 0), KM_SLEEP|KM_NOFS);
>> +	name_value = ((char *)new) + sizeof(struct xfs_attr_item);
>> +	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(name->len, 0));
>> +	new->xattri_ip = dp;
>> +	new->xattri_op_flags = XFS_ATTR_OP_FLAGS_REMOVE;
>> +	new->xattri_name_len = name->len;
>> +	new->xattri_value_len = 0;
>> +	new->xattri_flags = name->type;
>> +	memcpy(name_value, name->name, name->len);
>> +
>> +	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
> 
> Can the common parts of these two functions be refactored into a single
> initialization function called from xfs_attr_{set,remove}_deferred,
> similar to what xfs_rmap.c does for all the various deferred rmap calls?
> 
> --D

Sure, I can add a quick init routine.

Thx!
Allison

> 
>> +
>> +	return 0;
>> +}
>> +
>>   /*========================================================================
>>    * External routines when attribute list is inside the inode
>>    *========================================================================*/
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 9132d4f..0bade83 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -177,5 +177,10 @@ bool xfs_attr_namecheck(const void *name, size_t length);
>>   int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
>>   		       struct xfs_name *name);
>>   int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
>> +int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
>> +			  struct xfs_name *name, const unsigned char *value,
>> +			  unsigned int valuelen);
>> +int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
>> +			    struct xfs_name *name);
>>   
>>   #endif	/* __XFS_ATTR_H__ */
>> -- 
>> 2.7.4
>>
