Return-Path: <linux-xfs+bounces-2259-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A5A10821224
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 01:32:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 551A5282A1A
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 00:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE10B1376;
	Mon,  1 Jan 2024 00:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t4rPyvv3"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A81B1370
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D980C433C8;
	Mon,  1 Jan 2024 00:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069129;
	bh=blSr9bMEOrQjxAMavSNgMOlxxiRX60w/QFGLF4p1ytM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=t4rPyvv38wxHy8vJx5xhoxFnINIAEb196lSitmOrLK4cQHSO1S+/SVUKBbnF2ei4D
	 UM0kvozxpEPFfBKfj+OpRk86s/f/sS9v7MrO4dPJib0Y7UXdKzBA6AVaC0ulqt7pDO
	 Sf4k5rHhmnKMaj1VgdtmcCSDmyJqNSuzobSQSP+s0qhiitoYHKbjTCsxWIU+oWh3h/
	 kDxcL/9PCpHJXkeiZoAb5KNChZcm00bpa/tJMoZ7/xqggU5Cjmq51bEULb7xBUzykk
	 AlNCBEHRmYqbDp94AOCYnhbix0GfIwv12q+R2kkAVAdDpgCfhPKpnmLXy7lrjeUwVI
	 8O8gMoAVdFeKA==
Date: Sun, 31 Dec 2023 16:32:08 +9900
Subject: [PATCH 23/42] libfrog: enable scrubbing of the realtime refcount data
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017432.1817107.15282915694645263552.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Add a new entry so that we can scrub the rtrefcountbt.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/scrub.c |    5 +++++
 scrub/repair.c  |    1 +
 2 files changed, 6 insertions(+)


diff --git a/libfrog/scrub.c b/libfrog/scrub.c
index 97b3d533910..62220f1eb0b 100644
--- a/libfrog/scrub.c
+++ b/libfrog/scrub.c
@@ -174,6 +174,11 @@ const struct xfrog_scrub_descr xfrog_scrubbers[XFS_SCRUB_TYPE_NR] = {
 		.descr	= "realtime reverse mapping btree",
 		.group	= XFROG_SCRUB_GROUP_RTGROUP,
 	},
+	[XFS_SCRUB_TYPE_RTREFCBT] = {
+		.name	= "rtrefcountbt",
+		.descr	= "realtime reference count btree",
+		.group	= XFROG_SCRUB_GROUP_RTGROUP,
+	},
 };
 
 const struct xfrog_scrub_descr xfrog_metapaths[XFS_SCRUB_METAPATH_NR] = {
diff --git a/scrub/repair.c b/scrub/repair.c
index 72533ab5b02..08d11079547 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -556,6 +556,7 @@ repair_item_difficulty(
 		case XFS_SCRUB_TYPE_RTBITMAP:
 		case XFS_SCRUB_TYPE_RTSUM:
 		case XFS_SCRUB_TYPE_RGSUPER:
+		case XFS_SCRUB_TYPE_RTREFCBT:
 			ret |= REPAIR_DIFFICULTY_PRIMARY;
 			break;
 		}


