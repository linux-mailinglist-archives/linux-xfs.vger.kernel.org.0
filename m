Return-Path: <linux-xfs+bounces-27245-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A4015C27425
	for <lists+linux-xfs@lfdr.de>; Sat, 01 Nov 2025 01:16:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 21DC034F48D
	for <lists+linux-xfs@lfdr.de>; Sat,  1 Nov 2025 00:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B75CB136349;
	Sat,  1 Nov 2025 00:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tkv5HnfX"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753182AE68
	for <linux-xfs@vger.kernel.org>; Sat,  1 Nov 2025 00:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761956157; cv=none; b=f1AAcfzNBrQhFxTkutDpJMy9D8dJwEDrcrGWrZlimZ0bMuNSTNPj5NSUfd8LsqFhMSpSZ5c6O0Yi+AkK5DlXKbbl8QqmcnzIOYjVfkvKyu6mxSH892dTOV0mXXTNqXJc0UxqQOFLaZ4smp4EQvsUsMsu9UC+5ErMSsn1BtTQO6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761956157; c=relaxed/simple;
	bh=KTWnS0NuwuS3h4Mv73yrH8W+uBK3AXpPDIfJj8tPHcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SduGONXf3dBA4oEd2dCY6yh3pSxGVhmR0G/OGiuvZp7N91K0yyiwJfvN8GBnv/FKvTzWpb7ZKUwVC3KTaHy8x3LVpcRGx+6KzKWplDenYy789QZAhjxLVEzTAFm9Yu69evThhqxOh0nlQcaZwwEzRNm6FZfzR/kL5/rREVpQpO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tkv5HnfX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D875EC4CEE7;
	Sat,  1 Nov 2025 00:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761956156;
	bh=KTWnS0NuwuS3h4Mv73yrH8W+uBK3AXpPDIfJj8tPHcQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tkv5HnfXJgraPLA9l6+7TyFdmNVm+/6v0f6+28ZNC6DwPzxtn7x613sAX5r83MZKB
	 98ro4cnFYgsEfMw9naAKx367hdP09l+dqt9p7Hfe5iFdBaAnU7nkbEOAkHj2FICZHW
	 hCcGT9FFSTm5nvFvhcwsN76qeImLG0l7f1mOzi2rUz/E6MrFcGoGvy2MGagm9213tf
	 n6sBus5z3JkH5Q/T7xso1q3Y/fkccVElhFxurWlSWC0vdDPkkUplW4/hG9DUh2sok0
	 Dl1RymRJZnBfIL3EgPaYnZv/+YNcpg7ciOyHt/ZOA60xMWrqvkKfgDX02786134yoh
	 EaDa3MuD8l+AQ==
Date: Fri, 31 Oct 2025 17:15:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: improve the ->iop_format interface
Message-ID: <20251101001556.GS3356773@frogsfrogsfrogs>
References: <20251030144946.1372887-1-hch@lst.de>
 <20251030144946.1372887-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251030144946.1372887-4-hch@lst.de>

