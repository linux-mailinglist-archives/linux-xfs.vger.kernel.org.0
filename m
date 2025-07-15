Return-Path: <linux-xfs+bounces-24015-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DFBDB05A39
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Jul 2025 14:31:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B50F77A860E
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Jul 2025 12:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC0162E0403;
	Tue, 15 Jul 2025 12:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FOY8+/sA"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1491EDA09
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582697; cv=none; b=uQM/zFMe326e4KcZXQGULrRBP7n/7rFtCkA3L6X4gyAniTLt/+kGZd0AffeIobgYbs2xdfsff++cgOIifep7OVhUxAUoemQpU38dGsAkcw9DZJbEWbPWtn+HkFbgRxtWGayHk0gF9c2YSz12qQNuboz//IHmEL/dpB7A7jJ5Uh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582697; c=relaxed/simple;
	bh=sPijERSK3sn19g6/jl/KpiPlmu3KPZfHFXfy2LX3T0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vALyQv0CVZp9Gi/pdIx0rwLdqwVTw9Dmaf6TGdnEIcitsNasWwyTdoVFwlw/AULbHhtLsUVzudNi10Yyv4aEL1bFilYZPFrhZ7TfjtLpo2hydXo/Zp9rtKGiOOTCa1pEyuhE+tlRygm66uFivOrPbU+nteflDv6WPiX4MkWRPV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FOY8+/sA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1fvf4kOsEQ/3rNPuJBeg9PahCFVmj0Bj6BnNqB5Qk4w=; b=FOY8+/sAHJIAHYcBjFyyNEezKM
	A/6RyMUCxIyd/NySZHy2+rOVHjv89COj7rCba9RVokw76uoX5TiG8hK57V8bD3O8fvkWuVEmWaynI
	oQk8oxtEBveqxXt2AM3irYOnIRySfiT5c0V27wYAKCBcAsNXuGVVVUBTTjEkysGaK+PV70qQ4M4kl
	J+VRQdOjLFO7kX+Wi64oJ0XdKmZSpkNS5a1fsJcC4FGFg9ykEvECr1h2jzVJlPPH6frbXTGUwvTrX
	cclXlQeUCPBbC2Q/ccUEb+eWnrgkBpWpIYH4SC6m/6WjfDLxOhLmFYfXs9zmRCtGa4S18PkBIvUKd
	mwVsr4/w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubeop-000000054lE-1dpa;
	Tue, 15 Jul 2025 12:31:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 03/18] xfs: use better names for size members in xfs_log_vec
Date: Tue, 15 Jul 2025 14:30:08 +0200
Message-ID: <20250715123125.1945534-4-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250715123125.1945534-1-hch@lst.de>
References: <20250715123125.1945534-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The lv_size member counts the size of the entire allocation, rename it to
lv_alloc_size to make that clear.

The lv_buf_len member tracks how much of lv_buf has been used up
to format the log item, rename it to lv_buf_used to make that more clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_log.c     | 10 +++++-----
 fs/xfs/xfs_log.h     |  9 +++++----
 fs/xfs/xfs_log_cil.c | 30 +++++++++++++++---------------
 3 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 793468b4d30d..3179923a68d4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -109,14 +109,14 @@ xlog_prepare_iovec(
 		vec = &lv->lv_iovecp[0];
 	}
 
-	len = lv->lv_buf_len + sizeof(struct xlog_op_header);
+	len = lv->lv_buf_used + sizeof(struct xlog_op_header);
 	if (!IS_ALIGNED(len, sizeof(uint64_t))) {
-		lv->lv_buf_len = round_up(len, sizeof(uint64_t)) -
+		lv->lv_buf_used = round_up(len, sizeof(uint64_t)) -
 					sizeof(struct xlog_op_header);
 	}
 
 	vec->i_type = type;
-	vec->i_addr = lv->lv_buf + lv->lv_buf_len;
+	vec->i_addr = lv->lv_buf + lv->lv_buf_used;
 
 	oph = vec->i_addr;
 	oph->oh_clientid = XFS_TRANSACTION;
@@ -1931,9 +1931,9 @@ xlog_print_trans(
 		if (!lv)
 			continue;
 		xfs_warn(mp, "  niovecs	= %d", lv->lv_niovecs);
-		xfs_warn(mp, "  size	= %d", lv->lv_size);
+		xfs_warn(mp, "  alloc_size = %d", lv->lv_alloc_size);
 		xfs_warn(mp, "  bytes	= %d", lv->lv_bytes);
-		xfs_warn(mp, "  buf len	= %d", lv->lv_buf_len);
+		xfs_warn(mp, "  buf used= %d", lv->lv_buf_used);
 
 		/* dump each iovec for the log item */
 		vec = lv->lv_iovecp;
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 13455854365f..f239fce4f260 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -16,8 +16,8 @@ struct xfs_log_vec {
 	struct xfs_log_item	*lv_item;	/* owner */
 	char			*lv_buf;	/* formatted buffer */
 	int			lv_bytes;	/* accounted space in buffer */
-	int			lv_buf_len;	/* aligned size of buffer */
-	int			lv_size;	/* size of allocated lv */
+	int			lv_buf_used;	/* buffer space used so far */
+	int			lv_alloc_size;	/* size of allocated lv */
 };
 
 #define XFS_LOG_VEC_ORDERED	(-1)
@@ -64,12 +64,13 @@ xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec,
 	oph->oh_len = cpu_to_be32(len);
 
 	len += sizeof(struct xlog_op_header);
-	lv->lv_buf_len += len;
+	lv->lv_buf_used += len;
 	lv->lv_bytes += len;
 	vec->i_len = len;
 
 	/* Catch buffer overruns */
-	ASSERT((void *)lv->lv_buf + lv->lv_bytes <= (void *)lv + lv->lv_size);
+	ASSERT((void *)lv->lv_buf + lv->lv_bytes <=
+		(void *)lv + lv->lv_alloc_size);
 }
 
 /*
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 9200301e539b..f443757e93c2 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -275,7 +275,7 @@ xlog_cil_alloc_shadow_bufs(
 		struct xfs_log_vec *lv;
 		int	niovecs = 0;
 		int	nbytes = 0;
-		int	buf_size;
+		int	alloc_size;
 		bool	ordered = false;
 
 		/* Skip items which aren't dirty in this transaction. */
