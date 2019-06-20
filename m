Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF9994D429
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 18:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731773AbfFTQuG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 12:50:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54416 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfFTQuG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:50:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGnM4Y173815;
        Thu, 20 Jun 2019 16:50:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=U5wDuznWFPvM9tph7fi7ryucbFBNDvi5kovDxTpR4xE=;
 b=EPo/civ4mzXlBbnIehTkXaS6Lzaen9Bf5/8A4VmroLwAdIJDwqHufN8m2QjAg5zH9fWT
 zFLncgec7s6DJJ1Posi0VS5lY4nnd/OjYSKpBPCezXdky+NHkiiTpHQS5gyKvNKmtKG+
 ZqxNohZVvft6asmME8AhdZpFYDL0GFOnnhNAPe7h2r+0ISq9kHGhvgkz2g/QVPQcYi2K
 7x8c93gxHiLSM/tFsjMBrENYthEfaOsPezb62TarzyLMtiHEMblqbnRzDoRcFdRWJtk1
 R2GsRKwl6bu+pSA5NZof1OarUjho079M6yIpvTPKLlmqUC3guLkJr4+sPBbdreRADjKr VA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t7809j772-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:50:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGneaj057813;
        Thu, 20 Jun 2019 16:50:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2t77ynqp61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:50:03 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5KGo2f9024490;
        Thu, 20 Jun 2019 16:50:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 09:50:02 -0700
Subject: [PATCH 05/12] libfrog: store more inode and block geometry in
 struct xfrog
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 20 Jun 2019 09:50:01 -0700
Message-ID: <156104940145.1172531.5596841620134065896.stgit@magnolia>
In-Reply-To: <156104936953.1172531.2121427277342917243.stgit@magnolia>
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906200122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906200122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the extra AG geometry fields out of scrub and into the libfrog code
so that we can consolidate the geoemtry code in one place.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfrog.h    |   12 ++++++++++++
 libfrog/fsgeom.c   |   13 ++++++++++++-
 scrub/fscounters.c |    4 ++--
 scrub/inodes.c     |    4 ++--
 scrub/phase1.c     |    5 -----
 scrub/phase3.c     |    6 +++---
 scrub/phase5.c     |    4 ++--
 scrub/phase6.c     |    2 +-
 scrub/phase7.c     |    6 +++---
 scrub/xfs_scrub.h  |    4 ----
 10 files changed, 37 insertions(+), 23 deletions(-)


diff --git a/include/xfrog.h b/include/xfrog.h
index e450ee1d..507f27a4 100644
--- a/include/xfrog.h
+++ b/include/xfrog.h
@@ -30,6 +30,18 @@ struct xfrog {
 
 	/* filesystem geometry */
 	struct xfs_fsop_geom	fsgeom;
+
+	/* log2 of sb_agblocks (rounded up) */
+	unsigned int		agblklog;
+
+	/* log2 of sb_blocksize */
+	unsigned int		blocklog;
+
+	/* log2 of sb_inodesize */
+	unsigned int		inodelog;
+
+	/* log2 of sb_inopblock */
+	unsigned int		inopblog;
 };
 
 /* Static initializers */
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index bf76b520..28e4fd62 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -5,6 +5,7 @@
 #include "libxfs.h"
 #include "fsgeom.h"
 #include "xfrog.h"
+#include "libfrog.h"
 
 void
 xfs_report_geom(
@@ -94,7 +95,17 @@ int
 xfrog_prepare_geometry(
 	struct xfrog		*froggie)
 {
-	return xfrog_geometry(froggie->fd, &froggie->fsgeom);
+	int			ret;
+
+	ret = xfrog_geometry(froggie->fd, &froggie->fsgeom);
+	if (ret)
+		return ret;
+
+	froggie->agblklog = log2_roundup(froggie->fsgeom.agblocks);
+	froggie->blocklog = highbit32(froggie->fsgeom.blocksize);
+	froggie->inodelog = highbit32(froggie->fsgeom.inodesize);
+	froggie->inopblog = froggie->blocklog - froggie->inodelog;
+	return 0;
 }
 
 /* Release any resources associated with this xfrog structure. */
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index f18d0e19..ac898764 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -91,8 +91,8 @@ xfs_count_ag_inodes(
 				minor(ctx->fsinfo.fs_datadev),
 				agno);
 
-	ag_ino = (__u64)agno << (ctx->inopblog + ctx->agblklog);
-	next_ag_ino = (__u64)(agno + 1) << (ctx->inopblog + ctx->agblklog);
+	ag_ino = (__u64)agno << (ctx->mnt.inopblog + ctx->mnt.agblklog);
+	next_ag_ino = (__u64)(agno + 1) << (ctx->mnt.inopblog + ctx->mnt.agblklog);
 
 	moveon = xfs_count_inodes_range(ctx, descr, ag_ino, next_ag_ino - 1,
 			&ci->counters[agno]);
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 08f3d847..873ad425 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -228,8 +228,8 @@ xfs_scan_ag_inodes(
 				minor(ctx->fsinfo.fs_datadev),
 				agno);
 
-	ag_ino = (__u64)agno << (ctx->inopblog + ctx->agblklog);
-	next_ag_ino = (__u64)(agno + 1) << (ctx->inopblog + ctx->agblklog);
+	ag_ino = (__u64)agno << (ctx->mnt.inopblog + ctx->mnt.agblklog);
+	next_ag_ino = (__u64)(agno + 1) << (ctx->mnt.inopblog + ctx->mnt.agblklog);
 
 	moveon = xfs_iterate_inodes_range(ctx, descr, ctx->fshandle, ag_ino,
 			next_ag_ino - 1, si->fn, si->arg);
diff --git a/scrub/phase1.c b/scrub/phase1.c
index c7034527..9a3d8f05 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -140,11 +140,6 @@ _("Does not appear to be an XFS filesystem!"));
 		return false;
 	}
 
