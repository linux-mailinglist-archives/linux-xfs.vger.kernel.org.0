Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02FDD70CED
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Jul 2019 01:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbfGVXFZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Jul 2019 19:05:25 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:47964 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728191AbfGVXFZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jul 2019 19:05:25 -0400
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 70FB843C16D
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2019 09:05:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hphLo-0001Ga-VK
        for linux-xfs@vger.kernel.org; Tue, 23 Jul 2019 09:04:12 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hphMt-0004yQ-05
        for linux-xfs@vger.kernel.org; Tue, 23 Jul 2019 09:05:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: allocate xattr buffer on demand
Date:   Tue, 23 Jul 2019 09:05:18 +1000
Message-Id: <20190722230518.19078-1-david@fromorbit.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=0o9FgrsRnhwA:10 a=20KFwNOVAAAA:8 a=w1OQ7Biraai5yjU_evgA:9
        a=M6Wf_L-asH7SKQtg:21 a=wobGFT1rs042Mm-z:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When doing file lookups and checking for permissions, we end up in
xfs_get_acl() to see if there are any ACLs on the inode. This
requires and xattr lookup, and to do that we have to supply a buffer
large enough to hold an maximum sized xattr.

On workloads were we are accessing a wide range of cache cold files
under memory pressure (e.g. NFS fileservers) we end up spending a
lot of time allocating the buffer. The buffer is 64k in length, so
is a contiguous multi-page allocation, and if that then fails we
fall back to vmalloc(). Hence the allocation here is /expensive/
when we are looking up hundreds of thousands of files a second.

Initial numbers from a bpf trace show average time in xfs_get_acl()
is ~32us, with ~19us of that in the memory allocation. Note these
are average times, so there are going to be affected by the worst
case allocations more than the common fast case...

To avoid this, we could just do a "null"  lookup to see if the ACL
xattr exists and then only do the allocation if it exists. This,
however, optimises the path for the "no ACL present" case at the
expense of the "acl present" case. i.e. we can halve the time in
xfs_get_acl() for the no acl case (i.e down to ~10-15us), but that
then increases the ACL case by 30% (i.e. up to 40-45us).

To solve this and speed up both cases, drive the xattr buffer
allocation into the attribute code once we know what the actual
xattr length is. For the no-xattr case, we avoid the allocation
completely, speeding up that case. For the common ACL case, we'll
end up with a fast heap allocation (because it'll be smaller than a
page), and only for the rarer "we have a remote xattr" will we have
a multi-page allocation occur. Hence the common ACL case will be
much faster, too.

The down side of this is the buffer allocation is now a GFP_NOFS
allocation. This isn't a big deal for small allocations, though it
might cause large xattrs (which are out of line and doing
substantial GFP_NOFS allocations already) to have to do another
large allocation in this context. I think, however, this is rare
enough that it won't matter for the ACL path, and the common xattr
paths can still provide and external buffer...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 23 ++++------
 fs/xfs/libxfs/xfs_attr.h      |  6 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c | 85 +++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_da_btree.h  |  4 +-
 fs/xfs/xfs_acl.c              | 14 ++----
 fs/xfs/xfs_ioctl.c            |  2 +-
 fs/xfs/xfs_xattr.c            |  2 +-
 7 files changed, 72 insertions(+), 64 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d48fcf11cc35..cc520a11ca4e 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -120,7 +120,7 @@ int
 xfs_attr_get(
 	struct xfs_inode	*ip,
 	const unsigned char	*name,
-	unsigned char		*value,
+	unsigned char		**value,
 	int			*valuelenp,
 	int			flags)
 {
@@ -128,6 +128,8 @@ xfs_attr_get(
 	uint			lock_mode;
 	int			error;
 
+	ASSERT((flags & (ATTR_ALLOC | ATTR_KERNOVAL)) || *value);
+
 	XFS_STATS_INC(ip->i_mount, xs_attr_get);
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
@@ -137,16 +139,20 @@ xfs_attr_get(
 	if (error)
 		return error;
 
-	args.value = value;
-	args.valuelen = *valuelenp;
 	/* Entirely possible to look up a name which doesn't exist */
 	args.op_flags = XFS_DA_OP_OKNOENT;
+	if (flags & ATTR_ALLOC)
+		args.op_flags |= XFS_DA_OP_ALLOCVAL;
+	else
+		args.value = *value;
+	args.valuelen = *valuelenp;
 
 	lock_mode = xfs_ilock_attr_map_shared(ip);
 	error = xfs_attr_get_ilocked(ip, &args);
 	xfs_iunlock(ip, lock_mode);
 
 	*valuelenp = args.valuelen;
+	*value = args.value;
 	return error == -EEXIST ? 0 : error;
 }
 
@@ -789,9 +795,6 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 	}
 	error = xfs_attr3_leaf_getvalue(bp, args);
 	xfs_trans_brelse(args->trans, bp);
-	if (!error && (args->rmtblkno > 0) && !(args->flags & ATTR_KERNOVAL)) {
-		error = xfs_attr_rmtval_get(args);
-	}
 	return error;
 }
 
