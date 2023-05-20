Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DEC70AB2F
	for <lists+linux-xfs@lfdr.de>; Sat, 20 May 2023 23:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjETV4M (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 20 May 2023 17:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjETV4L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 May 2023 17:56:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37AF109
        for <linux-xfs@vger.kernel.org>; Sat, 20 May 2023 14:56:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E65D60B47
        for <linux-xfs@vger.kernel.org>; Sat, 20 May 2023 21:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D5AC433D2;
        Sat, 20 May 2023 21:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684619765;
        bh=cmPBAwztItXomBRZv3TJxfXSxjlSg4fYGKv7xY83MjU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dwdj3B26PNQAkGs636OTZ0v/zp9tRqN+VvsnWdyb76XWFAC/czwRaOIb+Zx1Ae/nT
         yJ2NSwOCUy/6PYzvAxzhnV8+qlh+X5lOYoHVbC4PbOFDjt0pt4UK45/6ZO7i+CqaCx
         9Aa9qrX2isT4Nr1lSxIPWN5WMJ8QYsNeulZwAyUeYASIMqlH7gVELf71JLHcmRmlxy
         Q3lXNAMesVVaOmyXHT1PX7C3HGcHqM3RHDM9obRld8/qTX0/0G6RS72uBzvZCx3kKg
         G/Hctu/F15UCY5onTJEFvEPMZZVsS0tOOwWjmmHXoQt0q9fZObCyaf94nnNVB8yiuJ
         Kb7l2ZPKw2qtA==
Date:   Sat, 20 May 2023 14:56:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH] xfs: Don't block in xfs_extent_busy_flush
Message-ID: <20230520215604.GA11620@frogsfrogsfrogs>
References: <20230519171829.4108-1-wen.gang.wang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519171829.4108-1-wen.gang.wang@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 19, 2023 at 10:18:29AM -0700, Wengang Wang wrote:
> The following calltrace is seen:
> 	#0	context_switch() kernel/sched/core.c:3881
> 	#1	__schedule() kernel/sched/core.c:5111
> 	#2	schedule() kernel/sched/core.c:5186
> 	#3	xfs_extent_busy_flush() fs/xfs/xfs_extent_busy.c:598
> 	#4	xfs_alloc_ag_vextent_size() fs/xfs/libxfs/xfs_alloc.c:1641
> 	#5	xfs_alloc_ag_vextent() fs/xfs/libxfs/xfs_alloc.c:828
> 	#6	xfs_alloc_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:2362
> 	#7	xfs_free_extent_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:3029
> 	#8	__xfs_free_extent() fs/xfs/libxfs/xfs_alloc.c:3067
> 	#9	xfs_trans_free_extent() fs/xfs/xfs_extfree_item.c:370
> 	#10	xfs_efi_recover() fs/xfs/xfs_extfree_item.c:626
> 	#11	xlog_recover_process_efi() fs/xfs/xfs_log_recover.c:4605
> 	#12	xlog_recover_process_intents() fs/xfs/xfs_log_recover.c:4893
> 	#13	xlog_recover_finish() fs/xfs/xfs_log_recover.c:5824
> 	#14	xfs_log_mount_finish() fs/xfs/xfs_log.c:764
> 	#15	xfs_mountfs() fs/xfs/xfs_mount.c:978
> 	#16	xfs_fs_fill_super() fs/xfs/xfs_super.c:1908
> 	#17	mount_bdev() fs/super.c:1417
> 	#18	xfs_fs_mount() fs/xfs/xfs_super.c:1985
> 	#19	legacy_get_tree() fs/fs_context.c:647
> 	#20	vfs_get_tree() fs/super.c:1547
> 	#21	do_new_mount() fs/namespace.c:2843
> 	#22	do_mount() fs/namespace.c:3163
> 	#23	ksys_mount() fs/namespace.c:3372
> 	#24	__do_sys_mount() fs/namespace.c:3386
> 	#25	__se_sys_mount() fs/namespace.c:3383
> 	#26	__x64_sys_mount() fs/namespace.c:3383
> 	#27	do_syscall_64() arch/x86/entry/common.c:296
> 	#28	entry_SYSCALL_64() arch/x86/entry/entry_64.S:180
> 
> During the process of the 2nd and subsequetial record in an EFI.
> It is waiting for the busy blocks to be cleaned, but the only busy extent
> is still hold in current xfs_trans->t_busy. That busy extent was added when
> processing previous EFI record. And because that busy extent is not committed
> yet, it can't be cleaned.
> 
> To avoid above deadlock, we don't block in xfs_extent_busy_flush() when
> allocating AGFL blocks, instead it returns -EAGAIN. On receiving -EAGAIN
> we are able to retry that EFI record with a new transaction after committing
> the old transactin. With old transaction committed, the busy extent attached
> to the old transaction get the change to be cleaned. On the retry, there is
> no existing busy extents in the new transaction, thus no deadlock.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 30 ++++++++++++++++++++++++------
>  fs/xfs/libxfs/xfs_alloc.h |  2 ++
>  fs/xfs/scrub/repair.c     |  4 ++--
>  fs/xfs/xfs_extent_busy.c  | 34 +++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_extent_busy.h  |  6 +++---
>  fs/xfs/xfs_extfree_item.c | 37 ++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_log_recover.c  | 23 ++++++++++-------------
>  fs/xfs/xfs_trans_ail.c    |  2 +-
>  fs/xfs/xfs_trans_priv.h   |  1 +
>  9 files changed, 108 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 203f16c48c19..abfd2acb3053 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1491,6 +1491,7 @@ STATIC int
>  xfs_alloc_ag_vextent_near(
>  	struct xfs_alloc_arg	*args)
>  {
> +	int			flags = args->flags | XFS_ALLOC_FLAG_TRYFLUSH;
>  	struct xfs_alloc_cur	acur = {};
>  	int			error;		/* error code */
>  	int			i;		/* result code, temporary */
> @@ -1564,8 +1565,11 @@ xfs_alloc_ag_vextent_near(
>  	if (!acur.len) {
>  		if (acur.busy) {
>  			trace_xfs_alloc_near_busy(args);
> -			xfs_extent_busy_flush(args->mp, args->pag,
> -					      acur.busy_gen);
> +			error = xfs_extent_busy_flush(args->tp, args->pag,
> +					      acur.busy_gen, flags);
> +			if (error)
> +				goto out;
> +			flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
>  			goto restart;
>  		}
>  		trace_xfs_alloc_size_neither(args);
> @@ -1592,6 +1596,7 @@ STATIC int				/* error */
>  xfs_alloc_ag_vextent_size(
>  	xfs_alloc_arg_t	*args)		/* allocation argument structure */
>  {
> +	int		flags = args->flags | XFS_ALLOC_FLAG_TRYFLUSH;

This variable holds XFS_ALLOC_FLAG_* values that are passed only to
xfs_extent_busy_flush, right?  Could this be named "busyflags" or
similar to make that clearer?

(Clearer to 6hr^W6mo from now Darrick who won't remember this at all.)

>  	struct xfs_agf	*agf = args->agbp->b_addr;
>  	struct xfs_btree_cur *bno_cur;	/* cursor for bno btree */
>  	struct xfs_btree_cur *cnt_cur;	/* cursor for cnt btree */
> @@ -1670,8 +1675,13 @@ xfs_alloc_ag_vextent_size(
>  				xfs_btree_del_cursor(cnt_cur,
>  						     XFS_BTREE_NOERROR);
>  				trace_xfs_alloc_size_busy(args);
> -				xfs_extent_busy_flush(args->mp,
> -							args->pag, busy_gen);
> +				error = xfs_extent_busy_flush(args->tp, args->pag,
> +						busy_gen, flags);
> +				if (error) {
> +					cnt_cur = NULL;
> +					goto error0;
> +				}
> +				flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
>  				goto restart;
>  			}
>  		}
> @@ -1755,7 +1765,13 @@ xfs_alloc_ag_vextent_size(
>  		if (busy) {
>  			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
>  			trace_xfs_alloc_size_busy(args);
> -			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
> +			error = xfs_extent_busy_flush(args->tp, args->pag,
> +					busy_gen, flags);
> +			if (error) {
> +				cnt_cur = NULL;
> +				goto error0;
> +			}
> +			flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
>  			goto restart;
>  		}
>  		goto out_nominleft;
> @@ -2629,6 +2645,7 @@ xfs_alloc_fix_freelist(
>  	targs.agno = args->agno;
>  	targs.alignment = targs.minlen = targs.prod = 1;
>  	targs.pag = pag;
> +	targs.flags = args->flags & XFS_ALLOC_FLAG_FREEING;

Hmm, I guess this propagates FREEING into the allocation that lengthens
the AGFL.  Right?

>  	error = xfs_alloc_read_agfl(pag, tp, &agflbp);
>  	if (error)
>  		goto out_agbp_relse;
> @@ -3572,6 +3589,7 @@ xfs_free_extent_fix_freelist(
>  	args.mp = tp->t_mountp;
>  	args.agno = pag->pag_agno;
>  	args.pag = pag;
> +	args.flags = XFS_ALLOC_FLAG_FREEING;
>  
>  	/*
>  	 * validate that the block number is legal - the enables us to detect
> @@ -3580,7 +3598,7 @@ xfs_free_extent_fix_freelist(
>  	if (args.agno >= args.mp->m_sb.sb_agcount)
>  		return -EFSCORRUPTED;
>  
> -	error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
> +	error = xfs_alloc_fix_freelist(&args, args.flags);

Hm.  Why stuff XFS_ALLOC_FLAG_FREEING into args.flags here?  I /think/
in this case it doesn't matter because nothing under
xfs_alloc_fix_freelist accesses args->flags...?

AFAICT in xfs_alloc_fix_freelist, the difference between @args->flags
and @flags is that @args is the allocation that we're trying to do,
whereas @flags are for any allocation that might need to be done to fix
the freelist.  IOWS, the only allocation we're doing *is* to fix the
freelist, so they are one in the same.  Maybe?  Otherwise I can't tell
why we'd convey two sets of XFS_ALLOC flags to xfs_alloc_fix_freelist.

So while I think this isn't incorrect, the flag mixing bothers me a bit
because setting fields in a struct can have weird not so obvious side
effects.

(Still trying to make sense of the addition of a @flags field to struct
xfs_alloc_arg.)

>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 2b246d74c189..5038fba87784 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -24,6 +24,7 @@ unsigned int xfs_agfl_size(struct xfs_mount *mp);
>  #define	XFS_ALLOC_FLAG_NORMAP	0x00000004  /* don't modify the rmapbt */
>  #define	XFS_ALLOC_FLAG_NOSHRINK	0x00000008  /* don't shrink the freelist */
>  #define	XFS_ALLOC_FLAG_CHECK	0x00000010  /* test only, don't modify args */
> +#define	XFS_ALLOC_FLAG_TRYFLUSH	0x00000020  /* don't block in busyextent flush*/
>  
>  /*
>   * Argument structure for xfs_alloc routines.
> @@ -57,6 +58,7 @@ typedef struct xfs_alloc_arg {
>  #ifdef DEBUG
>  	bool		alloc_minlen_only; /* allocate exact minlen extent */
>  #endif
> +	int		flags;		/* XFS_ALLOC_FLAG_* */
>  } xfs_alloc_arg_t;
>  
>  /*
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 1b71174ec0d6..2ba28e4257fe 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -496,9 +496,9 @@ xrep_fix_freelist(
>  	args.agno = sc->sa.pag->pag_agno;
>  	args.alignment = 1;
>  	args.pag = sc->sa.pag;
> +	args.flags = can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK;
>  
> -	return xfs_alloc_fix_freelist(&args,
> -			can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK);
> +	return xfs_alloc_fix_freelist(&args, args.flags);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index f3d328e4a440..ea1c1857bf5b 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -567,18 +567,41 @@ xfs_extent_busy_clear(
>  /*
>   * Flush out all busy extents for this AG.
>   */
> -void
> +int
>  xfs_extent_busy_flush(
> -	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
>  	struct xfs_perag	*pag,
> -	unsigned		busy_gen)
> +	unsigned		busy_gen,
> +	int			flags)
>  {
>  	DEFINE_WAIT		(wait);
>  	int			error;
>  
> -	error = xfs_log_force(mp, XFS_LOG_SYNC);
> +	error = xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
>  	if (error)
> -		return;
> +		return error;
> +
> +	/*
> +	 * If we are holding busy extents, the caller may not want to block
> +	 * straight away. If we are being told just to try a flush or progress
> +	 * has been made since we last skipped a busy extent, return
> +	 * immediately to allow the caller to try again. If we are freeing
> +	 * extents, we might actually be holding the only free extents in the
> +	 * transaction busy list and the log force won't resolve that
> +	 * situation. In this case, return -EAGAIN in that case to tell the
> +	 * caller it needs to commit the busy extents it holds before retrying
> +	 * the extent free operation.
> +	 */
> +	if (!list_empty(&tp->t_busy)) {
> +		if (flags & XFS_ALLOC_FLAG_TRYFLUSH)
> +			return 0;
> +
> +		if (busy_gen != READ_ONCE(pag->pagb_gen))
> +			return 0;
> +
> +		if (flags & XFS_ALLOC_FLAG_FREEING)
> +			return -EAGAIN;
> +	}
>  
>  	do {
>  		prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
> @@ -588,6 +611,7 @@ xfs_extent_busy_flush(
>  	} while (1);
>  
>  	finish_wait(&pag->pagb_wait, &wait);
> +	return 0;

This part looks good.

>  }
>  
>  void
> diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
> index 4a118131059f..edeedb92e0df 100644
> --- a/fs/xfs/xfs_extent_busy.h
> +++ b/fs/xfs/xfs_extent_busy.h
> @@ -51,9 +51,9 @@ bool
>  xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t *bno,
>  		xfs_extlen_t *len, unsigned *busy_gen);
>  
> -void
> -xfs_extent_busy_flush(struct xfs_mount *mp, struct xfs_perag *pag,
> -	unsigned busy_gen);
> +int
> +xfs_extent_busy_flush(struct xfs_trans *tp, struct xfs_perag *pag,
> +	unsigned busy_gen, int flags);
>  
>  void
>  xfs_extent_busy_wait_all(struct xfs_mount *mp);
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 011b50469301..3c5a9e9952ec 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -336,6 +336,25 @@ xfs_trans_get_efd(
>  	return efdp;
>  }
>  
> +/*
> + * Fill the EFD with all extents from the EFI and set the counter.
> + * Note: the EFD should comtain at least one extents already.
> + */
> +static void xfs_fill_efd_with_efi(struct xfs_efd_log_item *efdp)
> +{
> +	struct xfs_efi_log_item *efip = efdp->efd_efip;
> +	uint                    i;
> +
> +	if (efdp->efd_next_extent == efip->efi_format.efi_nextents)
> +		return;
> +
> +	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> +	       efdp->efd_format.efd_extents[i] =
> +		       efip->efi_format.efi_extents[i];
> +	}
> +	efdp->efd_next_extent = efip->efi_format.efi_nextents;
> +}
> +
>  /*
>   * Free an extent and log it to the EFD. Note that the transaction is marked
>   * dirty regardless of whether the extent free succeeds or fails to support the
> @@ -369,6 +388,10 @@ xfs_trans_free_extent(
>  	error = __xfs_free_extent(tp, xefi->xefi_startblock,
>  			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
>  			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
> +	if (error == -EAGAIN) {
> +		xfs_fill_efd_with_efi(efdp);
> +		return error;
> +	}
>  	/*
>  	 * Mark the transaction dirty, even on error. This ensures the
>  	 * transaction is aborted, which:
> @@ -476,7 +499,8 @@ xfs_extent_free_finish_item(
>  	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
>  
>  	error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
> -	kmem_cache_free(xfs_extfree_item_cache, xefi);
> +	if (error != -EAGAIN)
> +		kmem_cache_free(xfs_extfree_item_cache, xefi);
>  	return error;
>  }
>  
> @@ -633,6 +657,17 @@ xfs_efi_item_recover(
>  		fake.xefi_blockcount = extp->ext_len;
>  
>  		error = xfs_trans_free_extent(tp, efdp, &fake);
> +		if (error == -EAGAIN) {

Curious, is this patch based off of 6.4-rc?  There should be a
xfs_extent_free_get_group / xfs_extent_free_put_group here.

> +			xfs_free_extent_later(tp, fake.xefi_startblock,
> +				fake.xefi_blockcount, &XFS_RMAP_OINFO_ANY_OWNER);
> +			/*
> +			 * try to free as many extents as possible with current
> +			 * transaction
> +			 */
> +			error = 0;
> +			continue;
> +		};

If we get EAGAIN, why not let the unfinished parts of the recovered EFI
work get turned into a new EFI?

> +
>  		if (error == -EFSCORRUPTED)
>  			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
>  					extp, sizeof(*extp));
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 322eb2ee6c55..00bfe9683fa8 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2540,30 +2540,27 @@ xlog_recover_process_intents(
>  	struct xfs_log_item	*lip;
>  	struct xfs_ail		*ailp;
>  	int			error = 0;
> -#if defined(DEBUG) || defined(XFS_WARN)
> -	xfs_lsn_t		last_lsn;
> -#endif
> +	xfs_lsn_t		threshold_lsn;
>  
>  	ailp = log->l_ailp;
> +	threshold_lsn = xfs_ail_max_lsn(ailp);
>  	spin_lock(&ailp->ail_lock);
> -#if defined(DEBUG) || defined(XFS_WARN)
> -	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
> -#endif
> +
>  	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
>  	     lip != NULL;
>  	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
>  		const struct xfs_item_ops	*ops;
> +		/*
> +		 * Orignal redo EFI could be splitted into new EFIs. Those
> +		 * new EFIs are supposed to be processed in capture_list.
> +		 * Stop here when original redo intents are done.
> +		 */
> +		if (XFS_LSN_CMP(threshold_lsn, lip->li_lsn) < 0)
> +			break;

I'm not sure what this change accomplishes?  Is it because of the
continue; statement in xfs_efi_item_recover?

--D

>  
>  		if (!xlog_item_is_intent(lip))
>  			break;
>  
> -		/*
> -		 * We should never see a redo item with a LSN higher than
> -		 * the last transaction we found in the log at the start
> -		 * of recovery.
> -		 */
> -		ASSERT(XFS_LSN_CMP(last_lsn, lip->li_lsn) >= 0);
> -
>  		/*
>  		 * NOTE: If your intent processing routine can create more
>  		 * deferred ops, you /must/ attach them to the capture list in
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 7d4109af193e..2825f55eca88 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -137,7 +137,7 @@ xfs_ail_min_lsn(
>  /*
>   * Return the maximum lsn held in the AIL, or zero if the AIL is empty.
>   */
> -static xfs_lsn_t
> +xfs_lsn_t
>  xfs_ail_max_lsn(
>  	struct xfs_ail		*ailp)
>  {
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index d5400150358e..86b4f29b2a6e 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -106,6 +106,7 @@ void			xfs_ail_push_all(struct xfs_ail *);
>  void			xfs_ail_push_all_sync(struct xfs_ail *);
>  struct xfs_log_item	*xfs_ail_min(struct xfs_ail  *ailp);
>  xfs_lsn_t		xfs_ail_min_lsn(struct xfs_ail *ailp);
> +xfs_lsn_t		xfs_ail_max_lsn(struct xfs_ail *ailp);
>  
>  struct xfs_log_item *	xfs_trans_ail_cursor_first(struct xfs_ail *ailp,
>  					struct xfs_ail_cursor *cur,
> -- 
> 2.21.0 (Apple Git-122.2)
> 
