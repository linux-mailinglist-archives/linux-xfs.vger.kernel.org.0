Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB01B5186B
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 18:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfFXQW0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 12:22:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41770 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbfFXQWZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 12:22:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OGK9B8031180;
        Mon, 24 Jun 2019 16:22:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=HAbniybFAEJpBBNSj4ZE3NbjqY4x03TzDGCFCAeQQos=;
 b=vHvtkbQhcO7DkGLTM8tWZMzkwV/FfmjrL4sCXuBTqb4W2i51Vy3mro75Obx+oHD4AlYt
 TiCbQgQVJla5iwBcwfjj9xePam3Ilb3gexEoqgHciD52ILTH82EUJTQCVeu0GxeNMTP5
 /IMVX/iqvWH6t9UxUhXXfj8hXBljoln6E7f/oo2veKtJyEeHU9/egw1pFLeLFUXK2SKr
 YjX/njuH+wAkakeXyLIQcANvmHX9VyyD9dA6fxjQUeDe/CjUDnEaXt1/kCZQMWRtUjp7
 Ri5XYKImnWi2H6+1GSqfxiHO+dPB/rLb5e/UxNDSkjnp5FxXbi3y9gUx/RxjuVmZxu6z SA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t9c9pfcj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 16:22:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5OGKgph071741;
        Mon, 24 Jun 2019 16:22:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2t9p6tp4hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jun 2019 16:22:18 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5OGMGYW014178;
        Mon, 24 Jun 2019 16:22:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Jun 2019 09:22:16 -0700
Date:   Mon, 24 Jun 2019 09:22:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: [PATCH 2/2] xfs: implement cgroup aware writeback
Message-ID: <20190624162215.GS5387@magnolia>
References: <20190624134315.21307-1-hch@lst.de>
 <20190624134315.21307-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624134315.21307-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906240130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9298 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906240130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 24, 2019 at 03:43:15PM +0200, Christoph Hellwig wrote:
> Link every newly allocated writeback bio to cgroup pointed to by the
> writeback control structure, and charge every byte written back to it.
> 
> Tested-by: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

Was this tested by running shared/011?  Or did it involve other checks?

As I mentioned in the thread about shared/011, I think the test needs a
better way of figuring out if the filesystem under test actually
supports cgroup writeback so we don't cause failures that then have to
be put on a known-issue list for an old kernel.

FWIW that test looks like it only is testing the accounting, so that
might be as easy as trying a write and seeing if the numbers jump.

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c  | 4 +++-
>  fs/xfs/xfs_super.c | 2 ++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 9cceb90e77c5..73c291aeae17 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -700,6 +700,7 @@ xfs_alloc_ioend(
>  	bio->bi_iter.bi_sector = sector;
>  	bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
>  	bio->bi_write_hint = inode->i_write_hint;
> +	wbc_init_bio(wbc, bio);
>  
>  	ioend = container_of(bio, struct xfs_ioend, io_inline_bio);
>  	INIT_LIST_HEAD(&ioend->io_list);
> @@ -727,7 +728,7 @@ xfs_chain_bio(
>  	struct bio *new;
>  
>  	new = bio_alloc(GFP_NOFS, BIO_MAX_PAGES);
> -	bio_copy_dev(new, prev);
> +	bio_copy_dev(new, prev);/* also copies over blkcg information */
>  	new->bi_iter.bi_sector = bio_end_sector(prev);
>  	new->bi_opf = prev->bi_opf;
>  	new->bi_write_hint = prev->bi_write_hint;
> @@ -782,6 +783,7 @@ xfs_add_to_ioend(
>  	}
>  
>  	wpc->ioend->io_size += len;
> +	wbc_account_io(wbc, page, len);
>  }
>  
>  STATIC void
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 594c119824cc..ee0df8f611ff 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1685,6 +1685,8 @@ xfs_fs_fill_super(
>  	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
>  	sb->s_max_links = XFS_MAXLINK;
>  	sb->s_time_gran = 1;
> +	sb->s_iflags |= SB_I_CGROUPWB;
> +
>  	set_posix_acl_flag(sb);
>  
>  	/* version 5 superblocks support inode version counters. */
> -- 
> 2.20.1
> 