-	ctx->agblklog = log2_roundup(ctx->mnt.fsgeom.agblocks);
-	ctx->blocklog = highbit32(ctx->mnt.fsgeom.blocksize);
-	ctx->inodelog = highbit32(ctx->mnt.fsgeom.inodesize);
-	ctx->inopblog = ctx->blocklog - ctx->inodelog;
-
 	error = path_to_fshandle(ctx->mntpoint, &ctx->fshandle,
 			&ctx->fshandle_len);
 	if (error) {
diff --git a/scrub/phase3.c b/scrub/phase3.c
index a42d8213..579e08c3 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -52,8 +52,8 @@ xfs_scrub_inode_vfs_error(
 	xfs_agino_t		agino;
 	int			old_errno = errno;
 
-	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
-	agino = bstat->bs_ino % (1ULL << (ctx->inopblog + ctx->agblklog));
+	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
+	agino = bstat->bs_ino % (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
 	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
 			(uint64_t)bstat->bs_ino, agno, agino);
 	errno = old_errno;
@@ -77,7 +77,7 @@ xfs_scrub_inode(
 	int			error;
 
 	xfs_action_list_init(&alist);
-	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
+	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
 	background_sleep();
 
 	/* Try to open the inode to pin it. */
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 748885d4..36ec27b3 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -239,8 +239,8 @@ xfs_scrub_connections(
 	int			fd = -1;
 	int			error;
 
-	agno = bstat->bs_ino / (1ULL << (ctx->inopblog + ctx->agblklog));
-	agino = bstat->bs_ino % (1ULL << (ctx->inopblog + ctx->agblklog));
+	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
+	agino = bstat->bs_ino % (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
 	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
 			(uint64_t)bstat->bs_ino, agno, agino);
 	background_sleep();
diff --git a/scrub/phase6.c b/scrub/phase6.c
index e5a0b3c1..48971270 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -547,7 +547,7 @@ xfs_estimate_verify_work(
 	if (!moveon)
 		return moveon;
 
-	*items = ((d_blocks - d_bfree) + (r_blocks - r_bfree)) << ctx->blocklog;
+	*items = ((d_blocks - d_bfree) + (r_blocks - r_bfree)) << ctx->mnt.blocklog;
 	*nr_threads = disk_heads(ctx->datadev);
 	*rshift = 20;
 	return moveon;
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 13959ca8..41a77356 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -148,11 +148,11 @@ xfs_scan_summary(
 	 * filesystem treats them as "free", but since we scanned
 	 * them, we'll consider them used.
 	 */
-	d_bfree -= totalcount.agbytes >> ctx->blocklog;
+	d_bfree -= totalcount.agbytes >> ctx->mnt.blocklog;
 
 	/* Report on what we found. */
-	used_data = (d_blocks - d_bfree) << ctx->blocklog;
-	used_rt = (r_blocks - r_bfree) << ctx->blocklog;
+	used_data = (d_blocks - d_bfree) << ctx->mnt.blocklog;
+	used_rt = (r_blocks - r_bfree) << ctx->mnt.blocklog;
 	used_files = f_files - f_free;
 	stat_data = totalcount.dbytes;
 	stat_rt = totalcount.rbytes;
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 3eb7ed79..13888f8c 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -63,10 +63,6 @@ struct scrub_ctx {
 
 	/* XFS specific geometry */
 	struct fs_path		fsinfo;
-	unsigned int		agblklog;
-	unsigned int		blocklog;
-	unsigned int		inodelog;
-	unsigned int		inopblog;
 	void			*fshandle;
 	size_t			fshandle_len;
 

