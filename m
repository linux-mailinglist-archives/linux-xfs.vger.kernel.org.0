Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7C39152440
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Feb 2020 01:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgBEArg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Feb 2020 19:47:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34490 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727747AbgBEArg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:47:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150dbuE103535;
        Wed, 5 Feb 2020 00:47:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Li+0K8zAtQHoScML9ahAOXh5GfRyB+l2w9oYG51u/Ac=;
 b=ptcQLk05PPWq4Ai1xM5eKiu8amiBIcTaV2wyVx+OUeiz/+fHc/4+Th7QhlNKJ2pCWmJC
 846WN3zBbjxbqCdvUXgp363tXaU1BnGvwcFUGvvgNfrdnnaOgpoONHpGd15/Q/yfsYJz
 hDcTPOjDsIyzw4FcZCXGGgUPDnWL2ra/sTH/CSP9MT+Z4PZdOzgRillWixd6QadUlKuW
 rtVjoMNnQhBfUfdYcsXt2Q55G00SE3qW0Cj6NQGf+9Nf//YeyjpDMYQI5NKLjvHrKIj+
 TT8I52UmH0ZGa/5kys+dy8Zn+kuMVXWsheHZxeOCSctdffzCMw1SgP0S4hOys5REc1BD jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xykbp00nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:47:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150djPj125282;
        Wed, 5 Feb 2020 00:47:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xykc1gfsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:47:33 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0150lWvH011341;
        Wed, 5 Feb 2020 00:47:32 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:47:32 -0800
Subject: [PATCH 1/4] libxfs: libxfs_buf_delwri_submit should write buffers
 immediately
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 04 Feb 2020 16:47:31 -0800
Message-ID: <158086365123.2079905.12151913907904621987.stgit@magnolia>
In-Reply-To: <158086364511.2079905.3531505051831183875.stgit@magnolia>
References: <158086364511.2079905.3531505051831183875.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=962
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The whole point of libxfs_buf_delwri_submit is to submit a bunch of
buffers for write and wait for the response.  Unfortunately, while it
does mark the buffers dirty, it doesn't actually flush them and lets the
cache mru flusher do it.  This is inconsistent with the kernel API,
which actually writes the buffers and returns any IO errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/rdwr.c   |    3 ++-
 mkfs/xfs_mkfs.c |   16 ++++++++++------
 2 files changed, 12 insertions(+), 7 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 0d9d7202..2e9f66cc 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1491,9 +1491,10 @@ xfs_buf_delwri_submit(
 
 	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
 		list_del_init(&bp->b_list);
-		error2 = libxfs_writebuf(bp, 0);
+		error2 = libxfs_writebufr(bp);
 		if (!error)
 			error = error2;
+		libxfs_putbuf(bp);
 	}
 
 	return error;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5a042917..1f5d2105 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3685,6 +3685,7 @@ main(
 	};
 
 	struct list_head	buffer_list;
+	int			error;
 
 	platform_uuid_generate(&cli.uuid);
 	progname = basename(argv[0]);
@@ -3885,16 +3886,19 @@ main(
 		if (agno % 16)
 			continue;
 
-		if (libxfs_buf_delwri_submit(&buffer_list)) {
-			fprintf(stderr, _("%s: writing AG headers failed\n"),
-					progname);
+		error = -libxfs_buf_delwri_submit(&buffer_list);
+		if (error) {
+			fprintf(stderr,
+	_("%s: writing AG headers failed, err=%d\n"),
+					progname, error);
 			exit(1);
 		}
 	}
 
-	if (libxfs_buf_delwri_submit(&buffer_list)) {
-		fprintf(stderr, _("%s: writing AG headers failed\n"),
-				progname);
+	error = -libxfs_buf_delwri_submit(&buffer_list);
+	if (error) {
+		fprintf(stderr, _("%s: writing AG headers failed, err=%d\n"),
+				progname, error);
 		exit(1);
 	}
 

