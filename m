Return-Path: <linux-xfs+bounces-27154-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C4D94C20C44
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Oct 2025 15:56:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BC0814EE4DD
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Oct 2025 14:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52F0627FB28;
	Thu, 30 Oct 2025 14:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O5Nk5zJG"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AE427CCE2
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 14:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761835816; cv=none; b=B7ZU7NThiHtEp1I+wUYurTuqQJgm+Gbmk8sojCDUbuETBZ7woMytyJol298NLgr/asZ+eVu/uDEi7t8sk/0MbiHDJlI1CgrqtW64unF73hODpgjiKJ1ESKazFqRQnzNVSzGbQH3DzYfcMP+H1KKRBrxmZOdgRDp6ddIY2PS/cWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761835816; c=relaxed/simple;
	bh=AhQk5jFA2Gb9rZI+JqM1MZBCt9VAlvLs//Q/n3OgJhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPuU7DeJCTxWXz2kv1rc+ZsaqisFMA0UfLNYPeu5P3DgzSJ0k2TVdSkAfxYk/Cl4HGmIDyP/xhKNzTpJll+pUaumQSipIWPt8+dWubh9bNOSdzXtjtL40mL3grPgPD9/iH7KKqTJhftwJUtMc6fHVjtefe9CVI4cf4XEg8rnujE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O5Nk5zJG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4svdUJThV+R2W+r7xLAy7vLyGYA0IpQ76MDj4mqBSfo=; b=O5Nk5zJGy95BefwL5+pPKgsHqv
	PL/sud9my3ZAkj8jFUQlzL51fVl/5KWpHG0g6/CoGhYi20F4QstIe0VwWIWy6TR4+Xhae9MQbMUsX
	wP2wzAbcYhMNLMbemIJ87qnYqWCzaTGq9qQl67Ev3ch8vJdavk1Hv5PVnzK1W5WcWhdMjGYuUopZX
	KB1+Y/BFRA+G9GDIp3QOyr0TLRhNPwFJvrS/a5NGgy54i/88yqDiZsP2mtofCAAbKhP6MbLwPv+/k
	LqM8l4NQPGkzU9oa9B520XreUTSNoqoZ6MWTXz/uyArQ2M9B4gUddH09KW/DwZbSMBXTYSy7e8cRd
	lHb3Eahw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vETyf-00000004KPG-1gPq;
	Thu, 30 Oct 2025 14:50:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 09/10] xfs: improve the iclog space assert in xlog_write_iovec
Date: Thu, 30 Oct 2025 15:49:19 +0100
Message-ID: <20251030144946.1372887-10-hch@lst.de>
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

We need enough space for the length we copy into the iclog, not just
some space, so tighten up the check a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7c751665bc44..8b8fdef6414d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1889,7 +1889,7 @@ xlog_write_iovec(
 	void			*buf,
 	uint32_t		buf_len)
 {
-	ASSERT(xlog_write_space_left(data) > 0);
+	ASSERT(xlog_write_space_left(data) >= buf_len);
 	ASSERT(data->log_offset % sizeof(int32_t) == 0);
 	ASSERT(buf_len % sizeof(int32_t) == 0);
 
-- 
2.47.3


