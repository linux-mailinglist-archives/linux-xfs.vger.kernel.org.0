Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74FC524404
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 01:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfETXRg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 19:17:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38600 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfETXRf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:17:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNDX5D148824;
        Mon, 20 May 2019 23:17:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Okru09u4Z/UKpPNO29JaL1W7hlb5tppeuFV5VIcp7/g=;
 b=teajE8wsq57m0Q1is1fQGhAIFieMoEQQnq804VU/SvGAtut3RrtlvIAr4QFxwOtJXN0a
 kYrT68OS4MuljUOr/4ykkd+sjLPGo0Cfj8c/jx10VepEuCfRNz4h2SL8jvym2R+Wdm2b
 2ChNx2NRmzWPs/LxWiSsI9AbjD7hswN5TgyIc7rMpud9V8dmSWoH5HdqCZyYQySGo/L/
 PBng04D9PrhtUrC5Rv7hGmMYQDp177IKWNAJq0wgppI0G3DRWZUrVHc5S8W362yqr88p
 5jAdS4WPIMBdqDqCAEVRxGuwY+pcCNwN5UGae5blXUuLkHgpJ/jT7mzknuPddiUKiKuZ oA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2sjapq9ubr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:17:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNHT6v123684;
        Mon, 20 May 2019 23:17:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2sks1xv8kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:17:32 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KNHWNk015672;
        Mon, 20 May 2019 23:17:32 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 23:17:32 +0000
Subject: [PATCH 08/12] xfs_repair: refactor namecheck functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 20 May 2019 16:17:31 -0700
Message-ID: <155839425128.68606.14448412166622032502.stgit@magnolia>
In-Reply-To: <155839420081.68606.4573219764134939943.stgit@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200142
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we have name check functions in libxfs, use them instead of our
custom versions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    2 ++
 repair/attr_repair.c     |   32 +++++++++++++-------------------
 repair/da_util.c         |   27 ---------------------------
 repair/da_util.h         |    6 ------
 repair/dir2.c            |   12 ++----------
 5 files changed, 17 insertions(+), 62 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 34bb552d..71a7ef53 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -143,6 +143,8 @@
 #define xfs_default_ifork_ops		libxfs_default_ifork_ops
 #define xfs_fs_geometry			libxfs_fs_geometry
 #define xfs_init_local_fork		libxfs_init_local_fork
+#define xfs_dir2_namecheck		libxfs_dir2_namecheck
+#define xfs_attr_namecheck		libxfs_attr_namecheck
 
 #define LIBXFS_ATTR_ROOT		ATTR_ROOT
 #define LIBXFS_ATTR_SECURE		ATTR_SECURE
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 5ad81c09..9a44f610 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -122,14 +122,6 @@ set_da_freemap(xfs_mount_t *mp, da_freemap_t *map, int start, int stop)
  * fork being emptied and put in shortform format.
  */
 
-static int
-attr_namecheck(
-	uint8_t	*name,
-	int	length)
-{
-	return namecheck((char *)name, length, false);
-}
-
 /*
  * This routine just checks what security needs are for attribute values
  * only called when root flag is set, otherwise these names could exist in
@@ -301,8 +293,8 @@ process_shortform_attr(
 		}
 
 		/* namecheck checks for null chars in attr names. */
