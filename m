Return-Path: <linux-xfs+bounces-1646-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C19F820F1E
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 22:53:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9AC7BB21806
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 21:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8956FC8D4;
	Sun, 31 Dec 2023 21:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EgHKWe0K"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C93C8CA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA347C433C7;
	Sun, 31 Dec 2023 21:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059590;
	bh=ZzA4MZcasB7a5n5aR64NjjVnANol6BBBxaoohBNZjSA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EgHKWe0KGxH3T/sDfO+/41dM2DFjAr4qBT0LB5hqLTL262oOU252D3wwv9DpYApy/
	 J/LEtEqZiS/rlIEjSI6ctAzn8MT0QHMeLICqIzkW1env1U493f3VGRzUdMriYkIeHE
	 F6K/B6dtb8aqHp9ciMz10ZRP6cG3txkOck79YMLtvHLNBAQUqjivk8aZp/vsXWQx9v
	 FGR7ZmUmhNkfWnRpOA5CkiQ1thlJkZX5w7eDvhx+MrqT0UzFTJVAvCd7eHCpaw3aF9
	 PwztLc98D4nMzH9nAZuZ3vhFrx6e+B4u4xQHFg+3u+MSDG2ru3VyPW3h4Aqzs5Rljc
	 n3Hbpl1tT1Krg==
Date: Sun, 31 Dec 2023 13:53:10 -0800
Subject: [PATCH 33/44] xfs: allow dquot rt block count to exceed rt blocks on
 reflink fs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852112.1766284.5409003953055384924.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

Update the quota scrubber to allow dquots where the realtime block count
exceeds the block count of the rt volume if reflink is enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/quota.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 183d531875eae..58d6d4ed2853b 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -212,12 +212,18 @@ xchk_quota_item(
 		if (mp->m_sb.sb_dblocks < dq->q_blk.count)
 			xchk_fblock_set_warning(sc, XFS_DATA_FORK,
 					offset);
+		if (mp->m_sb.sb_rblocks < dq->q_rtb.count)
+			xchk_fblock_set_warning(sc, XFS_DATA_FORK,
+					offset);
 	} else {
 		if (mp->m_sb.sb_dblocks < dq->q_blk.count)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
 					offset);
+		if (mp->m_sb.sb_rblocks < dq->q_rtb.count)
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
+					offset);
 	}
-	if (dq->q_ino.count > fs_icount || dq->q_rtb.count > mp->m_sb.sb_rblocks)
+	if (dq->q_ino.count > fs_icount)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	/*


