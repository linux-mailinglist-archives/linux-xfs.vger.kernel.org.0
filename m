Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1C26A778
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Jul 2019 13:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387569AbfGPLbS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 16 Jul 2019 07:31:18 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44175 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733067AbfGPLbS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jul 2019 07:31:18 -0400
Received: by mail-wr1-f67.google.com with SMTP id p17so20512245wrf.11
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2019 04:31:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=c24a/xP2Bii+tf522g/ioNopuoFIOT5iwEnzPL2Q8no=;
        b=MLycOO2O4ru/XIZ4gvj0Btb/dMcqjiNAKXn+Xk7IHQgwRUVxiIxXSMa25sK2yBn98S
         dSPSCHwG2piHwNqZKFjxQyvqxARmAEnFG0heKUj4phJLVThtPATgfMLlw8fOkkxJ03gX
         bpNkGynmj3ec4Lt2fFQsFLP44dsC5gzPbVBrqyUWs7jvqi4wh1B5hWPOQx0zcr9lDiKj
         uA38cPyjScv+1r699abDANnqjmLxdsZZTfYANQOiIl+/Q4uTB3ec7MxAXJbUFPlpHkjG
         DKGki+dUvhHWTm+/fZPSkE4wlQey7ZQzF4bhitqgbRfnG/lKSoJ46r/WgkO2fjB4lXKR
         MGxg==
X-Gm-Message-State: APjAAAVSWCd3yhNkt01jkr8Zgf3FD0lwdKEL3qQDMLwXqb4dZrBUD/Z+
        IPG6OXCQb5cNcL239izOISYbuQ==
X-Google-Smtp-Source: APXvYqxjRDyC4FExY8PGFE71VdJ6MoP6UMwJVzCtpFPmvk8VZkXhvK+DTprkvoOpyrcfaVidjFpfpw==
X-Received: by 2002:adf:c594:: with SMTP id m20mr5405760wrg.126.1563276675893;
        Tue, 16 Jul 2019 04:31:15 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id k63sm26139264wmb.2.2019.07.16.04.31.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 04:31:15 -0700 (PDT)
Date:   Tue, 16 Jul 2019 13:31:13 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/4] xfsprogs: cosmetic changes to libxfs/trans.c
Message-ID: <20190716113113.v7jyjpejygrxz6gg@pegasus.maiolino.io>
Mail-Followup-To: Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <a40115ca-93e2-6dd2-7940-5911988f8fe4@redhat.com>
 <5c8fe68f-c5dd-4f23-de03-fa886cd57641@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c8fe68f-c5dd-4f23-de03-fa886cd57641@redhat.com>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 12, 2019 at 04:36:29PM -0500, Eric Sandeen wrote:
> Make some completely trivial changes to libxfs/trans.c to more
> closely match kernelspace xfs_trans.c:
> 
> - remove some typedefs
> - alter whitespace
> - rename some variables
> 
> No functional changes.
> 




> Signed-off-by: Eric Sandeen <sandeen@redhat.com>


Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>



