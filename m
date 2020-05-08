Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BCB1CA407
	for <lists+linux-xfs@lfdr.de>; Fri,  8 May 2020 08:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgEHGek (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 May 2020 02:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727094AbgEHGek (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 02:34:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175F5C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 23:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=nji3pXWqnlhESgZSJEYXFwp/k6BOP/xGDPyxKEUFD88=; b=nwe096Si6sYjIuHpIwTXNnqpvK
        RKsXKMrK2fQ6+0xo6BfLYuzxCPI3ZTHvTV2hU0ELH+T5vrG2DA5koPu8Ymxw/ts7ni6p12mEqflMT
        q2SSBb+NTYsTzZVfFLHz7mrcH/ErIWk+Z8Kca2FqQqckPFwqjYw3USCFVvbIFDVHQ8pS15E1nm4mH
        aJCVGOWcCpe5xoxVExWSAtgVF/UM2kF3b91SGQOnk9hnO9+DnQnf3FcxYx2akO8CcZDwH62VR8MdS
        uexefZB5kANa0hCij9R3y/N0VpO5RH5JRIeGm9tSpuEXMS3Lc//jxb+bXJ2r2a7TF75x1+Omq3jov
        cOgMFBGw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWwal-0002v3-JF; Fri, 08 May 2020 06:34:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH 06/12] xfs: don't reset i_delayed_blks in xfs_iread
Date:   Fri,  8 May 2020 08:34:17 +0200
Message-Id: <20200508063423.482370-7-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508063423.482370-1-hch@lst.de>
References: <20200508063423.482370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

i_delayed_blks is set to 0 in xfs_inode_alloc and can't have anything
assigned to it until the inode is visible to the VFS.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 3aac22e892985..329534eebbdcc 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -663,8 +663,6 @@ xfs_iread(
 	if (error)
 		goto out_brelse;
 
-	ip->i_delayed_blks = 0;
-
 	/*
 	 * Mark the buffer containing the inode as something to keep
 	 * around for a while.  This helps to keep recently accessed
-- 
2.26.2

