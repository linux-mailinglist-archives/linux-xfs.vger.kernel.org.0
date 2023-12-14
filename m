Return-Path: <linux-xfs+bounces-750-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F68281283D
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Dec 2023 07:35:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1057CB2129C
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Dec 2023 06:35:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF36D50C;
	Thu, 14 Dec 2023 06:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j2P7BKVN"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790F0B9
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ACPIMfDEik9+Qer6RmxFCuvrOSOGqwVnO8ZS0cg8Ms0=; b=j2P7BKVNExp18ZzMOh0mdJ0svs
	k9QwN/trrEjbh5DxGnOH83BMEYGb5IaPXYkvM4jPNvgNl+Gzkf7bZIrk7NGQDE+XSQlSCE3kXoS9a
	fGLD3yxXl0DOwL0NVBjwTy0ZLvjFyOw2pIPu7x9BwVzZdGkY+VYri92mEn0gUdp4ICxtkH7yqkGIP
	ZX1/jDFpbnjQQ7yU+LES1meBoZ6avKx/8yDREx88OldgaHnvcz9wRF6V5yQKfL0ir8IuJ6V2RBgB3
	6TMCFueaSxwlXY16ynDORc0Hz4qM0s2kN8xPi0lRnvZnc4+QHGe/vXqPKpsooS5BDKqyYQ4G2dlZJ
	X7B3FqXg==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDfIy-00GzIy-19;
	Thu, 14 Dec 2023 06:34:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/19] xfs: consider minlen sized extents in xfs_rtallocate_extent_block
Date: Thu, 14 Dec 2023 07:34:20 +0100
Message-Id: <20231214063438.290538-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231214063438.290538-1-hch@lst.de>
References: <20231214063438.290538-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

minlen is the lower bound on the extent length that the caller can
accept, and maxlen is at this point the maximal available length.
This means a minlen extent is perfectly fine to use, so do it.  This
matches the equivalent logic in xfs_rtallocate_extent_exact that also
accepts a minlen sized extent.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 8feb58c6241ce4..fe98a96a26484f 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -309,7 +309,7 @@ xfs_rtallocate_extent_block(
 	/*
 	 * Searched the whole thing & didn't find a maxlen free extent.
 	 */
-	if (minlen < maxlen && besti != -1) {
+	if (minlen <= maxlen && besti != -1) {
 		xfs_rtxlen_t	p;	/* amount to trim length by */
 
 		/*
-- 
2.39.2


