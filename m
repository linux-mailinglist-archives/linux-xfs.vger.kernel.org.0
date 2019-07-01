Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29BF5237C6
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 15:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730855AbfETNMq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 09:12:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34858 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730513AbfETNMq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 09:12:46 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E462A3082E4F;
        Mon, 20 May 2019 13:12:45 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D1E9100EBDF;
        Mon, 20 May 2019 13:12:45 +0000 (UTC)
Date:   Mon, 20 May 2019 09:12:43 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/20] xfs: remove a pointless comment duplicated above
 all xfs_item_ops instances
Message-ID: <20190520131243.GC31317@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-13-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 20 May 2019 13:12:45 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:11AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_bmap_item.c     | 6 ------
>  fs/xfs/xfs_buf_item.c      | 3 ---
>  fs/xfs/xfs_dquot_item.c    | 6 ------
>  fs/xfs/xfs_extfree_item.c  | 6 ------
>  fs/xfs/xfs_icreate_item.c  | 3 ---
>  fs/xfs/xfs_inode_item.c    | 3 ---
>  fs/xfs/xfs_refcount_item.c | 6 ------
>  fs/xfs/xfs_rmap_item.c     | 6 ------
>  8 files changed, 39 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index d7ceb2d1ae82..46dcadf790c2 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -125,9 +125,6 @@ xfs_bui_item_release(
>  	xfs_bui_release(BUI_ITEM(lip));
>  }
>  
> -/*
> - * This is the ops vector shared by all bui log items.
> - */
>  static const struct xfs_item_ops xfs_bui_item_ops = {
>  	.iop_size	= xfs_bui_item_size,
>  	.iop_format	= xfs_bui_item_format,
> @@ -208,9 +205,6 @@ xfs_bud_item_release(
>  	kmem_zone_free(xfs_bud_zone, budp);
>  }
>  
> -/*
> - * This is the ops vector shared by all bud log items.
> - */
>  static const struct xfs_item_ops xfs_bud_item_ops = {
>  	.flags		= XFS_ITEM_RELEASE_ON_COMMIT,
>  	.iop_size	= xfs_bud_item_size,
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 05eefc677cd8..2c7aef61ea92 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -679,9 +679,6 @@ xfs_buf_item_committed(
>  	return lsn;
>  }
>  
> -/*
> - * This is the ops vector shared by all buf log items.
> - */
>  static const struct xfs_item_ops xfs_buf_item_ops = {
>  	.iop_size	= xfs_buf_item_size,
>  	.iop_format	= xfs_buf_item_format,
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index b8fd81641dfc..ade4520d3fdf 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -222,9 +222,6 @@ xfs_qm_dquot_logitem_committing(
>  	return xfs_qm_dquot_logitem_release(lip);
>  }
>  
> -/*
> - * This is the ops vector for dquots
> - */
>  static const struct xfs_item_ops xfs_dquot_item_ops = {
>  	.iop_size	= xfs_qm_dquot_logitem_size,
>  	.iop_format	= xfs_qm_dquot_logitem_format,
> @@ -320,9 +317,6 @@ static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
>  	.iop_committed	= xfs_qm_qoffend_logitem_committed,
>  };
>  
> -/*
> - * This is the ops vector shared by all quotaoff-start log items.
> - */
>  static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
>  	.iop_size	= xfs_qm_qoff_logitem_size,
>  	.iop_format	= xfs_qm_qoff_logitem_format,
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 762eb288dfe8..bb0b1e942d00 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -135,9 +135,6 @@ xfs_efi_item_release(
>  	xfs_efi_release(EFI_ITEM(lip));
>  }
>  
> -/*
> - * This is the ops vector shared by all efi log items.
> - */
>  static const struct xfs_item_ops xfs_efi_item_ops = {
>  	.iop_size	= xfs_efi_item_size,
>  	.iop_format	= xfs_efi_item_format,
> @@ -307,9 +304,6 @@ xfs_efd_item_release(
>  	xfs_efd_item_free(efdp);
>  }
>  
> -/*
> - * This is the ops vector shared by all efd log items.
> - */
>  static const struct xfs_item_ops xfs_efd_item_ops = {
>  	.flags		= XFS_ITEM_RELEASE_ON_COMMIT,
>  	.iop_size	= xfs_efd_item_size,
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index eb9cb04635be..4f1ce50ce323 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -63,9 +63,6 @@ xfs_icreate_item_release(
>  	kmem_zone_free(xfs_icreate_zone, ICR_ITEM(lip));
>  }
>  
> -/*
> - * This is the ops vector shared by all buf log items.
> - */
>  static const struct xfs_item_ops xfs_icreate_item_ops = {
>  	.flags		= XFS_ITEM_RELEASE_ON_COMMIT,
>  	.iop_size	= xfs_icreate_item_size,
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index a00f0b6aecc7..62847e95b399 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -627,9 +627,6 @@ xfs_inode_item_committing(
>  	return xfs_inode_item_release(lip);
>  }
>  
> -/*
> - * This is the ops vector shared by all buf log items.
> - */
>  static const struct xfs_item_ops xfs_inode_item_ops = {
>  	.iop_size	= xfs_inode_item_size,
>  	.iop_format	= xfs_inode_item_format,
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index b4ab71ce39fc..2b2f6e7ad867 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -124,9 +124,6 @@ xfs_cui_item_release(
>  	xfs_cui_release(CUI_ITEM(lip));
>  }
>  
> -/*
> - * This is the ops vector shared by all cui log items.
> - */
>  static const struct xfs_item_ops xfs_cui_item_ops = {
>  	.iop_size	= xfs_cui_item_size,
>  	.iop_format	= xfs_cui_item_format,
> @@ -213,9 +210,6 @@ xfs_cud_item_release(
>  	kmem_zone_free(xfs_cud_zone, cudp);
>  }
>  
> -/*
> - * This is the ops vector shared by all cud log items.
> - */
>  static const struct xfs_item_ops xfs_cud_item_ops = {
>  	.flags		= XFS_ITEM_RELEASE_ON_COMMIT,
>  	.iop_size	= xfs_cud_item_size,
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 1b35b3d38708..dce1357aef88 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -123,9 +123,6 @@ xfs_rui_item_release(
>  	xfs_rui_release(RUI_ITEM(lip));
>  }
>  
> -/*
> - * This is the ops vector shared by all rui log items.
> - */
>  static const struct xfs_item_ops xfs_rui_item_ops = {
>  	.iop_size	= xfs_rui_item_size,
>  	.iop_format	= xfs_rui_item_format,
> @@ -234,9 +231,6 @@ xfs_rud_item_release(
>  	kmem_zone_free(xfs_rud_zone, rudp);
>  }
>  
> -/*
> - * This is the ops vector shared by all rud log items.
> - */
>  static const struct xfs_item_ops xfs_rud_item_ops = {
>  	.flags		= XFS_ITEM_RELEASE_ON_COMMIT,
>  	.iop_size	= xfs_rud_item_size,
> -- 
> 2.20.1
> 
