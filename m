Return-Path: <linux-xfs+bounces-19359-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D38EA2C56B
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Feb 2025 15:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 458D97A536F
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Feb 2025 14:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E562451CE;
	Fri,  7 Feb 2025 14:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UvaCivSS"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F132B2405F9
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 14:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738938646; cv=none; b=hkSm+ADqTyyOwBVAMAHLKtd4gaJkJKoKhoS2f8915d/3A/xxBC8ody7RGlvU3y+8uiIprjM1lP5DiKYRqDVsSRrdGAzPIhgcn/H2f0X2/AJZCWrDjnKIU7CQTgUvC9BUtdQ3QII75BYJe2e3WVLvDuEqnOxbEeskHidaqqRRe74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738938646; c=relaxed/simple;
	bh=WIOZ0Vy7P1VJy4Ypi8BXGTrUY+jj6jld6u7eo6MHCo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NmfoBP7K3dUSD1smr+eSzDppUZbZRMWckPP2u/ijd5jPSAfkp0BJNSylQYg2Q6J4WJAO56HnHuPe617Z/k/N3xDDWBWJrtGbPquduIq8CdVcM2a+2t3q2TY7LXoFzdi3mvcDMIKM98FWHIc/kyqJg49DCvYTBLyFBsFejTXIOok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UvaCivSS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738938643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I+0yla8UbFnjzc/ISY8Thxx3Ga1uALTCbgxpCboRunQ=;
	b=UvaCivSSbpKLWg2EICMEN6CF950v3aHk/r7YEX7rkCxAwaiycTh+jSZwUHFhr7t4AGFfwY
	V7Zfat7GiSFQxA1WRsKYsrlprBngCypsxg7n9IEmUz9Y/rhwG2B0FxeP6wEiLe0/o3g0co
	c1bDobBPjy8EQZ981rSdo4IUMGa9G9g=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-91-FcA63paJPlyuxp0su7abXQ-1; Fri,
 07 Feb 2025 09:30:41 -0500
X-MC-Unique: FcA63paJPlyuxp0su7abXQ-1
X-Mimecast-MFC-AGG-ID: FcA63paJPlyuxp0su7abXQ
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B28E5195608B;
	Fri,  7 Feb 2025 14:30:39 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.48])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C96001800352;
	Fri,  7 Feb 2025 14:30:38 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v6 10/10] iomap: advance the iter directly on zero range
Date: Fri,  7 Feb 2025 09:32:53 -0500
Message-ID: <20250207143253.314068-11-bfoster@redhat.com>
In-Reply-To: <20250207143253.314068-1-bfoster@redhat.com>
References: <20250207143253.314068-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Modify zero range to advance the iter directly. Replace the local pos
and length calculations with direct advances and loop based on iter
state instead.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index f953bf66beb1..ec227b45f3aa 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1345,17 +1345,16 @@ static inline int iomap_zero_iter_flush_and_stale(struct iomap_iter *i)
 
 static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 {
-	loff_t pos = iter->pos;
-	loff_t length = iomap_length(iter);
-	loff_t written = 0;
+	u64 bytes = iomap_length(iter);
+	int status;
 
 	do {
 		struct folio *folio;
-		int status;
 		size_t offset;
-		size_t bytes = min_t(u64, SIZE_MAX, length);
+		loff_t pos = iter->pos;
 		bool ret;
 
+		bytes = min_t(u64, SIZE_MAX, bytes);
 		status = iomap_write_begin(iter, pos, bytes, &folio);
 		if (status)
 			return status;
@@ -1376,14 +1375,14 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 		if (WARN_ON_ONCE(!ret))
 			return -EIO;
 
-		pos += bytes;
-		length -= bytes;
-		written += bytes;
-	} while (length > 0);
+		status = iomap_iter_advance(iter, &bytes);
+		if (status)
+			break;
+	} while (bytes > 0);
 
 	if (did_zero)
 		*did_zero = true;
-	return written;
+	return status;
 }
 
 int
@@ -1436,11 +1435,14 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 
 		if (srcmap->type == IOMAP_HOLE ||
 		    srcmap->type == IOMAP_UNWRITTEN) {
-			loff_t proc = iomap_length(&iter);
+			s64 proc;
 
 			if (range_dirty) {
 				range_dirty = false;
 				proc = iomap_zero_iter_flush_and_stale(&iter);
+			} else {
+				u64 length = iomap_length(&iter);
+				proc = iomap_iter_advance(&iter, &length);
 			}
 			iter.processed = proc;
 			continue;
-- 
2.48.1


