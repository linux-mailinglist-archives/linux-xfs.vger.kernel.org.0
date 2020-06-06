Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090D61F05C6
	for <lists+linux-xfs@lfdr.de>; Sat,  6 Jun 2020 10:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgFFI2P (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 6 Jun 2020 04:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728598AbgFFI2M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Jun 2020 04:28:12 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFACC08C5C3
        for <linux-xfs@vger.kernel.org>; Sat,  6 Jun 2020 01:28:11 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p21so6264511pgm.13
        for <linux-xfs@vger.kernel.org>; Sat, 06 Jun 2020 01:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZWXKz7uGjj9j4oh4L3iqAqQbfXOPs+3jEy3+yq3popQ=;
        b=tfeT1+OgVoMLcJOOkVmPYZke3n9m8T1wW0X1lyDmNQS0+owQJyZv4Zh4kwUV/WDtA5
         JByajPUn6drZOshgZyLUwZs4wjxl3Bs5phSsXeHK741AG/XZTztVZW1+w+E8DrxlnnOe
         /5aXExeqbJzfSEuXQDEPvMNn0jGKbv25xbUhv/EwKi3C8WC8dunKiB9k1Zb6dLLkZo12
         upZKqqzGaLGGy2bP2UDGTPrm2bWXO5p0PuMhBn6v7ZoiMpRHBRMrooTMg+qy4O3egjmd
         mKfyrhkFNw4Y/oVer7RsKjUfVsiN1BN5S9Ql2f4rw5uht0/t7IrzeAgvKSv2dGSCeUhw
         hikg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZWXKz7uGjj9j4oh4L3iqAqQbfXOPs+3jEy3+yq3popQ=;
        b=RdHu6BZlhrhuwhDA27wMYrKKit4yWohNcTrLA6Eqxi0Z2oc571sgLzUnSfWcQhw2ax
         DPXY30Avj7g+JTtMUDPlelZUncP4M03Fom9fdc/++cRX0bsYAx9iC63eeFnqEykqbpS6
         sJ0bV8jDvqX8BknaU1oT2NLC170MtHN+8Bba6eBcx2vPPYphTF3sMfs9zC3a7p0AlMo3
         tg77hxXrALJ2cuf6e3+kzZN9a98pswF7Z42xSZwnWQB4Gg5VH9EbdbEdaaBC7ML/oYm3
         qDQj0iG/lL5LI/RhltpJ+x3x5eEZ2UhhelQP5+jqqO/mVo6ZgEAmC6PtQK7kTHQCBir8
         wyRg==
X-Gm-Message-State: AOAM531WbBCqkaA2h85IWVxHfz/dT/jyBo4mb/ThA3A3TYTeRh+eGLL8
        nNFET7yUfxdO7GvonLJyOgkVVYfH
X-Google-Smtp-Source: ABdhPJzyk03HuorGfgpy4BAzy1/NXoLTa5Qkl6DnTXfPJhYnRXLa1x799rXIl+ozxegL68JsDVVazA==
X-Received: by 2002:a62:60c3:: with SMTP id u186mr13531943pfb.253.1591432090966;
        Sat, 06 Jun 2020 01:28:10 -0700 (PDT)
Received: from localhost.localdomain ([122.167.144.243])
        by smtp.gmail.com with ESMTPSA id j3sm1678130pfh.87.2020.06.06.01.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2020 01:28:10 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com, hch@infradead.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 1/7] xfs: Fix log reservation calculation for xattr insert operation
Date:   Sat,  6 Jun 2020 13:57:39 +0530
Message-Id: <20200606082745.15174-2-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200606082745.15174-1-chandanrlinux@gmail.com>
References: <20200606082745.15174-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Log space reservation for xattr insert operation is divided into two
parts,
1. Mount time
   - Inode
   - Superblock for accounting space allocations
   - AGF for accounting space used by count, block number, rmap and refcnt
     btrees.

2. The remaining log space can only be calculated at run time because,
   - A local xattr can be large enough to cause a double split of the da
     btree.
   - The value of the xattr can be large enough to be stored in remote
     blocks. The contents of the remote blocks are not logged.

   The log space reservation could be,
   - (XFS_DA_NODE_MAXDEPTH + 1) number of blocks. The "+ 1" is required in
     case xattr is large enough to cause another split of the da btree path.
   - BMBT blocks for storing (XFS_DA_NODE_MAXDEPTH + 1) record
     entries.
   - Space for logging blocks of count, block number, rmap and refcnt btrees.

At present, mount time log reservation includes block count required for a
single split of the dabtree. The dabtree block count is also taken into
account by xfs_attr_calc_size().

Also, AGF log space reservation isn't accounted for.

