Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8404B21CD8
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 19:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbfEQRuh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 13:50:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60610 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbfEQRuh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 13:50:37 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6C312307BA56;
        Fri, 17 May 2019 17:50:37 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 154E510027B7;
        Fri, 17 May 2019 17:50:37 +0000 (UTC)
Date:   Fri, 17 May 2019 13:50:35 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/20] xfs: don't cast inode_log_items to get the log_item
Message-ID: <20190517175035.GI7888@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-10-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 17 May 2019 17:50:37 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:08AM +0200, Christoph Hellwig wrote:
> The cast is not type safe, and we can just dereference the first
> member instead to start with.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 71d216cf6f87..419eae485ff3 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -485,7 +485,7 @@ xfs_lock_inodes(
>  		 */
>  		if (!try_lock) {
>  			for (j = (i - 1); j >= 0 && !try_lock; j--) {
> -				lp = (xfs_log_item_t *)ips[j]->i_itemp;
> +				lp = &ips[j]->i_itemp->ili_item;
>  				if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags))
>  					try_lock++;
>  			}
> @@ -585,7 +585,7 @@ xfs_lock_two_inodes(
>  	 * the second lock. If we can't get it, we must release the first one
>  	 * and try again.
>  	 */
> -	lp = (xfs_log_item_t *)ip0->i_itemp;
> +	lp = &ip0->i_itemp->ili_item;
>  	if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags)) {
>  		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(ip1_mode, 1))) {
>  			xfs_iunlock(ip0, ip0_mode);
> -- 
> 2.20.1
> 
