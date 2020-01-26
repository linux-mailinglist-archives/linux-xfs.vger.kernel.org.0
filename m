Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93856149A6F
	for <lists+linux-xfs@lfdr.de>; Sun, 26 Jan 2020 12:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387418AbgAZLgg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 Jan 2020 06:36:36 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47278 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387416AbgAZLgg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 06:36:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gBZB3KppZ4QBoVpHGIOFPKet9GTGXtzkxdWnhAT7HVE=; b=i/hFZA+A8buWoYohKEBqceDKo
        qQU6eqQGas5hxF5/1/eC1ehDgFbNXc6DfdLno02JV+EgNFpc9YgYQoKZPV/d5h/d5Mc5BAh8668gh
        4kq+DXaLZJXhbV7Z5S/xVI/sLKUKGnmHvIIuffMLcuKsjtWIzb9fTCeTT9nIsrfo4gRoBeWpV3ooB
        D2YaW2d0GRY/dk7M/ahileRUSVqP3d8nCCM0uILFAZxfnLlvSo9sk7uGwUY0rB1nDfJ2tYkrPOWcO
        mDhny7H3goT2AFbnJleseljGH9RUyMHgdmsTRxXDIK2ZmPuOlOFBfrfMOa2XBy+AexDDa+rYH8PIn
        ADEIuQ7Gg==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivgDS-0008CB-Fw
        for linux-xfs@vger.kernel.org; Sun, 26 Jan 2020 11:36:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] xfsprogs: remove the SIZEOF_LONG substitution in platform_defs.h.in
Date:   Sun, 26 Jan 2020 12:35:40 +0100
Message-Id: <20200126113541.787884-5-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200126113541.787884-1-hch@lst.de>
References: <20200126113541.787884-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

BITS_PER_LONG is now only checked in C expressions, so we can simply
define it based on sizeof(long).

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/platform_defs.h.in | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index ff0a6a4e..36006cbf 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -26,9 +26,7 @@
 
 typedef struct filldir		filldir_t;
 
-/* long and pointer must be either 32 bit or 64 bit */
-#undef SIZEOF_LONG
-#define BITS_PER_LONG (SIZEOF_LONG * CHAR_BIT)
+#define BITS_PER_LONG (sizeof(long) * CHAR_BIT)
 
 /* Check whether to define umode_t ourselves. */
 #ifndef HAVE_UMODE_T
-- 
2.24.1

