Return-Path: <linux-xfs+bounces-6898-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B056D8A6084
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Apr 2024 03:41:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D43511C20AC9
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Apr 2024 01:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1108F5240;
	Tue, 16 Apr 2024 01:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u4cvf9RF"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C9B5227
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231701; cv=none; b=NZ5ucFFYbQ8pt06yRnj+NuAzFtozUcWCJoSWqDvRcKrDpymZL6bbfGoZmmHy+wUpyaCSeVQ/wQz+nyY6bzAZSGK7Fj2NkcbqkPYgJeXmUwd4h/stgdB2pcSslQnGgRKcOPnHSFQXMT+aymMi3vA/AC8u8pRd/QOqaNrkfedHfRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231701; c=relaxed/simple;
	bh=nDbQUX2kXKdvlI5CHGsbH6BjKMZnINMaem7HTfyMKwg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PAs+hkRjii3j8nR2TLI16+yhvr7WG92Kqasaugl1ICGm8qM++hMqsOsg1RwPkJ90pJeSRl20TXpPs1apenM000VoDqwVN6xHhEISRSMx+9tJJ1JEjdDoCqrNx3aUl5jYRyPtlT+16vMvhscl3MaPz1DXJUYlizjIGPUWU0MF44I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u4cvf9RF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49586C113CC;
	Tue, 16 Apr 2024 01:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231701;
	bh=nDbQUX2kXKdvlI5CHGsbH6BjKMZnINMaem7HTfyMKwg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u4cvf9RFlrHSOOWfpNOnYqcqKwpvLr96sNtyo/wEf8IBTG+KbSSClNJHUiVmFviaL
	 2p+/i5pgfCx+Fv0L1jBgAYu0ezqT5ojqqH9lvXrt0YO3ce7p3jYdK76+Id/VQGDZPS
	 rt01JTr1f+OM3jeZT0S4w6AHnVdZ/OAMaV9t+M/K/9y7JY4v3pERkkcZcyS4qulEjG
	 SQzm8GfDlYwsZUNzrqLWuAdyu6ftJr2dhcn6Qnjmt7vBZmOPPVF3xwRG+YCllXydqO
	 aPy0JfkPh+LxtWCasAvYkfe/rg7ICfTGoBYwmGJ784W0hix/mJN9+GXPsZEvBMoaM/
	 XOQ0ARTp5xysw==
Date: Mon, 15 Apr 2024 18:41:40 -0700
Subject: [PATCH 1/4] xfs: reduce the rate of cond_resched calls inside scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de,
 hch@infradead.org
Message-ID: <171323030260.253873.3709400504100908629.stgit@frogsfrogsfrogs>
In-Reply-To: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
References: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We really don't want to call cond_resched every single time we go
through a loop in scrub -- there may be billions of records, and probing
into the scheduler itself has overhead.  Reduce this overhead by only
calling cond_resched 10x per second; and add a counter so that we only
check jiffies once every 1000 records or so.

Surprisingly, this reduces scrub-only fstests runtime by about 2%.  I
used the bmapinflate xfs_db command to produce a billion-extent file and
this stupid gadget reduced the scrub runtime by about 4%.

From a stupid microbenchmark of calling these things 1 billion times, I
estimate that cond_resched costs about 5.5ns per call; jiffes costs
about 0.3ns per read; and fatal_signal_pending costs about 0.4ns per
call.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.h  |   25 -------------------
 fs/xfs/scrub/scrub.c   |    1 +
 fs/xfs/scrub/scrub.h   |   64 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/xfarray.c |   10 ++++----
 fs/xfs/scrub/xfarray.h |    3 ++
 fs/xfs/scrub/xfile.c   |    2 +-
 6 files changed, 74 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 39465e39dc5fd..3d5f1f6b4b7bf 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -6,31 +6,6 @@
 #ifndef __XFS_SCRUB_COMMON_H__
 #define __XFS_SCRUB_COMMON_H__
 
