Return-Path: <linux-xfs+bounces-27153-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B33A2C20B5A
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Oct 2025 15:50:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6073134F916
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Oct 2025 14:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 188F427C866;
	Thu, 30 Oct 2025 14:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CRMME8W1"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CFB27A442
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 14:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761835813; cv=none; b=W1FiNDQGqfpWirykCm+3ZrrDs5si+QvFED0Y40crWtWTcer1hNft1WosweTYx+4tR/ZRpa2E2XbMWx1mvDM0sJKz9X81wdwpC2+uxa82V4Hv2xmaErVsaWp9JpIvxwzyVEn5/owHnEf4w/MLnQyq2/sAt0HfMDjqgbIlwvdVRlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761835813; c=relaxed/simple;
	bh=IBjLDbfc3HKrDJxxZkW0mN7XimPh7DEtVknnJ7heQ5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGNI9zAEFygEWHEZCXq0XIJuq0y6mNQ+l62ZPlhT4SuIctDWv4BAmJJy4/EBqYSqVxqY6q/X9cBB7E6M+vMYXCVIXpnpkw48CJsx48PqZidhU1UpUJRiaA6CByBe3NgpREQbrwQEAF8dAeWOaHmaq55BqOEPlxht+KQQRKD4oXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CRMME8W1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GDlpNZyRUGa3a23GblNYIhU4gal1xUyZ6gKVVy21e/k=; b=CRMME8W1Ze8EfoQS8xOJxaH9LS
	xBZAU8pWQ6nXaK80yPe9ExeapEJahcQAV1O+DrTGEu8U2fbH+FDjH0c0vHfzlszNfh549gH0qknqp
	+sxZayAe8hKFj6hibysN50AcXpclgDZHjAdwMGtnSdWMa7gahvCWdkROZNkY7L1Ow3vMTl6uriFgF
	s9klnOoexe8LQKL7xmwbeToly74ni+TK3yeJbQebaw6FHP87razhRafHmy9U1AYPamXVZzq5VV+wI
	1Gwkl6Le3luMAmwlTGcKN1DO44aKmLSQOAA/TDdYcppDSnF00gio5kT6A3BZNZcZfal33zX+LNsEI
	Lvtz2SvQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vETyc-00000004KOs-362z;
	Thu, 30 Oct 2025 14:50:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 08/10] xfs: add a xlog_write_space_left helper
Date: Thu, 30 Oct 2025 15:49:18 +0100
Message-ID: <20251030144946.1372887-9-hch@lst.de>
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

Various places check how much space is left in the current iclog,
add a helper for that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2b1744af8a67..7c751665bc44 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1878,13 +1878,18 @@ xlog_print_trans(
 	}
 }
 
+static inline uint32_t xlog_write_space_left(struct xlog_write_data *data)
+{
+	return data->iclog->ic_size - data->log_offset;
+}
+
 static inline void
 xlog_write_iovec(
 	struct xlog_write_data	*data,
 	void			*buf,
 	uint32_t		buf_len)
 {
-	ASSERT(data->log_offset < data->iclog->ic_log->l_iclog_size);
+	ASSERT(xlog_write_space_left(data) > 0);
 	ASSERT(data->log_offset % sizeof(int32_t) == 0);
 	ASSERT(buf_len % sizeof(int32_t) == 0);
 
@@ -1906,7 +1911,7 @@ xlog_write_full(
 {
 	int			index;
 
-	ASSERT(data->log_offset + data->bytes_left <= data->iclog->ic_size ||
+	ASSERT(data->bytes_left <= xlog_write_space_left(data) ||
 		data->iclog->ic_state == XLOG_STATE_WANT_SYNC);
 
 	/*
@@ -1978,7 +1983,7 @@ xlog_write_partial(
 		 * Hence if there isn't space for region data after the
 		 * opheader, then we need to start afresh with a new iclog.
 		 */
-		if (data->iclog->ic_size - data->log_offset <=
+		if (xlog_write_space_left(data) <=
 					sizeof(struct xlog_op_header)) {
 			error = xlog_write_get_more_iclog_space(data);
 			if (error)
@@ -1986,8 +1991,7 @@ xlog_write_partial(
 		}
 
 		ophdr = reg->i_addr;
-		rlen = min_t(uint32_t, reg->i_len,
-			data->iclog->ic_size - data->log_offset);
+		rlen = min_t(uint32_t, reg->i_len, xlog_write_space_left(data));
 
 		ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
 		ophdr->oh_len = cpu_to_be32(rlen - sizeof(struct xlog_op_header));
@@ -2052,13 +2056,13 @@ xlog_write_partial(
 			 */
 			reg_offset += rlen;
 			rlen = reg->i_len - reg_offset;
-			if (rlen <= data->iclog->ic_size - data->log_offset)
+			if (rlen <= xlog_write_space_left(data))
 				ophdr->oh_flags |= XLOG_END_TRANS;
 			else
 				ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
 
 			rlen = min_t(uint32_t, rlen,
-				data->iclog->ic_size - data->log_offset);
+					xlog_write_space_left(data));
 			ophdr->oh_len = cpu_to_be32(rlen);
 
 			xlog_write_iovec(data, reg->i_addr + reg_offset, rlen);
@@ -2135,7 +2139,7 @@ xlog_write(
 	if (error)
 		return error;
 
-	ASSERT(data.log_offset <= data.iclog->ic_size - 1);
+	ASSERT(xlog_write_space_left(&data) > 0);
 
 	/*
 	 * If we have a context pointer, pass it the first iclog we are
@@ -2151,7 +2155,7 @@ xlog_write(
 		 * the partial copy loop which can handle this case.
 		 */
 		if (lv->lv_niovecs &&
-		    lv->lv_bytes > data.iclog->ic_size - data.log_offset) {
+		    lv->lv_bytes > xlog_write_space_left(&data)) {
 			error = xlog_write_partial(lv, &data);
 			if (error) {
 				/*
-- 
2.47.3


