Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA1D672B7E
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Jan 2023 23:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjARWp3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Jan 2023 17:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjARWpS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:18 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701AA63E37
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:15 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id d8so554681pjc.3
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ly/jS9/5RaSRPVrpPHMId5HTDzeZZNrP+19hXgBzcaQ=;
        b=LaZotMHzH8jDORzVv61p/LFhg1rAqPVmsjrI1EaMFT0n0ls3TKgU3cugudDoM8KAIC
         oe1lAa29tfrrzsPFF6H3MJyAESxNLR/cT+nGj4Z7/nTuxUOG//AusT//xyVPloJ32VQ2
         3gPAtizlZum71gOiaUFkbf/5weDVmL6KygDIreYKrDCnGCxJwA2B/S+1fdkUGKm6T+1W
         o+VaqOowCWiWadcPj9SkTSNFAOit3k1cc0hpTSJggq8rB0wjevZU6gGkBjBXRCx0qkwB
         jBeg8L95v1sVbk9kU33gow6mwhzANHducrbnCbhQzL1b/tBWufDbK6TVF9Jj+64AK1dB
         hGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ly/jS9/5RaSRPVrpPHMId5HTDzeZZNrP+19hXgBzcaQ=;
        b=DJKLDVpiK1/X4ou4yhL574J8yILh/yg155eH0gy8aTy0i4QiekYN90EDGxFlSQqwhv
         rIKoPZFatKY78IxBjySsTpYZSrurb7mXYprovmKAx4oFz38RQZX4AOeU4He3CpqzhPov
         Kn/VxMmQeAJan7eN9ztVbuvX4EU/aIxgqNn81w0yDqOmVI9p50f6CAglaQobhSnO+0NN
         ONpbOh4zrr3nOUHaMYN+FP/vKHP96HdmnDCsPIhP4lMHLk1n8VZ0/3l3iIEsjeP04A7D
         FbYNpT+810uC4mpypsfZdgxc6dhqHuSUDPJJiuYrPgVMmX33UvzQaM3xNhC0xPUSGzN/
         Jaew==
X-Gm-Message-State: AFqh2kpD2nIFMmM+8DWL9L6ZAWr9VwFQMW1bixyb1YeSjhCy9c2yyW4E
        o/Hx/RDlOIMuLz/sbohcrLQ8OrsbsJQLXZhS
X-Google-Smtp-Source: AMrXdXt10hf7gfyVNqQIbWt8XeChJwDl5/aUnw8YVTvuFx5DBdjzM00jWa/9pjsYuvpR1nMDMnIIew==
X-Received: by 2002:a05:6a20:9e4a:b0:af:ee05:fd0b with SMTP id mt10-20020a056a209e4a00b000afee05fd0bmr8554987pzb.3.1674081914842;
        Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id q7-20020aa78427000000b00580978caca7sm16326716pfn.45.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB8-004iWv-W3
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB8-008FD4-3D
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/42] xfs: active perag reference counting
Date:   Thu, 19 Jan 2023 09:44:30 +1100
Message-Id: <20230118224505.1964941-8-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We need to be able to dynamically remove instantiated AGs from
memory safely, either for shrinking the filesystem or paging AG
state in and out of memory (e.g. supporting millions of AGs). This
means we need to be able to safely exclude operations from accessing
perags while dynamic removal is in progress.

To do this, introduce the concept of active and passive references.
Active references are required for high level operations that make
use of an AG for a given operation (e.g. allocation) and pin the
perag in memory for the duration of the operation that is operating
on the perag (e.g. transaction scope). This means we can fail to get
an active reference to an AG, hence callers of the new active
reference API must be able to handle lookup failure gracefully.

Passive references are used in low level code, where we might need
to access the perag structure for the purposes of completing high
level operations. For example, buffers need to use passive
references because:
- we need to be able to do metadata IO during operations like grow
  and shrink transactions where high level active references to the
  AG have already been blocked
- buffers need to pin the perag until they are reclaimed from
  memory, something that high level code has no direct control over.
- unused cached buffers should not prevent a shrink from being
  started.

Hence we have active references that will form exclusion barriers
for operations to be performed on an AG, and passive references that
will prevent reclaim of the perag until all objects with passive
references have been reclaimed themselves.

This patch introduce xfs_perag_grab()/xfs_perag_rele() as the API
for active AG reference functionality. We also need to convert the
for_each_perag*() iterators to use active references, which will
start the process of converting high level code over to using active
references. Conversion of non-iterator based code to active
references will be done in followup patches.

