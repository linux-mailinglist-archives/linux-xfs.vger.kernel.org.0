Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A23709DB5
	for <lists+linux-xfs@lfdr.de>; Fri, 19 May 2023 19:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjESRSq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 19 May 2023 13:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjESRSp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 May 2023 13:18:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B4D9E
        for <linux-xfs@vger.kernel.org>; Fri, 19 May 2023 10:18:43 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34JFx6tk005912;
        Fri, 19 May 2023 17:18:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-03-30; bh=zL62oFkkhG6mV5ZQxqLAluGJ2c9nLFWFXIf4XUoOnT8=;
 b=MIxzuvx8G+m8CZOVRKl8/SeFmmw8dxDW2AgOe5Zqz0zbkKlY8lcTrC4rYMp1IyJrqR8s
 wLfOeS/Nd9KudfWi9jS9weMEYQX6rPsUz8rHodliKkdVyrFeyYA1Ry4c4LsEvmhbeSwf
 gHkdLC1UZ9VKnncwqaXvuRmlmmqNUPifrJ8TZShC0XyGkMxeUx/N0cPEA/pEHlUkFaGF
 CoJp3WWEWx80BrjVCf60KDuo9Sg/4V7gPFlEaFoVvGqxEwuOwlImhjaTZpPpYPuwr5Zl
 PSPgNe+gZcXexbnAs7S0CBE3nrIemyZwJk+DAOEv5v6tPP7GNFVZecxQsU8Hp3Wn/jiM fQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj0yeakkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 17:18:38 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34JGDxgk025051;
        Fri, 19 May 2023 17:18:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj108b77d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 17:18:37 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34JHIaNk018804;
        Fri, 19 May 2023 17:18:36 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-248-172.vpn.oracle.com [10.159.248.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qj108b72u-1;
        Fri, 19 May 2023 17:18:36 +0000
From:   Wengang Wang <wen.gang.wang@oracle.com>
To:     linux-xfs@vger.kernel.org, djwong@kernel.org, david@fromorbit.com
Cc:     wen.gang.wang@oracle.com
Subject: [PATCH] xfs: Don't block in xfs_extent_busy_flush
Date:   Fri, 19 May 2023 10:18:29 -0700
Message-Id: <20230519171829.4108-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_12,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305190148
X-Proofpoint-ORIG-GUID: S4izVEx_nY41uS78dagou1ZRAu3Yz5Mr
X-Proofpoint-GUID: S4izVEx_nY41uS78dagou1ZRAu3Yz5Mr
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The following calltrace is seen:
	#0	context_switch() kernel/sched/core.c:3881
	#1	__schedule() kernel/sched/core.c:5111
	#2	schedule() kernel/sched/core.c:5186
	#3	xfs_extent_busy_flush() fs/xfs/xfs_extent_busy.c:598
	#4	xfs_alloc_ag_vextent_size() fs/xfs/libxfs/xfs_alloc.c:1641
	#5	xfs_alloc_ag_vextent() fs/xfs/libxfs/xfs_alloc.c:828
	#6	xfs_alloc_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:2362
	#7	xfs_free_extent_fix_freelist() fs/xfs/libxfs/xfs_alloc.c:3029
	#8	__xfs_free_extent() fs/xfs/libxfs/xfs_alloc.c:3067
	#9	xfs_trans_free_extent() fs/xfs/xfs_extfree_item.c:370
	#10	xfs_efi_recover() fs/xfs/xfs_extfree_item.c:626
	#11	xlog_recover_process_efi() fs/xfs/xfs_log_recover.c:4605
	#12	xlog_recover_process_intents() fs/xfs/xfs_log_recover.c:4893
	#13	xlog_recover_finish() fs/xfs/xfs_log_recover.c:5824
	#14	xfs_log_mount_finish() fs/xfs/xfs_log.c:764
	#15	xfs_mountfs() fs/xfs/xfs_mount.c:978
	#16	xfs_fs_fill_super() fs/xfs/xfs_super.c:1908
	#17	mount_bdev() fs/super.c:1417
	#18	xfs_fs_mount() fs/xfs/xfs_super.c:1985
	#19	legacy_get_tree() fs/fs_context.c:647
	#20	vfs_get_tree() fs/super.c:1547
	#21	do_new_mount() fs/namespace.c:2843
	#22	do_mount() fs/namespace.c:3163
	#23	ksys_mount() fs/namespace.c:3372
	#24	__do_sys_mount() fs/namespace.c:3386
	#25	__se_sys_mount() fs/namespace.c:3383
	#26	__x64_sys_mount() fs/namespace.c:3383
	#27	do_syscall_64() arch/x86/entry/common.c:296
	#28	entry_SYSCALL_64() arch/x86/entry/entry_64.S:180

During the process of the 2nd and subsequetial record in an EFI.
It is waiting for the busy blocks to be cleaned, but the only busy extent
is still hold in current xfs_trans->t_busy. That busy extent was added when
processing previous EFI record. And because that busy extent is not committed
yet, it can't be cleaned.

To avoid above deadlock, we don't block in xfs_extent_busy_flush() when
allocating AGFL blocks, instead it returns -EAGAIN. On receiving -EAGAIN
we are able to retry that EFI record with a new transaction after committing
the old transactin. With old transaction committed, the busy extent attached
to the old transaction get the change to be cleaned. On the retry, there is
no existing busy extents in the new transaction, thus no deadlock.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 30 ++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_alloc.h |  2 ++
 fs/xfs/scrub/repair.c     |  4 ++--
 fs/xfs/xfs_extent_busy.c  | 34 +++++++++++++++++++++++++++++-----
 fs/xfs/xfs_extent_busy.h  |  6 +++---
 fs/xfs/xfs_extfree_item.c | 37 ++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_log_recover.c  | 23 ++++++++++-------------
 fs/xfs/xfs_trans_ail.c    |  2 +-
 fs/xfs/xfs_trans_priv.h   |  1 +
 9 files changed, 108 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 203f16c48c19..abfd2acb3053 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1491,6 +1491,7 @@ STATIC int
 xfs_alloc_ag_vextent_near(
 	struct xfs_alloc_arg	*args)
 {
+	int			flags = args->flags | XFS_ALLOC_FLAG_TRYFLUSH;
 	struct xfs_alloc_cur	acur = {};
 	int			error;		/* error code */
 	int			i;		/* result code, temporary */
@@ -1564,8 +1565,11 @@ xfs_alloc_ag_vextent_near(
 	if (!acur.len) {
 		if (acur.busy) {
 			trace_xfs_alloc_near_busy(args);
-			xfs_extent_busy_flush(args->mp, args->pag,
-					      acur.busy_gen);
+			error = xfs_extent_busy_flush(args->tp, args->pag,
+					      acur.busy_gen, flags);
+			if (error)
+				goto out;
+			flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
 			goto restart;
 		}
 		trace_xfs_alloc_size_neither(args);
@@ -1592,6 +1596,7 @@ STATIC int				/* error */
 xfs_alloc_ag_vextent_size(
 	xfs_alloc_arg_t	*args)		/* allocation argument structure */
 {
+	int		flags = args->flags | XFS_ALLOC_FLAG_TRYFLUSH;
 	struct xfs_agf	*agf = args->agbp->b_addr;
 	struct xfs_btree_cur *bno_cur;	/* cursor for bno btree */
 	struct xfs_btree_cur *cnt_cur;	/* cursor for cnt btree */
@@ -1670,8 +1675,13 @@ xfs_alloc_ag_vextent_size(
 				xfs_btree_del_cursor(cnt_cur,
 						     XFS_BTREE_NOERROR);
 				trace_xfs_alloc_size_busy(args);
-				xfs_extent_busy_flush(args->mp,
-							args->pag, busy_gen);
+				error = xfs_extent_busy_flush(args->tp, args->pag,
+						busy_gen, flags);
+				if (error) {
+					cnt_cur = NULL;
+					goto error0;
+				}
+				flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
 				goto restart;
 			}
 		}
@@ -1755,7 +1765,13 @@ xfs_alloc_ag_vextent_size(
 		if (busy) {
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 			trace_xfs_alloc_size_busy(args);
-			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
+			error = xfs_extent_busy_flush(args->tp, args->pag,
+					busy_gen, flags);
+			if (error) {
+				cnt_cur = NULL;
+				goto error0;
+			}
+			flags &= ~XFS_ALLOC_FLAG_TRYFLUSH;
 			goto restart;
 		}
 		goto out_nominleft;
@@ -2629,6 +2645,7 @@ xfs_alloc_fix_freelist(
 	targs.agno = args->agno;
 	targs.alignment = targs.minlen = targs.prod = 1;
 	targs.pag = pag;
+	targs.flags = args->flags & XFS_ALLOC_FLAG_FREEING;
 	error = xfs_alloc_read_agfl(pag, tp, &agflbp);
 	if (error)
 		goto out_agbp_relse;
@@ -3572,6 +3589,7 @@ xfs_free_extent_fix_freelist(
 	args.mp = tp->t_mountp;
 	args.agno = pag->pag_agno;
 	args.pag = pag;
+	args.flags = XFS_ALLOC_FLAG_FREEING;
 
 	/*
 	 * validate that the block number is legal - the enables us to detect
@@ -3580,7 +3598,7 @@ xfs_free_extent_fix_freelist(
 	if (args.agno >= args.mp->m_sb.sb_agcount)
 		return -EFSCORRUPTED;
 
-	error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
+	error = xfs_alloc_fix_freelist(&args, args.flags);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 2b246d74c189..5038fba87784 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -24,6 +24,7 @@ unsigned int xfs_agfl_size(struct xfs_mount *mp);
 #define	XFS_ALLOC_FLAG_NORMAP	0x00000004  /* don't modify the rmapbt */
 #define	XFS_ALLOC_FLAG_NOSHRINK	0x00000008  /* don't shrink the freelist */
 #define	XFS_ALLOC_FLAG_CHECK	0x00000010  /* test only, don't modify args */
+#define	XFS_ALLOC_FLAG_TRYFLUSH	0x00000020  /* don't block in busyextent flush*/
 
 /*
  * Argument structure for xfs_alloc routines.
@@ -57,6 +58,7 @@ typedef struct xfs_alloc_arg {
 #ifdef DEBUG
 	bool		alloc_minlen_only; /* allocate exact minlen extent */
 #endif
+	int		flags;		/* XFS_ALLOC_FLAG_* */
 } xfs_alloc_arg_t;
 
 /*
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 1b71174ec0d6..2ba28e4257fe 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -496,9 +496,9 @@ xrep_fix_freelist(
 	args.agno = sc->sa.pag->pag_agno;
 	args.alignment = 1;
 	args.pag = sc->sa.pag;
+	args.flags = can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK;
 
-	return xfs_alloc_fix_freelist(&args,
-			can_shrink ? 0 : XFS_ALLOC_FLAG_NOSHRINK);
+	return xfs_alloc_fix_freelist(&args, args.flags);
 }
 
 /*
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index f3d328e4a440..ea1c1857bf5b 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -567,18 +567,41 @@ xfs_extent_busy_clear(
 /*
  * Flush out all busy extents for this AG.
  */
-void
+int
 xfs_extent_busy_flush(
-	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
 	struct xfs_perag	*pag,
-	unsigned		busy_gen)
+	unsigned		busy_gen,
+	int			flags)
 {
 	DEFINE_WAIT		(wait);
 	int			error;
 
-	error = xfs_log_force(mp, XFS_LOG_SYNC);
+	error = xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
 	if (error)
-		return;
+		return error;
+
+	/*
+	 * If we are holding busy extents, the caller may not want to block
+	 * straight away. If we are being told just to try a flush or progress
+	 * has been made since we last skipped a busy extent, return
+	 * immediately to allow the caller to try again. If we are freeing
+	 * extents, we might actually be holding the only free extents in the
+	 * transaction busy list and the log force won't resolve that
+	 * situation. In this case, return -EAGAIN in that case to tell the
+	 * caller it needs to commit the busy extents it holds before retrying
+	 * the extent free operation.
+	 */
+	if (!list_empty(&tp->t_busy)) {
+		if (flags & XFS_ALLOC_FLAG_TRYFLUSH)
+			return 0;
+
+		if (busy_gen != READ_ONCE(pag->pagb_gen))
+			return 0;
+
+		if (flags & XFS_ALLOC_FLAG_FREEING)
+			return -EAGAIN;
+	}
 
 	do {
 		prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
@@ -588,6 +611,7 @@ xfs_extent_busy_flush(
 	} while (1);
 
 	finish_wait(&pag->pagb_wait, &wait);
+	return 0;
 }
 
 void
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 4a118131059f..edeedb92e0df 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -51,9 +51,9 @@ bool
 xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t *bno,
 		xfs_extlen_t *len, unsigned *busy_gen);
 
-void
-xfs_extent_busy_flush(struct xfs_mount *mp, struct xfs_perag *pag,
-	unsigned busy_gen);
+int
+xfs_extent_busy_flush(struct xfs_trans *tp, struct xfs_perag *pag,
+	unsigned busy_gen, int flags);
 
 void
 xfs_extent_busy_wait_all(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 011b50469301..3c5a9e9952ec 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -336,6 +336,25 @@ xfs_trans_get_efd(
 	return efdp;
 }
 
+/*
+ * Fill the EFD with all extents from the EFI and set the counter.
+ * Note: the EFD should comtain at least one extents already.
+ */
+static void xfs_fill_efd_with_efi(struct xfs_efd_log_item *efdp)
+{
+	struct xfs_efi_log_item *efip = efdp->efd_efip;
+	uint                    i;
+
+	if (efdp->efd_next_extent == efip->efi_format.efi_nextents)
+		return;
+
+	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
+	       efdp->efd_format.efd_extents[i] =
+		       efip->efi_format.efi_extents[i];
+	}
+	efdp->efd_next_extent = efip->efi_format.efi_nextents;
+}
+
 /*
  * Free an extent and log it to the EFD. Note that the transaction is marked
  * dirty regardless of whether the extent free succeeds or fails to support the
@@ -369,6 +388,10 @@ xfs_trans_free_extent(
 	error = __xfs_free_extent(tp, xefi->xefi_startblock,
 			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
 			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
+	if (error == -EAGAIN) {
+		xfs_fill_efd_with_efi(efdp);
+		return error;
+	}
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
@@ -476,7 +499,8 @@ xfs_extent_free_finish_item(
 	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
 
 	error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
-	kmem_cache_free(xfs_extfree_item_cache, xefi);
+	if (error != -EAGAIN)
+		kmem_cache_free(xfs_extfree_item_cache, xefi);
 	return error;
 }
 
@@ -633,6 +657,17 @@ xfs_efi_item_recover(
 		fake.xefi_blockcount = extp->ext_len;
 
 		error = xfs_trans_free_extent(tp, efdp, &fake);
+		if (error == -EAGAIN) {
+			xfs_free_extent_later(tp, fake.xefi_startblock,
+				fake.xefi_blockcount, &XFS_RMAP_OINFO_ANY_OWNER);
+			/*
+			 * try to free as many extents as possible with current
+			 * transaction
+			 */
+			error = 0;
+			continue;
+		};
+
 		if (error == -EFSCORRUPTED)
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					extp, sizeof(*extp));
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 322eb2ee6c55..00bfe9683fa8 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2540,30 +2540,27 @@ xlog_recover_process_intents(
 	struct xfs_log_item	*lip;
 	struct xfs_ail		*ailp;
 	int			error = 0;
-#if defined(DEBUG) || defined(XFS_WARN)
-	xfs_lsn_t		last_lsn;
-#endif
+	xfs_lsn_t		threshold_lsn;
 
 	ailp = log->l_ailp;
+	threshold_lsn = xfs_ail_max_lsn(ailp);
 	spin_lock(&ailp->ail_lock);
-#if defined(DEBUG) || defined(XFS_WARN)
-	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
-#endif
+
 	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
 	     lip != NULL;
 	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
 		const struct xfs_item_ops	*ops;
+		/*
+		 * Orignal redo EFI could be splitted into new EFIs. Those
+		 * new EFIs are supposed to be processed in capture_list.
+		 * Stop here when original redo intents are done.
+		 */
+		if (XFS_LSN_CMP(threshold_lsn, lip->li_lsn) < 0)
+			break;
 
 		if (!xlog_item_is_intent(lip))
 			break;
 
-		/*
-		 * We should never see a redo item with a LSN higher than
-		 * the last transaction we found in the log at the start
-		 * of recovery.
-		 */
-		ASSERT(XFS_LSN_CMP(last_lsn, lip->li_lsn) >= 0);
-
 		/*
 		 * NOTE: If your intent processing routine can create more
 		 * deferred ops, you /must/ attach them to the capture list in
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 7d4109af193e..2825f55eca88 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -137,7 +137,7 @@ xfs_ail_min_lsn(
 /*
  * Return the maximum lsn held in the AIL, or zero if the AIL is empty.
  */
-static xfs_lsn_t
+xfs_lsn_t
 xfs_ail_max_lsn(
 	struct xfs_ail		*ailp)
 {
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index d5400150358e..86b4f29b2a6e 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -106,6 +106,7 @@ void			xfs_ail_push_all(struct xfs_ail *);
 void			xfs_ail_push_all_sync(struct xfs_ail *);
 struct xfs_log_item	*xfs_ail_min(struct xfs_ail  *ailp);
 xfs_lsn_t		xfs_ail_min_lsn(struct xfs_ail *ailp);
+xfs_lsn_t		xfs_ail_max_lsn(struct xfs_ail *ailp);
 
 struct xfs_log_item *	xfs_trans_ail_cursor_first(struct xfs_ail *ailp,
 					struct xfs_ail_cursor *cur,
-- 
2.21.0 (Apple Git-122.2)

