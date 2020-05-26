Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A861B1C4D08
	for <lists+linux-xfs@lfdr.de>; Tue,  5 May 2020 06:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725320AbgEEELM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 5 May 2020 00:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgEEELM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 00:11:12 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1D7C061A0F
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 21:11:12 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o18so452734pgg.8
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 21:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F9rUnjMqfdpFH+/Ax63X6AAGxNnVwofkqUQIxeDpPk4=;
        b=GLhgV+995j5rI6TmBn+pmVUQeJXTUfTdxTccQTH4VOiGOtxj770rajk+U0R/bcUgBj
         nYf18+TjWTK7oY4RMO8slLxhXtSJ5feWCOnInyzlnBJWfptglQoFdTYaDfsGUtpbGsNa
         3Vg5IQWJIjV+nvmkCXmE3SG2W21tytvlvp1/mm2r8MMXHCbw8DenguHAeTbPDtY6VxQW
         1uKNC6QbWdYka6Qvs7c7BQM3WSLgC5Mw0yEaN1XBwcgwfcjVrMXT0536U7U7CdEQPMCU
         9qin+YzD54A9/PXadX+TdYpJ+uKtfZlUsGIc8yaBycmnHKZndjOyVQafR9T9ZReHEVj2
         +Gyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F9rUnjMqfdpFH+/Ax63X6AAGxNnVwofkqUQIxeDpPk4=;
        b=CDlsZHJgGvQdHGL71GPRHQzLFiNfhao0QcfsWgmROKkmB35Rrnx8cXwWLPJSnt6W2/
         nIaVWUBpvlWJ1eaEX371kHE0F6Q3BT2nWl6v5vdk6tc+FUy2AT3kuMHVi/nX3PlmGXtp
         hnXq1dViPBmcF5EGZI3S1ebdp8s+k9qci2gksVZakmo3c4OSxNTDGZdg2zHIwuie0lUi
         BN+M7Kj1xBosICEoeNp4BI1E/bx8Y12FS0rHxIMPg662AttoI8vG+duYifP0iP09uC5q
         Dr3m0KOd6478hSkru/7JknYUIR+FXKcjH0+GkZCxgqg5g9hT8tFt/fREt7pxG2xQ9A7R
         OIZg==
X-Gm-Message-State: AGi0Pub88ATarI8B9/pTZkp/wCiiaBtIL8myupz9I5zUXuG0GgugH1f7
        ZTrrsmWl93+2LO155l8dJjvA2ZRCMbM=
X-Google-Smtp-Source: APiQypLsu97OrsaEqx1CFfIsZgulN0quTOX1kc75MGTWs2EwPFdqq0kL/mDcVVz+vfY/6q9Whk6BUA==
X-Received: by 2002:a63:1d4a:: with SMTP id d10mr1405111pgm.188.1588651871633;
        Mon, 04 May 2020 21:11:11 -0700 (PDT)
Received: from garuda.localnet ([122.171.152.206])
        by smtp.gmail.com with ESMTPSA id w11sm485483pgj.4.2020.05.04.21.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 21:11:10 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/28] xfs: refactor log recovery item sorting into a generic dispatch structure
Date:   Tue, 05 May 2020 09:41:08 +0530
Message-ID: <93453827.lAAUMYVWGY@garuda>
In-Reply-To: <158864104502.182683.672673211897001126.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864104502.182683.672673211897001126.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:40:45 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a generic dispatch structure to delegate recovery of different
> log item types into various code modules.  This will enable us to move
> code specific to a particular log item type out of xfs_log_recover.c and
> into the log item source.
> 
> The first operation we virtualize is the log item sorting.
>

