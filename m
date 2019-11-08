Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6FE8F509E
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Nov 2019 17:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfKHQHH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Nov 2019 11:07:07 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60112 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfKHQHG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 11:07:06 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8G41eA122090;
        Fri, 8 Nov 2019 16:07:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=3wPHrmfo4jApDjzH88mApvSpTb4FBZV+yreBwgcEDxY=;
 b=mvqjEmYZ8c3AXcKbIfMoeAGbg/poVH3G5qpO9GqfupR46/aoMODhssBCi16XXn8En+JS
 91oBEG3/v9KyiKoxBc5VR+AU//zM5yewZ7e5fSwinds/Rs8NiNjHnd5Aq+UcCA04ACCd
 7CrLkeGPVgpt7TJJwRoENseAtJjuXuERkx6xWw7AvSrgat5BoTgQw4AqycZoMO8Da9bU
 qBsbDpIsZr+CghsfNkzTLR3wx5dUsJT/cLdetpj3ICYNLAib+X9ZiEK2RdLjpFZAF6mO
 1K9E1gefVjmw4N93KQhvXv5eAGCoRct9cq+faTKt7YExK3zeaERUXQbrh6e+qaATJ/1t Fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2w41w1681b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 16:07:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8G4PwJ001740;
        Fri, 8 Nov 2019 16:07:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w50m5jsp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 16:07:01 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA8G70RF007380;
        Fri, 8 Nov 2019 16:07:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 08:07:00 -0800
Date:   Fri, 8 Nov 2019 08:06:58 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Ian Kent <raven@themaw.net>, linux-xfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: remove a stray tab in xfs_remount_rw()
Message-ID: <20191108160658.GT6219@magnolia>
References: <20191108051121.GA26279@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108051121.GA26279@mwanda>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080160
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 08, 2019 at 08:11:22AM +0300, Dan Carpenter wrote:
> The extra tab makes the code slightly confusing.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index b3188ea49413..ede6fac47c56 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1599,7 +1599,7 @@ xfs_remount_rw(
>  	if (error) {
>  		xfs_err(mp,
>  			"Error %d recovering leftover CoW allocations.", error);
> -			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>  		return error;
>  	}
>  	xfs_start_block_reaping(mp);
> -- 
> 2.20.1
> 
