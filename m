Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED042DD356
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Dec 2020 15:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgLQOzF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Dec 2020 09:55:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20966 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725468AbgLQOzE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Dec 2020 09:55:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608216818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hB58zboC0dtKxlmTz5kHA1Xe58GCQ02wmZOXvBBAcBQ=;
        b=OpZtG3L94ZfkxtooWzTwjNmSIX2TAlkNQqY2IBlo8VQSPZc1xlbz0L13OYZy07xj9bdwY5
        poaUIvAp4LWWbyJrQ1T7zNQgVU7csfX6D+n9QrIcspikNgjsvEIdDdAxZGpRd8Nsl1nE6T
        ikciFGkVINzZWZ5v6SmW9I950s1s6Gk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-j5zGQGQiMMe7657Tj4QqXg-1; Thu, 17 Dec 2020 09:53:36 -0500
X-MC-Unique: j5zGQGQiMMe7657Tj4QqXg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6551E800D53
        for <linux-xfs@vger.kernel.org>; Thu, 17 Dec 2020 14:53:35 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2542B19C71
        for <linux-xfs@vger.kernel.org>; Thu, 17 Dec 2020 14:53:35 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: sync lazy sb accounting on quiesce of read-only mounts
Date:   Thu, 17 Dec 2020 09:53:34 -0500
Message-Id: <20201217145334.2512475-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_log_sbcount() syncs the superblock specifically to accumulate
the in-core percpu superblock counters and commit them to disk. This
is required to maintain filesystem consistency across quiesce
(freeze, read-only mount/remount) or unmount when lazy superblock
accounting is enabled because individual transactions do not update
the superblock directly.

This mechanism works as expected for writable mounts, but
xfs_log_sbcount() skips the update for read-only mounts. Read-only
mounts otherwise still allow log recovery and write out an unmount
record during log quiesce. If a read-only mount performs log
recovery, it can modify the in-core superblock counters and write an
unmount record when the filesystem unmounts without ever syncing the
in-core counters. This leaves the filesystem with a clean log but in
an inconsistent state with regard to lazy sb counters.

Update xfs_log_sbcount() to use the same logic
xfs_log_unmount_write() uses to determine when to write an unmount
record. We can drop the freeze state check because the update is
already allowed during the freezing process and no context calls
this function on an already frozen fs. This ensures that lazy
accounting is always synced before the log is cleaned. Refactor this
logic into a new helper to distinguish between a writable filesystem
and a writable log. Specifically, the log is writable unless the
filesystem is mounted with the norecovery mount option, the
underlying log device is read-only, or the filesystem is shutdown.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This is something I noticed when reworking the log quiesce code to reuse
log covering. It seems like a bug worth an independent fix, so I peeled
it off into a standalone patch. Note that the broader rework currently
removes both xfs_log_sbcount() and xfs_quiesce_attr(), so this is
intended to be an isolated/backportable bug fix. The problem is easily
reproducible with a small tweak to generic/388 that I'll post shortly...

Brian

 fs/xfs/xfs_log.c   | 28 ++++++++++++++++++++--------
 fs/xfs/xfs_log.h   |  1 +
 fs/xfs/xfs_mount.c |  3 +--
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fa2d05e65ff1..b445e63cbc3c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -347,6 +347,25 @@ xlog_tic_add_region(xlog_ticket_t *tic, uint len, uint type)
 	tic->t_res_num++;
 }
 
+bool
+xfs_log_writable(
+	struct xfs_mount	*mp)
+{
+	/*
+	 * Never write to the log on norecovery mounts, if the block device is
+	 * read-only, or if the filesystem is shutdown. Read-only mounts still
+	 * allow internal writes for log recovery and unmount purposes, so don't
+	 * restrict that case here.
+	 */
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+		return false;
+	if (xfs_readonly_buftarg(mp->m_log->l_targ))
+		return false;
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return false;
+	return true;
+}
+
 /*
  * Replenish the byte reservation required by moving the grant write head.
  */
@@ -886,15 +905,8 @@ xfs_log_unmount_write(
 {
 	struct xlog		*log = mp->m_log;
 
-	/*
-	 * Don't write out unmount record on norecovery mounts or ro devices.
-	 * Or, if we are doing a forced umount (typically because of IO errors).
-	 */
-	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
-	    xfs_readonly_buftarg(log->l_targ)) {
-		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
+	if (!xfs_log_writable(mp))
 		return;
-	}
 
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 58c3fcbec94a..98c913da7587 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -127,6 +127,7 @@ int	  xfs_log_reserve(struct xfs_mount *mp,
 int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
 void      xfs_log_unmount(struct xfs_mount *mp);
 int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
+bool	xfs_log_writable(struct xfs_mount *mp);
 
 struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
 void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 7110507a2b6b..a62b8a574409 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1176,8 +1176,7 @@ xfs_fs_writable(
 int
 xfs_log_sbcount(xfs_mount_t *mp)
 {
-	/* allow this to proceed during the freeze sequence... */
-	if (!xfs_fs_writable(mp, SB_FREEZE_COMPLETE))
+	if (!xfs_log_writable(mp))
 		return 0;
 
 	/*
-- 
2.26.2

