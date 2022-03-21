Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA354E33EA
	for <lists+linux-xfs@lfdr.de>; Tue, 22 Mar 2022 00:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbiCUXKK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 21 Mar 2022 19:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234577AbiCUXJg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 19:09:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141EE2DC033
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 15:58:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A1E6B81A4C
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 21:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F0DC340E8;
        Mon, 21 Mar 2022 21:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647899557;
        bh=6RnQ1R2FFyxBCm7TJJ5ASgTxYTayhmBq0xQIClt1zoI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EQc3xqd0GwaC1S+zUFKKBYDWfsAHSScrXPXFthZUe9T5vbYBI59HaVoklg9S+VcjD
         4VuO8veorgXCAqjaV4wgSbFNc7wxqApR6zpTWKfwQpQFn3tbOa8RPKABh1nifQSzju
         BRg/iaGa4PMe0K0AmMb54lZQqbZoc2D8MODEQW9lWlwsK3Xz0NQXq3huUXHHpVYYwY
         VJtnrTCJsHjycsG5enfk4cMx3PmC8ofSIqO3gQdl5aLcghuljCSXun97EVU5Y4EUba
         3vebMvOaPni6jUa0LEQnG1OFNA1UbDaq9W42yZA4atcZn9rmxdXD7UQu6waFzye2VQ
         dp+uxq59r5jRg==
Date:   Mon, 21 Mar 2022 14:52:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: shutdown in intent recovery has non-intent
 items in the AIL
Message-ID: <20220321215236.GK8224@magnolia>
References: <20220321012329.376307-1-david@fromorbit.com>
 <20220321012329.376307-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321012329.376307-3-david@fromorbit.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 21, 2022 at 12:23:29PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> generic/388 triggered a failure in RUI recovery due to a corrupted
> btree record and the system then locked up hard due to a subsequent
> assert failure while holding a spinlock cancelling intents:
> 
>  XFS (pmem1): Corruption of in-memory data (0x8) detected at xfs_do_force_shutdown+0x1a/0x20 (fs/xfs/xfs_trans.c:964).  Shutting down filesystem.
>  XFS (pmem1): Please unmount the filesystem and rectify the problem(s)
>  XFS: Assertion failed: !xlog_item_is_intent(lip), file: fs/xfs/xfs_log_recover.c, line: 2632
>  Call Trace:
>   <TASK>
>   xlog_recover_cancel_intents.isra.0+0xd1/0x120
>   xlog_recover_finish+0xb9/0x110
>   xfs_log_mount_finish+0x15a/0x1e0
>   xfs_mountfs+0x540/0x910
>   xfs_fs_fill_super+0x476/0x830
>   get_tree_bdev+0x171/0x270
>   ? xfs_init_fs_context+0x1e0/0x1e0
>   xfs_fs_get_tree+0x15/0x20
>   vfs_get_tree+0x24/0xc0
>   path_mount+0x304/0xba0
>   ? putname+0x55/0x60
>   __x64_sys_mount+0x108/0x140
>   do_syscall_64+0x35/0x80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Essentially, there's dirty metadata in the AIL from intent recovery
> transactions, so when we go to cancel the remaining intents we assume
> that all objects after the first non-intent log item in the AIL are
> not intents.
> 
> This is not true. Intent recovery can log new intents to continue
> the operations the original intent could not complete in a single
> transaction. The new intents are committed before they are deferred,
> which means if the CIL commits in the background they will get
> inserted into the AIL at the head.

Like you, I wonder how I never hit this.  Maybe I've never hit a
corrupted rmap btree record during recovery?

So I guess what we're tripping over is a sequence of items in the AIL
that looks something like this?

0. <recovered non intent items>
1. <recovered intent item>
2. <new non-intent item>
3. <new intent items>

So we speed along the AIL list, dealing with the <0> items until we get
to <1>.  We recover <1>, which generates <2> and <3>.  Next, the
debugging code thinks we've hit the end of the list of recovered items,
and therefore it can keep walking the AIL and that it will only find
items like <2>.  Unfortunately, it finds the new intent <3> and trips?