> ---
> 
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 8954f0fe..fecefc7a 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -361,7 +361,7 @@ _libxfs_trans_bjoin(
>  
>  	ASSERT(bp->b_transp == NULL);
>  
> -        /*
> +	/*
>  	 * The xfs_buf_log_item pointer is stored in b_log_item.  If
>  	 * it doesn't have one yet, then allocate one and initialize it.
>  	 * The checks to see if one is there are in xfs_buf_item_init().
> @@ -389,21 +389,21 @@ libxfs_trans_bjoin(
>  	trace_xfs_trans_bjoin(bp->b_log_item);
>  }
>  
> -xfs_buf_t *
> +struct xfs_buf *
>  libxfs_trans_get_buf_map(
> -	xfs_trans_t		*tp,
> -	struct xfs_buftarg	*btp,
> +	struct xfs_trans	*tp,
> +	struct xfs_buftarg	*target,
>  	struct xfs_buf_map	*map,
>  	int			nmaps,
> -	uint			f)
> +	uint			flags)
>  {
>  	xfs_buf_t		*bp;
> -	xfs_buf_log_item_t	*bip;
> +	struct xfs_buf_log_item	*bip;
>  
>  	if (tp == NULL)
> -		return libxfs_getbuf_map(btp, map, nmaps, 0);
> +		return libxfs_getbuf_map(target, map, nmaps, 0);
>  
> -	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
> +	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
>  	if (bp != NULL) {
>  		ASSERT(bp->b_transp == tp);
>  		bip = bp->b_log_item;
> @@ -412,7 +412,7 @@ libxfs_trans_get_buf_map(
>  		return bp;
>  	}
>  
> -	bp = libxfs_getbuf_map(btp, map, nmaps, 0);
> +	bp = libxfs_getbuf_map(target, map, nmaps, 0);
>  	if (bp == NULL)
>  		return NULL;
>  
> @@ -424,11 +424,11 @@ libxfs_trans_get_buf_map(
>  xfs_buf_t *
>  libxfs_trans_getsb(
>  	xfs_trans_t		*tp,
> -	xfs_mount_t		*mp,
> +	struct xfs_mount	*mp,
>  	int			flags)
>  {
>  	xfs_buf_t		*bp;
> -	xfs_buf_log_item_t	*bip;
> +	struct xfs_buf_log_item	*bip;
>  	int			len = XFS_FSS_TO_BB(mp, 1);
>  	DEFINE_SINGLE_BUF_MAP(map, XFS_SB_DADDR, len);
>  
> @@ -454,23 +454,23 @@ libxfs_trans_getsb(
>  
>  int
>  libxfs_trans_read_buf_map(
> -	xfs_mount_t		*mp,
> -	xfs_trans_t		*tp,
> -	struct xfs_buftarg	*btp,
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct xfs_buftarg	*target,
>  	struct xfs_buf_map	*map,
>  	int			nmaps,
>  	uint			flags,
> -	xfs_buf_t		**bpp,
> +	struct xfs_buf		**bpp,
>  	const struct xfs_buf_ops *ops)
>  {
> -	xfs_buf_t		*bp;
> -	xfs_buf_log_item_t	*bip;
> +	struct xfs_buf		*bp;
> +	struct xfs_buf_log_item	*bip;
>  	int			error;
>  
>  	*bpp = NULL;
>  
>  	if (tp == NULL) {
> -		bp = libxfs_readbuf_map(btp, map, nmaps, flags, ops);
> +		bp = libxfs_readbuf_map(target, map, nmaps, flags, ops);
>  		if (!bp) {
>  			return (flags & XBF_TRYLOCK) ?  -EAGAIN : -ENOMEM;
>  		}
> @@ -479,7 +479,7 @@ libxfs_trans_read_buf_map(
>  		goto done;
>  	}
>  
> -	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
> +	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
>  	if (bp != NULL) {
>  		ASSERT(bp->b_transp == tp);
>  		ASSERT(bp->b_log_item != NULL);
> @@ -489,7 +489,7 @@ libxfs_trans_read_buf_map(
>  		goto done;
>  	}
>  
> -	bp = libxfs_readbuf_map(btp, map, nmaps, flags, ops);
> +	bp = libxfs_readbuf_map(target, map, nmaps, flags, ops);
>  	if (!bp) {
>  		return (flags & XBF_TRYLOCK) ?  -EAGAIN : -ENOMEM;
>  	}
> @@ -509,10 +509,10 @@ out_relse:
>  
>  void
>  libxfs_trans_brelse(
> -	xfs_trans_t		*tp,
> -	xfs_buf_t		*bp)
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*bp)
>  {
> -	xfs_buf_log_item_t	*bip;
> +	struct xfs_buf_log_item	*bip;
>  
>  	if (tp == NULL) {
>  		ASSERT(bp->b_transp == NULL);
> @@ -524,19 +524,23 @@ libxfs_trans_brelse(
>  	ASSERT(bp->b_transp == tp);
>  	bip = bp->b_log_item;
>  	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
> +
>  	if (bip->bli_recur > 0) {
>  		bip->bli_recur--;
>  		return;
>  	}
> +
>  	/* If dirty/stale, can't release till transaction committed */
>  	if (bip->bli_flags & XFS_BLI_STALE)
>  		return;
>  	if (test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags))
>  		return;
> +
>  	xfs_trans_del_item(&bip->bli_item);
>  	if (bip->bli_flags & XFS_BLI_HOLD)
>  		bip->bli_flags &= ~XFS_BLI_HOLD;
>  	xfs_buf_item_put(bip);
> +
>  	bp->b_transp = NULL;
>  	libxfs_putbuf(bp);
>  }
> @@ -552,7 +556,7 @@ libxfs_trans_bhold(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> -	xfs_buf_log_item_t	*bip = bp->b_log_item;
> +	struct xfs_buf_log_item	*bip = bp->b_log_item;
>  
>  	ASSERT(bp->b_transp == tp);
>  	ASSERT(bip != NULL);
> @@ -599,6 +603,7 @@ libxfs_trans_log_buf(
>  	ASSERT((first <= last) && (last < bp->b_bcount));
>  
>  	xfs_trans_dirty_buf(tp, bp);
> +
>  	xfs_buf_item_log(bip, first, last);
>  }
>  
> @@ -607,7 +612,7 @@ libxfs_trans_binval(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> -	xfs_buf_log_item_t	*bip = bp->b_log_item;
> +	struct xfs_buf_log_item	*bip = bp->b_log_item;
>  
>  	ASSERT(bp->b_transp == tp);
>  	ASSERT(bip != NULL);
> @@ -618,6 +623,7 @@ libxfs_trans_binval(
>  		return;
>  	XFS_BUF_UNDELAYWRITE(bp);
>  	xfs_buf_stale(bp);
> +
>  	bip->bli_flags |= XFS_BLI_STALE;
>  	bip->bli_flags &= ~XFS_BLI_DIRTY;
>  	bip->__bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
> @@ -631,7 +637,7 @@ libxfs_trans_inode_alloc_buf(
>  	xfs_trans_t		*tp,
>  	xfs_buf_t		*bp)
>  {
> -	xfs_buf_log_item_t	*bip = bp->b_log_item;
> +	struct xfs_buf_log_item	*bip = bp->b_log_item;
>  
>  	ASSERT(bp->b_transp == tp);
>  	ASSERT(bip != NULL);
> 
> 

-- 
Carlos
