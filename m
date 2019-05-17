Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 086072197B
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 16:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbfEQOEX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 10:04:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728535AbfEQOEW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 10:04:22 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DB54E2E95B6;
        Fri, 17 May 2019 14:04:22 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 86F5E60852;
        Fri, 17 May 2019 14:04:22 +0000 (UTC)
Date:   Fri, 17 May 2019 10:04:20 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/20] xfs: fix a trivial comment typo in the
 xfs_trans_committed_bulk
Message-ID: <20190517140420.GA7888@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-2-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 17 May 2019 14:04:22 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:00AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_trans.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 912b42f5fe4a..19f91312561a 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -815,7 +815,7 @@ xfs_log_item_batch_insert(
>   *
>   * If we are called with the aborted flag set, it is because a log write during
>   * a CIL checkpoint commit has failed. In this case, all the items in the
> - * checkpoint have already gone through iop_commited and iop_unlock, which
> + * checkpoint have already gone through iop_committed and iop_unlock, which
>   * means that checkpoint commit abort handling is treated exactly the same
>   * as an iclog write error even though we haven't started any IO yet. Hence in
>   * this case all we need to do is iop_committed processing, followed by an
> -- 
> 2.20.1
> 
