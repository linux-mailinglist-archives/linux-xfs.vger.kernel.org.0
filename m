Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99DDF41C9F
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 08:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404623AbfFLGux (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 02:50:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35494 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403835AbfFLGuw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:50:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6miuB055074;
        Wed, 12 Jun 2019 06:50:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=M0AtDlL/Npp7Sa+tj+aICMBQmNyDt+zIYFbxSTggyJ8=;
 b=MdfZToe5aVHZr0jhTU8uAz7C1bKZd+EK1be0XgiJaz7G5f7iJ9yqE4vpr+bUeuxG3vzl
 JGedWbIrgmzuGIStD1GrpXcOXjqLBH7xK7Sx2s8KCyhS0VJhDuEvBW0iwDaJS4NdVbK9
 Zdwt5NUe3tk0ep5yJlcZ/JOYTjHJXt1iWO6RW3yET1W3WnfUC2Vv2DgMQj1ASrB1QQzk
 DPQWc0WmAugOyb+HY3JNIMd6YuCGsQ4l9EXNUoLqEj8KQQGaqSb4VRG70Y3/mn4y3X3V
 4EAvxBhadFm5NUmYYkpIt/MfpxmKhUaszhrcg2Sgrud+zny38WmNeW+u/luib5jvaqES RA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t05nqsc1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 06:50:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6mJQ7177004;
        Wed, 12 Jun 2019 06:48:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2t1jphuvnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 06:48:38 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5C6mb1c014408;
        Wed, 12 Jun 2019 06:48:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Jun 2019 23:48:37 -0700
Subject: [PATCH 10/14] xfs: refactor xfs_iwalk_grab_ichunk
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Tue, 11 Jun 2019 23:48:36 -0700
Message-ID: <156032211661.3774243.18392356280083221766.stgit@magnolia>
In-Reply-To: <156032205136.3774243.15725828509940520561.stgit@magnolia>
References: <156032205136.3774243.15725828509940520561.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906120047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906120047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In preparation for reusing the iwalk code for the inogrp walking code
(aka INUMBERS), move the initial inobt lookup and retrieval code out of
xfs_iwalk_grab_ichunk so that we call the masking code only when we need
to trim out the inodes that came before the cursor in the inobt record
(aka BULKSTAT).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iwalk.c |   79 ++++++++++++++++++++++++++--------------------------
 1 file changed, 39 insertions(+), 40 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index a2102fa94ff5..8c4d7e59f86a 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -98,43 +98,17 @@ xfs_iwalk_ichunk_ra(
 }
 
 /*
- * Lookup the inode chunk that the given @agino lives in and then get the
- * record if we found the chunk.  Set the bits in @irec's free mask that
- * correspond to the inodes before @agino so that we skip them.  This is how we
- * restart an inode walk that was interrupted in the middle of an inode record.
+ * Set the bits in @irec's free mask that correspond to the inodes before
+ * @agino so that we skip them.  This is how we restart an inode walk that was
+ * interrupted in the middle of an inode record.
  */
-STATIC int
-xfs_iwalk_grab_ichunk(
-	struct xfs_btree_cur		*cur,	/* btree cursor */
+STATIC void
+xfs_iwalk_adjust_start(
 	xfs_agino_t			agino,	/* starting inode of chunk */
-	int				*icount,/* return # of inodes grabbed */
 	struct xfs_inobt_rec_incore	*irec)	/* btree record */
 {
 	int				idx;	/* index into inode chunk */
-	int				stat;
 	int				i;
-	int				error = 0;
-
-	/* Lookup the inode chunk that this inode lives in */
-	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &stat);
-	if (error)
-		return error;
-	if (!stat) {
-		*icount = 0;
-		return error;
-	}
-
-	/* Get the record, should always work */
-	error = xfs_inobt_get_rec(cur, irec, &stat);
-	if (error)
-		return error;
-	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, stat == 1);
-
-	/* Check if the record contains the inode in request */
-	if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino) {
-		*icount = 0;
-		return 0;
-	}
 
 	idx = agino - irec->ir_startino;
 
@@ -149,8 +123,6 @@ xfs_iwalk_grab_ichunk(
 	}
 
 	irec->ir_free |= xfs_inobt_maskn(0, idx);
-	*icount = irec->ir_count - irec->ir_freecount;
-	return 0;
 }
 
 /* Allocate memory for a walk. */
@@ -258,7 +230,7 @@ xfs_iwalk_ag_start(
 {
 	struct xfs_mount	*mp = iwag->mp;
 	struct xfs_trans	*tp = iwag->tp;
-	int			icount;
+	struct xfs_inobt_rec_incore *irec;
 	int			error;
 
 	/* Set up a fresh cursor and empty the inobt cache. */
@@ -274,15 +246,40 @@ xfs_iwalk_ag_start(
 	/*
 	 * Otherwise, we have to grab the inobt record where we left off, stuff
 	 * the record into our cache, and then see if there are more records.
-	 * We require a lookup cache of at least two elements so that we don't
-	 * have to deal with tearing down the cursor to walk the records.
+	 * We require a lookup cache of at least two elements so that the
+	 * caller doesn't have to deal with tearing down the cursor to walk the
+	 * records.
 	 */
-	error = xfs_iwalk_grab_ichunk(*curpp, agino, &icount,
-			&iwag->recs[iwag->nr_recs]);
+	error = xfs_inobt_lookup(*curpp, agino, XFS_LOOKUP_LE, has_more);
+	if (error)
+		return error;
+
+	/*
+	 * If the LE lookup at @agino yields no records, jump ahead to the
+	 * inobt cursor increment to see if there are more records to process.
+	 */
+	if (!*has_more)
+		goto out_advance;
+
+	/* Get the record, should always work */
+	irec = &iwag->recs[iwag->nr_recs];
+	error = xfs_inobt_get_rec(*curpp, irec, has_more);
 	if (error)
 		return error;
-	if (icount)
-		iwag->nr_recs++;
+	XFS_WANT_CORRUPTED_RETURN(mp, *has_more == 1);
+
+	/*
+	 * If the LE lookup yielded an inobt record before the cursor position,
+	 * skip it and see if there's another one after it.
+	 */
+	if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino)
+		goto out_advance;
+
+	/*
+	 * If agino fell in the middle of the inode record, make it look like
+	 * the inodes up to agino are free so that we don't return them again.
+	 */
+	xfs_iwalk_adjust_start(agino, irec);
 
 	/*
 	 * set_prefetch is supposed to give us a large enough inobt record
@@ -290,8 +287,10 @@ xfs_iwalk_ag_start(
 	 * body can cache a record without having to check for cache space
 	 * until after it reads an inobt record.
 	 */
+	iwag->nr_recs++;
 	ASSERT(iwag->nr_recs < iwag->sz_recs);
 
+out_advance:
 	return xfs_btree_increment(*curpp, 0, has_more);
 }
 