On Thu, Oct 30, 2025 at 03:49:13PM +0100, Christoph Hellwig wrote:
> Export a higher level interface to format log items.  The xlog_format_buf
> structure is hidden inside xfs_log_cil.c and only accessed using two
> helpers (and a wrapper build on top), hiding details of log iovecs from
> the log items.  This also allows simply using an index into lv_iovecp
> instead of keeping a cursor vec.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That's a nice cleanup!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_attr_item.c     |  27 +++++-----
>  fs/xfs/xfs_bmap_item.c     |  10 ++--
>  fs/xfs/xfs_buf_item.c      |  19 +++----
>  fs/xfs/xfs_dquot_item.c    |   9 ++--
>  fs/xfs/xfs_exchmaps_item.c |  11 ++--
>  fs/xfs/xfs_extfree_item.c  |  10 ++--
>  fs/xfs/xfs_icreate_item.c  |   6 +--
>  fs/xfs/xfs_inode_item.c    |  49 +++++++++---------
>  fs/xfs/xfs_log.c           |  56 ---------------------
>  fs/xfs/xfs_log.h           |  53 ++++----------------
>  fs/xfs/xfs_log_cil.c       | 100 ++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_refcount_item.c |  10 ++--
>  fs/xfs/xfs_rmap_item.c     |  10 ++--
>  fs/xfs/xfs_trans.h         |   4 +-
>  14 files changed, 180 insertions(+), 194 deletions(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index c3a593319bee..02fca5267f53 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -192,10 +192,9 @@ xfs_attri_item_size(
>  STATIC void
>  xfs_attri_item_format(
>  	struct xfs_log_item		*lip,
> -	struct xfs_log_vec		*lv)
> +	struct xlog_format_buf		*lfb)
>  {
>  	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
> -	struct xfs_log_iovec		*vecp = NULL;
>  	struct xfs_attri_log_nameval	*nv = attrip->attri_nameval;
>  
>  	attrip->attri_format.alfi_type = XFS_LI_ATTRI;
> @@ -220,24 +219,23 @@ xfs_attri_item_format(
>  	if (nv->new_value.iov_len > 0)
>  		attrip->attri_format.alfi_size++;
>  
> -	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
> -			&attrip->attri_format,
> +	xlog_format_copy(lfb, XLOG_REG_TYPE_ATTRI_FORMAT, &attrip->attri_format,
>  			sizeof(struct xfs_attri_log_format));
>  
> -	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME, nv->name.iov_base,
> +	xlog_format_copy(lfb, XLOG_REG_TYPE_ATTR_NAME, nv->name.iov_base,
>  			nv->name.iov_len);
>  
>  	if (nv->new_name.iov_len > 0)
> -		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NEWNAME,
> -			nv->new_name.iov_base, nv->new_name.iov_len);
> +		xlog_format_copy(lfb, XLOG_REG_TYPE_ATTR_NEWNAME,
> +				nv->new_name.iov_base, nv->new_name.iov_len);
>  
>  	if (nv->value.iov_len > 0)
> -		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
> -			nv->value.iov_base, nv->value.iov_len);
> +		xlog_format_copy(lfb, XLOG_REG_TYPE_ATTR_VALUE,
> +				nv->value.iov_base, nv->value.iov_len);
>  
>  	if (nv->new_value.iov_len > 0)
> -		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NEWVALUE,
> -			nv->new_value.iov_base, nv->new_value.iov_len);
> +		xlog_format_copy(lfb, XLOG_REG_TYPE_ATTR_NEWVALUE,
> +				nv->new_value.iov_base, nv->new_value.iov_len);
>  }
>  
>  /*
> @@ -322,16 +320,15 @@ xfs_attrd_item_size(
>   */
>  STATIC void
>  xfs_attrd_item_format(
> -	struct xfs_log_item	*lip,
> -	struct xfs_log_vec	*lv)
> +	struct xfs_log_item		*lip,
> +	struct xlog_format_buf		*lfb)
>  {
>  	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
> -	struct xfs_log_iovec		*vecp = NULL;
>  
>  	attrdp->attrd_format.alfd_type = XFS_LI_ATTRD;
>  	attrdp->attrd_format.alfd_size = 1;
>  
> -	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRD_FORMAT,
> +	xlog_format_copy(lfb, XLOG_REG_TYPE_ATTRD_FORMAT,
>  			&attrdp->attrd_format,
>  			sizeof(struct xfs_attrd_log_format));
>  }
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 80f0c4bcc483..f38ed63fe86b 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -92,10 +92,9 @@ unsigned int xfs_bui_log_space(unsigned int nr)
>  STATIC void
>  xfs_bui_item_format(
>  	struct xfs_log_item	*lip,
> -	struct xfs_log_vec	*lv)
> +	struct xlog_format_buf	*lfb)
>  {
>  	struct xfs_bui_log_item	*buip = BUI_ITEM(lip);
> -	struct xfs_log_iovec	*vecp = NULL;
>  
>  	ASSERT(atomic_read(&buip->bui_next_extent) ==
>  			buip->bui_format.bui_nextents);
> @@ -103,7 +102,7 @@ xfs_bui_item_format(
>  	buip->bui_format.bui_type = XFS_LI_BUI;
>  	buip->bui_format.bui_size = 1;
>  
> -	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_BUI_FORMAT, &buip->bui_format,
> +	xlog_format_copy(lfb, XLOG_REG_TYPE_BUI_FORMAT, &buip->bui_format,
>  			xfs_bui_log_format_sizeof(buip->bui_format.bui_nextents));
>  }
>  
> @@ -188,15 +187,14 @@ unsigned int xfs_bud_log_space(void)
>  STATIC void
>  xfs_bud_item_format(
>  	struct xfs_log_item	*lip,
> -	struct xfs_log_vec	*lv)
> +	struct xlog_format_buf	*lfb)
>  {
>  	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
> -	struct xfs_log_iovec	*vecp = NULL;
>  
>  	budp->bud_format.bud_type = XFS_LI_BUD;
>  	budp->bud_format.bud_size = 1;
>  
> -	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_BUD_FORMAT, &budp->bud_format,
> +	xlog_format_copy(lfb, XLOG_REG_TYPE_BUD_FORMAT, &budp->bud_format,
>  			sizeof(struct xfs_bud_log_format));
>  }
>  
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 8d85b5eee444..c998983ade64 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -263,24 +263,21 @@ xfs_buf_item_size(
>  
>  static inline void
>  xfs_buf_item_copy_iovec(
> -	struct xfs_log_vec	*lv,
> -	struct xfs_log_iovec	**vecp,
> +	struct xlog_format_buf	*lfb,
>  	struct xfs_buf		*bp,
>  	uint			offset,
>  	int			first_bit,
>  	uint			nbits)
>  {
>  	offset += first_bit * XFS_BLF_CHUNK;
> -	xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_BCHUNK,
> -			xfs_buf_offset(bp, offset),
> +	xlog_format_copy(lfb, XLOG_REG_TYPE_BCHUNK, xfs_buf_offset(bp, offset),
>  			nbits * XFS_BLF_CHUNK);
>  }
>  
>  static void
>  xfs_buf_item_format_segment(
>  	struct xfs_buf_log_item	*bip,
> -	struct xfs_log_vec	*lv,
> -	struct xfs_log_iovec	**vecp,
> +	struct xlog_format_buf	*lfb,
>  	uint			offset,
>  	struct xfs_buf_log_format *blfp)
>  {
> @@ -308,7 +305,7 @@ xfs_buf_item_format_segment(
>  		return;
>  	}
>  
> -	blfp = xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_BFORMAT, blfp, base_size);
> +	blfp = xlog_format_copy(lfb, XLOG_REG_TYPE_BFORMAT, blfp, base_size);
>  	blfp->blf_size = 1;
>  
>  	if (bip->bli_flags & XFS_BLI_STALE) {
> @@ -331,8 +328,7 @@ xfs_buf_item_format_segment(
>  		nbits = xfs_contig_bits(blfp->blf_data_map,
>  					blfp->blf_map_size, first_bit);
>  		ASSERT(nbits > 0);
> -		xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
> -					first_bit, nbits);
> +		xfs_buf_item_copy_iovec(lfb, bp, offset, first_bit, nbits);
>  		blfp->blf_size++;
>  
>  		/*
> @@ -357,11 +353,10 @@ xfs_buf_item_format_segment(
>  STATIC void
>  xfs_buf_item_format(
>  	struct xfs_log_item	*lip,
> -	struct xfs_log_vec	*lv)
> +	struct xlog_format_buf	*lfb)
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
>  	struct xfs_buf		*bp = bip->bli_buf;
> -	struct xfs_log_iovec	*vecp = NULL;
>  	uint			offset = 0;
>  	int			i;
>  
> @@ -398,7 +393,7 @@ xfs_buf_item_format(
>  	}
>  
>  	for (i = 0; i < bip->bli_format_count; i++) {
> -		xfs_buf_item_format_segment(bip, lv, &vecp, offset,
> +		xfs_buf_item_format_segment(bip, lfb, offset,
>  					    &bip->bli_formats[i]);
>  		offset += BBTOB(bp->b_maps[i].bm_len);
>  	}
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 271b195ebb93..9c2fcfbdf7dc 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -44,25 +44,24 @@ xfs_qm_dquot_logitem_size(
>  STATIC void
>  xfs_qm_dquot_logitem_format(
>  	struct xfs_log_item	*lip,
> -	struct xfs_log_vec	*lv)
> +	struct xlog_format_buf	*lfb)
>  {
>  	struct xfs_disk_dquot	ddq;
>  	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
> -	struct xfs_log_iovec	*vecp = NULL;
>  	struct xfs_dq_logformat	*qlf;
>  
> -	qlf = xlog_prepare_iovec(lv, &vecp, XLOG_REG_TYPE_QFORMAT);
> +	qlf = xlog_format_start(lfb, XLOG_REG_TYPE_QFORMAT);
>  	qlf->qlf_type = XFS_LI_DQUOT;
>  	qlf->qlf_size = 2;
>  	qlf->qlf_id = qlip->qli_dquot->q_id;
>  	qlf->qlf_blkno = qlip->qli_dquot->q_blkno;
>  	qlf->qlf_len = 1;
>  	qlf->qlf_boffset = qlip->qli_dquot->q_bufoffset;
> -	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_dq_logformat));
> +	xlog_format_commit(lfb, sizeof(struct xfs_dq_logformat));
>  
>  	xfs_dquot_to_disk(&ddq, qlip->qli_dquot);
>  
> -	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_DQUOT, &ddq,
> +	xlog_format_copy(lfb, XLOG_REG_TYPE_DQUOT, &ddq,
>  			sizeof(struct xfs_disk_dquot));
>  }
>  
> diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
> index 229cbe0adf17..10d6fbeff651 100644
> --- a/fs/xfs/xfs_exchmaps_item.c
> +++ b/fs/xfs/xfs_exchmaps_item.c
> @@ -83,16 +83,14 @@ xfs_xmi_item_size(
>  STATIC void
>  xfs_xmi_item_format(
>  	struct xfs_log_item	*lip,
> -	struct xfs_log_vec	*lv)
> +	struct xlog_format_buf	*lfb)
>  {
>  	struct xfs_xmi_log_item	*xmi_lip = XMI_ITEM(lip);
> -	struct xfs_log_iovec	*vecp = NULL;
>  
>  	xmi_lip->xmi_format.xmi_type = XFS_LI_XMI;
>  	xmi_lip->xmi_format.xmi_size = 1;
>  
> -	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_XMI_FORMAT,
> -			&xmi_lip->xmi_format,
> +	xlog_format_copy(lfb, XLOG_REG_TYPE_XMI_FORMAT, &xmi_lip->xmi_format,
>  			sizeof(struct xfs_xmi_log_format));
>  }
>  
> @@ -166,15 +164,14 @@ xfs_xmd_item_size(
>  STATIC void
>  xfs_xmd_item_format(
>  	struct xfs_log_item	*lip,
> -	struct xfs_log_vec	*lv)
> +	struct xlog_format_buf	*lfb)
>  {
>  	struct xfs_xmd_log_item	*xmd_lip = XMD_ITEM(lip);
> -	struct xfs_log_iovec	*vecp = NULL;
>  
>  	xmd_lip->xmd_format.xmd_type = XFS_LI_XMD;
>  	xmd_lip->xmd_format.xmd_size = 1;
>  
> -	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_XMD_FORMAT, &xmd_lip->xmd_format,
> +	xlog_format_copy(lfb, XLOG_REG_TYPE_XMD_FORMAT, &xmd_lip->xmd_format,
>  			sizeof(struct xfs_xmd_log_format));
>  }
>  
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 418ddab590e0..3d1edc43e6fb 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -98,10 +98,9 @@ unsigned int xfs_efi_log_space(unsigned int nr)
>  STATIC void
>  xfs_efi_item_format(
>  	struct xfs_log_item	*lip,
> -	struct xfs_log_vec	*lv)
> +	struct xlog_format_buf	*lfb)
>  {
>  	struct xfs_efi_log_item	*efip = EFI_ITEM(lip);
> -	struct xfs_log_iovec	*vecp = NULL;
>  
>  	ASSERT(atomic_read(&efip->efi_next_extent) ==
>  				efip->efi_format.efi_nextents);
> @@ -110,7 +109,7 @@ xfs_efi_item_format(
>  	efip->efi_format.efi_type = lip->li_type;
>  	efip->efi_format.efi_size = 1;
>  
> -	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_EFI_FORMAT, &efip->efi_format,
> +	xlog_format_copy(lfb, XLOG_REG_TYPE_EFI_FORMAT, &efip->efi_format,
>  			xfs_efi_log_format_sizeof(efip->efi_format.efi_nextents));
>  }
>  
> @@ -277,10 +276,9 @@ unsigned int xfs_efd_log_space(unsigned int nr)
>  STATIC void
>  xfs_efd_item_format(
>  	struct xfs_log_item	*lip,
> -	struct xfs_log_vec	*lv)
> +	struct xlog_format_buf	*lfb)
>  {
>  	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
> -	struct xfs_log_iovec	*vecp = NULL;
>  
>  	ASSERT(efdp->efd_next_extent == efdp->efd_format.efd_nextents);
>  	ASSERT(lip->li_type == XFS_LI_EFD || lip->li_type == XFS_LI_EFD_RT);
> @@ -288,7 +286,7 @@ xfs_efd_item_format(
>  	efdp->efd_format.efd_type = lip->li_type;
>  	efdp->efd_format.efd_size = 1;
>  
> -	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_EFD_FORMAT, &efdp->efd_format,
> +	xlog_format_copy(lfb, XLOG_REG_TYPE_EFD_FORMAT, &efdp->efd_format,
>  			xfs_efd_log_format_sizeof(efdp->efd_format.efd_nextents));
>  }
>  
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index f83ec2bd0583..004dd22393dc 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -49,13 +49,11 @@ xfs_icreate_item_size(
>  STATIC void
>  xfs_icreate_item_format(
>  	struct xfs_log_item	*lip,
> -	struct xfs_log_vec	*lv)
> +	struct xlog_format_buf	*lfb)
>  {
>  	struct xfs_icreate_item	*icp = ICR_ITEM(lip);
> -	struct xfs_log_iovec	*vecp = NULL;
>  
> -	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ICREATE,
> -			&icp->ic_format,
> +	xlog_format_copy(lfb, XLOG_REG_TYPE_ICREATE, &icp->ic_format,
>  			sizeof(struct xfs_icreate_log));
>  }
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 1bd411a1114c..54d72234ae32 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -336,8 +336,7 @@ STATIC void
>  xfs_inode_item_format_data_fork(
>  	struct xfs_inode_log_item *iip,
>  	struct xfs_inode_log_format *ilf,
> -	struct xfs_log_vec	*lv,
> -	struct xfs_log_iovec	**vecp)
> +	struct xlog_format_buf	*lfb)
>  {
>  	struct xfs_inode	*ip = iip->ili_inode;
>  	size_t			data_bytes;
> @@ -354,9 +353,9 @@ xfs_inode_item_format_data_fork(
>  
>  			ASSERT(xfs_iext_count(&ip->i_df) > 0);
>  
> -			p = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_IEXT);
> +			p = xlog_format_start(lfb, XLOG_REG_TYPE_IEXT);
>  			data_bytes = xfs_iextents_copy(ip, p, XFS_DATA_FORK);
> -			xlog_finish_iovec(lv, *vecp, data_bytes);
> +			xlog_format_commit(lfb, data_bytes);
>  
>  			ASSERT(data_bytes <= ip->i_df.if_bytes);
>  
> @@ -374,7 +373,7 @@ xfs_inode_item_format_data_fork(
>  		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
>  		    ip->i_df.if_broot_bytes > 0) {
>  			ASSERT(ip->i_df.if_broot != NULL);
> -			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IBROOT,
> +			xlog_format_copy(lfb, XLOG_REG_TYPE_IBROOT,
>  					ip->i_df.if_broot,
>  					ip->i_df.if_broot_bytes);
>  			ilf->ilf_dsize = ip->i_df.if_broot_bytes;
> @@ -392,8 +391,9 @@ xfs_inode_item_format_data_fork(
>  		    ip->i_df.if_bytes > 0) {
>  			ASSERT(ip->i_df.if_data != NULL);
>  			ASSERT(ip->i_disk_size > 0);
> -			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_ILOCAL,
> -					ip->i_df.if_data, ip->i_df.if_bytes);
> +			xlog_format_copy(lfb, XLOG_REG_TYPE_ILOCAL,
> +					ip->i_df.if_data,
> +					ip->i_df.if_bytes);
>  			ilf->ilf_dsize = (unsigned)ip->i_df.if_bytes;
>  			ilf->ilf_size++;
>  		} else {
> @@ -416,8 +416,7 @@ STATIC void
>  xfs_inode_item_format_attr_fork(
>  	struct xfs_inode_log_item *iip,
>  	struct xfs_inode_log_format *ilf,
> -	struct xfs_log_vec	*lv,
> -	struct xfs_log_iovec	**vecp)
> +	struct xlog_format_buf	*lfb)
>  {
>  	struct xfs_inode	*ip = iip->ili_inode;
>  	size_t			data_bytes;
> @@ -435,9 +434,9 @@ xfs_inode_item_format_attr_fork(
>  			ASSERT(xfs_iext_count(&ip->i_af) ==
>  				ip->i_af.if_nextents);
>  
> -			p = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_EXT);
> +			p = xlog_format_start(lfb, XLOG_REG_TYPE_IATTR_EXT);
>  			data_bytes = xfs_iextents_copy(ip, p, XFS_ATTR_FORK);
> -			xlog_finish_iovec(lv, *vecp, data_bytes);
> +			xlog_format_commit(lfb, data_bytes);
>  
>  			ilf->ilf_asize = data_bytes;
>  			ilf->ilf_size++;
> @@ -453,7 +452,7 @@ xfs_inode_item_format_attr_fork(
>  		    ip->i_af.if_broot_bytes > 0) {
>  			ASSERT(ip->i_af.if_broot != NULL);
>  
> -			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_BROOT,
> +			xlog_format_copy(lfb, XLOG_REG_TYPE_IATTR_BROOT,
>  					ip->i_af.if_broot,
>  					ip->i_af.if_broot_bytes);
>  			ilf->ilf_asize = ip->i_af.if_broot_bytes;
> @@ -469,8 +468,9 @@ xfs_inode_item_format_attr_fork(
>  		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
>  		    ip->i_af.if_bytes > 0) {
>  			ASSERT(ip->i_af.if_data != NULL);
> -			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_LOCAL,
> -					ip->i_af.if_data, ip->i_af.if_bytes);
> +			xlog_format_copy(lfb, XLOG_REG_TYPE_IATTR_LOCAL,
> +					ip->i_af.if_data,
> +					ip->i_af.if_bytes);
>  			ilf->ilf_asize = (unsigned)ip->i_af.if_bytes;
>  			ilf->ilf_size++;
>  		} else {
> @@ -619,14 +619,13 @@ xfs_inode_to_log_dinode(
>  static void
>  xfs_inode_item_format_core(
>  	struct xfs_inode	*ip,
> -	struct xfs_log_vec	*lv,
> -	struct xfs_log_iovec	**vecp)
> +	struct xlog_format_buf	*lfb)
>  {
>  	struct xfs_log_dinode	*dic;
>  
> -	dic = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_ICORE);
> +	dic = xlog_format_start(lfb, XLOG_REG_TYPE_ICORE);
>  	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);
> -	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_mount));
> +	xlog_format_commit(lfb, xfs_log_dinode_size(ip->i_mount));
>  }
>  
>  /*
> @@ -644,14 +643,13 @@ xfs_inode_item_format_core(
>  STATIC void
>  xfs_inode_item_format(
>  	struct xfs_log_item	*lip,
> -	struct xfs_log_vec	*lv)
> +	struct xlog_format_buf	*lfb)
>  {
>  	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
>  	struct xfs_inode	*ip = iip->ili_inode;
> -	struct xfs_log_iovec	*vecp = NULL;
>  	struct xfs_inode_log_format *ilf;
>  
> -	ilf = xlog_prepare_iovec(lv, &vecp, XLOG_REG_TYPE_IFORMAT);
> +	ilf = xlog_format_start(lfb, XLOG_REG_TYPE_IFORMAT);
>  	ilf->ilf_type = XFS_LI_INODE;
>  	ilf->ilf_ino = ip->i_ino;
>  	ilf->ilf_blkno = ip->i_imap.im_blkno;
> @@ -668,13 +666,12 @@ xfs_inode_item_format(
>  	ilf->ilf_asize = 0;
>  	ilf->ilf_pad = 0;
>  	memset(&ilf->ilf_u, 0, sizeof(ilf->ilf_u));
> +	xlog_format_commit(lfb, sizeof(*ilf));
>  
> -	xlog_finish_iovec(lv, vecp, sizeof(*ilf));
> -
> -	xfs_inode_item_format_core(ip, lv, &vecp);
> -	xfs_inode_item_format_data_fork(iip, ilf, lv, &vecp);
> +	xfs_inode_item_format_core(ip, lfb);
> +	xfs_inode_item_format_data_fork(iip, ilf, lfb);
>  	if (xfs_inode_has_attr_fork(ip)) {
> -		xfs_inode_item_format_attr_fork(iip, ilf, lv, &vecp);
> +		xfs_inode_item_format_attr_fork(iip, ilf, lfb);
>  	} else {
>  		iip->ili_fields &=
>  			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT | XFS_ILOG_AEXT);
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 382c55f4d8d2..93e99d1cc037 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -74,62 +74,6 @@ xlog_iclogs_empty(
>  static int
>  xfs_log_cover(struct xfs_mount *);
>  
> -/*
> - * We need to make sure the buffer pointer returned is naturally aligned for the
> - * biggest basic data type we put into it. We have already accounted for this
> - * padding when sizing the buffer.
> - *
> - * However, this padding does not get written into the log, and hence we have to
> - * track the space used by the log vectors separately to prevent log space hangs
> - * due to inaccurate accounting (i.e. a leak) of the used log space through the
> - * CIL context ticket.
> - *
> - * We also add space for the xlog_op_header that describes this region in the
> - * log. This prepends the data region we return to the caller to copy their data
> - * into, so do all the static initialisation of the ophdr now. Because the ophdr
> - * is not 8 byte aligned, we have to be careful to ensure that we align the
> - * start of the buffer such that the region we return to the call is 8 byte
> - * aligned and packed against the tail of the ophdr.
> - */
> -void *
> -xlog_prepare_iovec(
> -	struct xfs_log_vec	*lv,
> -	struct xfs_log_iovec	**vecp,
> -	uint			type)
> -{
> -	struct xfs_log_iovec	*vec = *vecp;
> -	struct xlog_op_header	*oph;
> -	uint32_t		len;
> -	void			*buf;
> -
> -	if (vec) {
> -		ASSERT(vec - lv->lv_iovecp < lv->lv_niovecs);
> -		vec++;
> -	} else {
> -		vec = &lv->lv_iovecp[0];
> -	}
> -
> -	len = lv->lv_buf_used + sizeof(struct xlog_op_header);
> -	if (!IS_ALIGNED(len, sizeof(uint64_t))) {
> -		lv->lv_buf_used = round_up(len, sizeof(uint64_t)) -
> -					sizeof(struct xlog_op_header);
> -	}
> -
> -	vec->i_type = type;
> -	vec->i_addr = lv->lv_buf + lv->lv_buf_used;
> -
> -	oph = vec->i_addr;
> -	oph->oh_clientid = XFS_TRANSACTION;
> -	oph->oh_res2 = 0;
> -	oph->oh_flags = 0;
> -
> -	buf = vec->i_addr + sizeof(struct xlog_op_header);
> -	ASSERT(IS_ALIGNED((unsigned long)buf, sizeof(uint64_t)));
> -
> -	*vecp = vec;
> -	return buf;
> -}
> -
>  static inline void
>  xlog_grant_sub_space(
>  	struct xlog_grant_head	*head,
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index dcc1f44ed68f..c4930e925fed 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -6,6 +6,7 @@
>  #ifndef	__XFS_LOG_H__
>  #define __XFS_LOG_H__
>  
> +struct xlog_format_buf;
>  struct xfs_cil_ctx;
>  
>  struct xfs_log_vec {
> @@ -70,58 +71,24 @@ xlog_calc_iovec_len(int len)
>  	return roundup(len, sizeof(uint32_t));
>  }
>  
> -void *xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
> -		uint type);
> -
> -static inline void
> -xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec,
> -		int data_len)
> -{
> -	struct xlog_op_header	*oph = vec->i_addr;
> -	int			len;
> -
> -	/*
> -	 * Always round up the length to the correct alignment so callers don't
> -	 * need to know anything about this log vec layout requirement. This
> -	 * means we have to zero the area the data to be written does not cover.
> -	 * This is complicated by fact the payload region is offset into the
> -	 * logvec region by the opheader that tracks the payload.
> -	 */
> -	len = xlog_calc_iovec_len(data_len);
> -	if (len - data_len != 0) {
> -		char	*buf = vec->i_addr + sizeof(struct xlog_op_header);
> -
> -		memset(buf + data_len, 0, len - data_len);
> -	}
> -
> -	/*
> -	 * The opheader tracks aligned payload length, whilst the logvec tracks
> -	 * the overall region length.
> -	 */
> -	oph->oh_len = cpu_to_be32(len);
> -
> -	len += sizeof(struct xlog_op_header);
> -	lv->lv_buf_used += len;
> -	lv->lv_bytes += len;
> -	vec->i_len = len;
> -
> -	/* Catch buffer overruns */
> -	ASSERT((void *)lv->lv_buf + lv->lv_bytes <=
> -		(void *)lv + lv->lv_alloc_size);
> -}
> +void *xlog_format_start(struct xlog_format_buf *lfb, uint16_t type);
> +void xlog_format_commit(struct xlog_format_buf *lfb, unsigned int data_len);
>  
>  /*
>   * Copy the amount of data requested by the caller into a new log iovec.
>   */
>  static inline void *
> -xlog_copy_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
> -		uint type, void *data, int len)
> +xlog_format_copy(
> +	struct xlog_format_buf	*lfb,
> +	uint16_t		type,
> +	void			*data,
> +	unsigned int		len)
>  {
>  	void *buf;
>  
> -	buf = xlog_prepare_iovec(lv, vecp, type);
> +	buf = xlog_format_start(lfb, type);
>  	memcpy(buf, data, len);
> -	xlog_finish_iovec(lv, *vecp, len);
> +	xlog_format_commit(lfb, len);
>  	return buf;
>  }
>  
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 83aa06e19cfb..bc25012ac5c0 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -409,6 +409,102 @@ xfs_cil_prepare_item(
>  		lv->lv_item->li_seq = log->l_cilp->xc_ctx->sequence;
>  }
>  
> +struct xlog_format_buf {
> +	struct xfs_log_vec	*lv;
> +	unsigned int		idx;
> +};
> +
> +/*
> + * We need to make sure the buffer pointer returned is naturally aligned for the
> + * biggest basic data type we put into it. We have already accounted for this
> + * padding when sizing the buffer.
> + *
> + * However, this padding does not get written into the log, and hence we have to
> + * track the space used by the log vectors separately to prevent log space hangs
> + * due to inaccurate accounting (i.e. a leak) of the used log space through the
> + * CIL context ticket.
> + *
> + * We also add space for the xlog_op_header that describes this region in the
> + * log. This prepends the data region we return to the caller to copy their data
> + * into, so do all the static initialisation of the ophdr now. Because the ophdr
> + * is not 8 byte aligned, we have to be careful to ensure that we align the
> + * start of the buffer such that the region we return to the call is 8 byte
> + * aligned and packed against the tail of the ophdr.
> + */
> +void *
> +xlog_format_start(
> +	struct xlog_format_buf	*lfb,
> +	uint16_t		type)
> +{
> +	struct xfs_log_vec	*lv = lfb->lv;
> +	struct xfs_log_iovec	*vec = &lv->lv_iovecp[lfb->idx];
> +	struct xlog_op_header	*oph;
> +	uint32_t		len;
> +	void			*buf;
> +
> +	ASSERT(lfb->idx < lv->lv_niovecs);
> +
> +	len = lv->lv_buf_used + sizeof(struct xlog_op_header);
> +	if (!IS_ALIGNED(len, sizeof(uint64_t))) {
> +		lv->lv_buf_used = round_up(len, sizeof(uint64_t)) -
> +					sizeof(struct xlog_op_header);
> +	}
> +
> +	vec->i_type = type;
> +	vec->i_addr = lv->lv_buf + lv->lv_buf_used;
> +
> +	oph = vec->i_addr;
> +	oph->oh_clientid = XFS_TRANSACTION;
> +	oph->oh_res2 = 0;
> +	oph->oh_flags = 0;
> +
> +	buf = vec->i_addr + sizeof(struct xlog_op_header);
> +	ASSERT(IS_ALIGNED((unsigned long)buf, sizeof(uint64_t)));
> +	return buf;
> +}
> +
> +void
> +xlog_format_commit(
> +	struct xlog_format_buf	*lfb,
> +	unsigned int		data_len)
> +{
> +	struct xfs_log_vec	*lv = lfb->lv;
> +	struct xfs_log_iovec	*vec = &lv->lv_iovecp[lfb->idx];
> +	struct xlog_op_header	*oph = vec->i_addr;
> +	int			len;
> +
> +	/*
> +	 * Always round up the length to the correct alignment so callers don't
> +	 * need to know anything about this log vec layout requirement. This
> +	 * means we have to zero the area the data to be written does not cover.
> +	 * This is complicated by fact the payload region is offset into the
> +	 * logvec region by the opheader that tracks the payload.
> +	 */
> +	len = xlog_calc_iovec_len(data_len);
> +	if (len - data_len != 0) {
> +		char	*buf = vec->i_addr + sizeof(struct xlog_op_header);
> +
> +		memset(buf + data_len, 0, len - data_len);
> +	}
> +
> +	/*
> +	 * The opheader tracks aligned payload length, whilst the logvec tracks
> +	 * the overall region length.
> +	 */
> +	oph->oh_len = cpu_to_be32(len);
> +
> +	len += sizeof(struct xlog_op_header);
> +	lv->lv_buf_used += len;
> +	lv->lv_bytes += len;
> +	vec->i_len = len;
> +
> +	/* Catch buffer overruns */
> +	ASSERT((void *)lv->lv_buf + lv->lv_bytes <=
> +		(void *)lv + lv->lv_alloc_size);
> +
> +	lfb->idx++;
> +}
> +
>  /*
>   * Format log item into a flat buffers
>   *
> @@ -454,6 +550,7 @@ xlog_cil_insert_format_items(
>  	list_for_each_entry(lip, &tp->t_items, li_trans) {
>  		struct xfs_log_vec *lv = lip->li_lv;
>  		struct xfs_log_vec *shadow = lip->li_lv_shadow;
> +		struct xlog_format_buf lfb = { };
>  
>  		/* Skip items which aren't dirty in this transaction. */
>  		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
> @@ -501,8 +598,9 @@ xlog_cil_insert_format_items(
>  			lv->lv_item = lip;
>  		}
>  
> +		lfb.lv = lv;
>  		ASSERT(IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)));
> -		lip->li_ops->iop_format(lip, lv);
> +		lip->li_ops->iop_format(lip, &lfb);
>  		xfs_cil_prepare_item(log, lip, lv, diff_len);
>  	}
>  }
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 3728234699a2..a41f5b577e22 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -93,10 +93,9 @@ unsigned int xfs_cui_log_space(unsigned int nr)
>  STATIC void
>  xfs_cui_item_format(
>  	struct xfs_log_item	*lip,
> -	struct xfs_log_vec	*lv)
> +	struct xlog_format_buf	*lfb)
>  {
>  	struct xfs_cui_log_item	*cuip = CUI_ITEM(lip);
> -	struct xfs_log_iovec	*vecp = NULL;
>  
>  	ASSERT(atomic_read(&cuip->cui_next_extent) ==
>  			cuip->cui_format.cui_nextents);
> @@ -105,7 +104,7 @@ xfs_cui_item_format(
>  	cuip->cui_format.cui_type = lip->li_type;
>  	cuip->cui_format.cui_size = 1;
>  
> -	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_CUI_FORMAT, &cuip->cui_format,
> +	xlog_format_copy(lfb, XLOG_REG_TYPE_CUI_FORMAT, &cuip->cui_format,
>  			xfs_cui_log_format_sizeof(cuip->cui_format.cui_nextents));
>  }
>  
> @@ -199,17 +198,16 @@ unsigned int xfs_cud_log_space(void)
>  STATIC void
>  xfs_cud_item_format(
>  	struct xfs_log_item	*lip,
> -	struct xfs_log_vec	*lv)
> +	struct xlog_format_buf	*lfb)
>  {
>  	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
> -	struct xfs_log_iovec	*vecp = NULL;
>  
>  	ASSERT(lip->li_type == XFS_LI_CUD || lip->li_type == XFS_LI_CUD_RT);
>  
>  	cudp->cud_format.cud_type = lip->li_type;
>  	cudp->cud_format.cud_size = 1;
>  
> -	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_CUD_FORMAT, &cudp->cud_format,
> +	xlog_format_copy(lfb, XLOG_REG_TYPE_CUD_FORMAT, &cudp->cud_format,
>  			sizeof(struct xfs_cud_log_format));
>  }
>  
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 15f0903f6fd4..8bf04b101156 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -92,10 +92,9 @@ unsigned int xfs_rui_log_space(unsigned int nr)
>  STATIC void
>  xfs_rui_item_format(
>  	struct xfs_log_item	*lip,
> -	struct xfs_log_vec	*lv)
> +	struct xlog_format_buf	*lfb)
>  {
>  	struct xfs_rui_log_item	*ruip = RUI_ITEM(lip);
> -	struct xfs_log_iovec	*vecp = NULL;
>  
>  	ASSERT(atomic_read(&ruip->rui_next_extent) ==
>  			ruip->rui_format.rui_nextents);
> @@ -105,7 +104,7 @@ xfs_rui_item_format(
>  	ruip->rui_format.rui_type = lip->li_type;
>  	ruip->rui_format.rui_size = 1;
>  
> -	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_RUI_FORMAT, &ruip->rui_format,
> +	xlog_format_copy(lfb, XLOG_REG_TYPE_RUI_FORMAT, &ruip->rui_format,
>  			xfs_rui_log_format_sizeof(ruip->rui_format.rui_nextents));
>  }
>  
> @@ -200,17 +199,16 @@ unsigned int xfs_rud_log_space(void)
>  STATIC void
>  xfs_rud_item_format(
>  	struct xfs_log_item	*lip,
> -	struct xfs_log_vec	*lv)
> +	struct xlog_format_buf	*lfb)
>  {
>  	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
> -	struct xfs_log_iovec	*vecp = NULL;
>  
>  	ASSERT(lip->li_type == XFS_LI_RUD || lip->li_type == XFS_LI_RUD_RT);
>  
>  	rudp->rud_format.rud_type = lip->li_type;
>  	rudp->rud_format.rud_size = 1;
>  
> -	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_RUD_FORMAT, &rudp->rud_format,
> +	xlog_format_copy(lfb, XLOG_REG_TYPE_RUD_FORMAT, &rudp->rud_format,
>  			sizeof(struct xfs_rud_log_format));
>  }
>  
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 7fb860f645a3..8830600b3e72 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -9,6 +9,7 @@
>  /* kernel only transaction subsystem defines */
>  
>  struct xlog;
> +struct xlog_format_buf;
>  struct xfs_buf;
>  struct xfs_buftarg;
>  struct xfs_efd_log_item;
> @@ -70,7 +71,8 @@ struct xfs_log_item {
>  struct xfs_item_ops {
>  	unsigned flags;
>  	void (*iop_size)(struct xfs_log_item *, int *, int *);
> -	void (*iop_format)(struct xfs_log_item *, struct xfs_log_vec *);
> +	void (*iop_format)(struct xfs_log_item *lip,
> +			struct xlog_format_buf *lfb);
>  	void (*iop_pin)(struct xfs_log_item *);
>  	void (*iop_unpin)(struct xfs_log_item *, int remove);
>  	uint64_t (*iop_sort)(struct xfs_log_item *lip);
> -- 
> 2.47.3
> 
> 

