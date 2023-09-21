Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCEA7A908E
	for <lists+linux-xfs@lfdr.de>; Thu, 21 Sep 2023 03:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjIUBkA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 20 Sep 2023 21:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjIUBj7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2023 21:39:59 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB07BAB
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:39:52 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-690bd8f89baso360734b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695260392; x=1695865192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o1sCydzNwgDhwiOxlmWaW+T13wv02WNUL5B9sZGWGi8=;
        b=o1Du2ZHkc6Q9kC2lQBvXNv8LLdJDWL2a2T1A2DAU+27ChKL9LKg5EUzA+8rPRzeb2n
         gfii1GPsLANdgeIYbdlpe2c8jbJm3t6quFh4CgfG0PoP0bSRcv93sskkU129X4wCD7/6
         pPVNFM6+wVzE7DMir5UGR4UOtx92aQVvxX+0rTpwc6tRkqYwdf4iVvRCTVeMeCOGjgs9
         1QJTTa3bE3KdR27K+1HG1AsiVG62N/KFgGaxtg1eRcZ4X+Zvzmioi+Ak50uE7/BOaJ6M
         fi7lu/JoDCqY/zHXT+ArRjIBJFJMUjK81vVn5ShR8rI8kYUFGYjM7G97z0gJPjJPbsuR
         SdNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695260392; x=1695865192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o1sCydzNwgDhwiOxlmWaW+T13wv02WNUL5B9sZGWGi8=;
        b=bdjVf8Ng7Lsa6WY+6RG3FL4VYRSbNZs5aAQUyJ37k4JVhCbfSbrVUqn6V3aGzk3qzy
         7ADjWqP8imqPB4nmbhDrZm0AEM3nfI97Z6dczAclmUsU1b1mtANATYB4qA5ZhKCJooqs
         a1oaHq34a/Yp2hglUqA+Yd9efxkqimmwyEVUH2vey1+dW460ZRKIwi6OQnJ4ISFnzQj6
         c1eQpYDSWPFUwenHQE9CxVJAuWeI3uoZFb1aa5Coh22bagiP9YGODMECvl4lhuh2mobF
         1TLG9o//4VSwyQ7FNyEgGudxlvzdk/q41YBj2CdMfEo1lTqfTSk2w4TEhuSz1zIixFyg
         r7pw==
X-Gm-Message-State: AOJu0YxnC2BrQnUnvLzoc9Muqa/iW7g+FNnQ9ynWw4XgeDTeCIzbDqRo
        Z8ENOkXXP+1UAa6y26DVTg3nrZvINs2Hbv5RYzo=
X-Google-Smtp-Source: AGHT+IHDJh52gpkZ5pMcsPgA+tYD5pvXBdyMTmopLPuvsDXbMQnSSBl0Xltjjn7acbe80cc/8kihUQ==
X-Received: by 2002:a05:6a00:b44:b0:690:d413:ee13 with SMTP id p4-20020a056a000b4400b00690d413ee13mr4178471pfo.23.1695260392282;
        Wed, 20 Sep 2023 18:39:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id a24-20020aa78658000000b00690c0cf97c9sm155355pfo.73.2023.09.20.18.39.50
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 18:39:51 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qj8fT-003Sv2-1O
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:39:47 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qj8fT-00000002MHM-0kc6
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:39:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: reduce AGF hold times during fstrim operations
Date:   Thu, 21 Sep 2023 11:39:44 +1000
Message-Id: <20230921013945.559634-3-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230921013945.559634-1-david@fromorbit.com>
References: <20230921013945.559634-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

fstrim will hold the AGF lock for as long as it takes to walk and
discard all the free space in the AG that meets the userspace trim
criteria. For AGs with lots of free space extents (e.g. millions)
or the underlying device is really slow at processing discard
requests (e.g. Ceph RBD), this means the AGF hold time is often
measured in minutes to hours, not a few milliseconds as we normal
see with non-discard based operations.

This can result in the entire filesystem hanging whilst the
long-running fstrim is in progress. We can have transactions get
stuck waiting for the AGF lock (data or metadata extent allocation
and freeing), and then more transactions get stuck waiting on the
locks those transactions hold. We can get to the point where fstrim
blocks an extent allocation or free operation long enough that it
ends up pinning the tail of the log and the log then runs out of
space. At this point, every modification in the filesystem gets
blocked. This includes read operations, if atime updates need to be
made.

