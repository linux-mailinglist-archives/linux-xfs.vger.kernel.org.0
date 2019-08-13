Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A89D48B7B3
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Aug 2019 13:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfHML5s (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 13 Aug 2019 07:57:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57544 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbfHML5s (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Aug 2019 07:57:48 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 83DDC30001EE;
        Tue, 13 Aug 2019 11:57:47 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A3207EEA0;
        Tue, 13 Aug 2019 11:57:47 +0000 (UTC)
Date:   Tue, 13 Aug 2019 07:57:45 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com
Subject: Re: [PATCH 3/3] xfs: Opencode and remove DEFINE_SINGLE_BUF_MAP
Message-ID: <20190813115745.GC37069@bfoster>
References: <20190813090306.31278-1-nborisov@suse.com>
 <20190813090306.31278-4-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813090306.31278-4-nborisov@suse.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Tue, 13 Aug 2019 11:57:47 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 13, 2019 at 12:03:06PM +0300, Nikolay Borisov wrote:
> This macro encodes a trivial struct initializations, just open code it.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---

Seems fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

What might be more interesting is to audit the cases where nmap is
always 1 and see if we can start eliminating some of this code where it
isn't needed. For example, it looks xfs_buf_readahead_map() only ever
uses nmap == 1. Can we pass a block/len directly there and push the
map/nmap parameters further down the stack? FWIW, I also see several
functions on a quick glance (xfs_dabuf_map(), xfs_buf_map_from_irec())
that take map/nmaps params, assert that nmaps == 1 yet still have
iteration code for nmap > 1 cases.

>  fs/xfs/xfs_buf.c   | 4 ++--
>  fs/xfs/xfs_buf.h   | 9 +++------
>  fs/xfs/xfs_trans.h | 6 ++++--
>  3 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 99c66f80d7cc..389c5b590f11 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -658,7 +658,7 @@ xfs_buf_incore(
>  {
>  	struct xfs_buf		*bp;
>  	int			error;
> -	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> +	struct xfs_buf_map map = { .bm_bn = blkno, .bm_len = numblks };
>  
>  	error = xfs_buf_find(target, &map, 1, flags, NULL, &bp);
>  	if (error)
> @@ -905,7 +905,7 @@ xfs_buf_get_uncached(
>  	unsigned long		page_count;
>  	int			error, i;
>  	struct xfs_buf		*bp;
> -	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
> +	struct xfs_buf_map map = { .bm_bn = XFS_BUF_DADDR_NULL, .bm_len = numblks };
>  
>  	/* flags might contain irrelevant bits, pass only what we care about */
>  	bp = _xfs_buf_alloc(target, &map, 1, flags & XBF_NO_IOACCT);
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index ec7037284d62..548dfb0c6e27 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -104,9 +104,6 @@ struct xfs_buf_map {
>  	int			bm_len;	/* size of I/O */
>  };
>  
> -#define DEFINE_SINGLE_BUF_MAP(map, blkno, numblk) \
> -	struct xfs_buf_map (map) = { .bm_bn = (blkno), .bm_len = (numblk) };
> -
>  struct xfs_buf_ops {
>  	char *name;
>  	union {
> @@ -209,7 +206,7 @@ xfs_buf_get(
>  	xfs_daddr_t		blkno,
>  	size_t			numblks)
>  {
> -	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> +	struct xfs_buf_map map = { .bm_bn = blkno, .bm_len = numblks };
>  	return xfs_buf_get_map(target, &map, 1, 0);
>  }
>  
> @@ -221,7 +218,7 @@ xfs_buf_read(
>  	xfs_buf_flags_t		flags,
>  	const struct xfs_buf_ops *ops)
>  {
> -	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> +	struct xfs_buf_map map = { .bm_bn = blkno, .bm_len = numblks };
>  	return xfs_buf_read_map(target, &map, 1, flags, ops);
>  }
>  
> @@ -232,7 +229,7 @@ xfs_buf_readahead(
>  	size_t			numblks,
>  	const struct xfs_buf_ops *ops)
>  {
> -	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> +	struct xfs_buf_map map = { .bm_bn = blkno, .bm_len = numblks };
>  	return xfs_buf_readahead_map(target, &map, 1, ops);
>  }
>  
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 64d7f171ebd3..8d6fce5c0320 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -182,7 +182,8 @@ xfs_trans_get_buf(
>  	int			numblks,
>  	uint			flags)
>  {
> -	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> +	struct xfs_buf_map map = { .bm_bn = blkno, .bm_len = numblks };
> +
>  	return xfs_trans_get_buf_map(tp, target, &map, 1, flags);
>  }
>  
> @@ -205,7 +206,8 @@ xfs_trans_read_buf(
>  	struct xfs_buf		**bpp,
>  	const struct xfs_buf_ops *ops)
>  {
> -	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> +	struct xfs_buf_map map = { .bm_bn = blkno, .bm_len = numblks };
> +
>  	return xfs_trans_read_buf_map(mp, tp, target, &map, 1,
>  				      flags, bpp, ops);
>  }
> -- 
> 2.17.1
> 
