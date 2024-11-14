Return-Path: <linux-xfs+bounces-15453-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0425A9C8E39
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Nov 2024 16:35:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 868FB1F2259A
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Nov 2024 15:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0309C1ADFF8;
	Thu, 14 Nov 2024 15:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Y/1STsAJ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10901A3AB9
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 15:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731598100; cv=none; b=m/EyR3N4xoHD+J2Q7JrBHWkMZfb2l4H9gZIN0nwi4QGu2Y+y4/SgRuXarSXIvA0AQ5e9m6sZE5/6CMRF8mgWdcVtRw5VAvYMpb30yxY9V1AniXOovwVbL2PDw9QruDSVAphRr/Ql2pjwHQWkclMir32N//GtQEurG7eiu6bo8+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731598100; c=relaxed/simple;
	bh=4ADL7kFFYjVJou6EGB93OsIZhCYEyfOeIONxeYUu3bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZ5ddmdYzkfew8dgyxmh+KgtHCTO+TauXvrglDt2jggsi7U14OS3co+rwqaqCebkiuxO1nQxfnBj+6EUWEiZ95OabSdgn7q7DLIzGRc4GJ/uJisFhr8ucLJmuxk6tEIb2sxr0JKc+ezLybWEf+k4hQSIgzojWsqZGsr9gSsuT6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Y/1STsAJ; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5ee8eaa1694so403908eaf.0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 07:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731598096; x=1732202896; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xBThbwgpFnDYguERwRJ3Nd3OfeHrc6kNH6KxzsoIqNs=;
        b=Y/1STsAJbfgjZWLNjNVPEb2T1+Tkc+R0bkZw+xEncWocTemeDgFAq8hag/d4xZ23Gw
         LSXgXhX7eUX54UxAHmT1/2Hsvm+roRe0baboYnuFC2gBibn9Hozis+66CEMRck5bWKGQ
         VKRULUlDh9jkAJ8E2fxcOlDoY5eEI5kUB8wFcV8r49dE91ltSRZ/LdxRWIRLGNy9LgbT
         2OSo0ofWUrxG+GfKgo+r+J2lZL8RNuDtdhuSsyC6b/U7+qsAG1ZeFwwouavPzZnzUj6U
         K8fwZ0KLqWfSHYyT1kjZog9HorPus4/7qfRQb5pSNhkL/yi2ncA2b3S5ePj/+Dk0YFbc
         IIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731598096; x=1732202896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xBThbwgpFnDYguERwRJ3Nd3OfeHrc6kNH6KxzsoIqNs=;
        b=O8y5gDiWCPdgEpw3tnvtYBoDHvuuIgyni+rWqHVuRAMP4Uyyrj4pie26fASzQznxC0
         EP4V0ZkNtCDtUieuH1FET8eYc32/VvzHPdyc0eOPHo2F1VjN8oX/GjoRolg6dYr7ueIu
         CHQf8TG4taexgaR+5mCFix7Q4/7yt8IBXPTq9Qz+Bxoq13x91xFobBVV3ruP0wnH6AVm
         M1I42PgYgZeVMH1gZBAmwf/RWEXPbVEyWRT1ZuhFT6WpIF6bNxANxaPUJaGTEprHrSIL
         guVnq3p8Bl/S9blQRLtvipStW2eBdn7ICAEhhGapoc6h6WNxDOYdZSKHjhlyKZNFg+/d
         yTWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkm0EgGnyjwZxKyBi/KOT2r+CJSAv1S0FE9iaA/pm4oNItZofoVkd2f0d8f+58AyV2Tt+7nCG4s6w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuMceN9TRP//sxQy0oMr6S5L/RkZPMwciDlnA5/Vvd2jB1+Rx1
	wK0J1FCa1Q0d6ruuSJdIiMtGwpEA0eSdrncHfG9FGGELDbT8XqYbXIZWhckNW7o=
X-Google-Smtp-Source: AGHT+IHjZdeOSBooCNtlJS5s8uHCzSyESjo+TDYveTg1n/VGl8pzguc4+c1Edpma/7ckXWFt8H0gGQ==
X-Received: by 2002:a4a:ec4c:0:b0:5e1:cd24:c19c with SMTP id 006d021491bc7-5ee868b0bf0mr9239441eaf.0.1731598095749;
        Thu, 14 Nov 2024 07:28:15 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5eea026eb41sm368250eaf.39.2024.11.14.07.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 07:28:15 -0800 (PST)
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
	bfoster@redhat.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/17] mm/filemap: make buffered writes work with RWF_UNCACHED
Date: Thu, 14 Nov 2024 08:25:14 -0700
Message-ID: <20241114152743.2381672-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241114152743.2381672-2-axboe@kernel.dk>
References: <20241114152743.2381672-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If RWF_UNCACHED is set for a write, mark new folios being written with
uncached. This is done by passing in the fact that it's an uncached write
through the folio pointer. We can only get there when IOCB_UNCACHED was
allowed, which can only happen if the file system opts in. Opting in means
they need to check for the LSB in the folio pointer to know if it's an
uncached write or not. If it is, then FGP_UNCACHED should be used if
creating new folios is necessary.

