Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1F3B3A16
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Sep 2019 14:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732344AbfIPMQh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Sep 2019 08:16:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47690 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731379AbfIPMQh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Sep 2019 08:16:37 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7C79630A76A9
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 12:16:37 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A49E5C1D6
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 12:16:37 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 03/11] xfs: track allocation busy state in allocation cursor
Date:   Mon, 16 Sep 2019 08:16:27 -0400
Message-Id: <20190916121635.43148-4-bfoster@redhat.com>
In-Reply-To: <20190916121635.43148-1-bfoster@redhat.com>
References: <20190916121635.43148-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 16 Sep 2019 12:16:37 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Extend the allocation cursor to track extent busy state for an
allocation attempt. No functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d159377ed603..5c34d4c41761 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -716,6 +716,8 @@ struct xfs_alloc_cur {
 	struct xfs_btree_cur		*cnt;	/* btree cursors */
 	struct xfs_btree_cur		*bnolt;
 	struct xfs_btree_cur		*bnogt;
+	unsigned			busy_gen;/* busy state */
+	bool				busy;
 };
 
 /*
@@ -733,6 +735,9 @@ xfs_alloc_cur_setup(
 
 	ASSERT(args->alignment == 1 || args->type != XFS_ALLOCTYPE_THIS_BNO);
 
+	acur->busy = false;
+	acur->busy_gen = 0;
+
 	/*
 	 * Perform an initial cntbt lookup to check for availability of maxlen
 	 * extents. If this fails, we'll return -ENOSPC to signal the caller to
@@ -1185,8 +1190,6 @@ xfs_alloc_ag_vextent_near(
 	xfs_extlen_t	ltlena;		/* aligned ... */
 	xfs_agblock_t	ltnew;		/* useful start bno of left side */
 	xfs_extlen_t	rlen;		/* length of returned extent */
-	bool		busy;
-	unsigned	busy_gen;
 #ifdef DEBUG
 	/*
 	 * Randomly don't execute the first algorithm.
@@ -1211,7 +1214,6 @@ xfs_alloc_ag_vextent_near(
 	ltlen = 0;
 	gtlena = 0;
 	ltlena = 0;
-	busy = false;
 
 	/*
 	 * Set up cursors and see if there are any free extents as big as
@@ -1290,8 +1292,8 @@ xfs_alloc_ag_vextent_near(
 			if (error)
 				goto out;
 			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
-			busy = xfs_alloc_compute_aligned(args, ltbno, ltlen,
-					&ltbnoa, &ltlena, &busy_gen);
+			acur.busy = xfs_alloc_compute_aligned(args, ltbno, ltlen,
+					&ltbnoa, &ltlena, &acur.busy_gen);
 			if (ltlena < args->minlen)
 				continue;
 			if (ltbnoa < args->min_agbno || ltbnoa > args->max_agbno)
@@ -1373,8 +1375,8 @@ xfs_alloc_ag_vextent_near(
 			if (error)
 				goto out;
 			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
-			busy |= xfs_alloc_compute_aligned(args, ltbno, ltlen,
-					&ltbnoa, &ltlena, &busy_gen);
+			acur.busy |= xfs_alloc_compute_aligned(args, ltbno,
+					ltlen, &ltbnoa, &ltlena, &acur.busy_gen);
 			if (ltlena >= args->minlen && ltbnoa >= args->min_agbno)
 				break;
 			error = xfs_btree_decrement(acur.bnolt, 0, &i);
@@ -1388,8 +1390,8 @@ xfs_alloc_ag_vextent_near(
 			if (error)
 				goto out;
 			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
-			busy |= xfs_alloc_compute_aligned(args, gtbno, gtlen,
-					&gtbnoa, &gtlena, &busy_gen);
+			acur.busy |= xfs_alloc_compute_aligned(args, gtbno,
+					gtlen, &gtbnoa, &gtlena, &acur.busy_gen);
 			if (gtlena >= args->minlen && gtbnoa <= args->max_agbno)
 				break;
 			error = xfs_btree_increment(acur.bnogt, 0, &i);
@@ -1449,9 +1451,10 @@ xfs_alloc_ag_vextent_near(
 	 */
 	if (!xfs_alloc_cur_active(acur.bnolt) &&
 	    !xfs_alloc_cur_active(acur.bnogt)) {
-		if (busy) {
+		if (acur.busy) {
 			trace_xfs_alloc_near_busy(args);
-			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
+			xfs_extent_busy_flush(args->mp, args->pag,
+					      acur.busy_gen);
 			goto restart;
 		}
 		trace_xfs_alloc_size_neither(args);
-- 
2.20.1

