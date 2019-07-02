Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D84985D5FE
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2019 20:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfGBSPx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 2 Jul 2019 14:15:53 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39868 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfGBSPw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jul 2019 14:15:52 -0400
Received: by mail-pg1-f196.google.com with SMTP id 196so8075343pgc.6;
        Tue, 02 Jul 2019 11:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=DxOUvXm8PNrI3FnpXmI93iJZ669glLcrN8+sl606Vzo=;
        b=CzVO+nNLbPllxoJSeWpK2BzAWjshDfcdvDMua1IC5sYF6s7Xn/K8TNi9DnqBVo68Fx
         cb//ZSOn/y6OmS1ekJVl6aQSD8+K55m5nEIKaj4H1Z3OPlV3oZm6j7SLB6TEMAGoIo1h
         Vd62nu4SH4i2XEg+GURoN8BEPnrYd4pdgqvj8JwMW4oYxIWbkngzzEnXzq22roxJsyTL
         9h5qT91X25zEqWU9zX8/DnK/dczg/nfva8eCKPA6Cw0Uxk4wByyDw5ycphJpe/b7Thw4
         zClSZcAXk4o/74nxp5CHWl8rjgsOfnBOmkmO7SSbYCeItcI7kKdBsV63sVN5LczXi1u2
         Xmqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=DxOUvXm8PNrI3FnpXmI93iJZ669glLcrN8+sl606Vzo=;
        b=tkUkW+z+M/KSc4y+5gpsL34L2lc5yX9oAyWo6+xpKXE60ZladsddvXL6woHgq6rFA6
         Imlok114NGSAB0lsxXiX5MamehdeEJesHREeGpj7luP5MTBlaO3aHS1vZPGJ4MaTL74X
         07Sqq8O1X/j4bsQRNrikFX1GDu3ycj7iO3LRe7IH3HnfdkD0p6eSD04AWmSVA3XIr+nX
         jSVYTOjthneivjmxJHqHhG14VeOsPHyuvDzONsvDyUI7Eve/Bm5hJwJKZv01c0PrJjhT
         4XlOdAatnxl9+BA8N0+pIa39e/AoqAtjB607kTSMHmcEc1SbSnoy2dZcNWjikby+ojtE
         STyQ==
X-Gm-Message-State: APjAAAW6PjGvdfwHg9tFNjJ7T9oJMNBAogydxYhM52b7Vl0mPknhosZf
        YMMSOGbVqOh1qOTum+QNUQY=
X-Google-Smtp-Source: APXvYqwVQlC/FW+sbrMn2V0B2Ksokr49iVLxwe3ctfAlOi8fgHulMFAIrzzcUqEHghzSXodxC0hpsw==
X-Received: by 2002:a63:f146:: with SMTP id o6mr31297134pgk.179.1562091351993;
        Tue, 02 Jul 2019 11:15:51 -0700 (PDT)
Received: from hari-Inspiron-1545 ([183.83.92.187])
        by smtp.gmail.com with ESMTPSA id y133sm15016889pfb.28.2019.07.02.11.15.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 11:15:51 -0700 (PDT)
Date:   Tue, 2 Jul 2019 23:45:47 +0530
From:   Hariprasad Kelam <hariprasad.kelam@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: xfs: xfs_log: Change return type from int to void
Message-ID: <20190702181547.GA11316@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Change return types of below functions as they never fails
xfs_log_mount_cancel
xlog_recover_cancel
xlog_recover_cancel_intents

fix below issue reported by coccicheck
fs/xfs/xfs_log_recover.c:4886:7-12: Unneeded variable: "error". Return
"0" on line 4926

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 fs/xfs/xfs_log.c         |  8 ++------
 fs/xfs/xfs_log.h         |  2 +-
 fs/xfs/xfs_log_priv.h    |  2 +-
 fs/xfs/xfs_log_recover.c | 12 +++---------
 4 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index cbaf348..00e9f5c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -769,16 +769,12 @@ xfs_log_mount_finish(
  * The mount has failed. Cancel the recovery if it hasn't completed and destroy
  * the log.
  */
-int
+void
 xfs_log_mount_cancel(
 	struct xfs_mount	*mp)
 {
-	int			error;
-
-	error = xlog_recover_cancel(mp->m_log);
+	xlog_recover_cancel(mp->m_log);
 	xfs_log_unmount(mp);
-
-	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index f27b1cb..84e0680 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -117,7 +117,7 @@ int	  xfs_log_mount(struct xfs_mount	*mp,
 			xfs_daddr_t		start_block,
 			int		 	num_bblocks);
 int	  xfs_log_mount_finish(struct xfs_mount *mp);
-int	xfs_log_mount_cancel(struct xfs_mount *);
+void	xfs_log_mount_cancel(struct xfs_mount *);
 xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
 xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
 void	  xfs_log_space_wake(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 8acacbc..b880c23 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -418,7 +418,7 @@ xlog_recover(
 extern int
 xlog_recover_finish(
 	struct xlog		*log);
-extern int
+extern void
 xlog_recover_cancel(struct xlog *);
 
 extern __le32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1fc70ac..13d1d3e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4875,12 +4875,11 @@ xlog_recover_process_intents(
  * A cancel occurs when the mount has failed and we're bailing out.
  * Release all pending log intent items so they don't pin the AIL.
  */
-STATIC int
+STATIC void
 xlog_recover_cancel_intents(
 	struct xlog		*log)
 {
 	struct xfs_log_item	*lip;
-	int			error = 0;
 	struct xfs_ail_cursor	cur;
 	struct xfs_ail		*ailp;
 
@@ -4920,7 +4919,6 @@ xlog_recover_cancel_intents(
 
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->ail_lock);
-	return error;
 }
 
 /*
@@ -5779,16 +5777,12 @@ xlog_recover_finish(
 	return 0;
 }
 
-int
+void
 xlog_recover_cancel(
 	struct xlog	*log)
 {
-	int		error = 0;
-
 	if (log->l_flags & XLOG_RECOVERY_NEEDED)
-		error = xlog_recover_cancel_intents(log);
-
-	return error;
+		xlog_recover_cancel_intents(log);
 }
 
 #if defined(DEBUG)
-- 
2.7.4