-		if (attr_namecheck(currententry->nameval,
-						currententry->namelen)) {
+		if (!libxfs_attr_namecheck(currententry->nameval,
+					   currententry->namelen)) {
 			do_warn(
 	_("entry contains illegal character in shortform attribute name\n"));
 			junkit = 1;
@@ -464,8 +456,9 @@ process_leaf_attr_local(
 	xfs_attr_leaf_name_local_t *local;
 
 	local = xfs_attr3_leaf_name_local(leaf, i);
-	if (local->namelen == 0 || attr_namecheck(local->nameval,
-							local->namelen)) {
+	if (local->namelen == 0 ||
+	    !libxfs_attr_namecheck(local->nameval,
+				   local->namelen)) {
 		do_warn(
 	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
 			i, da_bno, ino, local->namelen);
@@ -519,13 +512,14 @@ process_leaf_attr_remote(
 
 	remotep = xfs_attr3_leaf_name_remote(leaf, i);
 
-	if (remotep->namelen == 0 || attr_namecheck(remotep->name,
-						remotep->namelen) ||
-			be32_to_cpu(entry->hashval) !=
-				libxfs_da_hashname((unsigned char *)&remotep->name[0],
-						remotep->namelen) ||
-			be32_to_cpu(entry->hashval) < last_hashval ||
-			be32_to_cpu(remotep->valueblk) == 0) {
+	if (remotep->namelen == 0 ||
+	    !libxfs_attr_namecheck(remotep->name,
+				   remotep->namelen) ||
+	    be32_to_cpu(entry->hashval) !=
+			libxfs_da_hashname((unsigned char *)&remotep->name[0],
+					   remotep->namelen) ||
+	    be32_to_cpu(entry->hashval) < last_hashval ||
+	    be32_to_cpu(remotep->valueblk) == 0) {
 		do_warn(
 	_("inconsistent remote attribute entry %d in attr block %u, ino %" PRIu64 "\n"), i, da_bno, ino);
 		return -1;
diff --git a/repair/da_util.c b/repair/da_util.c
index 4a258e58..8c818ea1 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -12,33 +12,6 @@
 #include "bmap.h"
 #include "da_util.h"
 
-/*
- * Takes a name and length (name need not be null-terminated) and whether
- * we are checking a dir (as opposed to an attr).
- * Returns 1 if the name contains a NUL or if a directory entry contains a '/'.
- * Returns 0 if the name checks out.
- */
-int
-namecheck(
-	char	*name,
-	int	length,
-	bool	isadir)
-{
-	char	*c;
-	int	i;
-
-	ASSERT(length < MAXNAMELEN);
-
-	for (c = name, i = 0; i < length; i++, c++) {
-		if (isadir && *c == '/')
-			return 1;
-		if (*c == '\0')
-			return 1;
-	}
-
-	return 0;
-}
-
 /*
  * the cursor gets passed up and down the da btree processing
  * routines.  The interior block processing routines use the
diff --git a/repair/da_util.h b/repair/da_util.h
index 041dff74..90fec00c 100644
--- a/repair/da_util.h
+++ b/repair/da_util.h
@@ -24,12 +24,6 @@ typedef struct da_bt_cursor {
 	struct blkmap		*blkmap;
 } da_bt_cursor_t;
 
-int
-namecheck(
-	char		*name,
-	int		length,
-	bool		isadir);
-
 struct xfs_buf *
 da_read_buf(
 	xfs_mount_t	*mp,
diff --git a/repair/dir2.c b/repair/dir2.c
index 094ecb3d..4ac0084e 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -44,14 +44,6 @@ _("malloc failed (%zu bytes) dir2_add_badlist:ino %" PRIu64 "\n"),
 	l->ino = ino;
 }
 
-static int
-dir_namecheck(
-	uint8_t	*name,
-	int	length)
-{
-	return namecheck((char *)name, length, true);
-}
-
 int
 dir2_is_badino(
 	xfs_ino_t	ino)
@@ -318,7 +310,7 @@ _("entry #%d %s in shortform dir %" PRIu64),
 		 * the length value is stored in a byte
 		 * so it can't be too big, it can only wrap
 		 */
-		if (dir_namecheck(sfep->name, namelen)) {
+		if (!libxfs_dir2_namecheck(sfep->name, namelen)) {
 			/*
 			 * junk entry
 			 */
@@ -789,7 +781,7 @@ _("\twould clear inode number in entry at offset %" PRIdPTR "...\n"),
 		 * during phase 4.
 		 */
 		junkit = dep->name[0] == '/';
-		nm_illegal = dir_namecheck(dep->name, dep->namelen);
+		nm_illegal = !libxfs_dir2_namecheck(dep->name, dep->namelen);
 		if (ino_discovery && nm_illegal) {
 			do_warn(
 _("entry at block %u offset %" PRIdPTR " in directory inode %" PRIu64 " has illegal name \"%*.*s\": "),

