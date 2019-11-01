Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29F5EBEB7
	for <lists+linux-xfs@lfdr.de>; Fri,  1 Nov 2019 08:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbfKAHvq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 Nov 2019 03:51:46 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:9233
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729894AbfKAHvp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 03:51:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AYAACY47td/xK90HYNVxsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgWsEAQEBCwGEPIQoj1oBAQEBAQEGgRGKCIUwAYRthSi?=
 =?us-ascii?q?BewkBAQEBAQEBAQE3AQGDLYEOAwIChB42Bw4CDAEBAQQBAQEBAQUDAYVYhio?=
 =?us-ascii?q?CAQMjBFIQGA0CJgICRxAGE4V1sF51fzMaijeBDigBgWSKRHiBB4FEgx2EKoM?=
 =?us-ascii?q?rgl4EjROCLzeGQUOWdYIulVAMgjCLeAMQix4tqWgJggFNLgqDJ1CDNheOMGe?=
 =?us-ascii?q?MLoI+AQE?=
X-IPAS-Result: =?us-ascii?q?A2AYAACY47td/xK90HYNVxsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgWsEAQEBCwGEPIQoj1oBAQEBAQEGgRGKCIUwAYRthSiBewkBAQEBAQEBA?=
 =?us-ascii?q?QE3AQGDLYEOAwIChB42Bw4CDAEBAQQBAQEBAQUDAYVYhioCAQMjBFIQGA0CJ?=
 =?us-ascii?q?gICRxAGE4V1sF51fzMaijeBDigBgWSKRHiBB4FEgx2EKoMrgl4EjROCLzeGQ?=
 =?us-ascii?q?UOWdYIulVAMgjCLeAMQix4tqWgJggFNLgqDJ1CDNheOMGeMLoI+AQE?=
X-IronPort-AV: E=Sophos;i="5.68,254,1569254400"; 
   d="scan'208";a="215830198"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 01 Nov 2019 15:51:28 +0800
Subject: [PATCH v8 16/16] xfs: move xfs_fc_parse_param() above
 xfs_fc_get_tree()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Fri, 01 Nov 2019 15:51:27 +0800
Message-ID: <157259468795.28278.16467063707250965967.stgit@fedora-28>
In-Reply-To: <157259452909.28278.1001302742832626046.stgit@fedora-28>
References: <157259452909.28278.1001302742832626046.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Grouping the options parsing and mount handling functions above the
struct fs_context_operations but below the struct super_operations
should improve (some) the grouping of the super operations while also
improving the grouping of the options parsing and mount handling code.

Lastly move xfs_fc_parse_param() and related functions down to above
xfs_fc_get_tree() and it's related functions.

But leave the options enum, struct fs_parameter_spec and the struct
fs_parameter_description declarations at the top since that's the
logical place for them.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |  507 ++++++++++++++++++++++++++--------------------------
 1 file changed, 254 insertions(+), 253 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7ff35ee0dc8f..9e587a294656 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -111,259 +111,6 @@ static const struct fs_parameter_description xfs_fs_parameters = {
 	.specs		= xfs_param_specs,
 };
 
