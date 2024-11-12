Return-Path: <linux-xfs+bounces-15279-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A42FF9C4A1A
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Nov 2024 00:53:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C8BB1F225A6
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Nov 2024 23:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1B0D1CCEE9;
	Mon, 11 Nov 2024 23:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YTNRgjZ/"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21631CC88C
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 23:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731368943; cv=none; b=jC5O5uHAhM4T+06kpSVLkJCj8f9/+833xQ3UTHKmTX5euqdGWcYq+v02LC+IdtrfgdzxhDRe3PCoF/8LNs4fuFIRzINjQEpLUL86T8/7TVkW+znE+uq7pdPpYp5irekO/eDSLFJZ10cZalWQFw8k8/mFAdWOugL0FMn1LOEDPpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731368943; c=relaxed/simple;
	bh=MmJ6uQz4zS+zNMk4WrnYAN8q8MiBRG7hHBRj4kFfBpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f02KUNROPPOFjDLXD57tQ012ss2OYCrrb8/dJossMRfX4uF7r9BVuRH1QWSVaL+S6Qc0ECJqnk2jZpYKCTb/9d4Fw7moH55g1Z9Gspb0CdgDXZ0SXwWk0SfXG5Tu5Td9iyKvN2vTQfXiKC2G6EID2Sf+WIx4sppmh6lrwChm4Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YTNRgjZ/; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-71e592d7f6eso3759703b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 15:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731368941; x=1731973741; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C5BmZ07D5DYJBYmt5fURgbXo4UgCrxSfGObLVz7UJ+Y=;
        b=YTNRgjZ/MujhL1xey9f4SDncEWX7de/DW5gFOJgg4nNqo8XNnKioHjJtWjDEDKVrBT
         +OTMRvJBUxmHACUDseiSgz2Dt3mRgyFr2zaziavJ4bP+8RMrgxwXC/0CHD25DZMJfILu
         lOUn5A0jpHBfCc0aGLijfpiFvavcMiorqdi0Qjj28n73+8p9j7oOQoVc49EPBCAs20PM
         eLjl+84GPAk8pawLiXuOUe8k47oW0EM1dZK//nSqFMZeU59vdwpAV4EcFQS9eFIrGBPm
         KEfwaiuuhyd0wlLJv+/n0Ay+v0LDQghf8eL1pEmWs//NHHOlx5I8F5HyGeugU1lKSLHM
         xcuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731368941; x=1731973741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C5BmZ07D5DYJBYmt5fURgbXo4UgCrxSfGObLVz7UJ+Y=;
        b=dUaxTcQ8TtibIEAiPSDNLO4SF41MtRiafLttjslKdJVJCty23V7nVHwltltCa3QJrt
         wBInRe4l+I+/mNv9IB4MBzycrgA1bu81AoIOcc6k46B3DXe20mxalDLGfcLBashzcott
         HvKdhYkXZ52fIHmW+JwXI0ARq/TaZ2SsfedMzYK4WDXq/e998K5A06tFZMIEawvswpta
         kcQrDoctn/G7M+nMIocCHpXAZFzHoh/ccPPt7ptmRpgk3gZEQKos9hUP5zK/OlLniKov
         9uEKQrXWY8xsrWCl+Z0bEyJhAcBUyrkf6iGgSRzibZ4ItDEKBVnzVLh/birAD9i95Xnd
         JmEA==
X-Forwarded-Encrypted: i=1; AJvYcCUTZREK7iIiQkka0lIYcYGfzJcMbIs1z+rqoNgzzamh+zPgXMsTA7Q4vXR/T//MWN+gd4MnU7L0xNQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4luFnMbkmDDIw3eJgmCrSt0HSEnQwJs9V+cH2SY8Y8cXvoCDG
	NY+yWUPq12vTsWlCB8qdew0kGksF2cW/BlmZHqNrwWbwpl8jXjzMZ6vDUoj5apo=
X-Google-Smtp-Source: AGHT+IHVAuYVOMfDSGlPxbnuC87wShBLb7OXW58ajqvAinndw3wlptYvFjbRCeInYbnH7Qo2aVFY4A==
X-Received: by 2002:a05:6a21:9101:b0:1db:e3c7:9974 with SMTP id adf61e73a8af0-1dc228ef1damr21176002637.12.1731368941302;
        Mon, 11 Nov 2024 15:49:01 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724078a7ee9sm10046057b3a.64.2024.11.11.15.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 15:49:00 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: hannes@cmpxchg.org,
	clm@meta.com,
	linux-kernel@vger.kernel.org,
	willy@infradead.org,
	kirill@shutemov.name,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/16] mm/filemap: drop uncached pages when writeback completes
Date: Mon, 11 Nov 2024 16:37:36 -0700
Message-ID: <20241111234842.2024180-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241111234842.2024180-1-axboe@kernel.dk>
References: <20241111234842.2024180-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the folio is marked as uncached, drop pages when writeback completes.
Intended to be used with RWF_UNCACHED, to avoid needing sync writes for
uncached IO.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 mm/filemap.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 3d0614ea5f59..40debe742abe 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1600,6 +1600,27 @@ int folio_wait_private_2_killable(struct folio *folio)
 }
 EXPORT_SYMBOL(folio_wait_private_2_killable);
 
+/*
+ * If folio was marked as uncached, then pages should be dropped when writeback
+ * completes. Do that now. If we fail, it's likely because of a big folio -
+ * just reset uncached for that case and latter completions should invalidate.
+ */
+static void folio_end_uncached(struct folio *folio)
+{
+	/*
+	 * Hitting !in_task() should not happen off RWF_UNCACHED writeback, but
+	 * can happen if normal writeback just happens to find dirty folios
+	 * that were created as part of uncached writeback, and that writeback
+	 * would otherwise not need non-IRQ handling. Just skip the
+	 * invalidation in that case.
+	 */
+	if (in_task() && folio_trylock(folio)) {
+		if (folio->mapping)
+			folio_unmap_invalidate(folio->mapping, folio, 0);
+		folio_unlock(folio);
+	}
+}
+
 /**
  * folio_end_writeback - End writeback against a folio.
  * @folio: The folio.
@@ -1610,6 +1631,8 @@ EXPORT_SYMBOL(folio_wait_private_2_killable);
  */
 void folio_end_writeback(struct folio *folio)
 {
+	bool folio_uncached = false;
+
 	VM_BUG_ON_FOLIO(!folio_test_writeback(folio), folio);
 
 	/*
@@ -1631,9 +1654,14 @@ void folio_end_writeback(struct folio *folio)
 	 * reused before the folio_wake_bit().
 	 */
 	folio_get(folio);
+	if (folio_test_uncached(folio) && folio_test_clear_uncached(folio))
+		folio_uncached = true;
 	if (__folio_end_writeback(folio))
 		folio_wake_bit(folio, PG_writeback);
 	acct_reclaim_writeback(folio);
+
+	if (folio_uncached)
+		folio_end_uncached(folio);
 	folio_put(folio);
 }
 EXPORT_SYMBOL(folio_end_writeback);
-- 
2.45.2