The sorted list order is the maintained as it was done before.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/Makefile                 |    3 +
>  fs/xfs/libxfs/xfs_log_recover.h |   45 ++++++++++++++++++-
>  fs/xfs/xfs_bmap_item.c          |    9 ++++
>  fs/xfs/xfs_buf_item_recover.c   |   38 ++++++++++++++++
>  fs/xfs/xfs_dquot_item_recover.c |   29 ++++++++++++
>  fs/xfs/xfs_extfree_item.c       |    9 ++++
>  fs/xfs/xfs_icreate_item.c       |   20 ++++++++
>  fs/xfs/xfs_inode_item_recover.c |   26 +++++++++++
>  fs/xfs/xfs_log_recover.c        |   93 +++++++++++++++++++++++----------------
>  fs/xfs/xfs_refcount_item.c      |    9 ++++
>  fs/xfs/xfs_rmap_item.c          |    9 ++++
>  11 files changed, 251 insertions(+), 39 deletions(-)
>  create mode 100644 fs/xfs/xfs_buf_item_recover.c
>  create mode 100644 fs/xfs/xfs_dquot_item_recover.c
>  create mode 100644 fs/xfs/xfs_inode_item_recover.c
> 
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index ff94fb90a2ee..04611a1068b4 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -99,9 +99,12 @@ xfs-y				+= xfs_log.o \
>  				   xfs_log_cil.o \
>  				   xfs_bmap_item.o \
>  				   xfs_buf_item.o \
> +				   xfs_buf_item_recover.o \
> +				   xfs_dquot_item_recover.o \
>  				   xfs_extfree_item.o \
>  				   xfs_icreate_item.o \
>  				   xfs_inode_item.o \
> +				   xfs_inode_item_recover.o \
>  				   xfs_refcount_item.o \
>  				   xfs_rmap_item.o \
>  				   xfs_log_recover.o \
> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index 148e0cb5d379..271b0741f1e1 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -6,6 +6,47 @@
>  #ifndef	__XFS_LOG_RECOVER_H__
>  #define __XFS_LOG_RECOVER_H__
>  
> +/*
> + * Each log item type (XFS_LI_*) gets its own xlog_recover_item_ops to
> + * define how recovery should work for that type of log item.
> + */
> +struct xlog_recover_item;
> +
> +/* Sorting hat for log items as they're read in. */
> +enum xlog_recover_reorder {
> +	XLOG_REORDER_BUFFER_LIST,
> +	XLOG_REORDER_ITEM_LIST,
> +	XLOG_REORDER_INODE_BUFFER_LIST,
> +	XLOG_REORDER_CANCEL_LIST,
> +};
> +
> +struct xlog_recover_item_ops {
> +	uint16_t	item_type;	/* XFS_LI_* type code. */
> +
> +	/*
> +	 * Help sort recovered log items into the order required to replay them
> +	 * correctly.  Log item types that always use XLOG_REORDER_ITEM_LIST do
> +	 * not have to supply a function here.  See the comment preceding
> +	 * xlog_recover_reorder_trans for more details about what the return
> +	 * values mean.
> +	 */
> +	enum xlog_recover_reorder (*reorder)(struct xlog_recover_item *item);
> +};
> +
> +extern const struct xlog_recover_item_ops xlog_icreate_item_ops;
> +extern const struct xlog_recover_item_ops xlog_buf_item_ops;
> +extern const struct xlog_recover_item_ops xlog_inode_item_ops;
> +extern const struct xlog_recover_item_ops xlog_dquot_item_ops;
> +extern const struct xlog_recover_item_ops xlog_quotaoff_item_ops;
> +extern const struct xlog_recover_item_ops xlog_bmap_intent_item_ops;
> +extern const struct xlog_recover_item_ops xlog_bmap_done_item_ops;
> +extern const struct xlog_recover_item_ops xlog_extfree_intent_item_ops;
> +extern const struct xlog_recover_item_ops xlog_extfree_done_item_ops;
> +extern const struct xlog_recover_item_ops xlog_rmap_intent_item_ops;
> +extern const struct xlog_recover_item_ops xlog_rmap_done_item_ops;
> +extern const struct xlog_recover_item_ops xlog_refcount_intent_item_ops;
> +extern const struct xlog_recover_item_ops xlog_refcount_done_item_ops;
> +
>  /*
>   * Macros, structures, prototypes for internal log manager use.
>   */
> @@ -24,10 +65,10 @@
>   */
>  struct xlog_recover_item {
>  	struct list_head	ri_list;
> -	int			ri_type;
>  	int			ri_cnt;	/* count of regions found */
>  	int			ri_total;	/* total regions */
> -	xfs_log_iovec_t		*ri_buf;	/* ptr to regions buffer */
> +	struct xfs_log_iovec	*ri_buf;	/* ptr to regions buffer */
> +	const struct xlog_recover_item_ops *ri_ops;
>  };
>  
>  struct xlog_recover {
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 7768fb2b7135..42354403fec7 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -22,6 +22,7 @@
>  #include "xfs_bmap_btree.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_error.h"
> +#include "xfs_log_recover.h"
>  
>  kmem_zone_t	*xfs_bui_zone;
>  kmem_zone_t	*xfs_bud_zone;
> @@ -557,3 +558,11 @@ xfs_bui_recover(
>  	}
>  	return error;
>  }
> +
> +const struct xlog_recover_item_ops xlog_bmap_intent_item_ops = {
> +	.item_type		= XFS_LI_BUI,
> +};
> +
> +const struct xlog_recover_item_ops xlog_bmap_done_item_ops = {
> +	.item_type		= XFS_LI_BUD,
> +};
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> new file mode 100644
> index 000000000000..def19025512e
> --- /dev/null
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -0,0 +1,38 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2000-2006 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_bit.h"
> +#include "xfs_mount.h"
> +#include "xfs_trans.h"
> +#include "xfs_buf_item.h"
> +#include "xfs_trans_priv.h"
> +#include "xfs_trace.h"
> +#include "xfs_log.h"
> +#include "xfs_log_priv.h"
> +#include "xfs_log_recover.h"
> +
> +STATIC enum xlog_recover_reorder
> +xlog_recover_buf_reorder(
> +	struct xlog_recover_item	*item)
> +{
> +	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
> +
> +	if (buf_f->blf_flags & XFS_BLF_CANCEL)
> +		return XLOG_REORDER_CANCEL_LIST;
> +	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
> +		return XLOG_REORDER_INODE_BUFFER_LIST;
> +	return XLOG_REORDER_BUFFER_LIST;
> +}
> +
> +const struct xlog_recover_item_ops xlog_buf_item_ops = {
> +	.item_type		= XFS_LI_BUF,
> +	.reorder		= xlog_recover_buf_reorder,
> +};
> diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
> new file mode 100644
> index 000000000000..78fe644e9907
> --- /dev/null
> +++ b/fs/xfs/xfs_dquot_item_recover.c
> @@ -0,0 +1,29 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2000-2006 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_inode.h"
> +#include "xfs_quota.h"
> +#include "xfs_trans.h"
> +#include "xfs_buf_item.h"
> +#include "xfs_trans_priv.h"
> +#include "xfs_qm.h"
> +#include "xfs_log.h"
> +#include "xfs_log_priv.h"
> +#include "xfs_log_recover.h"
> +
> +const struct xlog_recover_item_ops xlog_dquot_item_ops = {
> +	.item_type		= XFS_LI_DQUOT,
> +};
> +
> +const struct xlog_recover_item_ops xlog_quotaoff_item_ops = {
> +	.item_type		= XFS_LI_QUOTAOFF,
> +};
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index c8cde4122a0f..b43bb087aef3 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -22,6 +22,7 @@
>  #include "xfs_bmap.h"
>  #include "xfs_trace.h"
>  #include "xfs_error.h"
> +#include "xfs_log_recover.h"
>  
>  kmem_zone_t	*xfs_efi_zone;
>  kmem_zone_t	*xfs_efd_zone;
> @@ -644,3 +645,11 @@ xfs_efi_recover(
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> +
> +const struct xlog_recover_item_ops xlog_extfree_intent_item_ops = {
> +	.item_type		= XFS_LI_EFI,
> +};
> +
> +const struct xlog_recover_item_ops xlog_extfree_done_item_ops = {
> +	.item_type		= XFS_LI_EFD,
> +};
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 490fee22b878..366c1e722a29 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -11,6 +11,8 @@
>  #include "xfs_trans_priv.h"
>  #include "xfs_icreate_item.h"
>  #include "xfs_log.h"
> +#include "xfs_log_priv.h"
> +#include "xfs_log_recover.h"
>  
>  kmem_zone_t	*xfs_icreate_zone;		/* inode create item zone */
>  
> @@ -107,3 +109,21 @@ xfs_icreate_log(
>  	tp->t_flags |= XFS_TRANS_DIRTY;
>  	set_bit(XFS_LI_DIRTY, &icp->ic_item.li_flags);
>  }
> +
> +static enum xlog_recover_reorder
> +xlog_recover_icreate_reorder(
> +		struct xlog_recover_item *item)
> +{
> +	/*
> +	 * Inode allocation buffers must be replayed before subsequent inode
> +	 * items try to modify those buffers.  ICREATE items are the logical
> +	 * equivalent of logging a newly initialized inode buffer, so recover
> +	 * these at the same time that we recover logged buffers.
> +	 */
> +	return XLOG_REORDER_BUFFER_LIST;
> +}
> +
> +const struct xlog_recover_item_ops xlog_icreate_item_ops = {
> +	.item_type		= XFS_LI_ICREATE,
> +	.reorder		= xlog_recover_icreate_reorder,
> +};
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> new file mode 100644
> index 000000000000..b19a151efb10
> --- /dev/null
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -0,0 +1,26 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2000-2006 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_inode.h"
> +#include "xfs_trans.h"
> +#include "xfs_inode_item.h"
> +#include "xfs_trace.h"
> +#include "xfs_trans_priv.h"
> +#include "xfs_buf_item.h"
> +#include "xfs_log.h"
> +#include "xfs_error.h"
> +#include "xfs_log_priv.h"
> +#include "xfs_log_recover.h"
> +
> +const struct xlog_recover_item_ops xlog_inode_item_ops = {
> +	.item_type		= XFS_LI_INODE,
> +};
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index c2c06f70fb8a..0ef0d81fd190 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1785,6 +1785,34 @@ xlog_clear_stale_blocks(
>   *
>   ******************************************************************************
>   */
> +static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
> +	&xlog_buf_item_ops,
> +	&xlog_inode_item_ops,
> +	&xlog_dquot_item_ops,
> +	&xlog_quotaoff_item_ops,
> +	&xlog_icreate_item_ops,
> +	&xlog_extfree_intent_item_ops,
> +	&xlog_extfree_done_item_ops,
> +	&xlog_rmap_intent_item_ops,
> +	&xlog_rmap_done_item_ops,
> +	&xlog_refcount_intent_item_ops,
> +	&xlog_refcount_done_item_ops,
> +	&xlog_bmap_intent_item_ops,
> +	&xlog_bmap_done_item_ops,
> +};
> +
> +static const struct xlog_recover_item_ops *
> +xlog_find_item_ops(
> +	struct xlog_recover_item		*item)
> +{
> +	unsigned int				i;
> +
> +	for (i = 0; i < ARRAY_SIZE(xlog_recover_item_ops); i++)
> +		if (ITEM_TYPE(item) == xlog_recover_item_ops[i]->item_type)
> +			return xlog_recover_item_ops[i];
> +
> +	return NULL;
> +}
>  
>  /*
>   * Sort the log items in the transaction.
> @@ -1851,41 +1879,10 @@ xlog_recover_reorder_trans(
>  
>  	list_splice_init(&trans->r_itemq, &sort_list);
>  	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
> -		xfs_buf_log_format_t	*buf_f = item->ri_buf[0].i_addr;
> +		enum xlog_recover_reorder	fate = XLOG_REORDER_ITEM_LIST;
>  
> -		switch (ITEM_TYPE(item)) {
> -		case XFS_LI_ICREATE:
> -			list_move_tail(&item->ri_list, &buffer_list);
> -			break;
> -		case XFS_LI_BUF:
> -			if (buf_f->blf_flags & XFS_BLF_CANCEL) {
> -				trace_xfs_log_recover_item_reorder_head(log,
> -							trans, item, pass);
> -				list_move(&item->ri_list, &cancel_list);
> -				break;
> -			}
> -			if (buf_f->blf_flags & XFS_BLF_INODE_BUF) {
> -				list_move(&item->ri_list, &inode_buffer_list);
> -				break;
> -			}
> -			list_move_tail(&item->ri_list, &buffer_list);
> -			break;
> -		case XFS_LI_INODE:
> -		case XFS_LI_DQUOT:
> -		case XFS_LI_QUOTAOFF:
> -		case XFS_LI_EFD:
> -		case XFS_LI_EFI:
> -		case XFS_LI_RUI:
> -		case XFS_LI_RUD:
> -		case XFS_LI_CUI:
> -		case XFS_LI_CUD:
> -		case XFS_LI_BUI:
> -		case XFS_LI_BUD:
> -			trace_xfs_log_recover_item_reorder_tail(log,
> -							trans, item, pass);
> -			list_move_tail(&item->ri_list, &item_list);
> -			break;
> -		default:
> +		item->ri_ops = xlog_find_item_ops(item);
> +		if (!item->ri_ops) {
>  			xfs_warn(log->l_mp,
>  				"%s: unrecognized type of log operation (%d)",
>  				__func__, ITEM_TYPE(item));
> @@ -1896,11 +1893,33 @@ xlog_recover_reorder_trans(
>  			 */
>  			if (!list_empty(&sort_list))
>  				list_splice_init(&sort_list, &trans->r_itemq);
> -			error = -EIO;
> -			goto out;
> +			error = -EFSCORRUPTED;
> +			break;
> +		}
> +
> +		if (item->ri_ops->reorder)
> +			fate = item->ri_ops->reorder(item);
> +
> +		switch (fate) {
> +		case XLOG_REORDER_BUFFER_LIST:
> +			list_move_tail(&item->ri_list, &buffer_list);
> +			break;
> +		case XLOG_REORDER_CANCEL_LIST:
> +			trace_xfs_log_recover_item_reorder_head(log,
> +					trans, item, pass);
> +			list_move(&item->ri_list, &cancel_list);
> +			break;
> +		case XLOG_REORDER_INODE_BUFFER_LIST:
> +			list_move(&item->ri_list, &inode_buffer_list);
> +			break;
> +		case XLOG_REORDER_ITEM_LIST:
> +			trace_xfs_log_recover_item_reorder_tail(log,
> +							trans, item, pass);
> +			list_move_tail(&item->ri_list, &item_list);
> +			break;
>  		}
>  	}
> -out:
> +
>  	ASSERT(list_empty(&sort_list));
>  	if (!list_empty(&buffer_list))
>  		list_splice(&buffer_list, &trans->r_itemq);
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 0316eab2fc35..0e8e8bab4344 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -18,6 +18,7 @@
>  #include "xfs_log.h"
>  #include "xfs_refcount.h"
>  #include "xfs_error.h"
> +#include "xfs_log_recover.h"
>  
>  kmem_zone_t	*xfs_cui_zone;
>  kmem_zone_t	*xfs_cud_zone;
> @@ -570,3 +571,11 @@ xfs_cui_recover(
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> +
> +const struct xlog_recover_item_ops xlog_refcount_intent_item_ops = {
> +	.item_type		= XFS_LI_CUI,
> +};
> +
> +const struct xlog_recover_item_ops xlog_refcount_done_item_ops = {
> +	.item_type		= XFS_LI_CUD,
> +};
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index e3bba2aec868..3eb538674cb9 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -18,6 +18,7 @@
>  #include "xfs_log.h"
>  #include "xfs_rmap.h"
>  #include "xfs_error.h"
> +#include "xfs_log_recover.h"
>  
>  kmem_zone_t	*xfs_rui_zone;
>  kmem_zone_t	*xfs_rud_zone;
> @@ -585,3 +586,11 @@ xfs_rui_recover(
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> +
> +const struct xlog_recover_item_ops xlog_rmap_intent_item_ops = {
> +	.item_type		= XFS_LI_RUI,
> +};
> +
> +const struct xlog_recover_item_ops xlog_rmap_done_item_ops = {
> +	.item_type		= XFS_LI_RUD,
> +};
> 
> 


-- 
chandan



