Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB46E1CC2FB
	for <lists+linux-xfs@lfdr.de>; Sat,  9 May 2020 19:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgEIRBr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 9 May 2020 13:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgEIRBr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:01:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2DAC061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 10:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=CV88A/CVMy+mkvSW6qGzg2XsIUvBLjugWqMPYn3h4tA=; b=CeO7qwIA79IhAR+fWrOqx8yYJ+
        iJlys3RzLtGmSHL3W6b31X1DtyZPKxVsabYdGLj8J0rmJ1c+58FuKnvXik3KtBUYvmf9o4JZYt6gK
        0lP+/oh6QZ/k6z3PmUs6dVqxqvyNcGhz4+lzcxzbCYNHjWB97PXMNes9F/8JnKItKYvCSBGYVpDUC
        R3N4b/phOfkJluduCpRn38ZvfJh354LBh5XDeuPmLbXKA2ZOfOay6n6xma7pPYPhqq70Mu2MY1ffq
        Gk3ZDV8CldXeUpe8qrlWtz/wqG5ATEsoauXOVSnbm/k3RCDePgAU+BLWdD3y0po1gt0CxlxOSbrOv
        6L7Za0Ng==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSrD-00066O-5c; Sat, 09 May 2020 17:01:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 8/8] metadump: small cleanup for process_inode
Date:   Sat,  9 May 2020 19:01:25 +0200
Message-Id: <20200509170125.952508-9-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509170125.952508-1-hch@lst.de>
References: <20200509170125.952508-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Shorten a conditional to a single line.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/metadump.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 14e7eaa7..e5cb3aa5 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2415,8 +2415,7 @@ process_inode(
 	nametable_clear();
 
 	/* copy extended attributes if they exist and forkoff is valid */
-	if (success &&
-	    XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
+	if (success && XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
 		attr_data.remote_val_count = 0;
 		switch (dip->di_aformat) {
 			case XFS_DINODE_FMT_LOCAL:
-- 
2.26.2

