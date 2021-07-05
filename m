Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0693BC284
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Jul 2021 20:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhGESVS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 5 Jul 2021 14:21:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38104 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229743AbhGESVR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jul 2021 14:21:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625509120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OfnbDKVQTNnP9yn/zxhP8slR9Z1sonaiM3CMMk0IhL8=;
        b=AblZZiLp2E3J/BpTzGng8q7M/WrCo7s17nGL21pfR+MCGawrrnFodofcSTvYR4Jg4D7H8Q
        UT1kXqTWD3lkacI871dnp8KY+SWx3TTqP+y+PazisyoHZte4uAv3NoRk9aSMpfH8gEWfAK
        lJSaHs/4RoqB/cwiheSRkpIQ0C5lFgA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-4B9j1xK7N46yOlj6JtQuVw-1; Mon, 05 Jul 2021 14:18:39 -0400
X-MC-Unique: 4B9j1xK7N46yOlj6JtQuVw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9FE8362F9;
        Mon,  5 Jul 2021 18:18:37 +0000 (UTC)
Received: from max.com (unknown [10.40.193.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C95B2EB18;
        Mon,  5 Jul 2021 18:18:33 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J . Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 2/2] iomap: Permit pages without an iop to enter writeback
Date:   Mon,  5 Jul 2021 20:18:24 +0200
Message-Id: <20210705181824.2174165-3-agruenba@redhat.com>
In-Reply-To: <20210705181824.2174165-1-agruenba@redhat.com>
References: <20210705181824.2174165-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Create an iop in the writeback path if one doesn't exist.  This allows
us to avoid creating the iop in some cases.  The only current case we
do that for is pages with inline data, but it can be extended to pages
which are entirely within an extent.  It also allows for an iop to be
removed from pages in the future (eg page split).

Co-developed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap/buffered-io.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 03537ecb2a94..6330dabc451e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1336,14 +1336,13 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 		struct writeback_control *wbc, struct inode *inode,
 		struct page *page, u64 end_offset)
 {
-	struct iomap_page *iop = to_iomap_page(page);
+	struct iomap_page *iop = iomap_page_create(inode, page);
 	struct iomap_ioend *ioend, *next;
 	unsigned len = i_blocksize(inode);
 	u64 file_offset; /* file offset of page */
 	int error = 0, count = 0, i;
 	LIST_HEAD(submit_list);
 
-	WARN_ON_ONCE(i_blocks_per_page(inode, page) > 1 && !iop);
 	WARN_ON_ONCE(iop && atomic_read(&iop->write_bytes_pending) != 0);
 
 	/*
-- 
2.26.3

