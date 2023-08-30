Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0CD78D008
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Aug 2023 01:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjH2XLe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 29 Aug 2023 19:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239625AbjH2XLF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:11:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058DADB
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 16:11:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75307611A5
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 23:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D586EC433C8;
        Tue, 29 Aug 2023 23:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350660;
        bh=ljfArqi1598wkxZ7MuvYvKldv0ktUz7VIySp3jcWeZs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bE1AjutdXSxTjCDSIlA0XzmZNsUaJZamuTAr6pL+Q+ii2f/xZq3TQm1+T1Vg7jNIK
         XZ4r3YTB1VIU9nPvrCMuDyHonIyID2frcnTit0mzHSfUZ8aKMbhn3/mrLiUo6LMQUO
         uXrBUTiShuvztAZXI0tPa2edXVs3UhChTeGYySffpI0tOdn4esoD7AuP7KTVaa/Vcj
         PV091RvIQfgk1r0ugRQPPI8aWVkyK17J41Jiqvzd2e4i8IyJuSDmqDVdmUZEzTiebw
         2vHTUXNHdsAkhmW20lpqDRRPUnc6f4CmUyMyCbgecrXu6i/hvnQ3Hh1LVXAICw9Wl5
         vVZWgAeATTvuQ==
Subject: [PATCH 1/1] xfs: reserve less log space when recovering log intent
 items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@gmail.com
Cc:     Wengang Wang <wen.gang.wang@oracle.com>,
        Srikanth C S <srikanth.c.s@oracle.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Tue, 29 Aug 2023 16:11:00 -0700
Message-ID: <169335066034.3528394.15168907062088535034.stgit@frogsfrogsfrogs>
In-Reply-To: <169335065467.3528394.5454470321177848433.stgit@frogsfrogsfrogs>
References: <169335065467.3528394.5454470321177848433.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Wengang Wang reports that a customer's system was running a number of
truncate operations on a filesystem with a very small log.  Contention
on the reserve heads lead to other threads stalling on smaller updates
(e.g.  mtime updates) long enough to result in the node being rebooted
on account of the lack of responsivenes.  The node failed to recover
because log recovery of an EFI became stuck waiting for a grant of
reserve space.  From Wengang's report:

"For the file deletion, log bytes are reserved basing on
xfs_mount->tr_itruncate which is:

    tr_logres = 175488,
    tr_logcount = 2,
    tr_logflags = XFS_TRANS_PERM_LOG_RES,

"You see it's a permanent log reservation with two log operations (two
transactions in rolling mode).  After calculation (xlog_calc_unit_res()
adds space for various log headers), the final log space needed per
transaction changes from  175488 to 180208 bytes.  So the total log
space needed is 360416 bytes (180208 * 2).  [That quantity] of log space
(360416 bytes) needs to be reserved for both run time inode removing
(xfs_inactive_truncate()) and EFI recover (xfs_efi_item_recover())."

In other words, runtime pre-reserves 360K of space in anticipation of
running a chain of two transactions in which each transaction gets a
180K reservation.

Now that we've allocated the transaction, we delete the bmap mapping,
log an EFI to free the space, and roll the transaction as part of
finishing the deferops chain.  Rolling creates a new xfs_trans which
shares its ticket with the old transaction.  Next, xfs_trans_roll calls
__xfs_trans_commit with regrant == true, which calls xlog_cil_commit
with the same regrant parameter.

xlog_cil_commit calls xfs_log_ticket_regrant, which decrements t_cnt and
subtracts t_curr_res from the reservation and write heads.

If the filesystem is fresh and the first transaction only used (say)
20K, then t_curr_res will be 160K, and we give that much reservation
back to the reservation head.  Or if the file is really fragmented and
the first transaction actually uses 170K, then t_curr_res will be 10K,
and that's what we give back to the reservation.

Having done that, we're now headed into the second transaction with an
EFI and 180K of reservation.  Other threads apparently consumed all the
reservation for smaller transactions, such as timestamp updates.

Now let's say the first transaction gets written to disk and we crash
without ever completing the second transaction.  Now we remount the fs,
log recovery finds the unfinished EFI, and calls xfs_efi_recover to
finish the EFI.  However, xfs_efi_recover starts a new tr_itruncate
tranasction, which asks for 360K log reservation.  This is a lot more
than the 180K that we had reserved at the time of the crash.  If the
first EFI to be recovered is also pinning the tail of the log, we will
be unable to free any space in the log, and recovery livelocks.

