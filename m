Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17BB56AEAE
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Jul 2022 00:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbiGGWil (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 Jul 2022 18:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236881AbiGGWik (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 18:38:40 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6437183A3
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 15:38:38 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id i8-20020a17090a4b8800b001ef8a65bfbdso188596pjh.1
        for <linux-xfs@vger.kernel.org>; Thu, 07 Jul 2022 15:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3u5alQ391Xm/Zm2A5SIg62qPJJLdErZe0snhScshagg=;
        b=hoGPli2ZTRx1XAWwEcvp0K28PYfnzVnMALz+kFQlx///QLPB/wDc1FdfZUdb4nGBy6
         SkHMRS510tPFjI5OFWtM+0kCzZtX/mMmint86QKllIZ1aryeSkpg3CcxfZeM8dwLYKqU
         DVjzYxL9EhbkSqvpCMFlcZ+vGUKyAFNmq4ZG5CgA2xOEhc7oYn9Sh7gXHOA0OOpe2PYh
         I0v+OALANAxCCrHby7+OrtJrw3Ur8F//JqKtoSg3x4N33psMVX+I84wBqXeehQU/qY4i
         SrcUyxJWHtZdpPeb2zNuoQU74IzQGJDhftFR29+dBm7O8C9wtrHuoj4G7z2pPtrRcNrT
         tgYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3u5alQ391Xm/Zm2A5SIg62qPJJLdErZe0snhScshagg=;
        b=diGAYLxh69D6nU1VABo6jeEH/8nKKL5HOyaO8HtDiAL8FuQGI+UhvyRdnscjgSwoL9
         2X/S+X70sLHCF4h+tC0GbmveyZXRfWCGcjsCGEgea0cz+WFHHJkbn+35VVeR3azzOday
         HUXGiX7pGwd7/yAxQWpQhr0HImEbDwZqVM9tKKKXedBreLdCperCHrdgstVzNLtZmVIm
         IPpa16RX3Gr3qkMjfhkVrqxC6pFvoekOYV5rS9KWABp6tSMLQy9Zc5fsa0MhPzWCDaQs
         N9gyhFj8aYbZvKBtMC+POaDVV9jw5AA5ww7YREP5KvOq7FAFBDriDYnHm0AA/cqXn7Uh
         b63w==
X-Gm-Message-State: AJIora+Z/j/U2ESi/5q/sdNpA6a9YDwMuOv29aLlzEsjUD8fHyESrYu1
        /JE3SkpWqjo2zimbX2VIakkNzLoDC2vQDw==
X-Google-Smtp-Source: AGRyM1tkIfTLF9HXGPcEh4oa9x83Qy4ONcIT8nggIxGMJ0wDoxhjholu5Au2THnJMBIu1Npux7PIZw==
X-Received: by 2002:a17:902:ce88:b0:16c:1b1e:71b4 with SMTP id f8-20020a170902ce8800b0016c1b1e71b4mr192722plg.153.1657233518044;
        Thu, 07 Jul 2022 15:38:38 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:26db:8a38:cdca:57b5])
        by smtp.gmail.com with ESMTPSA id j15-20020a056a00234f00b0052542cbff9dsm28776889pfj.99.2022.07.07.15.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 15:38:37 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <lrumancik@google.com>
Subject: [PATCH 5.15 CANDIDATE 1/4] xfs: only run COW extent recovery when there are no live extents
Date:   Thu,  7 Jul 2022 15:38:25 -0700
Message-Id: <20220707223828.599185-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
In-Reply-To: <20220707223828.599185-1-leah.rumancik@gmail.com>
References: <20220707223828.599185-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 7993f1a431bc5271369d359941485a9340658ac3 ]

As part of multiple customer escalations due to file data corruption
after copy on write operations, I wrote some fstests that use fsstress
to hammer on COW to shake things loose.  Regrettably, I caught some
filesystem shutdowns due to incorrect rmap operations with the following
loop:

mount <filesystem>				# (0)
fsstress <run only readonly ops> &		# (1)
while true; do
	fsstress <run all ops>
	mount -o remount,ro			# (2)
	fsstress <run only readonly ops>
	mount -o remount,rw			# (3)
done

When (2) happens, notice that (1) is still running.  xfs_remount_ro will
call xfs_blockgc_stop to walk the inode cache to free all the COW
extents, but the blockgc mechanism races with (1)'s reader threads to
take IOLOCKs and loses, which means that it doesn't clean them all out.
Call such a file (A).

When (3) happens, xfs_remount_rw calls xfs_reflink_recover_cow, which
walks the ondisk refcount btree and frees any COW extent that it finds.
This function does not check the inode cache, which means that incore
COW forks of inode (A) is now inconsistent with the ondisk metadata.  If
one of those former COW extents are allocated and mapped into another
file (B) and someone triggers a COW to the stale reservation in (A), A's
dirty data will be written into (B) and once that's done, those blocks
will be transferred to (A)'s data fork without bumping the refcount.

