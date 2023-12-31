Return-Path: <linux-xfs+bounces-1301-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DA8AD820D8D
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 21:23:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79F801F21F57
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 20:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A97BFBA31;
	Sun, 31 Dec 2023 20:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qx5pJQRm"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76607BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47629C433C7;
	Sun, 31 Dec 2023 20:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054208;
	bh=Ydwq2rIQdkQ4PvHH1UdXmpdgeLJIVprrDdRYIg7h6Dk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Qx5pJQRm+56XtQ6Hw4lzwPv/Ur4ZKQQLR6DsqF1Wn0z6qiFzR9dC2i6egmGYvr7Hq
	 z2tZmcFqx4nd1xBysXaBcCyDc3Ls+bt1YHicGmz01Pepti7ev9n0wlBkB2qgQNxL5h
	 PGuevoi4mscJDm8m49MrsM9q0/VV9lXHR029KaA8B4JVAfhfFPZfWGD6+8qcrJS4xn
	 IYrxusRgXgeUxVOzgoe7G6d6WxwGoy9Iuk/PcZn6xVN2oCelf9g99T1hhpR9bUXoVZ
	 eMc0wN58OzFj9Ut5ecDeeV5qpTcjcsje5drE8IH0OhN7GZmW/gDp9Q+LV43xuOg68T
	 wvOjSwo1oFx3w==
Date: Sun, 31 Dec 2023 12:23:27 -0800
Subject: [PATCH 2/2] xfs: xfs_bmap_finish_one should map unwritten extents
 properly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404832298.1750058.10974375231877444092.stgit@frogsfrogsfrogs>
In-Reply-To: <170404832261.1750058.14588057130952880290.stgit@frogsfrogsfrogs>
References: <170404832261.1750058.14588057130952880290.stgit@frogsfrogsfrogs>
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

The deferred bmap work state and the log item can transmit unwritten
state, so the XFS_BMAP_MAP handler must map in extents with that
unwritten state.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e7da6a72eb928..03a67a4acd668 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6223,6 +6223,8 @@ xfs_bmap_finish_one(
 
 	switch (bi->bi_type) {
 	case XFS_BMAP_MAP:
+		if (bi->bi_bmap.br_state == XFS_EXT_UNWRITTEN)
+			flags |= XFS_BMAPI_PREALLOC;
 		error = xfs_bmapi_remap(tp, bi->bi_owner, bmap->br_startoff,
 				bmap->br_blockcount, bmap->br_startblock,
 				flags);


