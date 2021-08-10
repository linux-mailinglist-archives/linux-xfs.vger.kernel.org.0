Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481653E52DF
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Aug 2021 07:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbhHJFZT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 Aug 2021 01:25:19 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:41184 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234316AbhHJFZS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Aug 2021 01:25:18 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 2B94B1143B12
        for <linux-xfs@vger.kernel.org>; Tue, 10 Aug 2021 15:24:56 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mDKFz-00GZg1-1i
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:24:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mDKFy-000Aq7-Pn
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:24:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/16] xfs: convert scrub to use mount-based feature checks
Date:   Tue, 10 Aug 2021 15:24:47 +1000
Message-Id: <20210810052451.41578-13-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810052451.41578-1-david@fromorbit.com>
References: <20210810052451.41578-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=VD3eYbhaXsHkHZtvsr4A:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The scrub feature checks are the last place that the superblock
feature checks are used. Convert them to mount based feature checks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/scrub.c | 12 ++++++------
 fs/xfs/scrub/scrub.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index a5b1ea9361b3..57ecbc48bbd5 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -239,21 +239,21 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_iallocbt,
 		.scrub	= xchk_finobt,
-		.has	= xfs_sb_version_hasfinobt,
+		.has	= xfs_has_finobt,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_RMAPBT] = {	/* rmapbt */
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_rmapbt,
 		.scrub	= xchk_rmapbt,
-		.has	= xfs_sb_version_hasrmapbt,
+		.has	= xfs_has_rmapbt,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_REFCNTBT] = {	/* refcountbt */
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_refcountbt,
 		.scrub	= xchk_refcountbt,
-		.has	= xfs_sb_version_hasreflink,
+		.has	= xfs_has_reflink,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_INODE] = {	/* inode record */
@@ -308,14 +308,14 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xchk_setup_rt,
 		.scrub	= xchk_rtbitmap,
-		.has	= xfs_sb_version_hasrealtime,
+		.has	= xfs_has_realtime,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
 		.type	= ST_FS,
 		.setup	= xchk_setup_rt,
 		.scrub	= xchk_rtsummary,
-		.has	= xfs_sb_version_hasrealtime,
+		.has	= xfs_has_realtime,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_UQUOTA] = {	/* user quota */
@@ -383,7 +383,7 @@ xchk_validate_inputs(
 	if (ops->setup == NULL || ops->scrub == NULL)
 		goto out;
 	/* Does this fs even support this type of metadata? */
-	if (ops->has && !ops->has(&mp->m_sb))
+	if (ops->has && !ops->has(mp))
 		goto out;
 
 	error = -EINVAL;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 08a483cb46e2..b8e7ccc5e6c3 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -27,7 +27,7 @@ struct xchk_meta_ops {
 	int		(*repair)(struct xfs_scrub *);
 
 	/* Decide if we even have this piece of metadata. */
-	bool		(*has)(struct xfs_sb *);
+	bool		(*has)(struct xfs_mount *);
 
 	/* type describing required/allowed inputs */
 	enum xchk_type	type;
-- 
2.31.1

