Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4195322470
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Feb 2021 04:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhBWDCg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Feb 2021 22:02:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230401AbhBWDCf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 22:02:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EEF764E4A;
        Tue, 23 Feb 2021 03:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049314;
        bh=Sv2n5vKRFuNBgkj6Z8+9sm7lRorux2QTS7n5WPPwSCg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CWJG1XPaUyOHVMf68vybNAT1jROU1M3sbOF9u5GsuKbTumb0WGqsw3r5283bIVD2G
         8BZrdPGGBuRWOoVoVGd7Iu39JKXwt0NvpqTST7VWeeeTR741BxNiR1Y57iVuEh5uiu
         DO2uxRbBtQVj4eTSUA7+z0+JvVKsfXwIEtwNVUWoYyFnRJX+B5bD9IMRyO+32UHUgE
         7CgEkHuN2tZY3XjMp5sxRne8wKLhjghgq4XZ4pdo8ABL39W/X8EOQB8qGBuvNW+6iV
         iBHOOnOoM0KLAGuDNp1cWOktYHbf2BSB1EMdNB9uUF5M3QmLlTZbtrXtOjhK2/Sh84
         gVNv/ginsjm6Q==
Subject: [PATCH 5/5] xfs_repair: enable bigtime upgrade via repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@lst.de, bfoster@redhat.com
Date:   Mon, 22 Feb 2021 19:01:53 -0800
Message-ID: <161404931377.425731.15193003623629504162.stgit@magnolia>
In-Reply-To: <161404928523.425731.7157248967184496592.stgit@magnolia>
References: <161404928523.425731.7157248967184496592.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Upgrade existing V5 filesystems to support large timestamps up to 2486.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 man/man8/xfs_admin.8 |    6 ++++++
 repair/globals.c     |    1 +
 repair/globals.h     |    1 +
 repair/phase2.c      |   23 +++++++++++++++++++++++
 repair/xfs_repair.c  |   11 +++++++++++
 5 files changed, 42 insertions(+)


diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 4ba718d8..25437ff1 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -145,6 +145,12 @@ This reduces mount time by speeding up metadata space reservation calculations.
 The filesystem cannot be downgraded after this feature is enabled.
 Once enabled, the filesystem will not be writable by older kernels.
 This feature was added to Linux 5.10.
+.TP 0.4i
+.B bigtime
+Upgrade a filesystem to support larger timestamps up to the year 2486.
+The filesystem cannot be downgraded after this feature is enabled.
+Once enabled, the filesystem will not be mountable by older kernels.
+This feature was added to Linux 5.10.
 .RE
 .TP
 .BI \-U " uuid"
diff --git a/repair/globals.c b/repair/globals.c
index 47d90bd3..506a4e72 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -49,6 +49,7 @@ int	rt_spec;		/* Realtime dev specified as option */
 int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 int	lazy_count;		/* What to set if to if converting */
 bool	add_inobtcount;		/* add inode btree counts to AGI */
+bool	add_bigtime;		/* add support for timestamps up to 2486 */
 
 /* misc status variables */
 
diff --git a/repair/globals.h b/repair/globals.h
index 5b6fe4d4..929b82be 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -90,6 +90,7 @@ extern int	rt_spec;		/* Realtime dev specified as option */
 extern int	convert_lazy_count;	/* Convert lazy-count mode on/off */
 extern int	lazy_count;		/* What to set if to if converting */
 extern bool	add_inobtcount;		/* add inode btree counts to AGI */
+extern bool	add_bigtime;		/* add support for timestamps up to 2486 */
 
 /* misc status variables */
 
diff --git a/repair/phase2.c b/repair/phase2.c
index 96074a1d..cb9adf1d 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -158,6 +158,27 @@ set_inobtcount(
 	return true;
 }
 
+static bool
+set_bigtime(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+		printf(
+	_("Large timestamp feature only supported on V5 filesystems.\n"));
+		exit(0);
+	}
+
+	if (xfs_sb_version_hasbigtime(&mp->m_sb)) {
+		printf(_("Filesystem already supports large timestamps.\n"));
+		exit(0);
+	}
+
+	printf(_("Adding large timestamp support to filesystem.\n"));
+	mp->m_sb.sb_features_incompat |= (XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
+					  XFS_SB_FEAT_INCOMPAT_BIGTIME);
+	return true;
+}
+
 /* Perform the user's requested upgrades on filesystem. */
 static void
 upgrade_filesystem(
@@ -169,6 +190,8 @@ upgrade_filesystem(
 
 	if (add_inobtcount)
 		dirty |= set_inobtcount(mp);
+	if (add_bigtime)
+		dirty |= set_bigtime(mp);
 
         if (no_modify || !dirty)
                 return;
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 8a9caf15..38406eea 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -66,12 +66,14 @@ static char *o_opts[] = {
 enum c_opt_nums {
 	CONVERT_LAZY_COUNT = 0,
 	CONVERT_INOBTCOUNT,
+	CONVERT_BIGTIME,
 	C_MAX_OPTS,
 };
 
 static char *c_opts[] = {
 	[CONVERT_LAZY_COUNT]	= "lazycount",
 	[CONVERT_INOBTCOUNT]	= "inobtcount",
+	[CONVERT_BIGTIME]	= "bigtime",
 	[C_MAX_OPTS]		= NULL,
 };
 
@@ -313,6 +315,15 @@ process_args(int argc, char **argv)
 		_("-c inobtcount only supports upgrades\n"));
 					add_inobtcount = true;
 					break;
+				case CONVERT_BIGTIME:
+					if (!val)
+						do_abort(
+		_("-c bigtime requires a parameter\n"));
+					if (strtol(val, NULL, 0) != 1)
+						do_abort(
+		_("-c bigtime only supports upgrades\n"));
+					add_bigtime = true;
+					break;
 				default:
 					unknown('c', val);
 					break;

