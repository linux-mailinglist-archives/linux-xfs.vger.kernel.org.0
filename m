Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC323556DD
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Apr 2021 16:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345264AbhDFOmu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Apr 2021 10:42:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39705 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345273AbhDFOmu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 10:42:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617720162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MJiIHIHEEKzWS65EVd4tfcA/jdNOJKNpN19TDI/CiB4=;
        b=PTyI14XKPZW9OLEMaad782YPO7RKrLoB+cv9Mo22MxgIo5gkq8U4JugpmV3xJtR1DfphnB
        KBkduMRhNjZw8icvfSyF+7TEVlxdc6qKobbLLQ0k9iXfyD0FLW3HSYFIdyyLuaWYu6Oh4L
        JcPJ7PiwFWoiTbsFpyKhmiEB2v3EzKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-Yppl0X0CPkiV29wp9xwK6w-1; Tue, 06 Apr 2021 10:42:40 -0400
X-MC-Unique: Yppl0X0CPkiV29wp9xwK6w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA83D1966334
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 14:42:39 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CE335D6DC
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 14:42:39 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/3] xfs: transaction subsystem quiesce mechanism
Date:   Tue,  6 Apr 2021 10:42:37 -0400
Message-Id: <20210406144238.814558-3-bfoster@redhat.com>
In-Reply-To: <20210406144238.814558-1-bfoster@redhat.com>
References: <20210406144238.814558-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The updated quotaoff logging algorithm depends on a runtime quiesce
of the transaction subsystem to guarantee all transactions after a
certain point detect quota subsystem changes. Implement this
mechanism using an internal lock, similar to the external filesystem
freeze mechanism. This is also somewhat analogous to the old percpu
transaction counter mechanism, but we don't actually need a counter.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_aops.c  |  2 ++
 fs/xfs/xfs_mount.h |  3 +++
 fs/xfs/xfs_super.c |  8 ++++++++
 fs/xfs/xfs_trans.c |  4 ++--
 fs/xfs/xfs_trans.h | 20 ++++++++++++++++++++
 5 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1cc7c36d98e9..dce52943e5a7 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -58,6 +58,7 @@ xfs_setfilesize_trans_alloc(
 	 * we released it.
 	 */
 	__sb_writers_release(ioend->io_inode->i_sb, SB_FREEZE_FS);
+	percpu_rwsem_release(&mp->m_trans_rwsem, true, _THIS_IP_);
 	/*
 	 * We hand off the transaction to the completion thread now, so
 	 * clear the flag here.
@@ -127,6 +128,7 @@ xfs_setfilesize_ioend(
 	 */
 	xfs_trans_set_context(tp);
 	__sb_writers_acquired(VFS_I(ip)->i_sb, SB_FREEZE_FS);
+	percpu_rwsem_acquire(&ip->i_mount->m_trans_rwsem, true, _THIS_IP_);
 
 	/* we abort the update if there was an IO error */
 	if (error) {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 81829d19596e..27a2a53abb4f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -171,6 +171,9 @@ typedef struct xfs_mount {
 	 */
 	struct percpu_counter	m_delalloc_blks;
 
+	/* lock for transaction quiesce (used by quotaoff) */
+	struct percpu_rw_semaphore	m_trans_rwsem;
+
 	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
 	uint64_t		m_resblks;	/* total reserved blocks */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8d079c5e7099..64feab042dea 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1001,8 +1001,15 @@ xfs_init_percpu_counters(
 	if (error)
 		goto free_fdblocks;
 
+	/* not a counter, but close enough... */
+	error = percpu_init_rwsem(&mp->m_trans_rwsem);
+	if (error)
+		goto free_delalloc;
+
 	return 0;
 
+free_delalloc:
+	percpu_counter_destroy(&mp->m_delalloc_blks);
 free_fdblocks:
 	percpu_counter_destroy(&mp->m_fdblocks);
 free_ifree:
@@ -1025,6 +1032,7 @@ static void
 xfs_destroy_percpu_counters(
 	struct xfs_mount	*mp)
 {
+	percpu_free_rwsem(&mp->m_trans_rwsem);
 	percpu_counter_destroy(&mp->m_icount);
 	percpu_counter_destroy(&mp->m_ifree);
 	percpu_counter_destroy(&mp->m_fdblocks);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bc25afc10245..c46943f0fc77 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -74,7 +74,7 @@ xfs_trans_free(
 	trace_xfs_trans_free(tp, _RET_IP_);
 	xfs_trans_clear_context(tp);
 	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
-		sb_end_intwrite(tp->t_mountp->m_super);
+		xfs_trans_end(tp->t_mountp);
 	xfs_trans_free_dqinfo(tp);
 	kmem_cache_free(xfs_trans_zone, tp);
 }
@@ -265,7 +265,7 @@ xfs_trans_alloc(
 retry:
 	tp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
 	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
-		sb_start_intwrite(mp->m_super);
+		xfs_trans_start(mp);
 	xfs_trans_set_context(tp);
 
 	/*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 9dd745cf77c9..95da3e179150 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -226,6 +226,26 @@ xfs_trans_read_buf(
 				      flags, bpp, ops);
 }
 
+/*
+ * Context tracking helpers for external (i.e. fs freeze) and internal
+ * transaction quiesce.
+ */
+static inline void
+xfs_trans_start(
+	struct xfs_mount	*mp)
+{
+	sb_start_intwrite(mp->m_super);
+	percpu_down_read(&mp->m_trans_rwsem);
+}
+
+static inline void
+xfs_trans_end(
+	struct xfs_mount	*mp)
+{
+	percpu_up_read(&mp->m_trans_rwsem);
+	sb_end_intwrite(mp->m_super);
+}
+
 struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
 
 void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
-- 
2.26.3