Wengang confirmed this:

"Now we have the second transaction which has 180208 log bytes reserved
too. The second transaction is supposed to process intents including
extent freeing.  With my hacking patch, I blocked the extent freeing 5
hours. So in that 5 hours, 180208 (NOT 360416) log bytes are reserved.

"With my test case, other transactions (update timestamps) then happen.
As my hacking patch pins the journal tail, those timestamp-updating
transactions finally use up (almost) all the left available log space
(in memory in on disk).  And finally the on disk (and in memory)
available log space goes down near to 180208 bytes.  Those 180208 bytes
are reserved by [the] second (extent-free) transaction [in the chain]."

Wengang and I noticed that EFI recovery starts a transaction, completes
one step of the chain, and commits the transaction without completing
any other steps of the chain.  Those subsequent steps are completed by
xlog_finish_defer_ops, which allocates yet another transaction to
finish the rest of the chain.  That transaction gets the same tr_logres
as the head transaction, but with tr_logcount = 1 to force regranting
with every roll to avoid livelocks.

In other words, we already figured this out in commit 929b92f64048d
("xfs: xfs_defer_capture should absorb remaining transaction
reservation"), but should have applied that logic to each intent item's
recovery function.  For Wengang's case, the xfs_trans_alloc call in the
EFI recovery function should only be asking for a single transaction's
worth of log reservation -- 180K, not 360K.

Quoting Wengang again:

"With log recovery, during EFI recovery, we use tr_itruncate again to
reserve two transactions that needs 360416 log bytes.  Reserving 360416
bytes fails [stalls] because we now only have about 180208 available.

"Actually during the EFI recover, we only need one transaction to free
the extents just like the 2nd transaction at RUNTIME.  So it only needs
to reserve 180208 rather than 360416 bytes.  We have (a bit) more than
180208 available log bytes on disk, so [if we decrease the reservation
to 180K] the reservation goes and the recovery [finishes].  That is to
say: we can fix the log recover part to fix the issue. We can introduce
a new xfs_trans_res xfs_mount->tr_ext_free

{
  tr_logres = 175488,
  tr_logcount = 0,
  tr_logflags = 0,
}

"and use tr_ext_free instead of tr_itruncate in EFI recover."

However, I don't think it quite makes sense to create an entirely new
transaction reservation type to handle single-stepping during log
recovery.  Instead, we should copy the transaction reservation
information in the xfs_mount, change tr_logcount to 1, and pass that
into xfs_trans_alloc.  We know this won't risk changing the min log size
computation since we always ask for a fraction of the reservation for
all known transaction types.

This looks like it's been lurking in the codebase since commit
3d3c8b5222b92, which changed the xfs_trans_reserve call in
xlog_recover_process_efi to use the tr_logcount in tr_itruncate.
That changed the EFI recovery transaction from making a
non-XFS_TRANS_PERM_LOG_RES request for one transaction's worth of log
space to a XFS_TRANS_PERM_LOG_RES request for two transactions worth.

Fixes: 3d3c8b5222b92 ("xfs: refactor xfs_trans_reserve() interface")
Complements: 929b92f64048d ("xfs: xfs_defer_capture should absorb remaining transaction reservation")
Suggested-by: Wengang Wang <wen.gang.wang@oracle.com>
Cc: Srikanth C S <srikanth.c.s@oracle.com>
[djwong: apply the same transformation to all log intent recovery]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_recover.h |   22 ++++++++++++++++++++++
 fs/xfs/xfs_attr_item.c          |    7 ++++---
 fs/xfs/xfs_bmap_item.c          |    4 +++-
 fs/xfs/xfs_extfree_item.c       |    4 +++-
 fs/xfs/xfs_refcount_item.c      |    6 ++++--
 fs/xfs/xfs_rmap_item.c          |    6 ++++--
 6 files changed, 40 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 2420865f3007..a5100a11faf9 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -131,4 +131,26 @@ void xlog_check_buf_cancel_table(struct xlog *log);
 #define xlog_check_buf_cancel_table(log) do { } while (0)
 #endif
 
+/*
+ * Transform a regular reservation into one suitable for recovery of a log
+ * intent item.
+ *
+ * Intent recovery only runs a single step of the transaction chain and defers
+ * the rest to a separate transaction.  Therefore, we reduce logcount to 1 here
+ * to avoid livelocks if the log grant space is nearly exhausted due to the
+ * recovered intent pinning the tail.  Keep the same logflags to avoid tripping
+ * asserts elsewhere.  Struct copies abound below.
+ */
+static inline struct xfs_trans_res
+xlog_recover_resv(const struct xfs_trans_res *r)
+{
+	struct xfs_trans_res ret = {
+		.tr_logres	= r->tr_logres,
+		.tr_logcount	= 1,
+		.tr_logflags	= r->tr_logflags,
+	};
+
+	return ret;
+}
+
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 2788a6f2edcd..36fe2abb16e6 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -547,7 +547,7 @@ xfs_attri_item_recover(
 	struct xfs_inode		*ip;
 	struct xfs_da_args		*args;
 	struct xfs_trans		*tp;
-	struct xfs_trans_res		tres;
+	struct xfs_trans_res		resv;
 	struct xfs_attri_log_format	*attrp;
 	struct xfs_attri_log_nameval	*nv = attrip->attri_nameval;
 	int				error;
@@ -618,8 +618,9 @@ xfs_attri_item_recover(
 		goto out;
 	}
 
-	xfs_init_attr_trans(args, &tres, &total);
-	error = xfs_trans_alloc(mp, &tres, total, 0, XFS_TRANS_RESERVE, &tp);
+	xfs_init_attr_trans(args, &resv, &total);
+	resv = xlog_recover_resv(&resv);
+	error = xfs_trans_alloc(mp, &resv, total, 0, XFS_TRANS_RESERVE, &tp);
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 7551c3ec4ea5..e736a0844c89 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -490,6 +490,7 @@ xfs_bui_item_recover(
 	struct list_head		*capture_list)
 {
 	struct xfs_bmap_intent		fake = { };
+	struct xfs_trans_res		resv;
 	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip = NULL;
@@ -515,7 +516,8 @@ xfs_bui_item_recover(
 		return error;
 
 	/* Allocate transaction and do the work. */
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
+	error = xfs_trans_alloc(mp, &resv,
 			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
 	if (error)
 		goto err_rele;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index f1a5ecf099aa..3fa8789820ad 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -660,6 +660,7 @@ xfs_efi_item_recover(
 	struct xfs_log_item		*lip,
 	struct list_head		*capture_list)
 {
+	struct xfs_trans_res		resv;
 	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
 	struct xfs_mount		*mp = lip->li_log->l_mp;
 	struct xfs_efd_log_item		*efdp;
@@ -683,7 +684,8 @@ xfs_efi_item_recover(
 		}
 	}
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
+	error = xfs_trans_alloc(mp, &resv, 0, 0, 0, &tp);
 	if (error)
 		return error;
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index edd8587658d5..2d4444d61e98 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -477,6 +477,7 @@ xfs_cui_item_recover(
 	struct xfs_log_item		*lip,
 	struct list_head		*capture_list)
 {
+	struct xfs_trans_res		resv;
 	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
 	struct xfs_cud_log_item		*cudp;
 	struct xfs_trans		*tp;
@@ -514,8 +515,9 @@ xfs_cui_item_recover(
 	 * doesn't fit.  We need to reserve enough blocks to handle a
 	 * full btree split on either end of the refcount range.
 	 */
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
-			mp->m_refc_maxlevels * 2, 0, XFS_TRANS_RESERVE, &tp);
+	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
+	error = xfs_trans_alloc(mp, &resv, mp->m_refc_maxlevels * 2, 0,
+			XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 520c7ebdfed8..0e0e747028da 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -507,6 +507,7 @@ xfs_rui_item_recover(
 	struct xfs_log_item		*lip,
 	struct list_head		*capture_list)
 {
+	struct xfs_trans_res		resv;
 	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
 	struct xfs_rud_log_item		*rudp;
 	struct xfs_trans		*tp;
@@ -530,8 +531,9 @@ xfs_rui_item_recover(
 		}
 	}
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
-			mp->m_rmap_maxlevels, 0, XFS_TRANS_RESERVE, &tp);
+	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);
+	error = xfs_trans_alloc(mp, &resv, mp->m_rmap_maxlevels, 0,
+			XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
 	rudp = xfs_trans_get_rud(tp, ruip);

