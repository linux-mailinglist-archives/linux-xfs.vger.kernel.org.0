Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24914229468
	for <lists+linux-xfs@lfdr.de>; Wed, 22 Jul 2020 11:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgGVJFa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 22 Jul 2020 05:05:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35433 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726821AbgGVJFa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jul 2020 05:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595408728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=boYTwXX4fgO2jnZInIZJcm7WWrnSakQHSf5q5lYp3/c=;
        b=JjXUS/XjCjf51VHahq3bW9aYYfGrkk7kJl4kYr6kN8rBMqh+n9GcsKtpUkDgHMWaqkU9JY
        9CepUjo4GAsyTGeMCxt9l0KMsvImRQJYLoY0N1Vx23YbxhVOrI+LHRxOJiViuZwFItqe95
        5EU2JD5g+GSe/viAP4yGZ0Iewk9X3lk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-DbjTXIVkNCqlc7F_bZKDuw-1; Wed, 22 Jul 2020 05:05:26 -0400
X-MC-Unique: DbjTXIVkNCqlc7F_bZKDuw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82D36106B245
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2020 09:05:25 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAF81BA66
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2020 09:05:24 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfs: Remove kmem_zone_alloc() usage
Date:   Wed, 22 Jul 2020 11:05:14 +0200
Message-Id: <20200722090518.214624-2-cmaiolino@redhat.com>
In-Reply-To: <20200722090518.214624-1-cmaiolino@redhat.com>
References: <20200722090518.214624-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use kmem_cache_alloc() directly.

All kmem_zone_alloc() users pass 0 as flags, which are translated into:
GFP_KERNEL | __GFP_NOWARN, and kmem_zone_alloc() loops forever until the
allocation succeeds.

We can use __GFP_NOFAIL to tell the allocator to loop forever rather
than doing it ourself, and because the allocation will never fail, we do
not need to use __GFP_NOWARN anymore. Hence, all callers can be
converted to use GFP_KERNEL | __GFP_NOFAIL

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Changelog:
	V2:
		- Wire up xfs_inode_alloc to use __GFP_NOFAIL
		  if it's called inside a transaction
		- Rewrite changelog in a more decent way.
	V3:
		- Use __GFP_NOFAIL unconditionally in xfs_inode_alloc(),
		  use of PF_FSTRANS will be added when the patch re-adding
		  it is moved to mainline.

 fs/xfs/libxfs/xfs_alloc.c |  3 ++-
 fs/xfs/libxfs/xfs_bmap.c  |  3 ++-
 fs/xfs/xfs_icache.c       | 10 ++--------
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 203e74fa64aa6..583242253c027 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2467,7 +2467,8 @@ xfs_defer_agfl_block(
 	ASSERT(xfs_bmap_free_item_zone != NULL);
 	ASSERT(oinfo != NULL);
 
-	new = kmem_zone_alloc(xfs_bmap_free_item_zone, 0);
+	new = kmem_cache_alloc(xfs_bmap_free_item_zone,
+			       GFP_KERNEL | __GFP_NOFAIL);
 	new->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
 	new->xefi_blockcount = 1;
 	new->xefi_oinfo = *oinfo;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 667cdd0dfdf4a..fd5c0d669d0d7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -553,7 +553,8 @@ __xfs_bmap_add_free(
 #endif
 	ASSERT(xfs_bmap_free_item_zone != NULL);
 
-	new = kmem_zone_alloc(xfs_bmap_free_item_zone, 0);
+	new = kmem_cache_alloc(xfs_bmap_free_item_zone,
+			       GFP_KERNEL | __GFP_NOFAIL);
 	new->xefi_startblock = bno;
 	new->xefi_blockcount = (xfs_extlen_t)len;
 	if (oinfo)
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 58a750ce689c0..c2d97e4f131fb 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -36,14 +36,8 @@ xfs_inode_alloc(
 {
 	struct xfs_inode	*ip;
 
-	/*
-	 * if this didn't occur in transactions, we could use
-	 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
-	 * code up to do this anyway.
-	 */
-	ip = kmem_zone_alloc(xfs_inode_zone, 0);
-	if (!ip)
-		return NULL;
+	ip = kmem_cache_alloc(xfs_inode_zone, GFP_KERNEL | __GFP_NOFAIL);
+
 	if (inode_init_always(mp->m_super, VFS_I(ip))) {
 		kmem_cache_free(xfs_inode_zone, ip);
 		return NULL;
-- 
2.26.2