To fix this problem, we need to be able to discard free space
extents safely without holding the AGF lock. Fortunately, we already
do this with online discard via busy extents. We can mark free space
extents as "busy being discarded" under the AGF lock and then unlock
the AGF, knowing that nobody will be able to allocate that free
space extent until we remove it from the busy tree.

Modify xfs_trim_extents to use the same asynchronous discard
mechanism backed by busy extents as is used with online discard.
This results in the AGF only needing to be held for short periods of
time and it is never held while we issue discards. Hence if discard
submission gets throttled because it is slow and/or there are lots
of them, we aren't preventing other operations from being performed
on AGF while we wait for discards to complete...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_discard.c     | 174 +++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_extent_busy.c |  34 ++++++--
 fs/xfs/xfs_extent_busy.h |   4 +
 3 files changed, 188 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 3f45c7bb94f2..f16b254b5eaa 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -19,6 +19,56 @@
 #include "xfs_log.h"
 #include "xfs_ag.h"
 
+/*
+ * Notes on an efficient, low latency fstrim algorithm
+ *
+ * We need to walk the filesystem free space and issue discards on the free
+ * space that meet the search criteria (size and location). We cannot issue
+ * discards on extents that might be in use, or are so recently in use they are
+ * still marked as busy. To serialise against extent state changes whilst we are
+ * gathering extents to trim, we must hold the AGF lock to lock out other
+ * allocations and extent free operations that might change extent state.
+ *
+ * However, we cannot just hold the AGF for the entire AG free space walk whilst
+ * we issue discards on each free space that is found. Storage devices can have
+ * extremely slow discard implementations (e.g. ceph RBD) and so walking a
+ * couple of million free extents and issuing synchronous discards on each
+ * extent can take a *long* time. Whilst we are doing this walk, nothing else
+ * can access the AGF, and we can stall transactions and hence the log whilst
+ * modifications wait for the AGF lock to be released. This can lead hung tasks
+ * kicking the hung task timer and rebooting the system. This is bad.
+ *
+ * Hence we need to take a leaf from the bulkstat playbook. It takes the AGI
+ * lock, gathers a range of inode cluster buffers that are allocated, drops the
+ * AGI lock and then reads all the inode cluster buffers and processes them. It
+ * loops doing this, using a cursor to keep track of where it is up to in the AG
+ * for each iteration to restart the INOBT lookup from.
+ *
+ * We can't do this exactly with free space - once we drop the AGF lock, the
+ * state of the free extent is out of our control and we cannot run a discard
+ * safely on it in this situation. Unless, of course, we've marked the free
+ * extent as busy and undergoing a discard operation whilst we held the AGF
+ * locked.
+ *
+ * This is exactly how online discard works - free extents are marked busy when
+ * they are freed, and once the extent free has been committed to the journal,
+ * the busy extent record is marked as "undergoing discard" and the discard is
+ * then issued on the free extent. Once the discard completes, the busy extent
+ * record is removed and the extent is able to be allocated again.
+ *
+ * In the context of fstrim, if we find a free extent we need to discard, we
+ * don't have to discard it immediately. All we need to do it record that free
+ * extent as being busy and under discard, and all the allocation routines will
+ * now avoid trying to allocate it. Hence if we mark the extent as busy under
+ * the AGF lock, we can safely discard it without holding the AGF lock because
+ * nothing will attempt to allocate that free space until the discard completes.
+ *
+ * This also allows us to issue discards asynchronously like we do with online
+ * discard, and so for fast devices fstrim will run much faster as we can have
+ * multiple discard operations in flight at once, as well as pipeline the free
+ * extent search so that it overlaps in flight discard IO.
+ */
+
 struct workqueue_struct *xfs_discard_wq;
 
 static void
@@ -94,21 +144,22 @@ xfs_discard_extents(
 }
 
 
