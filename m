Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B831CC790
	for <lists+linux-xfs@lfdr.de>; Sun, 10 May 2020 09:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgEJHYK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 10 May 2020 03:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgEJHYK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 May 2020 03:24:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56636C061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 10 May 2020 00:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=tyLRRqRNC2TbQZcQqfZ5FE/KNKdtXcxxH3ADPYeqkGw=; b=jSkqyDsbMMWbPoQ8KjWkDU8UYW
        UcRfphyk9AFDQMufvqLu3QCRcwX1qLwVhcs9JHJOHc4tMNtnKWi0EWO5LpIulsCD658RfXQ1nKFh4
        dJHPiXKSIw+02PbT6fCwyakAhWgqdOtKn0Ay5WAMW6Y8u97UPdwwfZs4l4+8tSrnssRqxensL+fbl
        Elf1ITXC8YLbLjk3v8l9YwaPkw9fhepEPvV9MuZ6xBkDs/HeyOOzwgdZJlZ4gTtQGGiZqjkfojV/H
        KrFCYmBnV+kAfpVuSQhx7fcWKeebF+0aJC6oFYvSfwqMqruf2ZSexqW5A0boUfYnA8e6CzBCHoMdT
        eQdOQ/kw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXgJl-0004v4-QR
        for linux-xfs@vger.kernel.org; Sun, 10 May 2020 07:24:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/6] xfs: use XFS_IFORK_BOFF xchk_bmap_check_rmaps
Date:   Sun, 10 May 2020 09:23:59 +0200
Message-Id: <20200510072404.986627-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200510072404.986627-1-hch@lst.de>
References: <20200510072404.986627-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_IFORK_Q is to be used in boolean context, not for a size.  This
doesn't make a difference in practice as size is only checked for
0, but this keeps the logic sane.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index add8598eacd5d..283424d6d2bb6 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -591,7 +591,7 @@ xchk_bmap_check_rmaps(
 		size = i_size_read(VFS_I(sc->ip));
 		break;
 	case XFS_ATTR_FORK:
-		size = XFS_IFORK_Q(sc->ip);
+		size = XFS_IFORK_BOFF(sc->ip);
 		break;
 	default:
 		size = 0;
-- 
2.26.2

