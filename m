Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B017C650507
	for <lists+linux-xfs@lfdr.de>; Sun, 18 Dec 2022 23:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbiLRWN2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 18 Dec 2022 17:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbiLRWN1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 17:13:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FA42198
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 14:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671401479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YBjyQlptB5PLKIuxcyCDyq+X80V2H5J58Z9A/PfEHto=;
        b=Pvm2vEsLEzZbZu75x29aLreEw5zPepzuzeQIqiFofSbS1pB3BrrzSrcSNAB4GDUXdvh/BH
        1pli6cZV1Jth3NQAnPQnoFIciO3oDBu+x38kWEBjHEqYuZ5KmrQTQb46bN3V4mm26Ifm8Q
        qQ/f/IkGYOgFzHNzdeV4Gdyn9BUXANU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-nzFZuUTAOBWKtO6vcaFHDQ-1; Sun, 18 Dec 2022 17:11:14 -0500
X-MC-Unique: nzFZuUTAOBWKtO6vcaFHDQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA3E5802C1C;
        Sun, 18 Dec 2022 22:11:13 +0000 (UTC)
Received: from pasta.redhat.com (ovpn-192-22.brq.redhat.com [10.40.192.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1D3C2166B26;
        Sun, 18 Dec 2022 22:11:11 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com
Subject: [RFC v4 7/7] iomap: Rename page_ops to folio_ops
Date:   Sun, 18 Dec 2022 23:10:54 +0100
Message-Id: <20221218221054.3946886-8-agruenba@redhat.com>
In-Reply-To: <20221216150626.670312-1-agruenba@redhat.com>
References: <20221216150626.670312-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The operations in struct page_ops all operate on folios, so rename
struct page_ops to struct folio_ops, ->page_prepare() to
->folio_prepare(), and ->page_done() to ->folio_done().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/bmap.c         | 16 ++++++++--------
 fs/iomap/buffered-io.c | 12 ++++++------
 fs/xfs/xfs_iomap.c     |  8 ++++----
 include/linux/iomap.h  | 22 +++++++++++-----------
 4 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index ed8ceed64100..57282e3720be 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -960,7 +960,7 @@ static int __gfs2_iomap_get(struct inode *inode, loff_t pos, loff_t length,
 }
 
 static struct folio *
-gfs2_iomap_page_prepare(struct iomap_iter *iter, loff_t pos, unsigned len)
+gfs2_iomap_folio_prepare(struct iomap_iter *iter, loff_t pos, unsigned len)
 {
 	struct inode *inode = iter->inode;
 	unsigned int blockmask = i_blocksize(inode) - 1;
@@ -980,8 +980,8 @@ gfs2_iomap_page_prepare(struct iomap_iter *iter, loff_t pos, unsigned len)
 	return folio;
 }
 
-static void gfs2_iomap_page_done(struct inode *inode, loff_t pos,
-				 unsigned copied, struct folio *folio)
+static void gfs2_iomap_folio_done(struct inode *inode, loff_t pos,
+				  unsigned copied, struct folio *folio)
 {
 	struct gfs2_trans *tr = current->journal_info;
 	struct gfs2_inode *ip = GFS2_I(inode);
@@ -1005,9 +1005,9 @@ static void gfs2_iomap_page_done(struct inode *inode, loff_t pos,
 	gfs2_trans_end(sdp);
 }
 
-static const struct iomap_page_ops gfs2_iomap_page_ops = {
-	.page_prepare = gfs2_iomap_page_prepare,
-	.page_done = gfs2_iomap_page_done,
+static const struct iomap_folio_ops gfs2_iomap_folio_ops = {
+	.folio_prepare = gfs2_iomap_folio_prepare,
+	.folio_done = gfs2_iomap_folio_done,
 };
 
 static int gfs2_iomap_begin_write(struct inode *inode, loff_t pos,
@@ -1083,7 +1083,7 @@ static int gfs2_iomap_begin_write(struct inode *inode, loff_t pos,
 	}
 
 	if (gfs2_is_stuffed(ip) || gfs2_is_jdata(ip))
-		iomap->page_ops = &gfs2_iomap_page_ops;
+		iomap->folio_ops = &gfs2_iomap_folio_ops;
 	return 0;
 
 out_trans_end:
@@ -1299,7 +1299,7 @@ int gfs2_alloc_extent(struct inode *inode, u64 lblock, u64 *dblock,
 /*
  * NOTE: Never call gfs2_block_zero_range with an open transaction because it
  * uses iomap write to perform its actions, which begin their own transactions
- * (iomap_begin, page_prepare, etc.)
+ * (iomap_begin, folio_prepare, etc.)
  */
 static int gfs2_block_zero_range(struct inode *inode, loff_t from,
 				 unsigned int length)
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 32a2a287d32c..1d1ca1fb4a88 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -603,10 +603,10 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
 static void iomap_folio_done(struct iomap_iter *iter, loff_t pos, size_t ret,
 		struct folio *folio)
 {
-	const struct iomap_page_ops *page_ops = iter->iomap.page_ops;
+	const struct iomap_folio_ops *folio_ops = iter->iomap.folio_ops;
 
-	if (page_ops && page_ops->page_done) {
-		page_ops->page_done(iter->inode, pos, ret, folio);
+	if (folio_ops && folio_ops->folio_done) {
+		folio_ops->folio_done(iter->inode, pos, ret, folio);
 	} else {
 		folio_unlock(folio);
 		folio_put(folio);
@@ -625,7 +625,7 @@ static int iomap_write_begin_inline(const struct iomap_iter *iter,
 static int iomap_write_begin(struct iomap_iter *iter, loff_t pos,
 		size_t len, struct folio **foliop)
 {
-	const struct iomap_page_ops *page_ops = iter->iomap.page_ops;
+	const struct iomap_folio_ops *folio_ops = iter->iomap.folio_ops;
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
 	struct folio *folio;
 	int status;
@@ -640,8 +640,8 @@ static int iomap_write_begin(struct iomap_iter *iter, loff_t pos,
 	if (!mapping_large_folio_support(iter->inode->i_mapping))
 		len = min_t(size_t, len, PAGE_SIZE - offset_in_page(pos));
 
-	if (page_ops && page_ops->page_prepare)
-		folio = page_ops->page_prepare(iter, pos, len);
+	if (folio_ops && folio_ops->folio_prepare)
+		folio = folio_ops->folio_prepare(iter, pos, len);
 	else
 		folio = iomap_folio_prepare(iter, pos);
 	if (IS_ERR(folio)) {
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ae83cb89279d..04ba368395cc 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -63,7 +63,7 @@ xfs_iomap_inode_sequence(
 }
 
 static struct folio *
-xfs_page_prepare(
+xfs_folio_prepare(
 	struct iomap_iter	*iter,
 	loff_t			pos,
 	unsigned		len)
@@ -99,8 +99,8 @@ xfs_page_prepare(
 	return folio;
 }
 
-const struct iomap_page_ops xfs_iomap_page_ops = {
-	.page_prepare		= xfs_page_prepare,
+const struct iomap_folio_ops xfs_iomap_folio_ops = {
+	.folio_prepare		= xfs_folio_prepare,
 };
 
 int
@@ -149,7 +149,7 @@ xfs_bmbt_to_iomap(
 		iomap->flags |= IOMAP_F_DIRTY;
 
 	iomap->validity_cookie = sequence_cookie;
-	iomap->page_ops = &xfs_iomap_page_ops;
+	iomap->folio_ops = &xfs_iomap_folio_ops;
 	return 0;
 }
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 1c8b9a04b0bb..85d360881851 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -86,7 +86,7 @@ struct vm_fault;
  */
 #define IOMAP_NULL_ADDR -1ULL	/* addr is not valid */
 
-struct iomap_page_ops;
+struct iomap_folio_ops;
 
 struct iomap {
 	u64			addr; /* disk offset of mapping, bytes */
@@ -98,7 +98,7 @@ struct iomap {
 	struct dax_device	*dax_dev; /* dax_dev for dax operations */
 	void			*inline_data;
 	void			*private; /* filesystem private */
-	const struct iomap_page_ops *page_ops;
+	const struct iomap_folio_ops *folio_ops;
 	u64			validity_cookie; /* used with .iomap_valid() */
 };
 
@@ -126,19 +126,19 @@ static inline bool iomap_inline_data_valid(const struct iomap *iomap)
 }
 
 /*
- * When a filesystem sets page_ops in an iomap mapping it returns, page_prepare
- * and page_done will be called for each page written to.  This only applies to
- * buffered writes as unbuffered writes will not typically have pages
- * associated with them.
+ * When a filesystem sets folio_ops in an iomap mapping it returns,
+ * folio_prepare and folio_done will be called for each page written to.  This
+ * only applies to buffered writes as unbuffered writes will not typically have
+ * pages associated with them.
  *
- * When page_prepare succeeds, page_done will always be called to do any
- * cleanup work necessary.  page_done is responsible for unlocking and putting
+ * When folio_prepare succeeds, folio_done will always be called to do any
+ * cleanup work necessary.  folio_done is responsible for unlocking and putting
  * @folio.
  */
-struct iomap_page_ops {
-	struct folio *(*page_prepare)(struct iomap_iter *iter, loff_t pos,
+struct iomap_folio_ops {
+	struct folio *(*folio_prepare)(struct iomap_iter *iter, loff_t pos,
 			unsigned len);
-	void (*page_done)(struct inode *inode, loff_t pos, unsigned copied,
+	void (*folio_done)(struct inode *inode, loff_t pos, unsigned copied,
 			struct folio *folio);
 };
 
-- 
2.38.1

