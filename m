Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F8928B193
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Oct 2020 11:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbgJLJaQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Oct 2020 05:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbgJLJaQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 05:30:16 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED2FC0613CE
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:16 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n9so13673973pgf.9
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 02:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oYBM06+g/EmUBhIp77KCEhSyDSZi8IrTtzGEoP6nKcs=;
        b=q8MR5kS8MbdrNPZxgCzyiozCDREzB2aF5BNT3+l1HCXhcp/zs60ha84rYKrpDSGt8N
         0Untb/ovGlMHUr0Ym3w0qmsvmdiXFFadp215oDXdK/IkE2QnEy7EtuS4UA9ra/BzotI0
         1+HGSPiI5SRjQU3R4I0atc1vOVIGZI1tKWD3kM6g9UhEJJ7r+sDfqGiZc6eooQzx3Qeo
         zFtHNoBlMQEaYlH4hTduKdXkUHpTTAa95acUlUpadlTvoprr0bLoe6rZ1KQpo8uKfxBc
         PalaEBffZ+c0iRnIjMTe0p/2+UPJwYa0doZreEOP1RAMbww3C0YY8Ere5EDQUFUitv3v
         3T5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oYBM06+g/EmUBhIp77KCEhSyDSZi8IrTtzGEoP6nKcs=;
        b=S9SxoXfJl1CgZh+mS09iqCHp5b5E9VP/MrSyr6vbCmJcuYqigga5bQoxD1hbjil9yq
         Ry7k8kV2g9BcoZ8E9oUxTQnLr28S+p0QJF/eT89GSmLACgAhEfF/cRohTFKSfwYDY0Nw
         G7Yr3IvXbiVl3il9bK/1EWlaaxjJN8LSeIXXH6EMrAZb9ovOEq8I6SLYDvkFi3dLMDY5
         loW/MmppPNez6eBFmpI1KPXeALZkpURrpB2Jr4EzHOoGsZM1Q7Scs1DUYgEwCO1ni8hv
         zXqFao1E0UN6D1ngYy0rC41fw1b3QXRq65umaTSFRw2pEOvxl34ZFEraM/iiV7iweRTQ
         XeDQ==
X-Gm-Message-State: AOAM531E4Vb5Cd0UiNcUwK451Tw2j/ZIit5bC3x1kzGqxxYUdY5hOEwp
        /qUPff0xjZdeyXyhV9mdp/C1dU+vfUU=
X-Google-Smtp-Source: ABdhPJyn+46lxsZWMb7NH+qUvZTMzT/OOtXUX06G8G08Bc5lPXwywCmC1HDWEckr6YGCgG9rxVvB6A==
X-Received: by 2002:a17:90a:2e14:: with SMTP id q20mr17323311pjd.65.1602495015875;
        Mon, 12 Oct 2020 02:30:15 -0700 (PDT)
Received: from localhost.localdomain ([122.172.180.109])
        by smtp.gmail.com with ESMTPSA id z142sm19451985pfc.179.2020.10.12.02.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 02:30:15 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V6 04/11] xfs: Check for extent overflow when adding/removing xattrs
Date:   Mon, 12 Oct 2020 14:59:31 +0530
Message-Id: <20201012092938.50946-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012092938.50946-1-chandanrlinux@gmail.com>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to be
added. One extra extent for dabtree in case a local attr is large enough
to cause a double split.  It can also cause extent count to increase
proportional to the size of a remote xattr's value.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c       | 13 +++++++++++++
 fs/xfs/libxfs/xfs_inode_fork.h | 10 ++++++++++
 2 files changed, 23 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fd8e6418a0d3..be51e7068dcd 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -396,6 +396,7 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
 	int			error, local;
+	int			rmt_blks = 0;
 	unsigned int		total;
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
@@ -442,11 +443,15 @@ xfs_attr_set(
 		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
 		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 		total = args->total;
+
+		if (!local)
+			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
 	} else {
 		XFS_STATS_INC(mp, xs_attr_remove);
 
 		tres = M_RES(mp)->tr_attrrm;
 		total = XFS_ATTRRM_SPACE_RES(mp);
+		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
 	}
 
 	/*
@@ -460,6 +465,14 @@ xfs_attr_set(
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(args->trans, dp, 0);
+
+	if (args->value || xfs_inode_hasattr(dp)) {
+		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
+				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	if (args->value) {
 		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index bcac769a7df6..5de2f07d0dd5 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -47,6 +47,16 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_PUNCH_HOLE_CNT		(1)
 
+/*
+ * Adding/removing an xattr can cause XFS_DA_NODE_MAXDEPTH extents to
+ * be added. One extra extent for dabtree in case a local attr is
+ * large enough to cause a double split.  It can also cause extent
+ * count to increase proportional to the size of a remote xattr's
+ * value.
+ */
+#define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
+	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
+
 /*
  * Fork handling.
  */
-- 
2.28.0