Note that the implementation using reference counting is really just
a development vehicle for the API to ensure we don't have any leaks
in the callers. Once we need to remove perag structures from memory
dyanmically, we will need a much more robust per-ag state transition
mechanism for preventing new references from being taken while we
wait for existing references to drain before removal from memory can
occur....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c    | 70 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h    | 31 ++++++++++++-----
 fs/xfs/scrub/bmap.c       |  2 +-
 fs/xfs/scrub/fscounters.c |  4 +--
 fs/xfs/xfs_fsmap.c        |  4 +--
 fs/xfs/xfs_icache.c       |  2 +-
 fs/xfs/xfs_iwalk.c        |  6 ++--
 fs/xfs/xfs_reflink.c      |  2 +-
 fs/xfs/xfs_trace.h        |  3 ++
 9 files changed, 105 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index bb0c700afe3c..46e25c682bf4 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -94,6 +94,68 @@ xfs_perag_put(
 	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
 }
 
+/*
+ * Active references for perag structures. This is for short term access to the
+ * per ag structures for walking trees or accessing state. If an AG is being
+ * shrunk or is offline, then this will fail to find that AG and return NULL
+ * instead.
+ */
+struct xfs_perag *
+xfs_perag_grab(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_perag	*pag;
+
+	rcu_read_lock();
+	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
+	if (pag) {
+		trace_xfs_perag_grab(mp, pag->pag_agno,
+				atomic_read(&pag->pag_active_ref), _RET_IP_);
+		if (!atomic_inc_not_zero(&pag->pag_active_ref))
+			pag = NULL;
+	}
+	rcu_read_unlock();
+	return pag;
+}
+
+/*
+ * search from @first to find the next perag with the given tag set.
+ */
+struct xfs_perag *
+xfs_perag_grab_tag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		first,
+	int			tag)
+{
+	struct xfs_perag	*pag;
+	int			found;
+
+	rcu_read_lock();
+	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
+					(void **)&pag, first, 1, tag);
+	if (found <= 0) {
+		rcu_read_unlock();
+		return NULL;
+	}
+	trace_xfs_perag_grab_tag(mp, pag->pag_agno,
+			atomic_read(&pag->pag_active_ref), _RET_IP_);
+	if (!atomic_inc_not_zero(&pag->pag_active_ref))
+		pag = NULL;
+	rcu_read_unlock();
+	return pag;
+}
+
+void
+xfs_perag_rele(
+	struct xfs_perag	*pag)
+{
+	trace_xfs_perag_rele(pag->pag_mount, pag->pag_agno,
+			atomic_read(&pag->pag_active_ref), _RET_IP_);
+	if (atomic_dec_and_test(&pag->pag_active_ref))
+		wake_up(&pag->pag_active_wq);
+}
+
 /*
  * xfs_initialize_perag_data
  *
@@ -196,6 +258,10 @@ xfs_free_perag(
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
 		xfs_buf_hash_destroy(pag);
 
+		/* drop the mount's active reference */
+		xfs_perag_rele(pag);
+		XFS_IS_CORRUPT(pag->pag_mount,
+				atomic_read(&pag->pag_active_ref) != 0);
 		call_rcu(&pag->rcu_head, __xfs_free_perag);
 	}
 }
