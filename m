Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B141149A6B
	for <lists+linux-xfs@lfdr.de>; Sun, 26 Jan 2020 12:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbgAZLgP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 Jan 2020 06:36:15 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47262 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgAZLgP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 06:36:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Jwcm3EybhJoixusZ+7B7Ht2NyrKET5NCZJKhVTHy2yE=; b=pfUSDFdE+Itc/U+M7e8G7H9rI
        4MaLI5iJYkgXugoNBkImHLrwcKFytuedf3AJJx35Fear5x08Bg1nxMk2LQlyqpyh/Xk2gq+FFLpQs
        hhigDlmFinr0ZOmNDNOfPmp943Nc/ClHglqo71SSNxx0ugaKpaDPLiio3mrQ0eiUCuj4lvL2gkHRt
        FRPMbpm3PiwSBgHyFSPffGcjAYXulOxChVJ/YOakT/ltL/9gXnUyZ+k4YO7+Y8K0uMUDNR5ib2XSF
        ep8HmD0Ml7bWCjPv/xiIxTvNNYr9QRjfNADcXTz4PhRm6N31TEH1+QcRtaAp+rX4wWdra+nrR1ljL
        T0S7+FG4Q==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivgD7-0008AV-8L
        for linux-xfs@vger.kernel.org; Sun, 26 Jan 2020 11:36:14 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] xfsprogs: remove the SIZEOF_CHAR_P substitution in platform_defs.h.in
Date:   Sun, 26 Jan 2020 12:35:38 +0100
Message-Id: <20200126113541.787884-3-hch@lst.de>
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

SIZEOF_CHAR_P is not used anywhere in the code, so remove the reference
to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/platform_defs.h.in | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 6cc56e31..ff0a6a4e 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -28,7 +28,6 @@ typedef struct filldir		filldir_t;
 
 /* long and pointer must be either 32 bit or 64 bit */
 #undef SIZEOF_LONG
-#undef SIZEOF_CHAR_P
 #define BITS_PER_LONG (SIZEOF_LONG * CHAR_BIT)
 
 /* Check whether to define umode_t ourselves. */
-- 
2.24.1

