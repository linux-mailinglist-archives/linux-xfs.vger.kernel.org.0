Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F18B3AB117
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Sep 2019 05:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392137AbfIFDhQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Sep 2019 23:37:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43004 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732799AbfIFDhQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:37:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YAOJ074363;
        Fri, 6 Sep 2019 03:37:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=LgpX/+bj7iIsp8Zi6TzNYtyV0DkfUNjYoyWC3uU2lPM=;
 b=pAyGL4iALopuss+iUiq15+QOrsA2NnogngK6HXxxncnWnyXnHGMqkRJspEujvtDaST8S
 8LayuWoARh4KS7Ntj80iqX/6LiCCi2boqpbtzTPv5DNwSq4puWliVVAzPrlDTp19T4mX
 62Nih4Lnkp+xpXzBVHnHuneG9Se4eizqEVoT9hm7Gc1w/sK8ujMAcvNn9E5nv5i0LRBy
 a2l7LDumsBh3dmuu0CU037q4cCqzE2EKn6nSmdJciMNoHS+nnlE7VhxVlDyQ8tM4j7W0
 Z0Gplxq6nDNe8l3S73Ym1XJOtObGOJkR+qbppTKWm6Yt2TOnzluUBTbmY3ICoe9q6leh hA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2uuf51g36x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:37:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YOTx088452;
        Fri, 6 Sep 2019 03:37:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uu1b99s7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:37:13 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863bC6T015496;
        Fri, 6 Sep 2019 03:37:13 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:37:12 -0700
Subject: [PATCH 09/13] xfs_scrub: fix per-thread counter error communication
 problems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:37:10 -0700
Message-ID: <156774103087.2644719.15423118655626775867.stgit@magnolia>
In-Reply-To: <156774097496.2644719.4441145106129821110.stgit@magnolia>
References: <156774097496.2644719.4441145106129821110.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix all the places in the per-thread counter functions either we fail to
check for runtime errors or fail to communicate them properly to
callers.  Then fix all the callers to report the error messages instead
of hiding them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/counter.c     |   33 ++++++++++++++++++---------------
 scrub/counter.h     |    6 +++---
 scrub/phase3.c      |   23 +++++++++++++++++------
 scrub/progress.c    |   12 +++++++++---
 scrub/read_verify.c |    9 ++++++---
 5 files changed, 53 insertions(+), 30 deletions(-)


diff --git a/scrub/counter.c b/scrub/counter.c
index 49ffbfea..1bb726dc 100644
--- a/scrub/counter.c
+++ b/scrub/counter.c
@@ -26,23 +26,25 @@ struct ptcounter {
 	struct ptvar	*var;
 };
 
-/* Initialize per-thread counter. */
-struct ptcounter *
-ptcounter_init(
-	size_t			nr)
+/* Allocate per-thread counter. */
+int
+ptcounter_alloc(
+	size_t			nr,
+	struct ptcounter	**pp)
 {
 	struct ptcounter	*p;
 	int			ret;
 
 	p = malloc(sizeof(struct ptcounter));
 	if (!p)
-		return NULL;
+		return errno;
 	ret = ptvar_alloc(nr, sizeof(uint64_t), &p->var);
 	if (ret) {
 		free(p);
-		return NULL;
+		return ret;
 	}
-	return p;
+	*pp = p;
+	return 0;
 }
 
 /* Free per-thread counter. */
@@ -55,7 +57,7 @@ ptcounter_free(
 }
 
 /* Add a quantity to the counter. */
-void
+int
 ptcounter_add(
 	struct ptcounter	*ptc,
 	int64_t			nr)
@@ -64,8 +66,10 @@ ptcounter_add(
 	int			ret;
 
 	p = ptvar_get(ptc->var, &ret);
-	assert(ret == 0);
+	if (ret)
+		return ret;
 	*p += nr;
+	return 0;
 }
 
 static int
@@ -82,12 +86,11 @@ ptcounter_val_helper(
 }
 
 /* Return the approximate value of this counter. */
-uint64_t
+int
 ptcounter_value(
-	struct ptcounter	*ptc)
+	struct ptcounter	*ptc,
+	uint64_t		*sum)
 {
-	uint64_t		sum = 0;
-
-	ptvar_foreach(ptc->var, ptcounter_val_helper, &sum);
-	return sum;
+	*sum = 0;
+	return ptvar_foreach(ptc->var, ptcounter_val_helper, sum);
 }
diff --git a/scrub/counter.h b/scrub/counter.h
index 6c501b85..01b65056 100644
--- a/scrub/counter.h
+++ b/scrub/counter.h
@@ -7,9 +7,9 @@
 #define XFS_SCRUB_COUNTER_H_
 
 struct ptcounter;
