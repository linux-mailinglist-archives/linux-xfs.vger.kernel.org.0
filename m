Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A463385B4
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Mar 2021 07:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhCLGUS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 12 Mar 2021 01:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhCLGTu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Mar 2021 01:19:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05266C061574
        for <linux-xfs@vger.kernel.org>; Thu, 11 Mar 2021 22:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=D+9LJmJP/AFZ+OMdtH0VGpXwRNxwIOw4p+Xjyh+j7VE=; b=UCmfE2Ps6/4zBW8iQUL3c/+Mog
        JmRK5zsk82uqC2GUHw7NXTsEVHhcqqGdMmEtK75Wk9c/cgefvwU3Lja5vqS+Pwpu8xZCdJWh+wNhC
        RQMKjHBhSHEEKsiAzy7/klOdyvrMGcrf4bYuQ9YJHxU3ROnm865V+MlEoeoPlT2fS+ih92wcBw6D+
        cwtTw9aJ7r5wZvqIdVNYrnzfFEFve05ovb6jRMl6owT4oNcZD8+Y/KlmNqTCe5D5l9zW+Yfg9vU4l
        2zBbjRl3YVjqdJTdiwBetDlKlTGa4q10Grxqyc/S19I71VVMq9qM+ZUEVzLKHTZ9p/BpDL1oDkcGr
        CKO3CPKg==;
Received: from [2001:4bb8:180:9884:c70:4a89:bc61:3] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lKb9C-009kjR-Jz
        for linux-xfs@vger.kernel.org; Fri, 12 Mar 2021 06:19:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: also reject BULKSTAT_SINGLE in a mount user namespace
Date:   Fri, 12 Mar 2021 07:19:41 +0100
Message-Id: <20210312061941.1362951-1-hch@lst.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

BULKSTAT_SINGLE exposed the ondisk uids/gids just like bulkstat, and can
be called on any inode, including ones not visible in the current mount.

Fixes: f736d93d76d3 ("xfs: support idmapped mounts")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_itable.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index ca310a125d1e14..3498b97fb06d31 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -168,6 +168,12 @@ xfs_bulkstat_one(
 	};
 	int			error;
 
+	if (breq->mnt_userns != &init_user_ns) {
+		xfs_warn_ratelimited(breq->mp,
+			"bulkstat not supported inside of idmapped mounts.");
+		return -EINVAL;
+	}
+
 	ASSERT(breq->icount == 1);
 
 	bc.buf = kmem_zalloc(sizeof(struct xfs_bulkstat),
-- 
2.30.1

