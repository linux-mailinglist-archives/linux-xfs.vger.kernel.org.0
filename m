Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404E83D1F1E
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jul 2021 09:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhGVG7D (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 22 Jul 2021 02:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbhGVG7B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 02:59:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C25C06179F;
        Thu, 22 Jul 2021 00:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=XHf7NylaNHEeAjC+MhKJdPPu0IAZXpO3NzEg4UjJV3s=; b=qhpvj8fbIXrEaq7rccoU5lrGRE
        XGVteld3Vd8XycTb63Cnu7RpB535nm9RlePfkGgSM69TTVSWyThuca2L6Peth1LuzwP4WjkslzxmK
        2dNzG68JaCmvn1M+ENzdYsQ0yGUGYiT54F92DJpy3JfIfmP5BlPx/NeYNKREJUZpqLSlxRk4o43Rz
        HlnLQ0YTY08YH4em/sW2XoVLVBQY04tb3OfyaUag1s+e+97J8lMOr4jv86g5BDtOUp95sQm3RhWiN
        GbxJKJrT6vdMw7rXFx0h49PlPUb09mO5a/qkUOkWR2jj2srKznBSSoJWsIlZpswGqLQwtLPIooTUj
        QHwFk5Tg==;
Received: from [2001:4bb8:193:7660:643c:9899:473:314a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6TIW-00A0Sz-W1; Thu, 22 Jul 2021 07:39:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 2/7] xfs/007: unmount after disabling quota
Date:   Thu, 22 Jul 2021 09:38:27 +0200
Message-Id: <20210722073832.976547-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210722073832.976547-1-hch@lst.de>
References: <20210722073832.976547-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

With the pending patches to remove support for disabling quota
accounting on a mounted file system we need to unmount the
file system first before removing the quota files.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/007 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/xfs/007 b/tests/xfs/007
index 09268e8c..d1946524 100755
--- a/tests/xfs/007
+++ b/tests/xfs/007
@@ -41,6 +41,9 @@ do_test()
 	_qmount
 	echo "*** turn off $off_opts quotas"
 	xfs_quota -x -c "off -$off_opts" $SCRATCH_MNT
+	_scratch_unmount
+	_qmount_option ""
+	_scratch_mount
 	xfs_quota -x -c "remove -$off_opts" $SCRATCH_MNT
 	echo "*** umount"
 	_scratch_unmount
-- 
2.30.2

