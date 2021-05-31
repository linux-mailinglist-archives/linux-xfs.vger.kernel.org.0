Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437013969B4
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Jun 2021 00:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhEaWma (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 31 May 2021 18:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232364AbhEaWm3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 May 2021 18:42:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 733F2611CA;
        Mon, 31 May 2021 22:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622500849;
        bh=9LuAZyJsJexw0gd98ftncLLMn+dDy6ug4CX3RxknEbs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DE0bvME/TUjf9bNQjxofmyQhUpqr0xS4gSeSWPtxHwR4xYXE1rIRhZSt5U54TtcNl
         M9XwgGhGLaLS0i/g4R328lf79CInIq5wgRQCfUT0vGE0hgXUcX9Faj2hh3h1UPxnKt
         F6rk82v212V88Nzmuf0u38l77ZKPSjmS9LOjvxAx1vaftkkoiYsmNNiIDht8v5bQ+h
         ovbCVq+A7+6uoS81NtaMUGsTi36zlramdyaN2LrIoawDRL9/XRqvme1sJd9oBUg44t
         hZXcaeHyyScPo2IJr8ffQvq46aGDDSbcEFswjfuzYT9l78/PxSGF4yY87zlxmAVjta
         jphqSpHC0nlpg==
Subject: [PATCH 3/3] xfs: remove unnecessary shifts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Mon, 31 May 2021 15:40:49 -0700
Message-ID: <162250084916.490289.453146390591474194.stgit@locust>
In-Reply-To: <162250083252.490289.17618066691063888710.stgit@locust>
References: <162250083252.490289.17618066691063888710.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The superblock verifier already validates that (1 << blocklog) ==
blocksize, so use the value directly instead of doing math.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0936f3a96fe6..997eb5c6e9b4 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -945,7 +945,7 @@ xfs_flush_unmap_range(
 	xfs_off_t		rounding, start, end;
 	int			error;
 
-	rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_SIZE);
+	rounding = max_t(xfs_off_t, mp->m_sb.sb_blocksize, PAGE_SIZE);
 	start = round_down(offset, rounding);
 	end = round_up(offset + len, rounding) - 1;
 
@@ -1053,9 +1053,9 @@ xfs_prepare_shift(
 	 * extent (after split) during the shift and corrupt the file. Start
 	 * with the block just prior to the start to stabilize the boundary.
 	 */
-	offset = round_down(offset, 1 << mp->m_sb.sb_blocklog);
+	offset = round_down(offset, mp->m_sb.sb_blocksize);
 	if (offset)
-		offset -= (1 << mp->m_sb.sb_blocklog);
+		offset -= mp->m_sb.sb_blocksize;
 
 	/*
 	 * Writeback and invalidate cache for the remainder of the file as we're