-struct ptcounter *ptcounter_init(size_t nr);
+int ptcounter_alloc(size_t nr, struct ptcounter **pp);
 void ptcounter_free(struct ptcounter *ptc);
-void ptcounter_add(struct ptcounter *ptc, int64_t nr);
-uint64_t ptcounter_value(struct ptcounter *ptc);
+int ptcounter_add(struct ptcounter *ptc, int64_t nr);
+int ptcounter_value(struct ptcounter *ptc, uint64_t *sum);
 
 #endif /* XFS_SCRUB_COUNTER_H_ */
diff --git a/scrub/phase3.c b/scrub/phase3.c
index a32d1ced..1e908c2c 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -139,7 +139,12 @@ xfs_scrub_inode(
 		goto out;
 
 out:
-	ptcounter_add(icount, 1);
+	error = ptcounter_add(icount, 1);
+	if (error) {
+		str_liberror(ctx, error,
+				_("incrementing scanned inode counter"));
+		return false;
+	}
 	progress_add(1);
 	xfs_action_list_defer(ctx, agno, &alist);
 	if (fd >= 0) {
@@ -158,12 +163,14 @@ xfs_scan_inodes(
 	struct scrub_ctx	*ctx)
 {
 	struct scrub_inode_ctx	ictx;
+	uint64_t		val;
+	int			err;
 	bool			ret;
 
 	ictx.moveon = true;
-	ictx.icount = ptcounter_init(scrub_nproc(ctx));
-	if (!ictx.icount) {
-		str_info(ctx, ctx->mntpoint, _("Could not create counter."));
+	err = ptcounter_alloc(scrub_nproc(ctx), &ictx.icount);
+	if (err) {
+		str_liberror(ctx, err, _("creating scanned inode counter"));
 		return false;
 	}
 
@@ -173,8 +180,12 @@ xfs_scan_inodes(
 	if (!ictx.moveon)
 		goto free;
 	xfs_scrub_report_preen_triggers(ctx);
-	ctx->inodes_checked = ptcounter_value(ictx.icount);
-
+	err = ptcounter_value(ictx.icount, &val);
+	if (err) {
+		str_liberror(ctx, err, _("summing scanned inode counter"));
+		return false;
+	}
+	ctx->inodes_checked = val;
 free:
 	ptcounter_free(ictx.icount);
 	return ictx.moveon;
diff --git a/scrub/progress.c b/scrub/progress.c
index c9a9d286..08c7233e 100644
--- a/scrub/progress.c
+++ b/scrub/progress.c
@@ -119,6 +119,8 @@ progress_report_thread(void *arg)
 
 	pthread_mutex_lock(&pt.lock);
 	while (1) {
+		uint64_t	progress_val;
+
 		/* Every half second. */
 		ret = clock_gettime(CLOCK_REALTIME, &abstime);
 		if (ret)
@@ -131,7 +133,9 @@ progress_report_thread(void *arg)
 		pthread_cond_timedwait(&pt.wakeup, &pt.lock, &abstime);
 		if (pt.terminate)
 			break;
-		progress_report(ptcounter_value(pt.ptc));
+		ret = ptcounter_value(pt.ptc, &progress_val);
+		if (!ret)
+			progress_report(progress_val);
 	}
 	pthread_mutex_unlock(&pt.lock);
 	return NULL;
@@ -187,9 +191,11 @@ progress_init_phase(
 	pt.twiddle = 0;
 	pt.terminate = false;
 
-	pt.ptc = ptcounter_init(nr_threads);
-	if (!pt.ptc)
+	ret = ptcounter_alloc(nr_threads, &pt.ptc);
+	if (ret) {
+		str_liberror(ctx, ret, _("allocating progress counter"));
 		goto out_max;
+	}
 
 	ret = pthread_create(&pt.thread, NULL, progress_report_thread, NULL);
 	if (ret)
diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 95987a9b..b890c92f 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -84,8 +84,8 @@ read_verify_pool_init(
 			RVP_IO_MAX_SIZE);
 	if (error || !rvp->readbuf)
 		goto out_free;
-	rvp->verified_bytes = ptcounter_init(nproc);
-	if (!rvp->verified_bytes)
+	error = ptcounter_alloc(nproc, &rvp->verified_bytes);
+	if (error)
 		goto out_buf;
 	rvp->miniosz = miniosz;
 	rvp->ctx = ctx;
@@ -282,5 +282,8 @@ uint64_t
 read_verify_bytes(
 	struct read_verify_pool		*rvp)
 {
-	return ptcounter_value(rvp->verified_bytes);
+	uint64_t			ret;
+
+	ptcounter_value(rvp->verified_bytes, &ret);
+	return ret;
 }

