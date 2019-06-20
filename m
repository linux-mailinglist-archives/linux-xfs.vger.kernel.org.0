Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5D84D42A
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 18:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfFTQuN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 12:50:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54498 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbfFTQuM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:50:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGnNeb173833;
        Thu, 20 Jun 2019 16:50:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=QaJijqfxWrYmT8Gy7u+pFNH3HoIgo1rikt+3z0lqkXs=;
 b=wSWYWxi6JVOrEiIj0J5aG3ZzXhphfvXkM/Xgug/I6OHjxStoiI4xKvRCzJR8m+eyUXP1
 colc2spawhJkt7b7OGDCv075t7ldJrXRrrOfNT+XqVoP1zj3nxz/Wy1iFEgAxxFd5CDm
 QJiOCWCoOWCFJUMb5EHdRTDSSfY+5u8UC9yRfU+7MmRuU/OzFIML/6vqNtt9WSLZYrIT
 5GIpDn05cYWqEmEulg+oNq2Nm9pWxXVFWUg5sB7RFig1NKfXZkI5dUfKBC/O410ZARn/
 n3jEj4yasXLRE8oygGYe7IJm8Sdm3p+krhQnSUsrfsfPUmMZlH7i+RtkP9sSJ8lzt0CU jA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t7809j77d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:50:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGmdg9052801;
        Thu, 20 Jun 2019 16:50:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2t77ypfrnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:50:10 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5KGo9jw024523;
        Thu, 20 Jun 2019 16:50:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 09:50:08 -0700
Subject: [PATCH 06/12] libfrog: create online fs geometry converters
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 20 Jun 2019 09:50:07 -0700
Message-ID: <156104940780.1172531.1442505572804647669.stgit@magnolia>
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

Create helper functions to perform unit conversions against a runtime
filesystem, then remove the open-coded versions in scrub.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfrog.h    |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/fsgeom.c   |    1 +
 scrub/fscounters.c |    4 ++--
 scrub/inodes.c     |    4 ++--
 scrub/phase3.c     |    6 +++---
 scrub/phase5.c     |    4 ++--
 scrub/phase6.c     |    3 ++-
 scrub/phase7.c     |    6 +++---
 8 files changed, 64 insertions(+), 13 deletions(-)


diff --git a/include/xfrog.h b/include/xfrog.h
index 507f27a4..8d7e38df 100644
--- a/include/xfrog.h
+++ b/include/xfrog.h
@@ -42,6 +42,9 @@ struct xfrog {
 
 	/* log2 of sb_inopblock */
 	unsigned int		inopblog;
+
+	/* bits for agino in inum */
+	unsigned int		aginolog;
 };
 
 /* Static initializers */
