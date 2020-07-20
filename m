Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E1C225554
	for <lists+linux-xfs@lfdr.de>; Mon, 20 Jul 2020 03:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgGTBVz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 19 Jul 2020 21:21:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60604 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgGTBVz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Jul 2020 21:21:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06K1L50A020461;
        Mon, 20 Jul 2020 01:21:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=TqwG6GjCZJvPd6btCK+p4+IwmQ2IazMol2QhJmaXixI=;
 b=CMvn9Pdm4NpPy1CJyEq5HKdrbXga/aliGzH/pEw+/Mea6QYmHy+gNYsgZzg/LMpCtTL0
 V+d3cgdm+uBGNTG1bbpkkJlygO2n/kWwXloTlKX+tNZw1AYZ0CYMqxbVRag/skoqJcHL
 5ojhfrenW40DVraMis+dRuWio0ZRe4oXzZk3VN+tJTVMJTDm+SQNPVGX8xvNsj4Vushw
 h4olQ1KA0Dt7laYjykN345xq7bQSBFQyGOOjfVuN3+uA+Jm+OE1LApsKtthU6gMxs6jS
 ffRsNTHtFzW40PMhy99X8JATKh8Fdtyk95nyMdS1UUAzHqie0RhWkyRHd6Pa+4MCLp6Z nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32brgr453g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Jul 2020 01:21:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06K1Km2J124688;
        Mon, 20 Jul 2020 01:21:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32cqm7rr39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 01:21:49 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06K1LnXu010343;
        Mon, 20 Jul 2020 01:21:49 GMT
Received: from localhost (/10.159.155.187)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 19 Jul 2020 18:21:48 -0700
Date:   Sun, 19 Jul 2020 18:21:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: xfs_btree_staging.h: delete duplicated words
Message-ID: <20200720012147.GU3151642@magnolia>
References: <20200720001509.656-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720001509.656-1-rdunlap@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9687 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9687 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=5 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 19, 2020 at 05:15:09PM -0700, Randy Dunlap wrote:
> Drop the repeated words "with" and "be" in comments.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Cc: linux-xfs@vger.kernel.org

Ha.
Ha.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D
--D

> ---
>  fs/xfs/libxfs/xfs_btree_staging.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- linux-next-20200717.orig/fs/xfs/libxfs/xfs_btree_staging.h
> +++ linux-next-20200717/fs/xfs/libxfs/xfs_btree_staging.h
> @@ -18,7 +18,7 @@ struct xbtree_afakeroot {
>  	unsigned int		af_blocks;
>  };
>  
> -/* Cursor interactions with with fake roots for AG-rooted btrees. */
> +/* Cursor interactions with fake roots for AG-rooted btrees. */
>  void xfs_btree_stage_afakeroot(struct xfs_btree_cur *cur,
>  		struct xbtree_afakeroot *afake);
>  void xfs_btree_commit_afakeroot(struct xfs_btree_cur *cur, struct xfs_trans *tp,
> @@ -45,7 +45,7 @@ struct xbtree_ifakeroot {
>  	unsigned int		if_extents;
>  };
>  
> -/* Cursor interactions with with fake roots for inode-rooted btrees. */
> +/* Cursor interactions with fake roots for inode-rooted btrees. */
>  void xfs_btree_stage_ifakeroot(struct xfs_btree_cur *cur,
>  		struct xbtree_ifakeroot *ifake,
>  		struct xfs_btree_ops **new_ops);
> @@ -90,7 +90,7 @@ struct xfs_btree_bload {
>  
>  	/*
>  	 * Number of free records to leave in each leaf block.  If the caller
> -	 * sets this to -1, the slack value will be calculated to be be halfway
> +	 * sets this to -1, the slack value will be calculated to be halfway
>  	 * between maxrecs and minrecs.  This typically leaves the block 75%
>  	 * full.  Note that slack values are not enforced on inode root blocks.
>  	 */