-STATIC int
-xfs_trim_extents(
+static int
+xfs_trim_gather_extents(
 	struct xfs_perag	*pag,
 	xfs_daddr_t		start,
 	xfs_daddr_t		end,
 	xfs_daddr_t		minlen,
+	struct xfs_alloc_rec_incore *tcur,
+	struct xfs_busy_extents	*extents,
 	uint64_t		*blocks_trimmed)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
-	struct block_device	*bdev = mp->m_ddev_targp->bt_bdev;
 	struct xfs_btree_cur	*cur;
 	struct xfs_buf		*agbp;
-	struct xfs_agf		*agf;
 	int			error;
 	int			i;
+	int			batch = 100;
 
 	/*
 	 * Force out the log.  This means any transactions that might have freed
@@ -120,20 +171,28 @@ xfs_trim_extents(
 	error = xfs_alloc_read_agf(pag, NULL, 0, &agbp);
 	if (error)
 		return error;
-	agf = agbp->b_addr;
 
 	cur = xfs_allocbt_init_cursor(mp, NULL, agbp, pag, XFS_BTNUM_CNT);
 
 	/*
-	 * Look up the longest btree in the AGF and start with it.
+	 * Look up the extent length requested in the AGF and start with it.
 	 */
-	error = xfs_alloc_lookup_ge(cur, 0, be32_to_cpu(agf->agf_longest), &i);
+	if (tcur->ar_startblock == NULLAGBLOCK)
+		error = xfs_alloc_lookup_ge(cur, 0, tcur->ar_blockcount, &i);
+	else
+		error = xfs_alloc_lookup_le(cur, tcur->ar_startblock,
+				tcur->ar_blockcount, &i);
 	if (error)
 		goto out_del_cursor;
+	if (i == 0) {
+		/* nothing of that length left in the AG, we are done */
+		tcur->ar_blockcount = 0;
+		goto out_del_cursor;
+	}
 
 	/*
 	 * Loop until we are done with all extents that are large
-	 * enough to be worth discarding.
+	 * enough to be worth discarding or we hit batch limits.
 	 */
 	while (i) {
 		xfs_agblock_t	fbno;
@@ -148,7 +207,16 @@ xfs_trim_extents(
 			error = -EFSCORRUPTED;
 			break;
 		}
-		ASSERT(flen <= be32_to_cpu(agf->agf_longest));
+
+		if (--batch <= 0) {
+			/*
+			 * Update the cursor to point at this extent so we
+			 * restart the next batch from this extent.
+			 */
+			tcur->ar_startblock = fbno;
+			tcur->ar_blockcount = flen;
+			break;
+		}
 
 		/*
 		 * use daddr format for all range/len calculations as that is
@@ -163,6 +231,7 @@ xfs_trim_extents(
 		 */
 		if (dlen < minlen) {
 			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
+			tcur->ar_blockcount = 0;
 			break;
 		}
 
@@ -185,29 +254,98 @@ xfs_trim_extents(
 			goto next_extent;
 		}
 
-		trace_xfs_discard_extent(mp, pag->pag_agno, fbno, flen);
-		error = blkdev_issue_discard(bdev, dbno, dlen, GFP_NOFS);
-		if (error)
-			break;
+		xfs_extent_busy_insert_discard(pag, fbno, flen,
+				&extents->extent_list);
 		*blocks_trimmed += flen;
-
 next_extent:
 		error = xfs_btree_decrement(cur, 0, &i);
 		if (error)
 			break;
 
-		if (fatal_signal_pending(current)) {
-			error = -ERESTARTSYS;
-			break;
-		}
+		/*
+		 * If there's no more records in the tree, we are done. Set the
+		 * cursor block count to 0 to indicate to the caller that there
+		 * is no more extents to search.
+		 */
+		if (i == 0)
+			tcur->ar_blockcount = 0;
 	}
 
+	/*
+	 * If there was an error, release all the gathered busy extents because
+	 * we aren't going to issue a discard on them any more.
+	 */
+	if (error)
+		xfs_extent_busy_clear(mp, &extents->extent_list, false);
 out_del_cursor:
 	xfs_btree_del_cursor(cur, error);
 	xfs_buf_relse(agbp);
 	return error;
 }
 
