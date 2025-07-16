Return-Path: <linux-xfs+bounces-24070-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 666DCB0764C
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Jul 2025 14:54:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F23A91AA50E4
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Jul 2025 12:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A6128C2CA;
	Wed, 16 Jul 2025 12:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tyE49xIe"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0C5341AA
	for <linux-xfs@vger.kernel.org>; Wed, 16 Jul 2025 12:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752670469; cv=none; b=l67+YzXp5pKCi1PMVvh5xGGpV44wIcef0AtWnlD9C9Ts5bqoVeajfRryaeqj3Z7f+8j3Fzx84Rf6lU2rTLX+VkLwIfXbda7ncXH27UOmc7hdGP+NyRed/kc71wfHg5XRBAMOlBjXGTTmCrBgE+t+aieu2H3Hjx1glzvxPv09ito=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752670469; c=relaxed/simple;
	bh=5v2YSm1N24fOqlEP5nX1Veg9b7JnOpMhhDhvkKqHoYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrVwwvjX6cpv/p/wDYCjXvFAUgLKGKPJ6jmKF/QROQjpR8nWi0kEodFqe7NnXCR7q671fX4xUZ2dOx3yg4ZmoxyQO3MFWz5e5NeAyig9aftbzMxY0kRpploTu51IdtA6lXrkS8hnOESozrK7x6k+Y5pIcTG4oPIvK7rLDaXxlL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tyE49xIe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Fnf5iRFaScs6Rnqx4jxK2FW3vRI7iL7omyC3U0DxMqU=; b=tyE49xIeDIQ51uTisUrFpg7A8G
	KHUetyvt1vOVCrW9fG+4N1U4zaDzIYPgNkjFSxrl2KSeBmIEFsTHG0AS6JhzCFP+6Fvyf54jXHd0P
	xSNyaB3rcauNveOgkXpAyIeBn1gRsxvh7fgYA6+gkZ1wumyOsHoSOofA2ylYvCobxCXxzHCZmt/OH
	1gB/AZ4wLWveD7rlwnHyorU00VmQdDQBrEY7AYqhmod09FIKbH686cogpwas8x5CSbdiawO2oAsLb
	K7nWTYrWB4kHA8677nz67TSwNepqQUbciKcWSooFopkGcF85c59fnmUcqaMrvYVg86OYQctoCRJx0
	ZNZ46G0A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uc1eV-00000007iN9-10Wz;
	Wed, 16 Jul 2025 12:54:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/7] xfs: rename oz_write_pointer to oz_allocated
Date: Wed, 16 Jul 2025 14:54:03 +0200
Message-ID: <20250716125413.2148420-4-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250716125413.2148420-1-hch@lst.de>
References: <20250716125413.2148420-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This member just tracks how much space we handed out for sequential
write required zones.  Only for conventional space it actually is the
pointer where thing are written at, otherwise zone append manages
that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trace.h      |  8 ++++----
 fs/xfs/xfs_zone_alloc.c | 18 +++++++++---------
 fs/xfs/xfs_zone_gc.c    | 13 ++++++-------
 fs/xfs/xfs_zone_info.c  |  2 +-
 fs/xfs/xfs_zone_priv.h  | 16 ++++++++--------
 5 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6addebd764b0..10d4fd671dcf 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -425,8 +425,8 @@ DECLARE_EVENT_CLASS(xfs_zone_alloc_class,
 		__field(dev_t, dev)
 		__field(xfs_rgnumber_t, rgno)
 		__field(xfs_rgblock_t, used)
+		__field(xfs_rgblock_t, allocated)
 		__field(xfs_rgblock_t, written)
-		__field(xfs_rgblock_t, write_pointer)
 		__field(xfs_rgblock_t, rgbno)
 		__field(xfs_extlen_t, len)
 	),
