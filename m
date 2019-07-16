Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 927796A774
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Jul 2019 13:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387565AbfGPLaw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 16 Jul 2019 07:30:52 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50651 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733067AbfGPLaw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jul 2019 07:30:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so18310633wml.0
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jul 2019 04:30:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=UK9qgPcm0j/B4lXEqsrJOtULTzAamg9izTH+Vtri5rs=;
        b=OatGM8fxtXG9E9QvtUokbVoonJvOfTAIFdxATWMY9kmivALJAa5nqB/Jydbsxb0uuV
         k/1loZzeFeqYhf3osPb3KpIakm4niFweWBo5Ic5csKDM/T+2dm4TjVHrUc8MwidTJoxE
         /yYyHX20AHmpp9Oswt1aNBgP+sb1Fc5cMO51Kgiv7vqml8b0qE3QyhfSbynqwZuTd4aN
         FOkEH7U8CNIlIFqZPCHjMKiLzaOsM1jUQhbPU7qccVDvzoFUGBmBzqN9pOQCHSctJS1F
         QBz08b81to7aoHUojLgd0LIa2ONict73bsK7V6a0JsHCA3UdHslTUg1nNggvduYReWes
         KCgg==
X-Gm-Message-State: APjAAAXVk7GnEYH5+HReC3gW5nO3VNxfPBAlEAcxIPRFh0GiFY6rU34j
        H/iIS8oH2otjjPeoRUfgeVBOIrHwzKc=
X-Google-Smtp-Source: APXvYqxMLVFffoW1jtRglLP4q3Vxkw7jvNLldOY0WNGYxRYN29ywLEraXfwm3dDUzZmEZzAOToUS0A==
X-Received: by 2002:a7b:cd9a:: with SMTP id y26mr31850340wmj.44.1563276649274;
        Tue, 16 Jul 2019 04:30:49 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id f10sm12558522wrs.22.2019.07.16.04.30.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 04:30:48 -0700 (PDT)
Date:   Tue, 16 Jul 2019 13:30:46 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] xfsprogs: reorder functions in libxfs/trans.c
Message-ID: <20190716113046.daozxtrv7ycj5fok@pegasus.maiolino.io>
Mail-Followup-To: Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <a40115ca-93e2-6dd2-7940-5911988f8fe4@redhat.com>
 <5cfffec2-092e-5409-e89f-48b5fd905ac2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cfffec2-092e-5409-e89f-48b5fd905ac2@redhat.com>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 12, 2019 at 04:34:20PM -0500, Eric Sandeen wrote:
