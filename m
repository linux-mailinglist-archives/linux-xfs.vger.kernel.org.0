Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 794E9E2B77
	for <lists+linux-xfs@lfdr.de>; Thu, 24 Oct 2019 09:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408748AbfJXHvv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 24 Oct 2019 03:51:51 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:26989
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408743AbfJXHvv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 03:51:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2A3AADRVrFd/0e30XYNWBsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgWoDAQEBCwEBhDqEKI9JBoERiiKFIAGMDgkBAQEBAQE?=
 =?us-ascii?q?BAQE3AQGEOwMCAoNZNwYOAgwBAQEEAQEBAQEFAwGFWIEaAQEEBwGFAQIBAyM?=
 =?us-ascii?q?EUhAYDQImAgJHEAYThXWxdHV/MxqKMIEOKAGBZIpCeIEHgREzgx2HVYJeBI0?=
 =?us-ascii?q?OL4IAN4VfYUOWbIIulUUMgi+LcAMQixQtqWiBe00uCoMnUJF9Z4c9gxmCfyu?=
 =?us-ascii?q?CLgEB?=
X-IPAS-Result: =?us-ascii?q?A2A3AADRVrFd/0e30XYNWBsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgWoDAQEBCwEBhDqEKI9JBoERiiKFIAGMDgkBAQEBAQEBAQE3AQGEOwMCA?=
 =?us-ascii?q?oNZNwYOAgwBAQEEAQEBAQEFAwGFWIEaAQEEBwGFAQIBAyMEUhAYDQImAgJHE?=
 =?us-ascii?q?AYThXWxdHV/MxqKMIEOKAGBZIpCeIEHgREzgx2HVYJeBI0OL4IAN4VfYUOWb?=
 =?us-ascii?q?IIulUUMgi+LcAMQixQtqWiBe00uCoMnUJF9Z4c9gxmCfyuCLgEB?=
X-IronPort-AV: E=Sophos;i="5.68,224,1569254400"; 
   d="scan'208";a="250044066"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Oct 2019 15:51:48 +0800
Subject: [PATCH v7 14/17] xfs: move xfs_parseargs() validation to a helper
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 24 Oct 2019 15:51:48 +0800
Message-ID: <157190350890.27074.6204984936498640245.stgit@fedora-28>
In-Reply-To: <157190333868.27074.13987695222060552856.stgit@fedora-28>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move the validation code of xfs_parseargs() into a helper for later
use within the mount context methods.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |  128 ++++++++++++++++++++++++++++------------------------
 1 file changed, 69 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index de0ab79536b3..b3c27a0781ed 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -314,68 +314,13 @@ xfs_fc_parse_param(
 	return 0;
 }
 
-/*
- * This function fills in xfs_mount_t fields based on mount args.
- * Note: the superblock has _not_ yet been read in.
- *
- * Note that this function leaks the various device name allocations on
- * failure.  The caller takes care of them.
- *
- * *sb is const because this is also used to test options on the remount
- * path, and we don't want this to have any side effects at remount time.
- * Today this function does not change *sb, but just to future-proof...
- */
 static int
-xfs_parseargs(
+xfs_fc_validate_params(
 	struct xfs_mount	*mp,
-	char			*options)
+	int			dsunit,
+	int			dswidth,
+	uint8_t			iosizelog)
 {
-	const struct super_block *sb = mp->m_super;
-	char			*p;
-	substring_t		args[MAX_OPT_ARGS];
-	int			dsunit = 0;
-	int			dswidth = 0;
-	uint8_t			iosizelog = 0;
-
-	/*
-	 * Copy binary VFS mount flags we are interested in.
-	 */
-	if (sb_rdonly(sb))
-		mp->m_flags |= XFS_MOUNT_RDONLY;
-	if (sb->s_flags & SB_DIRSYNC)
-		mp->m_flags |= XFS_MOUNT_DIRSYNC;
-	if (sb->s_flags & SB_SYNCHRONOUS)
-		mp->m_flags |= XFS_MOUNT_WSYNC;
-
-	/*
-	 * Set some default flags that could be cleared by the mount option
-	 * parsing.
-	 */
-	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
-
-	/*
-	 * These can be overridden by the mount option parsing.
-	 */
-	mp->m_logbufs = -1;
-	mp->m_logbsize = -1;
-
-	if (!options)
-		return 0;
-
-	while ((p = strsep(&options, ",")) != NULL) {
-		int		token;
-		int		ret;
-
-		if (!*p)
-			continue;
-
-		token = match_token(p, tokens, args);
-		ret = xfs_fc_parse_param(token, p, args, mp, &dsunit, &dswidth,
-					 &iosizelog);
-		if (ret)
-			return ret;
-	}
-
 	/*
 	 * no recovery flag requires a read-only mount
 	 */
@@ -600,6 +545,71 @@ xfs_remount_ro(
 	return 0;
 }
 
+/*
+ * This function fills in xfs_mount_t fields based on mount args.
+ * Note: the superblock has _not_ yet been read in.
+ *
+ * Note that this function leaks the various device name allocations on
+ * failure.  The caller takes care of them.
+ *
+ * *sb is const because this is also used to test options on the remount
+ * path, and we don't want this to have any side effects at remount time.
+ * Today this function does not change *sb, but just to future-proof...
+ */
+static int
+xfs_parseargs(
+	struct xfs_mount	*mp,
+	char			*options)
+{
+	const struct super_block *sb = mp->m_super;
+	char			*p;
+	substring_t		args[MAX_OPT_ARGS];
+	int			dsunit = 0;
+	int			dswidth = 0;
+	uint8_t			iosizelog = 0;
+
+	/*
+	 * Copy binary VFS mount flags we are interested in.
+	 */
+	if (sb_rdonly(sb))
+		mp->m_flags |= XFS_MOUNT_RDONLY;
+	if (sb->s_flags & SB_DIRSYNC)
+		mp->m_flags |= XFS_MOUNT_DIRSYNC;
+	if (sb->s_flags & SB_SYNCHRONOUS)
+		mp->m_flags |= XFS_MOUNT_WSYNC;
+
+	/*
+	 * Set some default flags that could be cleared by the mount option
+	 * parsing.
+	 */
+	mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+
+	/*
+	 * These can be overridden by the mount option parsing.
+	 */
+	mp->m_logbufs = -1;
+	mp->m_logbsize = -1;
+
+	if (!options)
+		return 0;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int		token;
+		int		ret;
+
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		ret = xfs_fc_parse_param(token, p, args, mp, &dsunit, &dswidth,
+					 &iosizelog);
+		if (ret)
+			return ret;
+	}
+
+	return xfs_fc_validate_params(mp, dsunit, dswidth, iosizelog);
+}
+
 struct proc_xfs_info {
 	uint64_t	flag;
 	char		*str;

