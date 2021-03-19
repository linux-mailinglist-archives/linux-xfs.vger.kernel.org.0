Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E6534125E
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Mar 2021 02:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhCSBw4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 18 Mar 2021 21:52:56 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:41437 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230203AbhCSBwu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Mar 2021 21:52:50 -0400
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A+G2RhqPfqYtoz8BcTiGjsMiAIKoaSvp033AA?=
 =?us-ascii?q?0UdtRRtJNvGJjszGpoV+6TbYqhY0HEshl9eJJbWaTRrnmKJdzIENMd6ZMjXOl2?=
 =?us-ascii?q?elIYpr54mn4xCIIUfD38FH06MISclDIfnRKXQ/ssrg+gm/FL8bsby62YSln/3X?=
 =?us-ascii?q?wXsobSwCUdAC0y5DBgyWElJ7SWB9bPJXKLOn+sFFqzC8EE5nDPiTO39tZYj+ju?=
 =?us-ascii?q?yOvJfnTDpDPBQ/9TSJ5AnC1JfKVzSewTcSOgki/Ysf?=
X-IronPort-AV: E=Sophos;i="5.81,259,1610380800"; 
   d="scan'208";a="105876647"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 19 Mar 2021 09:52:49 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id A28264CEB2A3;
        Fri, 19 Mar 2021 09:52:46 +0800 (CST)
Received: from G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Fri, 19 Mar 2021 09:52:46 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Fri, 19 Mar 2021 09:52:46 +0800
From:   Shiyang Ruan <ruansy.fnst@fujitsu.com>
To:     <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        <linux-nvdimm@lists.01.org>, <linux-fsdevel@vger.kernel.org>
CC:     <darrick.wong@oracle.com>, <dan.j.williams@intel.com>,
        <willy@infradead.org>, <jack@suse.cz>, <viro@zeniv.linux.org.uk>,
        <linux-btrfs@vger.kernel.org>, <ocfs2-devel@oss.oracle.com>,
        <david@fromorbit.com>, <hch@lst.de>, <rgoldwyn@suse.de>
Subject: [PATCH v3 01/10] fsdax: Factor helpers to simplify dax fault code
Date:   Fri, 19 Mar 2021 09:52:28 +0800
Message-ID: <20210319015237.993880-2-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210319015237.993880-1-ruansy.fnst@fujitsu.com>
References: <20210319015237.993880-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: A28264CEB2A3.A2A18
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The dax page fault code is too long and a bit difficult to read. And it
is hard to understand when we trying to add new features. Some of the
PTE/PMD codes have similar logic. So, factor them as helper functions to
simplify the code.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c | 152 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 84 insertions(+), 68 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 26d5dcd2d69e..7031e4302b13 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1243,6 +1243,52 @@ static bool dax_fault_is_synchronous(unsigned long flags,
 		&& (iomap->flags & IOMAP_F_DIRTY);
 }
 
+/*
+ * If we are doing synchronous page fault and inode needs fsync, we can insert
+ * PTE/PMD into page tables only after that happens. Skip insertion for now and
+ * return the pfn so that caller can insert it after fsync is done.
+ */
+static vm_fault_t dax_fault_synchronous_pfnp(pfn_t *pfnp, pfn_t pfn)
+{
+	if (WARN_ON_ONCE(!pfnp))
+		return VM_FAULT_SIGBUS;
+
+	*pfnp = pfn;
+	return VM_FAULT_NEEDDSYNC;
+}
+
+static int dax_fault_cow_page(struct vm_fault *vmf, struct iomap *iomap,
+		loff_t pos, vm_fault_t *ret)
+{
+	int error = 0;
+	unsigned long vaddr = vmf->address;
+	sector_t sector = dax_iomap_sector(iomap, pos);
+
+	switch (iomap->type) {
+	case IOMAP_HOLE:
+	case IOMAP_UNWRITTEN:
+		clear_user_highpage(vmf->cow_page, vaddr);
+		break;
+	case IOMAP_MAPPED:
+		error = copy_cow_page_dax(iomap->bdev, iomap->dax_dev,
+						sector, vmf->cow_page, vaddr);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		error = -EIO;
+		break;
+	}
+
+	if (error)
+		return error;
+
+	__SetPageUptodate(vmf->cow_page);
+	*ret = finish_fault(vmf);
+	if (!*ret)
+		*ret = VM_FAULT_DONE_COW;
+	return 0;
+}
+
 static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			       int *iomap_errp, const struct iomap_ops *ops)
 {
@@ -1311,30 +1357,9 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	}
 
 	if (vmf->cow_page) {
-		sector_t sector = dax_iomap_sector(&iomap, pos);
-
-		switch (iomap.type) {
-		case IOMAP_HOLE:
-		case IOMAP_UNWRITTEN:
-			clear_user_highpage(vmf->cow_page, vaddr);
-			break;
-		case IOMAP_MAPPED:
-			error = copy_cow_page_dax(iomap.bdev, iomap.dax_dev,
-						  sector, vmf->cow_page, vaddr);
-			break;
-		default:
-			WARN_ON_ONCE(1);
-			error = -EIO;
-			break;
-		}
-
+		error = dax_fault_cow_page(vmf, &iomap, pos, &ret);
 		if (error)
-			goto error_finish_iomap;
-
-		__SetPageUptodate(vmf->cow_page);
-		ret = finish_fault(vmf);
-		if (!ret)
-			ret = VM_FAULT_DONE_COW;
+			ret = dax_fault_return(error);
 		goto finish_iomap;
 	}
 
