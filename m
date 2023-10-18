Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A1E7CE6DB
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Oct 2023 20:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjJRSiS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Oct 2023 14:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjJRSiR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2023 14:38:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CE7114
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2023 11:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697654246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Q/0ep7eS2yn1G5ni+CIWne5Bs5Cck5auB+wlCPDOEU=;
        b=Qj8VJu3HvfA16RcrXZko7o4w6DTXO9Z5/X6SmkyObYuHZtfPKV0AnXuUo+87diEYIOlkK/
        T92R9dmAFQ8cWrE2WpeJ4m1vMazZ1jtuYRUtL5Pg8XWybCAA28CDmtVQSSKyzMISgu/15e
        Jwu34xZ9Oyt+pdBcW4dDSwRh6mT3TOg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-Mu_eMp-RO9OeB8AD4XfzsA-1; Wed, 18 Oct 2023 14:37:18 -0400
X-MC-Unique: Mu_eMp-RO9OeB8AD4XfzsA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 617943C0C113;
        Wed, 18 Oct 2023 18:37:17 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.45.225.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53C8E40C6F7D;
        Wed, 18 Oct 2023 18:37:15 +0000 (UTC)
From:   Jan Stancek <jstancek@redhat.com>
To:     djwong@kernel.org, willy@infradead.org, hch@lst.de,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        jstancek@redhat.com
Subject: [PATCH v2] iomap: fix short copy in iomap_write_iter()
Date:   Wed, 18 Oct 2023 20:32:32 +0200
Message-Id: <e1cb4f8981f8c6e7e0384e95faf1911d9937e979.1697647960.git.jstancek@redhat.com>
In-Reply-To: <8762e91a210f4cc5713fce05fe5906c18513bd0a.1697617238.git.jstancek@redhat.com>
References: <8762e91a210f4cc5713fce05fe5906c18513bd0a.1697617238.git.jstancek@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Starting with commit 5d8edfb900d5 ("iomap: Copy larger chunks from
userspace"), iomap_write_iter() can get into endless loop. This can
be reproduced with LTP writev07 which uses partially valid iovecs:
        struct iovec wr_iovec[] = {
                { buffer, 64 },
                { bad_addr, 64 },
                { buffer + 64, 64 },
                { buffer + 64 * 2, 64 },
        };

commit bc1bb416bbb9 ("generic_perform_write()/iomap_write_actor():
saner logics for short copy") previously introduced the logic, which
made short copy retry in next iteration with amount of "bytes" it
managed to copy:

                if (unlikely(status == 0)) {
                        /*
                         * A short copy made iomap_write_end() reject the
                         * thing entirely.  Might be memory poisoning
                         * halfway through, might be a race with munmap,
                         * might be severe memory pressure.
                         */
                        if (copied)
                                bytes = copied;

However, since 5d8edfb900d5 "bytes" is no longer carried into next
iteration, because it is now always initialized at the beginning of
the loop. And for iov_iter_count < PAGE_SIZE, "bytes" ends up with
same value as previous iteration, making the loop retry same copy
over and over, which leads to writev07 testcase hanging.

Make next iteration retry with amount of bytes we managed to copy.

Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Signed-off-by: Jan Stancek <jstancek@redhat.com>
---
Changes in v2:
- use goto instead of new variable (suggested by Christoph Hellwig)

 fs/iomap/buffered-io.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 5db54ca29a35..2bc0aa23fde3 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -881,8 +881,10 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 		size_t bytes;		/* Bytes to write to folio */
 		size_t copied;		/* Bytes copied from user */
 
+		bytes = iov_iter_count(i);
+retry:
 		offset = pos & (chunk - 1);
-		bytes = min(chunk - offset, iov_iter_count(i));
+		bytes = min(chunk - offset, bytes);
 		status = balance_dirty_pages_ratelimited_flags(mapping,
 							       bdp_flags);
 		if (unlikely(status))
@@ -933,10 +935,12 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 			 * halfway through, might be a race with munmap,
 			 * might be severe memory pressure.
 			 */
-			if (copied)
-				bytes = copied;
 			if (chunk > PAGE_SIZE)
 				chunk /= 2;
+			if (copied) {
+				bytes = copied;
+				goto retry;
+			}
 		} else {
 			pos += status;
 			written += status;
-- 
2.31.1

