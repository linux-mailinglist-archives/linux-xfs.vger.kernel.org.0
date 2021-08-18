Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2B83EF63A
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Aug 2021 01:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbhHQXnI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Aug 2021 19:43:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229466AbhHQXnI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:43:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FF1B61008;
        Tue, 17 Aug 2021 23:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629243754;
        bh=s65d65r45g9PGTvEC94M6CIJiZYNcC1WcHCkxNfYp64=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=p/fDpY7zRKPWVOv4Sz1kYN841cepXgueTqvhoTcnA6Uqdr3Frwkim/KivLN65yMj7
         S5SPtfw5aO5CSQmzAfQ3I2Gj8pQDQXsoFB0+WW/ycYT6Dn0R9KoP+FzIcjqjFgOjpv
         jTObJyWtPBSLUXw3YHs2V9iRlRf/ycF7sIu7akX/1P9mrGyYfV6fEi8K4db99es063
         A2Hc3owt1XTAZpuOv4iGAF6f8WWve5ER1gFEoVbn6f+wKLfIVuo737JWhoQvLW8/NF
         zoQyAbwMaEgpUCSnTzoXRk9XERVAdTDgfAjk/+0a1UxjKJTYFEPXJ1I7Exgd5cWQNV
         iLXkMYR3fqLGg==
Subject: [PATCH 04/15] xfs: standardize AG block number formatting in ftrace
 output
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 17 Aug 2021 16:42:34 -0700
Message-ID: <162924375404.761813.16085072027749593088.stgit@magnolia>
In-Reply-To: <162924373176.761813.10896002154570305865.stgit@magnolia>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Always print allocation group block numbers in hexadecimal and preceded
with the unit "agbno".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h |   24 ++++++++++++------------
 fs/xfs/xfs_trace.h   |   46 +++++++++++++++++++++++-----------------------
 2 files changed, 35 insertions(+), 35 deletions(-)


diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 3676b1736bab..49822589a4ae 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -145,7 +145,7 @@ TRACE_EVENT(xchk_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %s agno 0x%x agbno %u error %d ret_ip %pS",
+	TP_printk("dev %d:%d type %s agno 0x%x agbno 0x%x error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __entry->agno,
@@ -203,7 +203,7 @@ DECLARE_EVENT_CLASS(xchk_block_error_class,
 		__entry->agbno = xfs_daddr_to_agbno(sc->mp, daddr);
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %s agno 0x%x agbno %u ret_ip %pS",
+	TP_printk("dev %d:%d type %s agno 0x%x agbno 0x%x ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __entry->agno,
@@ -338,7 +338,7 @@ TRACE_EVENT(xchk_btree_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno 0x%x agbno %u error %d ret_ip %pS",
+	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
@@ -381,7 +381,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno 0x%x agbno %u error %d ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
@@ -420,7 +420,7 @@ TRACE_EVENT(xchk_btree_error,
 		__entry->ptr = cur->bc_ptrs[level];
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno 0x%x agbno %u ret_ip %pS",
+	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
@@ -460,7 +460,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
 		__entry->ptr = cur->bc_ptrs[level];
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno 0x%x agbno %u ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx fork %d type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->whichfork,
@@ -499,7 +499,7 @@ DECLARE_EVENT_CLASS(xchk_sbtree_class,
 		__entry->nlevels = cur->bc_nlevels;
 		__entry->ptr = cur->bc_ptrs[level];
 	),
-	TP_printk("dev %d:%d type %s btree %s agno 0x%x agbno %u level %d nlevels %d ptr %d",
+	TP_printk("dev %d:%d type %s btree %s agno 0x%x agbno 0x%x level %d nlevels %d ptr %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
@@ -662,7 +662,7 @@ DECLARE_EVENT_CLASS(xrep_extent_class,
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u len %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -699,7 +699,7 @@ DECLARE_EVENT_CLASS(xrep_rmap_class,
 		__entry->offset = offset;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u len %u owner %lld offset %llu flags 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner %lld offset %llu flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -737,7 +737,7 @@ TRACE_EVENT(xrep_refcount_extent_fn,
 		__entry->blockcount = irec->rc_blockcount;
 		__entry->refcount = irec->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startblock,
@@ -761,7 +761,7 @@ TRACE_EVENT(xrep_init_btblock,
 		__entry->agbno = agbno;
 		__entry->btnum = btnum;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u btree %s",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x btree %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -785,7 +785,7 @@ TRACE_EVENT(xrep_findroot_block,
 		__entry->magic = magic;
 		__entry->level = level;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u magic 0x%x level %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x magic 0x%x level %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 9ddc710c1be9..a780b1752ede 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1601,7 +1601,7 @@ DECLARE_EVENT_CLASS(xfs_extent_busy_class,
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u len %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -1639,7 +1639,7 @@ TRACE_EVENT(xfs_extent_busy_trim,
 		__entry->tbno = tbno;
 		__entry->tlen = tlen;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u len %u tbno %u tlen %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u found_agbno 0x%x tlen %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -1735,7 +1735,7 @@ TRACE_EVENT(xfs_free_extent,
 		__entry->haveleft = haveleft;
 		__entry->haveright = haveright;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u len %u resv %d %s",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u resv %d %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -1792,7 +1792,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
 		__entry->datatype = args->datatype;
 		__entry->firstblock = args->tp->t_firstblock;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u minlen %u maxlen %u mod %u "
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x minlen %u maxlen %u mod %u "
 		  "prod %u minleft %u total %u alignment %u minalignslop %u "
 		  "len %u type %s otype %s wasdel %d wasfromfl %d resv %d "
 		  "datatype 0x%x firstblock 0x%llx",
@@ -1870,7 +1870,7 @@ TRACE_EVENT(xfs_alloc_cur_check,
 		__entry->diff = diff;
 		__entry->new = new;
 	),
-	TP_printk("dev %d:%d btree %s bno 0x%x len 0x%x diff 0x%x new %d",
+	TP_printk("dev %d:%d btree %s agbno 0x%x len 0x%x diff 0x%x new %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
 		  __entry->bno, __entry->len, __entry->diff, __entry->new)
@@ -2363,7 +2363,7 @@ DECLARE_EVENT_CLASS(xfs_log_recover_icreate_item_class,
 		__entry->length = be32_to_cpu(in_f->icl_length);
 		__entry->gen = be32_to_cpu(in_f->icl_gen);
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u count %u isize %u length %u "
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x count %u isize %u length %u "
 		  "gen %u", MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno, __entry->agbno, __entry->count, __entry->isize,
 		  __entry->length, __entry->gen)
@@ -2392,7 +2392,7 @@ DECLARE_EVENT_CLASS(xfs_discard_class,
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u len %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -2551,7 +2551,7 @@ DECLARE_EVENT_CLASS(xfs_phys_extent_deferred_class,
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d op %d agno 0x%x agbno %u len %u",
+	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x len %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->agno,
@@ -2598,7 +2598,7 @@ DECLARE_EVENT_CLASS(xfs_map_extent_deferred_class,
 		__entry->l_state = state;
 		__entry->op = op;
 	),
-	TP_printk("dev %d:%d op %d agno 0x%x agbno %u owner %lld %s offset %llu len %llu state %d",
+	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner %lld %s offset %llu len %llu state %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->op,
 		  __entry->agno,
@@ -2668,7 +2668,7 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 		if (unwritten)
 			__entry->flags |= XFS_RMAP_UNWRITTEN;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u len %u owner %lld offset %llu flags 0x%lx",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner %lld offset %llu flags 0x%lx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -2748,7 +2748,7 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 		__entry->offset = offset;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u len %u owner %lld offset %llu flags 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u owner %lld offset %llu flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -2870,7 +2870,7 @@ DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
 		__entry->agbno = agbno;
 		__entry->dir = dir;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u cmp %s(%d)",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x cmp %s(%d)",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->agbno,
@@ -2903,7 +2903,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 		__entry->blockcount = irec->rc_blockcount;
 		__entry->refcount = irec->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startblock,
@@ -2938,7 +2938,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
 		__entry->refcount = irec->rc_refcount;
 		__entry->agbno = agbno;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u @ agbno %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u @ agbno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->startblock,
@@ -2978,8 +2978,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 		__entry->i2_blockcount = i2->rc_blockcount;
 		__entry->i2_refcount = i2->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u -- "
-		  "agbno %u len %u refcount %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u -- "
+		  "agbno 0x%x len %u refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->i1_startblock,
@@ -3024,8 +3024,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 		__entry->i2_refcount = i2->rc_refcount;
 		__entry->agbno = agbno;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u -- "
-		  "agbno %u len %u refcount %u @ agbno %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u -- "
+		  "agbno 0x%x len %u refcount %u @ agbno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->i1_startblock,
@@ -3076,9 +3076,9 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 		__entry->i3_blockcount = i3->rc_blockcount;
 		__entry->i3_refcount = i3->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno %u len %u refcount %u -- "
-		  "agbno %u len %u refcount %u -- "
-		  "agbno %u len %u refcount %u",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x len %u refcount %u -- "
+		  "agbno 0x%x len %u refcount %u -- "
+		  "agbno 0x%x len %u refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->agno,
 		  __entry->i1_startblock,
@@ -3165,7 +3165,7 @@ TRACE_EVENT(xfs_refcount_finish_one_leftover,
 		__entry->new_agbno = new_agbno;
 		__entry->new_len = new_len;
 	),
-	TP_printk("dev %d:%d type %d agno 0x%x agbno %u len %u new_agbno %u new_len %u",
+	TP_printk("dev %d:%d type %d agno 0x%x agbno 0x%x len %u new_agbno 0x%x new_len %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->agno,
@@ -3930,7 +3930,7 @@ TRACE_EVENT(xfs_btree_bload_block,
 		}
 		__entry->nr_records = nr_records;
 	),
-	TP_printk("dev %d:%d btree %s level %u block %llu/%llu agno 0x%x agbno %u recs %u",
+	TP_printk("dev %d:%d btree %s level %u block %llu/%llu agno 0x%x agbno 0x%x recs %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
 		  __entry->level,

