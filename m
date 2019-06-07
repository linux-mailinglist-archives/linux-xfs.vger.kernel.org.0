Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E68743958C
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 21:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729848AbfFGT2l (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Jun 2019 15:28:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54400 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729625AbfFGT2l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 15:28:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JSdXZ086504;
        Fri, 7 Jun 2019 19:28:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=R7WmN4bKop7gYYSDgdKOUS+w5eFelt9bwWT6dSyZ6iA=;
 b=E447eSpOlVZTRLiBU67h8m3w7r9PHID8T327Ts3FiasyEDYSR9fFine0xIwp86hAQymC
 BLRl5AlTsOMH9oKOKzZvetKRv+sTNQZcjQaePzFwxfHUpVT8SHL9JXCRtPxkgvMz2Twa
 Biuarn+aX21indUFkcsSvv4dhb2QE7mRzvtng1BQzfZnYB8G795FOdwyFwBlkuQ4CwYc
 6Uf9pYTSjfvU5hJBjVgX1WlpWv1eY4+s4XYAOHtr8qDJfzWHryEvgZjFraWPhFZTVVzg
 qp8vWdc1pyiA75wk9aO+dbUsxBq2sKfMnRKxuCVupj2rnw6/RDxTtVdyWsMlN9+t7jfE 0w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2suj0r02w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:28:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JSdXd053829;
        Fri, 7 Jun 2019 19:28:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2swnhbgcfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:28:38 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x57JSZem004729;
        Fri, 7 Jun 2019 19:28:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Jun 2019 12:28:35 -0700
Subject: [PATCH 3/6] libxfs: refactor open-coded INUMBERS calls
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 07 Jun 2019 12:28:34 -0700
Message-ID: <155993571460.2343365.17053963096831775316.stgit@magnolia>
In-Reply-To: <155993569512.2343365.15510991248022865602.stgit@magnolia>
References: <155993569512.2343365.15510991248022865602.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906070130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906070130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor all the INUMBERS ioctl callsites into helper functions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfrog.h    |    4 ++++
 io/imap.c          |   31 ++++++++++++++-----------------
 io/open.c          |   19 +++++++------------
 libfrog/bulkstat.c |   19 +++++++++++++++++++
 scrub/fscounters.c |   18 +++++++-----------
 scrub/inodes.c     |   21 +++++++--------------
 6 files changed, 58 insertions(+), 54 deletions(-)


diff --git a/include/xfrog.h b/include/xfrog.h
index 4b4e0adc..8456d55e 100644
--- a/include/xfrog.h
+++ b/include/xfrog.h
@@ -24,4 +24,8 @@ int xfrog_bulkstat_single(int fd, uint64_t ino, struct xfs_bstat *ubuffer);
 int xfrog_bulkstat(int fd, uint64_t *lastino, uint32_t icount,
 		struct xfs_bstat *ubuffer, uint32_t *ocount);
 
+struct xfs_inogrp;
+int xfrog_inumbers(int fd, uint64_t *lastino, uint32_t icount,
+		struct xfs_inogrp *ubuffer, uint32_t *ocount);
+
 #endif	/* __XFROG_H__ */
diff --git a/io/imap.c b/io/imap.c
index fbc8e9e1..69027693 100644
--- a/io/imap.c
+++ b/io/imap.c
@@ -8,18 +8,19 @@
 #include "input.h"
 #include "init.h"
 #include "io.h"
+#include "xfrog.h"
 
 static cmdinfo_t imap_cmd;
 
 static int
 imap_f(int argc, char **argv)
 {
-	int		count;
-	int		nent;
-	int		i;
-	__u64		last = 0;
-	xfs_inogrp_t	*t;
-	xfs_fsop_bulkreq_t bulkreq;
+	struct xfs_inogrp	*t;
+	uint64_t		last = 0;
+	uint32_t		count;
+	uint32_t		nent;
+	int			i;
+	int			error;
 
 	if (argc != 2)
 		nent = 1;
@@ -30,14 +31,8 @@ imap_f(int argc, char **argv)
 	if (!t)
 		return 0;
 
-	bulkreq.lastip  = &last;
-	bulkreq.icount  = nent;
-	bulkreq.ubuffer = (void *)t;
-	bulkreq.ocount  = &count;
-
-	while (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS, &bulkreq) == 0) {
-		if (count == 0)
-			goto out_free;
+	while ((error = xfrog_inumbers(file->fd, &last, nent, t, &count)) == 0 &&
+	       count > 0) {
 		for (i = 0; i < count; i++) {
 			printf(_("ino %10llu count %2d mask %016llx\n"),
 				(unsigned long long)t[i].xi_startino,
@@ -45,9 +40,11 @@ imap_f(int argc, char **argv)
 				(unsigned long long)t[i].xi_allocmask);
 		}
 	}
-	perror("xfsctl(XFS_IOC_FSINUMBERS)");
-	exitcode = 1;
-out_free:
+
+	if (error) {
+		perror("xfsctl(XFS_IOC_FSINUMBERS)");
+		exitcode = 1;
+	}
 	free(t);
 	return 0;
 }
diff --git a/io/open.c b/io/open.c
index d97903e9..7bc5a2f3 100644
--- a/io/open.c
+++ b/io/open.c
@@ -669,24 +669,19 @@ inode_help(void)
 "\n"));
 }
 
