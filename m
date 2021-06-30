Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5743B7D4E
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Jun 2021 08:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbhF3GRH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 30 Jun 2021 02:17:07 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:50248 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231414AbhF3GRG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jun 2021 02:17:06 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 654571B0D07;
        Wed, 30 Jun 2021 16:14:35 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lyTUY-0012JL-Kb; Wed, 30 Jun 2021 16:14:34 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lyTUY-007LTt-D3; Wed, 30 Jun 2021 16:14:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 2/3] xfs: remove kmem_alloc_io()
Date:   Wed, 30 Jun 2021 16:14:30 +1000
Message-Id: <20210630061431.1750745-3-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630061431.1750745-1-david@fromorbit.com>
References: <20210630061431.1750745-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=4XHAKF2RG0DQCWMB_poA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Since commit 59bb47985c1d ("mm, sl[aou]b: guarantee natural alignment
for kmalloc(power-of-two)"), the core slab code now guarantees slab
alignment in all situations sufficient for IO purposes (i.e. minimum
of 512 byte alignment of >= 512 byte sized heap allocations) we no
longer need the workaround in the XFS code to provide this
guarantee.

Replace the use of kmem_alloc_io() with kmem_alloc() or
kmem_alloc_large() appropriately, and remove the kmem_alloc_io()
interface altogether.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/kmem.c            | 25 -------------------------
 fs/xfs/kmem.h            |  1 -
 fs/xfs/xfs_buf.c         |  3 +--
 fs/xfs/xfs_buf.h         |  6 ------
 fs/xfs/xfs_log.c         |  3 +--
 fs/xfs/xfs_log_recover.c |  4 +---
 fs/xfs/xfs_trace.h       |  1 -
 7 files changed, 3 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index e986b95d94c9..3f2979fd2f2b 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -56,31 +56,6 @@ __kmem_vmalloc(size_t size, xfs_km_flags_t flags)
 	return ptr;
 }
 
-/*
- * Same as kmem_alloc_large, except we guarantee the buffer returned is aligned
- * to the @align_mask. We only guarantee alignment up to page size, we'll clamp
- * alignment at page size if it is larger. vmalloc always returns a PAGE_SIZE
- * aligned region.
- */
-void *
-kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags)
-{
-	void	*ptr;
-
-	trace_kmem_alloc_io(size, flags, _RET_IP_);
-
-	if (WARN_ON_ONCE(align_mask >= PAGE_SIZE))
-		align_mask = PAGE_SIZE - 1;
-
-	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
-	if (ptr) {
-		if (!((uintptr_t)ptr & align_mask))
-			return ptr;
-		kfree(ptr);
-	}
-	return __kmem_vmalloc(size, flags);
-}
-
 void *
 kmem_alloc_large(size_t size, xfs_km_flags_t flags)
 {
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 38007117697e..9ff20047f8b8 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -57,7 +57,6 @@ kmem_flags_convert(xfs_km_flags_t flags)
 }
 
 extern void *kmem_alloc(size_t, xfs_km_flags_t);
-extern void *kmem_alloc_io(size_t size, int align_mask, xfs_km_flags_t flags);
 extern void *kmem_alloc_large(size_t size, xfs_km_flags_t);
 static inline void  kmem_free(const void *ptr)
 {
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8ff42b3585e0..a5ef1f9eb622 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -315,7 +315,6 @@ xfs_buf_alloc_kmem(
 	struct xfs_buf	*bp,
 	xfs_buf_flags_t	flags)
 {
-	int		align_mask = xfs_buftarg_dma_alignment(bp->b_target);
 	xfs_km_flags_t	kmflag_mask = KM_NOFS;
 	size_t		size = BBTOB(bp->b_length);
 
@@ -323,7 +322,7 @@ xfs_buf_alloc_kmem(
 	if (!(flags & XBF_READ))
 		kmflag_mask |= KM_ZERO;
 
-	bp->b_addr = kmem_alloc_io(size, align_mask, kmflag_mask);
+	bp->b_addr = kmem_alloc(size, kmflag_mask);
 	if (!bp->b_addr)
 		return -ENOMEM;
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 464dc548fa23..cfbe37d73293 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -355,12 +355,6 @@ extern int xfs_setsize_buftarg(struct xfs_buftarg *, unsigned int);
 #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
 
-static inline int
-xfs_buftarg_dma_alignment(struct xfs_buftarg *bt)
-{
-	return queue_dma_alignment(bt->bt_bdev->bd_disk->queue);
-}
-
 int xfs_buf_reverify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
 bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c896c9041b8e..5f6fc0ee4584 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1451,7 +1451,6 @@ xlog_alloc_log(
 	 */
 	ASSERT(log->l_iclog_size >= 4096);
 	for (i = 0; i < log->l_iclog_bufs; i++) {
-		int align_mask = xfs_buftarg_dma_alignment(mp->m_logdev_targp);
 		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE) *
 				sizeof(struct bio_vec);
 
@@ -1463,7 +1462,7 @@ xlog_alloc_log(
 		iclog->ic_prev = prev_iclog;
 		prev_iclog = iclog;
 
-		iclog->ic_data = kmem_alloc_io(log->l_iclog_size, align_mask,
+		iclog->ic_data = kmem_alloc_large(log->l_iclog_size,
 						KM_MAYFAIL | KM_ZERO);
 		if (!iclog->ic_data)
 			goto out_free_iclog;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index fee4fbadea0a..cc559815e08f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -79,8 +79,6 @@ xlog_alloc_buffer(
 	struct xlog	*log,
 	int		nbblks)
 {
-	int align_mask = xfs_buftarg_dma_alignment(log->l_targ);
-
 	/*
 	 * Pass log block 0 since we don't have an addr yet, buffer will be
 	 * verified on read.
@@ -108,7 +106,7 @@ xlog_alloc_buffer(
 	if (nbblks > 1 && log->l_sectBBsize > 1)
 		nbblks += log->l_sectBBsize;
 	nbblks = round_up(nbblks, log->l_sectBBsize);
-	return kmem_alloc_io(BBTOB(nbblks), align_mask, KM_MAYFAIL | KM_ZERO);
+	return kmem_alloc_large(BBTOB(nbblks), KM_MAYFAIL | KM_ZERO);
 }
 
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f9d8d605f9b1..6865e838a71b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3689,7 +3689,6 @@ DEFINE_EVENT(xfs_kmem_class, name, \
 	TP_PROTO(ssize_t size, int flags, unsigned long caller_ip), \
 	TP_ARGS(size, flags, caller_ip))
 DEFINE_KMEM_EVENT(kmem_alloc);
-DEFINE_KMEM_EVENT(kmem_alloc_io);
 DEFINE_KMEM_EVENT(kmem_alloc_large);
 
 TRACE_EVENT(xfs_check_new_dalign,
-- 
2.31.1