@@ -314,6 +380,7 @@ xfs_initialize_perag(
 		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 		init_waitqueue_head(&pag->pagb_wait);
+		init_waitqueue_head(&pag->pag_active_wq);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
 #endif /* __KERNEL__ */
@@ -322,6 +389,9 @@ xfs_initialize_perag(
 		if (error)
 			goto out_remove_pag;
 
+		/* Active ref owned by mount indicates AG is online. */
+		atomic_set(&pag->pag_active_ref, 1);
+
 		/* first new pag is fully initialized */
 		if (first_initialised == NULLAGNUMBER)
 			first_initialised = index;
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 191b22b9a35b..aeb21c8df201 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -32,7 +32,9 @@ struct xfs_ag_resv {
 struct xfs_perag {
 	struct xfs_mount *pag_mount;	/* owner filesystem */
 	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
-	atomic_t	pag_ref;	/* perag reference count */
+	atomic_t	pag_ref;	/* passive reference count */
+	atomic_t	pag_active_ref;	/* active reference count */
+	wait_queue_head_t pag_active_wq;/* woken active_ref falls to zero */
 	char		pagf_init;	/* this agf's entry is initialized */
 	char		pagi_init;	/* this agi's entry is initialized */
 	char		pagf_metadata;	/* the agf is preferred to be metadata */
@@ -111,11 +113,18 @@ int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
 void xfs_free_perag(struct xfs_mount *mp);
 
+/* Passive AG references */
 struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
 struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int tag);
 void xfs_perag_put(struct xfs_perag *pag);
 
+/* Active AG references */
+struct xfs_perag *xfs_perag_grab(struct xfs_mount *, xfs_agnumber_t);
+struct xfs_perag *xfs_perag_grab_tag(struct xfs_mount *, xfs_agnumber_t,
+				   int tag);
+void xfs_perag_rele(struct xfs_perag *pag);
+
 /*
  * Per-ag geometry infomation and validation
  */
@@ -193,14 +202,18 @@ xfs_perag_next(
 	struct xfs_mount	*mp = pag->pag_mount;
 
 	*agno = pag->pag_agno + 1;
-	xfs_perag_put(pag);
-	if (*agno > end_agno)
-		return NULL;
-	return xfs_perag_get(mp, *agno);
+	xfs_perag_rele(pag);
+	while (*agno <= end_agno) {
+		pag = xfs_perag_grab(mp, *agno);
+		if (pag)
+			return pag;
+		(*agno)++;
+	}
+	return NULL;
 }
 
 #define for_each_perag_range(mp, agno, end_agno, pag) \
-	for ((pag) = xfs_perag_get((mp), (agno)); \
+	for ((pag) = xfs_perag_grab((mp), (agno)); \
 		(pag) != NULL; \
 		(pag) = xfs_perag_next((pag), &(agno), (end_agno)))
 
@@ -213,11 +226,11 @@ xfs_perag_next(
 	for_each_perag_from((mp), (agno), (pag))
 
 #define for_each_perag_tag(mp, agno, pag, tag) \
-	for ((agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
+	for ((agno) = 0, (pag) = xfs_perag_grab_tag((mp), 0, (tag)); \
 		(pag) != NULL; \
 		(agno) = (pag)->pag_agno + 1, \
-		xfs_perag_put(pag), \
-		(pag) = xfs_perag_get_tag((mp), (agno), (tag)))
+		xfs_perag_rele(pag), \
+		(pag) = xfs_perag_grab_tag((mp), (agno), (tag)))
 
 struct aghdr_init_data {
 	/* per ag data */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index d50d0eab196a..dbbc7037074c 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -662,7 +662,7 @@ xchk_bmap_check_rmaps(
 		error = xchk_bmap_check_ag_rmaps(sc, whichfork, pag);
 		if (error ||
 		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)) {
-			xfs_perag_put(pag);
+			xfs_perag_rele(pag);
 			return error;
 		}
 	}
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 4777e7b89fdc..ef97670970c3 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -117,7 +117,7 @@ xchk_fscount_warmup(
 	if (agi_bp)
 		xfs_buf_relse(agi_bp);
 	if (pag)
-		xfs_perag_put(pag);
+		xfs_perag_rele(pag);
 	return error;
 }
 
@@ -249,7 +249,7 @@ xchk_fscount_aggregate_agcounts(
 
 	}
 	if (pag)
-		xfs_perag_put(pag);
+		xfs_perag_rele(pag);
 	if (error) {
 		xchk_set_incomplete(sc);
 		return error;
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 88a88506ffff..120d284a03fe 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -688,11 +688,11 @@ __xfs_getfsmap_datadev(
 		info->agf_bp = NULL;
 	}
 	if (info->pag) {
-		xfs_perag_put(info->pag);
+		xfs_perag_rele(info->pag);
 		info->pag = NULL;
 	} else if (pag) {
 		/* loop termination case */
-		xfs_perag_put(pag);
+		xfs_perag_rele(pag);
 	}
 
 	return error;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ddeaccc04aec..0f4a014dded3 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1767,7 +1767,7 @@ xfs_icwalk(
 		if (error) {
 			last_error = error;
 			if (error == -EFSCORRUPTED) {
-				xfs_perag_put(pag);
+				xfs_perag_rele(pag);
 				break;
 			}
 		}
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 7558486f4937..c31857d903a4 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -591,7 +591,7 @@ xfs_iwalk(
 	}
 
 	if (iwag.pag)
-		xfs_perag_put(pag);
+		xfs_perag_rele(pag);
 	xfs_iwalk_free(&iwag);
 	return error;
 }
@@ -683,7 +683,7 @@ xfs_iwalk_threaded(
 			break;
 	}
 	if (pag)
-		xfs_perag_put(pag);
+		xfs_perag_rele(pag);
 	if (polled)
 		xfs_pwork_poll(&pctl);
 	return xfs_pwork_destroy(&pctl);
@@ -776,7 +776,7 @@ xfs_inobt_walk(
 	}
 
 	if (iwag.pag)
-		xfs_perag_put(pag);
+		xfs_perag_rele(pag);
 	xfs_iwalk_free(&iwag);
 	return error;
 }
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 57bf59ff4854..f5dc46ce9803 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -927,7 +927,7 @@ xfs_reflink_recover_cow(
 	for_each_perag(mp, agno, pag) {
 		error = xfs_refcount_recover_cow_leftovers(mp, pag);
 		if (error) {
-			xfs_perag_put(pag);
+			xfs_perag_rele(pag);
 			break;
 		}
 	}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7dc57db6aa42..f0b62054ea68 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -189,6 +189,9 @@ DEFINE_EVENT(xfs_perag_class, name,	\
 DEFINE_PERAG_REF_EVENT(xfs_perag_get);
 DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_put);
+DEFINE_PERAG_REF_EVENT(xfs_perag_grab);
+DEFINE_PERAG_REF_EVENT(xfs_perag_grab_tag);
+DEFINE_PERAG_REF_EVENT(xfs_perag_rele);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
 
-- 
2.39.0