Due to the reasons mentioned above, log reservation calculation for xattr
insert operation gives an incorrect value.

Apart from the above, xfs_log_calc_max_attrsetm_res() passes byte count as
an argument to XFS_NEXTENTADD_SPACE_RES() instead of block count.

The above mentioned inconsistencies were discoverd when trying to mount a
modified XFS filesystem which uses a 32-bit value as xattr extent counter
caused the following warning messages to be printed on the console,

XFS (loop0): Mounting V4 Filesystem
XFS (loop0): Log size 2560 blocks too small, minimum size is 4035 blocks
XFS (loop0): Log size out of supported range.
XFS (loop0): Continuing onwards, but if log hangs are experienced then please report this message in the bug report.
XFS (loop0): Ending clean mount

To fix the inconsistencies described above, this commit replaces 'mount'
and 'runtime' components with just one static reservation. The new
reservation calculates the log space for the worst case possible i.e. it
considers,
1. Double split of the da btree.
   This happens for large local xattrs.
2. Bmbt blocks required for mapping the contents of a maximum
   sized (i.e. XATTR_SIZE_MAX bytes in size) remote attribute.

Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c        |  6 +---
 fs/xfs/libxfs/xfs_log_rlimit.c  | 29 ------------------
 fs/xfs/libxfs/xfs_trans_resv.c  | 54 +++++++++++++++------------------
 fs/xfs/libxfs/xfs_trans_resv.h  |  5 +--
 fs/xfs/libxfs/xfs_trans_space.h |  7 ++++-
 5 files changed, 32 insertions(+), 69 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 3b1bd6e112f8..a4b23edf887e 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -337,11 +337,7 @@ xfs_attr_set(
 				return error;
 		}
 
-		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-				 M_RES(mp)->tr_attrsetrt.tr_logres *
-					args->total;
-		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
-		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+		tres = M_RES(mp)->tr_attrset;
 		total = args->total;
 	} else {
 		XFS_STATS_INC(mp, xs_attr_remove);
diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index 7f55eb3f3653..7aa9e6684ecd 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -15,27 +15,6 @@
 #include "xfs_da_btree.h"
 #include "xfs_bmap_btree.h"
 
-/*
- * Calculate the maximum length in bytes that would be required for a local
- * attribute value as large attributes out of line are not logged.
- */
-STATIC int
-xfs_log_calc_max_attrsetm_res(
-	struct xfs_mount	*mp)
-{
-	int			size;
-	int			nblks;
-
-	size = xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize) -
-	       MAXNAMELEN - 1;
-	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
-	nblks += XFS_B_TO_FSB(mp, size);
-	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
-
-	return  M_RES(mp)->tr_attrsetm.tr_logres +
-		M_RES(mp)->tr_attrsetrt.tr_logres * nblks;
-}
-
 /*
  * Iterate over the log space reservation table to figure out and return
  * the maximum one in terms of the pre-calculated values which were done
@@ -49,9 +28,6 @@ xfs_log_get_max_trans_res(
 	struct xfs_trans_res	*resp;
 	struct xfs_trans_res	*end_resp;
 	int			log_space = 0;
-	int			attr_space;
-
-	attr_space = xfs_log_calc_max_attrsetm_res(mp);
 
 	resp = (struct xfs_trans_res *)M_RES(mp);
 	end_resp = (struct xfs_trans_res *)(M_RES(mp) + 1);
@@ -64,11 +40,6 @@ xfs_log_get_max_trans_res(
 			*max_resp = *resp;		/* struct copy */
 		}
 	}
-
-	if (attr_space > log_space) {
-		*max_resp = M_RES(mp)->tr_attrsetm;	/* struct copy */
-		max_resp->tr_logres = attr_space;
-	}
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index d1a0848cb52e..b44b521c605c 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -19,6 +19,7 @@
 #include "xfs_trans.h"
 #include "xfs_qm.h"
 #include "xfs_trans_space.h"
+#include "xfs_attr_remote.h"
 
 #define _ALLOC	true
 #define _FREE	false
@@ -698,42 +699,36 @@ xfs_calc_attrinval_reservation(
 }
 
 /*
- * Setting an attribute at mount time.
+ * Setting an attribute.
  *	the inode getting the attribute
  *	the superblock for allocations
- *	the agfs extents are allocated from
+ *	the agf extents are allocated from
  *	the attribute btree * max depth
- *	the inode allocation btree
- * Since attribute transaction space is dependent on the size of the attribute,
- * the calculation is done partially at mount time and partially at runtime(see
- * below).
+ *	the bmbt entries for da btree blocks
+ *	the bmbt entries for remote blocks (if any)
+ *	the allocation btrees.
  */
 STATIC uint
