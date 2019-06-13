Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA6F44A2C
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 20:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfFMSDY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 14:03:24 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57462 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfFMSDX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1Do4PwYFV6ngn3tqQyzCG30LuvIk0GCIsy8PR+N+X9s=; b=fSVd0eVGvscVBINHctA93L+05K
        jGNF7F/ZBs9Y+DkJD+nT0Ui77gL2lJHXjIu3v1Ad0TQHJd4d7puMxD2FofzJbGIexKPw/UutViMFa
        z7YWzlOqTY7HkO7Yv/jUIau7lgrq2ylXGTzrWd6Olxs1rmrXTnP8CTX3HFjFkgXnEz2ryv52V/RhH
        jA6jk+m0veR8CEylw1zUiPNrYZx9tuh+xE/ujI6iY/etCaE5+BQ0XRSx3V6dtvB/I/mVmU2xQf1OQ
        WNzk05j2WTNVRxr6K9jSIN5G6xMbl3bPDfq7SQlxaDbRdHkzZ5/ejc1G4ocLf8hj2gqvSf0NFvr/G
        R0w9RrtA==;
Received: from [213.208.157.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbU4J-0002iE-FU; Thu, 13 Jun 2019 18:03:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH 09/20] xfs: don't cast inode_log_items to get the log_item
Date:   Thu, 13 Jun 2019 20:02:49 +0200
Message-Id: <20190613180300.30447-10-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190613180300.30447-1-hch@lst.de>
References: <20190613180300.30447-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The cast is not type safe, and we can just dereference the first
member instead to start with.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 71d216cf6f87..419eae485ff3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -485,7 +485,7 @@ xfs_lock_inodes(
 		 */
 		if (!try_lock) {
 			for (j = (i - 1); j >= 0 && !try_lock; j--) {
-				lp = (xfs_log_item_t *)ips[j]->i_itemp;
+				lp = &ips[j]->i_itemp->ili_item;
 				if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags))
 					try_lock++;
 			}
@@ -585,7 +585,7 @@ xfs_lock_two_inodes(
 	 * the second lock. If we can't get it, we must release the first one
 	 * and try again.
 	 */
-	lp = (xfs_log_item_t *)ip0->i_itemp;
+	lp = &ip0->i_itemp->ili_item;
 	if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags)) {
 		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(ip1_mode, 1))) {
 			xfs_iunlock(ip0, ip0_mode);
-- 
2.20.1

