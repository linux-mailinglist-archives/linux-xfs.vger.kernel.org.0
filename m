Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E350EC272E
	for <lists+linux-xfs@lfdr.de>; Mon, 30 Sep 2019 22:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbfI3Usl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 30 Sep 2019 16:48:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40182 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730071AbfI3Usk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 16:48:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UIAN6G128282;
        Mon, 30 Sep 2019 18:26:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=P9Z48Wvg72JyJPdIaI7UaeJ6Y6/218W3ebbhypIcTw0=;
 b=Q9R2ZiIld2aUrM/nkHfcavfU7EIEw0h01a9Y6LMqdXnSQ/iy0Kf0m6tX/X9UNt6plONd
 2rPXwnZfIkw1bsHFv5FGxvLw/veIceo3armAFZAXlImjg04SlCuYN7u1HJPD9ajrZr6c
 oQITaWxn3ZZlE9ocxNTEfCbJQs0zuUzJ5hIjRjuWA9p0ukJHzWsIkh+C2EV+1dfXy24e
 Bb6JTGHmasqF6EFERIGaIFjDM2LKV8hfJ4ETQiSp92mjKTcoz58fXymJ1nCdnjRfE0nV
 Y+oQRypGUc4NCAGbJuN0Uk+gi/bzMiKEeHvVFbrLD/NMWHbjP85zrLliyEZ4IuhSyxn6 2Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2va05rh19k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 18:26:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8UIEBd8112757;
        Mon, 30 Sep 2019 18:24:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2vayqxaqbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 18:24:30 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8UIOT7f005552;
        Mon, 30 Sep 2019 18:24:29 GMT
Received: from localhost (/67.161.8.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Sep 2019 11:24:29 -0700
Date:   Mon, 30 Sep 2019 11:24:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Aliasgar Surti <aliasgar.surti500@gmail.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH] xfs: removed unused error variable from
 xchk_refcountbt_rec
Message-ID: <20190930182428.GC13108@magnolia>
References: <1569851934-10718-1-git-send-email-aliasgar.surti500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569851934-10718-1-git-send-email-aliasgar.surti500@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909300165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9396 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909300165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 30, 2019 at 07:28:54PM +0530, Aliasgar Surti wrote:
> From: Aliasgar Surti <aliasgar.surti500@gmail.com>
> 
> Removed unused error variable. Instead of using error variable,
> returned the value directly as it wasn't updated.
> 
> Signed-off-by: Aliasgar Surti <aliasgar.surti500@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/scrub/refcount.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index 93b3793b..0cab11a 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -341,7 +341,6 @@ xchk_refcountbt_rec(
>  	xfs_extlen_t		len;
>  	xfs_nlink_t		refcount;
>  	bool			has_cowflag;
> -	int			error = 0;
>  
>  	bno = be32_to_cpu(rec->refc.rc_startblock);
>  	len = be32_to_cpu(rec->refc.rc_blockcount);
> @@ -366,7 +365,7 @@ xchk_refcountbt_rec(
>  
>  	xchk_refcountbt_xref(bs->sc, bno, len, refcount);
>  
> -	return error;
> +	return 0;
>  }
>  
>  /* Make sure we have as many refc blocks as the rmap says. */
> -- 
> 2.7.4
> 
