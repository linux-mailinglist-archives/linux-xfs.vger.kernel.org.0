Return-Path: <linux-xfs+bounces-7002-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E053B8A7AC8
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 04:55:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E7481C20CBD
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 02:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 924FA5680;
	Wed, 17 Apr 2024 02:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A+C1J+lh"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529F21878
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 02:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713322503; cv=none; b=fC1oIrOrK34ayIQAIXtOFGjpTSNgQLCgIu/H/RoYSBbN4UsMF41TqBD+xxfmyRZTk2JGMfwG5k8AuqvrRUoeq1zofXIYcT4zIBch+tR40vzVjC3w7RS9bSpd8TgyMU3rUjjBYZN06PMcGslFIU1F+iPGYFbPtiidB/C+WAGWxeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713322503; c=relaxed/simple;
	bh=uKJbRmSaF/DA/5/SMS241GlPjQPrUQ65NL+YnsgPTGk=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5wPHVaoQE3P9tT6JRg3HfOXKjb00PJJ2YmWALH1N+R/nTtcknkD06wdl8SFsqTQ+fi5ihYhH0yaF5YXftQoYw/BxVzZuQvVj5/V38GB1WZnJiAX7uXfnmhwVt5VLxoL4TdlzTaez1RuGpGOV1MmtBk5mLk4hSrqnULF1dykWAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A+C1J+lh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0721C113CE;
	Wed, 17 Apr 2024 02:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713322502;
	bh=uKJbRmSaF/DA/5/SMS241GlPjQPrUQ65NL+YnsgPTGk=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=A+C1J+lhnV3G4Z7fPrw1MeN2akjVtrSiPH0CG2cTytcy0cMeObmfPN9LonxwJYWjT
	 wDuvLEsFRCDBR8UqNGgP8j5n+vJmdgMo8FmpW9XQQQgvkzxjNMULzABbNJrk4q1zen
	 iBW+AZy1uqsfo9IHlTR1FpAYnIwExXXiZcUImIEnoTbAqhdQv9RtBsvoj3cevQgF/6
	 OJT6uyia5ed8man0idtdEJtA989oPLEAUV0cP9d0ZIDGfo63dWkhnF9gKF2IBUMGzn
	 9tE4fQ8MYnBaN+4FYEzFZMofP8fjfucRJhVSILz76xdO1YJiHR+M+lejYMrTRZBwiG
	 F2Psqvgo9hEKg==
Date: Tue, 16 Apr 2024 19:55:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: linux-xfs@vger.kernel.org, hch@lst.de, hch@infradead.org
Subject: [PATCH v13.2.1 3/4] xfs: introduce vectored scrub mode
Message-ID: <20240417025502.GO11948@frogsfrogsfrogs>
References: <171323030233.253873.6726826444851242926.stgit@frogsfrogsfrogs>
 <171323030293.253873.15581752242911696791.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171323030293.253873.15581752242911696791.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Introduce a variant on XFS_SCRUB_METADATA that allows for a vectored
mode.  The caller specifies the principal metadata object that they want
to scrub (allocation group, inode, etc.) once, followed by an array of
scrub types they want called on that object.  The kernel runs the scrub
operations and writes the output flags and errno code to the
corresponding array element.

A new pseudo scrub type BARRIER is introduced to force the kernel to
return to userspace if any corruptions have been found when scrubbing
the previous scrub types in the array.  This enables userspace to
schedule, for example, the sequence:

 1. data fork
 2. barrier
 3. directory

If the data fork scrub is clean, then the kernel will perform the
directory scrub.  If not, the barrier in 2 will exit back to userspace.

The alternative would have been an interface where userspace passes a
pointer to an empty buffer, and the kernel formats that with
xfs_scrub_vecs that tell userspace what it scrubbed and what the outcome
was.  With that the kernel would have to communicate that the buffer
needed to have been at least X size, even though for our cases
XFS_SCRUB_TYPE_NR + 2 would always be enough.

Compared to that, this design keeps all the dependency policy and
ordering logic in userspace where it already resides instead of
duplicating it in the kernel. The downside of that is that it needs the
barrier logic.

