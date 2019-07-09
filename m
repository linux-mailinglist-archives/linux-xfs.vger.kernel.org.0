Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A215637D6
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jul 2019 16:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfGIOXK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Jul 2019 10:23:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37108 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfGIOXK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 10:23:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69EJEw1141847;
        Tue, 9 Jul 2019 14:22:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=4AcOcG0DFxqZolVxDbnTLN0HIEhtCegXcAe33b86Qws=;
 b=Z50Ep28p4jogfDXieTOVvYE/CpQ9Ddlb5UoeEHRR2nH+/s5j0NXNjeYdFQXHC0kjXt5s
 h3srL3kBhviAOvDrWP1QEpf+s8Zvg+zJF/lxVx4IhLAcSigGlDkrHOtqJ9f/PDJSoyRz
 TeNFVLKHpOI6tkYXY1mmjTnbXJh4uljpnHiFTBRxwg/p/nu9QOjNEoCP8q+HUZ5gynJZ
 Hccy4o6A2uBmdFRGwh7fzSl6YugwrcOE9hPp7vuGeje8mpa+fZ6NnNUYemvDTqTfdgNz
 WAVnzdfrNDGagTlQKgEjl2oUBTQYQpr5mYPKamjnwoPUeBou0MHbIt5Qey6UkMg9k5Of Zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2tjm9qmkmk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 14:22:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69EHVsO131650;
        Tue, 9 Jul 2019 14:22:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2tmmh309jb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 14:22:26 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x69EMQ5r027799;
        Tue, 9 Jul 2019 14:22:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 07:22:26 -0700
Date:   Tue, 9 Jul 2019 07:22:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: bump INUMBERS cursor correctly in xfs_inumbers_walk
Message-ID: <20190709142226.GP1404256@magnolia>
References: <20190709135943.GF5167@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709135943.GF5167@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9312 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907090171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9312 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907090171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 09, 2019 at 06:59:43AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There's a subtle unit conversion error when we increment the INUMBERS
> cursor at the end of xfs_inumbers_walk.  If there's an inode chunk at
> the very end of the AG /and/ the AG size is a perfect power of two, that
> means we can have inodes, that means that the startino of that last

"...is a perfect power of two, the startino of that last chunk..."

--D

> chunk (which is in units of AG inodes) will be 63 less than (1 <<
> agino_log).  If we add XFS_INODES_PER_CHUNK to the startino, we end up
> with a startino that's larger than (1 << agino_log) and when we convert
> that back to fs inode units we'll rip off that upper bit and wind up
> back at the start of the AG.
> 
> Fix this by converting to units of fs inodes before adding
> XFS_INODES_PER_CHUNK so that we'll harmlessly end up pointing to the
> next AG.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_itable.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index cda8ae94480c..a8a06bb78ea8 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -338,15 +338,14 @@ xfs_inumbers_walk(
>  		.xi_version	= XFS_INUMBERS_VERSION_V5,
>  	};
>  	struct xfs_inumbers_chunk *ic = data;
> -	xfs_agino_t		agino;
>  	int			error;
>  
>  	error = ic->formatter(ic->breq, &inogrp);
>  	if (error && error != XFS_IBULK_ABORT)
>  		return error;
>  
> -	agino = irec->ir_startino + XFS_INODES_PER_CHUNK;
> -	ic->breq->startino = XFS_AGINO_TO_INO(mp, agno, agino);
> +	ic->breq->startino = XFS_AGINO_TO_INO(mp, agno, irec->ir_startino) +
> +			XFS_INODES_PER_CHUNK;
>  	return error;
>  }
>  
