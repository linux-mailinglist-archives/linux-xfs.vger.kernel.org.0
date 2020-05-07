Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E3D1C8A6A
	for <lists+linux-xfs@lfdr.de>; Thu,  7 May 2020 14:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgEGMTs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 May 2020 08:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGMTs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:19:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE9FC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Z0bfVinOT/kyvGlP/fmcipLweW2YysiCpBVrZCigk6U=; b=osL+ko+PPKuzjS5vDuaoGEBeOx
        hnpYUHVorid7kDRrl4tQ1sgA9OW5Lwo8HlOKOC/ZX59QbR5SJdZIUvcabQwSe7HFE76oD3r2Oyqa+
        cesZyEeHLHYlCp1t9z2OVhDvDjbdHKx6Nn6QpCUsohqJXqYQxuugk/UZogpJmFNbDMmcWxHUd2UZz
        WJALyAlYz7SOdTyTMdmjq31zSaQ8aXRXTT3uAH6fV4chePXHzaQycqhZDFtATZTAXoSlQDwxiWEKa
        YwlX9chbTu92iAnnKd0CmmDsBYFSexaq+obMaaKHUtQ9UACfag9Ef5LU30RRMniWP5GLj4toDmueJ
        MxE85rkw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfVD-0005CM-T2; Thu, 07 May 2020 12:19:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 22/58] xfs: rename xfs_attr_list_int to xfs_attr_list
Date:   Thu,  7 May 2020 14:18:15 +0200
Message-Id: <20200507121851.304002-23-hch@lst.de>
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

Source kernel commit: 17e1dd83ea21dc7aaf44590e5947338351b99bd0

The version taking the context structure is the main interface to list
attributes, so drop the _int postfix.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 0e3c213f..8d42f578 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -102,8 +102,8 @@ struct xfs_attr_list_context {
  * Overall external interface routines.
  */
 int xfs_attr_inactive(struct xfs_inode *dp);
-int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
-int xfs_attr_list_int(struct xfs_attr_list_context *);
+int xfs_attr_list_ilocked(struct xfs_attr_list_context *);
+int xfs_attr_list(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
-- 
2.26.2

