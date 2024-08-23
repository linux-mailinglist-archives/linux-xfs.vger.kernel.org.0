Return-Path: <linux-xfs+bounces-11925-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EA93F95C1C9
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Aug 2024 02:01:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1837EB24732
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Aug 2024 00:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84BFDA3B;
	Fri, 23 Aug 2024 00:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cKVPiTR3"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1BF365;
	Fri, 23 Aug 2024 00:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371283; cv=none; b=O9ErjQttZdB0Bts+I0OH1wOie8V7ljk3cSud/FIMHePvHGi99IGPCx7o6ES5u+oUDGuPh+H21n1WwKpjxVea+Wize5l7wmEpYA4ChbTYbz/nPLkNUfdAXZd22XLWrMXAuNVlzdYQZkuPEmqaD51+woQyz3EfQryCK10YvEfKt2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371283; c=relaxed/simple;
	bh=46LiIuR6+JpkDUb8HzN7eFEsw9pn6pg7fd3b5GOs39k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dIb8WzKOjfqaHulNdnSOi6wjsh23hWJYkozYfiEHlEZS/1PM95SFzamgGikKDvabGMakvRBZqsnA7++QRjX60r4CPnJq2b4GUOTCTWn1gdyBrpKGDICH2E5i9cVCFuf4zPA4YHCyyfGrHaGIq0zwipeHJhimktC64QZd87s15io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cKVPiTR3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1370AC32782;
	Fri, 23 Aug 2024 00:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371283;
	bh=46LiIuR6+JpkDUb8HzN7eFEsw9pn6pg7fd3b5GOs39k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cKVPiTR3cCtHvSuvbwbQdSCyBMUPLfqPOJVsvcd61JjuJrxHmJ4PDTpGsrdMd9UHs
	 xWN0rVLpTKYp0CmGIq83nuoF1yg3PM+ccecIZ9TLdfokihAFJdtyMSVho5ev5tqNX5
	 IOPS6a2slR3jo3KVasEHPL0AHpRjSQKcQyvGL4iUC0qVGB9FPaGatMBAx6RaC9YNPf
	 392Na/i8ILteLo56rosW656F7cJBou0Zeflsms7BJncdzpSb3bzRhU4QfVtYFFvxew
	 OtI2/OUryK5xaIHl3ucn58ywKEDKQKbdR6T65tHdGmwO4Q8/MzMV92UfmeW8WkpJZs
	 mjr/KGP69aCLQ==
Date: Thu, 22 Aug 2024 17:01:22 -0700
Subject: [PATCH 1/1] xfs: introduce new file range commit ioctls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-ID: <172437084278.57211.4355071581143024290.stgit@frogsfrogsfrogs>
In-Reply-To: <172437084258.57211.13522832162579952916.stgit@frogsfrogsfrogs>
References: <172437084258.57211.13522832162579952916.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

This patch introduces two more new ioctls to manage atomic updates to
file contents -- XFS_IOC_START_COMMIT and XFS_IOC_COMMIT_RANGE.  The
commit mechanism here is exactly the same as what XFS_IOC_EXCHANGE_RANGE
does, but with the additional requirement that file2 cannot have changed
since some sampling point.  The start-commit ioctl performs the sampling
of file attributes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h |   26 +++++++++
 fs/xfs/xfs_exchrange.c |  143 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_exchrange.h |   16 +++++
 fs/xfs/xfs_ioctl.c     |    4 +
 fs/xfs/xfs_trace.h     |   57 +++++++++++++++++++
 5 files changed, 243 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 454b63ef72016..c85c8077fac39 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -825,6 +825,30 @@ struct xfs_exchange_range {
 	__u64		flags;		/* see XFS_EXCHANGE_RANGE_* below */
 };
 
