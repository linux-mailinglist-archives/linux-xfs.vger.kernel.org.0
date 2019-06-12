Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C5542A2B
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 17:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbfFLPCD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 11:02:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43714 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbfFLPCD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 11:02:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5CEx0dq084229;
        Wed, 12 Jun 2019 15:01:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=B4EpS2g1NN47IPaTo7ayfxClUwiN6qZwTTy9QND3EpA=;
 b=EVuXGokbxdZpIHxE53lGYKrngeOqCaBh5iaT7gs4ojoPl54HSwaRW8vJcqPS1GRNyJuX
 KDPF2znv8587V9NaTvh3B+o0SvycPZE6ysVg8PWCmPoZcUYtPGOGKiFUXbsF75qKLEDu
 7A42L/HLwlEjIExSTpsW3NSJ01gDOXR1cZpYfuA/eIMx/XqsrfboIZZioEkFhCYmuiQT
 LeC08qp7Lcjm+r8VX10Qh56sEP2wTeqCo7P0dqWKDaxORBNxswAB0dFAsOBZJiYAn7dw
 LmgXPi375romgJaB3/Rf7eHW4T1ekEvR2CCmo60M/u/ay2vKwh6kie8X05RlgGyX/Tmz og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t05nqv143-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 15:01:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5CF0ohl133145;
        Wed, 12 Jun 2019 15:01:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2t1jpj2kju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 15:01:57 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5CF1uUD004754;
        Wed, 12 Jun 2019 15:01:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Jun 2019 08:01:55 -0700
Date:   Wed, 12 Jun 2019 08:01:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] mkfs: remove useless log options in usage
Message-ID: <20190612150155.GA3773859@magnolia>
References: <1560330575-2209-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560330575-2209-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906120101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906120101
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 12, 2019 at 05:09:35PM +0800, Yang Xu wrote:
> Since commit 2cf637cf(mkfs: remove logarithm based CLI options),
> xfsprogs has discarded log options in node_options, remove it in usage.
> 
> Signed-off-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  mkfs/xfs_mkfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index db3ad38e..91391b72 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -858,7 +858,7 @@ usage( void )
>  			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
>  			    sectsize=num\n\
>  /* force overwrite */	[-f]\n\
> -/* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
> +/* inode size */	[-i perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
>  			    projid32bit=0|1,sparse=0|1]\n\
>  /* no discard */	[-K]\n\
>  /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
> -- 
> 2.18.1
> 
> 
> 
