Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF6D321B50
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Feb 2021 16:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhBVPXg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Feb 2021 10:23:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28628 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231483AbhBVPWm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Feb 2021 10:22:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614007271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WS8vQ+dbAP04Lb9b0PlY5pdS4gPO+ZAxLSQKjIP85Zo=;
        b=Uym+Un/JodYbGcGRFoKsbx4MbuuqMdAzLT32wCnGNma6cFq3oVWNyAY5M8zQzYlzEm2FFF
        2SxUxU4o96Jw3zh077UIDjF69g451gDAAZXIl6lOECXo9Rxk6Y6muF1Z+tXfei9HCv9V9p
        PhXM0yvy/LfrODz3M7iQ2IJ+wUsHokA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-HsI_wfPnPKyAW17T2EIxrw-1; Mon, 22 Feb 2021 10:21:09 -0500
X-MC-Unique: HsI_wfPnPKyAW17T2EIxrw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C19698030C1
        for <linux-xfs@vger.kernel.org>; Mon, 22 Feb 2021 15:21:08 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B63A5D6B1
        for <linux-xfs@vger.kernel.org>; Mon, 22 Feb 2021 15:21:08 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: set aside allocation btree blocks from block reservation
Date:   Mon, 22 Feb 2021 10:21:08 -0500
Message-Id: <20210222152108.896178-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The blocks used for allocation btrees (bnobt and countbt) are
technically considered free space. This is because as free space is
used, allocbt blocks are removed and naturally become available for
traditional allocation. However, this means that a significant
portion of free space may consist of in-use btree blocks if free
space is severely fragmented.

On large filesystems with large perag reservations, this can lead to
a rare but nasty condition where a significant amount of physical
free space is available, but the majority of actual usable blocks
consist of in-use allocbt blocks. We have a record of a (~12TB, 32
AG) filesystem with multiple AGs in a state with ~2.5GB or so free
blocks tracked across ~300 total allocbt blocks, but effectively at
100% full because the the free space is entirely consumed by
refcountbt perag reservation.

Such a large perag reservation is by design on large filesystems.
The problem is that because the free space is so fragmented, this AG
contributes the 300 or so allocbt blocks to the global counters as
free space. If this pattern repeats across enough AGs, the
filesystem lands in a state where global block reservation can
outrun physical block availability. For example, a streaming
buffered write on the affected filesystem continues to allow delayed
allocation beyond the point where writeback starts to fail due to
physical block allocation failures. The expected behavior is for the
delalloc block reservation to fail gracefully with -ENOSPC before
physical block allocation failure is a possibility.

To address this problem, introduce a counter to track the sum of the
allocbt block counters already tracked in the AGF. Use the new
counter to set these blocks aside at reservation time and thus
ensure they cannot be allocated until truly available. Since this is
only necessary when large reflink perag reservations are in place
and the counter requires a read of each AGF to fully populate, only
enforce on reflink enabled filesystems. This allows initialization
of the counter at ->pagf_init time because the refcountbt perag
reservation init code reads each AGF at mount time.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Use an atomic counter instead of a percpu counter.
v1: https://lore.kernel.org/linux-xfs/20210217132339.651020-1-bfoster@redhat.com/

 fs/xfs/libxfs/xfs_alloc.c |  3 +++
 fs/xfs/xfs_mount.c        | 15 ++++++++++++++-
 fs/xfs/xfs_mount.h        |  6 ++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 0c623d3c1036..fb3d36cad173 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2746,6 +2746,7 @@ xfs_alloc_get_freelist(
 	if (btreeblk) {
 		be32_add_cpu(&agf->agf_btreeblks, 1);
 		pag->pagf_btreeblks++;
+		atomic64_inc(&mp->m_btree_blks);
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
 
@@ -2853,6 +2854,7 @@ xfs_alloc_put_freelist(
 	if (btreeblk) {
 		be32_add_cpu(&agf->agf_btreeblks, -1);
 		pag->pagf_btreeblks--;
+		atomic64_dec(&mp->m_btree_blks);
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
 
@@ -3055,6 +3057,7 @@ xfs_alloc_read_agf(
 	if (!pag->pagf_init) {
 		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
 		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
+		atomic64_add(pag->pagf_btreeblks, &mp->m_btree_blks);
 		pag->pagf_flcount = be32_to_cpu(agf->agf_flcount);
 		pag->pagf_longest = be32_to_cpu(agf->agf_longest);
 		pag->pagf_levels[XFS_BTNUM_BNOi] =
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 52370d0a3f43..16482e02da01 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1178,6 +1178,7 @@ xfs_mod_fdblocks(
 	int64_t			lcounter;
 	long long		res_used;
 	s32			batch;
+	uint64_t		set_aside = mp->m_alloc_set_aside;
 
 	if (delta > 0) {
 		/*
@@ -1217,8 +1218,20 @@ xfs_mod_fdblocks(
 	else
 		batch = XFS_FDBLOCKS_BATCH;
 
+	/*
+	 * Set aside allocbt blocks on reflink filesystems because COW remaps
+	 * can dip into the reserved block pool. This is problematic if free
+	 * space is fragmented and m_fdblocks tracks a significant number of
+	 * allocbt blocks. Note this also ensures the counter is accurate before
+	 * the filesystem is active because perag reservation reads all AGFs at
+	 * mount time. The only call prior to that is to populate the reserve
+	 * pool itself.
+	 */
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		set_aside += atomic64_read(&mp->m_btree_blks);
+
 	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
-	if (__percpu_counter_compare(&mp->m_fdblocks, mp->m_alloc_set_aside,
+	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
 				     XFS_FDBLOCKS_BATCH) >= 0) {
 		/* we had space! */
 		return 0;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 659ad95fe3e0..70e1dd6b538a 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -170,6 +170,12 @@ typedef struct xfs_mount {
 	 * extents or anything related to the rt device.
 	 */
 	struct percpu_counter	m_delalloc_blks;
+	/*
+	 * Optional count of btree blocks in use across all AGs. Only used when
+	 * reflink is enabled. Helps prevent block reservation from attempting
+	 * to reserve allocation btree blocks.
+	 */
+	atomic64_t		m_btree_blks;
 
 	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
-- 
2.26.2

