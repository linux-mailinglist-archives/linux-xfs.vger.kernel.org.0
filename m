Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C093D1EFF
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jul 2021 09:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhGVGqs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 22 Jul 2021 02:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhGVGqr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 02:46:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4341C061575
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jul 2021 00:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=S8jA29DBbfK+IYoEtmuEwAiJwsKGe5NbhZ08AZFnkMc=; b=hM0Yz+p7effhYA2+A8dvbZEFy1
        elDP6DN5piJohN9540EN/HH+VybE7ubQxdcxYp3hbmmgPiCdNNS3QgL0WGTQZ5nfOY/sAdJGn6+Cy
        o6PiBd+zUaL8mD0Lr3M8NR9FZY4z01JCDsPuN6orfyEAkZ5p3i/N22kFPHObQWSsb605zrANjyaJ0
        QxrgX4pfZOnv25mA0H5QW9X4DsX/cGizCWo+E7aqR9Ypdgcswn6EAStMHsd2MGlHP3dOWxVkSen5i
        +YS2PBdO7a5Pq9d07NvGAVQpqiygEE+TiVqDQU2c8rn/g9g/shxlwNPOLPsgGyjM/U4qz746fIY8Z
        NFn/YATw==;
Received: from [2001:4bb8:193:7660:643c:9899:473:314a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6T6f-009zpx-Jf; Thu, 22 Jul 2021 07:27:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Carlos Maiolino <cmaiolino@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 2/3] xfs: remove the flags argument to xfs_qm_dquot_walk
Date:   Thu, 22 Jul 2021 09:26:09 +0200
Message-Id: <20210722072610.975281-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210722072610.975281-1-hch@lst.de>
References: <20210722072610.975281-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We always purge all dquots now, so drop the argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

