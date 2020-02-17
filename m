Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0966E16128A
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 14:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgBQNBK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 08:01:10 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58938 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbgBQNBK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:01:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=kmiRmgYMTpBnZ7HTNXpEROlLOubjsZwTUMxxBJGoTDY=; b=Gg8STPVhKL5kb78v3yP6UC7gDV
        wTEEk1JVlPFHDvVmw/uDRHd5Al8BskJ4H9Kq/iqx2IbVdpgHAnMy073dA4hpuS3PKaM4bh9JqkZGk
        XM7AI4bx71UJs46phA4aYm2SRmEmV9Jdv4/HPKQ9n5eqgc3KsW0MVZieLtAw1Hpun+m79sk45crBN
        /d3jcS4L6FlMAvjbmOhP2/T60x/clsc0XjDUodxBDC/XfQa5qv+VG3soOxKYYFD626mWcXYN/qFg0
        CYaKynHNqxdPgSv8u2RzuHcgTXxEQ4X5AdNO/QdrzWCR/OvRfhdERPIbNC3SX6vGc4cfvJ/XfLUPB
        m0j+o3tg==;
Received: from [88.128.92.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3g1N-0001yy-Tp; Mon, 17 Feb 2020 13:01:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 24/31] xfs: lift common checks into xfs_ioc_attr_list
Date:   Mon, 17 Feb 2020 13:59:50 +0100
Message-Id: <20200217125957.263434-25-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217125957.263434-1-hch@lst.de>
References: <20200217125957.263434-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Lift the flags and bufsize checks from both callers into the common code
in xfs_ioc_attr_list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c   | 23 ++++++++++++-----------
 fs/xfs/xfs_ioctl32.c | 11 -----------
 2 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0f9326bc055c..c8814808a551 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -360,6 +360,18 @@ xfs_ioc_attr_list(
 	struct xfs_attrlist		*alist;
 	int				error;
 
+	if (bufsize < sizeof(struct xfs_attrlist) ||
+	    bufsize > XFS_XATTR_LIST_MAX)
+		return -EINVAL;
+
+	/*
+	 * Reject flags, only allow namespaces.
+	 */
+	if (flags & ~(ATTR_ROOT | ATTR_SECURE))
+		return -EINVAL;
+	if (flags == (ATTR_ROOT | ATTR_SECURE))
+		return -EINVAL;
+
 	/*
 	 * Validate the cursor.
 	 */
@@ -414,17 +426,6 @@ xfs_attrlist_by_handle(
 		return -EPERM;
 	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
 		return -EFAULT;
-	if (al_hreq.buflen < sizeof(struct xfs_attrlist) ||
-	    al_hreq.buflen > XFS_XATTR_LIST_MAX)
-		return -EINVAL;
-
-	/*
-	 * Reject flags, only allow namespaces.
-	 */
-	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
-		return -EINVAL;
-	if (al_hreq.flags == (ATTR_ROOT | ATTR_SECURE))
-		return -EINVAL;
 
 	dentry = xfs_handlereq_to_dentry(parfilp, &al_hreq.hreq);
 	if (IS_ERR(dentry))
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 10ea0222954c..840d17951407 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -366,17 +366,6 @@ xfs_compat_attrlist_by_handle(
 	if (copy_from_user(&al_hreq, arg,
 			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
 		return -EFAULT;
-	if (al_hreq.buflen < sizeof(struct xfs_attrlist) ||
-	    al_hreq.buflen > XFS_XATTR_LIST_MAX)
-		return -EINVAL;
-
-	/*
-	 * Reject flags, only allow namespaces.
-	 */
-	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
-		return -EINVAL;
-	if (al_hreq.flags == (ATTR_ROOT | ATTR_SECURE))
-		return -EINVAL;
 
 	dentry = xfs_compat_handlereq_to_dentry(parfilp, &al_hreq.hreq);
 	if (IS_ERR(dentry))
-- 
2.24.1

