Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0312E82D
	for <lists+linux-xfs@lfdr.de>; Thu, 30 May 2019 00:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfE2W1D (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 May 2019 18:27:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42680 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbfE2W1C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 18:27:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TM4jYo024135
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Y5F7q5sBr8wQt965IrO12rpid2fTyorOrY8mJctsLF4=;
 b=QjC8mmiGZbXITiwoHbNDUjks9fwJ/oB+qnQW9G9UUy3iYLFTSOUx7YEiaL13DCeA8jNE
 N4rbk/7oH09poIMNWG45Jgl5k715Z6vmm1ttfGnzskd3BNDhIEob6nR0DNWUGboaRhDp
 OgT/1Pl8MjR9Tv9Y9Yxxssd2Dr5OiwWgq1EzffliMEESD/FC/xE1MaS0GU1GImjx1sPb
 LaVXXnoZKIzhc0R2ZeI8DCNgaY/AKIsfoiT19HWioPhZSzBrVwro3p+aBs0x+QrkMg4H
 oaW4sjCPOKPtyC9UVwD0YQEyllxRRLoNa/l5YqbVTZRPWIp444OSGvVI1TTFAe7ix3hJ pA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2spw4tmtcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TMQcgD173038
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2sqh73ykwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:00 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4TMQx83003564
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 May 2019 15:26:59 -0700
Subject: [PATCH 07/11] xfs: change xfs_iwalk_grab_ichunk to use startino,
 not lastino
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 May 2019 15:26:58 -0700
Message-ID: <155916881851.757870.17079240504908852762.stgit@magnolia>
In-Reply-To: <155916877311.757870.11060347556535201032.stgit@magnolia>
References: <155916877311.757870.11060347556535201032.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=783
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905290138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=824 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290138
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
---
 fs/xfs/xfs_iwalk.c |   37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 77320c297284..8e7881e95674 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -87,10 +87,10 @@ xfs_iwalk_ichunk_ra(
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
@@ -101,6 +101,7 @@ xfs_iwalk_grab_ichunk(
 {
 	int				idx;	/* index into inode chunk */
 	int				stat;
+	int				i;
 	int				error = 0;
 
 	/* Lookup the inode chunk that this inode lives in */
@@ -124,24 +125,20 @@ xfs_iwalk_grab_ichunk(
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
 
@@ -295,7 +292,7 @@ xfs_iwalk_ag_start(
 	 * We require a lookup cache of at least two elements so that we don't
 	 * have to deal with tearing down the cursor to walk the records.
 	 */
-	error = xfs_iwalk_grab_ichunk(*curpp, agino - 1, &icount,
+	error = xfs_iwalk_grab_ichunk(*curpp, agino, &icount,
 			&iwag->recs[iwag->nr_recs]);
 	if (error)
 		return error;

