Return-Path: <linux-xfs+bounces-4592-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 22908870A39
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Mar 2024 20:13:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A182C1F2300E
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Mar 2024 19:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF99479DBE;
	Mon,  4 Mar 2024 19:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GQ/ow0ew"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAE678B79
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 19:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579538; cv=none; b=oA404NZuqKPvC6kzyAN4tm/2NVEkx8OnktwOeu4v2tMb2tpVLI92FrMqVsqhT1sjd9f2Z+Mx5vSYSKgmpmfKxxUWgEdmXkUz0KVlFHt1z75vgs+FqEZeXB/9mP7dcx2QClOVmYpklBJLqNL6SdEggF7lBS92A52pcX70IIArQWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579538; c=relaxed/simple;
	bh=grAu43Eie92E+XOQ7d04C6cdM5uR0Ox/AK1rLCL9Nso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezIvwKxviH4J2RG1qVY1bel7g9k2kAxIflwREI+kVmgfblQgK+vCf1wkVD2u6PnjtgKEmK3w5LguBVfrvLoUDFQsMdfSLedlE/O74Lieodl54AChZyPtHlUkPjwB3Yu6OAuq7q8+Hrcfuz7/RwC17+CRbWbepL1FJDvGYdYul9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GQ/ow0ew; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709579535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qXH4oA7cWAgzu2mxLxXFHd34t/bbMKvcNeTx3/w9/Kc=;
	b=GQ/ow0ewCHjC8TplC0S4bG6Shvxco7zg4p/83COGxr0cgJyXq10LwpYwfTzJBiV5kSeop2
	Nm5wUhcSjcWjRisv16rOPUUy84MG2tArc5Fa0tflVmwJD+oHapacbIrxGdVYxcYDqJGV8X
	Nw9ZuWnuDTgU6uWK4rHti24CwtUhTlE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-327-fjtPEPSYOzakzrdEZNCFug-1; Mon, 04 Mar 2024 14:12:13 -0500
X-MC-Unique: fjtPEPSYOzakzrdEZNCFug-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-51325a4d003so5318336e87.3
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 11:12:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579532; x=1710184332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qXH4oA7cWAgzu2mxLxXFHd34t/bbMKvcNeTx3/w9/Kc=;
        b=kj3LQh8hodcEOvbxnNs7TVuHjjnJY1GHW/Ew1SpFx4GIPTnv9nmZHSTwzPfC6b//IU
         zG6IC1VK6UmZZyjhsnf8UxVJGt+BXhHNssKhJvWb5bXE0kpmW46EkFOBwqJL3NvxJ2+m
         FT0xZBLJFzxEcgM9G12ZSip57ZZ5z95UYlLVwjMFKx0LHbdMTtaaz5MJUYeo0O7Oli6m
         kADL8OhRatH4t3RDwfXbbfJH21nfz6m9vTIjk6KEuIl+L6X3kA2Cr8wPuOXCxk+mDCsL
         Dv7fbmLrY2cIs7A1DIbSJ/WGRMZAQoAU7p1JRdFbDGt1z4LXNgSoP8DOsE0LDYN7f5Oe
         /i5A==
X-Forwarded-Encrypted: i=1; AJvYcCWEvDNRvhipfyERdcqM73oObQVbW+AurujkRF+eTAojnkMZ2K/EOJ/nDIJF+50FeGOQtk9D+kbzsASxXgqUpGy/SgEf4OwIhSnu
X-Gm-Message-State: AOJu0YxCj7hZIbegFvGjDaE1Z9NnCfDqMHaD5M7OiHcIa9qLsQ5MjNLB
	ZnhCyxAUfh2sfos6DdpOyHziZc9n94eUxRVdVYShdihIaF9v7biw8jEbQu+Z7BjVdTACSDvI1O2
	uQ4Pdc0QlEEavyNJs/IvUV03rmBkK1iobv5Q0+qlbm1/Pj6w89De+S/s2
X-Received: by 2002:a19:6406:0:b0:512:eb9a:dab7 with SMTP id y6-20020a196406000000b00512eb9adab7mr6191436lfb.2.1709579531899;
        Mon, 04 Mar 2024 11:12:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFmvwQHZczKkRO+3Qv9f+16OlN4ewbg8aTrkBU/tuYNoG9gi7a1s9fyz7dMVO+hCtnT/D4e4A==
X-Received: by 2002:a19:6406:0:b0:512:eb9a:dab7 with SMTP id y6-20020a196406000000b00512eb9adab7mr6191421lfb.2.1709579531436;
        Mon, 04 Mar 2024 11:12:11 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709064a4b00b00a44a04aa3cfsm3783319ejv.225.2024.03.04.11.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 11:12:11 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH v5 01/24] fsverity: remove hash page spin lock
Date: Mon,  4 Mar 2024 20:10:24 +0100
Message-ID: <20240304191046.157464-3-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240304191046.157464-2-aalbersh@redhat.com>
References: <20240304191046.157464-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The spin lock is not necessary here as it can be replaced with
memory barrier which should be better performance-wise.

When Merkle tree block size differs from page size, in
is_hash_block_verified() two things are modified during check - a
bitmap and PG_checked flag of the page.

