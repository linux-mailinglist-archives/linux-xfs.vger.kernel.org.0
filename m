Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF0544A28
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 20:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfFMSDP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 14:03:15 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57440 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfFMSDP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yU8AqC+THKDcz8+fwYgEoERcDVfc1qEdcBiSDd7uOFc=; b=e5m/uuNYsx+GcIUE7KR6ay4vn
        QsOOGke0mT4cDnlqYwPVQMK8Vzz3r6qpMLTlo9hZYB2/3gR0dHHUM8eq5CBqyYiGFtXoKPF31bMQM
        7YCgcJnmLJQoSyCZiUm6WGfJYiuKpnjUw9z+MVFyv7YMcrIFVXRotx62jX6hrobz8/AD8EvyHpFau
        ZV/3uucZBGPntyhuPT7LO2BCRDyyLJyy3L5W10kBXVPYEmLRkMa7I3L+rPdYfgD1zbwklz7L07jNZ
        88Th5nuQqugS79sxiZrSs+JmoCqBS+tBaJth8laJEqznhUtWQHNoaaS2clfezPwweQnNDuSe57Qms
        i0qUfk+Rg==;
Received: from [213.208.157.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbU4B-0002gw-9E
        for linux-xfs@vger.kernel.org; Thu, 13 Jun 2019 18:03:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/20] xfs: remove the iop_push implementation for quota off items
Date:   Thu, 13 Jun 2019 20:02:45 +0200
Message-Id: <20190613180300.30447-6-hch@lst.de>
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

