Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C647BBF54
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Oct 2023 20:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbjJFSzQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 6 Oct 2023 14:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbjJFSyw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 14:54:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4957910F
        for <linux-xfs@vger.kernel.org>; Fri,  6 Oct 2023 11:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696618362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8fJjOgJTOBqTNpGZsppEB438CqzELHcDr88tlE5TL2U=;
        b=U8vFXha50cJePBiu0XXQMO3B1cGVrcSDnmQUoa06fX8zpIK9I8u/3uV91I0Kx3Z96XsBOf
        QEYdDez5jIV9j89R12qdsFcEgSD/lz41WI4jqKQSh9Ks+8QHzWV08mSKx6TyhC0UVoXPVy
        CLdJKo8rILWxYsi5XYJ3fzF9cw4SAoE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-LuGc4fjrMF-Uqu2agnFB1Q-1; Fri, 06 Oct 2023 14:52:31 -0400
X-MC-Unique: LuGc4fjrMF-Uqu2agnFB1Q-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9ae70250ef5so395946766b.0
        for <linux-xfs@vger.kernel.org>; Fri, 06 Oct 2023 11:52:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696618350; x=1697223150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8fJjOgJTOBqTNpGZsppEB438CqzELHcDr88tlE5TL2U=;
        b=ViQShq1zjOy1ONTiJ0KaSXZVeBJMWKkps34ql5xtAxgfclepbtpOztyBwPiknG7A04
         r5Kt8ipMPxTO6vcTuJvix49BXIvRBB1AfJMDV+7N+4+uy96RMpes2+mEuFEdPtCuUS9l
         83yQSCJ3RCGy/WaJI+1jUPh7tfGpD9KfynQ36JXdxi3kB3qRgfNAEPm8Xs012L7Sxm7o
         qtCXd1KONUTp7Eh1hHzE4NaoExTUAxCEL/mJa3uRfdlbW75iBEtdr9NUHgBtKm2RcN/i
         HNSujhYW0eghpxG4Y3tLi3Xc5HU2ykofMpzuGZOMAJJCeJ+8hD4jYjsfjjgNUTbb90cw
         1QjQ==
X-Gm-Message-State: AOJu0YxE7IQP1ZBIjEwsnVDYNKORpysTpjDLRo9vqyW0BGwYqgKgGnWR
        u8ol4g/AoL2mumm9whrI3zv2EpUJsLoAPUIunoOiZj/Nf2oiqOhI6EQvUQVrEgEXkQcKThkOrHt
        8wHcvV6L+wulOEFHTf5vatcQGUQbCo8s9oOTkyRXoSYTvxM5DnWg2ZxXBcgipnYwFv0qtCwFhf5
        9z5R4=
X-Received: by 2002:a17:906:31c1:b0:9b6:d20d:8a46 with SMTP id f1-20020a17090631c100b009b6d20d8a46mr5748164ejf.6.1696618349887;
        Fri, 06 Oct 2023 11:52:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJtYnAO2IwdX1h2RvfFSiMYTMaukCGR5jLN6oib6DxFhtgJB+r7zCfde55VfmX4YT5UsZzWg==
X-Received: by 2002:a17:906:31c1:b0:9b6:d20d:8a46 with SMTP id f1-20020a17090631c100b009b6d20d8a46mr5748148ejf.6.1696618349521;
        Fri, 06 Oct 2023 11:52:29 -0700 (PDT)
Received: from localhost.localdomain ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id os5-20020a170906af6500b009b947f81c4asm3304741ejb.155.2023.10.06.11.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Oct 2023 11:52:28 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     djwong@kernel.org, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v3 12/28] iomap: allow filesystem to implement read path verification
Date:   Fri,  6 Oct 2023 20:49:06 +0200
Message-Id: <20231006184922.252188-13-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231006184922.252188-1-aalbersh@redhat.com>
References: <20231006184922.252188-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently, there is no interface to let filesystem do
post-processing of completed BIO (ioend) in read path. This can be
very handy for fs-verity verification. This patch add a callout to
filesystem provided ->submit_bio to configure BIO completion callout.

The read path ioend iomap_read_ioend are stored side by side with
BIOs allocated from filesystem provided bio_set.

Add IOMAP_F_READ_VERITY which indicates that iomap need to
verify BIO (e.g. fs-verity) after I/O is completed.

Any verification itself happens on filesystem side. The verification
is done when the BIO is processed by calling out ->bi_end_io().

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/iomap/buffered-io.c | 40 +++++++++++++++++++++++++++++++++-------
 include/linux/iomap.h  | 15 +++++++++++++++
 2 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index ca78c7f62527..0a1bec91fdf6 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -332,6 +332,19 @@ static inline bool iomap_block_needs_zeroing(const struct iomap_iter *iter,
 		pos >= i_size_read(iter->inode);
 }
 
