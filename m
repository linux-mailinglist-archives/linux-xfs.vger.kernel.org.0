Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461793C5B5C
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Jul 2021 13:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbhGLLVC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Jul 2021 07:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237061AbhGLLSU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jul 2021 07:18:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6168CC0613DD
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jul 2021 04:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=nTRDsMfcId1RrOUjQ5C8n95+Eqwi6hcxLgaYdex6z+k=; b=m6rhjb2gErcCP1J01eB139c/W+
        jQi5sm0oJmSHHYxvW9lweVq0O1N3IxEjGVIwtwtUM/BrJRhMNvSR4btipTu6XeBpI63mzmF2Qfrur
        +jJIwRcQ4CiKfUbJqwvxnqM2tOW3jN5Fu+my85gXymZ2LAMxQV/pYzxrbTab7IVTS7ldCDg5nN6V5
        VxvPI3GGX6CPe6/Cc3tm0KIaSVeAh3TT7R85jpNX8ZDSZJ6SCfs6W8xX+n08qiOcDYRantdnvQtrZ
        z0aP24mDfPkBzqnTfSeGkfrmCYbK15bNFTjdVAvA7XeYFpsSQRgn1vOiZX9gBowOWpyVftj8MIo23
        pk7XuSqQ==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2ttx-00HXPG-3y
        for linux-xfs@vger.kernel.org; Mon, 12 Jul 2021 11:15:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: remove the flags argument to xfs_qm_dquot_walk
Date:   Mon, 12 Jul 2021 13:14:25 +0200
Message-Id: <20210712111426.83004-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712111426.83004-1-hch@lst.de>
References: <20210712111426.83004-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We always purge all dquots now, so drop the argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 580b9dba21122b..2b34273d0405e7 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -187,15 +187,11 @@ xfs_qm_dqpurge(
  */
 static void
 xfs_qm_dqpurge_all(
-	struct xfs_mount	*mp,
-	uint			flags)
+	struct xfs_mount	*mp)
 {
-	if (flags & XFS_QMOPT_UQUOTA)
-		xfs_qm_dquot_walk(mp, XFS_DQTYPE_USER, xfs_qm_dqpurge, NULL);
-	if (flags & XFS_QMOPT_GQUOTA)
-		xfs_qm_dquot_walk(mp, XFS_DQTYPE_GROUP, xfs_qm_dqpurge, NULL);
-	if (flags & XFS_QMOPT_PQUOTA)
-		xfs_qm_dquot_walk(mp, XFS_DQTYPE_PROJ, xfs_qm_dqpurge, NULL);
+	xfs_qm_dquot_walk(mp, XFS_DQTYPE_USER, xfs_qm_dqpurge, NULL);
+	xfs_qm_dquot_walk(mp, XFS_DQTYPE_GROUP, xfs_qm_dqpurge, NULL);
+	xfs_qm_dquot_walk(mp, XFS_DQTYPE_PROJ, xfs_qm_dqpurge, NULL);
 }
 
 /*
@@ -206,7 +202,7 @@ xfs_qm_unmount(
 	struct xfs_mount	*mp)
 {
 	if (mp->m_quotainfo) {
-		xfs_qm_dqpurge_all(mp, XFS_QMOPT_QUOTALL);
+		xfs_qm_dqpurge_all(mp);
 		xfs_qm_destroy_quotainfo(mp);
 	}
 }
@@ -1359,7 +1355,7 @@ xfs_qm_quotacheck(
 	 * at this point (because we intentionally didn't in dqget_noattach).
 	 */
 	if (error) {
-		xfs_qm_dqpurge_all(mp, XFS_QMOPT_QUOTALL);
+		xfs_qm_dqpurge_all(mp);
 		goto error_return;
 	}
 
-- 
2.30.2

