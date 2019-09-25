Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E358ABE7AB
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Sep 2019 23:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbfIYVj1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Sep 2019 17:39:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47922 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbfIYVj1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:39:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdPit013249;
        Wed, 25 Sep 2019 21:39:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=nRnwG5U/yj0CH9oqmR92YrbN7u01zu31QvkgIhf904s=;
 b=ARoyBKlp7wj8r6Jzs2vnS3bxMxukXOxL3U62t7D+4GC+hbZ3NeT9YaZVYnPZmgDxQ6jf
 5D8I/R+y6+GdNR9lQOWIMZp+VMvs9tZ+dRVjdzgUiJa3EqfGDczpqUvSbwhQufAhAfDY
 jO/CmCOj/IwJsCDLth0b0x1ERu3GTEFJUJTB1ozrH415JeFalHHNWZhSqaxCw9pEaxNa
 ZNFxJ6GwO/90Gj9dx3SIaGh8szVK42Pooff2DMJ2gUajfBkYPrfkVVtY+azToYznQLuM
 QHxFigLdDIf0pdsp1T2knyjxLKBCDWCsIJLTXZieP6RvwgBIMaJbKXgudPILDid4iD8k Eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v5btq7j50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLdHuu021222;
        Wed, 25 Sep 2019 21:39:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2v829w54mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:39:16 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PLcIZ8017322;
        Wed, 25 Sep 2019 21:38:18 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:38:18 -0700
Subject: [PATCH 02/18] xfs_scrub: remove moveon from the fscounters functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:38:17 -0700
Message-ID: <156944749712.301514.7316631922258071675.stgit@magnolia>
In-Reply-To: <156944748487.301514.14685083474028866113.stgit@magnolia>
References: <156944748487.301514.14685083474028866113.stgit@magnolia>
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

Replace the moveon returns in the fscounters functions with direct error
returns.  Drop the xfs_ prefixes while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/fscounters.c |  129 ++++++++++++++++++++--------------------------------
 scrub/fscounters.h |    4 +-
 scrub/phase6.c     |   12 +++--
 scrub/phase7.c     |   15 ++++--
 4 files changed, 68 insertions(+), 92 deletions(-)


diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 98aa3826..2581947f 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -25,8 +25,8 @@
 /* Count the number of inodes in the filesystem. */
 
 /* INUMBERS wrapper routines. */
