Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5C4192035
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Mar 2020 05:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgCYEoB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Mar 2020 00:44:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49120 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgCYEoA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 00:44:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P4dIp7185981;
        Wed, 25 Mar 2020 04:43:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=//26bbKUSoWe/XiTBe158rNOi4Sf5rXf3e4ShTjXnGs=;
 b=cTkwH7g3U0EJpC6R7/ez0dLMYX0TrXpvtCM1I7cP0t+7O/2m/oDEqb2H3f//NqaS2/69
 XN2o/jRswXFwyIkR2jsyOLNLg1pgjK5q6XTlny2UXsFAUgY4NuFKRbIK8BTKkesV3WYL
 L81vxLd2QOQyCcZBCeYq5jqn/Ws5/XU0WP9PC6c0LbY1Kwu99fvdHwnCma9sv5vKDuLd
 JackqeEKprkj8qg60Oh2gcpHtdNJX2E6Jhs364cG84QenDzGu8MSnHArin/JdRmcpHzP
 uaCP90DsZ8gMTFFfpNo4ei20Rpt8K6vdc6zijTOD257dAzON2/MYGcrGFB+1k1hAjDU2 ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ywabr7s0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 04:43:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P4QphE009726;
        Wed, 25 Mar 2020 04:43:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yymbvebnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Mar 2020 04:43:58 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02P4hwps013794;
        Wed, 25 Mar 2020 04:43:58 GMT
Received: from [192.168.1.223] (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 21:43:57 -0700
Subject: Re: [PATCH 5/8] xfs: correctly acount for reclaimable slabs
To:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20200325014205.11843-1-david@fromorbit.com>
 <20200325014205.11843-6-david@fromorbit.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <8c9d9cee-7aab-ddca-5de9-8d38841402f1@oracle.com>
Date:   Tue, 24 Mar 2020 21:43:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200325014205.11843-6-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250038
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250038
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 3/24/20 6:42 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The XFS inode item slab actually reclaimed by inode shrinker
> callbacks from the memory reclaim subsystem. These should be marked
> as reclaimable so the mm subsystem has the full picture of how much
> memory it can actually reclaim from the XFS slab caches.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Looks fine
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/xfs_super.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 2094386af8aca..68fea439d9743 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1861,7 +1861,8 @@ xfs_init_zones(void)
>   
>   	xfs_ili_zone = kmem_cache_create("xfs_ili",
>   					 sizeof(struct xfs_inode_log_item), 0,
> -					 SLAB_MEM_SPREAD, NULL);
> +					 SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
> +					 NULL);
>   	if (!xfs_ili_zone)
>   		goto out_destroy_inode_zone;
>   
> 
