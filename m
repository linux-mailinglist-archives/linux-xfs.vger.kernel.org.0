Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4DC3C65F0
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Jul 2021 00:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhGLWKP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Jul 2021 18:10:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230030AbhGLWKO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jul 2021 18:10:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1300611C0;
        Mon, 12 Jul 2021 22:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626127645;
        bh=gDejCTAd3fEbQiygMiGoCHoM57d8US9set3sAgH/PzE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qHgVsEkpVVwGFzPWZLlAwruCjOGuIuob6+tBWGTx9d4JdajAfiSR/WncNI2BpaC57
         TnKY2wQ7CHa6ESmt9pGN1FatvhLoYHPPJpL5in2vTexPEOUh8aJ3YhE+SAhbjds0LM
         FBD/UF4OynOvNQOh4ePHAqGP+MCQC8ajvWC2X55HV8vPivtvgL6hTP7fI5s87bnDYr
         wo/3+PhiKPDH1GYheuZKTSjIbaX8s3a1vOE4EAi6qgMZ3+i7SXZnSmVxi2lfe2DUwa
         yHG6RS2nF0cgE0A11pzmjHrvc/HoZLLj+o9w4KZPFcVfOzsCl4CKGA5Inigge7iH/b
         hYJuq9E6pzzZA==
Subject: [PATCH 1/2] xfs: improve FSGROWFSRT precondition checking
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 12 Jul 2021 15:07:25 -0700
Message-ID: <162612764549.39052.13778481530353608889.stgit@magnolia>
In-Reply-To: <162612763990.39052.10884597587360249026.stgit@magnolia>
References: <162612763990.39052.10884597587360249026.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Improve the checking at the start of a realtime grow operation so that
we avoid accidentally set a new extent size that is too large and avoid
adding an rt volume to a filesystem with rmap or reflink because we
don't support rt rmap or reflink yet.

While we're at it, separate the checks so that we're only testing one
aspect at a time.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4e7be6b4ca8e..8920bce4fb0a 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -928,11 +928,23 @@ xfs_growfs_rt(
 	 */
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (mp->m_rtdev_targp == NULL || mp->m_rbmip == NULL ||
-	    (nrblocks = in->newblocks) <= sbp->sb_rblocks ||
-	    (sbp->sb_rblocks && (in->extsize != sbp->sb_rextsize)))
+	if (mp->m_rtdev_targp == NULL || !mp->m_rbmip || !mp->m_rsumip)
 		return -EINVAL;
-	if ((error = xfs_sb_validate_fsb_count(sbp, nrblocks)))
+	if (in->newblocks <= sbp->sb_rblocks)
+		return -EINVAL;
+	if (xfs_sb_version_hasrealtime(&mp->m_sb) &&
+	    in->extsize != sbp->sb_rextsize)
+		return -EINVAL;
+	if (XFS_FSB_TO_B(mp, in->extsize) > XFS_MAX_RTEXTSIZE ||
+	    XFS_FSB_TO_B(mp, in->extsize) < XFS_MIN_RTEXTSIZE)
+		return -EINVAL;
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) ||
+	    xfs_sb_version_hasreflink(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	nrblocks = in->newblocks;
+	error = xfs_sb_validate_fsb_count(sbp, nrblocks);
+	if (error)
 		return error;
 	/*
 	 * Read in the last block of the device, make sure it exists.

