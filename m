Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE4F730DA1
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Jun 2023 05:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237861AbjFODke (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Jun 2023 23:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237917AbjFODkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2023 23:40:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF2B2120
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 20:40:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD6C761AFD
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 03:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38276C433C0;
        Thu, 15 Jun 2023 03:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686800429;
        bh=3Oeh5OdRaxdvtNtILh3Z6iPuvnrkSjTLkN0sUliyRiE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C90yiFxqUOThIfTNJfejvoUi/75ybL9XxuKLtAVZrmBAE/uPgiWQnWIMjBLJhHejj
         cyazhCbgpig34w+rahnyB69M2EPgSqpQDo49kTPRKyOzgpH/lwr6HDxyZ3BLJq/OmO
         MJP90y7UGGW7VfRs6Dvte9qlBkzL9xMLcCkVCxs7F+qeI2fhXKo9La5In47hDwbQez
         R1kWAdKiFJ+Gjj5tMW9xGoAzPBIN70vrBmHTiLfUPcXzQJI03QxiChz1Cqq/Kd5vTQ
         5LrrEftI+GZ/5g0g+z5iMdOLv3rYfUqE+7PGvMWT22f7x9TxkIBPqL0NajW330+L6r
         y49YExn9+m3rw==
Date:   Wed, 14 Jun 2023 20:40:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        wen.gang.wang@oracle.com
Subject: Re: [PATCH 3/3] xfs: don't block in busy flushing when freeing
 extents
Message-ID: <20230615034028.GN11441@frogsfrogsfrogs>
References: <20230615014201.3171380-1-david@fromorbit.com>
 <20230615014201.3171380-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615014201.3171380-4-david@fromorbit.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 15, 2023 at 11:42:01AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If the current transaction holds a busy extent and we are trying to
> allocate a new extent to fix up the free list, we can deadlock if
> the AG is entirely empty except for the busy extent held by the
> transaction.
> 
> This can occur at runtime processing an XEFI with multiple extents
> in this path:
> 
> __schedule+0x22f at ffffffff81f75e8f
> schedule+0x46 at ffffffff81f76366
> xfs_extent_busy_flush+0x69 at ffffffff81477d99
> xfs_alloc_ag_vextent_size+0x16a at ffffffff8141711a
> xfs_alloc_ag_vextent+0x19b at ffffffff81417edb
> xfs_alloc_fix_freelist+0x22f at ffffffff8141896f
> xfs_free_extent_fix_freelist+0x6a at ffffffff8141939a
> __xfs_free_extent+0x99 at ffffffff81419499
> xfs_trans_free_extent+0x3e at ffffffff814a6fee
> xfs_extent_free_finish_item+0x24 at ffffffff814a70d4
> xfs_defer_finish_noroll+0x1f7 at ffffffff81441407
> xfs_defer_finish+0x11 at ffffffff814417e1
> xfs_itruncate_extents_flags+0x13d at ffffffff8148b7dd
> xfs_inactive_truncate+0xb9 at ffffffff8148bb89
> xfs_inactive+0x227 at ffffffff8148c4f7
> xfs_fs_destroy_inode+0xb8 at ffffffff81496898
> destroy_inode+0x3b at ffffffff8127d2ab
> do_unlinkat+0x1d1 at ffffffff81270df1
> do_syscall_64+0x40 at ffffffff81f6b5f0
> entry_SYSCALL_64_after_hwframe+0x44 at ffffffff8200007c
> 
> This can also happen in log recovery when processing an EFI
> with multiple extents through this path:
> 
> context_switch() kernel/sched/core.c:3881
> __schedule() kernel/sched/core.c:5111
> schedule() kernel/sched/core.c:5186
> xfs_extent_busy_flush() fs/xfs/xfs_extent_busy.c:598
> xfs_alloc_ag_vextent_size() fs/xfs/libxfs/xfs_alloc.c:1641
> xfs_alloc_ag_vextent() fs/xfs/libxfs/xfs_alloc.c:828
> xfs_alloc_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:2362
> xfs_free_extent_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:3029
> __xfs_free_extent() fs/xfs/libxfs/xfs_alloc.c:3067
> xfs_trans_free_extent() fs/xfs/xfs_extfree_item.c:370
> xfs_efi_recover() fs/xfs/xfs_extfree_item.c:626
> xlog_recover_process_efi() fs/xfs/xfs_log_recover.c:4605
> xlog_recover_process_intents() fs/xfs/xfs_log_recover.c:4893
> xlog_recover_finish() fs/xfs/xfs_log_recover.c:5824
> xfs_log_mount_finish() fs/xfs/xfs_log.c:764
> xfs_mountfs() fs/xfs/xfs_mount.c:978
> xfs_fs_fill_super() fs/xfs/xfs_super.c:1908
> mount_bdev() fs/super.c:1417
> xfs_fs_mount() fs/xfs/xfs_super.c:1985
> legacy_get_tree() fs/fs_context.c:647
> vfs_get_tree() fs/super.c:1547
> do_new_mount() fs/namespace.c:2843
> do_mount() fs/namespace.c:3163
> ksys_mount() fs/namespace.c:3372
> __do_sys_mount() fs/namespace.c:3386
> __se_sys_mount() fs/namespace.c:3383
> __x64_sys_mount() fs/namespace.c:3383
> do_syscall_64() arch/x86/entry/common.c:296
> entry_SYSCALL_64() arch/x86/entry/entry_64.S:180
> 
> To avoid this deadlock, we should not block in
> xfs_extent_busy_flush() if we hold a busy extent in the current
> transaction.
> 
> Now that the EFI processing code can handle requeuing a partially
> completed EFI, we can detect this situation in
> xfs_extent_busy_flush() and return -EAGAIN rather than going to
> sleep forever. The -EAGAIN get propagated back out to the
> xfs_trans_free_extent() context, where the EFD is populated and the
> transaction is rolled, thereby moving the busy extents into the CIL.
> 
> At this point, we can retry the extent free operation again with a
> clean transaction. If we hit the same "all free extents are busy"
> situation when trying to fix up the free list, we can safely call
> xfs_extent_busy_flush() and wait for the busy extents to resolve
> and wake us. At this point, the allocation search can make progress
> again and we can fix up the free list.
> 
> This deadlock was first reported by Chandan in mid-2021, but I
> couldn't make myself understood during review, and didn't have time
> to fix it myself.
> 
> It was reported again in March 2023, and again I have found myself
> unable to explain the complexities of the solution needed during
> review.
> 
> As such, I don't have hours more time to waste trying to get the
> fix written the way it needs to be written, so I'm just doing it
> myself. This patchset is largely based on Wengang Wang's last patch,
> but with all the unnecessary stuff removed, split up into multiple
> patches and cleaned up somewhat.

Thank you for taking this over!

> Reported-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reported-by: Wengang Wang <wen.gang.wang@oracle.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 68 ++++++++++++++++++++++++++++-----------
>  fs/xfs/libxfs/xfs_alloc.h | 11 ++++---
>  fs/xfs/xfs_extent_busy.c  | 35 +++++++++++++++++---
>  fs/xfs/xfs_extent_busy.h  |  6 ++--
>  4 files changed, 89 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 11bd0a1756a1..7c675aae0a0f 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1556,6 +1556,8 @@ xfs_alloc_ag_vextent_near(
>  	if (args->agbno > args->max_agbno)
>  		args->agbno = args->max_agbno;
>  
> +	/* Retry once quickly if we find busy extents before blocking. */
> +	alloc_flags |= XFS_ALLOC_FLAG_TRYFLUSH;
>  restart:
>  	len = 0;
>  
> @@ -1611,9 +1613,20 @@ xfs_alloc_ag_vextent_near(
>  	 */
>  	if (!acur.len) {
>  		if (acur.busy) {
> +			/*
> +			 * Our only valid extents must have been busy. Flush and
> +			 * retry the allocation again. If we get an -EAGAIN
> +			 * error, we're being told that a deadlock was avoided
> +			 * and the current transaction needs committing before
> +			 * the allocation can be retried.
> +			 */
>  			trace_xfs_alloc_near_busy(args);
> -			xfs_extent_busy_flush(args->mp, args->pag,
> -					      acur.busy_gen, alloc_flags);
> +			error = xfs_extent_busy_flush(args->tp, args->pag,
> +					acur.busy_gen, alloc_flags);
> +			if (error)
> +				goto out;
> +
> +			alloc_flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
>  			goto restart;
>  		}
>  		trace_xfs_alloc_size_neither(args);
> @@ -1653,6 +1666,8 @@ xfs_alloc_ag_vextent_size(
>  	int			error;
>  	int			i;
>  
> +	/* Retry once quickly if we find busy extents before blocking. */
> +	alloc_flags |= XFS_ALLOC_FLAG_TRYFLUSH;
>  restart:
>  	/*
>  	 * Allocate and initialize a cursor for the by-size btree.
> @@ -1710,19 +1725,25 @@ xfs_alloc_ag_vextent_size(
>  			error = xfs_btree_increment(cnt_cur, 0, &i);
>  			if (error)
>  				goto error0;
> -			if (i == 0) {
> -				/*
> -				 * Our only valid extents must have been busy.
> -				 * Make it unbusy by forcing the log out and
> -				 * retrying.
> -				 */
> -				xfs_btree_del_cursor(cnt_cur,
> -						     XFS_BTREE_NOERROR);
> -				trace_xfs_alloc_size_busy(args);
> -				xfs_extent_busy_flush(args->mp, args->pag,
> -						busy_gen, alloc_flags);
> -				goto restart;
> -			}
> +			if (i)
> +				continue;
> +
> +			/*
> +			 * Our only valid extents must have been busy. Flush and
> +			 * retry the allocation again. If we get an -EAGAIN
> +			 * error, we're being told that a deadlock was avoided
> +			 * and the current transaction needs committing before
> +			 * the allocation can be retried.
> +			 */
> +			trace_xfs_alloc_size_busy(args);
> +			error = xfs_extent_busy_flush(args->tp, args->pag,
> +					busy_gen, alloc_flags);
> +			if (error)
> +				goto error0;
> +
> +			alloc_flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
> +			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> +			goto restart;
>  		}
>  	}
>  
> @@ -1802,10 +1823,21 @@ xfs_alloc_ag_vextent_size(
>  	args->len = rlen;
>  	if (rlen < args->minlen) {
>  		if (busy) {
> -			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> +			/*
> +			 * Our only valid extents must have been busy. Flush and
> +			 * retry the allocation again. If we get an -EAGAIN
> +			 * error, we're being told that a deadlock was avoided
> +			 * and the current transaction needs committing before
> +			 * the allocation can be retried.
> +			 */
>  			trace_xfs_alloc_size_busy(args);
> -			xfs_extent_busy_flush(args->mp, args->pag, busy_gen,
> -					alloc_flags);
> +			error = xfs_extent_busy_flush(args->tp, args->pag,
> +					busy_gen, alloc_flags);
> +			if (error)
> +				goto error0;
> +
> +			alloc_flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
> +			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
>  			goto restart;
>  		}
>  		goto out_nominleft;
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index d1aa7c63eafe..f267842e36ba 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -19,11 +19,12 @@ unsigned int xfs_agfl_size(struct xfs_mount *mp);
>  /*
>   * Flags for xfs_alloc_fix_freelist.
>   */
> -#define	XFS_ALLOC_FLAG_TRYLOCK	0x00000001  /* use trylock for buffer locking */
> -#define	XFS_ALLOC_FLAG_FREEING	0x00000002  /* indicate caller is freeing extents*/
> -#define	XFS_ALLOC_FLAG_NORMAP	0x00000004  /* don't modify the rmapbt */
> -#define	XFS_ALLOC_FLAG_NOSHRINK	0x00000008  /* don't shrink the freelist */
> -#define	XFS_ALLOC_FLAG_CHECK	0x00000010  /* test only, don't modify args */
> +#define	XFS_ALLOC_FLAG_TRYLOCK	(1U << 0)  /* use trylock for buffer locking */
> +#define	XFS_ALLOC_FLAG_FREEING	(1U << 1)  /* indicate caller is freeing extents*/
> +#define	XFS_ALLOC_FLAG_NORMAP	(1U << 2)  /* don't modify the rmapbt */
> +#define	XFS_ALLOC_FLAG_NOSHRINK	(1U << 3)  /* don't shrink the freelist */
> +#define	XFS_ALLOC_FLAG_CHECK	(1U << 4)  /* test only, don't modify args */
> +#define	XFS_ALLOC_FLAG_TRYFLUSH	(1U << 5)  /* don't wait in busy extent flush */
>  
>  /*
>   * Argument structure for xfs_alloc routines.
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 874798949625..7c2fdc71e42d 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -566,21 +566,45 @@ xfs_extent_busy_clear(
>  
>  /*
>   * Flush out all busy extents for this AG.
> + *
> + * If the current transaction is holding busy extents, the caller may not want
> + * to wait for committed busy extents to resolve. If we are being told just to
> + * try a flush or progress has been made since we last skipped a busy extent,
> + * return immediately to allow the caller to try again.
> + *
> + * If we are freeing extents, we might actually be holding the only free extents
> + * in the transaction busy list and the log force won't resolve that situation.
> + * In this case, we must return -EAGAIN to avoid a deadlock by informing the
> + * caller it needs to commit the busy extents it holds before retrying the
> + * extent free operation.
>   */
> -void
> +int
>  xfs_extent_busy_flush(
> -	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
>  	struct xfs_perag	*pag,
>  	unsigned		busy_gen,
> -	unsigned int		flags)
> +	uint32_t		alloc_flags)
>  {
>  	DEFINE_WAIT		(wait);
>  	int			error;
>  
> -	error = xfs_log_force(mp, XFS_LOG_SYNC);
> +	error = xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
>  	if (error)
> -		return;
> +		return error;
>  
> +	/* Avoid deadlocks on uncommitted busy extents. */
> +	if (!list_empty(&tp->t_busy)) {
> +		if (alloc_flags & XFS_ALLOC_FLAG_TRYFLUSH)
> +			return 0;
> +
> +		if (busy_gen != READ_ONCE(pag->pagb_gen))
> +			return 0;
> +
> +		if (alloc_flags & XFS_ALLOC_FLAG_FREEING)
> +			return -EAGAIN;
> +	}
> +
> +	/* Wait for committed busy extents to resolve. */
>  	do {
>  		prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
>  		if  (busy_gen != READ_ONCE(pag->pagb_gen))
> @@ -589,6 +613,7 @@ xfs_extent_busy_flush(
>  	} while (1);
>  
>  	finish_wait(&pag->pagb_wait, &wait);
> +	return 0;
>  }
>  
>  void
> diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
> index 79ef5a2d7758..2104548d6695 100644
> --- a/fs/xfs/xfs_extent_busy.h
> +++ b/fs/xfs/xfs_extent_busy.h
> @@ -51,9 +51,9 @@ bool
>  xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t *bno,
>  		xfs_extlen_t *len, unsigned *busy_gen);
>  
> -void
> -xfs_extent_busy_flush(struct xfs_mount *mp, struct xfs_perag *pag,
> -	unsigned busy_gen, unsigned int flags);
> +int
> +xfs_extent_busy_flush(struct xfs_trans *tp, struct xfs_perag *pag,
> +	unsigned busy_gen, uint32_t flags);

Aha, you /did/ change this by the end of the series.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  
>  void
>  xfs_extent_busy_wait_all(struct xfs_mount *mp);
> -- 
> 2.40.1
> 
