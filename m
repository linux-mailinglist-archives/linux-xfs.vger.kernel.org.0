Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82BC7BE7C3
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Sep 2019 23:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfIYVkd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Sep 2019 17:40:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49176 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfIYVkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:40:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdOEf013201;
        Wed, 25 Sep 2019 21:40:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=smtsZvFMXqx1WfTuf2AUSjZyNjXyZhEjWFE91DPJhc4=;
 b=hFBe+TNqiDz6hzvJKS4h8peXhfnJ17URMwsHpgUrg+AXeT7opqZPeafQ0qj4v3TzIQVv
 7bnqhLey55gZkzH7fEm86XyqZf7+3Ban2aU47uHI+UoCp+RZzUwEySDo+3IteF8OkfC8
 5dJYdnpPgA6stQaalhp6bV0Ttd0528G+MTxqFxVXQq6zcBFpFlCU6+pOJJL//4/eprjl
 CBA9oZiUVuZBgxHRpWNJX8k9vBBdpzhpUdG8vKKQaLtHrotYhotJ1UTd72zLSFuPiLnF
 VjLJWZxWT3iWsweUWMBXkdvlnQh17Rsfl6gdueCZeiCR+6+mnxvJOlSN889aL06WLfUO kA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v5btq7jdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:40:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdO32033651;
        Wed, 25 Sep 2019 21:40:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v7vnyuxht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:40:28 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLeR5r023663;
        Wed, 25 Sep 2019 21:40:27 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:40:27 -0700
Subject: [PATCH 4/7] libfrog: convert bulkstat.c functions to negative error
 codes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:40:26 -0700
Message-ID: <156944762603.302827.13603687068573848955.stgit@magnolia>
In-Reply-To: <156944760161.302827.4342305147521200999.stgit@magnolia>
References: <156944760161.302827.4342305147521200999.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250175
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250175
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert libfrog functions to return negative error codes like libxfs
does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fsr/xfs_fsr.c      |   18 ++++++-----
 io/bulkstat.c      |   18 ++++++-----
 io/imap.c          |    8 +++--
 io/open.c          |   21 ++++++-------
 io/swapext.c       |    4 +--
 libfrog/bulkstat.c |   82 +++++++++++++++++++++++++++-------------------------
 libfrog/bulkstat.h |    8 +++--
 quota/quot.c       |    8 +++--
 scrub/fscounters.c |    8 +++--
 scrub/inodes.c     |   20 ++++++-------
 spaceman/health.c  |   10 +++---
 11 files changed, 104 insertions(+), 101 deletions(-)


diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 3e9ba27c..77a10a1d 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -613,16 +613,15 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 
 	tmp_init(mntdir);
 
