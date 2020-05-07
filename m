Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F981C8A7C
	for <lists+linux-xfs@lfdr.de>; Thu,  7 May 2020 14:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgEGMUX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 May 2020 08:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726533AbgEGMUW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBA0C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=eKA8Z5bT/lpV4TG+nD2tYfz1pER6XXLhZv1LemCgLi0=; b=Yi7vvfn7Dr+j52R7BQgXn+1hAF
        P/jLqRG3ZVNg/A+Yvues0KZpcY7ydsVC0GqWYCeOEeF3k884hslD7yWOyKDwZ/SKSGpLME12fdQbP
        +orupiOt/86F7AjOiFBiJK2yOfy1PD25ZE7DplSEKQHT/N4I0OKr3m09oWI9QHY6J/0v0xVb/q9+0
        aNfDnLP6JN414uHDZidNSV6ydJlWwM12qER/kIII9Kbl1X5013KG1l3QmEj9Jw/C0mKrWyMoZIsCf
        FPBmQgfzh0VHOqrRsY7dTS0fw4FC3LtCm66a4BKZD0SRj4H6GDCAdyB0jmBq6u7QtPfhC6h8jl0B8
        VCdvQ03Q==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfVl-0007f9-Su; Thu, 07 May 2020 12:20:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 36/58] xfs: check owner of dir3 free blocks
Date:   Thu,  7 May 2020 14:18:29 +0200
Message-Id: <20200507121851.304002-37-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Source kernel commit: 6fb5aac73310d030be13eb3481fdb7c7cc7c0f00

Check the owner field of dir3 free block headers and reject the metadata
if there's something wrong with it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_dir2_node.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 48c06da2..b2026da5 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -191,6 +191,8 @@ xfs_dir3_free_header_check(
 			return __this_address;
 		if (be32_to_cpu(hdr3->nvalid) < be32_to_cpu(hdr3->nused))
 			return __this_address;
+		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
+			return __this_address;
 	} else {
 		struct xfs_dir2_free_hdr *hdr = bp->b_addr;
 
-- 
2.26.2

