Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8113A3D1B8B
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jul 2021 03:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhGVBNR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 21 Jul 2021 21:13:17 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:53301 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230086AbhGVBNG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jul 2021 21:13:06 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 793634DDA
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jul 2021 11:53:39 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m6Nu6-009JQA-9h
        for linux-xfs@vger.kernel.org; Thu, 22 Jul 2021 11:53:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m6Nu6-00CquX-1b
        for linux-xfs@vger.kernel.org; Thu, 22 Jul 2021 11:53:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfs: flush data dev on external log write
Date:   Thu, 22 Jul 2021 11:53:31 +1000
Message-Id: <20210722015335.3063274-2-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210722015335.3063274-1-david@fromorbit.com>
References: <20210722015335.3063274-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=r_EzLFMmjEd-lPC6gHAA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We incorrectly flush the log device instead of the data device when
trying to ensure metadata is correctly on disk before writing the
unmount record.

Fixes: eef983ffeae7 ("xfs: journal IO cache flush reductions")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 36fa2650b081..96434cc4df6e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -833,7 +833,7 @@ xlog_write_unmount_record(
 	 * stamp the tail LSN into the unmount record.
 	 */
 	if (log->l_targ != log->l_mp->m_ddev_targp)
-		blkdev_issue_flush(log->l_targ->bt_bdev);
+		blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
 	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS);
 }
 
-- 
2.31.1