When running fstests in "rebuild all metadata after each test" mode, I
observed a 10% reduction in runtime due to fewer transitions across the
system call boundary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v13.2.1: improve commit message
---
 fs/xfs/libxfs/xfs_fs.h   |   33 ++++++++++
 fs/xfs/scrub/scrub.c     |  149 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h     |   79 ++++++++++++++++++++++++
 fs/xfs/scrub/xfs_scrub.h |    2 +
 fs/xfs/xfs_ioctl.c       |    2 +
 5 files changed, 264 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index cc2ee5e0183d1..0071e6b57c561 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -725,6 +725,15 @@ struct xfs_scrub_metadata {
 /* Number of scrub subcommands. */
 #define XFS_SCRUB_TYPE_NR	29
 
+/*
+ * This special type code only applies to the vectored scrub implementation.
+ *
+ * If any of the previous scrub vectors recorded runtime errors or have
+ * sv_flags bits set that match the OFLAG bits in the barrier vector's
+ * sv_flags, set the barrier's sv_ret to -ECANCELED and return to userspace.
+ */
+#define XFS_SCRUB_TYPE_BARRIER	(0xFFFFFFFF)
+
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
 
@@ -769,6 +778,29 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+/* Vectored scrub calls to reduce the number of kernel transitions. */
+
+struct xfs_scrub_vec {
+	__u32 sv_type;		/* XFS_SCRUB_TYPE_* */
+	__u32 sv_flags;		/* XFS_SCRUB_FLAGS_* */
+	__s32 sv_ret;		/* 0 or a negative error code */
+	__u32 sv_reserved;	/* must be zero */
+};
+
+/* Vectored metadata scrub control structure. */
+struct xfs_scrub_vec_head {
+	__u64 svh_ino;		/* inode number. */
+	__u32 svh_gen;		/* inode generation. */
+	__u32 svh_agno;		/* ag number. */
+	__u32 svh_flags;	/* XFS_SCRUB_VEC_FLAGS_* */
+	__u16 svh_rest_us;	/* wait this much time between vector items */
+	__u16 svh_nr;		/* number of svh_vectors */
+	__u64 svh_reserved;	/* must be zero */
+	__u64 svh_vectors;	/* pointer to buffer of xfs_scrub_vec */
+};
+
+#define XFS_SCRUB_VEC_FLAGS_ALL		(0)
+
 /*
  * ioctl limits
  */
@@ -951,6 +983,7 @@ struct xfs_getparents_by_handle {
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
 #define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents)
 #define XFS_IOC_GETPARENTS_BY_HANDLE _IOWR('X', 63, struct xfs_getparents_by_handle)
+#define XFS_IOC_SCRUBV_METADATA	_IOWR('X', 64, struct xfs_scrub_vec_head)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 1456cc11c406d..78b00ab85c9c9 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -21,6 +21,7 @@
 #include "xfs_exchmaps.h"
 #include "xfs_dir2.h"
 #include "xfs_parent.h"
+#include "xfs_icache.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -749,3 +750,151 @@ xfs_ioc_scrub_metadata(
 
 	return 0;
 }
+
+/* Decide if there have been any scrub failures up to this point. */
+static inline int
+xfs_scrubv_check_barrier(
+	struct xfs_mount		*mp,
+	const struct xfs_scrub_vec	*vectors,
+	const struct xfs_scrub_vec	*stop_vec)
+{
+	const struct xfs_scrub_vec	*v;
+	__u32				failmask;
+
+	failmask = stop_vec->sv_flags & XFS_SCRUB_FLAGS_OUT;
+
+	for (v = vectors; v < stop_vec; v++) {
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER)
+			continue;
+
+		/*
+		 * Runtime errors count as a previous failure, except the ones
+		 * used to ask userspace to retry.
+		 */
+		switch (v->sv_ret) {
+		case -EBUSY:
+		case -ENOENT:
+		case -EUSERS:
+		case 0:
+			break;
+		default:
+			return -ECANCELED;
+		}
+
+		/*
+		 * If any of the out-flags on the scrub vector match the mask
+		 * that was set on the barrier vector, that's a previous fail.
+		 */
+		if (v->sv_flags & failmask)
+			return -ECANCELED;
+	}
+
+	return 0;
+}
+
+/* Vectored scrub implementation to reduce ioctl calls. */
+int
+xfs_ioc_scrubv_metadata(
+	struct file			*file,
+	void				__user *arg)
+{
+	struct xfs_scrub_vec_head	head;
+	struct xfs_scrub_vec_head	__user *uhead = arg;
+	struct xfs_scrub_vec		*vectors;
+	struct xfs_scrub_vec		__user *uvectors;
+	struct xfs_inode		*ip_in = XFS_I(file_inode(file));
+	struct xfs_mount		*mp = ip_in->i_mount;
+	struct xfs_scrub_vec		*v;
+	size_t				vec_bytes;
+	unsigned int			i;
+	int				error = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(&head, uhead, sizeof(head)))
+		return -EFAULT;
+
+	if (head.svh_reserved)
+		return -EINVAL;
+	if (head.svh_flags & ~XFS_SCRUB_VEC_FLAGS_ALL)
+		return -EINVAL;
+	if (head.svh_nr == 0)
+		return 0;
+
+	vec_bytes = array_size(head.svh_nr, sizeof(struct xfs_scrub_vec));
+	if (vec_bytes > PAGE_SIZE)
+		return -ENOMEM;
+
+	uvectors = (void __user *)(uintptr_t)head.svh_vectors;
+	vectors = memdup_user(uvectors, vec_bytes);
+	if (IS_ERR(vectors))
+		return PTR_ERR(vectors);
+
+	trace_xchk_scrubv_start(ip_in, &head);
+
+	for (i = 0, v = vectors; i < head.svh_nr; i++, v++) {
+		if (v->sv_reserved) {
+			error = -EINVAL;
+			goto out_free;
+		}
+
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER &&
+		    (v->sv_flags & ~XFS_SCRUB_FLAGS_OUT)) {
+			error = -EINVAL;
+			goto out_free;
+		}
+
+		trace_xchk_scrubv_item(mp, &head, i, v);
+	}
+
+	/* Run all the scrubbers. */
+	for (i = 0, v = vectors; i < head.svh_nr; i++, v++) {
+		struct xfs_scrub_metadata	sm = {
+			.sm_type		= v->sv_type,
+			.sm_flags		= v->sv_flags,
+			.sm_ino			= head.svh_ino,
+			.sm_gen			= head.svh_gen,
+			.sm_agno		= head.svh_agno,
+		};
+
+		if (v->sv_type == XFS_SCRUB_TYPE_BARRIER) {
+			v->sv_ret = xfs_scrubv_check_barrier(mp, vectors, v);
+			if (v->sv_ret) {
+				trace_xchk_scrubv_barrier_fail(mp, &head, i, v);
+				break;
+			}
+
+			continue;
+		}
+
+		v->sv_ret = xfs_scrub_metadata(file, &sm);
+		v->sv_flags = sm.sm_flags;
+
+		trace_xchk_scrubv_outcome(mp, &head, i, v);
+
+		if (head.svh_rest_us) {
+			ktime_t		expires;
+
+			expires = ktime_add_ns(ktime_get(),
+					head.svh_rest_us * 1000);
+			set_current_state(TASK_KILLABLE);
+			schedule_hrtimeout(&expires, HRTIMER_MODE_ABS);
+		}
+
+		if (fatal_signal_pending(current)) {
+			error = -EINTR;
+			goto out_free;
+		}
+	}
+
+	if (copy_to_user(uvectors, vectors, vec_bytes) ||
+	    copy_to_user(uhead, &head, sizeof(head))) {
+		error = -EFAULT;
+		goto out_free;
+	}
+
+out_free:
+	kfree(vectors);
+	return error;
+}
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index b3756722bee1d..8ce74bd8530a6 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -69,6 +69,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_QUOTACHECK);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_NLINKS);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_DIRTREE);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BARRIER);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -99,7 +100,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_DIRTREE);
 	{ XFS_SCRUB_TYPE_QUOTACHECK,	"quotacheck" }, \
 	{ XFS_SCRUB_TYPE_NLINKS,	"nlinks" }, \
 	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }, \
