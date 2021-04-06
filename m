Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112273552FF
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Apr 2021 13:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343633AbhDFL7j (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Apr 2021 07:59:39 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:38734 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343634AbhDFL7j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 07:59:39 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id BE65F64F71
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 21:59:27 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lTkMg-00Cns4-Sj
        for linux-xfs@vger.kernel.org; Tue, 06 Apr 2021 21:59:26 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lTkMg-007IOU-L4
        for linux-xfs@vger.kernel.org; Tue, 06 Apr 2021 21:59:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: inode fork allocation depends on XFS_IFEXTENT flag
Date:   Tue,  6 Apr 2021 21:59:21 +1000
Message-Id: <20210406115923.1738753-3-david@fromorbit.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210406115923.1738753-1-david@fromorbit.com>
References: <20210406115923.1738753-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=3YhXtTcJ-WEA:10 a=20KFwNOVAAAA:8 a=ckBvnjlXmtiezeFHkqwA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Due to confusion on when the XFS_IFEXTENT needs to be set, the
changes in e6a688c33238 ("xfs: initialise attr fork on inode
create") failed to set the flag when initialising the empty
attribute fork at inode creation. Set this flag the same way
xfs_bmap_add_attrfork() does after attry fork allocation.

Fixes: e6a688c33238 ("xfs: initialise attr fork on inode create")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3b516ab7f22b..6e3fbe25ef57 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -890,6 +890,7 @@ xfs_init_new_inode(
 	if (init_xattrs && xfs_sb_version_hasattr(&mp->m_sb)) {
 		ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
 		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
+		ip->i_afp->if_flags = XFS_IFEXTENTS;
 	}
 
 	/*
-- 
2.31.0

