Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906323AA7CA
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Jun 2021 01:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhFPX54 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Jun 2021 19:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:55238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhFPX54 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 16 Jun 2021 19:57:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68ED460FD7;
        Wed, 16 Jun 2021 23:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623887749;
        bh=BKJdqn3hJ1UqKIB6W3bjTrjzSzLqXM6IiA2AUQvQ/wM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JIbYhqxjsjtHh87gpXE1jaGlTK5hlDJ1rPtKybjVDXDiTrQckg2j+tQqSwTg8SrId
         2Cx2g51QbtrOA8/ZxNI/hy5JnC305UQBYU/O07hQu2YwMCFtBsp4fFWaW/LpeIzsdO
         f4Pn+inO+EodehdroEIsobe1+xZIsapLE0UES0ECH1p8R83NAQbqscZ9d7POpyLPT5
         BgUQgfOiMv2xXmysN6KxzpPpX8YpxtfkPJD0Fl0qkPssE1HV3d0CqBUnJ2EdcMaNxD
         3Py4T5XBSz5gJXSByY5q9uTTFRvFr2DHl1voF7k6N2o7xlWlHIKtjafvP2NvGwn1sU
         3WivRSOVMG+ig==
Subject: [PATCH 2/2] xfs: force the log offline when log intent item recovery
 fails
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 16 Jun 2021 16:55:49 -0700
Message-ID: <162388774909.3427167.8813765394953438195.stgit@locust>
In-Reply-To: <162388773802.3427167.4556309820960423454.stgit@locust>
References: <162388773802.3427167.4556309820960423454.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If any part of log intent item recovery fails, we should shut down the
log immediately to stop the log from writing a clean unmount record to
disk, because the metadata is not consistent.  The inability to cancel a
dirty transaction catches most of these cases, but there are a few
things that have slipped through the cracks, such as ENOSPC from a
transaction allocation, or runtime errors that result in cancellation of
a non-dirty transaction.

This solves some weird behaviors reported by customers where a system
goes down, the first mount fails, the second succeeds, but then the fs
goes down later because of inconsistent metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c         |    3 +++
 fs/xfs/xfs_log_recover.c |    5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index e921b554b683..f945df46c7e1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -776,6 +776,9 @@ xfs_log_mount_finish(
 	if (readonly)
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 
+	/* Make sure the log is dead if we're returning failure. */
+	ASSERT(!error || (mp->m_log->l_flags & XLOG_IO_ERROR));
+
 	return error;
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1227503d2246..1721fce2ec94 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2458,8 +2458,10 @@ xlog_finish_defer_ops(
 
 		error = xfs_trans_alloc(mp, &resv, dfc->dfc_blkres,
 				dfc->dfc_rtxres, XFS_TRANS_RESERVE, &tp);
-		if (error)
+		if (error) {
+			xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
 			return error;
+		}
 
 		/*
 		 * Transfer to this new transaction all the dfops we captured
@@ -3449,6 +3451,7 @@ xlog_recover_finish(
 			 * this) before we get around to xfs_log_mount_cancel.
 			 */
 			xlog_recover_cancel_intents(log);
+			xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 			xfs_alert(log->l_mp, "Failed to recover intents");
 			return error;
 		}

