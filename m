Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E32D31F9AD
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Feb 2021 14:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhBSNL2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 19 Feb 2021 08:11:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36789 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229681AbhBSNL2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Feb 2021 08:11:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613740200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mdyMWbI4982Gd5cuKi3C09yDvIgzrqTdI45V45i3pKE=;
        b=iwCuKzKPa/fOPGfFDdaJCc3iKCqMhs7nCu4QjjEneGGA5VJKNvo1gPkUsKEJeUZFtjNTX3
        uBRyAGFqVvVwgErheQ4RGN3RLrIyfNBiE1lalYyQdsjriDpmMK5Rmg3UUBQZoU3SEx0q+k
        HzQhwGfMeTxbcHPAZ8GcNbuC0BoL9Pg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-2X9inTheN_OcStp4oVTrEg-1; Fri, 19 Feb 2021 08:09:56 -0500
X-MC-Unique: 2X9inTheN_OcStp4oVTrEg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B19EA180483F;
        Fri, 19 Feb 2021 13:09:55 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2944B5C1BB;
        Fri, 19 Feb 2021 13:09:55 +0000 (UTC)
Date:   Fri, 19 Feb 2021 08:09:53 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't nest transactions when scanning for eofblocks
Message-ID: <20210219130953.GB757814@bfoster>
References: <20210219042940.GB7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219042940.GB7193@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 08:29:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Brian Foster reported a lockdep warning on xfs/167:
> 
> ============================================
> WARNING: possible recursive locking detected
> 5.11.0-rc4 #35 Tainted: G        W I
> --------------------------------------------
> fsstress/17733 is trying to acquire lock:
> ffff8e0fd1d90650 (sb_internal){++++}-{0:0}, at: xfs_free_eofblocks+0x104/0x1d0 [xfs]
> 
> but task is already holding lock:
> ffff8e0fd1d90650 (sb_internal){++++}-{0:0}, at: xfs_trans_alloc_inode+0x5f/0x160 [xfs]
> 
> stack backtrace:
> CPU: 38 PID: 17733 Comm: fsstress Tainted: G        W I       5.11.0-rc4 #35
> Hardware name: Dell Inc. PowerEdge R740/01KPX8, BIOS 1.6.11 11/20/2018
> Call Trace:
>  dump_stack+0x8b/0xb0
>  __lock_acquire.cold+0x159/0x2ab
>  lock_acquire+0x116/0x370
>  xfs_trans_alloc+0x1ad/0x310 [xfs]
>  xfs_free_eofblocks+0x104/0x1d0 [xfs]
>  xfs_blockgc_scan_inode+0x24/0x60 [xfs]
>  xfs_inode_walk_ag+0x202/0x4b0 [xfs]
>  xfs_inode_walk+0x66/0xc0 [xfs]
>  xfs_trans_alloc+0x160/0x310 [xfs]
>  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
>  xfs_alloc_file_space+0x105/0x300 [xfs]
>  xfs_file_fallocate+0x270/0x460 [xfs]
>  vfs_fallocate+0x14d/0x3d0
>  __x64_sys_fallocate+0x3e/0x70
>  do_syscall_64+0x33/0x40
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The cause of this is the new code that spurs a scan to garbage collect
> speculative preallocations if we fail to reserve enough blocks while
> allocating a transaction.  While the warning itself is a fairly benign
> lockdep complaint, it does bring to light a potential livelock.
> 
> Specifically, when we kick off that scan, we're still holding onto the
> transaction's log reservation.  If the blockgc scan finds something to
> free, it will need its own transaction, which means that it can block on
> the log grant.  This means that if there are enough writer threads to
> take all the log reservation space with that first transaction, the
> second reservation attempts will all block on log space that cannot be
> freed, leading to a livelock.
> 

The text above around a prospective livelock doesn't seem accurate.
Otherwise the code looks fine to me. I don't have a preference between
this patch or the other one...

Brian

> Fix this by freeing the transaction and jumping back to xfs_trans_alloc
> like this patch in the V4 submission[1].
> 
> [1] https://lore.kernel.org/linux-xfs/161142798066.2171939.9311024588681972086.stgit@magnolia/
> 
> Fixes: a1a7d05a0576 ("xfs: flush speculative space allocations when we run out of space")
> Reported-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_trans.c |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 44f72c09c203..377f3961d7ed 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -260,6 +260,7 @@ xfs_trans_alloc(
>  	struct xfs_trans	**tpp)
>  {
>  	struct xfs_trans	*tp;
> +	bool			want_retry = true;
>  	int			error;
>  
>  	/*
> @@ -267,6 +268,7 @@ xfs_trans_alloc(
>  	 * GFP_NOFS allocation context so that we avoid lockdep false positives
>  	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
>  	 */
> +retry:
>  	tp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
>  	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
>  		sb_start_intwrite(mp->m_super);
> @@ -289,7 +291,9 @@ xfs_trans_alloc(
>  	tp->t_firstblock = NULLFSBLOCK;
>  
>  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> -	if (error == -ENOSPC) {
> +	if (error == -ENOSPC && want_retry) {
> +		xfs_trans_cancel(tp);
> +
>  		/*
>  		 * We weren't able to reserve enough space for the transaction.
>  		 * Flush the other speculative space allocations to free space.
> @@ -297,8 +301,11 @@ xfs_trans_alloc(
>  		 * other locks.
>  		 */
>  		error = xfs_blockgc_free_space(mp, NULL);
> -		if (!error)
> -			error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> +		if (error)
> +			return error;
> +
> +		want_retry = false;
> +		goto retry;
>  	}
>  	if (error) {
>  		xfs_trans_cancel(tp);
> 