@@ -316,14 +316,14 @@ xlog_cil_alloc_shadow_bufs(
 		 * that space to ensure we can align it appropriately and not
 		 * overrun the buffer.
 		 */
-		buf_size = nbytes + xlog_cil_iovec_space(niovecs);
+		alloc_size = nbytes + xlog_cil_iovec_space(niovecs);
 
 		/*
 		 * if we have no shadow buffer, or it is too small, we need to
 		 * reallocate it.
 		 */
 		if (!lip->li_lv_shadow ||
-		    buf_size > lip->li_lv_shadow->lv_size) {
+		    alloc_size > lip->li_lv_shadow->lv_alloc_size) {
 			/*
 			 * We free and allocate here as a realloc would copy
 			 * unnecessary data. We don't use kvzalloc() for the
@@ -332,15 +332,15 @@ xlog_cil_alloc_shadow_bufs(
 			 * storage.
 			 */
 			kvfree(lip->li_lv_shadow);
-			lv = xlog_kvmalloc(buf_size);
+			lv = xlog_kvmalloc(alloc_size);
 
 			memset(lv, 0, xlog_cil_iovec_space(niovecs));
 
 			INIT_LIST_HEAD(&lv->lv_list);
 			lv->lv_item = lip;
-			lv->lv_size = buf_size;
+			lv->lv_alloc_size = alloc_size;
 			if (ordered)
-				lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
+				lv->lv_buf_used = XFS_LOG_VEC_ORDERED;
 			else
 				lv->lv_iovecp = (struct xfs_log_iovec *)&lv[1];
 			lip->li_lv_shadow = lv;
@@ -348,9 +348,9 @@ xlog_cil_alloc_shadow_bufs(
 			/* same or smaller, optimise common overwrite case */
 			lv = lip->li_lv_shadow;
 			if (ordered)
-				lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
+				lv->lv_buf_used = XFS_LOG_VEC_ORDERED;
 			else
-				lv->lv_buf_len = 0;
+				lv->lv_buf_used = 0;
 			lv->lv_bytes = 0;
 		}
 
@@ -375,7 +375,7 @@ xfs_cil_prepare_item(
 	int			*diff_len)
 {
 	/* Account for the new LV being passed in */
-	if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
+	if (lv->lv_buf_used != XFS_LOG_VEC_ORDERED)
 		*diff_len += lv->lv_bytes;
 
 	/*
@@ -390,7 +390,7 @@ xfs_cil_prepare_item(
 			lv->lv_item->li_ops->iop_pin(lv->lv_item);
 		lv->lv_item->li_lv_shadow = NULL;
 	} else if (lip->li_lv != lv) {
-		ASSERT(lv->lv_buf_len != XFS_LOG_VEC_ORDERED);
+		ASSERT(lv->lv_buf_used != XFS_LOG_VEC_ORDERED);
 
 		*diff_len -= lip->li_lv->lv_bytes;
 		lv->lv_item->li_lv_shadow = lip->li_lv;
@@ -463,12 +463,12 @@ xlog_cil_insert_format_items(
 		 * The formatting size information is already attached to
 		 * the shadow lv on the log item.
 		 */
-		if (shadow->lv_buf_len == XFS_LOG_VEC_ORDERED) {
+		if (shadow->lv_buf_used == XFS_LOG_VEC_ORDERED) {
 			if (!lv) {
 				lv = shadow;
 				lv->lv_item = lip;
 			}
-			ASSERT(shadow->lv_size == lv->lv_size);
+			ASSERT(shadow->lv_alloc_size == lv->lv_alloc_size);
 			xfs_cil_prepare_item(log, lip, lv, diff_len);
 			continue;
 		}
@@ -478,7 +478,7 @@ xlog_cil_insert_format_items(
 			continue;
 
 		/* compare to existing item size */
-		if (lv && shadow->lv_size <= lv->lv_size) {
+		if (lv && shadow->lv_alloc_size <= lv->lv_alloc_size) {
 			/* same or smaller, optimise common overwrite case */
 
 			/*
@@ -491,7 +491,7 @@ xlog_cil_insert_format_items(
 			lv->lv_niovecs = shadow->lv_niovecs;
 
 			/* reset the lv buffer information for new formatting */
-			lv->lv_buf_len = 0;
+			lv->lv_buf_used = 0;
 			lv->lv_bytes = 0;
 			lv->lv_buf = (char *)lv +
 					xlog_cil_iovec_space(lv->lv_niovecs);
@@ -1238,7 +1238,7 @@ xlog_cil_build_lv_chain(
 		lv->lv_order_id = item->li_order_id;
 
 		/* we don't write ordered log vectors */
-		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
+		if (lv->lv_buf_used != XFS_LOG_VEC_ORDERED)
 			*num_bytes += lv->lv_bytes;
 		*num_iovecs += lv->lv_niovecs;
 		list_add_tail(&lv->lv_list, &ctx->lv_chain);
-- 
2.47.2


