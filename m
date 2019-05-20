Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B512437A
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 00:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfETWdM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 18:33:12 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57858 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfETWdM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 18:33:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KMSXoJ119724;
        Mon, 20 May 2019 22:33:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=xAPR8RcB+FT73VX7B7Spaky50R+Uvlc/7jYZO34MR18=;
 b=GR4uNhEmy7WWlEuzPdSJIDkQbOCINMF481oo6re+svtX6x4dZn1QvBQfaAOmaJxpiLwf
 jzCOGpnXOJaj3426FtyudUqE84FZlHdUWqOrzTs88oHyO3xO9D2XiyLUJEsPLOTrvyoj
 rqYgdbY2yOOc6e05sLZnqmumiRKlL5Lznx3dy4khYHoYcGA6ll+bsqvgA3MwsyspckCl
 fLHGpBqo5Aj6by6IczKkvT2VpKZJJpLnh+KX3hG61IZvikkaSjcjn6PkFR6sfwd4FALQ
 ucg1oK8f5d/7zfycf93hSt4bMUJC0AK7LgyqMyKH7wdhIUPnWg1MpkB80g1efcVvLP2m JQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2sj7jdj1vb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 22:33:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KMTSRd035230;
        Mon, 20 May 2019 22:31:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2sks1xute8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 22:31:05 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KMV5Wk025729;
        Mon, 20 May 2019 22:31:05 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 22:31:05 +0000
Subject: [PATCH 2/3] generic/530,
 xfs/501: pass fs shutdown handle to t_open_tmpfiles
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, jefflexu@linux.alibaba.com,
        amir73il@gmail.com, fstests@vger.kernel.org
Date:   Mon, 20 May 2019 15:31:04 -0700
Message-ID: <155839146420.62682.1995545484813176181.stgit@magnolia>
In-Reply-To: <155839145160.62682.10916303376882370723.stgit@magnolia>
References: <155839145160.62682.10916303376882370723.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200138
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

So it turns out that overlayfs can't pass FS_IOC_SHUTDOWN to the lower
filesystems and so xfstests works around this by creating shutdown
helpers for the scratch fs to direct the shutdown ioctl to wherever it
needs to go to shut down the filesystem -- SCRATCH_MNT on normal
filesystems and OVL_BASE_SCRATCH_MNT when -overlay is enabled.  This
means that t_open_tmpfiles cannot simply use one of the open tempfiles
to shut down the filesystem.

Commit f8f57747222 tried to "fix" this by ripping the shutdown code out,
but this made the tests useless.  Fix this instead by creating a
xfstests helper to return a path that can be used to shut down the
filesystem and then pass that path to t_open_tmpfiles so that we can
shut down the filesystem when overlayfs is enabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc             |   11 +++++++++++
 src/t_open_tmpfiles.c |   20 +++++++++++++-------
 tests/generic/530     |    2 +-
 tests/xfs/501         |    2 +-
 4 files changed, 26 insertions(+), 9 deletions(-)


diff --git a/common/rc b/common/rc
index 27c8bb7a..f577e5e3 100644
--- a/common/rc
+++ b/common/rc
@@ -393,6 +393,17 @@ _scratch_shutdown()
 	fi
 }
 
+# Return a file path that can be used to shut down the scratch filesystem.
+# Caller should _require_scratch_shutdown before using this.
+_scratch_shutdown_handle()
+{
+	if [ $FSTYP = "overlay" ]; then
+		echo $OVL_BASE_SCRATCH_MNT
+	else
+		echo $SCRATCH_MNT
+	fi
+}
+
 _test_mount()
 {
     if [ "$FSTYP" == "overlay" ]; then
diff --git a/src/t_open_tmpfiles.c b/src/t_open_tmpfiles.c
index da9390fd..258b0c95 100644
--- a/src/t_open_tmpfiles.c
+++ b/src/t_open_tmpfiles.c
@@ -24,7 +24,7 @@ static int min_fd = -1;
 static int max_fd = -1;
 static unsigned int nr_opened = 0;
 static float start_time;
-static int shutdown_fs = 0;
+static int shutdown_fd = -1;
 
 void clock_time(float *time)
 {
@@ -69,7 +69,7 @@ void die(void)
 				end_time - start_time);
 		fflush(stdout);
 
-		if (shutdown_fs) {
+		if (shutdown_fd >= 0) {
 			/*
 			 * Flush the log so that we have to process the
 			 * unlinked inodes the next time we mount.
@@ -77,7 +77,7 @@ void die(void)
 			int flag = XFS_FSOP_GOING_FLAGS_LOGFLUSH;
 			int ret;
 
-			ret = ioctl(min_fd, XFS_IOC_GOINGDOWN, &flag);
+			ret = ioctl(shutdown_fd, XFS_IOC_GOINGDOWN, &flag);
 			if (ret) {
 				perror("shutdown");
 				exit(2);
@@ -148,8 +148,9 @@ void leak_tmpfile(void)
 
 /*
  * Try to put as many files on the unlinked list and then kill them.
- * The first argument is a directory to chdir into; passing any second arg
- * will shut down the fs instead of closing files.
+ * The first argument is a directory to chdir into; the second argumennt (if
+ * provided) is a file path that will be opened and then used to shut down the
+ * fs before the program exits.
  */
 int main(int argc, char *argv[])
 {
@@ -160,8 +161,13 @@ int main(int argc, char *argv[])
 		if (ret)
 			perror(argv[1]);
 	}
-	if (argc > 2 && !strcmp(argv[2], "shutdown"))
-		shutdown_fs = 1;
+	if (argc > 2) {
+		shutdown_fd = open(argv[2], O_RDONLY);
+		if (shutdown_fd < 0) {
+			perror(argv[2]);
+			return 1;
+		}
+	}
 
 	clock_time(&start_time);
 	while (1)
diff --git a/tests/generic/530 b/tests/generic/530
index b0d188b1..cb874ace 100755
--- a/tests/generic/530
+++ b/tests/generic/530
@@ -49,7 +49,7 @@ ulimit -n $max_files
 
 # Open a lot of unlinked files
 echo create >> $seqres.full
-$here/src/t_open_tmpfiles $SCRATCH_MNT shutdown >> $seqres.full
+$here/src/t_open_tmpfiles $SCRATCH_MNT $(_scratch_shutdown_handle) >> $seqres.full
 
 # Unmount to prove that we can clean it all
 echo umount >> $seqres.full
diff --git a/tests/xfs/501 b/tests/xfs/501
index 974f3414..4be03b31 100755
--- a/tests/xfs/501
+++ b/tests/xfs/501
@@ -54,7 +54,7 @@ ulimit -n $max_files
 
 # Open a lot of unlinked files
 echo create >> $seqres.full
-$here/src/t_open_tmpfiles $SCRATCH_MNT shutdown >> $seqres.full
+$here/src/t_open_tmpfiles $SCRATCH_MNT $(_scratch_shutdown_handle) >> $seqres.full
 
 # Unmount to prove that we can clean it all
 echo umount >> $seqres.full

