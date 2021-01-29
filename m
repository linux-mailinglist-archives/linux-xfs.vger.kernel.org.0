Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FC53083B1
	for <lists+linux-xfs@lfdr.de>; Fri, 29 Jan 2021 03:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhA2CS2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Jan 2021 21:18:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:57674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231575AbhA2CSZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 21:18:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44DC464E01;
        Fri, 29 Jan 2021 02:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611886664;
        bh=LX0sRnqBicIS60tJFW2fF81bLi+meKXCey26EDGxQoM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=smMQ5AVppE+9Wn2EutS+OkW8HNDBUll9ZXtHfiGQUD+pMvYU7evLkt9cJQSuH9uWB
         wH7UClbNge0hGeTGmMsrJwPqslzPpfGMLuiXjdsj8MjA3XZuAb5Q/WZRbWF/EmZGDI
         x35lAJN4WVngTEwCsSqtoJWALrn5K03/4I8joBOIiyMmugrdyydvWEBxGGwspDCZlx
         XlUJ1I9px7je16HjENTXNvb04TUdUC89ZB34o5z7u9pj1H2OM9iF3jZkO3IPGuDBkb
         S63fMlu9/0LW2eBJaMFNXgguxKF8Aet0rN6DcWk6M6ZpXxUxTPYCDFC7byQ2mdC3r5
         WgBmxRSgMe8JA==
Subject: [PATCH 13/13] xfs: clean up xfs_trans_reserve_quota_chown a bit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Thu, 28 Jan 2021 18:17:43 -0800
Message-ID: <161188666386.1943645.5844592158976823487.stgit@magnolia>
In-Reply-To: <161188658869.1943645.4527151504893870676.stgit@magnolia>
References: <161188658869.1943645.4527151504893870676.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Clean up the calling conventions of xfs_trans_reserve_quota_chown a
little bit -- we can pass in a boolean force parameter since that's the
only qmopt that caller care about, and make the obvious deficiencies
more obvious for anyone who someday wants to clean up rt quota.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_ioctl.c       |    2 +-
 fs/xfs/xfs_iops.c        |    3 +--
 fs/xfs/xfs_quota.h       |    4 ++--
 fs/xfs/xfs_trans_dquot.c |   38 +++++++++++++++++++++-----------------
 4 files changed, 25 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index e299fbd9ef13..73cfee8007a8 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1471,7 +1471,7 @@ xfs_ioctl_setattr(
 	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
 	    ip->i_d.di_projid != fa->fsx_projid) {
 		code = xfs_trans_reserve_quota_chown(tp, ip, NULL, NULL, pdqp,
-				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
+				capable(CAP_FOWNER));
 		if (code)	/* out of quota */
 			goto error_trans_cancel;
 	}
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index cb68be87e0a4..51c877ce90bc 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -731,8 +731,7 @@ xfs_setattr_nonsize(
 		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)))) {
 			ASSERT(tp);
 			error = xfs_trans_reserve_quota_chown(tp, ip, udqp,
-					gdqp, NULL, capable(CAP_FOWNER) ?
-					XFS_QMOPT_FORCE_RES : 0);
+					gdqp, NULL, capable(CAP_FOWNER));
 			if (error)	/* out of quota */
 				goto out_cancel;
 		}
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index ef423c5cb4e2..f95a92d7ceaf 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -100,7 +100,7 @@ extern struct xfs_dquot *xfs_qm_vop_chown(struct xfs_trans *,
 		struct xfs_inode *, struct xfs_dquot **, struct xfs_dquot *);
 int xfs_trans_reserve_quota_chown(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
-		struct xfs_dquot *pdqp, unsigned int flags);
+		struct xfs_dquot *pdqp, bool force);
 extern int xfs_qm_dqattach(struct xfs_inode *);
 extern int xfs_qm_dqattach_locked(struct xfs_inode *ip, bool doalloc);
 extern void xfs_qm_dqdetach(struct xfs_inode *);
@@ -165,7 +165,7 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
 static inline int
 xfs_trans_reserve_quota_chown(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
-		struct xfs_dquot *pdqp, unsigned int flags)
+		struct xfs_dquot *pdqp, bool force)
 {
 	return 0;
 }
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 88146280a177..73ef5994d09d 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -846,26 +846,30 @@ xfs_trans_reserve_quota_chown(
 	struct xfs_dquot	*udqp,
 	struct xfs_dquot	*gdqp,
 	struct xfs_dquot	*pdqp,
-	unsigned int		flags)
+	bool			force)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	uint64_t		delblks;
-	unsigned int		blkflags;
-	struct xfs_dquot	*udq_unres = NULL;
+	struct xfs_dquot	*udq_unres = NULL;	/* old dquots */
 	struct xfs_dquot	*gdq_unres = NULL;
 	struct xfs_dquot	*pdq_unres = NULL;
-	struct xfs_dquot	*udq_delblks = NULL;
+	struct xfs_dquot	*udq_delblks = NULL;	/* new dquots */
 	struct xfs_dquot	*gdq_delblks = NULL;
 	struct xfs_dquot	*pdq_delblks = NULL;
+	uint64_t		delblks;
+	unsigned int		qflags = XFS_QMOPT_RES_REGBLKS;
 	int			error;
 
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	/*
+	 * XXX: This function doesn't handle rt quota counts correctly.  We
+	 * don't support mounting with rt+quota so leave this breadcrumb.
+	 */
+	ASSERT(!XFS_IS_REALTIME_INODE(ip));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	delblks = ip->i_delayed_blks;
-	blkflags = XFS_IS_REALTIME_INODE(ip) ?
-			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
+	if (force)
+		qflags |= XFS_QMOPT_FORCE_RES;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
 	    i_uid_read(VFS_I(ip)) != udqp->q_id) {
@@ -898,9 +902,9 @@ xfs_trans_reserve_quota_chown(
 		}
 	}
 
-	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
-				udq_delblks, gdq_delblks, pdq_delblks,
-				ip->i_d.di_nblocks, 1, flags | blkflags);
+	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount, udq_delblks,
+			gdq_delblks, pdq_delblks, ip->i_d.di_nblocks, 1,
+			qflags);
 	if (error)
 		return error;
 
@@ -917,13 +921,13 @@ xfs_trans_reserve_quota_chown(
 		ASSERT(udq_delblks || gdq_delblks || pdq_delblks);
 		ASSERT(udq_unres || gdq_unres || pdq_unres);
 		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-			    udq_delblks, gdq_delblks, pdq_delblks,
-			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
+				udq_delblks, gdq_delblks, pdq_delblks,
+				(xfs_qcnt_t)delblks, 0, qflags);
 		if (error)
 			return error;
-		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-				udq_unres, gdq_unres, pdq_unres,
-				-((xfs_qcnt_t)delblks), 0, blkflags);
+		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount, udq_unres,
+				gdq_unres, pdq_unres, -((xfs_qcnt_t)delblks),
+				0, qflags);
 	}
 
 	return 0;

