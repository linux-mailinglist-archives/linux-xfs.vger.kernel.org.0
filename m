Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A091F572E3
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 22:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfFZUpK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 16:45:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40774 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZUpK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:45:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKhrlT126092;
        Wed, 26 Jun 2019 20:44:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=cFIHg21GShEe76y/TPuV2tacVwIY8cny+h9s+65uVjU=;
 b=aLbe0w19QGQZzb1hY5Sh+AjbZ5HXyYLgRV2UKH3/LOl99pXP9OC3VqeB5agA9wJglYPs
 EyTHrqMa4vUQEu/0lZuFE32XjFs+zxNW7VXQRG2M3X2bxtlHUo32GOqG1p7ZNWvcK0n4
 BAUtqBTebpQhkNX+r57dk6rfKZOvCv2q6/Hkw/X6bI8mjgcrTroZa944nulWhpHFI/zg
 Pj13c3FfW1PgnaGV956ocOk8ztwb+Aine4oHPvsw0P4FrPt6V08/Gq/yl99/kGPtp/WA
 6Ol5XBNyesWkvC6ZUlBSbU4XS6u7bzLRFTlpSMe1HgDBx6s2MKLF4P791g5L6e3H3LkF BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t9c9pvk42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 20:44:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKhtoh010614;
        Wed, 26 Jun 2019 20:44:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2t99f4nvg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 20:44:55 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5QKisXf004011;
        Wed, 26 Jun 2019 20:44:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 13:44:54 -0700
Subject: [PATCH 09/15] xfs: change xfs_iwalk_grab_ichunk to use startino,
 not lastino
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Wed, 26 Jun 2019 13:44:53 -0700
Message-ID: <156158189316.495087.13142269111016512059.stgit@magnolia>
In-Reply-To: <156158183697.495087.5371839759804528321.stgit@magnolia>
References: <156158183697.495087.5371839759804528321.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=828
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260240
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=881 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260240
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that the inode chunk grabbing function is a static function in the
iwalk code, change its behavior so that @agino is the inode where we
want to /start/ the iteration.  This reduces cognitive friction with the
callers and simplifes the code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iwalk.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 99539421ee57..16744fa556c6 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -98,10 +98,10 @@ xfs_iwalk_ichunk_ra(
 }
 
 /*
- * Lookup the inode chunk that the given inode lives in and then get the record
- * if we found the chunk.  If the inode was not the last in the chunk and there
- * are some left allocated, update the data for the pointed-to record as well as
- * return the count of grabbed inodes.
+ * Lookup the inode chunk that the given @agino lives in and then get the
+ * record if we found the chunk.  Set the bits in @irec's free mask that
+ * correspond to the inodes before @agino so that we skip them.  This is how we
+ * restart an inode walk that was interrupted in the middle of an inode record.
  */
 STATIC int
 xfs_iwalk_grab_ichunk(
@@ -112,6 +112,7 @@ xfs_iwalk_grab_ichunk(
 {
 	int				idx;	/* index into inode chunk */
 	int				stat;
+	int				i;
 	int				error = 0;
 
 	/* Lookup the inode chunk that this inode lives in */
@@ -135,24 +136,20 @@ xfs_iwalk_grab_ichunk(
 		return 0;
 	}
 
-	idx = agino - irec->ir_startino + 1;
-	if (idx < XFS_INODES_PER_CHUNK &&
-	    (xfs_inobt_maskn(idx, XFS_INODES_PER_CHUNK - idx) & ~irec->ir_free)) {
-		int	i;
+	idx = agino - irec->ir_startino;
 
-		/* We got a right chunk with some left inodes allocated at it.
-		 * Grab the chunk record.  Mark all the uninteresting inodes
-		 * free -- because they're before our start point.
-		 */
-		for (i = 0; i < idx; i++) {
-			if (XFS_INOBT_MASK(i) & ~irec->ir_free)
-				irec->ir_freecount++;
-		}
-
-		irec->ir_free |= xfs_inobt_maskn(0, idx);
-		*icount = irec->ir_count - irec->ir_freecount;
+	/*
+	 * We got a right chunk with some left inodes allocated at it.  Grab
+	 * the chunk record.  Mark all the uninteresting inodes free because
+	 * they're before our start point.
+	 */
+	for (i = 0; i < idx; i++) {
+		if (XFS_INOBT_MASK(i) & ~irec->ir_free)
+			irec->ir_freecount++;
 	}
 
+	irec->ir_free |= xfs_inobt_maskn(0, idx);
+	*icount = irec->ir_count - irec->ir_freecount;
 	return 0;
 }
 
@@ -281,7 +278,7 @@ xfs_iwalk_ag_start(
 	 * We require a lookup cache of at least two elements so that we don't
 	 * have to deal with tearing down the cursor to walk the records.
 	 */
-	error = xfs_iwalk_grab_ichunk(*curpp, agino - 1, &icount,
+	error = xfs_iwalk_grab_ichunk(*curpp, agino, &icount,
 			&iwag->recs[iwag->nr_recs]);
 	if (error)
 		return error;

