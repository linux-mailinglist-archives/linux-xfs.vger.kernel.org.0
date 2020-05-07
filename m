Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5491C9DA9
	for <lists+linux-xfs@lfdr.de>; Thu,  7 May 2020 23:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgEGVos (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 May 2020 17:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgEGVo0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 17:44:26 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F92C05BD0B
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 14:44:24 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id n17so5875577ejh.7
        for <linux-xfs@vger.kernel.org>; Thu, 07 May 2020 14:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W6k+nr3o33Kw7lh1iadEOaXBpO+mApJUEyA7nm+lCVE=;
        b=FZ6fTGY3spuMmoNHovS2scKLAy45oECWLSGK4J8REO6bw+4MW2ufoPSSSNz4nTBrTA
         uyubEJPaMyOadZhoVN6d8x5b6qP9FkAjC5BD3T9F4XzBwEM1H3m07rKkz/xDgE2jdqEd
         AdgyKlLCvCmG9+hMQUHlzORPrlkfhvL4lq26Z99gjOTMmSTjirVXLYol/xQD0R+jCnAQ
         lt5rSDUMrEw2zSDAUP7bn4kKRw+dTD8510FerIpIoLJXGNEopsr8Mo2A9Fp6zFJllyyZ
         2XainexmOGHw1py11wgLiDhzo6t7UCj7LAKSxLHZ2MLOs4ZoeMFE7eGI/nf/D6J/Gwko
         vFLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=W6k+nr3o33Kw7lh1iadEOaXBpO+mApJUEyA7nm+lCVE=;
        b=Gdm5PrL68UI+9fRTO6VHbdUCTSLTew8J7pBPJYjiqKpNds2Li9KYQwabHNSb8SRvob
         FSU04+KPAAjSKdXrQRpk+2sal7TPVBHNtQ0wUSa1tVP+82x9tZ/1+Mn0y9qiBE4Mkf9u
         rAQwKgLId1VgHScIo80fJrHvkmrE5MwWmJLAJfQ8BxKmwBDwdUqH5bsHdUQaSUnxSmK5
         /BLbIh4f4e1CvCFl5WkN2oWz1nL4b01iTq2QdrMeIe6aKXhZVfoiQWUhoD10pNohS96s
         FWsKN4qKfyoAkR3Elh3cEfvnJFFHJ/qV8HkrJnZerGk2l+i4PFEySUGPkemlGbIuB2T8
         wtsg==
X-Gm-Message-State: AGi0PubtT8fRYukw25X+UuwvoHQrEhXAIj62Z1DuiUwOFqOl1Yx4Fh1x
        6SMDdoJdw0CXnH+mknm475zYhg==
X-Google-Smtp-Source: APiQypIckrilpe/P2KXWHHZo9iDvOLXPRDY7mDU2aaijzmxr5jlijOIHu1HNfh0s2byb0fH7SXD01g==
X-Received: by 2002:a17:906:4714:: with SMTP id y20mr14594259ejq.5.1588887863537;
        Thu, 07 May 2020 14:44:23 -0700 (PDT)
Received: from ls00508.pb.local ([2001:1438:4010:2540:a1ee:a39a:b93a:c084])
        by smtp.gmail.com with ESMTPSA id k3sm613530edi.60.2020.05.07.14.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 14:44:22 -0700 (PDT)
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     david@fromorbit.com, hch@infradead.org, willy@infradead.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: [RFC PATCH V3 06/10] iomap: use attach/detach_page_private
Date:   Thu,  7 May 2020 23:43:56 +0200
Message-Id: <20200507214400.15785-7-guoqing.jiang@cloud.ionos.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200507214400.15785-1-guoqing.jiang@cloud.ionos.com>
References: <20200507214400.15785-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since the new pair function is introduced, we can call them to clean the
code in iomap.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
---
RFC V2 -> RFC V3
1. rename clear_page_private to detach_page_private.

RFC -> RFC V2
1. change the name of new functions to attach/clear_page_private.
2. call attach_page_private(newpage, clear_page_private(page)) to
   cleanup code further as suggested by Matthew Wilcox.
3. don't return attach_page_private in iomap_page_create per the
   comment from Christoph Hellwig.

 fs/iomap/buffered-io.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 89e21961d1ad..e3031007b4ae 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -59,24 +59,19 @@ iomap_page_create(struct inode *inode, struct page *page)
 	 * migrate_page_move_mapping() assumes that pages with private data have
 	 * their count elevated by 1.
 	 */
-	get_page(page);
-	set_page_private(page, (unsigned long)iop);
-	SetPagePrivate(page);
+	attach_page_private(page, iop);
 	return iop;
 }
 
 static void
 iomap_page_release(struct page *page)
 {
-	struct iomap_page *iop = to_iomap_page(page);
+	struct iomap_page *iop = detach_page_private(page);
 
 	if (!iop)
 		return;
 	WARN_ON_ONCE(atomic_read(&iop->read_count));
 	WARN_ON_ONCE(atomic_read(&iop->write_count));
-	ClearPagePrivate(page);
-	set_page_private(page, 0);
-	put_page(page);
 	kfree(iop);
 }
 
@@ -554,14 +549,8 @@ iomap_migrate_page(struct address_space *mapping, struct page *newpage,
 	if (ret != MIGRATEPAGE_SUCCESS)
 		return ret;
 
-	if (page_has_private(page)) {
-		ClearPagePrivate(page);
-		get_page(newpage);
-		set_page_private(newpage, page_private(page));
-		set_page_private(page, 0);
-		put_page(page);
-		SetPagePrivate(newpage);
-	}
+	if (page_has_private(page))
+		attach_page_private(newpage, detach_page_private(page));
 
 	if (mode != MIGRATE_SYNC_NO_COPY)
 		migrate_page_copy(newpage, page);
-- 
2.17.1

