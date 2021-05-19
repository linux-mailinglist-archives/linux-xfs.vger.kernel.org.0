Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5B4388DA9
	for <lists+linux-xfs@lfdr.de>; Wed, 19 May 2021 14:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353397AbhESMOo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 19 May 2021 08:14:44 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49020 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243146AbhESMOl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:14:41 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 80B6C861553
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:13:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4h-002m12-Uj
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:19 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4h-002SH7-Mp
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/39] xfs: embed the xlog_op_header in the unmount record
Date:   Wed, 19 May 2021 22:12:52 +1000
Message-Id: <20210519121317.585244-15-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519121317.585244-1-david@fromorbit.com>
References: <20210519121317.585244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=b-8Z-jpvmKRXpXNIxMAA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Remove another case where xlog_write() has to prepend an opheader to
a log transaction. The unmount record + ophdr is smaller than the
minimum amount of space guaranteed to be free in an iclog (2 *
sizeof(ophdr)) and so we don't have to care about an unmount record
being split across 2 iclogs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 981cd6f8f0ff..e7a135ffa66f 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -800,12 +800,22 @@ xlog_write_unmount_record(
 	struct xlog		*log,
 	struct xlog_ticket	*ticket)
 {
-	struct xfs_unmount_log_format ulf = {
-		.magic = XLOG_UNMOUNT_TYPE,
+	struct  {
+		struct xlog_op_header ophdr;
+		struct xfs_unmount_log_format ulf;
+	} unmount_rec = {
+		.ophdr = {
+			.oh_clientid = XFS_LOG,
+			.oh_tid = cpu_to_be32(ticket->t_tid),
+			.oh_flags = XLOG_UNMOUNT_TRANS,
+		},
+		.ulf = {
+			.magic = XLOG_UNMOUNT_TYPE,
+		},
 	};
 	struct xfs_log_iovec reg = {
-		.i_addr = &ulf,
-		.i_len = sizeof(ulf),
+		.i_addr = &unmount_rec,
+		.i_len = sizeof(unmount_rec),
 		.i_type = XLOG_REG_TYPE_UNMOUNT,
 	};
 	struct xfs_log_vec vec = {
@@ -813,8 +823,12 @@ xlog_write_unmount_record(
 		.lv_iovecp = &reg,
 	};
 
+	BUILD_BUG_ON((sizeof(struct xlog_op_header) +
+		      sizeof(struct xfs_unmount_log_format)) !=
+							sizeof(unmount_rec));
+
 	/* account for space used by record data */
-	ticket->t_curr_res -= sizeof(ulf);
+	ticket->t_curr_res -= sizeof(unmount_rec);
 
 	/*
 	 * For external log devices, we need to flush the data device cache
@@ -2145,6 +2159,8 @@ xlog_write_calc_vec_length(
 
 	/* Don't account for regions with embedded ophdrs */
 	if (optype && headers > 0) {
+		if (optype & XLOG_UNMOUNT_TRANS)
+			headers--;
 		if (optype & XLOG_START_TRANS) {
 			ASSERT(headers >= 2);
 			headers -= 2;
@@ -2359,12 +2375,11 @@ xlog_write(
 
 	/*
 	 * If this is a commit or unmount transaction, we don't need a start
-	 * record to be written.  We do, however, have to account for the
-	 * commit or unmount header that gets written. Hence we always have
-	 * to account for an extra xlog_op_header here for commit and unmount
-	 * records.
+	 * record to be written.  We do, however, have to account for the commit
+	 * header that gets written. Hence we always have to account for an
+	 * extra xlog_op_header here for commit records.
 	 */
-	if (optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
+	if (optype & XLOG_COMMIT_TRANS)
 		ticket->t_curr_res -= sizeof(struct xlog_op_header);
 	if (ticket->t_curr_res < 0) {
 		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
@@ -2424,6 +2439,8 @@ xlog_write(
 				ophdr = reg->i_addr;
 				if (index)
 					optype &= ~XLOG_START_TRANS;
+			} else if (optype & XLOG_UNMOUNT_TRANS) {
+				ophdr = reg->i_addr;
 			} else {
 				ophdr = xlog_write_setup_ophdr(log, ptr,
 							ticket, optype);
@@ -2454,7 +2471,7 @@ xlog_write(
 			/*
 			 * Copy region.
 			 *
-			 * Commit and unmount records just log an opheader, so
+			 * Commit records just log an opheader, so
 			 * we can have empty payloads with no data region to
 			 * copy.  Hence we only copy the payload if the vector
 			 * says it has data to copy.
-- 
2.31.1