-xfs_calc_attrsetm_reservation(
+xfs_calc_attrset_reservation(
 	struct xfs_mount	*mp)
 {
+	int			max_rmt_blks;
+	int			da_blks;
+	int			bmbt_blks;
+
+	da_blks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
+	bmbt_blks = XFS_DAENTER_BMAPS(mp, XFS_ATTR_FORK);
+
+	max_rmt_blks = xfs_attr3_rmt_blocks(mp, XATTR_SIZE_MAX);
+	bmbt_blks += XFS_NEXTENTADD_SPACE_RES(mp, max_rmt_blks, XFS_ATTR_FORK);
+
 	return XFS_DQUOT_LOGRES(mp) +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH, XFS_FSB_TO_B(mp, 1));
-}
-
-/*
- * Setting an attribute at runtime, transaction space unit per block.
- * 	the superblock for allocations: sector size
- *	the inode bmap btree could join or split: max depth * block size
- * Since the runtime attribute transaction space is dependent on the total
- * blocks needed for the 1st bmap, here we calculate out the space unit for
- * one block so that the caller could figure out the total space according
- * to the attibute extent length in blocks by:
- *	ext * M_RES(mp)->tr_attrsetrt.tr_logres
- */
-STATIC uint
-xfs_calc_attrsetrt_reservation(
-	struct xfs_mount	*mp)
-{
-	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
+		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		xfs_calc_buf_res(da_blks, XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(bmbt_blks, XFS_FSB_TO_B(mp, 1)) +
+		xfs_calc_buf_res(xfs_allocfree_log_count(mp, da_blks),
 				 XFS_FSB_TO_B(mp, 1));
 }
 
@@ -897,9 +892,9 @@ xfs_trans_resv_calc(
 	resp->tr_attrinval.tr_logcount = XFS_ATTRINVAL_LOG_COUNT;
 	resp->tr_attrinval.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_attrsetm.tr_logres = xfs_calc_attrsetm_reservation(mp);
-	resp->tr_attrsetm.tr_logcount = XFS_ATTRSET_LOG_COUNT;
-	resp->tr_attrsetm.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+	resp->tr_attrset.tr_logres = xfs_calc_attrset_reservation(mp);
+	resp->tr_attrset.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+	resp->tr_attrset.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_attrrm.tr_logres = xfs_calc_attrrm_reservation(mp);
 	resp->tr_attrrm.tr_logcount = XFS_ATTRRM_LOG_COUNT;
@@ -942,7 +937,6 @@ xfs_trans_resv_calc(
 	resp->tr_ichange.tr_logres = xfs_calc_ichange_reservation(mp);
 	resp->tr_fsyncts.tr_logres = xfs_calc_swrite_reservation(mp);
 	resp->tr_writeid.tr_logres = xfs_calc_writeid_reservation(mp);
-	resp->tr_attrsetrt.tr_logres = xfs_calc_attrsetrt_reservation(mp);
 	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
 	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
 	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 7241ab28cf84..f50996ae18e6 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -35,10 +35,7 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_writeid;	/* write setuid/setgid file */
 	struct xfs_trans_res	tr_attrinval;	/* attr fork buffer
 						 * invalidation */
-	struct xfs_trans_res	tr_attrsetm;	/* set/create an attribute at
-						 * mount time */
-	struct xfs_trans_res	tr_attrsetrt;	/* set/create an attribute at
-						 * runtime */
+	struct xfs_trans_res	tr_attrset;	/* set/create an attribute */
 	struct xfs_trans_res	tr_attrrm;	/* remove an attribute */
 	struct xfs_trans_res	tr_clearagi;	/* clear agi unlinked bucket */
 	struct xfs_trans_res	tr_growrtalloc;	/* grow realtime allocations */
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 88221c7a04cc..b559af70cf51 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -38,8 +38,13 @@
 
 #define	XFS_DAENTER_1B(mp,w)	\
 	((w) == XFS_DATA_FORK ? (mp)->m_dir_geo->fsbcount : 1)
+/*
+ * xattr set operation can cause the da btree to split once from the
+ * root to leaf and also allocate an extra leaf node. The '1' in the
+ * macro below accounts for the extra leaf node.
+ */
 #define	XFS_DAENTER_DBS(mp,w)	\
-	(XFS_DA_NODE_MAXDEPTH + (((w) == XFS_DATA_FORK) ? 2 : 0))
+	(XFS_DA_NODE_MAXDEPTH + (((w) == XFS_DATA_FORK) ? 2 : 1))
 #define	XFS_DAENTER_BLOCKS(mp,w)	\
 	(XFS_DAENTER_1B(mp,w) * XFS_DAENTER_DBS(mp,w))
 #define	XFS_DAENTER_BMAP1B(mp,w)	\
-- 
2.20.1

