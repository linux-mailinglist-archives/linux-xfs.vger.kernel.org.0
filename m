Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64691DFDE2
	for <lists+linux-xfs@lfdr.de>; Sun, 24 May 2020 11:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgEXJSD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 24 May 2020 05:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbgEXJSD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 05:18:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46ABCC061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 24 May 2020 02:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=FcZ9yGKRSrgwZcOD7dsJ54Hr2tpPe+njIrv2rY3FM34=; b=RRKCilFguVzVd5yo/2NyJOlJqO
        /KLMTuNg4eK34XtfhfXeZiELchR2SQl5hnpvjELLqsA+n9DN1rlrVeWG7VoIDCvdzFxnRvEcUQrF6
        5xyKgcYgvxdvZqtQl6U1+K3+zTdZr9LYErQvqr3ekeN0nrS1563gCO8OmrJNA9tutff+Vvib3qO81
        tbe666KZzgxvcOBjjFjGzj4NJeSsgebOo03vvPYv7F6vJQB+9izm2mveiaYeIfMuDU9akDAxOMGqz
        kX4TIuAYcY3gbT9I3Projhb9qLkZSWfwesATDFRPMhViZQQ+y4yO0DwJWeGsqnJTfWuJzZwzT/rqW
        AA+3GWBw==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcmle-0004po-Qc
        for linux-xfs@vger.kernel.org; Sun, 24 May 2020 09:18:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/14] xfs: don't clear the "dinode core" in xfs_inode_alloc
Date:   Sun, 24 May 2020 11:17:44 +0200
Message-Id: <20200524091757.128995-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524091757.128995-1-hch@lst.de>
References: <20200524091757.128995-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The xfs_icdinode structure just contains a random mix of inode field,
which are all read from the on-disk inode and mostly not looked at
before reading the inode or initializing a new inode cluster.  The
only exceptions are the forkoff and blocks field, which are used
in sanity checks for freshly allocated inodes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d806d3bfa8936..edc7837bdd13d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -66,7 +66,8 @@ xfs_inode_alloc(
 	memset(&ip->i_df, 0, sizeof(ip->i_df));
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
-	memset(&ip->i_d, 0, sizeof(ip->i_d));
+	ip->i_d.di_nblocks = 0;
+	ip->i_d.di_forkoff = 0;
 	ip->i_sick = 0;
 	ip->i_checked = 0;
 	INIT_WORK(&ip->i_ioend_work, xfs_end_io);
-- 
2.26.2

