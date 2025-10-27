Return-Path: <linux-xfs+bounces-27018-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 81F37C0C09D
	for <lists+linux-xfs@lfdr.de>; Mon, 27 Oct 2025 08:06:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 047944EA445
	for <lists+linux-xfs@lfdr.de>; Mon, 27 Oct 2025 07:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5981A26C3A7;
	Mon, 27 Oct 2025 07:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cyRNY23W"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF132F5B
	for <linux-xfs@vger.kernel.org>; Mon, 27 Oct 2025 07:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761548781; cv=none; b=VqD7X2Ib1Lsn0uLs/zj92jwP9vKJQhKBYaqRs4CWZVY4pJsdeB4qdMCOboIc2idaYlEzWvhxHXAT5AiKhUhPaBp2f6V3Bj4J59AewqOiG5CaMuWRlBqZvNMb9y/JbowkVnzDIssjALxL/M+8+bHU1nX/rYZiuLZ4eBAdBWYvlLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761548781; c=relaxed/simple;
	bh=NGU610b/vzHJ1GIWV3UCaxQnrpZgbsX+9emN+rvFwkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfVj/PcsYXJHdH+OLhL9weShaLtHyhyePQTsi/Vfm8nzh+5/yYTm9XXincRhCV2IFxSwsCsIvYmWCYf++tG4hDoL3JvUV20ihpgXcrIYhH1CBO41WkqmmhfBw4csHa2YmSlnUmWqSWGkkBgL5pLO2KRvu3dUlAAyrAiI1hg9Fns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cyRNY23W; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gIy6zfhk2p37A60MJ/kJXDiDWm8F5n0/HiR/Xv54/uU=; b=cyRNY23WMlwURhzMVukcT1iorh
	KwzhWuWgOfJtIODkL0+rce5iAd1i3FHa3JwYVTSsc96rh7AiJZF1NEKGTJ9LQn/3a2BYMD/YA5434
	PJRaKupwU+BG3l+6r6RDpEHBIaJsqfDeCXHem18vGvT5r1BXbVn5P8zUjLfe0TngjeWEPWBylMJBm
	mU8bPcXHuGAC+MWA74s2QkvinItNCW38GiCmOr7B6/cIc0vq2jWSF0id94BHfcmrbMjsSk/cmIkXn
	Wv8qGLhy5Lo2cL70732Z74LKXYCclmG9NCHBvwHACVlviZP3RAv0t+x03BgmGjLuFx8yjtq++7sBw
	5MrpILWw==;
Received: from [62.218.44.66] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDHJ4-0000000DFfv-3Rv5;
	Mon, 27 Oct 2025 07:06:19 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 2/9] xfs: add a on-disk log header cycle array accessor
Date: Mon, 27 Oct 2025 08:05:49 +0100
Message-ID: <20251027070610.729960-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251027070610.729960-1-hch@lst.de>
References: <20251027070610.729960-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Accessing the cycle arrays in the original log record header vs the
extended header is messy and duplicated in multiple places.

