Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0796504F9
	for <lists+linux-xfs@lfdr.de>; Sun, 18 Dec 2022 23:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiLRWMk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 18 Dec 2022 17:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbiLRWMh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Dec 2022 17:12:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC81F113D
        for <linux-xfs@vger.kernel.org>; Sun, 18 Dec 2022 14:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671401466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VO+moG/oEppC7fzqfjLDfJ6GvGE7XkJyRsj4uh85qjM=;
        b=G/RRENxonUAAdxLqIejnej6NDm3x5bUeYcn5346ruqxtQHlS/L9h8/ULJyYgO09Jqiq6z6
        HEfnkEXnXdQQh1xhSxBhKFmMjOabuCH34aOK6Fg35vju9PJQUXPKTegPGVXx+szbk2yXwO
        c6cE+/XPNd8qKlVscQzIr+p0jUCywY8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-80-n_oP86IUNBa8PDBP_AvaUA-1; Sun, 18 Dec 2022 17:11:02 -0500
X-MC-Unique: n_oP86IUNBa8PDBP_AvaUA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1DE0381078F;
        Sun, 18 Dec 2022 22:11:01 +0000 (UTC)
Received: from pasta.redhat.com (ovpn-192-22.brq.redhat.com [10.40.192.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3CCD2166B26;
        Sun, 18 Dec 2022 22:10:59 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com
Subject: [RFC v4 2/7] iomap: Add iomap_folio_done helper
Date:   Sun, 18 Dec 2022 23:10:49 +0100
Message-Id: <20221218221054.3946886-3-agruenba@redhat.com>
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

Add an iomap_folio_done() helper to encapsulate unlocking the folio,
calling ->page_done(), and putting the folio.  This doesn't change the
functionality.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap/buffered-io.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 347010c6a652..8ce9abb29d46 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -575,6 +575,19 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
 	return 0;
 }
 
+static void iomap_folio_done(struct iomap_iter *iter, loff_t pos, size_t ret,
+		struct folio *folio)
+{
+	const struct iomap_page_ops *page_ops = iter->iomap.page_ops;
+
+	if (folio)
+		folio_unlock(folio);
+	if (page_ops && page_ops->page_done)
+		page_ops->page_done(iter->inode, pos, ret, &folio->page);
+	if (folio)
+		folio_put(folio);
+}
+
 static int iomap_write_begin_inline(const struct iomap_iter *iter,
 		struct folio *folio)
 {
@@ -616,7 +629,8 @@ static int iomap_write_begin(struct iomap_iter *iter, loff_t pos,
 			fgp, mapping_gfp_mask(iter->inode->i_mapping));
 	if (!folio) {
 		status = (iter->flags & IOMAP_NOWAIT) ? -EAGAIN : -ENOMEM;
-		goto out_no_page;
+		iomap_folio_done(iter, pos, 0, NULL);
+		return status;
 	}
 
 	/*
@@ -656,13 +670,9 @@ static int iomap_write_begin(struct iomap_iter *iter, loff_t pos,
 	return 0;
 
 out_unlock:
-	folio_unlock(folio);
-	folio_put(folio);
+	iomap_folio_done(iter, pos, 0, folio);
 	iomap_write_failed(iter->inode, pos, len);
 
-out_no_page:
-	if (page_ops && page_ops->page_done)
-		page_ops->page_done(iter->inode, pos, 0, NULL);
 	return status;
 }
 
@@ -712,7 +722,6 @@ static size_t iomap_write_end_inline(const struct iomap_iter *iter,
 static size_t iomap_write_end(struct iomap_iter *iter, loff_t pos, size_t len,
 		size_t copied, struct folio *folio)
 {
-	const struct iomap_page_ops *page_ops = iter->iomap.page_ops;
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
 	loff_t old_size = iter->inode->i_size;
 	size_t ret;
@@ -736,11 +745,8 @@ static size_t iomap_write_end(struct iomap_iter *iter, loff_t pos, size_t len,
 		iter->iomap.flags |= IOMAP_F_SIZE_CHANGED;
 		folio_may_straddle_isize(iter->inode, folio, old_size, pos);
 	}
-	folio_unlock(folio);
 
-	if (page_ops && page_ops->page_done)
-		page_ops->page_done(iter->inode, pos, ret, &folio->page);
-	folio_put(folio);
+	iomap_folio_done(iter, pos, ret, folio);
 
 	if (ret < len)
 		iomap_write_failed(iter->inode, pos + ret, len - ret);
-- 
2.38.1