> Hence if we shut down the filesystem while processing intent
> recovery, the AIL may have new intents active at the current head.
> Hence this check:
> 
>                 /*
>                  * We're done when we see something other than an intent.
>                  * There should be no intents left in the AIL now.
>                  */
>                 if (!xlog_item_is_intent(lip)) {
> #ifdef DEBUG
>                         for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
>                                 ASSERT(!xlog_item_is_intent(lip));
> #endif
>                         break;
>                 }
> 
> in both xlog_recover_process_intents() and
> log_recover_cancel_intents() is simply not valid. It was valid back
> when we only had EFI/EFD intents and didn't chain intents, but it
> hasn't been valid ever since intent recovery could create and commit
> new intents.
> 
> Given that crashing the mount task like this pretty much prevents
> diagnosing what went wrong that lead to the initial failure that
> triggered intent cancellation, just remove the checks altogether.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Actually, I bet I have hit this while fuzz testing online repair, but
then decided that the better fix would be to make online fsck more
careful about not crashing the fs in the first place.

Assuming the answer to my question above is 'yes', then

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_recover.c | 50 ++++++++++++++--------------------------
>  1 file changed, 17 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 96c997ed2ec8..7758a6706b8c 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2519,21 +2519,22 @@ xlog_abort_defer_ops(
>  		xfs_defer_ops_capture_free(mp, dfc);
>  	}
>  }
> +
>  /*
>   * When this is called, all of the log intent items which did not have
> - * corresponding log done items should be in the AIL.  What we do now
> - * is update the data structures associated with each one.
> + * corresponding log done items should be in the AIL.  What we do now is update
> + * the data structures associated with each one.
>   *
> - * Since we process the log intent items in normal transactions, they
> - * will be removed at some point after the commit.  This prevents us
> - * from just walking down the list processing each one.  We'll use a
> - * flag in the intent item to skip those that we've already processed
> - * and use the AIL iteration mechanism's generation count to try to
> - * speed this up at least a bit.
> + * Since we process the log intent items in normal transactions, they will be
> + * removed at some point after the commit.  This prevents us from just walking
> + * down the list processing each one.  We'll use a flag in the intent item to
> + * skip those that we've already processed and use the AIL iteration mechanism's
> + * generation count to try to speed this up at least a bit.
>   *
> - * When we start, we know that the intents are the only things in the
> - * AIL.  As we process them, however, other items are added to the
> - * AIL.
> + * When we start, we know that the intents are the only things in the AIL. As we
> + * process them, however, other items are added to the AIL. Hence we know we
> + * have started recovery on all the pending intents when we find an non-intent
> + * item in the AIL.
>   */
>  STATIC int
>  xlog_recover_process_intents(
> @@ -2556,17 +2557,8 @@ xlog_recover_process_intents(
>  	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
>  	     lip != NULL;
>  	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
> -		/*
> -		 * We're done when we see something other than an intent.
> -		 * There should be no intents left in the AIL now.
> -		 */
> -		if (!xlog_item_is_intent(lip)) {
> -#ifdef DEBUG
> -			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
> -				ASSERT(!xlog_item_is_intent(lip));
> -#endif
> +		if (!xlog_item_is_intent(lip))
>  			break;
> -		}
>  
>  		/*
>  		 * We should never see a redo item with a LSN higher than
> @@ -2607,8 +2599,9 @@ xlog_recover_process_intents(
>  }
>  
>  /*
> - * A cancel occurs when the mount has failed and we're bailing out.
> - * Release all pending log intent items so they don't pin the AIL.
> + * A cancel occurs when the mount has failed and we're bailing out.  Release all
> + * pending log intent items that we haven't started recovery on so they don't
> + * pin the AIL.
>   */
>  STATIC void
>  xlog_recover_cancel_intents(
> @@ -2622,17 +2615,8 @@ xlog_recover_cancel_intents(
>  	spin_lock(&ailp->ail_lock);
>  	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
>  	while (lip != NULL) {
> -		/*
> -		 * We're done when we see something other than an intent.
> -		 * There should be no intents left in the AIL now.
> -		 */
> -		if (!xlog_item_is_intent(lip)) {
> -#ifdef DEBUG
> -			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
> -				ASSERT(!xlog_item_is_intent(lip));
> -#endif
> +		if (!xlog_item_is_intent(lip))
>  			break;
> -		}
>  
>  		spin_unlock(&ailp->ail_lock);
>  		lip->li_ops->iop_release(lip);
> -- 
> 2.35.1
> 
