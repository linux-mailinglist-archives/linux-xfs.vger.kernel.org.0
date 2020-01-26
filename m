Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDE7149D4B
	for <lists+linux-xfs@lfdr.de>; Sun, 26 Jan 2020 23:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgAZWO3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 Jan 2020 17:14:29 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51224 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbgAZWO3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 17:14:29 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QMEHUv042418;
        Sun, 26 Jan 2020 22:14:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=MkNquIIheHB5PfocbK1oMqtBBAPCYd+TjuRwBX7HNhs=;
 b=kqhqcsj6YSXBMN8JKXVOGbVFdOEeFsh5DlcY+oVlLfom7Hsg8VSjitsSbAqbAUI/1BOk
 mzl45WAapgQc7qfx+U0NcnvJKJhuw8UFT601gMlJ30ujnzVYbMy+j0JK3eHkApphnIAn
 2LL2lk0sup58bQQOEQOta6EEnSEl+RNTcze944RVd1CuR3bZmc2ksu6692U/M9gNsh1X
 RK5P891ph9juqWcOs1phqT1xWTK1oO8dRb0L+Fmc4fJ5n5B3GtpmvIKZisGvDA5k4qKT
 4nQGZqOSUxjLjVkKPFNs93+wKdbv0DsEOP6V4gcatJo3wuaVH1DfmMpD0RmqZOnF98rx Xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xreaqvc1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:14:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00QMEOrn152814;
        Sun, 26 Jan 2020 22:14:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xrytnpxf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 26 Jan 2020 22:14:24 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00QMDItk017940;
        Sun, 26 Jan 2020 22:13:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 26 Jan 2020 14:13:18 -0800
Date:   Sun, 26 Jan 2020 14:13:17 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfsprogs: remove the SIZEOF_CHAR_P substitution in
 platform_defs.h.in
Message-ID: <20200126221317.GE3447196@magnolia>
References: <20200126113541.787884-1-hch@lst.de>
 <20200126113541.787884-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200126113541.787884-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=9 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001260193
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9512 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001260193
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 26, 2020 at 12:35:38PM +0100, Christoph Hellwig wrote:
> SIZEOF_CHAR_P is not used anywhere in the code, so remove the reference
> to it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Woo.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  include/platform_defs.h.in | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
> index 6cc56e31..ff0a6a4e 100644
> --- a/include/platform_defs.h.in
> +++ b/include/platform_defs.h.in
> @@ -28,7 +28,6 @@ typedef struct filldir		filldir_t;
>  
>  /* long and pointer must be either 32 bit or 64 bit */
>  #undef SIZEOF_LONG
> -#undef SIZEOF_CHAR_P
>  #define BITS_PER_LONG (SIZEOF_LONG * CHAR_BIT)
>  
>  /* Check whether to define umode_t ourselves. */
> -- 
> 2.24.1
> 