Each bit in the bitmap represent verification status of the Merkle
tree blocks. PG_checked flag tells if page was just re-instantiated
or was in pagecache. Both of this states are shared between
verification threads. Page which was re-instantiated can not have
already verified blocks (bit set in bitmap).

The spin lock was used to allow only one thread to modify both of
these states and keep order of operations. The only requirement here
is that PG_Checked is set strictly after bitmap is updated.
This way other threads which see that PG_Checked=1 (page cached)
knows that bitmap is up-to-date. Otherwise, if PG_Checked is set
before bitmap is cleared, other threads can see bit=1 and therefore
will not perform verification of that Merkle tree block.

However, there's still the case when one thread is setting a bit in
verify_data_block() and other thread is clearing it in
is_hash_block_verified(). This can happen if two threads get to
!PageChecked branch and one of the threads is rescheduled before
resetting the bitmap. This is fine as at worst blocks are
re-verified in each thread.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/verity/fsverity_private.h |  1 -
 fs/verity/open.c             |  1 -
 fs/verity/verify.c           | 48 ++++++++++++++++++------------------
 3 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index a6a6b2749241..b3506f56e180 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -69,7 +69,6 @@ struct fsverity_info {
 	u8 file_digest[FS_VERITY_MAX_DIGEST_SIZE];
 	const struct inode *inode;
 	unsigned long *hash_block_verified;
-	spinlock_t hash_page_init_lock;
 };
 
 #define FS_VERITY_MAX_SIGNATURE_SIZE	(FS_VERITY_MAX_DESCRIPTOR_SIZE - \
diff --git a/fs/verity/open.c b/fs/verity/open.c
index 6c31a871b84b..fdeb95eca3af 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -239,7 +239,6 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
 			err = -ENOMEM;
 			goto fail;
 		}
-		spin_lock_init(&vi->hash_page_init_lock);
 	}
 
 	return vi;
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 904ccd7e8e16..4fcad0825a12 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -19,7 +19,6 @@ static struct workqueue_struct *fsverity_read_workqueue;
 static bool is_hash_block_verified(struct fsverity_info *vi, struct page *hpage,
 				   unsigned long hblock_idx)
 {
-	bool verified;
 	unsigned int blocks_per_page;
 	unsigned int i;
 
@@ -43,12 +42,20 @@ static bool is_hash_block_verified(struct fsverity_info *vi, struct page *hpage,
 	 * re-instantiated from the backing storage are re-verified.  To do
 	 * this, we use PG_checked again, but now it doesn't really mean
 	 * "checked".  Instead, now it just serves as an indicator for whether
-	 * the hash page is newly instantiated or not.
+	 * the hash page is newly instantiated or not.  If the page is new, as
+	 * indicated by PG_checked=0, we clear the bitmap bits for the page's
+	 * blocks since they are untrustworthy, then set PG_checked=1.
+	 * Otherwise we return the bitmap bit for the requested block.
 	 *
-	 * The first thread that sees PG_checked=0 must clear the corresponding
-	 * bitmap bits, then set PG_checked=1.  This requires a spinlock.  To
-	 * avoid having to take this spinlock in the common case of
-	 * PG_checked=1, we start with an opportunistic lockless read.
+	 * Multiple threads may execute this code concurrently on the same page.
+	 * This is safe because we use memory barriers to ensure that if a
+	 * thread sees PG_checked=1, then it also sees the associated bitmap
+	 * clearing to have occurred.  Also, all writes and their corresponding
+	 * reads are atomic, and all writes are safe to repeat in the event that
+	 * multiple threads get into the PG_checked=0 section.  (Clearing a
+	 * bitmap bit again at worst causes a hash block to be verified
+	 * redundantly.  That event should be very rare, so it's not worth using
+	 * a lock to avoid.  Setting PG_checked again has no effect.)
 	 */
 	if (PageChecked(hpage)) {
 		/*
@@ -58,24 +65,17 @@ static bool is_hash_block_verified(struct fsverity_info *vi, struct page *hpage,
 		smp_rmb();
 		return test_bit(hblock_idx, vi->hash_block_verified);
 	}
-	spin_lock(&vi->hash_page_init_lock);
-	if (PageChecked(hpage)) {
-		verified = test_bit(hblock_idx, vi->hash_block_verified);
-	} else {
-		blocks_per_page = vi->tree_params.blocks_per_page;
-		hblock_idx = round_down(hblock_idx, blocks_per_page);
-		for (i = 0; i < blocks_per_page; i++)
-			clear_bit(hblock_idx + i, vi->hash_block_verified);
-		/*
-		 * A write memory barrier is needed here to give RELEASE
-		 * semantics to the below SetPageChecked() operation.
-		 */
-		smp_wmb();
-		SetPageChecked(hpage);
-		verified = false;
-	}
-	spin_unlock(&vi->hash_page_init_lock);
-	return verified;
+	blocks_per_page = vi->tree_params.blocks_per_page;
+	hblock_idx = round_down(hblock_idx, blocks_per_page);
+	for (i = 0; i < blocks_per_page; i++)
+		clear_bit(hblock_idx + i, vi->hash_block_verified);
+	/*
+	 * A write memory barrier is needed here to give RELEASE semantics to
+	 * the below SetPageChecked() operation.
+	 */
+	smp_wmb();
+	SetPageChecked(hpage);
+	return false;
 }
 
 /*
-- 
2.42.0


