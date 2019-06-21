Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A794F211
	for <lists+linux-xfs@lfdr.de>; Sat, 22 Jun 2019 02:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfFVABK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 20:01:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51670 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFVABK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 20:01:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LNtIWb052811;
        Sat, 22 Jun 2019 00:00:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Yy1VhWXUH7ZGVG7tTFCiR0PoM9wcKRFEiufJii/Zr04=;
 b=Jt1w9A/NPgK+Bqxm88W7YjFyFCaW7hRjKUF4I5l2Lj7M/TKx9+Ewzz/K0wB4AmIpjiuc
 m95WMFR1r9BGlkllI9lQHX7uW4FUiuTNJ0QBvK6GKXSYfALxZb+yqaTEi6Ioxg80BmE5
 s/KmX3EkBFVnbp3TqJ38IZpH5sTWVfp/cdgg+xP5GfZUeX1XK2Y4VZGKGNbF+nDD5ZLv
 cZEE6wPH/wiTo9eaalbrva1AvY6oLfu9hQaaa9CyAX4XR78v8BeJCkWSCigkyMFC/Lr3
 Tu39ksQvMbFOdxOm4I6zAxMNZgWFvni2m8eSJiG2VYP9sJX7iMDllsKX5WUYKb9UDA59 qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2t7809rt41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 Jun 2019 00:00:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LNvKQs171380;
        Fri, 21 Jun 2019 23:58:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2t7rdy06f5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 23:58:50 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5LNwnw2032262;
        Fri, 21 Jun 2019 23:58:49 GMT
Received: from localhost (/10.159.131.214)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 23:58:49 +0000
Date:   Fri, 21 Jun 2019 16:58:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 03/11] xfs: skip small alloc cntbt logic on NULL cursor
Message-ID: <20190621235848.GB5387@magnolia>
References: <20190522180546.17063-1-bfoster@redhat.com>
 <20190522180546.17063-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522180546.17063-4-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906210182
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906210182
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 22, 2019 at 02:05:38PM -0400, Brian Foster wrote:
> The small allocation helper is implemented in a way that is fairly
> tightly integrated to the existing allocation algorithms. It expects
> a cntbt cursor beyond the end of the tree, attempts to locate the
> last record in the tree and only attempts an AGFL allocation if the
> cntbt is empty.
> 
> The upcoming generic algorithm doesn't rely on the cntbt processing
> of this function. It will only call this function when the cntbt
> doesn't have a big enough extent or is empty and thus AGFL
> allocation is the only remaining option. Tweak
> xfs_alloc_ag_vextent_small() to handle a NULL cntbt cursor and skip
> the cntbt logic. This facilitates use by the existing allocation
> code and new code that only requires an AGFL allocation attempt.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index b345fe771c54..436f8eb0bc4c 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -713,9 +713,16 @@ xfs_alloc_ag_vextent_small(
>  	int			error = 0;
>  	xfs_agblock_t		fbno = NULLAGBLOCK;
>  	xfs_extlen_t		flen = 0;
> -	int			i;
> +	int			i = 0;
>  
> -	error = xfs_btree_decrement(ccur, 0, &i);
> +	/*
> +	 * If a cntbt cursor is provided, try to allocate the largest record in
> +	 * the tree. Try the AGFL if the cntbt is empty, otherwise fail the
> +	 * allocation. Make sure to respect minleft even when pulling from the
> +	 * freelist.
> +	 */
> +	if (ccur)
> +		error = xfs_btree_decrement(ccur, 0, &i);
>  	if (error)
>  		goto error;
>  	if (i) {
> -- 
> 2.17.2
> 