@@ -51,4 +54,50 @@ struct xfrog {
 int xfrog_prepare_geometry(struct xfrog *froggie);
 int xfrog_close(struct xfrog *froggie);
 
+/* Convert AG number and AG inode number into fs inode number. */
+static inline uint64_t
+xfrog_agino_to_ino(
+	struct xfrog		*frog,
+	uint32_t		agno,
+	uint32_t		agino)
+{
+	return ((uint64_t)agno << frog->aginolog) + agino;
+}
+
+/* Convert fs inode number into AG number. */
+static inline uint32_t
+xfrog_ino_to_agno(
+	struct xfrog		*frog,
+	uint64_t		ino)
+{
+	return ino >> frog->aginolog;
+}
+
+/* Convert fs inode number into AG inode number. */
+static inline uint32_t
+xfrog_ino_to_agino(
+	struct xfrog		*frog,
+	uint64_t		ino)
+{
+	return ino & ((1ULL << frog->aginolog) - 1);
+}
+
+/* Convert fs block number into bytes */
+static inline uint64_t
+xfrog_fsb_to_b(
+	struct xfrog		*frog,
+	uint64_t		fsb)
+{
+	return fsb << frog->blocklog;
+}
+
+/* Convert bytes into (rounded down) fs block number */
+static inline uint64_t
+xfrog_b_to_fsbt(
+	struct xfrog		*frog,
+	uint64_t		bytes)
+{
+	return bytes >> frog->blocklog;
+}
+
 #endif	/* __XFROG_H__ */
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 28e4fd62..c61466e2 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -105,6 +105,7 @@ xfrog_prepare_geometry(
 	froggie->blocklog = highbit32(froggie->fsgeom.blocksize);
 	froggie->inodelog = highbit32(froggie->fsgeom.inodesize);
 	froggie->inopblog = froggie->blocklog - froggie->inodelog;
+	froggie->aginolog = froggie->agblklog + froggie->inopblog;
 	return 0;
 }
 
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index ac898764..adb79b50 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -91,8 +91,8 @@ xfs_count_ag_inodes(
 				minor(ctx->fsinfo.fs_datadev),
 				agno);
 
-	ag_ino = (__u64)agno << (ctx->mnt.inopblog + ctx->mnt.agblklog);
-	next_ag_ino = (__u64)(agno + 1) << (ctx->mnt.inopblog + ctx->mnt.agblklog);
+	ag_ino = xfrog_agino_to_ino(&ctx->mnt, agno, 0);
+	next_ag_ino = xfrog_agino_to_ino(&ctx->mnt, agno + 1, 0);
 
 	moveon = xfs_count_inodes_range(ctx, descr, ag_ino, next_ag_ino - 1,
 			&ci->counters[agno]);
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 873ad425..a9000218 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -228,8 +228,8 @@ xfs_scan_ag_inodes(
 				minor(ctx->fsinfo.fs_datadev),
 				agno);
 
-	ag_ino = (__u64)agno << (ctx->mnt.inopblog + ctx->mnt.agblklog);
-	next_ag_ino = (__u64)(agno + 1) << (ctx->mnt.inopblog + ctx->mnt.agblklog);
+	ag_ino = xfrog_agino_to_ino(&ctx->mnt, agno, 0);
+	next_ag_ino = xfrog_agino_to_ino(&ctx->mnt, agno + 1, 0);
 
 	moveon = xfs_iterate_inodes_range(ctx, descr, ctx->fshandle, ag_ino,
 			next_ag_ino - 1, si->fn, si->arg);
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 579e08c3..def9a0de 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -52,8 +52,8 @@ xfs_scrub_inode_vfs_error(
 	xfs_agino_t		agino;
 	int			old_errno = errno;
 
-	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
-	agino = bstat->bs_ino % (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
+	agno = xfrog_ino_to_agno(&ctx->mnt, bstat->bs_ino);
+	agino = xfrog_ino_to_agino(&ctx->mnt, bstat->bs_ino);
 	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
 			(uint64_t)bstat->bs_ino, agno, agino);
 	errno = old_errno;
@@ -77,7 +77,7 @@ xfs_scrub_inode(
 	int			error;
 
 	xfs_action_list_init(&alist);
-	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
+	agno = xfrog_ino_to_agno(&ctx->mnt, bstat->bs_ino);
 	background_sleep();
 
 	/* Try to open the inode to pin it. */
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 36ec27b3..2189c9e4 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -239,8 +239,8 @@ xfs_scrub_connections(
 	int			fd = -1;
 	int			error;
 
-	agno = bstat->bs_ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
-	agino = bstat->bs_ino % (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
+	agno = xfrog_ino_to_agno(&ctx->mnt, bstat->bs_ino);
+	agino = xfrog_ino_to_agino(&ctx->mnt, bstat->bs_ino);
 	snprintf(descr, DESCR_BUFSZ, _("inode %"PRIu64" (%u/%u)"),
 			(uint64_t)bstat->bs_ino, agno, agino);
 	background_sleep();
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 48971270..630d15b0 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -547,7 +547,8 @@ xfs_estimate_verify_work(
 	if (!moveon)
 		return moveon;
 
-	*items = ((d_blocks - d_bfree) + (r_blocks - r_bfree)) << ctx->mnt.blocklog;
+	*items = xfrog_fsb_to_b(&ctx->mnt,
+			(d_blocks - d_bfree) + (r_blocks - r_bfree));
 	*nr_threads = disk_heads(ctx->datadev);
 	*rshift = 20;
 	return moveon;
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 41a77356..1c459dfc 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -148,11 +148,11 @@ xfs_scan_summary(
 	 * filesystem treats them as "free", but since we scanned
 	 * them, we'll consider them used.
 	 */
-	d_bfree -= totalcount.agbytes >> ctx->mnt.blocklog;
+	d_bfree -= xfrog_b_to_fsbt(&ctx->mnt, totalcount.agbytes);
 
 	/* Report on what we found. */
-	used_data = (d_blocks - d_bfree) << ctx->mnt.blocklog;
-	used_rt = (r_blocks - r_bfree) << ctx->mnt.blocklog;
+	used_data = xfrog_fsb_to_b(&ctx->mnt, d_blocks - d_bfree);
+	used_rt = xfrog_fsb_to_b(&ctx->mnt, r_blocks - r_bfree);
 	used_files = f_files - f_free;
 	stat_data = totalcount.dbytes;
 	stat_rt = totalcount.rbytes;

