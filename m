Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5FE4B8E1C
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Sep 2019 11:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437956AbfITJ4H (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 20 Sep 2019 05:56:07 -0400
Received: from icp-osb-irony-out5.external.iinet.net.au ([203.59.1.221]:6242
        "EHLO icp-osb-irony-out5.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408596AbfITJ4H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Sep 2019 05:56:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AUAADfoYRd/zmr0HYNVxwBAQEEAQE?=
 =?us-ascii?q?HBAEBgVMHAQELAQGEMoQiiByHSwEBBoERgSOId4Ufig6BewkBAQEBAQEBAQE?=
 =?us-ascii?q?3AQGEOgMCAoMqNAkOAgwBAQEEAQEBAQEFAwGFWIEQARABhHcCAQMjBFIQGA0?=
 =?us-ascii?q?CJgICRxAGE4UZqwZzfzMaii6BDCgBgWKKPniBB4ERM4Iqc4dPglgEjG0EgmW?=
 =?us-ascii?q?FTV9ClkeCLIwZiQwMgiqLXQMQin4thAakdoIQTS4KgydQgiqOGmaCa4ltKoI?=
 =?us-ascii?q?qAQE?=
X-IPAS-Result: =?us-ascii?q?A2AUAADfoYRd/zmr0HYNVxwBAQEEAQEHBAEBgVMHAQELA?=
 =?us-ascii?q?QGEMoQiiByHSwEBBoERgSOId4Ufig6BewkBAQEBAQEBAQE3AQGEOgMCAoMqN?=
 =?us-ascii?q?AkOAgwBAQEEAQEBAQEFAwGFWIEQARABhHcCAQMjBFIQGA0CJgICRxAGE4UZq?=
 =?us-ascii?q?wZzfzMaii6BDCgBgWKKPniBB4ERM4Iqc4dPglgEjG0EgmWFTV9ClkeCLIwZi?=
 =?us-ascii?q?QwMgiqLXQMQin4thAakdoIQTS4KgydQgiqOGmaCa4ltKoIqAQE?=
X-IronPort-AV: E=Sophos;i="5.64,528,1559491200"; 
   d="scan'208";a="253491486"
Received: from unknown (HELO [192.168.1.222]) ([118.208.171.57])
  by icp-osb-irony-out5.iinet.net.au with ESMTP; 20 Sep 2019 17:56:04 +0800
Subject: [PATCH v3 06/16] xfs: mount-api - make xfs_parse_param() take
 context .parse_param() args
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 20 Sep 2019 17:56:04 +0800
Message-ID: <156897336458.20210.16236394963116388337.stgit@fedora-28>
In-Reply-To: <156897321789.20210.339237101446767141.stgit@fedora-28>
References: <156897321789.20210.339237101446767141.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make xfs_parse_param() take arguments of the fs context operation
.parse_param() in preparation for switching to use the file system
mount context for mount.

The function fc_parse() only uses the file system context (fc here)
when calling log macros warnf() and invalf() which in turn check
only the fc->log field to determine if the message should be saved
to a context buffer (for later retrival by userspace) or logged
using printk().

Also the temporary function match_kstrtoint() is now unused, remove it.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |  135 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 79 insertions(+), 56 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b04aebab69ab..041ab8b52a7d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -191,57 +191,60 @@ suffix_kstrtoint(const char *s, unsigned int base, int *res)
 	return ret;
 }
 
-STATIC int
-match_kstrtoint(const substring_t *s, unsigned int base, int *res)
-{
-	const char	*value;
-	int ret;
-
-	value = match_strdup(s);
-	if (!value)
-		return -ENOMEM;
-	ret = suffix_kstrtoint(value, base, res);
-	kfree(value);
-	return ret;
-}
+struct xfs_fs_context {
+	int	dsunit;
+	int	dswidth;
+	uint8_t	iosizelog;
+};
 
 STATIC int
 xfs_parse_param(
-	int			token,
-	char			*p,
-	substring_t		*args,
-	struct xfs_mount	*mp,
-	int			*dsunit,
-	int			*dswidth,
-	uint8_t			*iosizelog)
+	struct fs_context	*fc,
+	struct fs_parameter	*param)
 {
+	struct xfs_fs_context	*ctx = fc->fs_private;
+	struct xfs_mount	*mp = fc->s_fs_info;
+	struct fs_parse_result	result;
 	int			iosize = 0;
+	int			opt;
 
-	switch (token) {
+	opt = fs_parse(fc, &xfs_fs_parameters, param, &result);
+	if (opt < 0) {
+		/*
+		 * If fs_parse() returns -ENOPARAM and the parameter
+		 * is "source" the VFS needs to handle this option
+		 * in order to boot otherwise use the default case
+		 * below to handle invalid options.
+		 */
+		if (opt != -ENOPARAM ||
+		    strcmp(param->key, "source") == 0)
+			return opt;
+	}
+
+	switch (opt) {
 	case Opt_logbufs:
-		if (match_int(args, &mp->m_logbufs))
-			return -EINVAL;
+		mp->m_logbufs = result.uint_32;
 		break;
 	case Opt_logbsize:
-		if (match_kstrtoint(args, 10, &mp->m_logbsize))
+		if (suffix_kstrtoint(param->string, 10, &mp->m_logbsize))
 			return -EINVAL;
 		break;
 	case Opt_logdev:
 		kfree(mp->m_logname);
-		mp->m_logname = match_strdup(args);
+		mp->m_logname = kstrdup(param->string, GFP_KERNEL);
 		if (!mp->m_logname)
 			return -ENOMEM;
 		break;
 	case Opt_rtdev:
 		kfree(mp->m_rtname);
-		mp->m_rtname = match_strdup(args);
+		mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
 		if (!mp->m_rtname)
 			return -ENOMEM;
 		break;
 	case Opt_allocsize:
-		if (match_kstrtoint(args, 10, &iosize))
+		if (suffix_kstrtoint(param->string, 10, &iosize))
 			return -EINVAL;
-		*iosizelog = ffs(iosize) - 1;
+		ctx->iosizelog = ffs(iosize) - 1;
 		break;
 	case Opt_grpid:
 	case Opt_bsdgroups:
@@ -264,12 +267,10 @@ xfs_parse_param(
 		mp->m_flags |= XFS_MOUNT_SWALLOC;
 		break;
 	case Opt_sunit:
-		if (match_int(args, dsunit))
-			return -EINVAL;
+		ctx->dsunit = result.uint_32;
 		break;
 	case Opt_swidth:
-		if (match_int(args, dswidth))
-			return -EINVAL;
+		ctx->dswidth = result.uint_32;
 		break;
 	case Opt_inode32:
 		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
@@ -348,7 +349,7 @@ xfs_parse_param(
 		break;
 #endif
 	default:
-		xfs_warn(mp, "unknown mount option [%s].", p);
+		xfs_warn(mp, "unknown mount option [%s].", param->key);
 		return -EINVAL;
 	}
 
@@ -373,10 +374,13 @@ xfs_parseargs(
 {
 	const struct super_block *sb = mp->m_super;
 	char			*p;
-	substring_t		args[MAX_OPT_ARGS];
-	int			dsunit = 0;
-	int			dswidth = 0;
-	uint8_t			iosizelog = 0;
+	struct fs_context	fc;
+	struct xfs_fs_context	context;
+
+	memset(&fc, 0, sizeof(fc));
+	memset(&context, 0, sizeof(context));
+	fc.fs_private = &context;
+	fc.s_fs_info = mp;
 
 	/*
 	 * set up the mount name first so all the errors will refer to the
@@ -413,16 +417,34 @@ xfs_parseargs(
 		goto done;
 
 	while ((p = strsep(&options, ",")) != NULL) {
-		int		token;
-		int		ret;
+		struct fs_parameter	param;
+		char			*value;
+		int			ret;
 
 		if (!*p)
 			continue;
 
-		token = match_token(p, tokens, args);
-		ret = xfs_parse_param(token, p, args, mp,
-				      &dsunit, &dswidth, &iosizelog);
-		if (ret)
+		param.key = p;
+		param.type = fs_value_is_string;
+		param.string = NULL;
+		param.size = 0;
+
+		value = strchr(p, '=');
+		if (value) {
+			*value++ = 0;
+			param.size = strlen(value);
+			if (param.size > 0) {
+				param.string = kmemdup_nul(value,
+							   param.size,
+							   GFP_KERNEL);
+				if (!param.string)
+					return -ENOMEM;
+			}
+		}
+
+		ret = xfs_parse_param(&fc, &param);
+		kfree(param.string);
+		if (ret < 0)
 			return ret;
 	}
 
@@ -435,7 +457,8 @@ xfs_parseargs(
 		return -EINVAL;
 	}
 
-	if ((mp->m_flags & XFS_MOUNT_NOALIGN) && (dsunit || dswidth)) {
+	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
+	    (ctx->dsunit || ctx->dswidth)) {
 		xfs_warn(mp,
 	"sunit and swidth options incompatible with the noalign option");
 		return -EINVAL;
@@ -448,28 +471,28 @@ xfs_parseargs(
 	}
 #endif
 
-	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
+	if ((ctx->dsunit && !ctx->dswidth) || (!ctx->dsunit && ctx->dswidth)) {
 		xfs_warn(mp, "sunit and swidth must be specified together");
 		return -EINVAL;
 	}
 
-	if (dsunit && (dswidth % dsunit != 0)) {
+	if (ctx->dsunit && (ctx->dswidth % ctx->dsunit != 0)) {
 		xfs_warn(mp,
 	"stripe width (%d) must be a multiple of the stripe unit (%d)",
-			dswidth, dsunit);
+			ctx->dswidth, ctx->dsunit);
 		return -EINVAL;
 	}
 
 done:
-	if (dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
+	if (ctx->dsunit && !(mp->m_flags & XFS_MOUNT_NOALIGN)) {
 		/*
 		 * At this point the superblock has not been read
 		 * in, therefore we do not know the block size.
 		 * Before the mount call ends we will convert
 		 * these to FSBs.
 		 */
-		mp->m_dalign = dsunit;
-		mp->m_swidth = dswidth;
+		mp->m_dalign = ctx->dsunit;
+		mp->m_swidth = ctx->dswidth;
 	}
 
 	if (mp->m_logbufs != -1 &&
@@ -491,18 +514,18 @@ xfs_parseargs(
 		return -EINVAL;
 	}
 
-	if (iosizelog) {
-		if (iosizelog > XFS_MAX_IO_LOG ||
-		    iosizelog < XFS_MIN_IO_LOG) {
+	if (ctx->iosizelog) {
+		if (ctx->iosizelog > XFS_MAX_IO_LOG ||
+		    ctx->iosizelog < XFS_MIN_IO_LOG) {
 			xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
-				iosizelog, XFS_MIN_IO_LOG,
+				ctx->iosizelog, XFS_MIN_IO_LOG,
 				XFS_MAX_IO_LOG);
 			return -EINVAL;
 		}
 
 		mp->m_flags |= XFS_MOUNT_DFLT_IOSIZE;
-		mp->m_readio_log = iosizelog;
-		mp->m_writeio_log = iosizelog;
+		mp->m_readio_log = ctx->iosizelog;
+		mp->m_writeio_log = ctx->iosizelog;
 	}
 
 	return 0;