+/*
+ * Iterate the free list gathering extents and discarding them. We need a cursor
+ * for the repeated iteration of gather/discard loop, so use the longest extent
+ * we found in the last batch as the key to start the next.
+ */
+static int
+xfs_trim_extents(
+	struct xfs_perag	*pag,
+	xfs_daddr_t		start,
+	xfs_daddr_t		end,
+	xfs_daddr_t		minlen,
+	uint64_t		*blocks_trimmed)
+{
+	struct xfs_alloc_rec_incore tcur = {
+		.ar_blockcount = pag->pagf_longest,
+		.ar_startblock = NULLAGBLOCK,
+	};
+	int			error = 0;
+
+	do {
+		struct xfs_busy_extents	*extents;
+
+		extents = kzalloc(sizeof(*extents), GFP_KERNEL);
+		if (!extents) {
+			error = -ENOMEM;
+			break;
+		}
+
+		extents->mount = pag->pag_mount;
+		extents->owner = extents;
+		INIT_LIST_HEAD(&extents->extent_list);
+
+		error = xfs_trim_gather_extents(pag, start, end, minlen,
+				&tcur, extents, blocks_trimmed);
+		if (error) {
+			kfree(extents);
+			break;
+		}
+
+		/*
+		 * We hand the extent list to the discard function here so the
+		 * discarded extents can be removed from the busy extent list.
+		 * This allows the discards to run asynchronously with gathering
+		 * the next round of extents to discard.
+		 *
+		 * However, we must ensure that we do not reference the extent
+		 * list  after this function call, as it may have been freed by
+		 * the time control returns to us.
+		 */
+		error = xfs_discard_extents(pag->pag_mount, extents);
+		if (error)
+			break;
+
+		if (fatal_signal_pending(current)) {
+			error = -ERESTARTSYS;
+			break;
+		}
+	} while (tcur.ar_blockcount != 0);
+
+	return error;
+
+}
+
 /*
  * trim a range of the filesystem.
  *
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 7c2fdc71e42d..746814815b1d 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -19,13 +19,13 @@
 #include "xfs_log.h"
 #include "xfs_ag.h"
 
-void
-xfs_extent_busy_insert(
-	struct xfs_trans	*tp,
+static void
+xfs_extent_busy_insert_list(
 	struct xfs_perag	*pag,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
-	unsigned int		flags)
+	unsigned int		flags,
+	struct list_head	*busy_list)
 {
 	struct xfs_extent_busy	*new;
 	struct xfs_extent_busy	*busyp;
@@ -40,7 +40,7 @@ xfs_extent_busy_insert(
 	new->flags = flags;
 
 	/* trace before insert to be able to see failed inserts */
-	trace_xfs_extent_busy(tp->t_mountp, pag->pag_agno, bno, len);
+	trace_xfs_extent_busy(pag->pag_mount, pag->pag_agno, bno, len);
 
 	spin_lock(&pag->pagb_lock);
 	rbp = &pag->pagb_tree.rb_node;
@@ -62,10 +62,32 @@ xfs_extent_busy_insert(
 	rb_link_node(&new->rb_node, parent, rbp);
 	rb_insert_color(&new->rb_node, &pag->pagb_tree);
 
-	list_add(&new->list, &tp->t_busy);
+	list_add(&new->list, busy_list);
 	spin_unlock(&pag->pagb_lock);
 }
 
+void
+xfs_extent_busy_insert(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	unsigned int		flags)
+{
+	xfs_extent_busy_insert_list(pag, bno, len, flags, &tp->t_busy);
+}
+
+void
+xfs_extent_busy_insert_discard(
+	struct xfs_perag	*pag,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	struct list_head	*busy_list)
+{
+	xfs_extent_busy_insert_list(pag, bno, len, XFS_EXTENT_BUSY_DISCARDED,
+			busy_list);
+}
+
 /*
  * Search for a busy extent within the range of the extent we are about to
  * allocate.  You need to be holding the busy extent tree lock when calling
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 71c28d031e3b..0639aab336f3 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -49,6 +49,10 @@ void
 xfs_extent_busy_insert(struct xfs_trans *tp, struct xfs_perag *pag,
 	xfs_agblock_t bno, xfs_extlen_t len, unsigned int flags);
 
+void
+xfs_extent_busy_insert_discard(struct xfs_perag *pag, xfs_agblock_t bno,
+	xfs_extlen_t len, struct list_head *busy_list);
+
 void
 xfs_extent_busy_clear(struct xfs_mount *mp, struct list_head *list,
 	bool do_discard);
-- 
2.40.1