@@ -1354,19 +1379,8 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
 						 0, write && !sync);
 
-		/*
-		 * If we are doing synchronous page fault and inode needs fsync,
-		 * we can insert PTE into page tables only after that happens.
-		 * Skip insertion for now and return the pfn so that caller can
-		 * insert it after fsync is done.
-		 */
 		if (sync) {
-			if (WARN_ON_ONCE(!pfnp)) {
-				error = -EIO;
-				goto error_finish_iomap;
-			}
-			*pfnp = pfn;
-			ret = VM_FAULT_NEEDDSYNC | major;
+			ret = dax_fault_synchronous_pfnp(pfnp, pfn);
 			goto finish_iomap;
 		}
 		trace_dax_insert_mapping(inode, vmf, entry);
@@ -1465,13 +1479,45 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
 	return VM_FAULT_FALLBACK;
 }
 
+static bool dax_fault_check_fallback(struct vm_fault *vmf, struct xa_state *xas,
+		pgoff_t max_pgoff)
+{
+	unsigned long pmd_addr = vmf->address & PMD_MASK;
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
+
+	/*
+	 * Make sure that the faulting address's PMD offset (color) matches
+	 * the PMD offset from the start of the file.  This is necessary so
+	 * that a PMD range in the page table overlaps exactly with a PMD
+	 * range in the page cache.
+	 */
+	if ((vmf->pgoff & PG_PMD_COLOUR) !=
+	    ((vmf->address >> PAGE_SHIFT) & PG_PMD_COLOUR))
+		return true;
+
+	/* Fall back to PTEs if we're going to COW */
+	if (write && !(vmf->vma->vm_flags & VM_SHARED))
+		return true;
+
+	/* If the PMD would extend outside the VMA */
+	if (pmd_addr < vmf->vma->vm_start)
+		return true;
+	if ((pmd_addr + PMD_SIZE) > vmf->vma->vm_end)
+		return true;
+
+	/* If the PMD would extend beyond the file size */
+	if ((xas->xa_index | PG_PMD_COLOUR) >= max_pgoff)
+		return true;
+
+	return false;
+}
+
 static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			       const struct iomap_ops *ops)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	XA_STATE_ORDER(xas, &mapping->i_pages, vmf->pgoff, PMD_ORDER);
-	unsigned long pmd_addr = vmf->address & PMD_MASK;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	bool sync;
 	unsigned int iomap_flags = (write ? IOMAP_WRITE : 0) | IOMAP_FAULT;
@@ -1494,33 +1540,12 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 	trace_dax_pmd_fault(inode, vmf, max_pgoff, 0);
 
-	/*
-	 * Make sure that the faulting address's PMD offset (color) matches
-	 * the PMD offset from the start of the file.  This is necessary so
-	 * that a PMD range in the page table overlaps exactly with a PMD
-	 * range in the page cache.
-	 */
-	if ((vmf->pgoff & PG_PMD_COLOUR) !=
-	    ((vmf->address >> PAGE_SHIFT) & PG_PMD_COLOUR))
-		goto fallback;
-
-	/* Fall back to PTEs if we're going to COW */
-	if (write && !(vma->vm_flags & VM_SHARED))
-		goto fallback;
-
-	/* If the PMD would extend outside the VMA */
-	if (pmd_addr < vma->vm_start)
-		goto fallback;
-	if ((pmd_addr + PMD_SIZE) > vma->vm_end)
-		goto fallback;
-
 	if (xas.xa_index >= max_pgoff) {
 		result = VM_FAULT_SIGBUS;
 		goto out;
 	}
 
-	/* If the PMD would extend beyond the file size */
-	if ((xas.xa_index | PG_PMD_COLOUR) >= max_pgoff)
+	if (dax_fault_check_fallback(vmf, &xas, max_pgoff))
 		goto fallback;
 
 	/*
@@ -1572,17 +1597,8 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 		entry = dax_insert_entry(&xas, mapping, vmf, entry, pfn,
 						DAX_PMD, write && !sync);
 
-		/*
-		 * If we are doing synchronous page fault and inode needs fsync,
-		 * we can insert PMD into page tables only after that happens.
-		 * Skip insertion for now and return the pfn so that caller can
-		 * insert it after fsync is done.
-		 */
 		if (sync) {
-			if (WARN_ON_ONCE(!pfnp))
-				goto finish_iomap;
-			*pfnp = pfn;
-			result = VM_FAULT_NEEDDSYNC;
+			result = dax_fault_synchronous_pfnp(pfnp, pfn);
 			goto finish_iomap;
 		}
 
-- 
2.30.1



