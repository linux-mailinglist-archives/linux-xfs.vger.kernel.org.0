Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E27C84612C
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Jun 2019 16:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbfFNOnf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Jun 2019 10:43:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53558 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbfFNOne (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jun 2019 10:43:34 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A4A1630C34CA;
        Fri, 14 Jun 2019 14:43:34 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EBBF17983;
        Fri, 14 Jun 2019 14:43:34 +0000 (UTC)
Date:   Fri, 14 Jun 2019 10:43:32 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/20] xfs: remove the iop_push implementation for quota
 off items
Message-ID: <20190614144332.GH26586@bfoster>
References: <20190613180300.30447-1-hch@lst.de>
 <20190613180300.30447-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613180300.30447-6-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 14 Jun 2019 14:43:34 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 13, 2019 at 08:02:45PM +0200, Christoph Hellwig wrote:
> If we want to push the log to make progress on the items we'd need to
> return XFS_ITEM_PINNED instead of XFS_ITEM_LOCKED.  Removing the
> method will do exactly that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Wasn't this one supposed to be dropped?

Brian

>  fs/xfs/xfs_dquot_item.c | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index 486eea151fdb..a61a8a770d7f 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -288,18 +288,6 @@ xfs_qm_qoff_logitem_format(
>  	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_qoff_logitem));
>  }
>  
> -/*
> - * There isn't much you can do to push a quotaoff item.  It is simply
> - * stuck waiting for the log to be flushed to disk.
> - */
> -STATIC uint
> -xfs_qm_qoff_logitem_push(
> -	struct xfs_log_item	*lip,
> -	struct list_head	*buffer_list)
> -{
> -	return XFS_ITEM_LOCKED;
> -}
> -
>  STATIC xfs_lsn_t
>  xfs_qm_qoffend_logitem_committed(
>  	struct xfs_log_item	*lip,
> @@ -327,7 +315,6 @@ static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
>  	.iop_size	= xfs_qm_qoff_logitem_size,
>  	.iop_format	= xfs_qm_qoff_logitem_format,
>  	.iop_committed	= xfs_qm_qoffend_logitem_committed,
> -	.iop_push	= xfs_qm_qoff_logitem_push,
>  };
>  
>  /*
> @@ -336,7 +323,6 @@ static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
>  static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
>  	.iop_size	= xfs_qm_qoff_logitem_size,
>  	.iop_format	= xfs_qm_qoff_logitem_format,
> -	.iop_push	= xfs_qm_qoff_logitem_push,
>  };
>  
>  /*
> -- 
> 2.20.1
> 
