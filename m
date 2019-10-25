Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51709E527B
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Oct 2019 19:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505949AbfJYRlG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 25 Oct 2019 13:41:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39504 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731004AbfJYRlG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 13:41:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Mhj2bV0zW3AusSVvLz5o8gfEE1bFdjs9SxdHL9Cynys=; b=gv65pVj+5lJyoFwBWNah44ZIHu
        a4NvFqqLOkiZj7sNfev4I7hjN8jgLDiRkImOhZEN7aLAHbbEJOftHWYxJSM/kUw9Hr8HwadTJK648
        bXkaEnoj+xJFwn2V6iQYZeUmoWUmoZWUkcHwPtLSSY/D1YnhxtfbJyv+WBrptOJ0JtOGxFe2jx9j2
        8AHNL2TED0gg7rMJF+EvyOdZPn6lo8DRn7mYsrgQBnFxkv0s3YGpW0ArkJLp0yr5j/Mpk5SQYD+1m
        qOnv8qZ/WUPhn6XBB/5XIHK094UXNiYmlWH6qolrBEHVHbtMdD9EO9MnGe1NP3Y6CZq8QEjcnVqxM
        en/qgpVQ==;
Received: from [88.128.80.25] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO3aC-0005Wj-1W; Fri, 25 Oct 2019 17:41:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Ian Kent <raven@themaw.net>
Subject: [PATCH 2/7] xfs: remove the unused m_readio_blocks field from struct xfs_mount
Date:   Fri, 25 Oct 2019 19:40:21 +0200
Message-Id: <20191025174026.31878-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025174026.31878-1-hch@lst.de>
References: <20191025174026.31878-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mount.c | 1 -
 fs/xfs/xfs_mount.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ba5b6f3b2b88..18af97512aec 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -455,7 +455,6 @@ xfs_set_rw_sizes(xfs_mount_t *mp)
 	} else {
 		mp->m_readio_log = readio_log;
 	}
-	mp->m_readio_blocks = 1 << (mp->m_readio_log - sbp->sb_blocklog);
 	if (sbp->sb_blocklog > writeio_log) {
 		mp->m_writeio_log = sbp->sb_blocklog;
 	} else {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f69e370db341..ecde5b3828c8 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -99,7 +99,6 @@ typedef struct xfs_mount {
 	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
 	uint			m_readio_log;	/* min read size log bytes */
-	uint			m_readio_blocks; /* min read size blocks */
 	uint			m_writeio_log;	/* min write size log bytes */
 	uint			m_writeio_blocks; /* min write size blocks */
 	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
-- 
2.20.1

