Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797751BAE07
	for <lists+linux-xfs@lfdr.de>; Mon, 27 Apr 2020 21:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgD0Tdf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 27 Apr 2020 15:33:35 -0400
Received: from verein.lst.de ([213.95.11.211]:50806 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgD0Tdf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Apr 2020 15:33:35 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E546268CFE; Mon, 27 Apr 2020 21:33:32 +0200 (CEST)
Date:   Mon, 27 Apr 2020 21:33:32 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/2] xfs: factor out a xlog_buf_readahead helper
Message-ID: <20200427193332.GA24934@lst.de>
References: <20200427135229.1480993-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427135229.1480993-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a little helper to readahead a buffer if it hasn't been cancelled.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 33cac61570abe..4cb8f24f3aa63 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2034,6 +2034,17 @@ xlog_put_buffer_cancelled(
 	return true;
 }
 
+static void
+xlog_buf_readahead(
+	struct xlog		*log,
+	xfs_daddr_t		blkno,
+	uint			len,
+	const struct xfs_buf_ops *ops)
+{
+	if (!xlog_is_buffer_cancelled(log, blkno, len))
+		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
+}
+
 /*
  * Perform recovery for a buffer full of inodes.  In these buffers, the only
  * data which should be recovered is that which corresponds to the
@@ -3870,12 +3881,8 @@ xlog_recover_buffer_ra_pass2(
 	struct xlog_recover_item        *item)
 {
 	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
-	struct xfs_mount		*mp = log->l_mp;
 
-	if (xlog_is_buffer_cancelled(log, buf_f->blf_blkno, buf_f->blf_len))
-		return;
-	xfs_buf_readahead(mp->m_ddev_targp, buf_f->blf_blkno,
-				buf_f->blf_len, NULL);
+	xlog_buf_readahead(log, buf_f->blf_blkno, buf_f->blf_len, NULL);
 }
 
 STATIC void
@@ -3885,7 +3892,6 @@ xlog_recover_inode_ra_pass2(
 {
 	struct xfs_inode_log_format	ilf_buf;
 	struct xfs_inode_log_format	*ilfp;
-	struct xfs_mount		*mp = log->l_mp;
 	int			error;
 
 	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
@@ -3898,10 +3904,8 @@ xlog_recover_inode_ra_pass2(
 			return;
 	}
 
-	if (xlog_is_buffer_cancelled(log, ilfp->ilf_blkno, ilfp->ilf_len))
-		return;
-	xfs_buf_readahead(mp->m_ddev_targp, ilfp->ilf_blkno,
-				ilfp->ilf_len, &xfs_inode_buf_ra_ops);
+	xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
+			   &xfs_inode_buf_ra_ops);
 }
 
 STATIC void
@@ -3913,8 +3917,6 @@ xlog_recover_dquot_ra_pass2(
 	struct xfs_disk_dquot	*recddq;
 	struct xfs_dq_logformat	*dq_f;
 	uint			type;
-	int			len;
-
 
 	if (mp->m_qflags == 0)
 		return;
@@ -3934,11 +3936,9 @@ xlog_recover_dquot_ra_pass2(
 	ASSERT(dq_f);
 	ASSERT(dq_f->qlf_len == 1);
 
-	len = XFS_FSB_TO_BB(mp, dq_f->qlf_len);
-	if (xlog_is_buffer_cancelled(log, dq_f->qlf_blkno, len))
-		return;
-	xfs_buf_readahead(mp->m_ddev_targp, dq_f->qlf_blkno, len,
-			  &xfs_dquot_buf_ra_ops);
+	xlog_buf_readahead(log, dq_f->qlf_blkno,
+			XFS_FSB_TO_BB(mp, dq_f->qlf_len),
+			&xfs_dquot_buf_ra_ops);
 }
 
 STATIC void
-- 
2.26.1