+#define IGROUP_NR	(1024)
 static __u64
 get_last_inode(void)
 {
-	__u64			lastip = 0;
-	__u64			lastgrp = 0;
-	__s32			ocount = 0;
+	uint64_t		lastip = 0;
+	uint32_t		lastgrp = 0;
+	uint32_t		ocount = 0;
 	__u64			last_ino;
-	struct xfs_inogrp	igroup[1024];
-	struct xfs_fsop_bulkreq	bulkreq;
-
-	bulkreq.lastip = &lastip;
-	bulkreq.ubuffer = &igroup;
-	bulkreq.icount = sizeof(igroup) / sizeof(struct xfs_inogrp);
-	bulkreq.ocount = &ocount;
+	struct xfs_inogrp	igroup[IGROUP_NR];
 
 	for (;;) {
-		if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS,
-				&bulkreq)) {
+		if (xfrog_inumbers(file->fd, &lastip, IGROUP_NR, igroup,
+					&ocount)) {
 			perror("XFS_IOC_FSINUMBERS");
 			return 0;
 		}
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index c0d3b627..1b08bbbd 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -41,3 +41,22 @@ xfrog_bulkstat(
 
 	return ioctl(fd, XFS_IOC_FSBULKSTAT, &bulkreq);
 }
+
+/* Query inode allocation bitmask information. */
+int
+xfrog_inumbers(
+	int			fd,
+	uint64_t		*lastino,
+	uint32_t		icount,
+	struct xfs_inogrp	*ubuffer,
+	uint32_t		*ocount)
+{
+	struct xfs_fsop_bulkreq	bulkreq = {
+		.lastip		= (__u64 *)lastino,
+		.icount		= icount,
+		.ubuffer	= ubuffer,
+		.ocount		= (__s32 *)ocount,
+	};
+
+	return ioctl(fd, XFS_IOC_FSINUMBERS, &bulkreq);
+}
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 9e93e2a6..492a06c7 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -15,6 +15,7 @@
 #include "xfs_scrub.h"
 #include "common.h"
 #include "fscounters.h"
+#include "xfrog.h"
 
 /*
  * Filesystem counter collection routines.  We can count the number of
@@ -41,26 +42,21 @@ xfs_count_inodes_range(
 	uint64_t		last_ino,
 	uint64_t		*count)
 {
-	struct xfs_fsop_bulkreq	igrpreq = {NULL};
 	struct xfs_inogrp	inogrp;
-	__u64			igrp_ino;
+	uint64_t		igrp_ino;
 	uint64_t		nr = 0;
-	__s32			igrplen = 0;
+	uint32_t		igrplen = 0;
 	int			error;
 
 	ASSERT(!(first_ino & (XFS_INODES_PER_CHUNK - 1)));
 	ASSERT((last_ino & (XFS_INODES_PER_CHUNK - 1)));
 
-	igrpreq.lastip  = &igrp_ino;
-	igrpreq.icount  = 1;
-	igrpreq.ubuffer = &inogrp;
-	igrpreq.ocount  = &igrplen;
-
 	igrp_ino = first_ino;
-	error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
-	while (!error && igrplen && inogrp.xi_startino < last_ino) {
+	while ((error = xfrog_inumbers(ctx->mnt_fd, &igrp_ino, 1, &inogrp,
+					&igrplen)) == 0 &&
+	       igrplen > 0 &&
+	       inogrp.xi_startino < last_ino) {
 		nr += inogrp.xi_alloccount;
-		error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
 	}
 
 	if (error) {
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 7950208d..0db16916 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -90,17 +90,16 @@ xfs_iterate_inodes_range(
 	xfs_inode_iter_fn	fn,
 	void			*arg)
 {
-	struct xfs_fsop_bulkreq	igrpreq = {NULL};
 	struct xfs_handle	handle;
 	struct xfs_inogrp	inogrp;
 	struct xfs_bstat	bstat[XFS_INODES_PER_CHUNK];
 	char			idescr[DESCR_BUFSZ];
 	char			buf[DESCR_BUFSZ];
 	struct xfs_bstat	*bs;
-	__u64			igrp_ino;
+	uint64_t		igrp_ino;
 	uint64_t		ino;
 	uint32_t		bulklen = 0;
-	__s32			igrplen = 0;
+	uint32_t		igrplen = 0;
 	bool			moveon = true;
 	int			i;
 	int			error;
@@ -109,11 +108,6 @@ xfs_iterate_inodes_range(
 
 	memset(bstat, 0, XFS_INODES_PER_CHUNK * sizeof(struct xfs_bstat));
 
-	igrpreq.lastip  = &igrp_ino;
-	igrpreq.icount  = 1;
-	igrpreq.ubuffer = &inogrp;
-	igrpreq.ocount  = &igrplen;
-
 	memcpy(&handle.ha_fsid, fshandle, sizeof(handle.ha_fsid));
 	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
 			sizeof(handle.ha_fid.fid_len);
@@ -121,8 +115,9 @@ xfs_iterate_inodes_range(
 
 	/* Find the inode chunk & alloc mask */
 	igrp_ino = first_ino;
-	error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
-	while (!error && igrplen) {
+	while ((error = xfrog_inumbers(ctx->mnt_fd, &igrp_ino, 1, &inogrp,
+					&igrplen)) == 0 &&
+	       igrplen > 0) {
 		/* Load the inodes. */
 		ino = inogrp.xi_startino - 1;
 
@@ -131,7 +126,7 @@ xfs_iterate_inodes_range(
 		 * there are more than 64 inodes per block.  Skip these.
 		 */
 		if (inogrp.xi_alloccount == 0)
-			goto igrp_retry;
+			continue;
 		error = xfrog_bulkstat(ctx->mnt_fd, &ino, inogrp.xi_alloccount,
 				bstat, &bulklen);
 		if (error)
@@ -155,7 +150,7 @@ xfs_iterate_inodes_range(
 				stale_count++;
 				if (stale_count < 30) {
 					igrp_ino = inogrp.xi_startino;
-					goto igrp_retry;
+					continue;
 				}
 				snprintf(idescr, DESCR_BUFSZ, "inode %"PRIu64,
 						(uint64_t)bs->bs_ino);
@@ -177,8 +172,6 @@ _("Changed too many times during scan; giving up."));
 		}
 
 		stale_count = 0;
-igrp_retry:
-		error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
 	}
 
 err:

