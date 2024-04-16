Return-Path: <linux-xfs+bounces-6741-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 023798A5ED5
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Apr 2024 01:51:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACBCA1F21B8B
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Apr 2024 23:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1888D1591F9;
	Mon, 15 Apr 2024 23:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4PJ8nEp"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAE1157A61
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225089; cv=none; b=K7VyiGWnQfl2YXPf7moswj7x0nLAeg4KXaFEfXGN+GxgLJoqWI5pFR2m17AAwGM7AoAYNdcc2NiZPtlqFFCxL6WL6GSOxiaN/0iDQSWJ4bjB16kjtLmLCbJfZMnVA/VZ+K6Rztdc/Q6oSuRRhDgijMi3cpvbVDlX/5REE2IOyq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225089; c=relaxed/simple;
	bh=9HT3VoxTBhAQkwAC1iWtZlWNpISXZo/Zl31eFwVIzaA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iQfIQ8BBh4T8juymkwFjFhXeLm9D5gHP8vfPciMzxAw4xcSFU7S5yzLdqVXy/U82GespliDcpHGg/EEr+LmWM8/T5ps9xGZDzyr8YjutSWcBPmmRnyDwTxm6ZRjIPelS2D+1RfXhZadRdbVW5l+OHiMgUsWhjgjDvoz0JoGw7NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P4PJ8nEp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2935C113CC;
	Mon, 15 Apr 2024 23:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225089;
	bh=9HT3VoxTBhAQkwAC1iWtZlWNpISXZo/Zl31eFwVIzaA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P4PJ8nEpbl+YgfPiGUc97/QmMrgr8zGTt0PKnHQoYoYjpl8t3Kn+9brs+wHqE3LpU
	 pAG8TxgJUOMuWVblJpWFJIhEFzbwEG7YFDREnVN8v8q+qaJ9RGWv9P3yTknINRrtLI
	 PhqBXFFFpDHvpAtKkpA5r/wcleqiYYsRP5PYTyy+H0+CikHqP8xdFpo1FYSIwoGKQ/
	 31sdR1zZ2ASqfyRQazIEBsckPgNphl42k2+zVEVNfKJJpmaOJSZ95Ipznt9L5C+4Ru
	 n7ReZfDiANXlKOZNNHxbqiZ+GcG7j8lCnBu7RaQ8wH2WTbns/PrX7uO7FVlFklMlf8
	 zghxdNyN4ExVg==
Date: Mon, 15 Apr 2024 16:51:29 -0700
Subject: [PATCH 2/2] xfs: update the unlinked list when repairing link counts
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322383544.89063.4435412789569968283.stgit@frogsfrogsfrogs>
In-Reply-To: <171322383505.89063.1663567277512574374.stgit@frogsfrogsfrogs>
References: <171322383505.89063.1663567277512574374.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're repairing the link counts of a file, we must ensure either
that the file has zero link count and is on the unlinked list; or that
it has nonzero link count and is not on the unlinked list.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/nlinks_repair.c |   42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index b87618322f55..58cacb8e94c1 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -17,6 +17,7 @@
 #include "xfs_iwalk.h"
 #include "xfs_ialloc.h"
 #include "xfs_sb.h"
+#include "xfs_ag.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
@@ -36,6 +37,20 @@
  * inode is locked.
  */
 
+/* Remove an inode from the unlinked list. */
+STATIC int
+xrep_nlinks_iunlink_remove(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_perag	*pag;
+	int			error;
+
+	pag = xfs_perag_get(sc->mp, XFS_INO_TO_AGNO(sc->mp, sc->ip->i_ino));
+	error = xfs_iunlink_remove(sc->tp, pag, sc->ip);
+	xfs_perag_put(pag);
+	return error;
+}
+
 /*
  * Correct the link count of the given inode.  Because we have to grab locks
  * and resources in a certain order, it's possible that this will be a no-op.
@@ -99,16 +114,25 @@ xrep_nlinks_repair_inode(
 	}
 
 	/*
-	 * We did not find any links to this inode.  If the inode agrees, we
-	 * have nothing further to do.  If not, the inode has a nonzero link
-	 * count and we don't have anywhere to graft the child onto.  Dropping
-	 * a live inode's link count to zero can cause unexpected shutdowns in
-	 * inactivation, so leave it alone.
+	 * If this inode is linked from the directory tree and on the unlinked
+	 * list, remove it from the unlinked list.
 	 */
-	if (total_links == 0) {
-		if (actual_nlink != 0)
-			trace_xrep_nlinks_unfixable_inode(mp, ip, &obs);
-		goto out_trans;
+	if (total_links > 0 && xfs_inode_on_unlinked_list(ip)) {
+		error = xrep_nlinks_iunlink_remove(sc);
+		if (error)
+			goto out_trans;
+		dirty = true;
+	}
+
+	/*
+	 * If this inode is not linked from the directory tree yet not on the
+	 * unlinked list, put it on the unlinked list.
+	 */
+	if (total_links == 0 && !xfs_inode_on_unlinked_list(ip)) {
+		error = xfs_iunlink(sc->tp, ip);
+		if (error)
+			goto out_trans;
+		dirty = true;
 	}
 
 	/* Commit the new link count if it changed. */


