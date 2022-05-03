Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B9B51913E
	for <lists+linux-xfs@lfdr.de>; Wed,  4 May 2022 00:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243566AbiECWVK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 3 May 2022 18:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243562AbiECWVI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 18:21:08 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4269B3EF3D
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 15:17:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 248745345A1
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 08:17:31 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nm0pm-007gGF-2S
        for linux-xfs@vger.kernel.org; Wed, 04 May 2022 08:17:30 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nm0pm-000mGJ-1V
        for linux-xfs@vger.kernel.org;
        Wed, 04 May 2022 08:17:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/10] xfs: hide log iovec alignment constraints
Date:   Wed,  4 May 2022 08:17:21 +1000
Message-Id: <20220503221728.185449-4-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503221728.185449-1-david@fromorbit.com>
References: <20220503221728.185449-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6271a9fb
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=Ic1sBYCpAwEJxfN7YPEA:9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Callers currently have to round out the size of buffers to match the
aligment constraints of log iovecs and xlog_write(). They should not
need to know this detail, so introduce a new function to calculate
the iovec length (for use in ->iop_size implementations). Also
modify xlog_finish_iovec() to round up the length to the correct
alignment so the callers don't need to do this, either.

Convert the only user - inode forks - of this alignment rounding to
use the new interface.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c  | 20 ++++------------
 fs/xfs/xfs_inode_item.c         | 25 ++++++--------------
 fs/xfs/xfs_inode_item_recover.c |  4 ++--
 fs/xfs/xfs_log.h                | 42 ++++++++++++++++++++++++++++++---
 4 files changed, 52 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index a15ff38c3d41..1a4cdf550f6d 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -36,7 +36,7 @@ xfs_init_local_fork(
 	int64_t			size)
 {
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
-	int			mem_size = size, real_size = 0;
+	int			mem_size = size;
 	bool			zero_terminate;
 
 	/*
@@ -50,13 +50,7 @@ xfs_init_local_fork(
 		mem_size++;
 
 	if (size) {
-		/*
-		 * As we round up the allocation here, we need to ensure the
-		 * bytes we don't copy data into are zeroed because the log
-		 * vectors still copy them into the journal.
-		 */
-		real_size = roundup(mem_size, 4);
-		ifp->if_u1.if_data = kmem_zalloc(real_size, KM_NOFS);
+		ifp->if_u1.if_data = kmem_alloc(mem_size, KM_NOFS);
 		memcpy(ifp->if_u1.if_data, data, size);
 		if (zero_terminate)
 			ifp->if_u1.if_data[size] = '\0';
@@ -502,14 +496,8 @@ xfs_idata_realloc(
 		return;
 	}
 
-	/*
-	 * For inline data, the underlying buffer must be a multiple of 4 bytes
-	 * in size so that it can be logged and stay on word boundaries.
-	 * We enforce that here, and use __GFP_ZERO to ensure that size
-	 * extensions always zero the unused roundup area.
-	 */
-	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, roundup(new_size, 4),
-				      GFP_NOFS | __GFP_NOFAIL | __GFP_ZERO);
+	ifp->if_u1.if_data = krealloc(ifp->if_u1.if_data, new_size,
+				      GFP_NOFS | __GFP_NOFAIL);
 	ifp->if_bytes = new_size;
 }
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 00733a18ccdc..721def0639fd 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -71,7 +71,7 @@ xfs_inode_item_data_fork_size(
 	case XFS_DINODE_FMT_LOCAL:
 		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
 		    ip->i_df.if_bytes > 0) {
-			*nbytes += roundup(ip->i_df.if_bytes, 4);
+			*nbytes += xlog_calc_iovec_len(ip->i_df.if_bytes);
 			*nvecs += 1;
 		}
 		break;
@@ -112,7 +112,7 @@ xfs_inode_item_attr_fork_size(
 	case XFS_DINODE_FMT_LOCAL:
 		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
 		    ip->i_afp->if_bytes > 0) {
-			*nbytes += roundup(ip->i_afp->if_bytes, 4);
+			*nbytes += xlog_calc_iovec_len(ip->i_afp->if_bytes);
 			*nvecs += 1;
 		}
 		break;
@@ -204,17 +204,12 @@ xfs_inode_item_format_data_fork(
 			~(XFS_ILOG_DEXT | XFS_ILOG_DBROOT | XFS_ILOG_DEV);
 		if ((iip->ili_fields & XFS_ILOG_DDATA) &&
 		    ip->i_df.if_bytes > 0) {
-			/*
-			 * Round i_bytes up to a word boundary.
-			 * The underlying memory is guaranteed
-			 * to be there by xfs_idata_realloc().
-			 */
-			data_bytes = roundup(ip->i_df.if_bytes, 4);
 			ASSERT(ip->i_df.if_u1.if_data != NULL);
 			ASSERT(ip->i_disk_size > 0);
 			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_ILOCAL,
-					ip->i_df.if_u1.if_data, data_bytes);
-			ilf->ilf_dsize = (unsigned)data_bytes;
+					ip->i_df.if_u1.if_data,
+					ip->i_df.if_bytes);
+			ilf->ilf_dsize = (unsigned)ip->i_df.if_bytes;
 			ilf->ilf_size++;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_DDATA;
@@ -288,17 +283,11 @@ xfs_inode_item_format_attr_fork(
 
 		if ((iip->ili_fields & XFS_ILOG_ADATA) &&
 		    ip->i_afp->if_bytes > 0) {
-			/*
-			 * Round i_bytes up to a word boundary.
-			 * The underlying memory is guaranteed
-			 * to be there by xfs_idata_realloc().
-			 */
-			data_bytes = roundup(ip->i_afp->if_bytes, 4);
 			ASSERT(ip->i_afp->if_u1.if_data != NULL);
 			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_LOCAL,
 					ip->i_afp->if_u1.if_data,
-					data_bytes);
-			ilf->ilf_asize = (unsigned)data_bytes;
+					ip->i_afp->if_bytes);
+			ilf->ilf_asize = (unsigned)ip->i_afp->if_bytes;
 			ilf->ilf_size++;
 		} else {
 			iip->ili_fields &= ~XFS_ILOG_ADATA;
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 6d44f5fd6d7e..d28ffaebd067 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -462,7 +462,7 @@ xlog_recover_inode_commit_pass2(
 	ASSERT(in_f->ilf_size <= 4);
 	ASSERT((in_f->ilf_size == 3) || (fields & XFS_ILOG_AFORK));
 	ASSERT(!(fields & XFS_ILOG_DFORK) ||
-	       (len == in_f->ilf_dsize));
+	       (len == xlog_calc_iovec_len(in_f->ilf_dsize)));
 
 	switch (fields & XFS_ILOG_DFORK) {
 	case XFS_ILOG_DDATA:
@@ -497,7 +497,7 @@ xlog_recover_inode_commit_pass2(
 		}
 		len = item->ri_buf[attr_index].i_len;
 		src = item->ri_buf[attr_index].i_addr;
-		ASSERT(len == in_f->ilf_asize);
+		ASSERT(len == xlog_calc_iovec_len(in_f->ilf_asize));
 
 		switch (in_f->ilf_fields & XFS_ILOG_AFORK) {
 		case XFS_ILOG_ADATA:
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 8dafe8f771c7..3a4f6a4e4eb7 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -21,23 +21,59 @@ struct xfs_log_vec {
 
 #define XFS_LOG_VEC_ORDERED	(-1)
 
+/*
+ * Calculate the log iovec length for a given user buffer length. Intended to be
+ * used by ->iop_size implementations when sizing buffers of arbitrary
+ * alignments.
+ */
+static inline int
+xlog_calc_iovec_len(int len)
+{
+	return roundup(len, sizeof(uint32_t));
+}
+
 void *xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
 		uint type);
 
 static inline void
-xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec, int len)
+xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec,
+		int data_len)
 {
 	struct xlog_op_header	*oph = vec->i_addr;
-
-	/* opheader tracks payload length, logvec tracks region length */
+	int			len;
+
+	/*
+	 * Always round up the length to the correct alignment so callers don't
+	 * need to know anything about this log vec layout requirement. This
+	 * means we have to zero the area the data to be written does not cover.
+	 * This is complicated by fact the payload region is offset into the
+	 * logvec region by the opheader that tracks the payload.
+	 */
+	len = xlog_calc_iovec_len(data_len);
+	if (len - data_len != 0) {
+		char	*buf = vec->i_addr + sizeof(struct xlog_op_header);
+
+		memset(buf + data_len, 0, len - data_len);
+	}
+
+	/*
+	 * The opheader tracks aligned payload length, whilst the logvec tracks
+	 * the overall region length.
+	 */
 	oph->oh_len = cpu_to_be32(len);
 
 	len += sizeof(struct xlog_op_header);
 	lv->lv_buf_len += len;
 	lv->lv_bytes += len;
 	vec->i_len = len;
+
+	/* Catch buffer overruns */
+	ASSERT((void *)lv->lv_buf + lv->lv_bytes <= (void *)lv + lv->lv_size);
 }
 
+/*
+ * Copy the amount of data requested by the caller into a new log iovec.
+ */
 static inline void *
 xlog_copy_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
 		uint type, void *data, int len)
-- 
2.35.1

