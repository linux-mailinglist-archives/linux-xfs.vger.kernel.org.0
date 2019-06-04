Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F062B351BB
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 23:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfFDVRJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 17:17:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58660 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfFDVRJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:17:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54KwaVg015256;
        Tue, 4 Jun 2019 21:17:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=vkrJgng1Ih1Tko8QHI245wIvqCUzgBDLxRgio60uX2M=;
 b=QmbOz6YkUJdiFNedX6y1+nTs8FMhpnP7PBBEqKs0V7kDCwYBFVOwlWg6o25u9jq/1Qch
 fZdDH+7ICmXuJSTJluc/KdX4tkmDl2PF45DNHUGxtOrKEA/RmjyqG/XfMOIfCWhQZc1X
 4bRmNb8Ai75kQ8mi25HZHE9N03IPq3/WiaAkJMZqYjvN4d6tLvoMOzc+2AdA6H6AWwMq
 l2jgplTUG2zbNtERp5lpY2OWZN9OnKSMkRy2Yd3E1tNep/k1ZuEGGqJ9dWhpZGi9dpA9
 46/npz4q3PSdeU2DkjRH0X8sdY+hywCSRlKB6FNDWya+QWskAQCzU8eHHshMSNAV7mqX GA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2sugstfjju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 21:17:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LGUMh147736;
        Tue, 4 Jun 2019 21:17:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2swnh9twk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 21:17:04 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x54LH3BO023578;
        Tue, 4 Jun 2019 21:17:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Jun 2019 14:17:02 -0700
Subject: [PATCH 3/3] common: remove obsolete xfs ioctl typedef usage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 04 Jun 2019 14:17:01 -0700
Message-ID: <155968302188.1646947.321648284422396629.stgit@magnolia>
In-Reply-To: <155968300283.1646947.2586545304045786757.stgit@magnolia>
References: <155968300283.1646947.2586545304045786757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=924
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906040133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=963 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906040133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert 'xfs_foo_t' typedef usage to 'struct xfs_foo' in preparation for
changes to some of the xfs ioctls.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 ltp/fsstress.c                      |    8 ++++----
 src/bstat.c                         |    6 +++---
 src/bulkstat_unlink_test.c          |    8 ++++----
 src/bulkstat_unlink_test_modified.c |   10 +++++-----
 src/t_immutable.c                   |   12 ++++++------
 5 files changed, 22 insertions(+), 22 deletions(-)


diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 279da9f1..d41e776c 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -2152,9 +2152,9 @@ bulkstat_f(int opno, long r)
 	int		fd;
 	__u64		last;
 	int		nent;
-	xfs_bstat_t	*t;
+	struct xfs_bstat	*t;
 	int64_t		total;
-        xfs_fsop_bulkreq_t bsr;
+        struct xfs_fsop_bulkreq bsr;
 
 	last = 0;
 	nent = (r % 999) + 2;
@@ -2185,9 +2185,9 @@ bulkstat1_f(int opno, long r)
 	int		good;
 	__u64		ino;
 	struct stat64	s;
-	xfs_bstat_t	t;
+	struct xfs_bstat	t;
 	int		v;
-        xfs_fsop_bulkreq_t bsr;
+        struct xfs_fsop_bulkreq bsr;
         
 
 	good = random() & 1;
diff --git a/src/bstat.c b/src/bstat.c
index e4367cee..3f3dc2c6 100644
--- a/src/bstat.c
+++ b/src/bstat.c
@@ -20,7 +20,7 @@ dotime(void *ti, char *s)
 }
 
 void
