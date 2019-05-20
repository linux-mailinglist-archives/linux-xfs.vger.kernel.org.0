Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCE724372
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 00:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfETWbF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 18:31:05 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56030 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfETWbF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 18:31:05 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KMT5ee120444;
        Mon, 20 May 2019 22:31:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=PKVJ3MD1fXkroL25s/lH3EJ3XuXCH70DbwuohweWwpM=;
 b=u2iBs/UBcqCZ8JnWWO/04ygkmlB+JJVqZIjB8+bIyJj3oMulBRfNGvwwxBB40cCRSIgr
 QPQyCIDveH4KcUNK+aLaVwNR7z7ZXguO+xHRJI6G6+acFxe2kq5OoQQwGxT9EghsDISb
 FL2O+rVcfZiQrYEzSo5PU+MCT61RsjlFl0aFFJwrDORihcqLLJ3t37jDDj/w6Q9wkp/T
 i7MB6tc1SCJdr4onzE6OrB9PJm4vG+QFM8/gEfuNEj77uKaRAl6JcHlBNFU1UsovIdLA
 e9BLsuoQ7rX5xE88KwqxBO0tLNeJdYToAqr7RplYdreeaM9L793DH0X9eM1RBg+Rn5vd lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2sj7jdj1mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 22:31:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KMU0F8065494;
        Mon, 20 May 2019 22:30:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2sm046mp52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 22:30:59 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KMUxOo025684;
        Mon, 20 May 2019 22:30:59 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 22:30:59 +0000
Subject: [PATCH 1/3] generic/530: revert commit f8f57747222
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, jefflexu@linux.alibaba.com,
        amir73il@gmail.com, fstests@vger.kernel.org
Date:   Mon, 20 May 2019 15:30:57 -0700
Message-ID: <155839145791.62682.9311727733965110633.stgit@magnolia>
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

Commit f8f57747222 ("generic/530: fix shutdown failure of generic/530 in
overlay") improperly clears an overlayfs test failure by shutting down
the filesystem after all the tempfiles are closed, which totally defeats
the purpose of both generic/530 and xfs/501.  Revert this commit so we
can fix it properly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 src/t_open_tmpfiles.c |   19 +++++++++++++++++++
 tests/generic/530     |    4 +---
 tests/xfs/501         |    4 +---
 3 files changed, 21 insertions(+), 6 deletions(-)


diff --git a/src/t_open_tmpfiles.c b/src/t_open_tmpfiles.c
index 0393c6bd..da9390fd 100644
--- a/src/t_open_tmpfiles.c
+++ b/src/t_open_tmpfiles.c
@@ -24,6 +24,7 @@ static int min_fd = -1;
 static int max_fd = -1;
 static unsigned int nr_opened = 0;
 static float start_time;
+static int shutdown_fs = 0;
 
 void clock_time(float *time)
 {
@@ -68,6 +69,22 @@ void die(void)
 				end_time - start_time);
 		fflush(stdout);
 
+		if (shutdown_fs) {
+			/*
+			 * Flush the log so that we have to process the
+			 * unlinked inodes the next time we mount.
+			 */
+			int flag = XFS_FSOP_GOING_FLAGS_LOGFLUSH;
+			int ret;
+
+			ret = ioctl(min_fd, XFS_IOC_GOINGDOWN, &flag);
+			if (ret) {
+				perror("shutdown");
+				exit(2);
+			}
+			exit(0);
+		}
+
 		clock_time(&start_time);
 		for (fd = min_fd; fd <= max_fd; fd++)
 			close(fd);
@@ -143,6 +160,8 @@ int main(int argc, char *argv[])
 		if (ret)
 			perror(argv[1]);
 	}
+	if (argc > 2 && !strcmp(argv[2], "shutdown"))
+		shutdown_fs = 1;
 
 	clock_time(&start_time);
 	while (1)
diff --git a/tests/generic/530 b/tests/generic/530
index 56c6d32a..b0d188b1 100755
--- a/tests/generic/530
+++ b/tests/generic/530
@@ -49,9 +49,7 @@ ulimit -n $max_files
 
 # Open a lot of unlinked files
 echo create >> $seqres.full
-$here/src/t_open_tmpfiles $SCRATCH_MNT >> $seqres.full
-_scratch_shutdown -f
-
+$here/src/t_open_tmpfiles $SCRATCH_MNT shutdown >> $seqres.full
 
 # Unmount to prove that we can clean it all
 echo umount >> $seqres.full
diff --git a/tests/xfs/501 b/tests/xfs/501
index 4be9997c..974f3414 100755
--- a/tests/xfs/501
+++ b/tests/xfs/501
@@ -54,9 +54,7 @@ ulimit -n $max_files
 
 # Open a lot of unlinked files
 echo create >> $seqres.full
-$here/src/t_open_tmpfiles $SCRATCH_MNT >> $seqres.full
-_scratch_shutdown -f
-
+$here/src/t_open_tmpfiles $SCRATCH_MNT shutdown >> $seqres.full
 
 # Unmount to prove that we can clean it all
 echo umount >> $seqres.full