-static int
-suffix_kstrtoint(
-	const char	*s,
-	unsigned int	base,
-	int		*res)
-{
-	int		last, shift_left_factor = 0, _res;
-	char		*value;
-	int		ret = 0;
-
-	value = kstrdup(s, GFP_KERNEL);
-	if (!value)
-		return -ENOMEM;
-
-	last = strlen(value) - 1;
-	if (value[last] == 'K' || value[last] == 'k') {
-		shift_left_factor = 10;
-		value[last] = '\0';
-	}
-	if (value[last] == 'M' || value[last] == 'm') {
-		shift_left_factor = 20;
-		value[last] = '\0';
-	}
-	if (value[last] == 'G' || value[last] == 'g') {
-		shift_left_factor = 30;
-		value[last] = '\0';
-	}
-
-	if (kstrtoint(value, base, &_res))
-		ret = -EINVAL;
-	kfree(value);
-	*res = _res << shift_left_factor;
-	return ret;
-}
-
-static int
-xfs_fc_parse_param(
-	struct fs_context	*fc,
-	struct fs_parameter	*param)
-{
-	struct xfs_mount	*mp = fc->s_fs_info;
-	struct fs_parse_result	result;
-	int			size = 0;
-	int			opt;
-
-	opt = fs_parse(fc, &xfs_fs_parameters, param, &result);
-	if (opt < 0)
-		return opt;
-
-	switch (opt) {
-	case Opt_logbufs:
-		mp->m_logbufs = result.uint_32;
-		return 0;
-	case Opt_logbsize:
-		if (suffix_kstrtoint(param->string, 10, &mp->m_logbsize))
-			return -EINVAL;
-		return 0;
-	case Opt_logdev:
-		kfree(mp->m_logname);
-		mp->m_logname = kstrdup(param->string, GFP_KERNEL);
-		if (!mp->m_logname)
-			return -ENOMEM;
-		return 0;
-	case Opt_rtdev:
-		kfree(mp->m_rtname);
-		mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
-		if (!mp->m_rtname)
-			return -ENOMEM;
-		return 0;
-	case Opt_allocsize:
-		if (suffix_kstrtoint(param->string, 10, &size))
-			return -EINVAL;
-		mp->m_allocsize_log = ffs(size) - 1;
-		mp->m_flags |= XFS_MOUNT_ALLOCSIZE;
-		return 0;
-	case Opt_grpid:
-	case Opt_bsdgroups:
-		mp->m_flags |= XFS_MOUNT_GRPID;
-		return 0;
-	case Opt_nogrpid:
-	case Opt_sysvgroups:
-		mp->m_flags &= ~XFS_MOUNT_GRPID;
-		return 0;
-	case Opt_wsync:
-		mp->m_flags |= XFS_MOUNT_WSYNC;
-		return 0;
-	case Opt_norecovery:
-		mp->m_flags |= XFS_MOUNT_NORECOVERY;
-		return 0;
-	case Opt_noalign:
-		mp->m_flags |= XFS_MOUNT_NOALIGN;
-		return 0;
-	case Opt_swalloc:
-		mp->m_flags |= XFS_MOUNT_SWALLOC;
-		return 0;
-	case Opt_sunit:
-		mp->m_dalign = result.uint_32;
-		return 0;
-	case Opt_swidth:
-		mp->m_swidth = result.uint_32;
-		return 0;
-	case Opt_inode32:
-		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
-		return 0;
-	case Opt_inode64:
-		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
-		return 0;
-	case Opt_nouuid:
-		mp->m_flags |= XFS_MOUNT_NOUUID;
-		return 0;
-	case Opt_ikeep:
-		mp->m_flags |= XFS_MOUNT_IKEEP;
-		return 0;
-	case Opt_noikeep:
-		mp->m_flags &= ~XFS_MOUNT_IKEEP;
-		return 0;
-	case Opt_largeio:
-		mp->m_flags |= XFS_MOUNT_LARGEIO;
-		return 0;
-	case Opt_nolargeio:
-		mp->m_flags &= ~XFS_MOUNT_LARGEIO;
-		return 0;
-	case Opt_attr2:
-		mp->m_flags |= XFS_MOUNT_ATTR2;
-		return 0;
-	case Opt_noattr2:
-		mp->m_flags &= ~XFS_MOUNT_ATTR2;
-		mp->m_flags |= XFS_MOUNT_NOATTR2;
-		return 0;
-	case Opt_filestreams:
-		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
-		return 0;
-	case Opt_noquota:
-		mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
-		mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
-		mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
-		return 0;
-	case Opt_quota:
-	case Opt_uquota:
-	case Opt_usrquota:
-		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
-				 XFS_UQUOTA_ENFD);
-		return 0;
-	case Opt_qnoenforce:
-	case Opt_uqnoenforce:
-		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
-		mp->m_qflags &= ~XFS_UQUOTA_ENFD;
-		return 0;
-	case Opt_pquota:
-	case Opt_prjquota:
-		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
-				 XFS_PQUOTA_ENFD);
-		return 0;
-	case Opt_pqnoenforce:
-		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
-		mp->m_qflags &= ~XFS_PQUOTA_ENFD;
-		return 0;
-	case Opt_gquota:
-	case Opt_grpquota:
-		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
-				 XFS_GQUOTA_ENFD);
-		return 0;
-	case Opt_gqnoenforce:
-		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
-		mp->m_qflags &= ~XFS_GQUOTA_ENFD;
-		return 0;
-	case Opt_discard:
-		mp->m_flags |= XFS_MOUNT_DISCARD;
-		return 0;
-	case Opt_nodiscard:
-		mp->m_flags &= ~XFS_MOUNT_DISCARD;
-		return 0;
-#ifdef CONFIG_FS_DAX
-	case Opt_dax:
-		mp->m_flags |= XFS_MOUNT_DAX;
-		return 0;
-#endif
-	default:
-		xfs_warn(mp, "unknown mount option [%s].", param->key);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int
-xfs_fc_validate_params(
-	struct xfs_mount	*mp)
-{
-	/*
-	 * no recovery flag requires a read-only mount
-	 */
-	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
-	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
-		xfs_warn(mp, "no-recovery mounts must be read-only.");
-		return -EINVAL;
-	}
-
-	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
-	    (mp->m_dalign || mp->m_swidth)) {
-		xfs_warn(mp,
-	"sunit and swidth options incompatible with the noalign option");
-		return -EINVAL;
-	}
-
-	if (!IS_ENABLED(CONFIG_XFS_QUOTA) && mp->m_qflags != 0) {
-		xfs_warn(mp, "quota support not available in this kernel.");
-		return -EINVAL;
-	}
-
-	if ((mp->m_dalign && !mp->m_swidth) ||
-	    (!mp->m_dalign && mp->m_swidth)) {
-		xfs_warn(mp, "sunit and swidth must be specified together");
-		return -EINVAL;
-	}
-
-	if (mp->m_dalign && (mp->m_swidth % mp->m_dalign != 0)) {
-		xfs_warn(mp,
-	"stripe width (%d) must be a multiple of the stripe unit (%d)",
-			mp->m_swidth, mp->m_dalign);
-		return -EINVAL;
-	}
-
-	if (mp->m_logbufs != -1 &&
-	    mp->m_logbufs != 0 &&
-	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
-	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
-		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
-			mp->m_logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
-		return -EINVAL;
-	}
-	if (mp->m_logbsize != -1 &&
-	    mp->m_logbsize !=  0 &&
-	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
-	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
-	     !is_power_of_2(mp->m_logbsize))) {
-		xfs_warn(mp,
-			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
-			mp->m_logbsize);
-		return -EINVAL;
-	}
-
-	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) &&
-	    (mp->m_allocsize_log > XFS_MAX_IO_LOG ||
-	     mp->m_allocsize_log < XFS_MIN_IO_LOG)) {
-		xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
-			mp->m_allocsize_log, XFS_MIN_IO_LOG, XFS_MAX_IO_LOG);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 struct proc_xfs_info {
 	uint64_t	flag;
 	char		*str;
@@ -1378,6 +1125,260 @@ xfs_mount_alloc(void)
 	return mp;
 }
 