-	breq = xfrog_bulkstat_alloc_req(GRABSZ, startino);
-	if (!breq) {
-		fsrprintf(_("Skipping %s: not enough memory\n"),
-			  mntdir);
+	ret = -xfrog_bulkstat_alloc_req(GRABSZ, startino, &breq);
+	if (ret) {
+		fsrprintf(_("Skipping %s: %s\n"), mntdir, strerror(ret));
 		xfd_close(&fsxfd);
 		free(fshandlep);
 		return -1;
 	}
 
-	while ((ret = xfrog_bulkstat(&fsxfd, breq) == 0)) {
+	while ((ret = -xfrog_bulkstat(&fsxfd, breq) == 0)) {
 		struct xfs_bstat	bs1;
 		struct xfs_bulkstat	*buf = breq->bulkstat;
 		struct xfs_bulkstat	*p;
@@ -643,7 +642,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 			     (p->bs_extents < 2))
 				continue;
 
-			ret = xfrog_bulkstat_v5_to_v1(&fsxfd, &bs1, p);
+			ret = -xfrog_bulkstat_v5_to_v1(&fsxfd, &bs1, p);
 			if (ret) {
 				fsrprintf(_("bstat conversion error: %s\n"),
 						strerror(ret));
@@ -755,13 +754,13 @@ fsrfile(
 		goto out;
 	}
 
-	error = xfrog_bulkstat_single(&fsxfd, ino, 0, &bulkstat);
+	error = -xfrog_bulkstat_single(&fsxfd, ino, 0, &bulkstat);
 	if (error) {
 		fsrprintf(_("unable to get bstat on %s: %s\n"),
 			fname, strerror(error));
 		goto out;
 	}
-	error = xfrog_bulkstat_v5_to_v1(&fsxfd, &statbuf, &bulkstat);
+	error = -xfrog_bulkstat_v5_to_v1(&fsxfd, &statbuf, &bulkstat);
 	if (error) {
 		fsrprintf(_("bstat conversion error on %s: %s\n"),
 			fname, strerror(error));
@@ -996,7 +995,8 @@ fsr_setup_attr_fork(
 		 * this to compare against the target and determine what we
 		 * need to do.
 		 */
-		ret = xfrog_bulkstat_single(&txfd, tstatbuf.st_ino, 0, &tbstat);
+		ret = -xfrog_bulkstat_single(&txfd, tstatbuf.st_ino, 0,
+				&tbstat);
 		if (ret) {
 			fsrprintf(_("unable to get bstat on temp file: %s\n"),
 						strerror(ret));
diff --git a/io/bulkstat.c b/io/bulkstat.c
index e5ee4296..58afaf76 100644
--- a/io/bulkstat.c
+++ b/io/bulkstat.c
@@ -171,9 +171,9 @@ bulkstat_f(
 		return 0;
 	}
 
-	breq = xfrog_bulkstat_alloc_req(batch_size, startino);
-	if (!breq) {
-		perror("alloc bulkreq");
+	ret = -xfrog_bulkstat_alloc_req(batch_size, startino, &breq);
+	if (ret) {
+		xfrog_perror(ret, "alloc bulkreq");
 		exitcode = 1;
 		return 0;
 	}
@@ -183,7 +183,7 @@ bulkstat_f(
 
 	set_xfd_flags(&xfd, ver);
 
-	while ((ret = xfrog_bulkstat(&xfd, breq)) == 0) {
+	while ((ret = -xfrog_bulkstat(&xfd, breq)) == 0) {
 		if (debug)
 			printf(
 _("bulkstat: startino=%lld flags=0x%x agno=%u ret=%d icount=%u ocount=%u\n"),
@@ -309,7 +309,7 @@ bulkstat_single_f(
 			}
 		}
 
-		ret = xfrog_bulkstat_single(&xfd, ino, flags, &bulkstat);
+		ret = -xfrog_bulkstat_single(&xfd, ino, flags, &bulkstat);
 		if (ret) {
 			xfrog_perror(ret, "xfrog_bulkstat_single");
 			continue;
@@ -429,9 +429,9 @@ inumbers_f(
 		return 0;
 	}
 
-	ireq = xfrog_inumbers_alloc_req(batch_size, startino);
-	if (!ireq) {
-		perror("alloc inumbersreq");
+	ret = -xfrog_inumbers_alloc_req(batch_size, startino, &ireq);
+	if (ret) {
+		xfrog_perror(ret, "alloc inumbersreq");
 		exitcode = 1;
 		return 0;
 	}
@@ -441,7 +441,7 @@ inumbers_f(
 
 	set_xfd_flags(&xfd, ver);
 
-	while ((ret = xfrog_inumbers(&xfd, ireq)) == 0) {
+	while ((ret = -xfrog_inumbers(&xfd, ireq)) == 0) {
 		if (debug)
 			printf(
 _("bulkstat: startino=%"PRIu64" flags=0x%"PRIx32" agno=%"PRIu32" ret=%d icount=%"PRIu32" ocount=%"PRIu32"\n"),
diff --git a/io/imap.c b/io/imap.c
index 6b338640..e75dad1a 100644
--- a/io/imap.c
+++ b/io/imap.c
@@ -28,13 +28,13 @@ imap_f(int argc, char **argv)
 	else
 		nent = atoi(argv[1]);
 
-	ireq = xfrog_inumbers_alloc_req(nent, 0);
-	if (!ireq) {
-		perror("alloc req");
+	error = -xfrog_inumbers_alloc_req(nent, 0, &ireq);
+	if (error) {
+		xfrog_perror(error, "alloc req");
 		return 0;
 	}
 
-	while ((error = xfrog_inumbers(&xfd, ireq)) == 0 &&
+	while ((error = -xfrog_inumbers(&xfd, ireq)) == 0 &&
 	       ireq->hdr.ocount > 0) {
 		for (i = 0; i < ireq->hdr.ocount; i++) {
 			printf(_("ino %10"PRIu64" count %2d mask %016"PRIx64"\n"),
diff --git a/io/open.c b/io/open.c
index 3bbc5d0a..eb5d653c 100644
--- a/io/open.c
+++ b/io/open.c
@@ -684,17 +684,16 @@ get_last_inode(void)
 	struct xfs_inumbers_req	*ireq;
 	uint32_t		lastgrp = 0;
 	__u64			last_ino = 0;
+	int			ret;
 
-	ireq = xfrog_inumbers_alloc_req(IGROUP_NR, 0);
-	if (!ireq) {
-		perror("alloc req");
+	ret = -xfrog_inumbers_alloc_req(IGROUP_NR, 0, &ireq);
+	if (ret) {
+		xfrog_perror(ret, "alloc req");
 		return 0;
 	}
 
 	for (;;) {
-		int		ret;
-
-		ret = xfrog_inumbers(&xfd, ireq);
+		ret = -xfrog_inumbers(&xfd, ireq);
 		if (ret) {
 			xfrog_perror(ret, "XFS_IOC_FSINUMBERS");
 			free(ireq);
@@ -787,15 +786,15 @@ inode_f(
 		 * The -n option means that the caller wants to know the number
 		 * of the next allocated inode, so we need to increment here.
 		 */
-		breq = xfrog_bulkstat_alloc_req(1, userino + 1);
-		if (!breq) {
-			perror("alloc bulkstat");
+		ret = -xfrog_bulkstat_alloc_req(1, userino + 1, &breq);
+		if (ret) {
+			xfrog_perror(ret, "alloc bulkstat");
 			exitcode = 1;
 			return 0;
 		}
 
 		/* get next inode */
-		ret = xfrog_bulkstat(&xfd, breq);
+		ret = -xfrog_bulkstat(&xfd, breq);
 		if (ret) {
 			xfrog_perror(ret, "bulkstat");
 			free(breq);
@@ -813,7 +812,7 @@ inode_f(
 		struct xfs_fd	xfd = XFS_FD_INIT(file->fd);
 
 		/* get this inode */
-		ret = xfrog_bulkstat_single(&xfd, userino, 0, &bulkstat);
+		ret = -xfrog_bulkstat_single(&xfd, userino, 0, &bulkstat);
 		if (ret == EINVAL) {
 			/* Not in use */
 			result_ino = 0;
diff --git a/io/swapext.c b/io/swapext.c
index dc4e418f..a4153bb7 100644
--- a/io/swapext.c
+++ b/io/swapext.c
@@ -50,12 +50,12 @@ swapext_f(
 		goto out;
 	}
 
-	error = xfrog_bulkstat_single(&fxfd, stat.st_ino, 0, &bulkstat);
+	error = -xfrog_bulkstat_single(&fxfd, stat.st_ino, 0, &bulkstat);
 	if (error) {
 		xfrog_perror(error, "bulkstat");
 		goto out;
 	}
-	error = xfrog_bulkstat_v5_to_v1(&fxfd, &sx.sx_stat, &bulkstat);
+	error = -xfrog_bulkstat_v5_to_v1(&fxfd, &sx.sx_stat, &bulkstat);
 	if (error) {
 		xfrog_perror(error, "bulkstat conversion");
 		goto out;
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index 38d634f7..c3e5c5f8 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -39,7 +39,7 @@ xfrog_bulkstat_prep_v1_emulation(
 	if (xfd->fsgeom.blocksize > 0)
 		return 0;
 
-	return -xfd_prepare_geometry(xfd);
+	return xfd_prepare_geometry(xfd);
 }
 
 /* Bulkstat a single inode using v5 ioctl. */
@@ -54,21 +54,21 @@ xfrog_bulkstat_single5(
 	int				ret;
 
 	if (flags & ~(XFS_BULK_IREQ_SPECIAL))
-		return EINVAL;
+		return -EINVAL;
 
-	req = xfrog_bulkstat_alloc_req(1, ino);
-	if (!req)
-		return ENOMEM;
+	ret = xfrog_bulkstat_alloc_req(1, ino, &req);
+	if (ret)
+		return ret;
 
 	req->hdr.flags = flags;
 	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT, req);
 	if (ret) {
-		ret = errno;
+		ret = -errno;
 		goto free;
 	}
 
 	if (req->hdr.ocount == 0) {
-		ret = ENOENT;
+		ret = -ENOENT;
 		goto free;
 	}
 
@@ -91,7 +91,7 @@ xfrog_bulkstat_single1(
 	int				error;
 
 	if (flags)
-		return EINVAL;
+		return -EINVAL;
 
 	error = xfrog_bulkstat_prep_v1_emulation(xfd);
 	if (error)
@@ -102,13 +102,13 @@ xfrog_bulkstat_single1(
 	bulkreq.ubuffer = &bstat;
 	error = ioctl(xfd->fd, XFS_IOC_FSBULKSTAT_SINGLE, &bulkreq);
 	if (error)
-		return errno;
+		return -errno;
 
 	xfrog_bulkstat_v1_to_v5(xfd, bulkstat, &bstat);
 	return 0;
 }
 
-/* Bulkstat a single inode.  Returns zero or a positive error code. */
+/* Bulkstat a single inode.  Returns zero or a negative error code. */
 int
 xfrog_bulkstat_single(
 	struct xfs_fd			*xfd,
@@ -127,8 +127,8 @@ xfrog_bulkstat_single(
 
 	/* If the v5 ioctl wasn't found, we punt to v1. */
 	switch (error) {
-	case EOPNOTSUPP:
-	case ENOTTY:
+	case -EOPNOTSUPP:
+	case -ENOTTY:
 		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
 		break;
 	}
@@ -143,7 +143,7 @@ xfrog_bulkstat_single(
  * kernels.
  *
  * Returns 0 if the emulation should proceed; ECANCELED if there are no
- * records; or a positive error code.
+ * records; or a negative error code.
  */
 static int
 xfrog_bulk_req_v1_setup(
@@ -160,7 +160,7 @@ xfrog_bulk_req_v1_setup(
 		if (hdr->ino == 0)
 			hdr->ino = cvt_agino_to_ino(xfd, hdr->agno, 0);
 		else if (agno < hdr->agno)
-			return EINVAL;
+			return -EINVAL;
 		else if (agno > hdr->agno)
 			goto no_results;
 	}
@@ -170,7 +170,7 @@ xfrog_bulk_req_v1_setup(
 
 	buf = malloc(hdr->icount * rec_size);
 	if (!buf)
-		return errno;
+		return -errno;
 
 	if (hdr->ino)
 		hdr->ino--;
@@ -182,7 +182,7 @@ xfrog_bulk_req_v1_setup(
 
 no_results:
 	hdr->ocount = 0;
-	return ECANCELED;
+	return -ECANCELED;
 }
 
 /*
@@ -210,7 +210,7 @@ xfrog_bulk_req_v1_cleanup(
 	void			*v5_rec = v5_records;
 	unsigned int		i;
 
-	if (error == ECANCELED) {
+	if (error == -ECANCELED) {
 		error = 0;
 		goto free;
 	}
@@ -262,7 +262,7 @@ xfrog_bulkstat5(
 
 	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT, req);
 	if (ret)
-		return errno;
+		return -errno;
 	return 0;
 }
 
@@ -281,14 +281,14 @@ xfrog_bulkstat1(
 
 	error = xfrog_bulk_req_v1_setup(xfd, &req->hdr, &bulkreq,
 			sizeof(struct xfs_bstat));
-	if (error == ECANCELED)
+	if (error == -ECANCELED)
 		goto out_teardown;
 	if (error)
 		return error;
 
 	error = ioctl(xfd->fd, XFS_IOC_FSBULKSTAT, &bulkreq);
 	if (error)
-		error = errno;
+		error = -errno;
 
 out_teardown:
 	return xfrog_bulk_req_v1_cleanup(xfd, &req->hdr, &bulkreq,
@@ -314,8 +314,8 @@ xfrog_bulkstat(
 
 	/* If the v5 ioctl wasn't found, we punt to v1. */
 	switch (error) {
-	case EOPNOTSUPP:
-	case ENOTTY:
+	case -EOPNOTSUPP:
+	case -ENOTTY:
 		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
 		break;
 	}
@@ -347,7 +347,7 @@ xfrog_bulkstat_v5_to_v1(
 	    time_too_big(bs5->bs_atime) ||
 	    time_too_big(bs5->bs_ctime) ||
 	    time_too_big(bs5->bs_mtime))
-		return ERANGE;
+		return -ERANGE;
 
 	bs1->bs_ino = bs5->bs_ino;
 	bs1->bs_mode = bs5->bs_mode;
@@ -417,22 +417,24 @@ xfrog_bulkstat_v1_to_v5(
 	bs5->bs_aextents = bs1->bs_aextents;
 }
 
-/* Allocate a bulkstat request.  On error returns NULL and sets errno. */
-struct xfs_bulkstat_req *
+/* Allocate a bulkstat request.  Returns zero or a negative error code. */
+int
 xfrog_bulkstat_alloc_req(
 	uint32_t		nr,
-	uint64_t		startino)
+	uint64_t		startino,
+	struct xfs_bulkstat_req **preq)
 {
 	struct xfs_bulkstat_req	*breq;
 
 	breq = calloc(1, XFS_BULKSTAT_REQ_SIZE(nr));
 	if (!breq)
-		return NULL;
+		return -errno;
 
 	breq->hdr.icount = nr;
 	breq->hdr.ino = startino;
 
-	return breq;
+	*preq = breq;
+	return 0;
 }
 
 /* Set a bulkstat cursor to iterate only a particular AG. */
@@ -490,7 +492,7 @@ xfrog_inumbers5(
 
 	ret = ioctl(xfd->fd, XFS_IOC_INUMBERS, req);
 	if (ret)
-		return errno;
+		return -errno;
 	return 0;
 }
 
@@ -509,14 +511,14 @@ xfrog_inumbers1(
 
 	error = xfrog_bulk_req_v1_setup(xfd, &req->hdr, &bulkreq,
 			sizeof(struct xfs_inogrp));
-	if (error == ECANCELED)
+	if (error == -ECANCELED)
 		goto out_teardown;
 	if (error)
 		return error;
 
 	error = ioctl(xfd->fd, XFS_IOC_FSINUMBERS, &bulkreq);
 	if (error)
-		error = errno;
+		error = -errno;
 
 out_teardown:
 	return xfrog_bulk_req_v1_cleanup(xfd, &req->hdr, &bulkreq,
@@ -526,7 +528,7 @@ xfrog_inumbers1(
 }
 
 /*
- * Query inode allocation bitmask information.  Returns zero or a positive
+ * Query inode allocation bitmask information.  Returns zero or a negative
  * error code.
  */
 int
@@ -545,8 +547,8 @@ xfrog_inumbers(
 
 	/* If the v5 ioctl wasn't found, we punt to v1. */
 	switch (error) {
-	case EOPNOTSUPP:
-	case ENOTTY:
+	case -EOPNOTSUPP:
+	case -ENOTTY:
 		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
 		break;
 	}
@@ -555,22 +557,24 @@ xfrog_inumbers(
 	return xfrog_inumbers1(xfd, req);
 }
 
-/* Allocate a inumbers request.  On error returns NULL and sets errno. */
-struct xfs_inumbers_req *
+/* Allocate a inumbers request.  Returns zero or a negative error code. */
+int
 xfrog_inumbers_alloc_req(
 	uint32_t		nr,
-	uint64_t		startino)
+	uint64_t		startino,
+	struct xfs_inumbers_req **preq)
 {
 	struct xfs_inumbers_req	*ireq;
 
 	ireq = calloc(1, XFS_INUMBERS_REQ_SIZE(nr));
 	if (!ireq)
-		return NULL;
+		return -errno;
 
 	ireq->hdr.icount = nr;
 	ireq->hdr.ino = startino;
 
-	return ireq;
+	*preq = ireq;
+	return 0;
 }
 
 /* Set an inumbers cursor to iterate only a particular AG. */
diff --git a/libfrog/bulkstat.h b/libfrog/bulkstat.h
index 133a99b8..56ef7f9a 100644
--- a/libfrog/bulkstat.h
+++ b/libfrog/bulkstat.h
@@ -12,8 +12,8 @@ int xfrog_bulkstat_single(struct xfs_fd *xfd, uint64_t ino, unsigned int flags,
 		struct xfs_bulkstat *bulkstat);
 int xfrog_bulkstat(struct xfs_fd *xfd, struct xfs_bulkstat_req *req);
 
-struct xfs_bulkstat_req *xfrog_bulkstat_alloc_req(uint32_t nr,
-		uint64_t startino);
+int xfrog_bulkstat_alloc_req(uint32_t nr, uint64_t startino,
+		struct xfs_bulkstat_req **preq);
 int xfrog_bulkstat_v5_to_v1(struct xfs_fd *xfd, struct xfs_bstat *bs1,
 		const struct xfs_bulkstat *bstat);
 void xfrog_bulkstat_v1_to_v5(struct xfs_fd *xfd, struct xfs_bulkstat *bstat,
@@ -24,8 +24,8 @@ void xfrog_bulkstat_set_ag(struct xfs_bulkstat_req *req, uint32_t agno);
 struct xfs_inogrp;
 int xfrog_inumbers(struct xfs_fd *xfd, struct xfs_inumbers_req *req);
 
-struct xfs_inumbers_req *xfrog_inumbers_alloc_req(uint32_t nr,
-		uint64_t startino);
+int xfrog_inumbers_alloc_req(uint32_t nr, uint64_t startino,
+		struct xfs_inumbers_req **preq);
 void xfrog_inumbers_set_ag(struct xfs_inumbers_req *req, uint32_t agno);
 void xfrog_inumbers_v5_to_v1(struct xfs_inogrp *ig1,
 		const struct xfs_inumbers *ig);
diff --git a/quota/quot.c b/quota/quot.c
index df3825f2..8544aef6 100644
--- a/quota/quot.c
+++ b/quota/quot.c
@@ -152,14 +152,14 @@ quot_bulkstat_mount(
 		return;
 	}
 
-	breq = xfrog_bulkstat_alloc_req(NBSTAT, 0);
-	if (!breq) {
-		perror("calloc");
+	ret = -xfrog_bulkstat_alloc_req(NBSTAT, 0, &breq);
+	if (ret) {
+		xfrog_perror(ret, "calloc");
 		xfd_close(&fsxfd);
 		return;
 	}
 
-	while ((sts = xfrog_bulkstat(&fsxfd, breq)) == 0) {
+	while ((sts = -xfrog_bulkstat(&fsxfd, breq)) == 0) {
 		if (breq->hdr.ocount == 0)
 			break;
 		for (i = 0; i < breq->hdr.ocount; i++)
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 2581947f..a6b62f34 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -47,14 +47,14 @@ count_ag_inodes(
 	unsigned int		i;
 	int			error;
 
-	ireq = xfrog_inumbers_alloc_req(64, 0);
-	if (!ireq) {
-		ci->error = errno;
+	error = -xfrog_inumbers_alloc_req(64, 0, &ireq);
+	if (error) {
+		ci->error = error;
 		return;
 	}
 	xfrog_inumbers_set_ag(ireq, agno);
 
-	while (!ci->error && (error = xfrog_inumbers(&ctx->mnt, ireq)) == 0) {
+	while (!ci->error && (error = -xfrog_inumbers(&ctx->mnt, ireq)) == 0) {
 		if (ireq->hdr.ocount == 0)
 			break;
 		for (i = 0; i < ireq->hdr.ocount; i++)
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 142582eb..90d66c45 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -65,7 +65,7 @@ fill_in_bulkstat_holes(
 		}
 
 		/* Load the one inode. */
-		error = xfrog_bulkstat_single(&ctx->mnt,
+		error = -xfrog_bulkstat_single(&ctx->mnt,
 				inumbers->xi_startino + i, 0, bs);
 		if (error || bs->bs_ino != inumbers->xi_startino + i) {
 			memset(bs, 0, sizeof(struct xfs_bulkstat));
@@ -116,16 +116,16 @@ scan_ag_inodes(
 			sizeof(handle.ha_fid.fid_len);
 	handle.ha_fid.fid_pad = 0;
 
-	breq = xfrog_bulkstat_alloc_req(XFS_INODES_PER_CHUNK, 0);
-	if (!breq) {
-		str_errno(ctx, descr);
+	error = -xfrog_bulkstat_alloc_req(XFS_INODES_PER_CHUNK, 0, &breq);
+	if (error) {
+		str_liberror(ctx, error, descr);
 		si->aborted = true;
 		return;
 	}
 
-	ireq = xfrog_inumbers_alloc_req(1, 0);
-	if (!ireq) {
-		str_errno(ctx, descr);
+	error = -xfrog_inumbers_alloc_req(1, 0, &ireq);
+	if (error) {
+		str_liberror(ctx, error, descr);
 		free(breq);
 		si->aborted = true;
 		return;
@@ -134,7 +134,7 @@ scan_ag_inodes(
 	xfrog_inumbers_set_ag(ireq, agno);
 
 	/* Find the inode chunk & alloc mask */
-	error = xfrog_inumbers(&ctx->mnt, ireq);
+	error = -xfrog_inumbers(&ctx->mnt, ireq);
 	while (!error && !si->aborted && ireq->hdr.ocount > 0) {
 		/*
 		 * We can have totally empty inode chunks on filesystems where
@@ -145,7 +145,7 @@ scan_ag_inodes(
 
 		breq->hdr.ino = inumbers->xi_startino;
 		breq->hdr.icount = inumbers->xi_alloccount;
-		error = xfrog_bulkstat(&ctx->mnt, breq);
+		error = -xfrog_bulkstat(&ctx->mnt, breq);
 		if (error) {
 			char	errbuf[DESCR_BUFSZ];
 
@@ -193,7 +193,7 @@ _("Changed too many times during scan; giving up."));
 
 		stale_count = 0;
 igrp_retry:
-		error = xfrog_inumbers(&ctx->mnt, ireq);
+		error = -xfrog_inumbers(&ctx->mnt, ireq);
 	}
 
 err:
diff --git a/spaceman/health.c b/spaceman/health.c
index a10d2d4a..14538f55 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -217,7 +217,7 @@ report_inode_health(
 		descr = d;
 	}
 
-	ret = xfrog_bulkstat_single(&file->xfd, ino, 0, &bs);
+	ret = -xfrog_bulkstat_single(&file->xfd, ino, 0, &bs);
 	if (ret) {
 		xfrog_perror(ret, descr);
 		return 1;
@@ -270,9 +270,9 @@ report_bulkstat_health(
 	uint32_t		i;
 	int			error;
 
-	breq = xfrog_bulkstat_alloc_req(BULKSTAT_NR, 0);
-	if (!breq) {
-		perror("bulk alloc req");
+	error = -xfrog_bulkstat_alloc_req(BULKSTAT_NR, 0, &breq);
+	if (error) {
+		xfrog_perror(error, "bulk alloc req");
 		exitcode = 1;
 		return 1;
 	}
@@ -281,7 +281,7 @@ report_bulkstat_health(
 		xfrog_bulkstat_set_ag(breq, agno);
 
 	do {
-		error = xfrog_bulkstat(&file->xfd, breq);
+		error = -xfrog_bulkstat(&file->xfd, breq);
 		if (error)
 			break;
 		for (i = 0; i < breq->hdr.ocount; i++) {

