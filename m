Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B889C9C33
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Oct 2019 12:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbfJCKZ5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 3 Oct 2019 06:25:57 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:42874
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726039AbfJCKZ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Oct 2019 06:25:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AVAADHy5Vd/7q70HYNWRwBAQEEAQE?=
 =?us-ascii?q?MBAEBgVMHAQELAYQ5hCKIIocIAwaBEYoajzGBewkBAQEBAQEBAQE3AQGEOwM?=
 =?us-ascii?q?CAoJoNAkOAgwBAQEEAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkcQBhOFGa4?=
 =?us-ascii?q?MdX8zGoongQwoAYFkikF4gQeBETODHYdRglgEjQGCLzeGOUOWVIItlTMMgi2?=
 =?us-ascii?q?LZgMQiwwthAqlHYIRTS4KgydQkEZnkRsBAQ?=
X-IPAS-Result: =?us-ascii?q?A2AVAADHy5Vd/7q70HYNWRwBAQEEAQEMBAEBgVMHAQELA?=
 =?us-ascii?q?YQ5hCKIIocIAwaBEYoajzGBewkBAQEBAQEBAQE3AQGEOwMCAoJoNAkOAgwBA?=
 =?us-ascii?q?QEEAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkcQBhOFGa4MdX8zGoongQwoA?=
 =?us-ascii?q?YFkikF4gQeBETODHYdRglgEjQGCLzeGOUOWVIItlTMMgi2LZgMQiwwthAqlH?=
 =?us-ascii?q?YIRTS4KgydQkEZnkRsBAQ?=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="207652754"
Received: from unknown (HELO [192.168.1.222]) ([118.208.187.186])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 03 Oct 2019 18:25:51 +0800
Subject: [PATCH v4 06/17] xfs: mount-api - refactor xfs_parseags()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 03 Oct 2019 18:25:50 +0800
Message-ID: <157009835067.13858.14000695071043725089.stgit@fedora-28>
In-Reply-To: <157009817203.13858.7783767645177567968.stgit@fedora-28>
References: <157009817203.13858.7783767645177567968.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Refactor xfs_parseags(), move the entire token case block to a
separate function in an attempt to highlight the code that
actually changes in converting to use the new mount api.

The only changes are what's needed to communicate the variables
dsunit, dswidth and iosizelog back to xfs_parseags().

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c |  290 ++++++++++++++++++++++++++++------------------------
 1 file changed, 155 insertions(+), 135 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 6a16750b1314..b04aebab69ab 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -205,6 +205,156 @@ match_kstrtoint(const substring_t *s, unsigned int base, int *res)
 	return ret;
 }
 