+static int
+suffix_kstrtoint(
+	const char	*s,
+	unsigned int	base,
+	int		*res)
+{
+	int		last, shift_left_factor = 0, _res;
+	char		*value;
+	int		ret = 0;
+
+	value = kstrdup(s, GFP_KERNEL);
+	if (!value)
+		return -ENOMEM;
+
+	last = strlen(value) - 1;
+	if (value[last] == 'K' || value[last] == 'k') {
+		shift_left_factor = 10;
+		value[last] = '\0';
+	}
+	if (value[last] == 'M' || value[last] == 'm') {
+		shift_left_factor = 20;
+		value[last] = '\0';
+	}
+	if (value[last] == 'G' || value[last] == 'g') {
+		shift_left_factor = 30;
+		value[last] = '\0';
+	}
+
+	if (kstrtoint(value, base, &_res))
+		ret = -EINVAL;
+	kfree(value);
+	*res = _res << shift_left_factor;
+	return ret;
+}
+
+static int
+xfs_fc_parse_param(
+	struct fs_context	*fc,
+	struct fs_parameter	*param)
+{
+	struct xfs_mount	*mp = fc->s_fs_info;
+	struct fs_parse_result	result;
+	int			size = 0;
+	int			opt;
+
+	opt = fs_parse(fc, &xfs_fs_parameters, param, &result);
+	if (opt < 0)
+		return opt;
+
+	switch (opt) {
+	case Opt_logbufs:
+		mp->m_logbufs = result.uint_32;
+		return 0;
+	case Opt_logbsize:
+		if (suffix_kstrtoint(param->string, 10, &mp->m_logbsize))
+			return -EINVAL;
+		return 0;
+	case Opt_logdev:
+		kfree(mp->m_logname);
+		mp->m_logname = kstrdup(param->string, GFP_KERNEL);
+		if (!mp->m_logname)
+			return -ENOMEM;
+		return 0;
+	case Opt_rtdev:
+		kfree(mp->m_rtname);
+		mp->m_rtname = kstrdup(param->string, GFP_KERNEL);
+		if (!mp->m_rtname)
+			return -ENOMEM;
+		return 0;
+	case Opt_allocsize:
+		if (suffix_kstrtoint(param->string, 10, &size))
+			return -EINVAL;
+		mp->m_allocsize_log = ffs(size) - 1;
+		mp->m_flags |= XFS_MOUNT_ALLOCSIZE;
+		return 0;
+	case Opt_grpid:
+	case Opt_bsdgroups:
+		mp->m_flags |= XFS_MOUNT_GRPID;
+		return 0;
+	case Opt_nogrpid:
+	case Opt_sysvgroups:
+		mp->m_flags &= ~XFS_MOUNT_GRPID;
+		return 0;
+	case Opt_wsync:
+		mp->m_flags |= XFS_MOUNT_WSYNC;
+		return 0;
+	case Opt_norecovery:
+		mp->m_flags |= XFS_MOUNT_NORECOVERY;
+		return 0;
+	case Opt_noalign:
+		mp->m_flags |= XFS_MOUNT_NOALIGN;
+		return 0;
+	case Opt_swalloc:
+		mp->m_flags |= XFS_MOUNT_SWALLOC;
+		return 0;
+	case Opt_sunit:
+		mp->m_dalign = result.uint_32;
+		return 0;
+	case Opt_swidth:
+		mp->m_swidth = result.uint_32;
+		return 0;
+	case Opt_inode32:
+		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
+		return 0;
+	case Opt_inode64:
+		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
+		return 0;
+	case Opt_nouuid:
+		mp->m_flags |= XFS_MOUNT_NOUUID;
+		return 0;
+	case Opt_ikeep:
+		mp->m_flags |= XFS_MOUNT_IKEEP;
+		return 0;
+	case Opt_noikeep:
+		mp->m_flags &= ~XFS_MOUNT_IKEEP;
+		return 0;
+	case Opt_largeio:
+		mp->m_flags |= XFS_MOUNT_LARGEIO;
+		return 0;
+	case Opt_nolargeio:
+		mp->m_flags &= ~XFS_MOUNT_LARGEIO;
+		return 0;
+	case Opt_attr2:
+		mp->m_flags |= XFS_MOUNT_ATTR2;
+		return 0;
+	case Opt_noattr2:
+		mp->m_flags &= ~XFS_MOUNT_ATTR2;
+		mp->m_flags |= XFS_MOUNT_NOATTR2;
+		return 0;
+	case Opt_filestreams:
+		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
+		return 0;
+	case Opt_noquota:
+		mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
+		mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
+		mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
+		return 0;
+	case Opt_quota:
+	case Opt_uquota:
+	case Opt_usrquota:
+		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
+				 XFS_UQUOTA_ENFD);
+		return 0;
+	case Opt_qnoenforce:
+	case Opt_uqnoenforce:
+		mp->m_qflags |= (XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE);
+		mp->m_qflags &= ~XFS_UQUOTA_ENFD;
+		return 0;
+	case Opt_pquota:
+	case Opt_prjquota:
+		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
+				 XFS_PQUOTA_ENFD);
+		return 0;
+	case Opt_pqnoenforce:
+		mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
+		mp->m_qflags &= ~XFS_PQUOTA_ENFD;
+		return 0;
+	case Opt_gquota:
+	case Opt_grpquota:
+		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
+				 XFS_GQUOTA_ENFD);
+		return 0;
+	case Opt_gqnoenforce:
+		mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE);
+		mp->m_qflags &= ~XFS_GQUOTA_ENFD;
+		return 0;
+	case Opt_discard:
+		mp->m_flags |= XFS_MOUNT_DISCARD;
+		return 0;
+	case Opt_nodiscard:
+		mp->m_flags &= ~XFS_MOUNT_DISCARD;
+		return 0;
+#ifdef CONFIG_FS_DAX
+	case Opt_dax:
+		mp->m_flags |= XFS_MOUNT_DAX;
+		return 0;
+#endif
+	default:
+		xfs_warn(mp, "unknown mount option [%s].", param->key);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+xfs_fc_validate_params(
+	struct xfs_mount	*mp)
+{
+	/*
+	 * no recovery flag requires a read-only mount
+	 */
+	if ((mp->m_flags & XFS_MOUNT_NORECOVERY) &&
+	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		xfs_warn(mp, "no-recovery mounts must be read-only.");
+		return -EINVAL;
+	}
+
+	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
+	    (mp->m_dalign || mp->m_swidth)) {
+		xfs_warn(mp,
+	"sunit and swidth options incompatible with the noalign option");
+		return -EINVAL;
+	}
+
+	if (!IS_ENABLED(CONFIG_XFS_QUOTA) && mp->m_qflags != 0) {
+		xfs_warn(mp, "quota support not available in this kernel.");
+		return -EINVAL;
+	}
+
+	if ((mp->m_dalign && !mp->m_swidth) ||
+	    (!mp->m_dalign && mp->m_swidth)) {
+		xfs_warn(mp, "sunit and swidth must be specified together");
+		return -EINVAL;
+	}
+
+	if (mp->m_dalign && (mp->m_swidth % mp->m_dalign != 0)) {
+		xfs_warn(mp,
+	"stripe width (%d) must be a multiple of the stripe unit (%d)",
+			mp->m_swidth, mp->m_dalign);
+		return -EINVAL;
+	}
+
+	if (mp->m_logbufs != -1 &&
+	    mp->m_logbufs != 0 &&
+	    (mp->m_logbufs < XLOG_MIN_ICLOGS ||
+	     mp->m_logbufs > XLOG_MAX_ICLOGS)) {
+		xfs_warn(mp, "invalid logbufs value: %d [not %d-%d]",
+			mp->m_logbufs, XLOG_MIN_ICLOGS, XLOG_MAX_ICLOGS);
+		return -EINVAL;
+	}
+
+	if (mp->m_logbsize != -1 &&
+	    mp->m_logbsize !=  0 &&
+	    (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
+	     mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
+	     !is_power_of_2(mp->m_logbsize))) {
+		xfs_warn(mp,
+			"invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
+			mp->m_logbsize);
+		return -EINVAL;
+	}
+
+	if ((mp->m_flags & XFS_MOUNT_ALLOCSIZE) &&
+	    (mp->m_allocsize_log > XFS_MAX_IO_LOG ||
+	     mp->m_allocsize_log < XFS_MIN_IO_LOG)) {
+		xfs_warn(mp, "invalid log iosize: %d [not %d-%d]",
+			mp->m_allocsize_log, XFS_MIN_IO_LOG, XFS_MAX_IO_LOG);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int
 xfs_fc_fill_super(
 	struct super_block	*sb,

