Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E344034E0B0
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Mar 2021 07:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhC3Fbd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Mar 2021 01:31:33 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45928 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230224AbhC3FbE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Mar 2021 01:31:04 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 578061041C28
        for <linux-xfs@vger.kernel.org>; Tue, 30 Mar 2021 16:31:02 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lR6xx-008N4J-B7
        for linux-xfs@vger.kernel.org; Tue, 30 Mar 2021 16:31:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lR6xx-005cnh-3p
        for linux-xfs@vger.kernel.org; Tue, 30 Mar 2021 16:31:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: eager inode attr fork init needs attr feature awareness
Date:   Tue, 30 Mar 2021 16:30:56 +1100
Message-Id: <20210330053059.1339949-2-david@fromorbit.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210330053059.1339949-1-david@fromorbit.com>
References: <20210330053059.1339949-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=6qBOr3qjZ7zTj1CIAF0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The pitfalls of regression testing on a machine without realising
that selinux was disabled. Only set the attr fork during inode
allocation if the attr feature bits are already set on the
superblock.

Fixes: e6a688c33238 ("xfs: initialise attr fork on inode create")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c09bb39baeea..3b516ab7f22b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -887,7 +887,7 @@ xfs_init_new_inode(
 	 * this saves us from needing to run a separate transaction to set the
 	 * fork offset in the immediate future.
 	 */
-	if (init_xattrs) {
+	if (init_xattrs && xfs_sb_version_hasattr(&mp->m_sb)) {
 		ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
 		ip->i_afp = xfs_ifork_alloc(XFS_DINODE_FMT_EXTENTS, 0);
 	}
-- 
2.31.0

