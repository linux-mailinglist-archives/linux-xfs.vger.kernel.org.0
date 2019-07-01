Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F32AA21464
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 09:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfEQHcj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 03:32:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44114 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbfEQHcj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fLYs2aerwOAlnNoC4Eo1dfBF94lfBEs8/AZ+5y/gRWE=; b=XslICnZbt+lGmjdEGqz9BvFCY
        EeP4Jk65o0HcWKKpDt8Ld900784y2vJiGxW4aGq16cNsPcd0cRxjTNKmnGM71jUTigBKRbWPSxl8k
        CF9NaAU5OKfQaYFlvOdZKxndh6KnJuF40/REdR7AZocPqbPhteAZ/dbKSQk486gWyArs9FraeUdvR
        +al2/C7sLEq4Pvs3c8lANAtQIFRM+0VtzCboNcxR765Y9eWuqLXnJ20LUzFzuxDtULS6h28ZhEPgm
        5QJnk/FwSvTlq24f9hp1ZGWJF3zJ+BsmIf36jHDwEr/AVAmowCMdHpFAIesw4r0QazJgYFSDqA66l
        xCJam1KDg==;
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXM6-0000n4-Mo
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/20] xfs: remove a pointless comment duplicated above all xfs_item_ops instances
Date:   Fri, 17 May 2019 09:31:11 +0200
Message-Id: <20190517073119.30178-13-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190517073119.30178-1-hch@lst.de>
References: <20190517073119.30178-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_item.c     | 6 ------
 fs/xfs/xfs_buf_item.c      | 3 ---
 fs/xfs/xfs_dquot_item.c    | 6 ------
 fs/xfs/xfs_extfree_item.c  | 6 ------
 fs/xfs/xfs_icreate_item.c  | 3 ---
 fs/xfs/xfs_inode_item.c    | 3 ---
 fs/xfs/xfs_refcount_item.c | 6 ------
 fs/xfs/xfs_rmap_item.c     | 6 ------
 8 files changed, 39 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index d7ceb2d1ae82..46dcadf790c2 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -125,9 +125,6 @@ xfs_bui_item_release(
 	xfs_bui_release(BUI_ITEM(lip));
 }
 
-/*
- * This is the ops vector shared by all bui log items.
- */
 static const struct xfs_item_ops xfs_bui_item_ops = {
 	.iop_size	= xfs_bui_item_size,
 	.iop_format	= xfs_bui_item_format,
@@ -208,9 +205,6 @@ xfs_bud_item_release(
 	kmem_zone_free(xfs_bud_zone, budp);
 }
 
-/*
- * This is the ops vector shared by all bud log items.
- */
 static const struct xfs_item_ops xfs_bud_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_ON_COMMIT,
 	.iop_size	= xfs_bud_item_size,
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 05eefc677cd8..2c7aef61ea92 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -679,9 +679,6 @@ xfs_buf_item_committed(
 	return lsn;
 }
 
-/*
- * This is the ops vector shared by all buf log items.
- */
 static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_size	= xfs_buf_item_size,
 	.iop_format	= xfs_buf_item_format,
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index b8fd81641dfc..ade4520d3fdf 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -222,9 +222,6 @@ xfs_qm_dquot_logitem_committing(
 	return xfs_qm_dquot_logitem_release(lip);
 }
 
-/*
- * This is the ops vector for dquots
- */
 static const struct xfs_item_ops xfs_dquot_item_ops = {
 	.iop_size	= xfs_qm_dquot_logitem_size,
 	.iop_format	= xfs_qm_dquot_logitem_format,
@@ -320,9 +317,6 @@ static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
 	.iop_committed	= xfs_qm_qoffend_logitem_committed,
 };
 
-/*
- * This is the ops vector shared by all quotaoff-start log items.
- */
 static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
 	.iop_size	= xfs_qm_qoff_logitem_size,
 	.iop_format	= xfs_qm_qoff_logitem_format,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 762eb288dfe8..bb0b1e942d00 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -135,9 +135,6 @@ xfs_efi_item_release(
 	xfs_efi_release(EFI_ITEM(lip));
 }
 
-/*
- * This is the ops vector shared by all efi log items.
- */
 static const struct xfs_item_ops xfs_efi_item_ops = {
 	.iop_size	= xfs_efi_item_size,
 	.iop_format	= xfs_efi_item_format,
@@ -307,9 +304,6 @@ xfs_efd_item_release(
 	xfs_efd_item_free(efdp);
 }
 
-/*
- * This is the ops vector shared by all efd log items.
- */
 static const struct xfs_item_ops xfs_efd_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_ON_COMMIT,
 	.iop_size	= xfs_efd_item_size,
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index eb9cb04635be..4f1ce50ce323 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -63,9 +63,6 @@ xfs_icreate_item_release(
 	kmem_zone_free(xfs_icreate_zone, ICR_ITEM(lip));
 }
 
-/*
- * This is the ops vector shared by all buf log items.
- */
 static const struct xfs_item_ops xfs_icreate_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_ON_COMMIT,
 	.iop_size	= xfs_icreate_item_size,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index a00f0b6aecc7..62847e95b399 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -627,9 +627,6 @@ xfs_inode_item_committing(
 	return xfs_inode_item_release(lip);
 }
 
-/*
- * This is the ops vector shared by all buf log items.
- */
 static const struct xfs_item_ops xfs_inode_item_ops = {
 	.iop_size	= xfs_inode_item_size,
 	.iop_format	= xfs_inode_item_format,
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index b4ab71ce39fc..2b2f6e7ad867 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -124,9 +124,6 @@ xfs_cui_item_release(
 	xfs_cui_release(CUI_ITEM(lip));
 }
 
-/*
- * This is the ops vector shared by all cui log items.
- */
 static const struct xfs_item_ops xfs_cui_item_ops = {
 	.iop_size	= xfs_cui_item_size,
 	.iop_format	= xfs_cui_item_format,
@@ -213,9 +210,6 @@ xfs_cud_item_release(
 	kmem_zone_free(xfs_cud_zone, cudp);
 }
 
-/*
- * This is the ops vector shared by all cud log items.
- */
 static const struct xfs_item_ops xfs_cud_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_ON_COMMIT,
 	.iop_size	= xfs_cud_item_size,
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 1b35b3d38708..dce1357aef88 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -123,9 +123,6 @@ xfs_rui_item_release(
 	xfs_rui_release(RUI_ITEM(lip));
 }
 
-/*
- * This is the ops vector shared by all rui log items.
- */
 static const struct xfs_item_ops xfs_rui_item_ops = {
 	.iop_size	= xfs_rui_item_size,
 	.iop_format	= xfs_rui_item_format,
@@ -234,9 +231,6 @@ xfs_rud_item_release(
 	kmem_zone_free(xfs_rud_zone, rudp);
 }
 
-/*
- * This is the ops vector shared by all rud log items.
- */
 static const struct xfs_item_ops xfs_rud_item_ops = {
 	.flags		= XFS_ITEM_RELEASE_ON_COMMIT,
 	.iop_size	= xfs_rud_item_size,
-- 
2.20.1