@@ -434,17 +434,17 @@ DECLARE_EVENT_CLASS(xfs_zone_alloc_class,
 		__entry->dev = rtg_mount(oz->oz_rtg)->m_super->s_dev;
 		__entry->rgno = rtg_rgno(oz->oz_rtg);
 		__entry->used = rtg_rmap(oz->oz_rtg)->i_used_blocks;
+		__entry->allocated = oz->oz_allocated;
 		__entry->written = oz->oz_written;
-		__entry->write_pointer = oz->oz_write_pointer;
 		__entry->rgbno = rgbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d rgno 0x%x used 0x%x written 0x%x wp 0x%x rgbno 0x%x len 0x%x",
+	TP_printk("dev %d:%d rgno 0x%x used 0x%x alloced 0x%x written 0x%x rgbno 0x%x len 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->rgno,
 		  __entry->used,
+		  __entry->allocated,
 		  __entry->written,
-		  __entry->write_pointer,
 		  __entry->rgbno,
 		  __entry->len)
 );
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 867465b5b5fe..729d80ff52c1 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -434,7 +434,7 @@ xfs_init_open_zone(
 	spin_lock_init(&oz->oz_alloc_lock);
 	atomic_set(&oz->oz_ref, 1);
 	oz->oz_rtg = rtg;
-	oz->oz_write_pointer = write_pointer;
+	oz->oz_allocated = write_pointer;
 	oz->oz_written = write_pointer;
 	oz->oz_write_hint = write_hint;
 	oz->oz_is_gc = is_gc;
@@ -569,7 +569,7 @@ xfs_try_use_zone(
 	struct xfs_open_zone	*oz,
 	bool			lowspace)
 {
-	if (oz->oz_write_pointer == rtg_blocks(oz->oz_rtg))
+	if (oz->oz_allocated == rtg_blocks(oz->oz_rtg))
 		return false;
 	if (!lowspace && !xfs_good_hint_match(oz, file_hint))
 		return false;
@@ -744,25 +744,25 @@ xfs_zone_alloc_blocks(
 {
 	struct xfs_rtgroup	*rtg = oz->oz_rtg;
 	struct xfs_mount	*mp = rtg_mount(rtg);
-	xfs_rgblock_t		rgbno;
+	xfs_rgblock_t		allocated;
 
 	spin_lock(&oz->oz_alloc_lock);
 	count_fsb = min3(count_fsb, XFS_MAX_BMBT_EXTLEN,
-		(xfs_filblks_t)rtg_blocks(rtg) - oz->oz_write_pointer);
+		(xfs_filblks_t)rtg_blocks(rtg) - oz->oz_allocated);
 	if (!count_fsb) {
 		spin_unlock(&oz->oz_alloc_lock);
 		return 0;
 	}
-	rgbno = oz->oz_write_pointer;
-	oz->oz_write_pointer += count_fsb;
+	allocated = oz->oz_allocated;
+	oz->oz_allocated += count_fsb;
 	spin_unlock(&oz->oz_alloc_lock);
 
-	trace_xfs_zone_alloc_blocks(oz, rgbno, count_fsb);
+	trace_xfs_zone_alloc_blocks(oz, allocated, count_fsb);
 
 	*sector = xfs_gbno_to_daddr(&rtg->rtg_group, 0);
 	*is_seq = bdev_zone_is_seq(mp->m_rtdev_targp->bt_bdev, *sector);
 	if (!*is_seq)
-		*sector += XFS_FSB_TO_BB(mp, rgbno);
+		*sector += XFS_FSB_TO_BB(mp, allocated);
 	return XFS_FSB_TO_B(mp, count_fsb);
 }
 
@@ -983,7 +983,7 @@ xfs_zone_rgbno_is_valid(
 	lockdep_assert_held(&rtg_rmap(rtg)->i_lock);
 
 	if (rtg->rtg_open_zone)
-		return rgbno < rtg->rtg_open_zone->oz_write_pointer;
+		return rgbno < rtg->rtg_open_zone->oz_allocated;
 	return !xa_get_mark(&rtg_mount(rtg)->m_groups[XG_TYPE_RTG].xa,
 			rtg_rgno(rtg), XFS_RTG_FREE);
 }
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 9c00fc5baa30..7ea9fa77b061 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -533,8 +533,7 @@ xfs_zone_gc_steal_open(
 
 	spin_lock(&zi->zi_open_zones_lock);
 	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry) {
-		if (!found ||
-		    oz->oz_write_pointer < found->oz_write_pointer)
+		if (!found || oz->oz_allocated < found->oz_allocated)
 			found = oz;
 	}
 
@@ -584,7 +583,7 @@ xfs_zone_gc_ensure_target(
 {
 	struct xfs_open_zone	*oz = mp->m_zone_info->zi_open_gc_zone;
 
-	if (!oz || oz->oz_write_pointer == rtg_blocks(oz->oz_rtg))
+	if (!oz || oz->oz_allocated == rtg_blocks(oz->oz_rtg))
 		return xfs_zone_gc_select_target(mp);
 	return oz;
 }
@@ -605,7 +604,7 @@ xfs_zone_gc_space_available(
 	oz = xfs_zone_gc_ensure_target(data->mp);
 	if (!oz)
 		return false;
-	return oz->oz_write_pointer < rtg_blocks(oz->oz_rtg) &&
+	return oz->oz_allocated < rtg_blocks(oz->oz_rtg) &&
 		xfs_zone_gc_scratch_available(data);
 }
 
@@ -647,7 +646,7 @@ xfs_zone_gc_alloc_blocks(
 	 */
 	spin_lock(&mp->m_sb_lock);
 	*count_fsb = min(*count_fsb,
-			rtg_blocks(oz->oz_rtg) - oz->oz_write_pointer);
+			rtg_blocks(oz->oz_rtg) - oz->oz_allocated);
 	*count_fsb = min3(*count_fsb,
 			mp->m_free[XC_FREE_RTEXTENTS].res_avail,
 			mp->m_free[XC_FREE_RTAVAILABLE].res_avail);
@@ -661,8 +660,8 @@ xfs_zone_gc_alloc_blocks(
 	*daddr = xfs_gbno_to_daddr(&oz->oz_rtg->rtg_group, 0);
 	*is_seq = bdev_zone_is_seq(mp->m_rtdev_targp->bt_bdev, *daddr);
 	if (!*is_seq)
-		*daddr += XFS_FSB_TO_BB(mp, oz->oz_write_pointer);
-	oz->oz_write_pointer += *count_fsb;
+		*daddr += XFS_FSB_TO_BB(mp, oz->oz_allocated);
+	oz->oz_allocated += *count_fsb;
 	atomic_inc(&oz->oz_ref);
 	return oz;
 }
diff --git a/fs/xfs/xfs_zone_info.c b/fs/xfs/xfs_zone_info.c
index 733bcc2f8645..07e30c596975 100644
--- a/fs/xfs/xfs_zone_info.c
+++ b/fs/xfs/xfs_zone_info.c
@@ -32,7 +32,7 @@ xfs_show_open_zone(
 {
 	seq_printf(m, "\t  zone %d, wp %u, written %u, used %u, hint %s\n",
 		rtg_rgno(oz->oz_rtg),
-		oz->oz_write_pointer, oz->oz_written,
+		oz->oz_allocated, oz->oz_written,
 		rtg_rmap(oz->oz_rtg)->i_used_blocks,
 		xfs_write_hint_to_str(oz->oz_write_hint));
 }
diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
index ab696975a993..35e6de3d25ed 100644
--- a/fs/xfs/xfs_zone_priv.h
+++ b/fs/xfs/xfs_zone_priv.h
@@ -11,18 +11,18 @@ struct xfs_open_zone {
 	atomic_t		oz_ref;
 
 	/*
-	 * oz_write_pointer is the write pointer at which space is handed out
-	 * for conventional zones, or simple the count of blocks handed out
-	 * so far for sequential write required zones and is protected by
-	 * oz_alloc_lock/
+	 * oz_allocated is the amount of space already allocated out of the zone
+	 * and is protected by oz_alloc_lock.
+	 *
+	 * For conventional zones it also is the offset of the next write.
 	 */
 	spinlock_t		oz_alloc_lock;
-	xfs_rgblock_t		oz_write_pointer;
+	xfs_rgblock_t		oz_allocated;
 
 	/*
-	 * oz_written is the number of blocks for which we've received a
-	 * write completion.  oz_written must always be <= oz_write_pointer
-	 * and is protected by the ILOCK of the rmap inode.
+	 * oz_written is the number of blocks for which we've received a write
+	 * completion.  oz_written must always be <= oz_allocated and is
+	 * protected by the ILOCK of the rmap inode.
 	 */
 	xfs_rgblock_t		oz_written;
 
-- 
2.47.2


