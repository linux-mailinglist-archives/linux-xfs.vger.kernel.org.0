Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC1722145D
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 09:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbfEQHcX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 03:32:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44064 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbfEQHcV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yU8AqC+THKDcz8+fwYgEoERcDVfc1qEdcBiSDd7uOFc=; b=RN3zkQWhZkXMLP8yURslx/fvI
        jOvxfZnIC/9iIwy30BezR9u+RB74NLBdlCcgkFT3gijLmLUwMIMdCMFauiN/kj8C+V/I7wMgV7rBv
        jZvpNGVF7nAm92U1Pj5bvQYEFdJCeJ9p+QOvegjW61OblNkzxFtRXbv0kuhi+OtkMxliW8TyA7Iyl
        aIZPNYnTpaWx+zosLpxhORbncLtYqzhzyoKgsNJpnhHxrV2vjmrLcriv2jD79Br/conepR3wBvrCj
        8YuO1DyNuSUSkmG80iMYEPlNwFrMB5n3bOdz+T/ASwWzbBE+lfZsbBZioZ5409FTWfCoTrlH2Rsd5
        JdCHXr1mQ==;
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXLp-0000jl-21
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/20] xfs: remove the iop_push implementation for quota off items
Date:   Fri, 17 May 2019 09:31:04 +0200
Message-Id: <20190517073119.30178-6-hch@lst.de>
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

If we want to push the log to make progress on the items we'd need to
return XFS_ITEM_PINNED instead of XFS_ITEM_LOCKED.  Removing the
method will do exactly that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot_item.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 486eea151fdb..a61a8a770d7f 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -288,18 +288,6 @@ xfs_qm_qoff_logitem_format(
 	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_qoff_logitem));
 }
 
-/*
- * There isn't much you can do to push a quotaoff item.  It is simply
- * stuck waiting for the log to be flushed to disk.
- */
-STATIC uint
-xfs_qm_qoff_logitem_push(
-	struct xfs_log_item	*lip,
-	struct list_head	*buffer_list)
-{
-	return XFS_ITEM_LOCKED;
-}
-
 STATIC xfs_lsn_t
 xfs_qm_qoffend_logitem_committed(
 	struct xfs_log_item	*lip,
@@ -327,7 +315,6 @@ static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
 	.iop_size	= xfs_qm_qoff_logitem_size,
 	.iop_format	= xfs_qm_qoff_logitem_format,
 	.iop_committed	= xfs_qm_qoffend_logitem_committed,
-	.iop_push	= xfs_qm_qoff_logitem_push,
 };
 
 /*
@@ -336,7 +323,6 @@ static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
 static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
 	.iop_size	= xfs_qm_qoff_logitem_size,
 	.iop_format	= xfs_qm_qoff_logitem_format,
-	.iop_push	= xfs_qm_qoff_logitem_push,
 };
 
 /*
-- 
2.20.1

