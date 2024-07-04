Return-Path: <linux-xfs+bounces-10375-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCA369274EE
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Jul 2024 13:25:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0A30AB242F1
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Jul 2024 11:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25D101AC441;
	Thu,  4 Jul 2024 11:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="niHhGXXL"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F7B1AC439;
	Thu,  4 Jul 2024 11:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720092234; cv=none; b=qx9hys1U8BowypMsi/SqDbo9HR+vWNvwoZ6kbQlyJceQNNG9Lsg4oQ0GV7QnWAnSxpc5+FYLbBGECaipSL3y776MTE5XIGnuFpb0s6TT74ghR6eK35rtx5OrhpZxUGZbnw+5JtHM5we1owXiCGnhHrcJ6xBnscygZOBEwkxTihM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720092234; c=relaxed/simple;
	bh=ykuHeCgdfskMcua/wKSJla1pOIn+bCHPrMH2YpuF4XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DR6TV9dAvea5KNxSSqZiDxDuLQJbOKPevsqTg1GhuyyAtUt7e1bq+K3WWnv6JgOVbqJ7XOiIuLC4qsmdusnY3NWqKteye1sCDz2QziYfyM83lTZT0JcVl6R0RI6H4+74hqQiniC1Brbr6d2LkNX05YrjbaIcFaBpvFSkSRuEaYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=niHhGXXL; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4WFDmb3QZCz9tVW;
	Thu,  4 Jul 2024 13:23:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1720092223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/8WfUkcPSa7GHZg7/Pn66GCljLM5KeUQHmwEzlJNP7Q=;
	b=niHhGXXLlGfBFEJjR7uSrNiVvSPbFHkCpsbWC7Q43zY0FGd9RzTzh0H9SncE1I//MU/tM8
	lZUFPg1YI2YDmp2QSUggek1zSomko9Z9Rx9j15dDPqJ+nYQRytcbL5pffF6zoyfyE9+x5y
	V/kEZW5KC9gJJy7fBzJ4zaoW8xKsJGB6E5+JVx23Uy9gJKV1KYySvp2kP/5DVS6frkfHSo
	+7uD3pxnLlSluHwxygKmybygOmxpTqlBP9iKKWtPf2KhdThATzmJnXKvEM5c17VQVGXPZq
	AVdpjRWG2HM+18T8ruhyhr1v9DseqUimBzIa+yfipmogY1CwvXDG5/RQgRGZVw==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: david@fromorbit.com,
	willy@infradead.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	brauner@kernel.org,
	akpm@linux-foundation.org
Cc: yang@os.amperecomputing.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	john.g.garry@oracle.com,
	linux-fsdevel@vger.kernel.org,
	hare@suse.de,
	p.raghav@samsung.com,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	cl@os.amperecomputing.com,
	linux-xfs@vger.kernel.org,
	kernel@pankajraghav.com,
	hch@lst.de,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v9 04/10] mm: split a folio in minimum folio order chunks
Date: Thu,  4 Jul 2024 11:23:14 +0000
Message-ID: <20240704112320.82104-5-kernel@pankajraghav.com>
In-Reply-To: <20240704112320.82104-1-kernel@pankajraghav.com>
References: <20240704112320.82104-1-kernel@pankajraghav.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4WFDmb3QZCz9tVW

From: Luis Chamberlain <mcgrof@kernel.org>

split_folio() and split_folio_to_list() assume order 0, to support
minorder for non-anonymous folios, we must expand these to check the
folio mapping order and use that.

Set new_order to be at least minimum folio order if it is set in
split_huge_page_to_list() so that we can maintain minimum folio order
requirement in the page cache.

Update the debugfs write files used for testing to ensure the order
is respected as well. We simply enforce the min order when a file
mapping is used.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 include/linux/huge_mm.h | 14 ++++++++---
 mm/huge_memory.c        | 55 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 4d155c7a47922..b320a246293ec 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -90,6 +90,8 @@ extern struct kobj_attribute thpsize_shmem_enabled_attr;
 #define thp_vma_allowable_order(vma, vm_flags, tva_flags, order) \
 	(!!thp_vma_allowable_orders(vma, vm_flags, tva_flags, BIT(order)))
 
+#define split_folio(f) split_folio_to_list(f, NULL)
+
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
 #define HPAGE_PMD_SHIFT PMD_SHIFT
 #define HPAGE_PUD_SHIFT PUD_SHIFT
@@ -327,9 +329,10 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
 bool can_split_folio(struct folio *folio, int *pextra_pins);
 int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
+int split_folio_to_list(struct folio *folio, struct list_head *list);
 static inline int split_huge_page(struct page *page)
 {
-	return split_huge_page_to_list_to_order(page, NULL, 0);
+	return split_folio(page_folio(page));
 }
 void deferred_split_folio(struct folio *folio);
 
@@ -501,6 +504,12 @@ static inline int split_huge_page(struct page *page)
 {
 	return 0;
 }
