Return-Path: <linux-xfs+bounces-7367-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2937B8AD25B
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Apr 2024 18:41:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B32B61F21CF7
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Apr 2024 16:41:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AE3A154422;
	Mon, 22 Apr 2024 16:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vKvXn0fc"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7FC154421
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804046; cv=none; b=c0VqNuHl5TRk7yTIn2Vzt7yBShpElSWQVJ9mG++jypWtJFnX7fwF7KjzTygi8A6Mbj4LygHRW5mlvE1UYGKqVC2wlt3/gQ1YHYeQGKvn6Wk9nZ+yIZxjk7QBTjRIwlo4sNxGrHx3Bv1isjDzeoL8lnCz6dA6JeC8hwAHoJC57n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804046; c=relaxed/simple;
	bh=AGNKdTVyTgNmz+670NjkqefCRRTgfQ5gywL7vW+xgT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOjsQhNwIsYy7wdK+982Cnpu0nLaaK/BUsnqydmtN4JgXYYcCLDGpQOVwAo3+f6YApSXIGqiSmyQTR5Rsl3FAWfUzo0U94w1Q2WGezphavbp2dKnPbe/pIbOWVglJq1mzrci2n7paAR7WS4kb8iVFozzxLTQ3RDDRfwqrK2nN5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vKvXn0fc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C428BC113CC;
	Mon, 22 Apr 2024 16:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804046;
	bh=AGNKdTVyTgNmz+670NjkqefCRRTgfQ5gywL7vW+xgT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKvXn0fcCi3Lh4fX0qzDMGL2zJqY6N7dpYFpGXfeSLLQi5fax/mdQMzkDHUt0qLKq
	 uxKZGiP+sV9LBX7rOwNThp3w1yDD6L3UD0V0+kjTn9I0AWLg3n8wunMgiKFpuagfgj
	 qnOAg7fUmC0h3dPN6AXCFefpb8LJX85GoLJCQWiCcAeVxp/6e+IfXTr4LtX+zZJ82S
	 ixT3c8lC6SbJr4BA9waYKhriix/kFumqqTnti/9WbCtWUQ11b1Q2naxKdmO/RgxZPa
	 7GQOr8C6gPImk9Ok7udZgLcl/BBU6r7UWWTIPQHaSzI3P54TDkCOt2VE7/0i4+lFo8
	 ErbDnRn+NZcpQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 65/67] xfs: fix backwards logic in xfs_bmap_alloc_account
Date: Mon, 22 Apr 2024 18:26:27 +0200
Message-ID: <20240422163832.858420-67-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: d61b40bf15ce453f3aa71f6b423938e239e7f8f8

We're only allocating from the realtime device if the inode is marked
for realtime and we're /not/ allocating into the attr fork.

Fixes: 58643460546d ("xfs: also use xfs_bmap_btalloc_accounting for RT allocations")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 5e6a5e1f3..494994d36 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3271,7 +3271,7 @@ xfs_bmap_alloc_account(
 	struct xfs_bmalloca	*ap)
 {
 	bool			isrt = XFS_IS_REALTIME_INODE(ap->ip) &&
-					(ap->flags & XFS_BMAPI_ATTRFORK);
+					!(ap->flags & XFS_BMAPI_ATTRFORK);
 	uint			fld;
 
 	if (ap->flags & XFS_BMAPI_COWFORK) {
-- 
2.44.0