-/*
- * We /could/ terminate a scrub/repair operation early.  If we're not
- * in a good place to continue (fatal signal, etc.) then bail out.
- * Note that we're careful not to make any judgements about *error.
- */
-static inline bool
-xchk_should_terminate(
-	struct xfs_scrub	*sc,
-	int			*error)
-{
-	/*
-	 * If preemption is disabled, we need to yield to the scheduler every
-	 * few seconds so that we don't run afoul of the soft lockup watchdog
-	 * or RCU stall detector.
-	 */
-	cond_resched();
-
-	if (fatal_signal_pending(current)) {
-		if (*error == 0)
-			*error = -EINTR;
-		return true;
-	}
-	return false;
-}
-
 int xchk_trans_alloc(struct xfs_scrub *sc, uint resblks);
 int xchk_trans_alloc_empty(struct xfs_scrub *sc);
 void xchk_trans_cancel(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index e813b66b603a1..4a81f828f9f13 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -620,6 +620,7 @@ xfs_scrub_metadata(
 	sc->sm = sm;
 	sc->ops = &meta_scrub_ops[sm->sm_type];
 	sc->sick_mask = xchk_health_mask_for_scrub_type(sm->sm_type);
+	sc->relax = INIT_XCHK_RELAX;
 retry_op:
 	/*
 	 * When repairs are allowed, prevent freezing or readonly remount while
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 3910270471462..4e7e3edb6350c 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -8,6 +8,49 @@
 
 struct xfs_scrub;
 
+struct xchk_relax {
+	unsigned long	next_resched;
+	unsigned int	resched_nr;
+	bool		interruptible;
+};
+
+/* Yield to the scheduler at most 10x per second. */
+#define XCHK_RELAX_NEXT		(jiffies + (HZ / 10))
+
+#define INIT_XCHK_RELAX	\
+	(struct xchk_relax){ \
+		.next_resched	= XCHK_RELAX_NEXT, \
+		.resched_nr	= 0, \
+		.interruptible	= true, \
+	}
+
+/*
+ * Relax during a scrub operation and exit if there's a fatal signal pending.
+ *
+ * If preemption is disabled, we need to yield to the scheduler every now and
+ * then so that we don't run afoul of the soft lockup watchdog or RCU stall
+ * detector.  cond_resched calls are somewhat expensive (~5ns) so we want to
+ * ratelimit this to 10x per second.  Amortize the cost of the other checks by
+ * only doing it once every 100 calls.
+ */
+static inline int xchk_maybe_relax(struct xchk_relax *widget)
+{
+	/* Amortize the cost of scheduling and checking signals. */
+	if (likely(++widget->resched_nr < 100))
+		return 0;
+	widget->resched_nr = 0;
+
+	if (unlikely(widget->next_resched <= jiffies)) {
+		cond_resched();
+		widget->next_resched = XCHK_RELAX_NEXT;
+	}
+
+	if (widget->interruptible && fatal_signal_pending(current))
+		return -EINTR;
+
+	return 0;
+}
+
 /*
  * Standard flags for allocating memory within scrub.  NOFS context is
  * configured by the process allocation scope.  Scrub and repair must be able
@@ -123,6 +166,9 @@ struct xfs_scrub {
 	 */
 	unsigned int			sick_mask;
 
+	/* next time we want to cond_resched() */
+	struct xchk_relax		relax;
+
 	/* State tracking for single-AG operations. */
 	struct xchk_ag			sa;
 };
@@ -167,6 +213,24 @@ struct xfs_scrub_subord *xchk_scrub_create_subord(struct xfs_scrub *sc,
 		unsigned int subtype);
 void xchk_scrub_free_subord(struct xfs_scrub_subord *sub);
 
+/*
+ * We /could/ terminate a scrub/repair operation early.  If we're not
+ * in a good place to continue (fatal signal, etc.) then bail out.
+ * Note that we're careful not to make any judgements about *error.
+ */
+static inline bool
+xchk_should_terminate(
+	struct xfs_scrub	*sc,
+	int			*error)
+{
+	if (xchk_maybe_relax(&sc->relax)) {
+		if (*error == 0)
+			*error = -EINTR;
+		return true;
+	}
+	return false;
+}
+
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
 int xchk_superblock(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index b65cd3fc5ac9b..9185ae7088d49 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -7,9 +7,9 @@
 #include "xfs_fs.h"
 #include "xfs_shared.h"
 #include "xfs_format.h"
+#include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
-#include "scrub/scrub.h"
 #include "scrub/trace.h"
 
 /*
@@ -486,6 +486,9 @@ xfarray_sortinfo_alloc(
 
 	xfarray_sortinfo_lo(si)[0] = 0;
 	xfarray_sortinfo_hi(si)[0] = array->nr - 1;
+	si->relax = INIT_XCHK_RELAX;
+	if (flags & XFARRAY_SORT_KILLABLE)
+		si->relax.interruptible = false;
 
 	trace_xfarray_sort(si, nr_bytes);
 	*infop = si;
@@ -503,10 +506,7 @@ xfarray_sort_terminated(
 	 * few seconds so that we don't run afoul of the soft lockup watchdog
 	 * or RCU stall detector.
 	 */
-	cond_resched();
-
-	if ((si->flags & XFARRAY_SORT_KILLABLE) &&
-	    fatal_signal_pending(current)) {
+	if (xchk_maybe_relax(&si->relax)) {
 		if (*error == 0)
 			*error = -EINTR;
 		return true;
diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
index 8f54c8fc888fa..5eeeeed13ae24 100644
--- a/fs/xfs/scrub/xfarray.h
+++ b/fs/xfs/scrub/xfarray.h
@@ -127,6 +127,9 @@ struct xfarray_sortinfo {
 	/* XFARRAY_SORT_* flags; see below. */
 	unsigned int		flags;
 
+	/* next time we want to cond_resched() */
+	struct xchk_relax	relax;
+
 	/* Cache a folio here for faster scanning for pivots */
 	struct folio		*folio;
 
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index 4e254a0ba0036..d848222f802ba 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -10,9 +10,9 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
-#include "scrub/scrub.h"
 #include "scrub/trace.h"
 #include <linux/shmem_fs.h>
 