+
+static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
+{
+	return 0;
+}
+
 static inline void deferred_split_folio(struct folio *folio) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
@@ -615,7 +624,4 @@ static inline int split_folio_to_order(struct folio *folio, int new_order)
 	return split_folio_to_list_to_order(folio, NULL, new_order);
 }
 
-#define split_folio_to_list(f, l) split_folio_to_list_to_order(f, l, 0)
-#define split_folio(f) split_folio_to_order(f, 0)
-
 #endif /* _LINUX_HUGE_MM_H */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index a633206375af1..2fd45d8730bab 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3062,6 +3062,9 @@ bool can_split_folio(struct folio *folio, int *pextra_pins)
  * released, or if some unexpected race happened (e.g., anon VMA disappeared,
  * truncation).
  *
+ * Callers should ensure that the order respects the address space mapping
+ * min-order if one is set for non-anonymous folios.
+ *
  * Returns -EINVAL when trying to split to an order that is incompatible
  * with the folio. Splitting to order 0 is compatible with all folios.
  */
@@ -3143,6 +3146,7 @@ int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		mapping = NULL;
 		anon_vma_lock_write(anon_vma);
 	} else {
+		unsigned int min_order;
 		gfp_t gfp;
 
 		mapping = folio->mapping;
@@ -3153,6 +3157,14 @@ int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 			goto out;
 		}
 
+		min_order = mapping_min_folio_order(folio->mapping);
+		if (new_order < min_order) {
+			VM_WARN_ONCE(1, "Cannot split mapped folio below min-order: %u",
+				     min_order);
+			ret = -EINVAL;
+			goto out;
+		}
+
 		gfp = current_gfp_context(mapping_gfp_mask(mapping) &
 							GFP_RECLAIM_MASK);
 
@@ -3265,6 +3277,21 @@ int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 	return ret;
 }
 
+int split_folio_to_list(struct folio *folio, struct list_head *list)
+{
+	unsigned int min_order = 0;
+
+	if (!folio_test_anon(folio)) {
+		if (!folio->mapping && folio_test_pmd_mappable(folio)) {
+			count_vm_event(THP_SPLIT_PAGE_FAILED);
+			return -EBUSY;
+		}
+		min_order = mapping_min_folio_order(folio->mapping);
+	}
+
+	return split_huge_page_to_list_to_order(&folio->page, list, min_order);
+}
+
 void __folio_undo_large_rmappable(struct folio *folio)
 {
 	struct deferred_split *ds_queue;
@@ -3496,6 +3523,8 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 		struct vm_area_struct *vma = vma_lookup(mm, addr);
 		struct page *page;
 		struct folio *folio;
+		struct address_space *mapping;
+		unsigned int target_order = new_order;
 
 		if (!vma)
 			break;
@@ -3516,7 +3545,13 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 		if (!is_transparent_hugepage(folio))
 			goto next;
 
-		if (new_order >= folio_order(folio))
+		if (!folio_test_anon(folio)) {
+			mapping = folio->mapping;
+			target_order = max(new_order,
+					   mapping_min_folio_order(mapping));
+		}
+
+		if (target_order >= folio_order(folio))
 			goto next;
 
 		total++;
@@ -3532,9 +3567,13 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 		if (!folio_trylock(folio))
 			goto next;
 
-		if (!split_folio_to_order(folio, new_order))
+		if (!folio_test_anon(folio) && folio->mapping != mapping)
+			goto unlock;
+
+		if (!split_folio_to_order(folio, target_order))
 			split++;
 
+unlock:
 		folio_unlock(folio);
 next:
 		folio_put(folio);
@@ -3559,6 +3598,7 @@ static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
 	pgoff_t index;
 	int nr_pages = 1;
 	unsigned long total = 0, split = 0;
+	unsigned int min_order;
 
 	file = getname_kernel(file_path);
 	if (IS_ERR(file))
@@ -3572,9 +3612,11 @@ static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
 		 file_path, off_start, off_end);
 
 	mapping = candidate->f_mapping;
+	min_order = mapping_min_folio_order(mapping);
 
 	for (index = off_start; index < off_end; index += nr_pages) {
 		struct folio *folio = filemap_get_folio(mapping, index);
+		unsigned int target_order = new_order;
 
 		nr_pages = 1;
 		if (IS_ERR(folio))
@@ -3583,18 +3625,23 @@ static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
 		if (!folio_test_large(folio))
 			goto next;
 
+		target_order = max(new_order, min_order);
 		total++;
 		nr_pages = folio_nr_pages(folio);
 
-		if (new_order >= folio_order(folio))
+		if (target_order >= folio_order(folio))
 			goto next;
 
 		if (!folio_trylock(folio))
 			goto next;
 
-		if (!split_folio_to_order(folio, new_order))
+		if (folio->mapping != mapping)
+			goto unlock;
+
+		if (!split_folio_to_order(folio, target_order))
 			split++;
 
+unlock:
 		folio_unlock(folio);
 next:
 		folio_put(folio);
-- 
2.44.1