@@ -1298,15 +1301,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
 		blk = &state->path.blk[ state->path.active-1 ];
 		ASSERT(blk->bp != NULL);
 		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-
-		/*
-		 * Get the value, local or "remote"
-		 */
 		retval = xfs_attr3_leaf_getvalue(blk->bp, args);
-		if (!retval && (args->rmtblkno > 0)
-		    && !(args->flags & ATTR_KERNOVAL)) {
-			retval = xfs_attr_rmtval_get(args);
-		}
 	}
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index ff28ebf3b635..94badfa1743e 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -37,6 +37,7 @@ struct xfs_attr_list_context;
 #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
 
 #define ATTR_INCOMPLETE	0x4000	/* [kernel] return INCOMPLETE attr keys */
+#define ATTR_ALLOC	0x8000	/* allocate xattr buffer on demand */
 
 #define XFS_ATTR_FLAGS \
 	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
@@ -47,7 +48,8 @@ struct xfs_attr_list_context;
 	{ ATTR_REPLACE,		"REPLACE" }, \
 	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
 	{ ATTR_KERNOVAL,	"KERNOVAL" }, \
-	{ ATTR_INCOMPLETE,	"INCOMPLETE" }
+	{ ATTR_INCOMPLETE,	"INCOMPLETE" }, \
+	{ ATTR_ALLOC,		"ALLOC" }
 
 /*
  * The maximum size (into the kernel or returned from the kernel) of an
@@ -143,7 +145,7 @@ int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 unsigned char *value, int *valuelenp, int flags);
+		 unsigned char **value, int *valuelenp, int flags);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 70eb941d02e4..61717caf22db 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -393,6 +393,32 @@ xfs_attr_namesp_match(int arg_flags, int ondisk_flags)
 	return XFS_ATTR_NSP_ONDISK(ondisk_flags) == XFS_ATTR_NSP_ARGS_TO_ONDISK(arg_flags);
 }
 
+static int
+xfs_attr_copy_value(
+	struct xfs_da_args	*args,
+	unsigned char		*value,
+	int			valuelen)
+{
+	if (args->valuelen < valuelen) {
+		args->valuelen = valuelen;
+		return -ERANGE;
+	}
+
+	if (args->op_flags & XFS_DA_OP_ALLOCVAL) {
+		args->value = kmem_alloc_large(valuelen, KM_SLEEP);
+		if (!args->value)
+			return -ENOMEM;
+	}
+	args->valuelen = valuelen;
+
+	/* remote block xattr requires IO for copy-in */
+	if (args->rmtblkno)
+		return xfs_attr_rmtval_get(args);
+
+	memcpy(args->value, value, valuelen);
+	return 0;
+}
+
 
 /*========================================================================
  * External routines when attribute fork size < XFS_LITINO(mp).
@@ -724,11 +750,13 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
  */
 /*ARGSUSED*/
 int
-xfs_attr_shortform_getvalue(xfs_da_args_t *args)
+xfs_attr_shortform_getvalue(
+	struct xfs_da_args	*args)
 {
-	xfs_attr_shortform_t *sf;
-	xfs_attr_sf_entry_t *sfe;
-	int i;
+	struct xfs_attr_shortform *sf;
+	struct xfs_attr_sf_entry *sfe;
+	int			error;
+	int			i;
 
 	ASSERT(args->dp->i_afp->if_flags == XFS_IFINLINE);
 	sf = (xfs_attr_shortform_t *)args->dp->i_afp->if_u1.if_data;
@@ -745,13 +773,10 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
 			args->valuelen = sfe->valuelen;
 			return -EEXIST;
 		}
