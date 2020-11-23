Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5812BFDBB
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Nov 2020 01:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgKWAl4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 22 Nov 2020 19:41:56 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44490 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726822AbgKWAlz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Nov 2020 19:41:55 -0500
X-IronPort-AV: E=Sophos;i="5.78,361,1599494400"; 
   d="scan'208";a="101635244"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 23 Nov 2020 08:41:47 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id C14ED4CE5472;
        Mon, 23 Nov 2020 08:41:44 +0800 (CST)
Received: from G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.203) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Mon, 23 Nov 2020 08:41:46 +0800
Received: from localhost.localdomain (10.167.225.141) by
 G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 08:41:44 +0800
From:   Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To:     <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        <linux-nvdimm@lists.01.org>, <linux-mm@kvack.org>
CC:     <linux-fsdevel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        <darrick.wong@oracle.com>, <dan.j.williams@intel.com>,
        <david@fromorbit.com>, <hch@lst.de>, <song@kernel.org>,
        <rgoldwyn@suse.de>, <qi.fuli@fujitsu.com>, <y-goto@fujitsu.com>
Subject: [RFC PATCH v2 5/6] mm, fsdax: refactor dax handler in memory-failure
Date:   Mon, 23 Nov 2020 08:41:15 +0800
Message-ID: <20201123004116.2453-6-ruansy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123004116.2453-1-ruansy.fnst@cn.fujitsu.com>
References: <20201123004116.2453-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: C14ED4CE5472.AD4E4
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

With the ->memory_failure() implemented in pmem device and
->storage_lost() in XFS, we are able to track files or metadata
and process them further.

We don't track files by page->mapping, page->index any more, so
some of functions who obtain ->mapping, ->index from struct page
parameter need to be changed by directly passing mapping and index.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 fs/dax.c            |  18 +++----
 include/linux/dax.h |   5 +-
 include/linux/mm.h  |   8 +++
 mm/memory-failure.c | 127 +++++++++++++++++++++++++++-----------------
 4 files changed, 94 insertions(+), 64 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 5b47834f2e1b..34471acde683 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -379,14 +379,14 @@ static struct page *dax_busy_page(void *entry)
 }
 
 /*
- * dax_lock_mapping_entry - Lock the DAX entry corresponding to a page
+ * dax_lock - Lock the DAX entry corresponding to a page
  * @page: The page whose entry we want to lock
  *
  * Context: Process context.
  * Return: A cookie to pass to dax_unlock_page() or 0 if the entry could
  * not be locked.
  */
