Return-Path: <linux-xfs+bounces-20081-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE5D8A42446
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Feb 2025 15:54:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58251189EDAA
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Feb 2025 14:46:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95DA2248862;
	Mon, 24 Feb 2025 14:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NEayMZOr"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FB92571CB
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 14:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408332; cv=none; b=mrvX044WtM/RcxbZRG3yTSAwQegD66/jEvwER1BKlbXDmSZdWsLXUrJ0qJMsWCWAoVnY9a0OiVjTnjPRCfIiyQ0NBY+kNwfz2T3VtghPG0EWymZFxvPsZFBzw4BQBq56xQkDmhLyP/MEKGACEoFcEPWTKJZo+Yq9w4UJnmArqPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408332; c=relaxed/simple;
	bh=PROhPnIzQMJFqmNFjK0sNFWDIjbfYPOtjDgLA7V9PE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RLCmHJZTD2o2TMqk0fl/EN4d+E0xHLbTGGwOWEjIpilWpq6XT/fFV87tErnCUDt11uYKIqnGHIw/kGMun4hD82JWmsCREg3XMWLn+kYVIRff6ppFGzrHGkX1kz9yUblBJJIHagCJekThJWY9oHyxsOPs9+klvdbMmqdvVioSijY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NEayMZOr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740408329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TzCgolIWiZEdJPRh3DJF9n+Dqf7Es/Iw3w2U07g14Ds=;
	b=NEayMZOrffbnIS4aK3kSmJumKrq60xZ83+n9yLBNQfWOJTQnqfn+0X55dnWpy9Ag+j1Sso
	+G12iDh9L5JUWx0T8WR0mumG29yGOMPc0urufY86/z29u4GARHXP7/U6D5l/95qYek3RR0
	7eOxm9nF92bWImmnaGyGWNWiIpSdDj0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-ue_4UbO7PU6o9k-IJDEezg-1; Mon,
 24 Feb 2025 09:45:24 -0500
X-MC-Unique: ue_4UbO7PU6o9k-IJDEezg-1
X-Mimecast-MFC-AGG-ID: ue_4UbO7PU6o9k-IJDEezg_1740408324
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA60819039C6;
	Mon, 24 Feb 2025 14:45:23 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.79])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ED25C19560AD;
	Mon, 24 Feb 2025 14:45:22 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v3 03/12] iomap: convert misc simple ops to incremental advance
Date: Mon, 24 Feb 2025 09:47:48 -0500
Message-ID: <20250224144757.237706-4-bfoster@redhat.com>
In-Reply-To: <20250224144757.237706-1-bfoster@redhat.com>
References: <20250224144757.237706-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Update several of the remaining iomap operations to advance the iter
directly rather than via return value. This includes page faults,
fiemap, seek data/hole and swapfile activation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/buffered-io.c |  2 +-
 fs/iomap/fiemap.c      | 18 +++++++++---------
 fs/iomap/seek.c        | 12 ++++++------
 fs/iomap/swapfile.c    |  7 +++++--
 4 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 582a64f565e6..1518acbf8b09 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1478,7 +1478,7 @@ static loff_t iomap_folio_mkwrite_iter(struct iomap_iter *iter,
 		folio_mark_dirty(folio);
 	}
 
-	return length;
+	return iomap_iter_advance(iter, &length);
 }
 
 vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops,
diff --git a/fs/iomap/fiemap.c b/fs/iomap/fiemap.c
index 610ca6f1ec9b..8a0d8b034218 100644
--- a/fs/iomap/fiemap.c
+++ b/fs/iomap/fiemap.c
@@ -39,24 +39,24 @@ static int iomap_to_fiemap(struct fiemap_extent_info *fi,
 			iomap->length, flags);
 }
 
