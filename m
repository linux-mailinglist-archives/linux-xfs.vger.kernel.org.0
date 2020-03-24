Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9F65191803
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Mar 2020 18:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbgCXRpS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Mar 2020 13:45:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54134 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbgCXRpS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 13:45:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=tIHxFCqbA7qG+SSfXT1WoxRxkRYRYgdcO0VBO5+WOQU=; b=ZgwFf+sIupSIxMEckMdbDf9s3l
        RWC6W2MYHSTIG/qRHElHfkpsAGxMRRlW+rL2Dyvw9SaOvutMqiWyiW7BJ9gQm5I5X94CUfSGgGjuj
        nOwCcVjaI94ZVnWfJYC6+kYk620kjtZdRShMQTKcEn4DczeHOlex6h+uUq73cXD/mt5RfB/r3iY08
        zzJpk00tdZEIrN7F4s/q1Q84dOmNa6ru3ycretiSIMOdRZfyYUnINIAwQX1tsiNRQiHjIV0fCAfRK
        zH2Qk2nx4+DUbzE3BqcuIsIZCBuOjijKG7VPYMD//2MwgZONjdWcuVSDLPl1sFSERn86u1aWeX0Sm
        8eMtozxQ==;
Received: from [2001:4bb8:18c:2a9e:999c:283e:b14a:9189] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGnc5-0003Ia-O8; Tue, 24 Mar 2020 17:45:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 7/8] xfs: refactor unmount record writing
Date:   Tue, 24 Mar 2020 18:44:58 +0100
Message-Id: <20200324174459.770999-8-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200324174459.770999-1-hch@lst.de>
References: <20200324174459.770999-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Separate out the unmount record writing from the rest of the
ticket and log state futzing necessary to make it work. This is
a no-op, just makes the code cleaner and places the unmount record
formatting and writing alongside the commit record formatting and
writing code.

We can also get rid of the ticket flag clearing before the
xlog_write() call because it no longer cares about the state of
XLOG_TIC_INITED.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c | 65 +++++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 28 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a173b5925d1b..1d6ed696f717 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -471,6 +471,36 @@ xfs_log_reserve(
  *		marked as with WANT_SYNC.
  */
 
+/*
+ * Write out an unmount record using the ticket provided. We have to account for
+ * the data space used in the unmount ticket as this write is not done from a
+ * transaction context that has already done the accounting for us.
+ */
+static int
+xlog_write_unmount_record(
+	struct xlog		*log,
+	struct xlog_ticket	*ticket,
+	xfs_lsn_t		*lsn,
+	uint			flags)
+{
+	struct xfs_unmount_log_format ulf = {
+		.magic = XLOG_UNMOUNT_TYPE,
+	};
+	struct xfs_log_iovec reg = {
+		.i_addr = &ulf,
+		.i_len = sizeof(ulf),
+		.i_type = XLOG_REG_TYPE_UNMOUNT,
+	};
+	struct xfs_log_vec vec = {
+		.lv_niovecs = 1,
+		.lv_iovecp = &reg,
+	};
+
+	/* account for space used by record data */
+	ticket->t_curr_res -= sizeof(ulf);
+	return xlog_write(log, &vec, ticket, lsn, NULL, flags);
+}
+
 static bool
 __xlog_state_release_iclog(
 	struct xlog		*log,
@@ -795,32 +825,14 @@ xlog_wait_on_iclog(
 }
 
 /*
- * Final log writes as part of unmount.
- *
- * Mark the filesystem clean as unmount happens.  Note that during relocation
- * this routine needs to be executed as part of source-bag while the
- * deallocation must not be done until source-end.
+ * Mark the filesystem clean by writing an unmount record to the head of the
+ * log.
  */
-
-/* Actually write the unmount record to disk. */
 static void
-xfs_log_write_unmount_record(
-	struct xfs_mount	*mp)
+xlog_unmount_write(
+	struct xlog		*log)
 {
-	/* the data section must be 32 bit size aligned */
-	struct xfs_unmount_log_format magic = {
-		.magic = XLOG_UNMOUNT_TYPE,
-	};
-	struct xfs_log_iovec reg = {
-		.i_addr = &magic,
-		.i_len = sizeof(magic),
-		.i_type = XLOG_REG_TYPE_UNMOUNT,
-	};
-	struct xfs_log_vec vec = {
-		.lv_niovecs = 1,
-		.lv_iovecp = &reg,
-	};
-	struct xlog		*log = mp->m_log;
+	struct xfs_mount	*mp = log->l_mp;
 	struct xlog_in_core	*iclog;
 	struct xlog_ticket	*tic = NULL;
 	xfs_lsn_t		lsn;
@@ -844,10 +856,7 @@ xfs_log_write_unmount_record(
 		flags &= ~XLOG_UNMOUNT_TRANS;
 	}
 
-	/* remove inited flag, and account for space used */
-	tic->t_flags = 0;
-	tic->t_curr_res -= sizeof(magic);
-	error = xlog_write(log, &vec, tic, &lsn, NULL, flags);
+	error = xlog_write_unmount_record(log, tic, &lsn, flags);
 	/*
 	 * At this point, we're umounting anyway, so there's no point in
 	 * transitioning log state to IOERROR. Just continue...
@@ -913,7 +922,7 @@ xfs_log_unmount_write(
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return;
 	xfs_log_unmount_verify_iclog(log);
-	xfs_log_write_unmount_record(mp);
+	xlog_unmount_write(log);
 }
 
 /*
-- 
2.25.1