+static void
+iomap_submit_read_io(const struct iomap_iter *iter,
+		struct iomap_readpage_ctx *ctx)
+{
+	if (!ctx->bio)
+		return;
+
+	if (ctx->ops && ctx->ops->submit_io)
+		ctx->ops->submit_io(iter, ctx->bio, iter->pos);
+	else
+		submit_bio(ctx->bio);
+}
+
 static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 		struct iomap_readpage_ctx *ctx, loff_t offset)
 {
@@ -355,6 +368,13 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 
 	if (iomap_block_needs_zeroing(iter, pos)) {
 		folio_zero_range(folio, poff, plen);
+		if (iomap->flags & IOMAP_F_READ_VERITY) {
+			if (ctx->ops->verify_folio(folio, poff, plen)) {
+				folio_set_error(folio);
+				goto done;
+			}
+		}
+
 		iomap_set_range_uptodate(folio, poff, plen);
 		goto done;
 	}
@@ -371,13 +391,20 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 		gfp_t orig_gfp = gfp;
 		unsigned int nr_vecs = DIV_ROUND_UP(length, PAGE_SIZE);
 
-		if (ctx->bio)
-			submit_bio(ctx->bio);
+		iomap_submit_read_io(iter, ctx);
 
 		if (ctx->rac) /* same as readahead_gfp_mask */
 			gfp |= __GFP_NORETRY | __GFP_NOWARN;
-		ctx->bio = bio_alloc(iomap->bdev, bio_max_segs(nr_vecs),
-				     REQ_OP_READ, gfp);
+
+		if (ctx->ops && ctx->ops->bio_set)
+			ctx->bio = bio_alloc_bioset(iomap->bdev,
+						    bio_max_segs(nr_vecs),
+						    REQ_OP_READ, GFP_NOFS,
+						    ctx->ops->bio_set);
+		else
+			ctx->bio = bio_alloc(iomap->bdev, bio_max_segs(nr_vecs),
+				REQ_OP_READ, gfp);
+
 		/*
 		 * If the bio_alloc fails, try it again for a single page to
 		 * avoid having to deal with partial page reads.  This emulates
@@ -427,7 +454,7 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops,
 		folio_set_error(folio);
 
 	if (ctx.bio) {
-		submit_bio(ctx.bio);
+		iomap_submit_read_io(&iter, &ctx);
 		WARN_ON_ONCE(!ctx.cur_folio_in_bio);
 	} else {
 		WARN_ON_ONCE(ctx.cur_folio_in_bio);
@@ -502,8 +529,7 @@ void iomap_readahead(struct readahead_control *rac, const struct iomap_ops *ops,
 	while (iomap_iter(&iter, ops) > 0)
 		iter.processed = iomap_readahead_iter(&iter, &ctx);
 
-	if (ctx.bio)
-		submit_bio(ctx.bio);
+	iomap_submit_read_io(&iter, &ctx);
 	if (ctx.cur_folio) {
 		if (!ctx.cur_folio_in_bio)
 			folio_unlock(ctx.cur_folio);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 3565c449f3c9..8d7206cd2f0f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -53,6 +53,9 @@ struct vm_fault;
  *
  * IOMAP_F_XATTR indicates that the iomap is for an extended attribute extent
  * rather than a file data extent.
+ *
+ * IOMAP_F_READ_VERITY indicates that the iomap needs verification of read
+ * folios
  */
 #define IOMAP_F_NEW		(1U << 0)
 #define IOMAP_F_DIRTY		(1U << 1)
@@ -64,6 +67,7 @@ struct vm_fault;
 #define IOMAP_F_BUFFER_HEAD	0
 #endif /* CONFIG_BUFFER_HEAD */
 #define IOMAP_F_XATTR		(1U << 5)
+#define IOMAP_F_READ_VERITY	(1U << 6)
 
 /*
  * Flags set by the core iomap code during operations:
@@ -262,7 +266,18 @@ int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
 		struct iomap *iomap, loff_t pos, loff_t length, ssize_t written,
 		int (*punch)(struct inode *inode, loff_t pos, loff_t length));
 
+struct iomap_read_ioend {
+	struct inode		*io_inode;	/* file being read from */
+	struct work_struct	work;		/* post read work (e.g. fs-verity) */
+	struct bio		read_inline_bio;/* MUST BE LAST! */
+};
+
 struct iomap_readpage_ops {
+	/*
+	 * Optional, verify folio when successfully read
+	 */
+	int (*verify_folio)(struct folio *folio, loff_t pos, unsigned int len);
+
 	/*
 	 * Filesystems wishing to attach private information to a direct io bio
 	 * must provide a ->submit_io method that attaches the additional
-- 
2.40.1