+STATIC int
+xfs_parse_param(
+	int			token,
+	char			*p,
+	substring_t		*args,
+	struct xfs_mount	*mp,
+	int			*dsunit,
+	int			*dswidth,
+	uint8_t			*iosizelog)
+{
+	int			iosize = 0;
+
+	switch (token) {
+	case Opt_logbufs:
+		if (match_int(args, &mp->m_logbufs))
+			return -EINVAL;
+		break;
+	case Opt_logbsize:
+		if (match_kstrtoint(args, 10, &mp->m_logbsize))
+			return -EINVAL;
+		break;
+	case Opt_logdev:
+		kfree(mp->m_logname);
+		mp->m_logname = match_strdup(args);
+		if (!mp->m_logname)
+			return -ENOMEM;
+		break;
+	case Opt_rtdev:
+		kfree(mp->m_rtname);
+		mp->m_rtname = match_strdup(args);
+		if (!mp->m_rtname)
+			return -ENOMEM;
+		break;
+	case Opt_allocsize:
+		if (match_kstrtoint(args, 10, &iosize))
+			return -EINVAL;
+		*iosizelog = ffs(iosize) - 1;
+		break;
+	case Opt_grpid:
+	case Opt_bsdgroups:
+		mp->m_flags |= XFS_MOUNT_GRPID;
+		break;
+	case Opt_nogrpid:
+	case Opt_sysvgroups:
+		mp->m_flags &= ~XFS_MOUNT_GRPID;
+		break;
+	case Opt_wsync:
+		mp->m_flags |= XFS_MOUNT_WSYNC;
+		break;
+	case Opt_norecovery:
+		mp->m_flags |= XFS_MOUNT_NORECOVERY;
+		break;
+	case Opt_noalign:
+		mp->m_flags |= XFS_MOUNT_NOALIGN;
+		break;
+	case Opt_swalloc:
+		mp->m_flags |= XFS_MOUNT_SWALLOC;
+		break;
+	case Opt_sunit:
+		if (match_int(args, dsunit))
+			return -EINVAL;
+		break;
+	case Opt_swidth:
+		if (match_int(args, dswidth))
+			return -EINVAL;
+		break;
+	case Opt_inode32:
+		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+		break;
+	case Opt_inode64:
+		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
+		break;
+	case Opt_nouuid:
+		mp->m_flags |= XFS_MOUNT_NOUUID;
+		break;
+	case Opt_ikeep:
+		mp->m_flags |= XFS_MOUNT_IKEEP;
+		break;
+	case Opt_noikeep:
+		mp->m_flags &= ~XFS_MOUNT_IKEEP;
+		break;
+	case Opt_largeio:
+		mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
+		break;
+	case Opt_nolargeio:
+		mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
+		break;
+	case Opt_attr2:
+		mp->m_flags |= XFS_MOUNT_ATTR2;
+		break;
+	case Opt_noattr2:
+		mp->m_flags &= ~XFS_MOUNT_ATTR2;
+		mp->m_flags |= XFS_MOUNT_NOATTR2;
+		break;
+	case Opt_filestreams:
+		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
+		break;
+	case Opt_noquota:
+		mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
+		mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
+		mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
+		break;
+	case Opt_quota:
+	case Opt_uquota:
+	case Opt_usrquota:
+		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
+				 XFS_UQUOTA_ENFD);
+		break;
+	case Opt_qnoenforce:
+	case Opt_uqnoenforce:
+		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
+		mp->m_qflags &= ~XFS_UQUOTA_ENFD;
+		break;
+	case Opt_pquota:
+	case Opt_prjquota:
+		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
+				 XFS_PQUOTA_ENFD);
+		break;
+	case Opt_pqnoenforce:
+		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
+		mp->m_qflags &= ~XFS_PQUOTA_ENFD;
+		break;
+	case Opt_gquota:
+	case Opt_grpquota:
+		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
+				 XFS_GQUOTA_ENFD);
+		break;
+	case Opt_gqnoenforce:
+		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
+		mp->m_qflags &= ~XFS_GQUOTA_ENFD;
+		break;
+	case Opt_discard:
+		mp->m_flags |= XFS_MOUNT_DISCARD;
+		break;
+	case Opt_nodiscard:
+		mp->m_flags &= ~XFS_MOUNT_DISCARD;
+		break;
+#ifdef CONFIG_FS_DAX
+	case Opt_dax:
+		mp->m_flags |= XFS_MOUNT_DAX;
+		break;
+#endif
+	default:
+		xfs_warn(mp, "unknown mount option [%s].", p);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /*
  * This function fills in xfs_mount_t fields based on mount args.
  * Note: the superblock has _not_ yet been read in.
@@ -226,7 +376,6 @@ xfs_parseargs(
 	substring_t		args[MAX_OPT_ARGS];
 	int			dsunit = 0;
 	int			dswidth = 0;
-	int			iosize = 0;
 	uint8_t			iosizelog = 0;
 
 	/*
@@ -265,145 +414,16 @@ xfs_parseargs(
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int		token;
+		int		ret;
 
 		if (!*p)
 			continue;
 
 		token = match_token(p, tokens, args);
-		switch (token) {
-		case Opt_logbufs:
-			if (match_int(args, &mp->m_logbufs))
-				return -EINVAL;
-			break;
-		case Opt_logbsize:
-			if (match_kstrtoint(args, 10, &mp->m_logbsize))
-				return -EINVAL;
-			break;
-		case Opt_logdev:
-			kfree(mp->m_logname);
-			mp->m_logname = match_strdup(args);
-			if (!mp->m_logname)
-				return -ENOMEM;
-			break;
-		case Opt_rtdev:
-			kfree(mp->m_rtname);
-			mp->m_rtname = match_strdup(args);
-			if (!mp->m_rtname)
-				return -ENOMEM;
-			break;
-		case Opt_allocsize:
-			if (match_kstrtoint(args, 10, &iosize))
-				return -EINVAL;
-			iosizelog = ffs(iosize) - 1;
-			break;
-		case Opt_grpid:
-		case Opt_bsdgroups:
-			mp->m_flags |= XFS_MOUNT_GRPID;
-			break;
-		case Opt_nogrpid:
-		case Opt_sysvgroups:
-			mp->m_flags &= ~XFS_MOUNT_GRPID;
-			break;
-		case Opt_wsync:
-			mp->m_flags |= XFS_MOUNT_WSYNC;
-			break;
-		case Opt_norecovery:
-			mp->m_flags |= XFS_MOUNT_NORECOVERY;
-			break;
-		case Opt_noalign:
-			mp->m_flags |= XFS_MOUNT_NOALIGN;
-			break;
-		case Opt_swalloc:
-			mp->m_flags |= XFS_MOUNT_SWALLOC;
-			break;
-		case Opt_sunit:
-			if (match_int(args, &dsunit))
-				return -EINVAL;
-			break;
-		case Opt_swidth:
-			if (match_int(args, &dswidth))
-				return -EINVAL;
-			break;
-		case Opt_inode32:
-			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
-			break;
-		case Opt_inode64:
-			mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
-			break;
-		case Opt_nouuid:
-			mp->m_flags |= XFS_MOUNT_NOUUID;
-			break;
-		case Opt_ikeep:
-			mp->m_flags |= XFS_MOUNT_IKEEP;
-			break;
-		case Opt_noikeep:
-			mp->m_flags &= ~XFS_MOUNT_IKEEP;
-			break;
-		case Opt_largeio:
-			mp->m_flags &= ~XFS_MOUNT_COMPAT_IOSIZE;
-			break;
-		case Opt_nolargeio:
-			mp->m_flags |= XFS_MOUNT_COMPAT_IOSIZE;
-			break;
-		case Opt_attr2:
-			mp->m_flags |= XFS_MOUNT_ATTR2;
-			break;
-		case Opt_noattr2:
-			mp->m_flags &= ~XFS_MOUNT_ATTR2;
-			mp->m_flags |= XFS_MOUNT_NOATTR2;
-			break;
-		case Opt_filestreams:
-			mp->m_flags |= XFS_MOUNT_FILESTREAMS;
-			break;
-		case Opt_noquota:
-			mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
-			mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
-			mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
-			break;
-		case Opt_quota:
-		case Opt_uquota:
-		case Opt_usrquota:
-			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
-					 XFS_UQUOTA_ENFD);
-			break;
-		case Opt_qnoenforce:
-		case Opt_uqnoenforce:
-			mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
-			mp->m_qflags &= ~XFS_UQUOTA_ENFD;
-			break;
-		case Opt_pquota:
-		case Opt_prjquota:
-			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
-					 XFS_PQUOTA_ENFD);
-			break;
-		case Opt_pqnoenforce:
-			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
-			mp->m_qflags &= ~XFS_PQUOTA_ENFD;
-			break;
-		case Opt_gquota:
-		case Opt_grpquota:
-			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
-					 XFS_GQUOTA_ENFD);
-			break;
-		case Opt_gqnoenforce:
-			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
-			mp->m_qflags &= ~XFS_GQUOTA_ENFD;
-			break;
-		case Opt_discard:
-			mp->m_flags |= XFS_MOUNT_DISCARD;
-			break;
-		case Opt_nodiscard:
-			mp->m_flags &= ~XFS_MOUNT_DISCARD;
-			break;
-#ifdef CONFIG_FS_DAX
-		case Opt_dax:
-			mp->m_flags |= XFS_MOUNT_DAX;
-			break;
-#endif
-		default:
-			xfs_warn(mp, "unknown mount option [%s].", p);
-			return -EINVAL;
-		}
+		ret = xfs_parse_param(token, p, args, mp,
+				      &dsunit, &dswidth, &iosizelog);
+		if (ret)
+			return ret;
 	}
 
 	/*