+/*
+ * Using the same definition of file2 as struct xfs_exchange_range, commit the
+ * contents of file1 into file2 if file2 has the same inode number, mtime, and
+ * ctime as the arguments provided to the call.  The old contents of file2 will
+ * be moved to file1.
+ *
+ * Returns -EBUSY if there isn't an exact match for the file2 fields.
+ *
+ * Filesystems must be able to restart and complete the operation even after
+ * the system goes down.
+ */
+struct xfs_commit_range {
+	__s32		file1_fd;
+	__u32		pad;		/* must be zeroes */
+	__u64		file1_offset;	/* file1 offset, bytes */
+	__u64		file2_offset;	/* file2 offset, bytes */
+	__u64		length;		/* bytes to exchange */
+
+	__u64		flags;		/* see XFS_EXCHANGE_RANGE_* below */
+
+	/* opaque file2 metadata for freshness checks */
+	__u64		file2_freshness[6];
+};
+
 /*
  * Exchange file data all the way to the ends of both files, and then exchange
  * the file sizes.  This flag can be used to replace a file's contents with a
@@ -997,6 +1021,8 @@ struct xfs_getparents_by_handle {
 #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
 #define XFS_IOC_EXCHANGE_RANGE	     _IOW ('X', 129, struct xfs_exchange_range)
+#define XFS_IOC_START_COMMIT	     _IOR ('X', 130, struct xfs_commit_range)
+#define XFS_IOC_COMMIT_RANGE	     _IOW ('X', 131, struct xfs_commit_range)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index c8a655c92c92f..d0889190ab7ff 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -72,6 +72,34 @@ xfs_exchrange_estimate(
 	return error;
 }
 
+/*
+ * Check that file2's metadata agree with the snapshot that we took for the
+ * range commit request.
+ *
+ * This should be called after the filesystem has locked /all/ inode metadata
+ * against modification.
+ */
+STATIC int
+xfs_exchrange_check_freshness(
+	const struct xfs_exchrange	*fxr,
+	struct xfs_inode		*ip2)
+{
+	struct inode			*inode2 = VFS_I(ip2);
+	struct timespec64		ctime = inode_get_ctime(inode2);
+	struct timespec64		mtime = inode_get_mtime(inode2);
+
+	trace_xfs_exchrange_freshness(fxr, ip2);
+
+	/* Check that file2 hasn't otherwise been modified. */
+	if (fxr->file2_ino != ip2->i_ino ||
+	    fxr->file2_gen != inode2->i_generation ||
+	    !timespec64_equal(&fxr->file2_ctime, &ctime) ||
+	    !timespec64_equal(&fxr->file2_mtime, &mtime))
+		return -EBUSY;
+
+	return 0;
+}
+
 #define QRETRY_IP1	(0x1)
 #define QRETRY_IP2	(0x2)
 
