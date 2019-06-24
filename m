Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E5C5183B
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 18:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfFXQTb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 12:19:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34132 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfFXQTb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 12:19:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OG9SIW120022;
        Mon, 24 Jun 2019 16:17:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=fTeNWBuxWPcvFXJE2FrYBW6qk08lCBcUzhO9J/QRpd8=;
 b=Kbs+z/FNMWZcb8jijz8uRK1BFlDAMmQ2566nD3+V3oAg9EUopkS7Z1qMO38YcWuNH97e
 GboaLnn3f0xb8DDEMInSVGPEcCZzDkwRVbl5DY+6ZtPv9D0BXlEmtIAqyALrIMUr896h
 hS5IgEvmBw45CRloJTQoabfdy9FfocmYeXU6IwblM7j7/+UYuC1SRwiPyfzPFu2A6B5U
 qLsf3RvfgQ2Xje08sX/sZPYj+dK0eq8ilUtwRvv7tl3Apf+IjzmOSfA8wrOT7yqZ7RXA
 ej+0NG18oVbCheMY+ZF2LUhjxlIdBXEgdA6OR9vI3rKbgH44HeTvbA/yRMfILd/mNAZN OQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t9cyq7b56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 16:17:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OGGgxT062660;
        Mon, 24 Jun 2019 16:17:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2t9p6tp2gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 16:17:53 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5OGHpWP026100;
        Mon, 24 Jun 2019 16:17:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 09:17:51 -0700
Date:   Mon, 24 Jun 2019 09:17:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: [PATCH 1/2] xfs: simplify xfs_chain_bio
Message-ID: <20190624161750.GR5387@magnolia>
References: <20190624134315.21307-1-hch@lst.de>
 <20190624134315.21307-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624134315.21307-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906240129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906240129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 03:43:14PM +0200, Christoph Hellwig wrote:
> Move setting up operation and write hint to xfs_alloc_ioend, and
> then just copy over all needed information from the previous bio
> in xfs_chain_bio and stop passing various parameters to it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Uh, is this the same patch with the same name in the previous series?

--D

> ---
>  fs/xfs/xfs_aops.c | 35 +++++++++++++++++------------------
>  1 file changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index a6f0f4761a37..9cceb90e77c5 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -665,7 +665,6 @@ xfs_submit_ioend(
>  
>  	ioend->io_bio->bi_private = ioend;
>  	ioend->io_bio->bi_end_io = xfs_end_bio;
> -	ioend->io_bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
>  
>  	/*
>  	 * If we are failing the IO now, just mark the ioend with an
> @@ -679,7 +678,6 @@ xfs_submit_ioend(
>  		return status;
>  	}
>  
> -	ioend->io_bio->bi_write_hint = ioend->io_inode->i_write_hint;
>  	submit_bio(ioend->io_bio);
>  	return 0;
>  }
> @@ -691,7 +689,8 @@ xfs_alloc_ioend(
>  	xfs_exntst_t		state,
>  	xfs_off_t		offset,
>  	struct block_device	*bdev,
> -	sector_t		sector)
> +	sector_t		sector,
> +	struct writeback_control *wbc)
>  {
>  	struct xfs_ioend	*ioend;
>  	struct bio		*bio;
> @@ -699,6 +698,8 @@ xfs_alloc_ioend(
>  	bio = bio_alloc_bioset(GFP_NOFS, BIO_MAX_PAGES, &xfs_ioend_bioset);
>  	bio_set_dev(bio, bdev);
>  	bio->bi_iter.bi_sector = sector;
> +	bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
> +	bio->bi_write_hint = inode->i_write_hint;
>  
>  	ioend = container_of(bio, struct xfs_ioend, io_inline_bio);
>  	INIT_LIST_HEAD(&ioend->io_list);
> @@ -719,24 +720,22 @@ xfs_alloc_ioend(
>   * so that the bi_private linkage is set up in the right direction for the
>   * traversal in xfs_destroy_ioend().
>   */
> -static void
> +static struct bio *
>  xfs_chain_bio(
> -	struct xfs_ioend	*ioend,
> -	struct writeback_control *wbc,
> -	struct block_device	*bdev,
> -	sector_t		sector)
> +	struct bio		*prev)
>  {
>  	struct bio *new;
>  
>  	new = bio_alloc(GFP_NOFS, BIO_MAX_PAGES);
> -	bio_set_dev(new, bdev);
> -	new->bi_iter.bi_sector = sector;
> -	bio_chain(ioend->io_bio, new);
> -	bio_get(ioend->io_bio);		/* for xfs_destroy_ioend */
> -	ioend->io_bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
> -	ioend->io_bio->bi_write_hint = ioend->io_inode->i_write_hint;
> -	submit_bio(ioend->io_bio);
> -	ioend->io_bio = new;
> +	bio_copy_dev(new, prev);
> +	new->bi_iter.bi_sector = bio_end_sector(prev);
> +	new->bi_opf = prev->bi_opf;
> +	new->bi_write_hint = prev->bi_write_hint;
> +
> +	bio_chain(prev, new);
> +	bio_get(prev);		/* for xfs_destroy_ioend */
> +	submit_bio(prev);
> +	return new;
>  }
>  
>  /*
> @@ -771,14 +770,14 @@ xfs_add_to_ioend(
>  		if (wpc->ioend)
>  			list_add(&wpc->ioend->io_list, iolist);
>  		wpc->ioend = xfs_alloc_ioend(inode, wpc->fork,
> -				wpc->imap.br_state, offset, bdev, sector);
> +				wpc->imap.br_state, offset, bdev, sector, wbc);
>  	}
>  
>  	if (!__bio_try_merge_page(wpc->ioend->io_bio, page, len, poff, true)) {
>  		if (iop)
>  			atomic_inc(&iop->write_count);
>  		if (bio_full(wpc->ioend->io_bio))
> -			xfs_chain_bio(wpc->ioend, wbc, bdev, sector);
> +			wpc->ioend->io_bio = xfs_chain_bio(wpc->ioend->io_bio);
>  		bio_add_page(wpc->ioend->io_bio, page, len, poff);
>  	}
>  
> -- 
> 2.20.1
> 
