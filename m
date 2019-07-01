Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FBD21992
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 16:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbfEQOIo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 10:08:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14423 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbfEQOIo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 10:08:44 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 19B9181114;
        Fri, 17 May 2019 14:08:44 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B4CB05D6A9;
        Fri, 17 May 2019 14:08:43 +0000 (UTC)
Date:   Fri, 17 May 2019 10:08:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/20] xfs: remove the iop_push implementation for quota
 off items
Message-ID: <20190517140841.GE7888@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-6-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 17 May 2019 14:08:44 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:04AM +0200, Christoph Hellwig wrote:
> If we want to push the log to make progress on the items we'd need to
> return XFS_ITEM_PINNED instead of XFS_ITEM_LOCKED.  Removing the
> method will do exactly that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
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

Hmm, this one is a bit interesting because it's a potential change in
behavior and I'm not sure the comment above accurately reflects the
situation. In xfs_qm_scall_quotaoff(), we log the first quotaoff item
and commit it synchronously. I believe this means it immediately goes
into the AIL. Then we have to iterate inodes to drop all dquot
references and purge the dquot cache, which can do I/O by writing back
dquot bufs before we eventually log the quotaoff_end item. All in all
this can take a bit of time (and we have test scenarios that reproduce
quotaoff log deadlocks already).

I think this change can cause AIL processing concurrent to a quotaoff in
progress to potentially force the log on every pass. I would not expect
that to have a positive effect because a log force doesn't actually help
the quotaoff progress until the quotaoff_end is committed, and that
already occurs synchronously as well. I don't think it's wise to change
behavior here, at least not without some testing and analysis around how
this impacts those already somewhat flakey quota off operations.

Brian

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