Add a xlog_cycle_data helper to abstract it out.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_log.c         | 63 ++++++++++------------------------------
 fs/xfs/xfs_log_priv.h    | 18 ++++++++++++
 fs/xfs/xfs_log_recover.c | 17 ++---------
 3 files changed, 37 insertions(+), 61 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index e09e5f71ed8c..a569a4320a3a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1524,18 +1524,13 @@ xlog_pack_data(
 	struct xlog_in_core	*iclog,
 	int			roundoff)
 {
-	int			i, j, k;
-	int			size = iclog->ic_offset + roundoff;
-	__be32			cycle_lsn;
-	char			*dp;
-
-	cycle_lsn = CYCLE_LSN_DISK(iclog->ic_header.h_lsn);
+	struct xlog_rec_header	*rhead = &iclog->ic_header;
+	__be32			cycle_lsn = CYCLE_LSN_DISK(rhead->h_lsn);
+	char			*dp = iclog->ic_datap;
+	int			i;
 
-	dp = iclog->ic_datap;
-	for (i = 0; i < BTOBB(size); i++) {
-		if (i >= XLOG_CYCLE_DATA_SIZE)
-			break;
-		iclog->ic_header.h_cycle_data[i] = *(__be32 *)dp;
+	for (i = 0; i < BTOBB(iclog->ic_offset + roundoff); i++) {
+		*xlog_cycle_data(rhead, i) = *(__be32 *)dp;
 		*(__be32 *)dp = cycle_lsn;
 		dp += BBSIZE;
 	}
@@ -1543,14 +1538,6 @@ xlog_pack_data(
 	if (xfs_has_logv2(log->l_mp)) {
 		xlog_in_core_2_t *xhdr = iclog->ic_data;
 
-		for ( ; i < BTOBB(size); i++) {
-			j = i / XLOG_CYCLE_DATA_SIZE;
-			k = i % XLOG_CYCLE_DATA_SIZE;
-			xhdr[j].hic_xheader.xh_cycle_data[k] = *(__be32 *)dp;
-			*(__be32 *)dp = cycle_lsn;
-			dp += BBSIZE;
-		}
-
 		for (i = 1; i < log->l_iclog_heads; i++)
 			xhdr[i].hic_xheader.xh_cycle = cycle_lsn;
 	}
@@ -3322,13 +3309,12 @@ xlog_verify_iclog(
 	struct xlog_in_core	*iclog,
 	int			count)
 {
-	struct xlog_op_header	*ophead;
+	struct xlog_rec_header	*rhead = &iclog->ic_header;
 	xlog_in_core_t		*icptr;
-	xlog_in_core_2_t	*xhdr;
-	void			*base_ptr, *ptr, *p;
+	void			*base_ptr, *ptr;
 	ptrdiff_t		field_offset;
 	uint8_t			clientid;
-	int			len, i, j, k, op_len;
+	int			len, i, op_len;
 	int			idx;
 
 	/* check validity of iclog pointers */
@@ -3342,11 +3328,10 @@ xlog_verify_iclog(
 	spin_unlock(&log->l_icloglock);
 
 	/* check log magic numbers */
-	if (iclog->ic_header.h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
+	if (rhead->h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
 		xfs_emerg(log->l_mp, "%s: invalid magic num", __func__);
 
-	base_ptr = ptr = &iclog->ic_header;
-	p = &iclog->ic_header;
+	base_ptr = ptr = rhead;
 	for (ptr += BBSIZE; ptr < base_ptr + count; ptr += BBSIZE) {
 		if (*(__be32 *)ptr == cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
 			xfs_emerg(log->l_mp, "%s: unexpected magic num",
@@ -3354,29 +3339,19 @@ xlog_verify_iclog(
 	}
 
 	/* check fields */
-	len = be32_to_cpu(iclog->ic_header.h_num_logops);
+	len = be32_to_cpu(rhead->h_num_logops);
 	base_ptr = ptr = iclog->ic_datap;
-	ophead = ptr;
-	xhdr = iclog->ic_data;
 	for (i = 0; i < len; i++) {
-		ophead = ptr;
+		struct xlog_op_header	*ophead = ptr;
+		void			*p = &ophead->oh_clientid;
 
 		/* clientid is only 1 byte */
-		p = &ophead->oh_clientid;
 		field_offset = p - base_ptr;
 		if (field_offset & 0x1ff) {
 			clientid = ophead->oh_clientid;
 		} else {
 			idx = BTOBBT((void *)&ophead->oh_clientid - iclog->ic_datap);
-			if (idx >= XLOG_CYCLE_DATA_SIZE) {
-				j = idx / XLOG_CYCLE_DATA_SIZE;
-				k = idx % XLOG_CYCLE_DATA_SIZE;
-				clientid = xlog_get_client_id(
-					xhdr[j].hic_xheader.xh_cycle_data[k]);
-			} else {
-				clientid = xlog_get_client_id(
-					iclog->ic_header.h_cycle_data[idx]);
-			}
+			clientid = xlog_get_client_id(*xlog_cycle_data(rhead, idx));
 		}
 		if (clientid != XFS_TRANSACTION && clientid != XFS_LOG) {
 			xfs_warn(log->l_mp,
@@ -3392,13 +3367,7 @@ xlog_verify_iclog(
 			op_len = be32_to_cpu(ophead->oh_len);
 		} else {
 			idx = BTOBBT((void *)&ophead->oh_len - iclog->ic_datap);
-			if (idx >= XLOG_CYCLE_DATA_SIZE) {
-				j = idx / XLOG_CYCLE_DATA_SIZE;
-				k = idx % XLOG_CYCLE_DATA_SIZE;
-				op_len = be32_to_cpu(xhdr[j].hic_xheader.xh_cycle_data[k]);
-			} else {
-				op_len = be32_to_cpu(iclog->ic_header.h_cycle_data[idx]);
-			}
+			op_len = be32_to_cpu(*xlog_cycle_data(rhead, idx));
 		}
 		ptr += sizeof(struct xlog_op_header) + op_len;
 	}
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 0cfc654d8e87..d2f17691ecca 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -711,4 +711,22 @@ xlog_item_space(
 	return round_up(nbytes, sizeof(uint64_t));
 }
 
+/*
+ * Cycles over XLOG_CYCLE_DATA_SIZE overflow into the extended header that was
+ * added for v2 logs.  Addressing for the cycles array there is off by one,
+ * because the first batch of cycles is in the original header.
+ */
+static inline __be32 *xlog_cycle_data(struct xlog_rec_header *rhead, unsigned i)
+{
+	if (i >= XLOG_CYCLE_DATA_SIZE) {
+		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
+		unsigned	j = i / XLOG_CYCLE_DATA_SIZE;
+		unsigned	k = i % XLOG_CYCLE_DATA_SIZE;
+
+		return &xhdr[j].hic_xheader.xh_cycle_data[k];
+	}
+
+	return &rhead->h_cycle_data[i];
+}
+
 #endif	/* __XFS_LOG_PRIV_H__ */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index bb2b3f976deb..ef0f6efc4381 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2863,23 +2863,12 @@ xlog_unpack_data(
 	char			*dp,
 	struct xlog		*log)
 {
-	int			i, j, k;
+	int			i;
 
-	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)) &&
-		  i < XLOG_CYCLE_DATA_SIZE; i++) {
-		*(__be32 *)dp = *(__be32 *)&rhead->h_cycle_data[i];
+	for (i = 0; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
+		*(__be32 *)dp = *xlog_cycle_data(rhead, i);
 		dp += BBSIZE;
 	}
-
-	if (xfs_has_logv2(log->l_mp)) {
-		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)rhead;
-		for ( ; i < BTOBB(be32_to_cpu(rhead->h_len)); i++) {
-			j = i / XLOG_CYCLE_DATA_SIZE;
-			k = i % XLOG_CYCLE_DATA_SIZE;
-			*(__be32 *)dp = xhdr[j].hic_xheader.xh_cycle_data[k];
-			dp += BBSIZE;
-		}
-	}
 }
 
 /*
-- 
2.47.3