-printbstat(xfs_bstat_t *sp)
+printbstat(struct xfs_bstat *sp)
 {
 	printf("ino %lld mode %#o nlink %d uid %d gid %d rdev %#x\n",
 		(long long)sp->bs_ino, sp->bs_mode, sp->bs_nlink,
@@ -64,7 +64,7 @@ main(int argc, char **argv)
 	int		quiet = 0;
 	int		statit = 0;
 	int		verbose = 0;
-	xfs_bstat_t	*t;
+	struct xfs_bstat	*t;
 	int		ret;
 	jdm_fshandle_t	*fshandlep = NULL;
 	int		fd;
@@ -73,7 +73,7 @@ main(int argc, char **argv)
 	char *cc_readlinkbufp;
 	int cc_readlinkbufsz;
 	int 		c;
-	xfs_fsop_bulkreq_t bulkreq;
+	struct xfs_fsop_bulkreq bulkreq;
 
 	while ((c = getopt(argc, argv, "cdl:qv")) != -1) {
 		switch (c) {
diff --git a/src/bulkstat_unlink_test.c b/src/bulkstat_unlink_test.c
index cdf720ef..d78cc2ac 100644
--- a/src/bulkstat_unlink_test.c
+++ b/src/bulkstat_unlink_test.c
@@ -26,8 +26,8 @@ main(int argc, char *argv[])
 
 	struct stat sbuf;
 	ino_t *inodelist;
-	xfs_fsop_bulkreq_t a;
-	xfs_bstat_t *ret;
+	struct xfs_fsop_bulkreq a;
+	struct xfs_bstat *ret;
 	int iterations;
 	char fname[MAXPATHLEN];
 	char *dirname;
@@ -60,7 +60,7 @@ main(int argc, char *argv[])
 		printf("Runing extended checks.\n");
 
 	inodelist = (ino_t *)malloc(nfiles * sizeof(ino_t));
-	ret = (xfs_bstat_t *)malloc(nfiles * sizeof(xfs_bstat_t));
+	ret = (struct xfs_bstat *)malloc(nfiles * sizeof(struct xfs_bstat));
 
 	for (k=0; k < iterations; k++) {
 		int fd[nfiles + 1];
@@ -69,7 +69,7 @@ main(int argc, char *argv[])
 
 		printf("Iteration %d ... (%d files)", k, nfiles);
 
-		memset(&a, 0, sizeof(xfs_fsop_bulkreq_t));
+		memset(&a, 0, sizeof(struct xfs_fsop_bulkreq));
 		a.lastip = (__u64 *)&last_inode;
 		a.icount = nfiles;
 		a.ubuffer = ret;
diff --git a/src/bulkstat_unlink_test_modified.c b/src/bulkstat_unlink_test_modified.c
index 981d80cc..a106749d 100644
--- a/src/bulkstat_unlink_test_modified.c
+++ b/src/bulkstat_unlink_test_modified.c
@@ -27,8 +27,8 @@ main(int argc, char *argv[])
     struct stat sbuf;
     ino_t *inodelist;
     __u32 *genlist;
-    xfs_fsop_bulkreq_t a;
-    xfs_bstat_t *ret;
+    struct xfs_fsop_bulkreq a;
+    struct xfs_bstat *ret;
     int iterations;
     char fname[MAXPATHLEN];
     char *dirname;
@@ -50,7 +50,7 @@ main(int argc, char *argv[])
 
     inodelist = (ino_t *)malloc(nfiles * sizeof(ino_t));
     genlist = (__u32 *)malloc(nfiles * sizeof(__u32));
-    ret = (xfs_bstat_t *)malloc(nfiles * sizeof(xfs_bstat_t));
+    ret = (struct xfs_bstat *)malloc(nfiles * sizeof(struct xfs_bstat));
 
     for (k=0; k < iterations; k++) {
 	xfs_ino_t last_inode = 0;
@@ -61,8 +61,8 @@ main(int argc, char *argv[])
 
 	memset(inodelist, 0, nfiles * sizeof(ino_t));
 	memset(genlist, 0, nfiles * sizeof(__u32));
-	memset(ret, 0, nfiles * sizeof(xfs_bstat_t));
-	memset(&a, 0, sizeof(xfs_fsop_bulkreq_t));
+	memset(ret, 0, nfiles * sizeof(struct xfs_bstat));
+	memset(&a, 0, sizeof(struct xfs_fsop_bulkreq));
 	a.lastip = (__u64 *)&last_inode;
 	a.icount = nfiles;
 	a.ubuffer = ret;
diff --git a/src/t_immutable.c b/src/t_immutable.c
index eadef78f..86c567ed 100644
--- a/src/t_immutable.c
+++ b/src/t_immutable.c
@@ -228,8 +228,8 @@ static int test_immutable(const char *dir)
 
      if (stfs.f_type == XFS_SUPER_MAGIC && !getuid()) {
 	  jdm_fshandle_t *fshandle;
-	  xfs_bstat_t bstat;
-	  xfs_fsop_bulkreq_t  bulkreq;
+	  struct xfs_bstat bstat;
+	  struct xfs_fsop_bulkreq  bulkreq;
 	  xfs_ino_t ino;
 	  char *dirpath;
 
@@ -903,8 +903,8 @@ static int test_append(const char *dir)
 
      if (stfs.f_type == XFS_SUPER_MAGIC && !getuid()) {
 	  jdm_fshandle_t *fshandle;
-	  xfs_bstat_t bstat;
-	  xfs_fsop_bulkreq_t  bulkreq;
+	  struct xfs_bstat bstat;
+	  struct xfs_fsop_bulkreq  bulkreq;
 	  xfs_ino_t ino;
 	  char *dirpath;
 
@@ -1288,8 +1288,8 @@ static int test_append(const char *dir)
 
      if (stfs.f_type == XFS_SUPER_MAGIC && !getuid()) {
           jdm_fshandle_t *fshandle;
-          xfs_bstat_t bstat;
-          xfs_fsop_bulkreq_t  bulkreq;
+          struct xfs_bstat bstat;
+          struct xfs_fsop_bulkreq  bulkreq;
           xfs_ino_t ino;
           char *dirpath;
 

