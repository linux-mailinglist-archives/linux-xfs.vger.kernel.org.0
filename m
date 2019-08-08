Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB715864AC
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Aug 2019 16:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732696AbfHHOrB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 8 Aug 2019 10:47:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50870 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730678AbfHHOrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Aug 2019 10:47:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x78Ej1oF071374
        for <linux-xfs@vger.kernel.org>; Thu, 8 Aug 2019 14:46:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=8w7jtpnfNUWwy2sBpYUCUyGWjmC0Wknhel3C1mkteSI=;
 b=rzIIvVQD6nFbOlSpC/07DmYEFx8bXtcW86l6rg3SjBxJSVxHuHX/6NjTLVu7fh7uxp0z
 7zelIl+fxqsTF5Ak05mZHCqOEvZKKYWmhshSySIhDf9OKImyCvqbMndPW+ph+EqVdx7l
 m46p0whtWICwZMgbjATncSfcwhZCe+Oo6HAYXTf0ywnygKpUe9dBO25M+0yvPl9ZUdfN
 k+glfQV/uv/BsEq58LlQQLcJVD8EvOP38H76nGaSozmb7ra4mezCRot31hYbn1fw6XpY
 05n4F+avFeCa8Gjl1KLp1xbkD2xNc3XcdvDJlM4CNc7LCXQaCG82KAJpM4krReOLlwjg nw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=8w7jtpnfNUWwy2sBpYUCUyGWjmC0Wknhel3C1mkteSI=;
 b=bqRNkEtxDqPDjD1MjYlhgR/AtZXerbP2DK7LJOcQhMETUk9xvxKBZwgqEvbT+re2LORE
 pVZg3bddKdGpg4jZYij9fpSGP3mOdPtzKih8cXzon+wV7+kD+1HIhw1K+PWIKdT1jE8y
 qij66pOIZ/v1QwJPBxrYxG8JLrfXbHD70Z5Y3taIMz1pCyT9zEVg9DMjq0vkQOGPv9CB
 smm6J7YLWvcyc8+ZPHsJPE7p00QrVpXsyUA3AYHe33XY2Rzlxo7GkitCNZWaOu1lFwsQ
 sQteSzY20fXG/lcPdkAnXUQ5DxwOgQvafZiWP8etzK8TzVdgZU2gKyBu6uk/zdyaudPE GA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u8hps1kpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2019 14:46:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x78EgvH1136087
        for <linux-xfs@vger.kernel.org>; Thu, 8 Aug 2019 14:46:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2u75798rd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2019 14:46:58 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x78EkvMX024712
        for <linux-xfs@vger.kernel.org>; Thu, 8 Aug 2019 14:46:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Aug 2019 07:46:57 -0700
Subject: [PATCH 1/3] vfs: fix page locking deadlocks when deduping files
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 08 Aug 2019 07:46:56 -0700
Message-ID: <156527561641.1960675.7113883901730327475.stgit@magnolia>
In-Reply-To: <156527561023.1960675.17007470833732765300.stgit@magnolia>
References: <156527561023.1960675.17007470833732765300.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=983
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908080147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908080147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When dedupe wants to use the page cache to compare parts of two files
for dedupe, we must be very careful to handle locking correctly.  The
current code doesn't do this.  It must lock and unlock the page only
once if the two pages are the same, since the overlapping range check
doesn't catch this when blocksize < pagesize.  If the pages are distinct
but from the same file, we must observe page locking order and lock them
in order of increasing offset to avoid clashing with writeback locking.

Fixes: 876bec6f9bbfcb3 ("vfs: refactor clone/dedupe_file_range common functions")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/read_write.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index 1f5088dec566..4dbdccffa59e 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1811,10 +1811,7 @@ static int generic_remap_check_len(struct inode *inode_in,
 	return (remap_flags & REMAP_FILE_DEDUP) ? -EBADE : -EINVAL;
 }
 
-/*
- * Read a page's worth of file data into the page cache.  Return the page
- * locked.
- */
+/* Read a page's worth of file data into the page cache. */
 static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
 {
 	struct page *page;
@@ -1826,10 +1823,32 @@ static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
 		put_page(page);
 		return ERR_PTR(-EIO);
 	}
-	lock_page(page);
 	return page;
 }
 
+/*
+ * Lock two pages, ensuring that we lock in offset order if the pages are from
+ * the same file.
+ */
+static void vfs_lock_two_pages(struct page *page1, struct page *page2)
+{
+	/* Always lock in order of increasing index. */
+	if (page1->index > page2->index)
+		swap(page1, page2);
+
+	lock_page(page1);
+	if (page1 != page2)
+		lock_page(page2);
+}
+
+/* Unlock two pages, being careful not to unlock the same page twice. */
+static void vfs_unlock_two_pages(struct page *page1, struct page *page2)
+{
+	unlock_page(page1);
+	if (page1 != page2)
+		unlock_page(page2);
+}
+
 /*
  * Compare extents of two files to see if they are the same.
  * Caller must have locked both inodes to prevent write races.
@@ -1867,10 +1886,12 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 		dest_page = vfs_dedupe_get_page(dest, destoff);
 		if (IS_ERR(dest_page)) {
 			error = PTR_ERR(dest_page);
-			unlock_page(src_page);
 			put_page(src_page);
 			goto out_error;
 		}
+
+		vfs_lock_two_pages(src_page, dest_page);
+
 		src_addr = kmap_atomic(src_page);
 		dest_addr = kmap_atomic(dest_page);
 
@@ -1882,8 +1903,7 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 
 		kunmap_atomic(dest_addr);
 		kunmap_atomic(src_addr);
-		unlock_page(dest_page);
-		unlock_page(src_page);
+		vfs_unlock_two_pages(src_page, dest_page);
 		put_page(dest_page);
 		put_page(src_page);
 