-		if (args->valuelen < sfe->valuelen) {
-			args->valuelen = sfe->valuelen;
-			return -ERANGE;
-		}
-		args->valuelen = sfe->valuelen;
-		memcpy(args->value, &sfe->nameval[args->namelen],
-						    args->valuelen);
+		error = xfs_attr_copy_value(args, &sfe->nameval[args->namelen],
+						sfe->valuelen);
+		if (error)
+			return error;
 		return -EEXIST;
 	}
 	return -ENOATTR;
@@ -2378,31 +2403,23 @@ xfs_attr3_leaf_getvalue(
 			args->valuelen = valuelen;
 			return 0;
 		}
-		if (args->valuelen < valuelen) {
-			args->valuelen = valuelen;
-			return -ERANGE;
-		}
-		args->valuelen = valuelen;
-		memcpy(args->value, &name_loc->nameval[args->namelen], valuelen);
-	} else {
-		name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
-		ASSERT(name_rmt->namelen == args->namelen);
-		ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
-		args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
-		args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
-		args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
-						       args->rmtvaluelen);
-		if (args->flags & ATTR_KERNOVAL) {
-			args->valuelen = args->rmtvaluelen;
-			return 0;
-		}
-		if (args->valuelen < args->rmtvaluelen) {
-			args->valuelen = args->rmtvaluelen;
-			return -ERANGE;
-		}
+		return xfs_attr_copy_value(args,
+					&name_loc->nameval[args->namelen],
+					valuelen);
+	}
+
+	name_rmt = xfs_attr3_leaf_name_remote(leaf, args->index);
+	ASSERT(name_rmt->namelen == args->namelen);
+	ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
+	args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
+	args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
+	args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
+					       args->rmtvaluelen);
+	if (args->flags & ATTR_KERNOVAL) {
 		args->valuelen = args->rmtvaluelen;
+		return 0;
 	}
-	return 0;
+	return xfs_attr_copy_value(args, NULL, args->rmtvaluelen);
 }
 
 /*========================================================================
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 84dd865b6c3d..ae0bbd20d9ca 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -81,13 +81,15 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
 #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
+#define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
 	{ XFS_DA_OP_RENAME,	"RENAME" }, \
 	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
-	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }
+	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
+	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }
 
 /*
  * Storage for holding state during Btree searches and split/join ops.
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index cbda40d40326..cba1ea9d6d0a 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -112,7 +112,7 @@ xfs_get_acl(struct inode *inode, int type)
 {
 	struct xfs_inode *ip = XFS_I(inode);
 	struct posix_acl *acl = NULL;
-	struct xfs_acl *xfs_acl;
+	struct xfs_acl *xfs_acl = NULL;
 	unsigned char *ea_name;
 	int error;
 	int len;
@@ -130,17 +130,9 @@ xfs_get_acl(struct inode *inode, int type)
 		BUG();
 	}
 
-	/*
-	 * If we have a cached ACLs value just return it, not need to
-	 * go out to the disk.
-	 */
 	len = XFS_ACL_MAX_SIZE(ip->i_mount);
-	xfs_acl = kmem_zalloc_large(len, KM_SLEEP);
-	if (!xfs_acl)
-		return ERR_PTR(-ENOMEM);
-
-	error = xfs_attr_get(ip, ea_name, (unsigned char *)xfs_acl,
-							&len, ATTR_ROOT);
+	error = xfs_attr_get(ip, ea_name, (unsigned char **)&xfs_acl, &len,
+				ATTR_ALLOC|ATTR_ROOT);
 	if (error) {
 		/*
 		 * If the attribute doesn't exist make sure we have a negative
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6f7848cd5527..5f73feb40384 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -438,7 +438,7 @@ xfs_attrmulti_attr_get(
 	if (!kbuf)
 		return -ENOMEM;
 
-	error = xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags);
+	error = xfs_attr_get(XFS_I(inode), name, &kbuf, (int *)len, flags);
 	if (error)
 		goto out_kfree;
 
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 3123b5aaad2a..cb895b1df5e4 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -30,7 +30,7 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 		value = NULL;
 	}
 
-	error = xfs_attr_get(ip, (unsigned char *)name, value, &asize, xflags);
+	error = xfs_attr_get(ip, name, (unsigned char **)&value, &asize, xflags);
 	if (error)
 		return error;
 	return asize;
-- 
2.22.0

