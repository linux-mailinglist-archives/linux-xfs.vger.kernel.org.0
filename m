Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 638F93647A
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 21:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfFETQY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 15:16:24 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59750 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFETQY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:16:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NEr9nc4bQERbXgigMhzkVaP8MWiFz6PiuJSK6+RNT9Q=; b=FiRlqhAVwYM5pNrCeH3Eu9eY3r
        jND1/nbf4OOuHVv9DO7BGrRAijS6xgEITGrfAKFmlyZ4yZqVLmS3sHD3l5AsyPEJymlSsCkQBXuU+
        HOP3cO2Rw7hwvodyV8jVuHYRZHZPeGY95KkZd/pJUkHHjpaR0hjjqnDbeoljkkorBz8AyB2QJhAiJ
        IwOe4Jnslj8I5cQ3U4tFmHuj4zsa9h2U80Fvwdx8vATMuH66zMU+I1ocZHoB2Q+0he/f5/sz/ltdb
        AduyAeNNythwu0qYHWQR56MNxzLhKfbhHuXN8NPe++v5YjdZrtSIy3ZOWyCmll3rTUypDX9TriC4o
        vhFJL1mQ==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbOa-0002FD-0P; Wed, 05 Jun 2019 19:16:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 22/24] xfs: properly type the b_log_item field in struct xfs_buf
Date:   Wed,  5 Jun 2019 21:15:09 +0200
Message-Id: <20190605191511.32695-23-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190605191511.32695-1-hch@lst.de>
References: <20190605191511.32695-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that the log code doesn't abuse this field any more we can
declare it as a struct xfs_buf_log_item pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index c1965c7e76bb..2abd2435d6aa 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -156,7 +156,7 @@ typedef struct xfs_buf {
 	struct work_struct	b_ioend_work;
 	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
 	struct completion	b_iowait;	/* queue for I/O waiters */
-	void			*b_log_item;
+	struct xfs_buf_log_item	*b_log_item;
 	struct list_head	b_li_list;	/* Log items list head */
 	struct xfs_trans	*b_transp;
 	struct page		**b_pages;	/* array of page pointers */
-- 
2.20.1

