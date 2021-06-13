Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5DC3A59CA
	for <lists+linux-xfs@lfdr.de>; Sun, 13 Jun 2021 19:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhFMRWx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 13 Jun 2021 13:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232017AbhFMRWx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 13 Jun 2021 13:22:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30DFA61078;
        Sun, 13 Jun 2021 17:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623604852;
        bh=QUb17QJbj6TLcvBF1SN55fvqhUW2SVn5xsuQq7o6bf4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GmZctl92bODtBA1V2P7H3D2SzyuMtT82jf3fR43/dn4Fkr+ydPZOE7Ei9kA2clHfz
         f0LMKFAJ8HnwdFQgk2JJcGk6JeFVZsw3jiXlOfIXWCTIQ53LHpPevUDfKiuW+taE63
         hdPs1cLfLT9C3BYNiQgOrvguCRs0muysPP7ykF+QNVqpBs/bGSfDz3NIyO6/9pOzQq
         2Lv5ZznpyZm8kXz8lwErqBeWi9EhBFoDbXvasi9d04DpnbxDnkz7jx5A0R/Qp68usV
         45ae62PsI/JHPf/tLo9vZD9dz5HePBDtAo3RdTtdhEsAAD8C2L17NYxtBx3gjxu+nM
         51OnlA5mNYThA==
Subject: [PATCH 10/16] xfs: inactivate inodes any time we try to free
 speculative preallocations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
        bfoster@redhat.com
Date:   Sun, 13 Jun 2021 10:20:51 -0700
Message-ID: <162360485190.1530792.729777050167640805.stgit@locust>
In-Reply-To: <162360479631.1530792.17147217854887531696.stgit@locust>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Other parts of XFS have learned to call xfs_blockgc_free_{space,quota}
to try to free speculative preallocations when space is tight.  This
means that file writes, transaction reservation failures, quota limit
enforcement, and the EOFBLOCKS ioctl all call this function to free
space when things are tight.

Since inode inactivation is now a background task, this means that the
filesystem can be hanging on to unlinked but not yet freed space.  Add
this to the list of things that xfs_blockgc_free_* makes writer threads
scan for when they cannot reserve space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 97c2901017e4..210a9e3cd19e 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1828,16 +1828,23 @@ xfs_blockgc_worker(
 }
 
 /*
- * Try to free space in the filesystem by purging eofblocks and cowblocks.
+ * Try to free space in the filesystem by purging inactive inodes, eofblocks
+ * and cowblocks.
  */
 int
 xfs_blockgc_free_space(
 	struct xfs_mount	*mp,
 	struct xfs_icwalk	*icw)
 {
+	int			error;
+
 	trace_xfs_blockgc_free_space(mp, icw, _RET_IP_);
 
-	return xfs_icwalk(mp, XFS_ICWALK_BLOCKGC, icw);
+	error = xfs_icwalk(mp, XFS_ICWALK_BLOCKGC, icw);
+	if (error)
+		return error;
+
+	return xfs_icwalk(mp, XFS_ICWALK_INODEGC, icw);
 }
 
 /*

