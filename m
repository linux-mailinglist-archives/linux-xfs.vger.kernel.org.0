Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C41AD178C00
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Mar 2020 08:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgCDHyL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Mar 2020 02:54:11 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34029 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728539AbgCDHyK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 02:54:10 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5B8953A2A30
        for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2020 18:54:03 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqw-0007lu-9L
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:02 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqw-0005cx-4t
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/11] xfs: kill XLOG_TIC_INITED
Date:   Wed,  4 Mar 2020 18:54:01 +1100
Message-Id: <20200304075401.21558-12-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
In-Reply-To: <20200304075401.21558-1-david@fromorbit.com>
References: <20200304075401.21558-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=HZAom3Fnrnec--42wGYA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It is not longer used or checked by anything, so remove the last
traces from the log ticket code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      | 1 -
 fs/xfs/xfs_log_priv.h | 6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 89956484848f..b91efc5829e1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3529,7 +3529,6 @@ xlog_ticket_alloc(
 	tic->t_ocnt		= cnt;
 	tic->t_tid		= prandom_u32();
 	tic->t_clientid		= client;
-	tic->t_flags		= XLOG_TIC_INITED;
 	if (permanent)
 		tic->t_flags |= XLOG_TIC_PERM_RESERV;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 081d4c6de2c8..e989cf024ffe 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -51,13 +51,11 @@ enum xlog_iclog_state {
 };
 
 /*
- * Flags to log ticket
+ * Log ticket flags
  */
-#define XLOG_TIC_INITED		0x1	/* has been initialized */
-#define XLOG_TIC_PERM_RESERV	0x2	/* permanent reservation */
+#define XLOG_TIC_PERM_RESERV	0x1	/* permanent reservation */
 
 #define XLOG_TIC_FLAGS \
-	{ XLOG_TIC_INITED,	"XLOG_TIC_INITED" }, \
 	{ XLOG_TIC_PERM_RESERV,	"XLOG_TIC_PERM_RESERV" }
 
 /*
-- 
2.24.0.rc0