-dax_entry_t dax_lock_page(struct page *page)
+dax_entry_t dax_lock(struct address_space *mapping, pgoff_t index)
 {
 	XA_STATE(xas, NULL, 0);
 	void *entry;
@@ -394,8 +394,6 @@ dax_entry_t dax_lock_page(struct page *page)
 	/* Ensure page->mapping isn't freed while we look at it */
 	rcu_read_lock();
 	for (;;) {
-		struct address_space *mapping = READ_ONCE(page->mapping);
-
 		entry = NULL;
 		if (!mapping || !dax_mapping(mapping))
 			break;
@@ -413,11 +411,7 @@ dax_entry_t dax_lock_page(struct page *page)
 
 		xas.xa = &mapping->i_pages;
 		xas_lock_irq(&xas);
-		if (mapping != page->mapping) {
-			xas_unlock_irq(&xas);
-			continue;
-		}
-		xas_set(&xas, page->index);
+		xas_set(&xas, index);
 		entry = xas_load(&xas);
 		if (dax_is_locked(entry)) {
 			rcu_read_unlock();
@@ -433,10 +427,10 @@ dax_entry_t dax_lock_page(struct page *page)
 	return (dax_entry_t)entry;
 }
 
-void dax_unlock_page(struct page *page, dax_entry_t cookie)
+void dax_unlock(struct address_space *mapping, pgoff_t index,
+		dax_entry_t cookie)
 {
-	struct address_space *mapping = page->mapping;
-	XA_STATE(xas, &mapping->i_pages, page->index);
+	XA_STATE(xas, &mapping->i_pages, index);
 
 	if (S_ISCHR(mapping->host->i_mode))
 		return;
diff --git a/include/linux/dax.h b/include/linux/dax.h
index b52f084aa643..a8d697eb886c 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -150,8 +150,9 @@ int dax_writeback_mapping_range(struct address_space *mapping,
 
 struct page *dax_layout_busy_page(struct address_space *mapping);
 struct page *dax_layout_busy_page_range(struct address_space *mapping, loff_t start, loff_t end);
-dax_entry_t dax_lock_page(struct page *page);
-void dax_unlock_page(struct page *page, dax_entry_t cookie);
+dax_entry_t dax_lock(struct address_space *mapping, pgoff_t index);
+void dax_unlock(struct address_space *mapping, pgoff_t index,
+		dax_entry_t cookie);
 #else
 static inline bool bdev_dax_supported(struct block_device *bdev,
 		int blocksize)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 872b51ebe57b..729448ed10b7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1141,6 +1141,14 @@ static inline bool is_device_private_page(const struct page *page)
 		page->pgmap->type == MEMORY_DEVICE_PRIVATE;
 }
 
+static inline bool is_device_fsdax_page(const struct page *page)
+{
+	return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) &&
+		IS_ENABLED(CONFIG_DEVICE_PRIVATE) &&
+		is_zone_device_page(page) &&
+		page->pgmap->type == MEMORY_DEVICE_FS_DAX;
+}
+
 static inline bool is_pci_p2pdma_page(const struct page *page)
 {
 	return IS_ENABLED(CONFIG_DEV_PAGEMAP_OPS) &&
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index c0bb186bba62..f8f80458746e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -120,6 +120,9 @@ static int hwpoison_filter_dev(struct page *p)
 	if (PageSlab(p))
 		return -EINVAL;
 
+	if (is_device_fsdax_page(p))
+		return 0;
+
 	mapping = page_mapping(p);
 	if (mapping == NULL || mapping->host == NULL)
 		return -EINVAL;
@@ -290,9 +293,8 @@ void shake_page(struct page *p, int access)
 EXPORT_SYMBOL_GPL(shake_page);
 
 static unsigned long dev_pagemap_mapping_shift(struct page *page,
-		struct vm_area_struct *vma)
+		struct vm_area_struct *vma, unsigned long address)
 {
-	unsigned long address = vma_address(page, vma);
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
@@ -333,8 +335,8 @@ static unsigned long dev_pagemap_mapping_shift(struct page *page,
  * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
  */
 static void add_to_kill(struct task_struct *tsk, struct page *p,
-		       struct vm_area_struct *vma,
-		       struct list_head *to_kill)
+		       struct address_space *mapping, pgoff_t pgoff,
+		       struct vm_area_struct *vma, struct list_head *to_kill)
 {
 	struct to_kill *tk;
 
@@ -344,12 +346,18 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
 		return;
 	}
 
-	tk->addr = page_address_in_vma(p, vma);
-	if (is_zone_device_page(p))
-		tk->size_shift = dev_pagemap_mapping_shift(p, vma);
-	else
-		tk->size_shift = page_shift(compound_head(p));
-
+	if (is_device_fsdax_page(p)) {
+		tk->addr = vma->vm_start +
+				((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+		tk->size_shift = dev_pagemap_mapping_shift(p, vma, tk->addr);
+	} else {
+		tk->addr = page_address_in_vma(p, vma);
+		if (is_zone_device_page(p)) {
+			tk->size_shift = dev_pagemap_mapping_shift(p, vma,
+							vma_address(p, vma));
+		} else
+			tk->size_shift = page_shift(compound_head(p));
+	}
 	/*
 	 * Send SIGKILL if "tk->addr == -EFAULT". Also, as
 	 * "tk->size_shift" is always non-zero for !is_zone_device_page(),
@@ -495,7 +503,7 @@ static void collect_procs_anon(struct page *page, struct list_head *to_kill,
 			if (!page_mapped_in_vma(page, vma))
 				continue;
 			if (vma->vm_mm == t->mm)
-				add_to_kill(t, page, vma, to_kill);
+				add_to_kill(t, page, NULL, 0, vma, to_kill);
 		}
 	}
 	read_unlock(&tasklist_lock);
@@ -505,24 +513,20 @@ static void collect_procs_anon(struct page *page, struct list_head *to_kill,
 /*
  * Collect processes when the error hit a file mapped page.
  */
-static void collect_procs_file(struct page *page, struct list_head *to_kill,
-				int force_early)
+static void collect_procs_file(struct page *page, struct address_space *mapping,
+		pgoff_t pgoff, struct list_head *to_kill, int force_early)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
-	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff;
 
 	i_mmap_lock_read(mapping);
 	read_lock(&tasklist_lock);
 	pgoff = page_to_pgoff(page);
 	for_each_process(tsk) {
 		struct task_struct *t = task_early_kill(tsk, force_early);
-
 		if (!t)
 			continue;
-		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff,
-				      pgoff) {
+		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 			/*
 			 * Send early kill signal to tasks where a vma covers
 			 * the page but the corrupted page is not necessarily
@@ -530,8 +534,10 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
 			 * Assume applications who requested early kill want
 			 * to be informed of all such data corruptions.
 			 */
-			if (vma->vm_mm == t->mm)
-				add_to_kill(t, page, vma, to_kill);
+			if (vma->vm_mm == t->mm) {
+				add_to_kill(t, page, mapping, pgoff, vma,
+					    to_kill);
+			}
 		}
 	}
 	read_unlock(&tasklist_lock);
@@ -550,7 +556,8 @@ static void collect_procs(struct page *page, struct list_head *tokill,
 	if (PageAnon(page))
 		collect_procs_anon(page, tokill, force_early);
 	else
-		collect_procs_file(page, tokill, force_early);
+		collect_procs_file(page, page->mapping, page_to_pgoff(page),
+				   tokill, force_early);
 }
 
 static const char *action_name[] = {
@@ -1221,14 +1228,14 @@ static int memory_failure_hugetlb(unsigned long pfn, int flags)
 	return res;
 }
 
-static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
-		struct dev_pagemap *pgmap)
+static int memory_failure_dev_pagemap_kill_procs(unsigned long pfn, int flags,
+		struct address_space *mapping, pgoff_t index)
 {
 	struct page *page = pfn_to_page(pfn);
 	const bool unmap_success = true;
 	unsigned long size = 0;
 	struct to_kill *tk;
-	LIST_HEAD(tokill);
+	LIST_HEAD(to_kill);
 	int rc = -EBUSY;
 	loff_t start;
 	dax_entry_t cookie;
@@ -1240,28 +1247,9 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	 * also prevents changes to the mapping of this pfn until
 	 * poison signaling is complete.
 	 */
-	cookie = dax_lock_page(page);
+	cookie = dax_lock(mapping, index);
 	if (!cookie)
-		goto out;
-
-	if (hwpoison_filter(page)) {
-		rc = 0;
-		goto unlock;
-	}
-
-	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
-		/*
-		 * TODO: Handle HMM pages which may need coordination
-		 * with device-side memory.
-		 */
 		goto unlock;
-	}
-
-	/*
-	 * Use this flag as an indication that the dax page has been
-	 * remapped UC to prevent speculative consumption of poison.
-	 */
-	SetPageHWPoison(page);
 
 	/*
 	 * Unlike System-RAM there is no possibility to swap in a
@@ -1270,9 +1258,10 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	 * SIGBUS (i.e. MF_MUST_KILL)
 	 */
 	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
-	collect_procs(page, &tokill, flags & MF_ACTION_REQUIRED);
+	collect_procs_file(page, mapping, index, &to_kill,
+			   flags & MF_ACTION_REQUIRED);
 
-	list_for_each_entry(tk, &tokill, nd)
+	list_for_each_entry(tk, &to_kill, nd)
 		if (tk->size_shift)
 			size = max(size, 1UL << tk->size_shift);
 	if (size) {
@@ -1282,13 +1271,51 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 		 * actual size of the mapping being torn down is
 		 * communicated in siginfo, see kill_proc()
 		 */
-		start = (page->index << PAGE_SHIFT) & ~(size - 1);
-		unmap_mapping_range(page->mapping, start, start + size, 0);
+		start = (index << PAGE_SHIFT) & ~(size - 1);
+		unmap_mapping_range(mapping, start, start + size, 0);
 	}
-	kill_procs(&tokill, flags & MF_MUST_KILL, !unmap_success, pfn, flags);
+
+	kill_procs(&to_kill, flags & MF_MUST_KILL, !unmap_success, pfn, flags);
 	rc = 0;
 unlock:
-	dax_unlock_page(page, cookie);
+	dax_unlock(mapping, index, cookie);
+	return rc;
+}
+
+static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
+		struct dev_pagemap *pgmap)
+{
+	struct page *page = pfn_to_page(pfn);
+	struct mf_recover_controller mfrc = {
+		.recover_fn = memory_failure_dev_pagemap_kill_procs,
+		.pfn = pfn,
+		.flags = flags,
+	};
+	int rc;
+
+	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
+		/*
+		 * TODO: Handle HMM pages which may need coordination
+		 * with device-side memory.
+		 */
+		goto out;
+	}
+
+	if (hwpoison_filter(page)) {
+		rc = 0;
+		goto out;
+	}
+
+	/*
+	 * Use this flag as an indication that the dax page has been
+	 * remapped UC to prevent speculative consumption of poison.
+	 */
+	SetPageHWPoison(page);
+
+	/* call driver to handle the memory failure */
+	if (pgmap->ops->memory_failure)
+		rc = pgmap->ops->memory_failure(pgmap, &mfrc);
+
 out:
 	/* drop pgmap ref acquired in caller */
 	put_dev_pagemap(pgmap);
-- 
2.29.2



