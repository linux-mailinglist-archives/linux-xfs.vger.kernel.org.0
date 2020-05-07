Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D601C8A5D
	for <lists+linux-xfs@lfdr.de>; Thu,  7 May 2020 14:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgEGMTR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 May 2020 08:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGMTR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:19:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379FAC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=gberVM9J7Pp0lQEHiXEVE5jMvprigfTG0D9qFr+8sho=; b=lH/NaNFEDqiNS5awpyf5w758Za
        QPFJyZPfHTsV/OwyI+xrPp39SpmuT+RTha7PsxqVrOJEl0BOYacRNJjM+7Mn6PrPaItCphij1VYe/
        m2pqGRq6cvHERC5YgdcYaljixDEq42Jj6Osg5+yQFHvABSrRFovmhBwOrRRCIxgd2lcwVgfIwaDwH
        PrrHeObirmu/yUQJji86AlCQ6mZIGvGD6EivSYCWwoOWORdTd+7vF0yqNs7mDnEN8g8Jzvy/mu+hV
        UUaIqfBmv4Dr6EX6JJH8nrF+kPxQirdmuM/wr7LlvHfiKr1tNAJNpymMGa6iTQFqQNzI2/WsVQdzK
        iUqqfTLg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfUi-00056g-Mu; Thu, 07 May 2020 12:19:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/58] xfs: remove the name == NULL check from xfs_attr_args_init
Date:   Thu,  7 May 2020 14:18:02 +0200
Message-Id: <20200507121851.304002-10-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: 79f2280b9bfd54aa37b3fa4a80b0037bd29b4f0e

All callers provide a valid name pointer, remove the redundant check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/attrset.c      | 8 ++++++++
 libxfs/xfs_attr.c | 4 ----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index 4360e5f7..d4b812e6 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -127,6 +127,10 @@ attr_set_f(
 	}
 
 	name = argv[optind];
+	if (!name) {
+		dbprintf(_("invalid name\n"));
+		return 0;
+	}
 
 	if (valuelen) {
 		value = (char *)memalign(getpagesize(), valuelen);
@@ -214,6 +218,10 @@ attr_remove_f(
 	}
 
 	name = argv[optind];
+	if (!name) {
+		dbprintf(_("invalid name\n"));
+		return 0;
+	}
 
 	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip,
 			&xfs_default_ifork_ops)) {
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 248f9e83..ee2225a3 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -65,10 +65,6 @@ xfs_attr_args_init(
 	size_t			namelen,
 	int			flags)
 {
-
-	if (!name)
-		return -EINVAL;
-
 	memset(args, 0, sizeof(*args));
 	args->geo = dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
-- 
2.26.2

