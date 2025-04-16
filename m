Return-Path: <linux-xfs+bounces-21444-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8258A87747
	for <lists+linux-xfs@lfdr.de>; Mon, 14 Apr 2025 07:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE2E116EDA6
	for <lists+linux-xfs@lfdr.de>; Mon, 14 Apr 2025 05:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 193BC19ABC2;
	Mon, 14 Apr 2025 05:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gYkcDGM0"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9351E19DFA7
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609011; cv=none; b=F8AGsSPOwZmFQAJ46lFjurj+KwojxIG4PLYEbyrE87VYq/W574oN3JMzyjmMgmzP37ozC3YGZXuplvt/ZThbtwE07s54iLs06H5Um/Ko7iEkBrMliqjXWNpu/3fDfKqX+z/+H1RRRipIG3Yx7Sa8V/hfGpo4dwu88P0EqGqJU+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609011; c=relaxed/simple;
	bh=dIFIP7Y88h2q46GzxcAKEkUZ3eX3rQUix0gyFAPZmIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qhf1AOBr/oK914BuSonIthT8cIy7ajNCaosFY0xgdP0sxGlJth1tLVh9w5EV2IDtpA3lUL9xOdZBXUas+uY1h/iXtyDcMi86ip67brxRAyd78xR/0EDfUB97oFGAW44N6N+KjYlSvRkjbvehaxThe44QxyeC7ybnNrXZk8OK2KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gYkcDGM0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=STuM/sqjJc9PfP6YopoqFgI/wbgFj3MI/U4YXlO1S/o=; b=gYkcDGM0jxU69XpsghRQFCzlV1
	EkBCq/E5C0TcBGpWBZUOUo2FT7H7WV1WjmvxGY6b2L/tfUFYPedb5SBZYalp58RTXHtnxMQcHXFK3
	yx3YtT7gqqL0PsNbXtWLRvMfuyU9Olub7XXsMJn45vwNZwYjH9CfZzHcteeJsAqV9gcSIH8vwDE6e
	SpcyXIru+EcFZKDsnCuR1q5nIg+XQcDEnAmuUcGg4ZiUj0NCHYQXw6GaJ11/3Te62U+jr5pTID7At
	JmVMtESANe/ivxPYC//DPkHm2SBWGpLa4FVwW58dOtdJGgtR3X6if61qT6VlNsVfrfTMatTDawEfh
	7v3KDJyQ==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CUz-00000000i9F-1Wc4;
	Mon, 14 Apr 2025 05:36:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 06/43] xfs: add a rtg_blocks helper
Date: Mon, 14 Apr 2025 07:35:49 +0200
Message-ID: <20250414053629.360672-7-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 012482b3308a49a84c2a7df08218dd4ad081e1da

Shortcut dereferencing the xg_block_count field in the generic group
structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtgroup.c | 2 +-
 libxfs/xfs_rtgroup.h | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 24fb160b8067..6f65ecc3015d 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -267,7 +267,7 @@ xfs_rtgroup_get_geometry(
 	/* Fill out form. */
 	memset(rgeo, 0, sizeof(*rgeo));
 	rgeo->rg_number = rtg_rgno(rtg);
-	rgeo->rg_length = rtg_group(rtg)->xg_block_count;
+	rgeo->rg_length = rtg_blocks(rtg);
 	xfs_rtgroup_geom_health(rtg, rgeo);
 	return 0;
 }
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 03f39d4e43fc..9c7e03f913cb 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -66,6 +66,11 @@ static inline xfs_rgnumber_t rtg_rgno(const struct xfs_rtgroup *rtg)
 	return rtg->rtg_group.xg_gno;
 }
 
+static inline xfs_rgblock_t rtg_blocks(const struct xfs_rtgroup *rtg)
+{
+	return rtg->rtg_group.xg_block_count;
+}
+
 static inline struct xfs_inode *rtg_bitmap(const struct xfs_rtgroup *rtg)
 {
 	return rtg->rtg_inodes[XFS_RTGI_BITMAP];
-- 
2.47.2


