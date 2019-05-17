Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82CEB220CD
	for <lists+linux-xfs@lfdr.de>; Sat, 18 May 2019 01:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfEQXvI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 19:51:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41532 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfEQXvI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 19:51:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4HNhkJx118645;
        Fri, 17 May 2019 23:50:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=OSeuM+pBYbMm9wo5BkbOOf2LeFqzUcFjFW8YUkjOBl4=;
 b=rD2mS+jzBsoqNhJ+e0DpKm1lcxK6yx0GCmiZLf6O1urEE9Hw8xPoh4RekRKlpm1DQnRP
 mW5iG0rSnzI1ydAxOSEqhvTCt/ePBdgOqpjgrE+dhUdoejzZ50waIXbr4XRWCMI2gWwZ
 n90vDVtkJU30t7UfwAcwa/G9k2G5U0GdeiVVJb7LQdPWA6PLWwQCeXmkFJ1SKlsUwkAY
 a/HYieAyffqQc7XyccPhbO99qqaq+ZG8aorOn74MDb2zQw0uTb1WVCCiIt/oK4y/Scm9
 8oiUMnQ2A08Rvb94Z9YGMJxwx7Sbdg1GOe2smhUd+Z/cJNrHhADCnZmcJDZJd/VqDn+R NA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2sdq1r4e86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 23:50:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4HNnXm6042864;
        Fri, 17 May 2019 23:50:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2sgp33vg2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 23:50:50 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4HNonVu012925;
        Fri, 17 May 2019 23:50:49 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 May 2019 16:50:49 -0700
Subject: Re: [PATCH 8/3] xfs: factor log item initialisation
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
 <31991357-c836-6a50-4203-dae25c051def@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <d1ea0ec3-cf18-9f68-c5ab-e575e2cac914@oracle.com>
Date:   Fri, 17 May 2019 16:50:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <31991357-c836-6a50-4203-dae25c051def@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9260 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905170143
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9260 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905170143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/16/19 1:41 PM, Eric Sandeen wrote:
> Each log item type does manual initialisation of the log item.
> Delayed logging introduces new fields that need initialisation, so
> factor all the open coded initialisation into a common function
> first.
> 
> Source kernel commit: 43f5efc5b59db1b66e39fe9fdfc4ba6a27152afa
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good to me.
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   libxfs/libxfs_priv.h |  1 +
>   libxfs/logitem.c     |  8 ++------
>   libxfs/util.c        | 12 ++++++++++++
>   3 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 157a99d6..7551ed65 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -564,6 +564,7 @@ int xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
>   
>   
>   bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
> +void xfs_log_item_init(struct xfs_mount *, struct xfs_log_item *, int);
>   #define xfs_log_in_recovery(mp)	(false)
>   
>   /* xfs_icache.c */
> diff --git a/libxfs/logitem.c b/libxfs/logitem.c
> index e862ab4f..14c62f67 100644
> --- a/libxfs/logitem.c
> +++ b/libxfs/logitem.c
> @@ -103,9 +103,7 @@ xfs_buf_item_init(
>   	fprintf(stderr, "adding buf item %p for not-logged buffer %p\n",
>   		bip, bp);
>   #endif
> -	bip->bli_item.li_type = XFS_LI_BUF;
> -	bip->bli_item.li_mountp = mp;
> -	INIT_LIST_HEAD(&bip->bli_item.li_trans);
> +	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF);
>   	bip->bli_buf = bp;
>   	bip->__bli_format.blf_type = XFS_LI_BUF;
>   	bip->__bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
> @@ -149,8 +147,6 @@ xfs_inode_item_init(
>   		ip->i_ino, iip);
>   #endif
>   
> -	iip->ili_item.li_type = XFS_LI_INODE;
> -	iip->ili_item.li_mountp = mp;
> -	INIT_LIST_HEAD(&iip->ili_item.li_trans);
> +	xfs_log_item_init(mp, &iip->ili_item, XFS_LI_INODE);
>   	iip->ili_inode = ip;
>   }
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 4901123a..aff91080 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -691,6 +691,18 @@ xfs_log_check_lsn(
>   	return true;
>   }
>   
> +void
> +xfs_log_item_init(
> +	struct xfs_mount	*mp,
> +	struct xfs_log_item	*item,
> +	int			type)
> +{
> +	item->li_mountp = mp;
> +	item->li_type = type;
> +
> +	INIT_LIST_HEAD(&item->li_trans);
> +}
> +
>   static struct xfs_buftarg *
>   xfs_find_bdev_for_inode(
>   	struct xfs_inode	*ip)
> 
