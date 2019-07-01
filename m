Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB60455F1A
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 04:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbfFZCjd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 22:39:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60660 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfFZCjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 22:39:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5Q2dVZ0123385;
        Wed, 26 Jun 2019 02:39:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=+nkQrBlX950+EYbGXgcUizm6AAyjw8/FFAI4ClSk43A=;
 b=DWGmZAKQizxv+Ukj+x/eanhFeNCpEHG9iE192w/cUDBVCAanEDSUPQP35JQ4U3hO8T/Z
 68UhsfWJfg8HW9rq5l981u00Ub7nTVztpy44ojxp3A8QdNj/6DemF0dwv/JQ178uVzQc
 NUS4SRraWxt37+aRVZVRSZrJKf5kEHqfBudLkF8wzZCacMjCJw6MSfKHWmzsn6NukUav
 yFt1HgnfXdfLNJKTOTXh0kjtXRlzoDIupF9mNLhAy9lAAkf2j12/Eap7EEZ8yWj4SRxI
 oHJekxsFF9e+NyIwpZE28jsC9zLl/nP68bZZYiubyfptRBsq7EhsYb05VszgGZmLd8a/ vg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t9brt7n2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 02:39:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5Q2bU7i088610;
        Wed, 26 Jun 2019 02:37:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tat7cjq5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 02:37:30 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5Q2bTTT014002;
        Wed, 26 Jun 2019 02:37:29 GMT
Received: from localhost (/10.159.230.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Jun 2019 19:37:28 -0700
Subject: [PATCH 06/10] libfrog: refactor open-coded INUMBERS calls
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 25 Jun 2019 19:37:27 -0700
Message-ID: <156151664777.2286979.3952912465639847748.stgit@magnolia>
In-Reply-To: <156151660523.2286979.13694849827562044045.stgit@magnolia>
References: <156151660523.2286979.13694849827562044045.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260029
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor all the INUMBERS ioctl callsites into helper functions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfrog.h    |    4 ++++
 io/imap.c          |   32 +++++++++++++++-----------------
 io/open.c          |   20 ++++++++------------
 libfrog/bulkstat.c |   19 +++++++++++++++++++
 scrub/fscounters.c |   18 +++++++-----------
 scrub/inodes.c     |   15 +++++----------
 6 files changed, 58 insertions(+), 50 deletions(-)


diff --git a/include/xfrog.h b/include/xfrog.h
index a76b00ec..d069de13 100644
--- a/include/xfrog.h
+++ b/include/xfrog.h
@@ -107,4 +107,8 @@ int xfrog_bulkstat_single(struct xfs_fd *xfd, uint64_t ino,
 int xfrog_bulkstat(struct xfs_fd *xfd, uint64_t *lastino, uint32_t icount,
 		struct xfs_bstat *ubuffer, uint32_t *ocount);
 
+struct xfs_inogrp;
+int xfrog_inumbers(struct xfs_fd *xfd, uint64_t *lastino, uint32_t icount,
+		struct xfs_inogrp *ubuffer, uint32_t *ocount);
+
 #endif	/* __XFROG_H__ */
diff --git a/io/imap.c b/io/imap.c
index fbc8e9e1..9a3d8965 100644
--- a/io/imap.c
+++ b/io/imap.c
@@ -8,18 +8,20 @@
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
+	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
+	struct xfs_inogrp	*t;
+	uint64_t		last = 0;
+	uint32_t		count;
+	uint32_t		nent;
+	int			i;
+	int			error;
 
 	if (argc != 2)
 		nent = 1;
@@ -30,14 +32,8 @@ imap_f(int argc, char **argv)
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
+	while ((error = xfrog_inumbers(&xfd, &last, nent, t, &count)) == 0 &&
+	       count > 0) {
 		for (i = 0; i < count; i++) {
 			printf(_("ino %10llu count %2d mask %016llx\n"),
 				(unsigned long long)t[i].xi_startino,
@@ -45,9 +41,11 @@ imap_f(int argc, char **argv)
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
index 67976f7f..968a9d9e 100644
--- a/io/open.c
+++ b/io/open.c
@@ -669,24 +669,20 @@ inode_help(void)
 "\n"));
 }
 
+#define IGROUP_NR	(1024)
 static __u64
 get_last_inode(void)
 {
-	__u64			lastip = 0;
-	__u64			lastgrp = 0;
-	__s32			ocount = 0;
+	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
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
+		if (xfrog_inumbers(&xfd, &lastip, IGROUP_NR, igroup,
+					&ocount)) {
 			perror("XFS_IOC_FSINUMBERS");
 			return 0;
 		}
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index 5db34eba..6632ffbb 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -42,3 +42,22 @@ xfrog_bulkstat(
 
 	return ioctl(xfd->fd, XFS_IOC_FSBULKSTAT, &bulkreq);
 }
+
+/* Query inode allocation bitmask information. */
+int
+xfrog_inumbers(
+	struct xfs_fd		*xfd,
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
+	return ioctl(xfd->fd, XFS_IOC_FSINUMBERS, &bulkreq);
+}
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index adb79b50..cd216b30 100644
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
-	error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
-	while (!error && igrplen && inogrp.xi_startino < last_ino) {
+	while (!(error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp,
+			&igrplen))) {
+		if (igrplen == 0 || inogrp.xi_startino >= last_ino)
+			break;
 		nr += inogrp.xi_alloccount;
-		error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
 	}
 
 	if (error) {
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 09dd0055..06d1245d 100644
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
@@ -121,7 +115,7 @@ xfs_iterate_inodes_range(
 
 	/* Find the inode chunk & alloc mask */
 	igrp_ino = first_ino;
-	error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
+	error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp, &igrplen);
 	while (!error && igrplen) {
 		/* Load the inodes. */
 		ino = inogrp.xi_startino - 1;
@@ -178,7 +172,8 @@ _("Changed too many times during scan; giving up."));
 
 		stale_count = 0;
 igrp_retry:
-		error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
+		error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp,
+				&igrplen);
 	}
 
 err:

