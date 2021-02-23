Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68792322585
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Feb 2021 06:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhBWFss (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Feb 2021 00:48:48 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:42101 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230014AbhBWFss (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 00:48:48 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CBC27104060C
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 16:47:54 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEQY5-000AX7-W3
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 16:47:54 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lEQY5-00Dofl-OU
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 16:47:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: type verification is expensive
Date:   Tue, 23 Feb 2021 16:47:46 +1100
Message-Id: <20210223054748.3292734-2-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210223054748.3292734-1-david@fromorbit.com>
References: <20210223054748.3292734-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=NuCpFDova00jneZWLDgA:9
        a=VYulwihJHBYJMpFq:21 a=7EeG--xdTkWisC3H:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

From a concurrent rm -rf workload:

  41.04%  [kernel]  [k] xfs_dir3_leaf_check_int
   9.85%  [kernel]  [k] __xfs_dir3_data_check
   5.60%  [kernel]  [k] xfs_verify_ino
   5.32%  [kernel]  [k] xfs_agino_range
   4.21%  [kernel]  [k] memcpy
   3.06%  [kernel]  [k] xfs_errortag_test
   2.57%  [kernel]  [k] xfs_dir_ino_validate
   1.66%  [kernel]  [k] xfs_dir2_data_get_ftype
   1.17%  [kernel]  [k] do_raw_spin_lock
   1.11%  [kernel]  [k] xfs_verify_dir_ino
   0.84%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock
   0.83%  [kernel]  [k] xfs_buf_find
   0.64%  [kernel]  [k] xfs_log_commit_cil

THere's an awful lot of overhead in just range checking inode
numbers in that, but each inode number check is not a lot of code.
The total is a bit over 14.5% of the CPU time is spent validating
inode numbers.

The problem is that they deeply nested global scope functions so the
overhead here is all in function call marshalling.

   text	   data	    bss	    dec	    hex	filename
   2077	      0	      0	   2077	    81d fs/xfs/libxfs/xfs_types.o.orig
   2197	      0	      0	   2197	    895	fs/xfs/libxfs/xfs_types.o

There's a small increase in binary size by inlining all the local
nested calls in the verifier functions, but the same workload now
profiles as:

  40.69%  [kernel]  [k] xfs_dir3_leaf_check_int
  10.52%  [kernel]  [k] __xfs_dir3_data_check
   6.68%  [kernel]  [k] xfs_verify_dir_ino
   4.22%  [kernel]  [k] xfs_errortag_test
   4.15%  [kernel]  [k] memcpy
   3.53%  [kernel]  [k] xfs_dir_ino_validate
   1.87%  [kernel]  [k] xfs_dir2_data_get_ftype
   1.37%  [kernel]  [k] do_raw_spin_lock
   0.98%  [kernel]  [k] xfs_buf_find
   0.94%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock
   0.73%  [kernel]  [k] xfs_log_commit_cil

Now we only spend just over 10% of the time validing inode numbers
for the same workload. Hence a few "inline" keyworks is good enough
to reduce the validation overhead by 30%...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_types.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index b254fbeaaa50..04801362e1a7 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -13,7 +13,7 @@
 #include "xfs_mount.h"
 
 /* Find the size of the AG, in blocks. */
-xfs_agblock_t
+inline xfs_agblock_t
 xfs_ag_block_count(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
@@ -29,7 +29,7 @@ xfs_ag_block_count(
  * Verify that an AG block number pointer neither points outside the AG
  * nor points at static metadata.
  */
-bool
+inline bool
 xfs_verify_agbno(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
@@ -49,7 +49,7 @@ xfs_verify_agbno(
  * Verify that an FS block number pointer neither points outside the
  * filesystem nor points at static AG metadata.
  */
-bool
+inline bool
 xfs_verify_fsbno(
 	struct xfs_mount	*mp,
 	xfs_fsblock_t		fsbno)
@@ -85,7 +85,7 @@ xfs_verify_fsbext(
 }
 
 /* Calculate the first and last possible inode number in an AG. */
-void
+inline void
 xfs_agino_range(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
@@ -116,7 +116,7 @@ xfs_agino_range(
  * Verify that an AG inode number pointer neither points outside the AG
  * nor points at static metadata.
  */
-bool
+inline bool
 xfs_verify_agino(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
@@ -146,7 +146,7 @@ xfs_verify_agino_or_null(
  * Verify that an FS inode number pointer neither points outside the
  * filesystem nor points at static AG metadata.
  */
-bool
+inline bool
 xfs_verify_ino(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
@@ -162,7 +162,7 @@ xfs_verify_ino(
 }
 
 /* Is this an internal inode number? */
-bool
+inline bool
 xfs_internal_inum(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino)
@@ -190,7 +190,7 @@ xfs_verify_dir_ino(
  * Verify that an realtime block number pointer doesn't point off the
  * end of the realtime device.
  */
-bool
+inline bool
 xfs_verify_rtbno(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
@@ -215,7 +215,7 @@ xfs_verify_rtext(
 }
 
 /* Calculate the range of valid icount values. */
-void
+inline void
 xfs_icount_range(
 	struct xfs_mount	*mp,
 	unsigned long long	*min,
-- 
2.28.0

