Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD3B1C4B63
	for <lists+linux-xfs@lfdr.de>; Tue,  5 May 2020 03:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgEEBNR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 May 2020 21:13:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37802 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgEEBNQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:13:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04513uRe054816
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:13:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=dwejrVZEJQb+E6UzCKOGj54FMqafgeqku5Px760pfSU=;
 b=lKdMmeh477bFrsbwfWPkf0jvmP/FlT7280L+n7cqVAfAMxAPtC7T7efh4UusV1+5BGQb
 bFA/yBWdQdevVSfq5W5WAJq+QZKcSgx7zH/MKi4GkWmpttUGIrNeFvoPY21ztmvEOo0G
 8zxRcv8CETgZ7qL4C8TM02aQHr2iylwGu6z1k6jWNjlWHx61NkEhx68b/8X5CQDB9ZrW
 4ne1TghI/cAjGEQU7wDW8FcDFnJIM9Ygs9wVtaMMVp+qa99PV8C0gG4hzI6355CpwCE0
 zHO5nv8UXAHM382+t6QIbv+ZHi6ifQx2X7u/AGEQctFxDT4rNAwXjP3peKzL4nu0+NQz pQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30s0tma1au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:13:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04516gIk149425
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:11:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30sjjxamyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:11:12 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0451BBGF014792
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:11:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:11:11 -0700
Subject: [PATCH 06/28] xfs: refactor log recovery inode item dispatch for
 pass2 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:11:10 -0700
Message-ID: <158864107031.182683.11762407692516826021.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=3
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the log inode item pass2 commit code into the per-item source code
files and use the dispatch function to call it.  We do these one at a
time because there's a lot of code to move.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode_item_recover.c |  355 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c        |  355 ---------------------------------------
 2 files changed, 355 insertions(+), 355 deletions(-)


diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index a132cacd8d48..2bdba612aa71 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -20,6 +20,8 @@
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_icache.h"
+#include "xfs_bmap_btree.h"
 
 STATIC void
 xlog_recover_inode_ra_pass2(
@@ -39,7 +41,360 @@ xlog_recover_inode_ra_pass2(
 	}
 }
 
