Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4037202222
	for <lists+linux-xfs@lfdr.de>; Sat, 20 Jun 2020 09:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgFTHLs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 20 Jun 2020 03:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgFTHLs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Jun 2020 03:11:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F90C06174E
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jun 2020 00:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=CTi15IiJrVV5i/VUSVly4frHJgk4H8rhPcfOPmXfUHo=; b=CbZEIIVGdqs4SAjZaTrUriIo6z
        b58pMAm1jf+CKKuRBHLmfppAQiCn8VRWcw5y1L52A3Eht84cFkdxHCKg1dhNN96p1OEHNJFVPnrSk
        ZeWpdHoBpF2aOoFP8REdVttoQ8hwL6+HVavu5ovcmJ1fFlZIGXc/S2mTRGdbf7cMCAXiqx4G4L6qR
        x7jMM4Sq8/LSVHt8JE/NcB94m4/VNU5oPJBQj0pq+gcWzkWZ2PqIMvW9R2EPkRsjBuVn7Qkx9UT9X
        b3fEDhXEXGLW/jLrp6nq2Z9vbr+31C0o55OMjyQxP3fXMihu08JBFXrUSche2yN2NC0PlUBI4mY3h
        VgXkbFCg==;
Received: from 195-192-102-148.dyn.cablelink.at ([195.192.102.148] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmXfH-00012S-G0
        for linux-xfs@vger.kernel.org; Sat, 20 Jun 2020 07:11:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/15] xfs: move the di_dmevmask field to struct xfs_inode
Date:   Sat, 20 Jun 2020 09:11:01 +0200
Message-Id: <20200620071102.462554-15-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200620071102.462554-1-hch@lst.de>
References: <20200620071102.462554-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation of removing the historic icinode struct, move the
dmevmask field into the containing xfs_inode structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 4 ++--
 fs/xfs/libxfs/xfs_inode_buf.h | 1 -
 fs/xfs/xfs_inode.c            | 4 ++--
 fs/xfs/xfs_inode.h            | 1 +
 fs/xfs/xfs_inode_item.c       | 2 +-
 fs/xfs/xfs_log_recover.c      | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index af595ee23635aa..d361803102d0e1 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -246,7 +246,7 @@ xfs_inode_from_disk(
 	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
 	ip->i_extsize = be32_to_cpu(from->di_extsize);
 	ip->i_forkoff = from->di_forkoff;
-	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
+	ip->i_dmevmask	= be32_to_cpu(from->di_dmevmask);
 	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
 	ip->i_diflags	= be16_to_cpu(from->di_flags);
 
@@ -312,7 +312,7 @@ xfs_inode_to_disk(
 	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
-	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
+	to->di_dmevmask = cpu_to_be32(ip->i_dmevmask);
 	to->di_dmstate = cpu_to_be16(from->di_dmstate);
 	to->di_flags = cpu_to_be16(ip->i_diflags);
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 2a8e7a7ed8d18d..0cfc1aaff6c6f3 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -16,7 +16,6 @@ struct xfs_dinode;
  * format specific structures at the appropriate time.
  */
 struct xfs_icdinode {
-	uint32_t	di_dmevmask;	/* DMIG event mask */
 	uint16_t	di_dmstate;	/* DMIG state info */
 };
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 59f11314750a46..db48c910c8d7b0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -833,7 +833,7 @@ xfs_ialloc(
 	inode->i_ctime = tv;
 
 	ip->i_extsize = 0;
-	ip->i_d.di_dmevmask = 0;
+	ip->i_dmevmask = 0;
 	ip->i_d.di_dmstate = 0;
 	ip->i_diflags = 0;
 
@@ -2755,7 +2755,7 @@ xfs_ifree(
 	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
 	ip->i_diflags = 0;
 	ip->i_diflags2 = 0;
-	ip->i_d.di_dmevmask = 0;
+	ip->i_dmevmask = 0;
 	ip->i_forkoff = 0;		/* mark the attr fork not in use */
 	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 106a8d6cc010cb..e64df2e7438aa0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -67,6 +67,7 @@ typedef struct xfs_inode {
 	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
 	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
 	struct timespec64	i_crtime;	/* time created */
+	uint32_t		i_dmevmask;	/* DMIG event mask */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index dff3bc6a33720a..9b7860025c497d 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -330,7 +330,7 @@ xfs_inode_to_log_dinode(
 	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
 	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
-	to->di_dmevmask = from->di_dmevmask;
+	to->di_dmevmask = ip->i_dmevmask;
 	to->di_dmstate = from->di_dmstate;
 	to->di_flags = ip->i_diflags;
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ec015df55b77a9..d096b8c4013814 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2720,7 +2720,7 @@ xlog_recover_process_one_iunlink(
 	 * Prevent any DMAPI event from being sent when the reference on
 	 * the inode is dropped.
 	 */
-	ip->i_d.di_dmevmask = 0;
+	ip->i_dmevmask = 0;
 
 	xfs_irele(ip);
 	return agino;
-- 
2.26.2