@@ -607,6 +635,12 @@ xfs_exchrange_prep(
 	if (error || fxr->length == 0)
 		return error;
 
+	if (fxr->flags & __XFS_EXCHANGE_RANGE_CHECK_FRESH2) {
+		error = xfs_exchrange_check_freshness(fxr, ip2);
+		if (error)
+			return error;
+	}
+
 	/* Attach dquots to both inodes before changing block maps. */
 	error = xfs_qm_dqattach(ip2);
 	if (error)
@@ -719,7 +753,8 @@ xfs_exchange_range(
 	if (fxr->file1->f_path.mnt != fxr->file2->f_path.mnt)
 		return -EXDEV;
 
-	if (fxr->flags & ~XFS_EXCHANGE_RANGE_ALL_FLAGS)
+	if (fxr->flags & ~(XFS_EXCHANGE_RANGE_ALL_FLAGS |
+			 __XFS_EXCHANGE_RANGE_CHECK_FRESH2))
 		return -EINVAL;
 
 	/* Userspace requests only honored for regular files. */
@@ -802,3 +837,109 @@ xfs_ioc_exchange_range(
 	fdput(file1);
 	return error;
 }
+
+/* Opaque freshness blob for XFS_IOC_COMMIT_RANGE */
+struct xfs_commit_range_fresh {
+	xfs_fsid_t	fsid;		/* m_fixedfsid */
+	__u64		file2_ino;	/* inode number */
+	__s64		file2_mtime;	/* modification time */
+	__s64		file2_ctime;	/* change time */
+	__s32		file2_mtime_nsec; /* mod time, nsec */
+	__s32		file2_ctime_nsec; /* change time, nsec */
+	__u32		file2_gen;	/* inode generation */
+	__u32		magic;		/* zero */
+};
+#define XCR_FRESH_MAGIC	0x444F524B	/* DORK */
+
+/* Set up a commitrange operation by sampling file2's write-related attrs */
+long
+xfs_ioc_start_commit(
+	struct file			*file,
+	struct xfs_commit_range __user	*argp)
+{
+	struct xfs_commit_range		args = { };
+	struct timespec64		ts;
+	struct xfs_commit_range_fresh	*kern_f;
+	struct xfs_commit_range_fresh	__user *user_f;
+	struct inode			*inode2 = file_inode(file);
+	struct xfs_inode		*ip2 = XFS_I(inode2);
+	const unsigned int		lockflags = XFS_IOLOCK_SHARED |
+						    XFS_MMAPLOCK_SHARED |
+						    XFS_ILOCK_SHARED;
+
+	BUILD_BUG_ON(sizeof(struct xfs_commit_range_fresh) !=
+		     sizeof(args.file2_freshness));
+
+	kern_f = (struct xfs_commit_range_fresh *)&args.file2_freshness;
+
+	memcpy(&kern_f->fsid, ip2->i_mount->m_fixedfsid, sizeof(xfs_fsid_t));
+
+	xfs_ilock(ip2, lockflags);
+	ts = inode_get_ctime(inode2);
+	kern_f->file2_ctime		= ts.tv_sec;
+	kern_f->file2_ctime_nsec	= ts.tv_nsec;
+	ts = inode_get_mtime(inode2);
+	kern_f->file2_mtime		= ts.tv_sec;
+	kern_f->file2_mtime_nsec	= ts.tv_nsec;
+	kern_f->file2_ino		= ip2->i_ino;
+	kern_f->file2_gen		= inode2->i_generation;
+	kern_f->magic			= XCR_FRESH_MAGIC;
+	xfs_iunlock(ip2, lockflags);
+
+	user_f = (struct xfs_commit_range_fresh __user *)&argp->file2_freshness;
+	if (copy_to_user(user_f, kern_f, sizeof(*kern_f)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/*
+ * Exchange file1 and file2 contents if file2 has not been written since the
+ * start commit operation.
+ */
+long
+xfs_ioc_commit_range(
+	struct file			*file,
+	struct xfs_commit_range __user	*argp)
+{
+	struct xfs_exchrange		fxr = {
+		.file2			= file,
+	};
+	struct xfs_commit_range		args;
+	struct xfs_commit_range_fresh	*kern_f;
+	struct xfs_inode		*ip2 = XFS_I(file_inode(file));
+	struct xfs_mount		*mp = ip2->i_mount;
+	struct fd			file1;
+	int				error;
+
+	kern_f = (struct xfs_commit_range_fresh *)&args.file2_freshness;
+
+	if (copy_from_user(&args, argp, sizeof(args)))
+		return -EFAULT;
+	if (args.flags & ~XFS_EXCHANGE_RANGE_ALL_FLAGS)
+		return -EINVAL;
+	if (kern_f->magic != XCR_FRESH_MAGIC)
+		return -EBUSY;
+	if (memcmp(&kern_f->fsid, mp->m_fixedfsid, sizeof(xfs_fsid_t)))
+		return -EBUSY;
+
+	fxr.file1_offset	= args.file1_offset;
+	fxr.file2_offset	= args.file2_offset;
+	fxr.length		= args.length;
+	fxr.flags		= args.flags | __XFS_EXCHANGE_RANGE_CHECK_FRESH2;
+	fxr.file2_ino		= kern_f->file2_ino;
+	fxr.file2_gen		= kern_f->file2_gen;
+	fxr.file2_mtime.tv_sec	= kern_f->file2_mtime;
+	fxr.file2_mtime.tv_nsec	= kern_f->file2_mtime_nsec;
+	fxr.file2_ctime.tv_sec	= kern_f->file2_ctime;
+	fxr.file2_ctime.tv_nsec	= kern_f->file2_ctime_nsec;
+
+	file1 = fdget(args.file1_fd);
+	if (!file1.file)
+		return -EBADF;
+	fxr.file1 = file1.file;
+
+	error = xfs_exchange_range(&fxr);
+	fdput(file1);
+	return error;
+}
diff --git a/fs/xfs/xfs_exchrange.h b/fs/xfs/xfs_exchrange.h
index 039abcca546e8..bc1298aba806b 100644
--- a/fs/xfs/xfs_exchrange.h
+++ b/fs/xfs/xfs_exchrange.h
@@ -10,8 +10,12 @@
 #define __XFS_EXCHANGE_RANGE_UPD_CMTIME1	(1ULL << 63)
 #define __XFS_EXCHANGE_RANGE_UPD_CMTIME2	(1ULL << 62)
 
+/* Freshness check required */
+#define __XFS_EXCHANGE_RANGE_CHECK_FRESH2	(1ULL << 61)
+
 #define XFS_EXCHANGE_RANGE_PRIV_FLAGS	(__XFS_EXCHANGE_RANGE_UPD_CMTIME1 | \
-					 __XFS_EXCHANGE_RANGE_UPD_CMTIME2)
+					 __XFS_EXCHANGE_RANGE_UPD_CMTIME2 | \
+					 __XFS_EXCHANGE_RANGE_CHECK_FRESH2)
 
 struct xfs_exchrange {
 	struct file		*file1;
@@ -22,10 +26,20 @@ struct xfs_exchrange {
 	u64			length;
 
 	u64			flags;	/* XFS_EXCHANGE_RANGE flags */
+
+	/* file2 metadata for freshness checks */
+	u64			file2_ino;
+	struct timespec64	file2_mtime;
+	struct timespec64	file2_ctime;
+	u32			file2_gen;
 };
 
 long xfs_ioc_exchange_range(struct file *file,
 		struct xfs_exchange_range __user *argp);
+long xfs_ioc_start_commit(struct file *file,
+		struct xfs_commit_range __user *argp);
+long xfs_ioc_commit_range(struct file *file,
+		struct xfs_commit_range __user	*argp);
 
 struct xfs_exchmaps_req;
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6b13666d4e963..90b3ee21e7fe6 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1518,6 +1518,10 @@ xfs_file_ioctl(
 
 	case XFS_IOC_EXCHANGE_RANGE:
 		return xfs_ioc_exchange_range(filp, arg);
+	case XFS_IOC_START_COMMIT:
+		return xfs_ioc_start_commit(filp, arg);
+	case XFS_IOC_COMMIT_RANGE:
+		return xfs_ioc_commit_range(filp, arg);
 
 	default:
 		return -ENOTTY;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 180ce697305a9..4cf0fa71ba9ce 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4926,7 +4926,8 @@ DEFINE_INODE_ERROR_EVENT(xfs_exchrange_error);
 	{ XFS_EXCHANGE_RANGE_DRY_RUN,		"DRY_RUN" }, \
 	{ XFS_EXCHANGE_RANGE_FILE1_WRITTEN,	"F1_WRITTEN" }, \
 	{ __XFS_EXCHANGE_RANGE_UPD_CMTIME1,	"CMTIME1" }, \
-	{ __XFS_EXCHANGE_RANGE_UPD_CMTIME2,	"CMTIME2" }
+	{ __XFS_EXCHANGE_RANGE_UPD_CMTIME2,	"CMTIME2" }, \
+	{ __XFS_EXCHANGE_RANGE_CHECK_FRESH2,	"FRESH2" }
 
 /* file exchange-range tracepoint class */
 DECLARE_EVENT_CLASS(xfs_exchrange_class,
@@ -4986,6 +4987,60 @@ DEFINE_EXCHRANGE_EVENT(xfs_exchrange_prep);
 DEFINE_EXCHRANGE_EVENT(xfs_exchrange_flush);
 DEFINE_EXCHRANGE_EVENT(xfs_exchrange_mappings);
 
+TRACE_EVENT(xfs_exchrange_freshness,
+	TP_PROTO(const struct xfs_exchrange *fxr, struct xfs_inode *ip2),
+	TP_ARGS(fxr, ip2),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ip2_ino)
+		__field(long long, ip2_mtime)
+		__field(long long, ip2_ctime)
+		__field(int, ip2_mtime_nsec)
+		__field(int, ip2_ctime_nsec)
+
+		__field(xfs_ino_t, file2_ino)
+		__field(long long, file2_mtime)
+		__field(long long, file2_ctime)
+		__field(int, file2_mtime_nsec)
+		__field(int, file2_ctime_nsec)
+	),
+	TP_fast_assign(
+		struct timespec64	ts64;
+		struct inode		*inode2 = VFS_I(ip2);
+
+		__entry->dev = inode2->i_sb->s_dev;
+		__entry->ip2_ino = ip2->i_ino;
+
+		ts64 = inode_get_ctime(inode2);
+		__entry->ip2_ctime = ts64.tv_sec;
+		__entry->ip2_ctime_nsec = ts64.tv_nsec;
+
+		ts64 = inode_get_mtime(inode2);
+		__entry->ip2_mtime = ts64.tv_sec;
+		__entry->ip2_mtime_nsec = ts64.tv_nsec;
+
+		__entry->file2_ino = fxr->file2_ino;
+		__entry->file2_mtime = fxr->file2_mtime.tv_sec;
+		__entry->file2_ctime = fxr->file2_ctime.tv_sec;
+		__entry->file2_mtime_nsec = fxr->file2_mtime.tv_nsec;
+		__entry->file2_ctime_nsec = fxr->file2_ctime.tv_nsec;
+	),
+	TP_printk("dev %d:%d "
+		  "ino 0x%llx mtime %lld:%d ctime %lld:%d -> "
+		  "file 0x%llx mtime %lld:%d ctime %lld:%d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ip2_ino,
+		  __entry->ip2_mtime,
+		  __entry->ip2_mtime_nsec,
+		  __entry->ip2_ctime,
+		  __entry->ip2_ctime_nsec,
+		  __entry->file2_ino,
+		  __entry->file2_mtime,
+		  __entry->file2_mtime_nsec,
+		  __entry->file2_ctime,
+		  __entry->file2_ctime_nsec)
+);
+
 TRACE_EVENT(xfs_exchmaps_overhead,
 	TP_PROTO(struct xfs_mount *mp, unsigned long long bmbt_blocks,
 		 unsigned long long rmapbt_blocks),


