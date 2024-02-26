Return-Path: <linux-xfs+bounces-4194-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDACE8670F1
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Feb 2024 11:28:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 870B8B22807
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Feb 2024 10:11:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B5364CC6;
	Mon, 26 Feb 2024 09:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="fFQkG18o"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90461634F3;
	Mon, 26 Feb 2024 09:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708940998; cv=none; b=bQVawrXTRA/c8vZVw/mvd9435sT4tJSeEC+Pfh6ozgVg8IgzXhn297nLEJcDh4upLhTBZF1UHzdVuVRW0daaEtcRxlXGusPfjNYUW/Z1ca5efWz4jsWMuqvjzNVLkz4Fr8JIawfon36E4CRqp8GhoRuHyNZalEtsVMPypkUfdQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708940998; c=relaxed/simple;
	bh=BY0+lJrnKbexBUzETPtFYZ+OJuge9ZodiUfVOjc2hK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RyISfggWyD+U1hNDMvF8KZK4r82AmGAAAHoZglpA6OwnAXsgvyVxP3xd42fZ89fhUuBg2R3C3VN9WznUMWfipqodrssO5mL2pkRGDfwH0w0ffxd027lkdxV2Je32SoOjEtqqA7CSMUBJT1MTLuLrRjuoKnJS3RXLLLnOcRyc9iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=fFQkG18o; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4Tjwnk5kDgz9sT6;
	Mon, 26 Feb 2024 10:49:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1708940986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O82T73AIK6qGhlYorGzOupTzei7wEk6+FPA8o3URJUE=;
	b=fFQkG18oqQYxyzAvUU/y6Xu/XNWxZbMy3Hto7NjxLMdpH4n7PnYGdCLyHr4oXKUWbXSdbt
	3kIMgsOe+HNJi2CzUuOzIN8/o3Hwj48BF9JSpk1ELMgKLrxDpkLn7dQHexpKbAy6k3on3h
	tAY9LeXQaVX3Z0icnnr5KaXGnxzwdyT+lKKy4CYh251ECjLnS+cXrDxGEVm36OGNJwQwRd
	47PB4v+rzOClutu21cDUGzMEc1J6st9TU1ML2CZo9yDdBjMu2qdfyN76b5tzCIv54RiQR8
	MMZn9aLw+WeROCUn9RtgqMYpFq+RNdlieT4wk3ZhHKWPj+rdmiFDG5WMdnHFZg==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	david@fromorbit.com,
	chandan.babu@oracle.com,
	akpm@linux-foundation.org,
	mcgrof@kernel.org,
	ziy@nvidia.com,
	hare@suse.de,
	djwong@kernel.org,
	gost.dev@samsung.com,
	linux-mm@kvack.org,
	willy@infradead.org
Subject: [PATCH 01/13] mm: Support order-1 folios in the page cache
Date: Mon, 26 Feb 2024 10:49:24 +0100
Message-ID: <20240226094936.2677493-2-kernel@pankajraghav.com>
In-Reply-To: <20240226094936.2677493-1-kernel@pankajraghav.com>
References: <20240226094936.2677493-1-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Folios of order 1 have no space to store the deferred list.  This is
not a problem for the page cache as file-backed folios are never
placed on the deferred list.  All we need to do is prevent the core
MM from touching the deferred list for order 1 folios and remove the
code which prevented us from allocating order 1 folios.

Link: https://lore.kernel.org/linux-mm/90344ea7-4eec-47ee-5996-0c22f42d6a6a@google.com/
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/huge_mm.h |  7 +++++--
 mm/filemap.c            |  2 --
 mm/huge_memory.c        | 23 ++++++++++++++++++-----
 mm/internal.h           |  4 +---
 mm/readahead.c          |  3 ---
 5 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 5adb86af35fc..916a2a539517 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -263,7 +263,7 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 