-	{ XFS_SCRUB_TYPE_DIRTREE,	"dirtree" }
+	{ XFS_SCRUB_TYPE_DIRTREE,	"dirtree" }, \
+	{ XFS_SCRUB_TYPE_BARRIER,	"barrier" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \
@@ -208,6 +210,81 @@ DEFINE_EVENT(xchk_fsgate_class, name, \
 DEFINE_SCRUB_FSHOOK_EVENT(xchk_fsgates_enable);
 DEFINE_SCRUB_FSHOOK_EVENT(xchk_fsgates_disable);
 
+DECLARE_EVENT_CLASS(xchk_vector_head_class,
+	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_vec_head *vhead),
+	TP_ARGS(ip, vhead),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, inum)
+		__field(unsigned int, gen)
+		__field(unsigned int, flags)
+		__field(unsigned short, rest_us)
+		__field(unsigned short, nr_vecs)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->agno = vhead->svh_agno;
+		__entry->inum = vhead->svh_ino;
+		__entry->gen = vhead->svh_gen;
+		__entry->flags = vhead->svh_flags;
+		__entry->rest_us = vhead->svh_rest_us;
+		__entry->nr_vecs = vhead->svh_nr;
+	),
+	TP_printk("dev %d:%d ino 0x%llx agno 0x%x inum 0x%llx gen 0x%x flags 0x%x rest_us %u nr_vecs %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->agno,
+		  __entry->inum,
+		  __entry->gen,
+		  __entry->flags,
+		  __entry->rest_us,
+		  __entry->nr_vecs)
+)
+#define DEFINE_SCRUBV_HEAD_EVENT(name) \
+DEFINE_EVENT(xchk_vector_head_class, name, \
+	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_vec_head *vhead), \
+	TP_ARGS(ip, vhead))
+
+DEFINE_SCRUBV_HEAD_EVENT(xchk_scrubv_start);
+
+DECLARE_EVENT_CLASS(xchk_vector_class,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_scrub_vec_head *vhead,
+		 unsigned int vec_nr, struct xfs_scrub_vec *v),
+	TP_ARGS(mp, vhead, vec_nr, v),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, vec_nr)
+		__field(unsigned int, vec_type)
+		__field(unsigned int, vec_flags)
+		__field(int, vec_ret)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->vec_nr = vec_nr;
+		__entry->vec_type = v->sv_type;
+		__entry->vec_flags = v->sv_flags;
+		__entry->vec_ret = v->sv_ret;
+	),
+	TP_printk("dev %d:%d vec[%u] type %s flags %s ret %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->vec_nr,
+		  __print_symbolic(__entry->vec_type, XFS_SCRUB_TYPE_STRINGS),
+		  __print_flags(__entry->vec_flags, "|", XFS_SCRUB_FLAG_STRINGS),
+		  __entry->vec_ret)
+)
+#define DEFINE_SCRUBV_EVENT(name) \
+DEFINE_EVENT(xchk_vector_class, name, \
+	TP_PROTO(struct xfs_mount *mp, struct xfs_scrub_vec_head *vhead, \
+		 unsigned int vec_nr, struct xfs_scrub_vec *v), \
+	TP_ARGS(mp, vhead, vec_nr, v))
+
+DEFINE_SCRUBV_EVENT(xchk_scrubv_barrier_fail);
+DEFINE_SCRUBV_EVENT(xchk_scrubv_item);
+DEFINE_SCRUBV_EVENT(xchk_scrubv_outcome);
+
 TRACE_EVENT(xchk_op_error,
 	TP_PROTO(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		 xfs_agblock_t bno, int error, void *ret_ip),
diff --git a/fs/xfs/scrub/xfs_scrub.h b/fs/xfs/scrub/xfs_scrub.h
index 02c930f175d0b..f17173b83e6f3 100644
--- a/fs/xfs/scrub/xfs_scrub.h
+++ b/fs/xfs/scrub/xfs_scrub.h
@@ -8,8 +8,10 @@
 
 #ifndef CONFIG_XFS_ONLINE_SCRUB
 # define xfs_ioc_scrub_metadata(f, a)	(-ENOTTY)
+# define xfs_ioc_scrubv_metadata(f, a)	(-ENOTTY)
 #else
 int xfs_ioc_scrub_metadata(struct file *file, void __user *arg);
+int xfs_ioc_scrubv_metadata(struct file *file, void __user *arg);
 #endif /* CONFIG_XFS_ONLINE_SCRUB */
 
 #endif	/* __XFS_SCRUB_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 87a45d4dbbd7c..6e094208d80e2 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1413,6 +1413,8 @@ xfs_file_ioctl(
 	case FS_IOC_GETFSMAP:
 		return xfs_ioc_getfsmap(ip, arg);
 
+	case XFS_IOC_SCRUBV_METADATA:
+		return xfs_ioc_scrubv_metadata(filp, arg);
 	case XFS_IOC_SCRUB_METADATA:
 		return xfs_ioc_scrub_metadata(filp, arg);
 