-struct xfs_count_inodes {
-	bool			moveon;
+struct count_inodes {
+	int			error;
 	uint64_t		counters[0];
 };
 
@@ -34,13 +34,14 @@ struct xfs_count_inodes {
  * Count the number of inodes.  Use INUMBERS to figure out how many inodes
  * exist in the filesystem, assuming we've already scrubbed that.
  */
-static bool
-xfs_count_inodes_ag(
-	struct scrub_ctx	*ctx,
-	const char		*descr,
-	uint32_t		agno,
-	uint64_t		*count)
+static void
+count_ag_inodes(
+	struct workqueue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
 {
+	struct count_inodes	*ci = arg;
+	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	struct xfs_inumbers_req	*ireq;
 	uint64_t		nr = 0;
 	unsigned int		i;
@@ -48,107 +49,78 @@ xfs_count_inodes_ag(
 
 	ireq = xfrog_inumbers_alloc_req(64, 0);
 	if (!ireq) {
-		str_info(ctx, descr, _("Insufficient memory; giving up."));
-		return false;
+		ci->error = errno;
+		return;
 	}
 	xfrog_inumbers_set_ag(ireq, agno);
 
-	while (!(error = xfrog_inumbers(&ctx->mnt, ireq))) {
+	while (!ci->error && (error = xfrog_inumbers(&ctx->mnt, ireq)) == 0) {
 		if (ireq->hdr.ocount == 0)
 			break;
 		for (i = 0; i < ireq->hdr.ocount; i++)
 			nr += ireq->inumbers[i].xi_alloccount;
 	}
+	if (error)
+		ci->error = error;
 
 	free(ireq);
 
-	if (error) {
-		str_liberror(ctx, error, descr);
-		return false;
-	}
-
-	*count = nr;
-	return true;
-}
-
-/* Scan all the inodes in an AG. */
-static void
-xfs_count_ag_inodes(
-	struct workqueue	*wq,
-	xfs_agnumber_t		agno,
-	void			*arg)
-{
-	struct xfs_count_inodes	*ci = arg;
-	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
-	char			descr[DESCR_BUFSZ];
-	bool			moveon;
-
-	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u inodes"),
-				major(ctx->fsinfo.fs_datadev),
-				minor(ctx->fsinfo.fs_datadev),
-				agno);
-
-	moveon = xfs_count_inodes_ag(ctx, descr, agno, &ci->counters[agno]);
-	if (!moveon)
-		ci->moveon = false;
+	ci->counters[agno] = nr;
 }
 
-/* Count all the inodes in a filesystem. */
-bool
-xfs_count_all_inodes(
+/*
+ * Count all the inodes in a filesystem.  Returns 0 or a positive error number.
+ */
+int
+scrub_count_all_inodes(
 	struct scrub_ctx	*ctx,
 	uint64_t		*count)
 {
-	struct xfs_count_inodes	*ci;
+	struct count_inodes	*ci;
 	xfs_agnumber_t		agno;
 	struct workqueue	wq;
-	bool			moveon = true;
-	int			ret;
+	int			ret, ret2;
 
-	ci = calloc(1, sizeof(struct xfs_count_inodes) +
+	ci = calloc(1, sizeof(struct count_inodes) +
 			(ctx->mnt.fsgeom.agcount * sizeof(uint64_t)));
 	if (!ci)
-		return false;
-	ci->moveon = true;
+		return errno;
 
 	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
-	if (ret) {
-		moveon = false;
-		str_liberror(ctx, ret, _("creating icount workqueue"));
+	if (ret)
 		goto out_free;
-	}
-	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
-		ret = workqueue_add(&wq, xfs_count_ag_inodes, agno, ci);
-		if (ret) {
-			moveon = false;
-			str_liberror(ctx, ret, _("queueing icount work"));
+
+	for (agno = 0; agno < ctx->mnt.fsgeom.agcount && !ci->error; agno++) {
+		ret = workqueue_add(&wq, count_ag_inodes, agno, ci);
+		if (ret)
 			break;
-		}
 	}
 
-	ret = workqueue_terminate(&wq);
-	if (ret) {
-		moveon = false;
-		str_liberror(ctx, ret, _("finishing icount work"));
-	}
+	ret2 = workqueue_terminate(&wq);
+	if (!ret && ret2)
+		ret = ret2;
 	workqueue_destroy(&wq);
 
-	if (!moveon)
+	if (ci->error) {
+		ret = ci->error;
 		goto out_free;
+	}
 
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++)
 		*count += ci->counters[agno];
-	moveon = ci->moveon;
 
 out_free:
 	free(ci);
-	return moveon;
+	return ret;
 }
 
-/* Estimate the number of blocks and inodes in the filesystem. */
-bool
-xfs_scan_estimate_blocks(
+/*
+ * Estimate the number of blocks and inodes in the filesystem.  Returns 0
+ * or a positive error number.
+ */
+int
+scrub_scan_estimate_blocks(
 	struct scrub_ctx		*ctx,
 	unsigned long long		*d_blocks,
 	unsigned long long		*d_bfree,
@@ -164,17 +136,13 @@ xfs_scan_estimate_blocks(
 
 	/* Grab the fstatvfs counters, since it has to report accurately. */
 	error = fstatvfs(ctx->mnt.fd, &sfs);
-	if (error) {
-		str_errno(ctx, ctx->mntpoint);
-		return false;
-	}
+	if (error)
+		return errno;
 
 	/* Fetch the filesystem counters. */
 	error = ioctl(ctx->mnt.fd, XFS_IOC_FSCOUNTS, &fc);
-	if (error) {
-		str_errno(ctx, ctx->mntpoint);
-		return false;
-	}
+	if (error)
+		return errno;
 
 	/*
 	 * XFS reserves some blocks to prevent hard ENOSPC, so add those
@@ -182,7 +150,8 @@ xfs_scan_estimate_blocks(
 	 */
 	error = ioctl(ctx->mnt.fd, XFS_IOC_GET_RESBLKS, &rb);
 	if (error)
-		str_errno(ctx, ctx->mntpoint);
+		return errno;
+
 	sfs.f_bfree += rb.resblks_avail;
 
 	*d_blocks = sfs.f_blocks;
@@ -194,5 +163,5 @@ xfs_scan_estimate_blocks(
 	*f_files = sfs.f_files;
 	*f_free = sfs.f_ffree;
 
-	return true;
+	return 0;
 }
diff --git a/scrub/fscounters.h b/scrub/fscounters.h
index e3a79740..1fae58a6 100644
--- a/scrub/fscounters.h
+++ b/scrub/fscounters.h
@@ -6,10 +6,10 @@
 #ifndef XFS_SCRUB_FSCOUNTERS_H_
 #define XFS_SCRUB_FSCOUNTERS_H_
 
-bool xfs_scan_estimate_blocks(struct scrub_ctx *ctx,
+int scrub_scan_estimate_blocks(struct scrub_ctx *ctx,
 		unsigned long long *d_blocks, unsigned long long *d_bfree,
 		unsigned long long *r_blocks, unsigned long long *r_bfree,
 		unsigned long long *f_files, unsigned long long *f_free);
-bool xfs_count_all_inodes(struct scrub_ctx *ctx, uint64_t *count);
+int scrub_count_all_inodes(struct scrub_ctx *ctx, uint64_t *count);
 
 #endif /* XFS_SCRUB_FSCOUNTERS_H_ */
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 3c9eec09..7607001a 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -779,17 +779,19 @@ xfs_estimate_verify_work(
 	unsigned long long	r_bfree;
 	unsigned long long	f_files;
 	unsigned long long	f_free;
-	bool			moveon;
+	int			ret;
 
-	moveon = xfs_scan_estimate_blocks(ctx, &d_blocks, &d_bfree,
+	ret = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree,
 				&r_blocks, &r_bfree, &f_files, &f_free);
-	if (!moveon)
-		return moveon;
+	if (ret) {
+		str_liberror(ctx, ret, _("estimating verify work"));
+		return false;
+	}
 
 	*items = cvt_off_fsb_to_b(&ctx->mnt, d_blocks + r_blocks);
 	if (scrub_data == 1)
 		*items -= cvt_off_fsb_to_b(&ctx->mnt, d_bfree + r_bfree);
 	*nr_threads = disk_heads(ctx->datadev);
 	*rshift = 20;
-	return moveon;
+	return true;
 }
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 2622bc45..64e52359 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -156,14 +156,19 @@ xfs_scan_summary(
 	ptvar_free(ptvar);
 
 	/* Scan the whole fs. */
-	moveon = xfs_count_all_inodes(ctx, &counted_inodes);
-	if (!moveon)
+	error = scrub_count_all_inodes(ctx, &counted_inodes);
+	if (error) {
+		str_liberror(ctx, error, _("counting inodes"));
+		moveon = false;
 		goto out;
+	}
 
-	moveon = xfs_scan_estimate_blocks(ctx, &d_blocks, &d_bfree, &r_blocks,
+	error = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree, &r_blocks,
 			&r_bfree, &f_files, &f_free);
-	if (!moveon)
-		return moveon;
+	if (error) {
+		str_liberror(ctx, error, _("estimating verify work"));
+		return false;
+	}
 
 	/*
 	 * If we counted blocks with fsmap, then dblocks includes

