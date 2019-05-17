Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7D5C2197F
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 16:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbfEQOEu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 10:04:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728456AbfEQOEu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 10:04:50 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 39E13309264B;
        Fri, 17 May 2019 14:04:50 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D76976085B;
        Fri, 17 May 2019 14:04:49 +0000 (UTC)
Date:   Fri, 17 May 2019 10:04:48 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/20] xfs: stop using XFS_LI_ABORTED as a parameter flag
Message-ID: <20190517140447.GB7888@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-3-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 17 May 2019 14:04:50 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:01AM +0200, Christoph Hellwig wrote:
> Just pass a straight bool aborted instead of abusing XFS_LI_ABORTED as a
> flag in function parameters.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c     | 25 +++++++++++--------------
>  fs/xfs/xfs_log.h     |  2 +-
>  fs/xfs/xfs_log_cil.c |  4 ++--
>  3 files changed, 14 insertions(+), 17 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 5e595948bc5a..1b54002d3874 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -577,7 +577,7 @@ xlog_discard_busy_extents(
>  static void
>  xlog_cil_committed(
>  	void	*args,
> -	int	abort)
> +	bool	abort)
>  {

Just FYI.. this function passes abort to xfs_trans_committed_bulk(),
which also looks like it could be changed from int to bool. That aside:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	struct xfs_cil_ctx	*ctx = args;
>  	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
> @@ -864,7 +864,7 @@ xlog_cil_push(
>  out_abort_free_ticket:
>  	xfs_log_ticket_put(tic);
>  out_abort:
> -	xlog_cil_committed(ctx, XFS_LI_ABORTED);
> +	xlog_cil_committed(ctx, true);
>  	return -EIO;
>  }
>  
> -- 
> 2.20.1
> 
