Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09740720BDE
	for <lists+linux-xfs@lfdr.de>; Sat,  3 Jun 2023 00:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbjFBWY4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Jun 2023 18:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbjFBWYz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2023 18:24:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271401BC;
        Fri,  2 Jun 2023 15:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Zh3vwPttBvras0W9xMfJik9g+4v5Ww/hZDI6n4H8e78=; b=pM5IUzBsEY/vQ/Nwzm+o5XiibG
        IOpgqcvsClLvAZJelssepb3n2OTF2AW+HrocgmfIPiDeyzGorPuH3Jr+56+KFiXs/OplCEkrjlYHd
        9ZDQjtG9cG6C4B+/D77rKvCcXi7gZk/dSBWUn+Y5mBtsYyrX3qH1a3Z88bDDf4ntLVqrSnXGUQtly
        faF3JtRTar1aY9Ay2gT32DS+n8JHW0TybRVImNbzp1jSzm383SwBZ/Lz9ieycACTOXRtF3EqTci6s
        32ZNZvVTVQWuW5BMR9dua0bAP8NaH6Tz0TCA2wAtLw2k8adz7h9+wQO1QbgfvoGSTliA1tMFmO5Rc
        2lD87zRg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1q5DCQ-009aPK-Pp; Fri, 02 Jun 2023 22:24:46 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-xfs@vger.kernel.org, Wang Yugui <wangyugui@e16-tech.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v2 2/7] doc: Correct the description of ->release_folio
Date:   Fri,  2 Jun 2023 23:24:39 +0100
Message-Id: <20230602222445.2284892-3-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230602222445.2284892-1-willy@infradead.org>
References: <20230602222445.2284892-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The filesystem ->release_folio method is called under more circumstances
now than when the documentation was written.  The second sentence
describing the interpretation of the return value is the wrong polarity
(false indicates failure, not success).  And the third sentence is also
wrong (the kernel calls try_to_free_buffers() instead).

So replace the entire paragraph with a detailed description of what the
state of the folio may be, the meaning of the gfp parameter, why the
method is being called and what the filesystem is expected to do.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 Documentation/filesystems/locking.rst | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index aa1a233b0fa8..91dc9d5bc602 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -374,10 +374,16 @@ invalidate_lock before invalidating page cache in truncate / hole punch
 path (and thus calling into ->invalidate_folio) to block races between page
 cache invalidation and page cache filling functions (fault, read, ...).
 
-->release_folio() is called when the kernel is about to try to drop the
-buffers from the folio in preparation for freeing it.  It returns false to
-indicate that the buffers are (or may be) freeable.  If ->release_folio is
-NULL, the kernel assumes that the fs has no private interest in the buffers.
+->release_folio() is called when the MM wants to make a change to the
+folio that would invalidate the filesystem's private data.  For example,
+it may be about to be removed from the address_space or split.  The folio
+is locked and not under writeback.  It may be dirty.  The gfp parameter is
+not usually used for allocation, but rather to indicate what the filesystem
+may do to attempt to free the private data.  The filesystem may
+return false to indicate that the folio's private data cannot be freed.
+If it returns true, it should have already removed the private data from
+the folio.  If a filesystem does not provide a ->release_folio method,
+the kernel will call try_to_free_buffers().
 
 ->free_folio() is called when the kernel has dropped the folio
 from the page cache.
-- 
2.39.2