-static loff_t iomap_fiemap_iter(const struct iomap_iter *iter,
+static loff_t iomap_fiemap_iter(struct iomap_iter *iter,
 		struct fiemap_extent_info *fi, struct iomap *prev)
 {
+	u64 length = iomap_length(iter);
 	int ret;
 
 	if (iter->iomap.type == IOMAP_HOLE)
-		return iomap_length(iter);
+		goto advance;
 
 	ret = iomap_to_fiemap(fi, prev, 0);
 	*prev = iter->iomap;
-	switch (ret) {
-	case 0:		/* success */
-		return iomap_length(iter);
-	case 1:		/* extent array full */
-		return 0;
-	default:	/* error */
+	if (ret < 0)
 		return ret;
-	}
+	if (ret == 1)	/* extent array full */
+		return 0;
+
+advance:
+	return iomap_iter_advance(iter, &length);
 }
 
 int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
diff --git a/fs/iomap/seek.c b/fs/iomap/seek.c
index a845c012b50c..83c687d6ccc0 100644
--- a/fs/iomap/seek.c
+++ b/fs/iomap/seek.c
@@ -10,7 +10,7 @@
 #include <linux/pagemap.h>
 #include <linux/pagevec.h>
 
-static loff_t iomap_seek_hole_iter(const struct iomap_iter *iter,
+static loff_t iomap_seek_hole_iter(struct iomap_iter *iter,
 		loff_t *hole_pos)
 {
 	loff_t length = iomap_length(iter);
@@ -20,13 +20,13 @@ static loff_t iomap_seek_hole_iter(const struct iomap_iter *iter,
 		*hole_pos = mapping_seek_hole_data(iter->inode->i_mapping,
 				iter->pos, iter->pos + length, SEEK_HOLE);
 		if (*hole_pos == iter->pos + length)
-			return length;
+			return iomap_iter_advance(iter, &length);
 		return 0;
 	case IOMAP_HOLE:
 		*hole_pos = iter->pos;
 		return 0;
 	default:
-		return length;
+		return iomap_iter_advance(iter, &length);
 	}
 }
 
@@ -56,19 +56,19 @@ iomap_seek_hole(struct inode *inode, loff_t pos, const struct iomap_ops *ops)
 }
 EXPORT_SYMBOL_GPL(iomap_seek_hole);
 
-static loff_t iomap_seek_data_iter(const struct iomap_iter *iter,
+static loff_t iomap_seek_data_iter(struct iomap_iter *iter,
 		loff_t *hole_pos)
 {
 	loff_t length = iomap_length(iter);
 
 	switch (iter->iomap.type) {
 	case IOMAP_HOLE:
-		return length;
+		return iomap_iter_advance(iter, &length);
 	case IOMAP_UNWRITTEN:
 		*hole_pos = mapping_seek_hole_data(iter->inode->i_mapping,
 				iter->pos, iter->pos + length, SEEK_DATA);
 		if (*hole_pos < 0)
-			return length;
+			return iomap_iter_advance(iter, &length);
 		return 0;
 	default:
 		*hole_pos = iter->pos;
diff --git a/fs/iomap/swapfile.c b/fs/iomap/swapfile.c
index b90d0eda9e51..4395e46a4dc7 100644
--- a/fs/iomap/swapfile.c
+++ b/fs/iomap/swapfile.c
@@ -94,9 +94,11 @@ static int iomap_swapfile_fail(struct iomap_swapfile_info *isi, const char *str)
  * swap only cares about contiguous page-aligned physical extents and makes no
  * distinction between written and unwritten extents.
  */
-static loff_t iomap_swapfile_iter(const struct iomap_iter *iter,
+static loff_t iomap_swapfile_iter(struct iomap_iter *iter,
 		struct iomap *iomap, struct iomap_swapfile_info *isi)
 {
+	u64 length = iomap_length(iter);
+
 	switch (iomap->type) {
 	case IOMAP_MAPPED:
 	case IOMAP_UNWRITTEN:
@@ -132,7 +134,8 @@ static loff_t iomap_swapfile_iter(const struct iomap_iter *iter,
 			return error;
 		memcpy(&isi->iomap, iomap, sizeof(isi->iomap));
 	}
-	return iomap_length(iter);
+
+	return iomap_iter_advance(iter, &length);
 }
 
 /*
-- 
2.48.1


