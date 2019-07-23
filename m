Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D379871B21
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Jul 2019 17:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388292AbfGWPLR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Jul 2019 11:11:17 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53446 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388475AbfGWPLR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jul 2019 11:11:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6NF9PQR102299;
        Tue, 23 Jul 2019 15:11:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=vGCeug4b+DUx/cryhYfZOxFvJ+JmahBxxu4SAGHz7oY=;
 b=khCj3DB1Va0uS2yI8zc6PqrSXODbAq87O8szA6B/qUgd8uu7dnBxIxgLTt9kc7iyBnm0
 SUdro0hFHnD5b+LDALFynXAco8mzCuChT6p9e9mfE8195SPfYGSZgLbFAUE2GUfWF4aP
 DkI5recIuqoxWffTgl4MVXFlOK0ZXXaXJ2L5lqLejwT+hJYM7bpRz4CYw5zt2H1zaAGE
 4V3CiTrKL7JYmyPigrPH2G23hZCgxPAjzcq+ypREUiDjlA9Yd3rro4S0kGIGKAzZSOjL
 7fnWCY3dmz+XI/h6lIzBGamJgBWsahpIopOqT7jlgtglWDkcRYpLc38a3qHyQhR5nitE 2w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2tutctgug8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jul 2019 15:11:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6NF8HAl153290;
        Tue, 23 Jul 2019 15:11:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2tuts3y931-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jul 2019 15:11:09 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6NFB4Or010430;
        Tue, 23 Jul 2019 15:11:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jul 2019 08:11:03 -0700
Date:   Tue, 23 Jul 2019 08:11:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Do not free xfs_extent_busy from inside a spinlock
Message-ID: <20190723151102.GA1561054@magnolia>
References: <20190723150017.31891-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723150017.31891-1-cmaiolino@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9326 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907230152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9326 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907230152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 23, 2019 at 05:00:17PM +0200, Carlos Maiolino wrote:
> xfs_extent_busy_clear_one() calls kmem_free() with the pag spinlock
> locked.

Er, what problem does this solve?  Does holding on to the pag spinlock
too long while memory freeing causes everything else to stall?  When is
memory freeing slow enough to cause a noticeable impact?

> Fix this by adding a new temporary list, and, make
> xfs_extent_busy_clear_one() to move the extent_busy items to this new
> list, instead of freeing them.
> 
> Free the objects in the temporary list after we drop the pagb_lock
> 
> Reported-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_extent_busy.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 0ed68379e551..0a7dcf03340b 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -523,7 +523,8 @@ STATIC void
>  xfs_extent_busy_clear_one(
>  	struct xfs_mount	*mp,
>  	struct xfs_perag	*pag,
> -	struct xfs_extent_busy	*busyp)
> +	struct xfs_extent_busy	*busyp,
> +	struct list_head	*list)
>  {
>  	if (busyp->length) {
>  		trace_xfs_extent_busy_clear(mp, busyp->agno, busyp->bno,
> @@ -531,8 +532,7 @@ xfs_extent_busy_clear_one(
>  		rb_erase(&busyp->rb_node, &pag->pagb_tree);
>  	}
>  
> -	list_del_init(&busyp->list);
> -	kmem_free(busyp);
> +	list_move(&busyp->list, list);
>  }
>  
>  static void
> @@ -565,6 +565,7 @@ xfs_extent_busy_clear(
>  	struct xfs_perag	*pag = NULL;
>  	xfs_agnumber_t		agno = NULLAGNUMBER;
>  	bool			wakeup = false;
> +	LIST_HEAD(busy_list);
>  
>  	list_for_each_entry_safe(busyp, n, list, list) {
>  		if (busyp->agno != agno) {
> @@ -580,13 +581,18 @@ xfs_extent_busy_clear(
>  		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD)) {
>  			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
>  		} else {
> -			xfs_extent_busy_clear_one(mp, pag, busyp);
> +			xfs_extent_busy_clear_one(mp, pag, busyp, &busy_list);

...and why not just put the busyp on the busy_list here so you don't
have to pass the list_head pointer around?

--D

>  			wakeup = true;
>  		}
>  	}
>  
>  	if (pag)
>  		xfs_extent_busy_put_pag(pag, wakeup);
> +
> +	list_for_each_entry_safe(busyp, n, &busy_list, list) {
> +		list_del_init(&busyp->list);
> +		kmem_free(busyp);
> +	}
>  }
>  
>  /*
> -- 
> 2.20.1
> 
