Return-Path: <linux-xfs+bounces-27146-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F2335C20C3C
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Oct 2025 15:55:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 55A7E4EBD02
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Oct 2025 14:49:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9243F2777FE;
	Thu, 30 Oct 2025 14:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GQoIQR26"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BC226FDAC
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 14:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761835793; cv=none; b=VoWQgR+MQg7uR2Uda0Iiebd1acojpHaYLkTSgBZmM2Bjj9ddzSr3+pMe68PhH8oloxOKpsziOpjquZ4feh+EhEJkpQX5CL9b/IxFTUx2ML3XoTWi/Rl+Qi5APyEYcfKiqmCfSEc1EeAXCBfzXqoIWnrhVF6vZUbrNGUqxoXSOeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761835793; c=relaxed/simple;
	bh=GBHr8P7Q8w1BSXQI2z6dNXzEOSXWNGYO2joHPPHt5g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTgGTghcb91zPHJDmdBa2xPz8q47qVbThSEg5iwxjjmk62fsdLs1VMphILprtjelpAHKi00tBvS/0jUtINX3zuqM+PYYcI1+NrdyUBxBpauPWKyGkRNBwqKU5I44OnofWBqZyP/Pwx4FxnpBzsIT+7iM9ESmuXi+684B2t3BpQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GQoIQR26; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Y07RVKzqTw9rMm2uH5kkXFhfoB8f4rIeoTCgwQavDtY=; b=GQoIQR262ghU2zTnagSvCOD3ZZ
	7YFmeHv/l1tGeDih7B7E4r7pDk0SLbdrMCAB6yanw8TxYoyzLc+8rsyj9R+qWXi5l+89wtiTRLEhN
	aH6Fo2qHyInEo2emG3gpe9tiDxWqWfmx/Yu6tHW9QIVvN+36BZgpuUabhNa55F2InQsYQfqgTICGc
	BTpLGajYIOsvkp589BDe2HBk2UDEXhmgwiZ0OPxdIirfeuPCJNd+S/hFEMXPImG1KmTj7KKrdIRaO
	Al1jsiLx6Qs3/495Gw4h21AHVXqNttuenGimwx2j16j8zFnNhJqNRBn/9BE6w8D2BamHBQpyjOK/4
	K/GBO9LA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vETyJ-00000004KND-0PqH;
	Thu, 30 Oct 2025 14:49:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 01/10] xfs: add a xlog_write_one_vec helper
Date: Thu, 30 Oct 2025 15:49:11 +0100
Message-ID: <20251030144946.1372887-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251030144946.1372887-1-hch@lst.de>
References: <20251030144946.1372887-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a wrapper for xlog_write for the two callers who need to build a
log_vec and add it to a single-entry chain instead of duplicating the
code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 35 +++++++++++++++++++++--------------
 fs/xfs/xfs_log_cil.c  | 11 +----------
 fs/xfs/xfs_log_priv.h |  2 ++
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a311385b23d8..ed83a0e3578e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -848,6 +848,26 @@ xlog_wait_on_iclog(
 	return 0;
 }
 
+int
+xlog_write_one_vec(
+	struct xlog		*log,
+	struct xfs_cil_ctx	*ctx,
+	struct xfs_log_iovec	*reg,
+	struct xlog_ticket	*ticket)
+{
+	struct xfs_log_vec	lv = {
+		.lv_niovecs	= 1,
+		.lv_iovecp	= reg,
+	};
+	LIST_HEAD		(lv_chain);
+
+	/* account for space used by record data */
+	ticket->t_curr_res -= reg->i_len;
+
+	list_add(&lv.lv_list, &lv_chain);
+	return xlog_write(log, ctx, &lv_chain, ticket, reg->i_len);
+}
+
 /*
  * Write out an unmount record using the ticket provided. We have to account for
  * the data space used in the unmount ticket as this write is not done from a
@@ -876,21 +896,8 @@ xlog_write_unmount_record(
 		.i_len = sizeof(unmount_rec),
 		.i_type = XLOG_REG_TYPE_UNMOUNT,
 	};
-	struct xfs_log_vec vec = {
-		.lv_niovecs = 1,
-		.lv_iovecp = &reg,
-	};
-	LIST_HEAD(lv_chain);
-	list_add(&vec.lv_list, &lv_chain);
-
-	BUILD_BUG_ON((sizeof(struct xlog_op_header) +
-		      sizeof(struct xfs_unmount_log_format)) !=
-							sizeof(unmount_rec));
-
-	/* account for space used by record data */
-	ticket->t_curr_res -= sizeof(unmount_rec);
 
-	return xlog_write(log, NULL, &lv_chain, ticket, reg.i_len);
+	return xlog_write_one_vec(log, NULL, &reg, ticket);
 }
 
 /*
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 778ac47adb8c..83aa06e19cfb 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1098,13 +1098,7 @@ xlog_cil_write_commit_record(
 		.i_len = sizeof(struct xlog_op_header),
 		.i_type = XLOG_REG_TYPE_COMMIT,
 	};
-	struct xfs_log_vec	vec = {
-		.lv_niovecs = 1,
-		.lv_iovecp = &reg,
-	};
 	int			error;
-	LIST_HEAD(lv_chain);
-	list_add(&vec.lv_list, &lv_chain);
 
 	if (xlog_is_shutdown(log))
 		return -EIO;
@@ -1112,10 +1106,7 @@ xlog_cil_write_commit_record(
 	error = xlog_cil_order_write(ctx->cil, ctx->sequence, _COMMIT_RECORD);
 	if (error)
 		return error;
-
-	/* account for space used by record data */
-	ctx->ticket->t_curr_res -= reg.i_len;
-	error = xlog_write(log, ctx, &lv_chain, ctx->ticket, reg.i_len);
+	error = xlog_write_one_vec(log, ctx, &reg, ctx->ticket);
 	if (error)
 		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
 	return error;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 0fe59f0525aa..d2410e78b7f5 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -507,6 +507,8 @@ void	xlog_print_trans(struct xfs_trans *);
 int	xlog_write(struct xlog *log, struct xfs_cil_ctx *ctx,
 		struct list_head *lv_chain, struct xlog_ticket *tic,
 		uint32_t len);
+int	xlog_write_one_vec(struct xlog *log, struct xfs_cil_ctx *ctx,
+		struct xfs_log_iovec *reg, struct xlog_ticket *ticket);
 void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
 void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
 
-- 
2.47.3