The results are catastrophic -- file (B) and the refcount btree are now
corrupt.  In the first patch, we fixed the race condition in (2) so that
(A) will always flush the COW fork.  In this second patch, we move the
_recover_cow call to the initial mount call in (0) for safety.

As mentioned previously, xfs_reflink_recover_cow walks the refcount
btree looking for COW staging extents, and frees them.  This was
intended to be run at mount time (when we know there are no live inodes)
to clean up any leftover staging events that may have been left behind
during an unclean shutdown.  As a time "optimization" for readonly
mounts, we deferred this to the ro->rw transition, not realizing that
any failure to clean all COW forks during a rw->ro transition would
result in catastrophic corruption.

Therefore, remove this optimization and only run the recovery routine
when we're guaranteed not to have any COW staging extents anywhere,
which means we always run this at mount time.  While we're at it, move
the callsite to xfs_log_mount_finish because any refcount btree
expansion (however unlikely given that we're removing records from the
right side of the index) must be fed by a per-AG reservation, which
doesn't exist in its current location.

Fixes: 174edb0e46e5 ("xfs: store in-progress CoW allocations in the refcount btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <lrumancik@google.com>
---
 fs/xfs/xfs_log_recover.c | 24 +++++++++++++++++++++++-
 fs/xfs/xfs_mount.c       | 10 ----------
 fs/xfs/xfs_reflink.c     |  5 ++++-
 fs/xfs/xfs_super.c       |  9 ---------
 4 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 10562ecbd9ea..581aeb288b32 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -27,7 +27,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_ag.h"
 #include "xfs_quota.h"
-
+#include "xfs_reflink.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
@@ -3502,6 +3502,28 @@ xlog_recover_finish(
 
 	xlog_recover_process_iunlinks(log);
 	xlog_recover_check_summary(log);
+
+	/*
+	 * Recover any CoW staging blocks that are still referenced by the
+	 * ondisk refcount metadata.  During mount there cannot be any live
+	 * staging extents as we have not permitted any user modifications.
+	 * Therefore, it is safe to free them all right now, even on a
+	 * read-only mount.
+	 */
+	error = xfs_reflink_recover_cow(log->l_mp);
+	if (error) {
+		xfs_alert(log->l_mp,
+	"Failed to recover leftover CoW staging extents, err %d.",
+				error);
+		/*
+		 * If we get an error here, make sure the log is shut down
+		 * but return zero so that any log items committed since the
+		 * end of intents processing can be pushed through the CIL
+		 * and AIL.
+		 */
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+	}
+
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 06dac09eddbd..62f3c153d4b2 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -922,15 +922,6 @@ xfs_mountfs(
 			xfs_warn(mp,
 	"Unable to allocate reserve blocks. Continuing without reserve pool.");
 
-		/* Recover any CoW blocks that never got remapped. */
-		error = xfs_reflink_recover_cow(mp);
-		if (error) {
-			xfs_err(mp,
-	"Error %d recovering leftover CoW allocations.", error);
-			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-			goto out_quota;
-		}
-
 		/* Reserve AG blocks for future btree expansion. */
 		error = xfs_fs_reserve_ag_blocks(mp);
 		if (error && error != -ENOSPC)
@@ -941,7 +932,6 @@ xfs_mountfs(
 
  out_agresv:
 	xfs_fs_unreserve_ag_blocks(mp);
- out_quota:
 	xfs_qm_unmount_quotas(mp);
  out_rtunmount:
 	xfs_rtunmount_inodes(mp);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 76355f293488..36832e4bc803 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -749,7 +749,10 @@ xfs_reflink_end_cow(
 }
 
 /*
- * Free leftover CoW reservations that didn't get cleaned out.
+ * Free all CoW staging blocks that are still referenced by the ondisk refcount
+ * metadata.  The ondisk metadata does not track which inode created the
+ * staging extent, so callers must ensure that there are no cached inodes with
+ * live CoW staging extents.
  */
 int
 xfs_reflink_recover_cow(
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e8d19916ba99..5410bf0ab426 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1742,15 +1742,6 @@ xfs_remount_rw(
 	 */
 	xfs_restore_resvblks(mp);
 	xfs_log_work_queue(mp);
-
-	/* Recover any CoW blocks that never got remapped. */
-	error = xfs_reflink_recover_cow(mp);
-	if (error) {
-		xfs_err(mp,
-			"Error %d recovering leftover CoW allocations.", error);
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		return error;
-	}
 	xfs_blockgc_start(mp);
 
 	/* Create the per-AG metadata reservation pool .*/
-- 
2.37.0.rc0.161.g10f37bed90-goog

