Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3828251A2E
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 20:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732695AbfFXSAP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 14:00:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37374 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfFXSAP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 14:00:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OHwfsC011684;
        Mon, 24 Jun 2019 17:59:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=JSXn4wuXi9YXW5+Bc7svc6f9ZqWpg4yUgrt2wV/rvRI=;
 b=eQ9YAPwy7K0CUQcKWwOD6E0daWx6LTIoPKpcybC6543JZH1i/uZrdYr8UbHwKFB9V1VR
 fRlxJb4Sd5t7SIVsH6mFyWGJn1d8vAd7FilRdXy57zkhOX9V9qqJz6sK4FAE8gIUcNM3
 pVgNJDNyinOjgskf7cvIjC34C0kM8J2BSroAyz4y3uXpyJi7ylH6rG0lMggdc/mlPgqi
 eAyAKrNnZEpsi1HA+bWDBdIMJsVGpSh3cNjYvWQ0h3e077Ki9jkgz1jN6nmM+DfekGpR
 zQBLhUfkh9Mf7sa3jYyQA4huJ8dkJlVvbevLUfViUDbAEAL1de9YiGGDyAFa2BwxeCQi Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t9cyq7t2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 17:59:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OHwg0U113210;
        Mon, 24 Jun 2019 17:59:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2t9p6tqh6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 17:59:49 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5OHxmVc023377;
        Mon, 24 Jun 2019 17:59:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 10:59:48 -0700
Date:   Mon, 24 Jun 2019 10:59:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 10/10] xfs: mount-api - rename xfs_fill_super()
Message-ID: <20190624175947.GA5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
 <156134516161.2519.11373830976371295990.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156134516161.2519.11373830976371295990.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906240143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906240143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 10:59:21AM +0800, Ian Kent wrote:
> Now the legacy mount functions have been removed xfs_fill_super()
> can be renamed to xfs_fs_fill_super() in keeping with the previous
> xfs naming convention.
> 
> Signed-off-by: Ian Kent <raven@themaw.net>

Looks ok I guess.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_super.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 643b40e8a328..38f3af44fbbf 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1756,7 +1756,7 @@ __xfs_fs_fill_super(
>  }
>  
>  STATIC int
> -xfs_fill_super(
> +xfs_fs_fill_super(
>  	struct super_block	*sb,
>  	struct fs_context	*fc)
>  {
> @@ -1798,7 +1798,7 @@ STATIC int
>  xfs_get_tree(
>  	struct fs_context	*fc)
>  {
> -	return vfs_get_block_super(fc, xfs_fill_super);
> +	return vfs_get_block_super(fc, xfs_fs_fill_super);
>  }
>  
>  STATIC void
> 
