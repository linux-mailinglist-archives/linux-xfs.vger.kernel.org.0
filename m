Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCDEB149A6A
	for <lists+linux-xfs@lfdr.de>; Sun, 26 Jan 2020 12:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387394AbgAZLgE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 Jan 2020 06:36:04 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47256 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgAZLgE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 06:36:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=I+WRzRbkEmVcsGD0rCc/ZFXJqXvy5BASpe4e86R9DBQ=; b=T7FLOldFVUQ//d8kO8r6fTMqn
        kKkdhSthfYXn83YOanemRX2BOnQAWoIgl6udwlSy82XJRvKMYcj5febYNk0hW5F2Tb9bT+AIzlQrO
        qmKfj2Rzl1M3YX6xvf1v4qabl0y7dfox6RqgcAoYhDnjP81f23uj+ErOX38tcTHNP1fOjswIhhg21
        CDgMfe6LB4MUGabIcl/oBzl03cncB5FNVrlTptEaUxLUQeGkeJDV4b04vA0whKhv4JKbDFzKyeVKN
        0e2njtjBpqqoC9puY6xZK9QS7/oWbayYB2RBtdpjfXXCvrofC3xh7XxwIdyluWkB7UR8aoo7YnyBO
        O+bPOCzmw==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivgCw-0008A3-Hl
        for linux-xfs@vger.kernel.org; Sun, 26 Jan 2020 11:36:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfsprogs: remove the ENABLE_GETTEXT substitution in platform_defs.h.in
Date:   Sun, 26 Jan 2020 12:35:37 +0100
Message-Id: <20200126113541.787884-2-hch@lst.de>
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

ENABLE_GETTEXT is already defined on the command line if enabled, no
need to duplicate it in platform_defs.h.in.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/platform_defs.h.in | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index 1f7ceafb..6cc56e31 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -36,8 +36,6 @@ typedef struct filldir		filldir_t;
 typedef unsigned short umode_t;
 #endif
 
-/* Define if you want gettext (I18N) support */
-#undef ENABLE_GETTEXT
 #ifdef ENABLE_GETTEXT
 # include <libintl.h>
 # define _(x)                   gettext(x)
-- 
2.24.1

