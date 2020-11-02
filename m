Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F4A2A2767
	for <lists+linux-xfs@lfdr.de>; Mon,  2 Nov 2020 10:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgKBJvD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 2 Nov 2020 04:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbgKBJvC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 04:51:02 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1E0C0617A6
        for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2020 01:51:02 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id b12so6570814plr.4
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 01:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XmdKpghfLeanbz+IwL0BYKqdxi1X0QN/uaPdOmARGkM=;
        b=SzKFKBu1MJrLXgFAULn2BZrxah/HtiWyzrSD0PNGPomJahbX6Rn9+XR/RpYzf5s7sO
         +JOTNJO4gP/ZllBYPKBPhqdMUgZ0Z1DZ8Oow08YRJWQjDMhU6lxLu2xgkxJC+1azPoOr
         RW47uWNyqCgDx4+vM2ADzlQFlQynKKKh4fS8OIEiMeyH48pYfMzPX2THqHBOgeqjFHJ/
         9UheENCrUK4a7B2wSF/KB6zwUns/i9BH1GOB4rzodtY0mfU11BtalQmEG/Sp+E4XUeBB
         LOVi3ewJ62cZmPxy2d1/2dVZJqXKvIGD9M+zyVvbePiXpqEIMyTb9+Rl62LP59UhYi3D
         3uUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XmdKpghfLeanbz+IwL0BYKqdxi1X0QN/uaPdOmARGkM=;
        b=stqmeuJZSUPv1yJFK884xuP0kfkhLe0VhMKjKOuKhr47uIKbFVvEFvFrVrLkf0U1YP
         Td6aGz0FyngBewKjHD1cSkH0gVzzYCYQODfsDyuD6dpJH1RFaW1Rxgvy5igj8M7zR2G2
         5cV+EzhANmhnkRvCdnJy5ipOFDYeNo5boVarXOgTGNSwajJSLtjmdVFwKwEplU1RCELQ
         9goPl8od/OBSCmhOsxxumepYTTlQf0FGS4wbHAKiLH8qn7HHitOrsPdalr1+ftcxoUEP
         nvDc2S57SXnJ2UB8yKksMHrc3oiJvlsfV0TGuVOMgMYbMDTfvD9ZOxNqkUq5exrJWLJN
         eLtw==
X-Gm-Message-State: AOAM530mKrdm5vrttHvjpx7Oh8pQZMY09AchmJmSrqAJzRP5X2/Mgv1+
        3dO4nXQ18+eUHihV2yAXPLoy3K0Quzs=
X-Google-Smtp-Source: ABdhPJxsYLJmzfzrpZnO/R4DoiaqWx6RNPP3b6mxAwEJYphXGSSQLcokzJg7dPVPctYMp74ZoJolOw==
X-Received: by 2002:a17:902:758d:b029:d6:57ea:a434 with SMTP id j13-20020a170902758db02900d657eaa434mr19469844pll.83.1604310662107;
        Mon, 02 Nov 2020 01:51:02 -0800 (PST)
Received: from localhost.localdomain ([122.179.32.56])
        by smtp.gmail.com with ESMTPSA id x15sm467062pjh.21.2020.11.02.01.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 01:51:01 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V9 01/14] xfs: Add helper for checking per-inode extent count overflow
Date:   Mon,  2 Nov 2020 15:20:35 +0530
Message-Id: <20201102095048.100956-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102095048.100956-1-chandanrlinux@gmail.com>
References: <20201102095048.100956-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS does not check for possible overflow of per-inode extent counter
fields when adding extents to either data or attr fork.

For e.g.
1. Insert 5 million xattrs (each having a value size of 255 bytes) and
   then delete 50% of them in an alternating manner.

2. On a 4k block sized XFS filesystem instance, the above causes 98511
   extents to be created in the attr fork of the inode.

   xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131

3. The incore inode fork extent counter is a signed 32-bit
   quantity. However the on-disk extent counter is an unsigned 16-bit
   quantity and hence cannot hold 98511 extents.

4. The following incorrect value is stored in the attr extent counter,
   # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
   core.naextents = -32561

This commit adds a new helper function (i.e.
xfs_iext_count_may_overflow()) to check for overflow of the per-inode
data and xattr extent counters. Future patches will use this function to
make sure that an FS operation won't cause the extent counter to
overflow.

Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 23 +++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 7575de5cecb1..8d48716547e5 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -23,6 +23,7 @@
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
 #include "xfs_attr_leaf.h"
+#include "xfs_types.h"
 
 kmem_zone_t *xfs_ifork_zone;
 
@@ -728,3 +729,25 @@ xfs_ifork_verify_local_attr(
 
 	return 0;
 }
+
+int
+xfs_iext_count_may_overflow(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	int			nr_to_add)
+{
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	uint64_t		max_exts;
+	uint64_t		nr_exts;
+
+	if (whichfork == XFS_COW_FORK)
+		return 0;
+
+	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
+
+	nr_exts = ifp->if_nextents + nr_to_add;
+	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
+		return -EFBIG;
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index a4953e95c4f3..0beb8e2a00be 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -172,5 +172,7 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
 int xfs_ifork_verify_local_data(struct xfs_inode *ip);
 int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
+int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
+		int nr_to_add);
 
 #endif	/* __XFS_INODE_FORK_H__ */
-- 
2.28.0