> This puts these functions in libxfs/trans.c in the same order as
> they appear in kernelspace xfs_trans_buf.c for easier comparison.
> 
> No functional changes.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> diff --git a/libxfs/trans.c b/libxfs/trans.c
> index 5c56b4fe..8954f0fe 100644
> --- a/libxfs/trans.c
> +++ b/libxfs/trans.c
> @@ -330,80 +330,6 @@ libxfs_trans_cancel(
>  	xfs_trans_free(tp);
>  }
>  
> -void
> -libxfs_trans_inode_alloc_buf(
> -	xfs_trans_t		*tp,
> -	xfs_buf_t		*bp)
> -{
> -	xfs_buf_log_item_t	*bip = bp->b_log_item;
> -
> -	ASSERT(bp->b_transp == tp);
> -	ASSERT(bip != NULL);
> -	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
> -	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
> -}
> -
> -/*
> - * Mark a buffer dirty in the transaction.
> - */
> -void
> -libxfs_trans_dirty_buf(
> -	struct xfs_trans	*tp,
> -	struct xfs_buf		*bp)
> -{
> -	struct xfs_buf_log_item	*bip = bp->b_log_item;
> -
> -	ASSERT(bp->b_transp == tp);
> -	ASSERT(bip != NULL);
> -
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> -	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
> -}
> -
> -/*
> - * This is called to mark bytes first through last inclusive of the given
> - * buffer as needing to be logged when the transaction is committed.
> - * The buffer must already be associated with the given transaction.
> - *
> - * First and last are numbers relative to the beginning of this buffer,
> - * so the first byte in the buffer is numbered 0 regardless of the
> - * value of b_blkno.
> - */
> -void
> -libxfs_trans_log_buf(
> -	struct xfs_trans	*tp,
> -	struct xfs_buf		*bp,
> -	uint			first,
> -	uint			last)
> -{
> -	struct xfs_buf_log_item	*bip = bp->b_log_item;
> -
> -	ASSERT((first <= last) && (last < bp->b_bcount));
> -
> -	xfs_trans_dirty_buf(tp, bp);
> -	xfs_buf_item_log(bip, first, last);
> -}
> -
> -/*
> - * For userspace, ordered buffers just need to be marked dirty so
> - * the transaction commit will write them and mark them up-to-date.
> - * In essence, they are just like any other logged buffer in userspace.
> - *
> - * If the buffer is already dirty, trigger the "already logged" return condition.
> - */
> -bool
> -libxfs_trans_ordered_buf(
> -	struct xfs_trans	*tp,
> -	struct xfs_buf		*bp)
> -{
> -	struct xfs_buf_log_item	*bip = bp->b_log_item;
> -	bool			ret;
> -
> -	ret = test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
> -	libxfs_trans_log_buf(tp, bp, 0, bp->b_bcount);
> -	return ret;
> -}
> -
>  static void
>  xfs_buf_item_put(
>  	struct xfs_buf_log_item	*bip)
> @@ -414,63 +340,7 @@ xfs_buf_item_put(
>  	kmem_zone_free(xfs_buf_item_zone, bip);
>  }
>  
> -void
> -libxfs_trans_brelse(
> -	xfs_trans_t		*tp,
> -	xfs_buf_t		*bp)
> -{
> -	xfs_buf_log_item_t	*bip;
> -
> -	if (tp == NULL) {
> -		ASSERT(bp->b_transp == NULL);
> -		libxfs_putbuf(bp);
> -		return;
> -	}
> -
> -	trace_xfs_trans_brelse(bip);
> -	ASSERT(bp->b_transp == tp);
> -	bip = bp->b_log_item;
> -	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
> -	if (bip->bli_recur > 0) {
> -		bip->bli_recur--;
> -		return;
> -	}
> -	/* If dirty/stale, can't release till transaction committed */
> -	if (bip->bli_flags & XFS_BLI_STALE)
> -		return;
> -	if (test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags))
> -		return;
> -	xfs_trans_del_item(&bip->bli_item);
> -	if (bip->bli_flags & XFS_BLI_HOLD)
> -		bip->bli_flags &= ~XFS_BLI_HOLD;
> -	xfs_buf_item_put(bip);
> -	bp->b_transp = NULL;
> -	libxfs_putbuf(bp);
> -}
> -
> -void
> -libxfs_trans_binval(
> -	xfs_trans_t		*tp,
> -	xfs_buf_t		*bp)
> -{
> -	xfs_buf_log_item_t	*bip = bp->b_log_item;
> -
> -	ASSERT(bp->b_transp == tp);
> -	ASSERT(bip != NULL);
> -
> -	trace_xfs_trans_binval(bip);
> -
> -	if (bip->bli_flags & XFS_BLI_STALE)
> -		return;
> -	XFS_BUF_UNDELAYWRITE(bp);
> -	xfs_buf_stale(bp);
> -	bip->bli_flags |= XFS_BLI_STALE;
> -	bip->bli_flags &= ~XFS_BLI_DIRTY;
> -	bip->__bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
> -	bip->__bli_format.blf_flags |= XFS_BLF_CANCEL;
> -	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> -}
> +/* from xfs_trans_buf.c */
>  
>  /*
>   * Add the locked buffer to the transaction.
> @@ -519,20 +389,6 @@ libxfs_trans_bjoin(
>  	trace_xfs_trans_bjoin(bp->b_log_item);
>  }
>  
> -void
> -libxfs_trans_bhold(
> -	xfs_trans_t		*tp,
> -	xfs_buf_t		*bp)
> -{
> -	xfs_buf_log_item_t	*bip = bp->b_log_item;
> -
> -	ASSERT(bp->b_transp == tp);
> -	ASSERT(bip != NULL);
> -
> -	bip->bli_flags |= XFS_BLI_HOLD;
> -	trace_xfs_trans_bhold(bip);
> -}
> -
>  xfs_buf_t *
>  libxfs_trans_get_buf_map(
>  	xfs_trans_t		*tp,
> @@ -651,6 +507,160 @@ out_relse:
>  	return error;
>  }
>  
> +void
> +libxfs_trans_brelse(
> +	xfs_trans_t		*tp,
> +	xfs_buf_t		*bp)
> +{
> +	xfs_buf_log_item_t	*bip;
> +
> +	if (tp == NULL) {
> +		ASSERT(bp->b_transp == NULL);
> +		libxfs_putbuf(bp);
> +		return;
> +	}
> +
> +	trace_xfs_trans_brelse(bip);
> +	ASSERT(bp->b_transp == tp);
> +	bip = bp->b_log_item;
> +	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
> +	if (bip->bli_recur > 0) {
> +		bip->bli_recur--;
> +		return;
> +	}
> +	/* If dirty/stale, can't release till transaction committed */
> +	if (bip->bli_flags & XFS_BLI_STALE)
> +		return;
> +	if (test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags))
> +		return;
> +	xfs_trans_del_item(&bip->bli_item);
> +	if (bip->bli_flags & XFS_BLI_HOLD)
> +		bip->bli_flags &= ~XFS_BLI_HOLD;
> +	xfs_buf_item_put(bip);
> +	bp->b_transp = NULL;
> +	libxfs_putbuf(bp);
> +}
> +
> +/*
> + * Mark the buffer as not needing to be unlocked when the buf item's
> + * iop_unlock() routine is called.  The buffer must already be locked
> + * and associated with the given transaction.
> + */
> +/* ARGSUSED */
> +void
> +libxfs_trans_bhold(
> +	xfs_trans_t		*tp,
> +	xfs_buf_t		*bp)
> +{
> +	xfs_buf_log_item_t	*bip = bp->b_log_item;
> +
> +	ASSERT(bp->b_transp == tp);
> +	ASSERT(bip != NULL);
> +
> +	bip->bli_flags |= XFS_BLI_HOLD;
> +	trace_xfs_trans_bhold(bip);
> +}
> +
> +/*
> + * Mark a buffer dirty in the transaction.
> + */
> +void
> +libxfs_trans_dirty_buf(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> +
> +	ASSERT(bp->b_transp == tp);
> +	ASSERT(bip != NULL);
> +
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
> +}
> +
> +/*
> + * This is called to mark bytes first through last inclusive of the given
> + * buffer as needing to be logged when the transaction is committed.
> + * The buffer must already be associated with the given transaction.
> + *
> + * First and last are numbers relative to the beginning of this buffer,
> + * so the first byte in the buffer is numbered 0 regardless of the
> + * value of b_blkno.
> + */
> +void
> +libxfs_trans_log_buf(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*bp,
> +	uint			first,
> +	uint			last)
> +{
> +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> +
> +	ASSERT((first <= last) && (last < bp->b_bcount));
> +
> +	xfs_trans_dirty_buf(tp, bp);
> +	xfs_buf_item_log(bip, first, last);
> +}
> +
> +void
> +libxfs_trans_binval(
> +	xfs_trans_t		*tp,
> +	xfs_buf_t		*bp)
> +{
> +	xfs_buf_log_item_t	*bip = bp->b_log_item;
> +
> +	ASSERT(bp->b_transp == tp);
> +	ASSERT(bip != NULL);
> +
> +	trace_xfs_trans_binval(bip);
> +
> +	if (bip->bli_flags & XFS_BLI_STALE)
> +		return;
> +	XFS_BUF_UNDELAYWRITE(bp);
> +	xfs_buf_stale(bp);
> +	bip->bli_flags |= XFS_BLI_STALE;
> +	bip->bli_flags &= ~XFS_BLI_DIRTY;
> +	bip->__bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
> +	bip->__bli_format.blf_flags |= XFS_BLF_CANCEL;
> +	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +}
> +
> +void
> +libxfs_trans_inode_alloc_buf(
> +	xfs_trans_t		*tp,
> +	xfs_buf_t		*bp)
> +{
> +	xfs_buf_log_item_t	*bip = bp->b_log_item;
> +
> +	ASSERT(bp->b_transp == tp);
> +	ASSERT(bip != NULL);
> +	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
> +	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
> +}
> +
> +/*
> + * For userspace, ordered buffers just need to be marked dirty so
> + * the transaction commit will write them and mark them up-to-date.
> + * In essence, they are just like any other logged buffer in userspace.
> + *
> + * If the buffer is already dirty, trigger the "already logged" return condition.
> + */
> +bool
> +libxfs_trans_ordered_buf(
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> +	bool			ret;
> +
> +	ret = test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
> +	libxfs_trans_log_buf(tp, bp, 0, bp->b_bcount);
> +	return ret;
> +}
> +
> +/* end of xfs_trans_buf.c */
> +
>  /*
>   * Record the indicated change to the given field for application
>   * to the file system's superblock when the transaction commits.
> 

-- 
Carlos
