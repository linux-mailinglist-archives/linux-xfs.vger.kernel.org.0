Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD0B34CFC
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 18:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfFDQMn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 12:12:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38146 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728166AbfFDQMn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Jun 2019 12:12:43 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EDB95C1EB1F1;
        Tue,  4 Jun 2019 16:12:42 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8162D5C26B;
        Tue,  4 Jun 2019 16:12:42 +0000 (UTC)
Date:   Tue, 4 Jun 2019 12:12:40 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 06/20] xfs: don't use REQ_PREFLUSH for split log writes
Message-ID: <20190604161240.GA44563@bfoster>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603172945.13819-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603172945.13819-7-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 04 Jun 2019 16:12:43 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 07:29:31PM +0200, Christoph Hellwig wrote:
> If we have to split a log write because it wraps the end of the log we
> can't just use REQ_PREFLUSH to flush before the first log write,
> as the writes might get reordered somewhere in the I/O stack.  Issue
> a manual flush in that case so that the ordering of the two log I/Os
> doesn't matter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 3b82ca8ac9c8..646a190e5730 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1941,7 +1941,7 @@ xlog_sync(
>  	 * synchronously here; for an internal log we can simply use the block
>  	 * layer state machine for preflushes.
>  	 */
> -	if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp)
> +	if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp || split)
>  		xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);

I'm curious if this is really necessary. The log record isn't
recoverable until it's complete on disk (and thus the tail LSN stamped
in the record header not relevant). As long as the cache flushes before
the record is completely written, what difference does it make if it was
made up of two out of order I/Os?

Granted log wrapping is not a frequent operation, but the explicit flush
is a synchronous operation in the log force path whereas the flush flag
isn't.

Brian

>  	else
>  		bp->b_flags |= XBF_FLUSH;
> -- 
> 2.20.1
> 