Uncached writes will drop any folios they create upon writeback
completion, but leave folios that may exist in that range alone. Since
->write_begin() doesn't currently take any flags, and to avoid needing
to change the callback kernel wide, use the foliop being passed in to
->write_begin() to signal if this is an uncached write or not. File
systems can then use that to mark newly created folios as uncached.

This provides similar benefits to using RWF_UNCACHED with reads. Testing
buffered writes on 32 files:

writing bs 65536, uncached 0
  1s: 196035MB/sec
  2s: 132308MB/sec
  3s: 132438MB/sec
  4s: 116528MB/sec
  5s: 103898MB/sec
  6s: 108893MB/sec
  7s: 99678MB/sec
  8s: 106545MB/sec
  9s: 106826MB/sec
 10s: 101544MB/sec
 11s: 111044MB/sec
 12s: 124257MB/sec
 13s: 116031MB/sec
 14s: 114540MB/sec
 15s: 115011MB/sec
 16s: 115260MB/sec
 17s: 116068MB/sec
 18s: 116096MB/sec

where it's quite obvious where the page cache filled, and performance
dropped from to about half of where it started, settling in at around
115GB/sec. Meanwhile, 32 kswapds were running full steam trying to
reclaim pages.

Running the same test with uncached buffered writes:

writing bs 65536, uncached 1
  1s: 198974MB/sec
  2s: 189618MB/sec
  3s: 193601MB/sec
  4s: 188582MB/sec
  5s: 193487MB/sec
  6s: 188341MB/sec
  7s: 194325MB/sec
  8s: 188114MB/sec
  9s: 192740MB/sec
 10s: 189206MB/sec
 11s: 193442MB/sec
 12s: 189659MB/sec
 13s: 191732MB/sec
 14s: 190701MB/sec
 15s: 191789MB/sec
 16s: 191259MB/sec
 17s: 190613MB/sec
 18s: 191951MB/sec

and the behavior is fully predictable, performing the same throughout
even after the page cache would otherwise have fully filled with dirty
data. It's also about 65% faster, and using half the CPU of the system
compared to the normal buffered write.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/fs.h      |  5 +++++
 include/linux/pagemap.h |  9 +++++++++
 mm/filemap.c            | 12 +++++++++++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 45510d0b8de0..122ae821989f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2877,6 +2877,11 @@ static inline ssize_t generic_write_sync(struct kiocb *iocb, ssize_t count)
 				(iocb->ki_flags & IOCB_SYNC) ? 0 : 1);
 		if (ret)
 			return ret;
+	} else if (iocb->ki_flags & IOCB_UNCACHED) {
+		struct address_space *mapping = iocb->ki_filp->f_mapping;
+
+		filemap_fdatawrite_range_kick(mapping, iocb->ki_pos,
+					      iocb->ki_pos + count);
 	}
 
 	return count;
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index d55bf995bd9e..cc02518d338d 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -14,6 +14,7 @@
 #include <linux/gfp.h>
 #include <linux/bitops.h>
 #include <linux/hardirq.h> /* for in_interrupt() */
+#include <linux/writeback.h>
 #include <linux/hugetlb_inline.h>
 
 struct folio_batch;
@@ -70,6 +71,14 @@ static inline int filemap_write_and_wait(struct address_space *mapping)
 	return filemap_write_and_wait_range(mapping, 0, LLONG_MAX);
 }
 
+/*
+ * Value passed in to ->write_begin() if IOCB_UNCACHED is set for the write,
+ * and the ->write_begin() handler on a file system supporting FOP_UNCACHED
+ * must check for this and pass FGP_UNCACHED for folio creation.
+ */
+#define foliop_uncached			((struct folio *) 0xfee1c001)
+#define foliop_is_uncached(foliop)	(*(foliop) == foliop_uncached)
+
 /**
  * filemap_set_wb_err - set a writeback error on an address_space
  * @mapping: mapping in which to set writeback error
diff --git a/mm/filemap.c b/mm/filemap.c
index 13815194ed8a..297cb53332ff 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4076,7 +4076,7 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
 	ssize_t written = 0;
 
 	do {
-		struct folio *folio;
+		struct folio *folio = NULL;
 		size_t offset;		/* Offset into folio */
 		size_t bytes;		/* Bytes to write to folio */
 		size_t copied;		/* Bytes copied from user */
@@ -4104,6 +4104,16 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
 			break;
 		}
 
+		/*
+		 * If IOCB_UNCACHED is set here, we now the file system
+		 * supports it. And hence it'll know to check folip for being
+		 * set to this magic value. If so, it's an uncached write.
+		 * Whenever ->write_begin() changes prototypes again, this
+		 * can go away and just pass iocb or iocb flags.
+		 */
+		if (iocb->ki_flags & IOCB_UNCACHED)
+			folio = foliop_uncached;
+
 		status = a_ops->write_begin(file, mapping, pos, bytes,
 						&folio, &fsdata);
 		if (unlikely(status < 0))
-- 
2.45.2