-void folio_prep_large_rmappable(struct folio *folio);
+struct folio *folio_prep_large_rmappable(struct folio *folio);
 bool can_split_folio(struct folio *folio, int *pextra_pins);
 int split_huge_page_to_list(struct page *page, struct list_head *list);
 static inline int split_huge_page(struct page *page)
@@ -410,7 +410,10 @@ static inline unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 	return 0;
 }
 
-static inline void folio_prep_large_rmappable(struct folio *folio) {}
+static inline struct folio *folio_prep_large_rmappable(struct folio *folio)
+{
+	return folio;
+}
 
 #define transparent_hugepage_flags 0UL
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 750e779c23db..2b00442b9d19 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1912,8 +1912,6 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 			gfp_t alloc_gfp = gfp;
 
 			err = -ENOMEM;
-			if (order == 1)
-				order = 0;
 			if (order > 0)
 				alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
 			folio = filemap_alloc_folio(alloc_gfp, order);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 94c958f7ebb5..81fd1ba57088 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -788,11 +788,15 @@ struct deferred_split *get_deferred_split_queue(struct folio *folio)
 }
 #endif
 
-void folio_prep_large_rmappable(struct folio *folio)
+struct folio *folio_prep_large_rmappable(struct folio *folio)
 {
-	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
-	INIT_LIST_HEAD(&folio->_deferred_list);
+	if (!folio || !folio_test_large(folio))
+		return folio;
+	if (folio_order(folio) > 1)
+		INIT_LIST_HEAD(&folio->_deferred_list);
 	folio_set_large_rmappable(folio);
+
+	return folio;
 }
 
 static inline bool is_transparent_hugepage(struct folio *folio)
@@ -3082,7 +3086,8 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock(&ds_queue->split_queue_lock);
 	if (folio_ref_freeze(folio, 1 + extra_pins)) {
-		if (!list_empty(&folio->_deferred_list)) {
+		if (folio_order(folio) > 1 &&
+		    !list_empty(&folio->_deferred_list)) {
 			ds_queue->split_queue_len--;
 			list_del(&folio->_deferred_list);
 		}
@@ -3133,6 +3138,9 @@ void folio_undo_large_rmappable(struct folio *folio)
 	struct deferred_split *ds_queue;
 	unsigned long flags;
 
+	if (folio_order(folio) <= 1)
+		return;
+
 	/*
 	 * At this point, there is no one trying to add the folio to
 	 * deferred_list. If folio is not in deferred_list, it's safe
@@ -3158,7 +3166,12 @@ void deferred_split_folio(struct folio *folio)
 #endif
 	unsigned long flags;
 
-	VM_BUG_ON_FOLIO(folio_order(folio) < 2, folio);
+	/*
+	 * Order 1 folios have no space for a deferred list, but we also
+	 * won't waste much memory by not adding them to the deferred list.
+	 */
+	if (folio_order(folio) <= 1)
+		return;
 
 	/*
 	 * The try_to_unmap() in page reclaim path might reach here too,
diff --git a/mm/internal.h b/mm/internal.h
index f309a010d50f..5174b5b0c344 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -419,9 +419,7 @@ static inline struct folio *page_rmappable_folio(struct page *page)
 {
 	struct folio *folio = (struct folio *)page;
 
-	if (folio && folio_order(folio) > 1)
-		folio_prep_large_rmappable(folio);
-	return folio;
+	return folio_prep_large_rmappable(folio);
 }
 
 static inline void prep_compound_head(struct page *page, unsigned int order)
diff --git a/mm/readahead.c b/mm/readahead.c
index 2648ec4f0494..369c70e2be42 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -516,9 +516,6 @@ void page_cache_ra_order(struct readahead_control *ractl,
 		/* Don't allocate pages past EOF */
 		while (index + (1UL << order) - 1 > limit)
 			order--;
-		/* THP machinery does not support order-1 */
-		if (order == 1)
-			order = 0;
 		err = ra_alloc_folio(ractl, index, mark, order, gfp);
 		if (err)
 			break;
-- 
2.43.0


