Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8EF216F2F8
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Feb 2020 00:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbgBYXKO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Feb 2020 18:10:14 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53218 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728989AbgBYXKN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 18:10:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=4mPP/ff5n2vZ4KoU4urQYSn7o751n+nX5PbXfXPmoHg=; b=UzrX6hAm5l0+zxt/ME1Cl8mJdy
        LX4Ya95pTjN8wRhvyYO4Q6sUqT5GQAXGflta5dxPi4yFikS2jl7sB8OgvHyg+9Bd8yE7P7H6/Xz1P
        /L69xjXSly8AT33GEDV4WRVbrntJ3mITnVUNrxaJvGlIe1nxQcoDwkhM+HCIqYy/h5UXV1r/1aEsR
        /iyqXexA9iOwApVRPgbiKCPZ0fRDGqZ0CRsoECDMkyE5rza+hTfOopwGKWlxR+hOVMWPWFlo6vWZt
        GQE8RSfuFvvBXxkg3LNWMk+aoF2dBU5BN6nrW8AyaBZNIiPHP8gVYEswOQ+6YqtcH2f94o4FXvEes
        QqcKkXLw==;
Received: from [4.28.11.157] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6jLB-00035L-2q; Tue, 25 Feb 2020 23:10:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/30] xfs: reject invalid flags combinations in XFS_IOC_ATTRLIST_BY_HANDLE
Date:   Tue, 25 Feb 2020 15:09:43 -0800
Message-Id: <20200225231012.735245-2-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200225231012.735245-1-hch@lst.de>
References: <20200225231012.735245-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

While the flags field in the ABI and the on-disk format allows for
multiple namespace flags, an attribute can only exist in a single
namespace at a time. Hence asking to list attributes that exist
in multiple namespaces simultaneously is a logically invalid
request and will return no results. Reject this case early with
-EINVAL.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c   | 2 ++
 fs/xfs/xfs_ioctl32.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d42de92cb283..d974bf099d45 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -317,6 +317,8 @@ xfs_attrlist_by_handle(
 	 */
 	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
 		return -EINVAL;
+	if (al_hreq.flags == (ATTR_ROOT | ATTR_SECURE))
+		return -EINVAL;
 
 	dentry = xfs_handlereq_to_dentry(parfilp, &al_hreq.hreq);
 	if (IS_ERR(dentry))
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 769581a79c58..9705172e5410 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -375,6 +375,8 @@ xfs_compat_attrlist_by_handle(
 	 */
 	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
 		return -EINVAL;
+	if (al_hreq.flags == (ATTR_ROOT | ATTR_SECURE))
+		return -EINVAL;
 
 	dentry = xfs_compat_handlereq_to_dentry(parfilp, &al_hreq.hreq);
 	if (IS_ERR(dentry))
-- 
2.24.1