+/*
+ * Inode fork owner changes
+ *
+ * If we have been told that we have to reparent the inode fork, it's because an
+ * extent swap operation on a CRC enabled filesystem has been done and we are
+ * replaying it. We need to walk the BMBT of the appropriate fork and change the
+ * owners of it.
+ *
+ * The complexity here is that we don't have an inode context to work with, so
+ * after we've replayed the inode we need to instantiate one.  This is where the
+ * fun begins.
+ *
+ * We are in the middle of log recovery, so we can't run transactions. That
+ * means we cannot use cache coherent inode instantiation via xfs_iget(), as
+ * that will result in the corresponding iput() running the inode through
+ * xfs_inactive(). If we've just replayed an inode core that changes the link
+ * count to zero (i.e. it's been unlinked), then xfs_inactive() will run
+ * transactions (bad!).
+ *
+ * So, to avoid this, we instantiate an inode directly from the inode core we've
+ * just recovered. We have the buffer still locked, and all we really need to
+ * instantiate is the inode core and the forks being modified. We can do this
+ * manually, then run the inode btree owner change, and then tear down the
+ * xfs_inode without having to run any transactions at all.
+ *
+ * Also, because we don't have a transaction context available here but need to
+ * gather all the buffers we modify for writeback so we pass the buffer_list
+ * instead for the operation to use.
+ */
+
+STATIC int
+xfs_recover_inode_owner_change(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip,
+	struct xfs_inode_log_format *in_f,
+	struct list_head	*buffer_list)
+{
+	struct xfs_inode	*ip;
+	int			error;
+
+	ASSERT(in_f->ilf_fields & (XFS_ILOG_DOWNER|XFS_ILOG_AOWNER));
+
+	ip = xfs_inode_alloc(mp, in_f->ilf_ino);
+	if (!ip)
+		return -ENOMEM;
+
+	/* instantiate the inode */
+	ASSERT(dip->di_version >= 3);
+	xfs_inode_from_disk(ip, dip);
+
+	error = xfs_iformat_fork(ip, dip);
+	if (error)
+		goto out_free_ip;
+
+	if (!xfs_inode_verify_forks(ip)) {
+		error = -EFSCORRUPTED;
+		goto out_free_ip;
+	}
+
+	if (in_f->ilf_fields & XFS_ILOG_DOWNER) {
+		ASSERT(in_f->ilf_fields & XFS_ILOG_DBROOT);
+		error = xfs_bmbt_change_owner(NULL, ip, XFS_DATA_FORK,
+					      ip->i_ino, buffer_list);
+		if (error)
+			goto out_free_ip;
+	}
+
+	if (in_f->ilf_fields & XFS_ILOG_AOWNER) {
+		ASSERT(in_f->ilf_fields & XFS_ILOG_ABROOT);
+		error = xfs_bmbt_change_owner(NULL, ip, XFS_ATTR_FORK,
+					      ip->i_ino, buffer_list);
+		if (error)
+			goto out_free_ip;
+	}
+
+out_free_ip:
+	xfs_inode_free(ip);
+	return error;
+}
+
+STATIC int
+xlog_recover_inode_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			current_lsn)
+{
+	struct xfs_inode_log_format	*in_f;
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_buf			*bp;
+	struct xfs_dinode		*dip;
+	int				len;
+	char				*src;
+	char				*dest;
+	int				error;
+	int				attr_index;
+	uint				fields;
+	struct xfs_log_dinode		*ldip;
+	uint				isize;
+	int				need_free = 0;
+
+	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
+		in_f = item->ri_buf[0].i_addr;
+	} else {
+		in_f = kmem_alloc(sizeof(struct xfs_inode_log_format), 0);
+		need_free = 1;
+		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
+		if (error)
+			goto error;
+	}
+
+	/*
+	 * Inode buffers can be freed, look out for it,
+	 * and do not replay the inode.
+	 */
+	if (xlog_is_buffer_cancelled(log, in_f->ilf_blkno, in_f->ilf_len)) {
+		error = 0;
+		trace_xfs_log_recover_inode_cancel(log, in_f);
+		goto error;
+	}
+	trace_xfs_log_recover_inode_recover(log, in_f);
+
+	error = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len,
+			0, &bp, &xfs_inode_buf_ops);
+	if (error)
+		goto error;
+	ASSERT(in_f->ilf_fields & XFS_ILOG_CORE);
+	dip = xfs_buf_offset(bp, in_f->ilf_boffset);
+
+	/*
+	 * Make sure the place we're flushing out to really looks
+	 * like an inode!
+	 */
+	if (XFS_IS_CORRUPT(mp, !xfs_verify_magic16(bp, dip->di_magic))) {
+		xfs_alert(mp,
+	"%s: Bad inode magic number, dip = "PTR_FMT", dino bp = "PTR_FMT", ino = %Ld",
+			__func__, dip, bp, in_f->ilf_ino);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+	ldip = item->ri_buf[1].i_addr;
+	if (XFS_IS_CORRUPT(mp, ldip->di_magic != XFS_DINODE_MAGIC)) {
+		xfs_alert(mp,
+			"%s: Bad inode log record, rec ptr "PTR_FMT", ino %Ld",
+			__func__, item, in_f->ilf_ino);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+
+	/*
+	 * If the inode has an LSN in it, recover the inode only if it's less
+	 * than the lsn of the transaction we are replaying. Note: we still
+	 * need to replay an owner change even though the inode is more recent
+	 * than the transaction as there is no guarantee that all the btree
+	 * blocks are more recent than this transaction, too.
+	 */
+	if (dip->di_version >= 3) {
+		xfs_lsn_t	lsn = be64_to_cpu(dip->di_lsn);
+
+		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
+			trace_xfs_log_recover_inode_skip(log, in_f);
+			error = 0;
+			goto out_owner_change;
+		}
+	}
+
+	/*
+	 * di_flushiter is only valid for v1/2 inodes. All changes for v3 inodes
+	 * are transactional and if ordering is necessary we can determine that
+	 * more accurately by the LSN field in the V3 inode core. Don't trust
+	 * the inode versions we might be changing them here - use the
+	 * superblock flag to determine whether we need to look at di_flushiter
+	 * to skip replay when the on disk inode is newer than the log one
+	 */
+	if (!xfs_sb_version_has_v3inode(&mp->m_sb) &&
+	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
+		/*
+		 * Deal with the wrap case, DI_MAX_FLUSH is less
+		 * than smaller numbers
+		 */
+		if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
+		    ldip->di_flushiter < (DI_MAX_FLUSH >> 1)) {
+			/* do nothing */
+		} else {
+			trace_xfs_log_recover_inode_skip(log, in_f);
+			error = 0;
+			goto out_release;
+		}
+	}
+
+	/* Take the opportunity to reset the flush iteration count */
+	ldip->di_flushiter = 0;
+
+	if (unlikely(S_ISREG(ldip->di_mode))) {
+		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
+		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
+			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
+					 XFS_ERRLEVEL_LOW, mp, ldip,
+					 sizeof(*ldip));
+			xfs_alert(mp,
+		"%s: Bad regular inode log record, rec ptr "PTR_FMT", "
+		"ino ptr = "PTR_FMT", ino bp = "PTR_FMT", ino %Ld",
+				__func__, item, dip, bp, in_f->ilf_ino);
+			error = -EFSCORRUPTED;
+			goto out_release;
+		}
+	} else if (unlikely(S_ISDIR(ldip->di_mode))) {
+		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
+		    (ldip->di_format != XFS_DINODE_FMT_BTREE) &&
+		    (ldip->di_format != XFS_DINODE_FMT_LOCAL)) {
+			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(4)",
+					     XFS_ERRLEVEL_LOW, mp, ldip,
+					     sizeof(*ldip));
+			xfs_alert(mp,
+		"%s: Bad dir inode log record, rec ptr "PTR_FMT", "
+		"ino ptr = "PTR_FMT", ino bp = "PTR_FMT", ino %Ld",
+				__func__, item, dip, bp, in_f->ilf_ino);
+			error = -EFSCORRUPTED;
+			goto out_release;
+		}
+	}
+	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
+		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
+				     XFS_ERRLEVEL_LOW, mp, ldip,
+				     sizeof(*ldip));
+		xfs_alert(mp,
+	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
+	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
+			__func__, item, dip, bp, in_f->ilf_ino,
+			ldip->di_nextents + ldip->di_anextents,
+			ldip->di_nblocks);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
+		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
+				     XFS_ERRLEVEL_LOW, mp, ldip,
+				     sizeof(*ldip));
+		xfs_alert(mp,
+	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
+	"dino bp "PTR_FMT", ino %Ld, forkoff 0x%x", __func__,
+			item, dip, bp, in_f->ilf_ino, ldip->di_forkoff);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+	isize = xfs_log_dinode_size(mp);
+	if (unlikely(item->ri_buf[1].i_len > isize)) {
+		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
+				     XFS_ERRLEVEL_LOW, mp, ldip,
+				     sizeof(*ldip));
+		xfs_alert(mp,
+			"%s: Bad inode log record length %d, rec ptr "PTR_FMT,
+			__func__, item->ri_buf[1].i_len, item);
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+
+	/* recover the log dinode inode into the on disk inode */
+	xfs_log_dinode_to_disk(ldip, dip);
+
+	fields = in_f->ilf_fields;
+	if (fields & XFS_ILOG_DEV)
+		xfs_dinode_put_rdev(dip, in_f->ilf_u.ilfu_rdev);
+
+	if (in_f->ilf_size == 2)
+		goto out_owner_change;
+	len = item->ri_buf[2].i_len;
+	src = item->ri_buf[2].i_addr;
+	ASSERT(in_f->ilf_size <= 4);
+	ASSERT((in_f->ilf_size == 3) || (fields & XFS_ILOG_AFORK));
+	ASSERT(!(fields & XFS_ILOG_DFORK) ||
+	       (len == in_f->ilf_dsize));
+
+	switch (fields & XFS_ILOG_DFORK) {
+	case XFS_ILOG_DDATA:
+	case XFS_ILOG_DEXT:
+		memcpy(XFS_DFORK_DPTR(dip), src, len);
+		break;
+
+	case XFS_ILOG_DBROOT:
+		xfs_bmbt_to_bmdr(mp, (struct xfs_btree_block *)src, len,
+				 (struct xfs_bmdr_block *)XFS_DFORK_DPTR(dip),
+				 XFS_DFORK_DSIZE(dip, mp));
+		break;
+
+	default:
+		/*
+		 * There are no data fork flags set.
+		 */
+		ASSERT((fields & XFS_ILOG_DFORK) == 0);
+		break;
+	}
+
+	/*
+	 * If we logged any attribute data, recover it.  There may or
+	 * may not have been any other non-core data logged in this
+	 * transaction.
+	 */
+	if (in_f->ilf_fields & XFS_ILOG_AFORK) {
+		if (in_f->ilf_fields & XFS_ILOG_DFORK) {
+			attr_index = 3;
+		} else {
+			attr_index = 2;
+		}
+		len = item->ri_buf[attr_index].i_len;
+		src = item->ri_buf[attr_index].i_addr;
+		ASSERT(len == in_f->ilf_asize);
+
+		switch (in_f->ilf_fields & XFS_ILOG_AFORK) {
+		case XFS_ILOG_ADATA:
+		case XFS_ILOG_AEXT:
+			dest = XFS_DFORK_APTR(dip);
+			ASSERT(len <= XFS_DFORK_ASIZE(dip, mp));
+			memcpy(dest, src, len);
+			break;
+
+		case XFS_ILOG_ABROOT:
+			dest = XFS_DFORK_APTR(dip);
+			xfs_bmbt_to_bmdr(mp, (struct xfs_btree_block *)src,
+					 len, (struct xfs_bmdr_block *)dest,
+					 XFS_DFORK_ASIZE(dip, mp));
+			break;
+
+		default:
+			xfs_warn(log->l_mp, "%s: Invalid flag", __func__);
+			ASSERT(0);
+			error = -EFSCORRUPTED;
+			goto out_release;
+		}
+	}
+
+out_owner_change:
+	/* Recover the swapext owner change unless inode has been deleted */
+	if ((in_f->ilf_fields & (XFS_ILOG_DOWNER|XFS_ILOG_AOWNER)) &&
+	    (dip->di_mode != 0))
+		error = xfs_recover_inode_owner_change(mp, dip, in_f,
+						       buffer_list);
+	/* re-generate the checksum. */
+	xfs_dinode_calc_crc(log->l_mp, dip);
+
+	ASSERT(bp->b_mount == mp);
+	bp->b_iodone = xlog_recover_iodone;
+	xfs_buf_delwri_queue(bp, buffer_list);
+
+out_release:
+	xfs_buf_relse(bp);
+error:
+	if (need_free)
+		kmem_free(in_f);
+	return error;
+}
+
 const struct xlog_recover_item_ops xlog_inode_item_ops = {
 	.item_type		= XFS_LI_INODE,
 	.ra_pass2		= xlog_recover_inode_ra_pass2,
+	.commit_pass2		= xlog_recover_inode_commit_pass2,
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index d65dc3895a62..cb5902550e8c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2034,358 +2034,6 @@ xlog_buf_readahead(
 		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
 }
 
-/*
- * Inode fork owner changes
- *
- * If we have been told that we have to reparent the inode fork, it's because an
- * extent swap operation on a CRC enabled filesystem has been done and we are
- * replaying it. We need to walk the BMBT of the appropriate fork and change the
- * owners of it.
- *
- * The complexity here is that we don't have an inode context to work with, so
- * after we've replayed the inode we need to instantiate one.  This is where the
- * fun begins.
- *
- * We are in the middle of log recovery, so we can't run transactions. That
- * means we cannot use cache coherent inode instantiation via xfs_iget(), as
- * that will result in the corresponding iput() running the inode through
- * xfs_inactive(). If we've just replayed an inode core that changes the link
- * count to zero (i.e. it's been unlinked), then xfs_inactive() will run
- * transactions (bad!).
- *
- * So, to avoid this, we instantiate an inode directly from the inode core we've
- * just recovered. We have the buffer still locked, and all we really need to
- * instantiate is the inode core and the forks being modified. We can do this
- * manually, then run the inode btree owner change, and then tear down the
- * xfs_inode without having to run any transactions at all.
- *
- * Also, because we don't have a transaction context available here but need to
- * gather all the buffers we modify for writeback so we pass the buffer_list
- * instead for the operation to use.
- */
-
-STATIC int
-xfs_recover_inode_owner_change(
-	struct xfs_mount	*mp,
-	struct xfs_dinode	*dip,
-	struct xfs_inode_log_format *in_f,
-	struct list_head	*buffer_list)
-{
-	struct xfs_inode	*ip;
-	int			error;
-
-	ASSERT(in_f->ilf_fields & (XFS_ILOG_DOWNER|XFS_ILOG_AOWNER));
-
-	ip = xfs_inode_alloc(mp, in_f->ilf_ino);
-	if (!ip)
-		return -ENOMEM;
-
-	/* instantiate the inode */
-	ASSERT(dip->di_version >= 3);
-	xfs_inode_from_disk(ip, dip);
-
-	error = xfs_iformat_fork(ip, dip);
-	if (error)
-		goto out_free_ip;
-
-	if (!xfs_inode_verify_forks(ip)) {
-		error = -EFSCORRUPTED;
-		goto out_free_ip;
-	}
-
-	if (in_f->ilf_fields & XFS_ILOG_DOWNER) {
-		ASSERT(in_f->ilf_fields & XFS_ILOG_DBROOT);
-		error = xfs_bmbt_change_owner(NULL, ip, XFS_DATA_FORK,
-					      ip->i_ino, buffer_list);
-		if (error)
-			goto out_free_ip;
-	}
-
-	if (in_f->ilf_fields & XFS_ILOG_AOWNER) {
-		ASSERT(in_f->ilf_fields & XFS_ILOG_ABROOT);
-		error = xfs_bmbt_change_owner(NULL, ip, XFS_ATTR_FORK,
-					      ip->i_ino, buffer_list);
-		if (error)
-			goto out_free_ip;
-	}
-
-out_free_ip:
-	xfs_inode_free(ip);
-	return error;
-}
-
-STATIC int
-xlog_recover_inode_pass2(
-	struct xlog			*log,
-	struct list_head		*buffer_list,
-	struct xlog_recover_item	*item,
-	xfs_lsn_t			current_lsn)
-{
-	struct xfs_inode_log_format	*in_f;
-	xfs_mount_t		*mp = log->l_mp;
-	xfs_buf_t		*bp;
-	xfs_dinode_t		*dip;
-	int			len;
-	char			*src;
-	char			*dest;
-	int			error;
-	int			attr_index;
-	uint			fields;
-	struct xfs_log_dinode	*ldip;
-	uint			isize;
-	int			need_free = 0;
-
-	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
-		in_f = item->ri_buf[0].i_addr;
-	} else {
-		in_f = kmem_alloc(sizeof(struct xfs_inode_log_format), 0);
-		need_free = 1;
-		error = xfs_inode_item_format_convert(&item->ri_buf[0], in_f);
-		if (error)
-			goto error;
-	}
-
-	/*
-	 * Inode buffers can be freed, look out for it,
-	 * and do not replay the inode.
-	 */
-	if (xlog_is_buffer_cancelled(log, in_f->ilf_blkno, in_f->ilf_len)) {
-		error = 0;
-		trace_xfs_log_recover_inode_cancel(log, in_f);
-		goto error;
-	}
-	trace_xfs_log_recover_inode_recover(log, in_f);
-
-	error = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len,
-			0, &bp, &xfs_inode_buf_ops);
-	if (error)
-		goto error;
-	ASSERT(in_f->ilf_fields & XFS_ILOG_CORE);
-	dip = xfs_buf_offset(bp, in_f->ilf_boffset);
-
-	/*
-	 * Make sure the place we're flushing out to really looks
-	 * like an inode!
-	 */
-	if (XFS_IS_CORRUPT(mp, !xfs_verify_magic16(bp, dip->di_magic))) {
-		xfs_alert(mp,
-	"%s: Bad inode magic number, dip = "PTR_FMT", dino bp = "PTR_FMT", ino = %Ld",
-			__func__, dip, bp, in_f->ilf_ino);
-		error = -EFSCORRUPTED;
-		goto out_release;
-	}
-	ldip = item->ri_buf[1].i_addr;
-	if (XFS_IS_CORRUPT(mp, ldip->di_magic != XFS_DINODE_MAGIC)) {
-		xfs_alert(mp,
-			"%s: Bad inode log record, rec ptr "PTR_FMT", ino %Ld",
-			__func__, item, in_f->ilf_ino);
-		error = -EFSCORRUPTED;
-		goto out_release;
-	}
-
-	/*
-	 * If the inode has an LSN in it, recover the inode only if it's less
-	 * than the lsn of the transaction we are replaying. Note: we still
-	 * need to replay an owner change even though the inode is more recent
-	 * than the transaction as there is no guarantee that all the btree
-	 * blocks are more recent than this transaction, too.
-	 */
-	if (dip->di_version >= 3) {
-		xfs_lsn_t	lsn = be64_to_cpu(dip->di_lsn);
-
-		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
-			trace_xfs_log_recover_inode_skip(log, in_f);
-			error = 0;
-			goto out_owner_change;
-		}
-	}
-
-	/*
-	 * di_flushiter is only valid for v1/2 inodes. All changes for v3 inodes
-	 * are transactional and if ordering is necessary we can determine that
-	 * more accurately by the LSN field in the V3 inode core. Don't trust
-	 * the inode versions we might be changing them here - use the
-	 * superblock flag to determine whether we need to look at di_flushiter
-	 * to skip replay when the on disk inode is newer than the log one
-	 */
-	if (!xfs_sb_version_has_v3inode(&mp->m_sb) &&
-	    ldip->di_flushiter < be16_to_cpu(dip->di_flushiter)) {
-		/*
-		 * Deal with the wrap case, DI_MAX_FLUSH is less
-		 * than smaller numbers
-		 */
-		if (be16_to_cpu(dip->di_flushiter) == DI_MAX_FLUSH &&
-		    ldip->di_flushiter < (DI_MAX_FLUSH >> 1)) {
-			/* do nothing */
-		} else {
-			trace_xfs_log_recover_inode_skip(log, in_f);
-			error = 0;
-			goto out_release;
-		}
-	}
-
-	/* Take the opportunity to reset the flush iteration count */
-	ldip->di_flushiter = 0;
-
-	if (unlikely(S_ISREG(ldip->di_mode))) {
-		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
-		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
-			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
-					 XFS_ERRLEVEL_LOW, mp, ldip,
-					 sizeof(*ldip));
-			xfs_alert(mp,
-		"%s: Bad regular inode log record, rec ptr "PTR_FMT", "
-		"ino ptr = "PTR_FMT", ino bp = "PTR_FMT", ino %Ld",
-				__func__, item, dip, bp, in_f->ilf_ino);
-			error = -EFSCORRUPTED;
-			goto out_release;
-		}
-	} else if (unlikely(S_ISDIR(ldip->di_mode))) {
-		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
-		    (ldip->di_format != XFS_DINODE_FMT_BTREE) &&
-		    (ldip->di_format != XFS_DINODE_FMT_LOCAL)) {
-			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(4)",
-					     XFS_ERRLEVEL_LOW, mp, ldip,
-					     sizeof(*ldip));
-			xfs_alert(mp,
-		"%s: Bad dir inode log record, rec ptr "PTR_FMT", "
-		"ino ptr = "PTR_FMT", ino bp = "PTR_FMT", ino %Ld",
-				__func__, item, dip, bp, in_f->ilf_ino);
-			error = -EFSCORRUPTED;
-			goto out_release;
-		}
-	}
-	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
-		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
-				     XFS_ERRLEVEL_LOW, mp, ldip,
-				     sizeof(*ldip));
-		xfs_alert(mp,
-	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
-	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
-			__func__, item, dip, bp, in_f->ilf_ino,
-			ldip->di_nextents + ldip->di_anextents,
-			ldip->di_nblocks);
-		error = -EFSCORRUPTED;
-		goto out_release;
-	}
-	if (unlikely(ldip->di_forkoff > mp->m_sb.sb_inodesize)) {
-		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(6)",
-				     XFS_ERRLEVEL_LOW, mp, ldip,
-				     sizeof(*ldip));
-		xfs_alert(mp,
-	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
-	"dino bp "PTR_FMT", ino %Ld, forkoff 0x%x", __func__,
-			item, dip, bp, in_f->ilf_ino, ldip->di_forkoff);
-		error = -EFSCORRUPTED;
-		goto out_release;
-	}
-	isize = xfs_log_dinode_size(mp);
-	if (unlikely(item->ri_buf[1].i_len > isize)) {
-		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(7)",
-				     XFS_ERRLEVEL_LOW, mp, ldip,
-				     sizeof(*ldip));
-		xfs_alert(mp,
-			"%s: Bad inode log record length %d, rec ptr "PTR_FMT,
-			__func__, item->ri_buf[1].i_len, item);
-		error = -EFSCORRUPTED;
-		goto out_release;
-	}
-
-	/* recover the log dinode inode into the on disk inode */
-	xfs_log_dinode_to_disk(ldip, dip);
-
-	fields = in_f->ilf_fields;
-	if (fields & XFS_ILOG_DEV)
-		xfs_dinode_put_rdev(dip, in_f->ilf_u.ilfu_rdev);
-
-	if (in_f->ilf_size == 2)
-		goto out_owner_change;
-	len = item->ri_buf[2].i_len;
-	src = item->ri_buf[2].i_addr;
-	ASSERT(in_f->ilf_size <= 4);
-	ASSERT((in_f->ilf_size == 3) || (fields & XFS_ILOG_AFORK));
-	ASSERT(!(fields & XFS_ILOG_DFORK) ||
-	       (len == in_f->ilf_dsize));
-
-	switch (fields & XFS_ILOG_DFORK) {
-	case XFS_ILOG_DDATA:
-	case XFS_ILOG_DEXT:
-		memcpy(XFS_DFORK_DPTR(dip), src, len);
-		break;
-
-	case XFS_ILOG_DBROOT:
-		xfs_bmbt_to_bmdr(mp, (struct xfs_btree_block *)src, len,
-				 (xfs_bmdr_block_t *)XFS_DFORK_DPTR(dip),
-				 XFS_DFORK_DSIZE(dip, mp));
-		break;
-
-	default:
-		/*
-		 * There are no data fork flags set.
-		 */
-		ASSERT((fields & XFS_ILOG_DFORK) == 0);
-		break;
-	}
-
-	/*
-	 * If we logged any attribute data, recover it.  There may or
-	 * may not have been any other non-core data logged in this
-	 * transaction.
-	 */
-	if (in_f->ilf_fields & XFS_ILOG_AFORK) {
-		if (in_f->ilf_fields & XFS_ILOG_DFORK) {
-			attr_index = 3;
-		} else {
-			attr_index = 2;
-		}
-		len = item->ri_buf[attr_index].i_len;
-		src = item->ri_buf[attr_index].i_addr;
-		ASSERT(len == in_f->ilf_asize);
-
-		switch (in_f->ilf_fields & XFS_ILOG_AFORK) {
-		case XFS_ILOG_ADATA:
-		case XFS_ILOG_AEXT:
-			dest = XFS_DFORK_APTR(dip);
-			ASSERT(len <= XFS_DFORK_ASIZE(dip, mp));
-			memcpy(dest, src, len);
-			break;
-
-		case XFS_ILOG_ABROOT:
-			dest = XFS_DFORK_APTR(dip);
-			xfs_bmbt_to_bmdr(mp, (struct xfs_btree_block *)src,
-					 len, (xfs_bmdr_block_t*)dest,
-					 XFS_DFORK_ASIZE(dip, mp));
-			break;
-
-		default:
-			xfs_warn(log->l_mp, "%s: Invalid flag", __func__);
-			ASSERT(0);
-			error = -EFSCORRUPTED;
-			goto out_release;
-		}
-	}
-
-out_owner_change:
-	/* Recover the swapext owner change unless inode has been deleted */
-	if ((in_f->ilf_fields & (XFS_ILOG_DOWNER|XFS_ILOG_AOWNER)) &&
-	    (dip->di_mode != 0))
-		error = xfs_recover_inode_owner_change(mp, dip, in_f,
-						       buffer_list);
-	/* re-generate the checksum. */
-	xfs_dinode_calc_crc(log->l_mp, dip);
-
-	ASSERT(bp->b_mount == mp);
-	bp->b_iodone = xlog_recover_iodone;
-	xfs_buf_delwri_queue(bp, buffer_list);
-
-out_release:
-	xfs_buf_relse(bp);
-error:
-	if (need_free)
-		kmem_free(in_f);
-	return error;
-}
-
 /*
  * Recover a dquot record
  */
@@ -3066,9 +2714,6 @@ xlog_recover_commit_pass2(
 				trans->r_lsn);
 
 	switch (ITEM_TYPE(item)) {
-	case XFS_LI_INODE:
-		return xlog_recover_inode_pass2(log, buffer_list, item,
-						 trans->r_lsn);
 	case XFS_LI_EFI:
 		return xlog_recover_efi_pass2(log, item, trans->r_lsn);
 	case XFS_LI_EFD:

