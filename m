Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3331519E0B6
	for <lists+linux-xfs@lfdr.de>; Sat,  4 Apr 2020 00:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgDCWKN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 3 Apr 2020 18:10:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45514 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbgDCWKN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:10:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M9jH8082666
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=AN02GFjiPXdLo1xqQ3stGZwA//jaL2jcZE12M4qxzwI=;
 b=0GoeX2Ts0YiDcPwz2IUWZ/PwwAuHkHb0KX3X0MLoNpEeGlC6I3v9mbSP8P3Ks55FJQCV
 iWuZHaYW1hGkd8IEF1ey+BRHAhCyI6D2bKj4TTbF0uY484tN0ViOU1tp3Nkx28T7B4vZ
 cJtSgFB9bdxvJad8ntRT+3jwNl0Hs22bNHsHb3cyuJ7C7Haqk69vYxhgsjgaMEB6qfGn
 2+RacUfixNNLJuKB4LtuT33JougTR4ltoSryJ243R4Vi9S7jdAK/mfVwaxCksKttFFgD
 OglYs5ffUyqvkwwPpYXOmncTBVZ+uO09HYezZ0HfJ9hCj7WNGWubnYN4D6XejV2586El dA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 303cevkdhk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M8NFM062307
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 302ga6120d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:11 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 033MABg0028177
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:11 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:10:10 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 20/39] xfsprogs: Add xfs_has_attr and subroutines
Date:   Fri,  3 Apr 2020 15:09:39 -0700
Message-Id: <20200403220958.4944-21-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403220958.4944-1-allison.henderson@oracle.com>
References: <20200403220958.4944-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=4 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a new functions to check for the existence of an
attribute. Subroutines are also added to handle the cases of leaf
blocks, nodes or shortform. Common code that appears in existing attr
add and remove functions have been factored out to help reduce the
appearance of duplicated code.  We will need these routines later for
delayed attributes since delayed operations cannot return error codes.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c      | 181 ++++++++++++++++++++++++++++++++-----------------
 libxfs/xfs_attr.h      |   1 +
 libxfs/xfs_attr_leaf.c |  97 ++++++++++++++++++--------
 libxfs/xfs_attr_leaf.h |   3 +
 4 files changed, 191 insertions(+), 91 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 810caff..728e7e8 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -47,6 +47,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -54,6 +55,8 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
+				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 
@@ -262,6 +265,37 @@ xfs_attr_set_args(
 }
 
 /*
+ * Return EEXIST if attr is found, or ENOATTR if not
+ */
+int
+xfs_has_attr(
+	struct xfs_da_args      *args)
+{
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_buf		*bp = NULL;
+	int			error;
+
+	if (!xfs_inode_hasattr(dp))
+		return -ENOATTR;
+
+	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
+		return xfs_attr_sf_findname(args, NULL, NULL);
+	}
+
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+		error = xfs_attr_leaf_hasname(args, &bp);
+
+		if (bp)
+			xfs_trans_brelse(args->trans, bp);
+
+		return error;
+	}
+
+	return xfs_attr_node_hasname(args, NULL);
+}
+
+/*
  * Remove the attribute specified in @args.
  */
 int
@@ -470,26 +504,19 @@ STATIC int
 xfs_attr_leaf_addname(
 	struct xfs_da_args	*args)
 {
-	struct xfs_inode	*dp;
 	struct xfs_buf		*bp;
 	int			retval, error, forkoff;
+	struct xfs_inode	*dp = args->dp;
 
 	trace_xfs_attr_leaf_addname(args);
 
 	/*
-	 * Read the (only) block in the attribute list in.
-	 */
-	dp = args->dp;
-	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
-	if (error)
-		return error;
-
-	/*
 	 * Look up the given attribute in the leaf block.  Figure out if
 	 * the given flags produce an error or call for an atomic rename.
 	 */
-	retval = xfs_attr3_leaf_lookup_int(bp, args);
+	retval = xfs_attr_leaf_hasname(args, &bp);
+	if (retval != -ENOATTR && retval != -EEXIST)
+		return retval;
 	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
 		goto out_brelse;
 	if (retval == -EEXIST) {
@@ -641,6 +668,27 @@ out_brelse:
 }
 
 /*
+ * Return EEXIST if attr is found, or ENOATTR if not
+ */
+STATIC int
+xfs_attr_leaf_hasname(
+	struct xfs_da_args      *args,
+	struct xfs_buf		**bp)
+{
+	int                     error = 0;
+
+	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, bp);
+	if (error)
+		return error;
+
+	error = xfs_attr3_leaf_lookup_int(*bp, args);
+	if (error != -ENOATTR && error != -EEXIST)
+		xfs_trans_brelse(args->trans, *bp);
+
+	return error;
+}
+
+/*
  * Remove a name from the leaf attribute list structure
  *
  * This leaf block cannot have a "remote" value, we only call this routine
@@ -660,16 +708,14 @@ xfs_attr_leaf_removename(
 	 * Remove the attribute.
 	 */
 	dp = args->dp;
-	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
-	if (error)
-		return error;
 
-	error = xfs_attr3_leaf_lookup_int(bp, args);
+	error = xfs_attr_leaf_hasname(args, &bp);
+
 	if (error == -ENOATTR) {
 		xfs_trans_brelse(args->trans, bp);
 		return error;
-	}
+	} else if (error != -EEXIST)
+		return error;
 
 	xfs_attr3_leaf_remove(bp, args);
 
@@ -704,21 +750,57 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 
 	trace_xfs_attr_leaf_get(args);
 
-	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
-	if (error)
-		return error;
+	error = xfs_attr_leaf_hasname(args, &bp);
 
-	error = xfs_attr3_leaf_lookup_int(bp, args);
 	if (error != -EEXIST)  {
 		xfs_trans_brelse(args->trans, bp);
 		return error;
-	}
+	} else if (error != -EEXIST)
+		return error;
+
+
 	error = xfs_attr3_leaf_getvalue(bp, args);
 	xfs_trans_brelse(args->trans, bp);
 	return error;
 }
 
+/*
+ * Return EEXIST if attr is found, or ENOATTR if not
+ * statep: If not null is set to point at the found state.  Caller will
+ *         be responsible for freeing the state in this case.
+ */
+STATIC int
+xfs_attr_node_hasname(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	**statep)
+{
+	struct xfs_da_state	*state;
+	int			retval, error;
+
+	state = xfs_da_state_alloc();
+	state->args = args;
+	state->mp = args->dp->i_mount;
+
+	if (statep != NULL)
+		*statep = NULL;
+
+	/*
+	 * Search to see if name exists, and get back a pointer to it.
+	 */
+	error = xfs_da3_node_lookup_int(state, &retval);
+	if (error == 0) {
+		if (statep != NULL)
+			*statep = state;
+		else
+			xfs_da_state_free(state);
+		return retval;
+	}
+
+	xfs_da_state_free(state);
+
+	return error;
+}
+
 /*========================================================================
  * External routines when attribute list size > geo->blksize
  *========================================================================*/
@@ -751,17 +833,14 @@ xfs_attr_node_addname(
 	dp = args->dp;
 	mp = dp->i_mount;
 restart:
-	state = xfs_da_state_alloc();
-	state->args = args;
-	state->mp = mp;
-
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	error = xfs_da3_node_lookup_int(state, &retval);
-	if (error)
+	retval = xfs_attr_node_hasname(args, &state);
+	if (retval != -ENOATTR && retval != -EEXIST)
 		goto out;
+
 	blk = &state->path.blk[ state->path.active-1 ];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
@@ -966,29 +1045,15 @@ xfs_attr_node_removename(
 {
 	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
-	struct xfs_inode	*dp;
 	struct xfs_buf		*bp;
 	int			retval, error, forkoff;
+	struct xfs_inode	*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);
 
-	/*
-	 * Tie a string around our finger to remind us where we are.
-	 */
-	dp = args->dp;
-	state = xfs_da_state_alloc();
-	state->args = args;
-	state->mp = dp->i_mount;
-
-	/*
-	 * Search to see if name exists, and get back a pointer to it.
-	 */
-	error = xfs_da3_node_lookup_int(state, &retval);
-	if (error || (retval != -EEXIST)) {
-		if (error == 0)
-			error = retval;
+	error = xfs_attr_node_hasname(args, &state);
+	if (error != -EEXIST)
 		goto out;
-	}
 
 	/*
 	 * If there is an out-of-line value, de-allocate the blocks.
@@ -1083,7 +1148,8 @@ xfs_attr_node_removename(
 	error = 0;
 
 out:
-	xfs_da_state_free(state);
+	if (state)
+		xfs_da_state_free(state);
 	return error;
 }
 
@@ -1203,31 +1269,23 @@ xfs_attr_node_get(xfs_da_args_t *args)
 {
 	xfs_da_state_t *state;
 	xfs_da_state_blk_t *blk;
-	int error, retval;
+	int error;
 	int i;
 
 	trace_xfs_attr_node_get(args);
 
-	state = xfs_da_state_alloc();
-	state->args = args;
-	state->mp = args->dp->i_mount;
-
 	/*
 	 * Search to see if name exists, and get back a pointer to it.
 	 */
-	error = xfs_da3_node_lookup_int(state, &retval);
-	if (error) {
-		retval = error;
-		goto out_release;
-	}
-	if (retval != -EEXIST)
+	error = xfs_attr_node_hasname(args, &state);
+	if (error != -EEXIST)
 		goto out_release;
 
 	/*
 	 * Get the value, local or "remote"
 	 */
 	blk = &state->path.blk[state->path.active - 1];
-	retval = xfs_attr3_leaf_getvalue(blk->bp, args);
+	error = xfs_attr3_leaf_getvalue(blk->bp, args);
 
 	/*
 	 * If not in a transaction, we have to release all the buffers.
@@ -1238,8 +1296,9 @@ out_release:
 		state->path.blk[i].bp = NULL;
 	}
 
-	xfs_da_state_free(state);
-	return retval;
+	if (state)
+		xfs_da_state_free(state);
+	return error;
 }
 
 /* Returns true if the attribute entry name is valid. */
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 0d2d059..66575b8 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -89,6 +89,7 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
+int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 bool xfs_attr_namecheck(const void *name, size_t length);
 
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index d560f94..7fa0e3a 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -657,18 +657,63 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
 }
 
 /*
+ * Return -EEXIST if attr is found, or -ENOATTR if not
+ * args:  args containing attribute name and namelen
+ * sfep:  If not null, pointer will be set to the last attr entry found on
+	  -EEXIST.  On -ENOATTR pointer is left at the last entry in the list
+ * basep: If not null, pointer is set to the byte offset of the entry in the
+ *	  list on -EEXIST.  On -ENOATTR, pointer is left at the byte offset of
+ *	  the last entry in the list
+ */
+int
+xfs_attr_sf_findname(
+	struct xfs_da_args	 *args,
+	struct xfs_attr_sf_entry **sfep,
+	unsigned int		 *basep)
+{
+	struct xfs_attr_shortform *sf;
+	struct xfs_attr_sf_entry *sfe;
+	unsigned int		base = sizeof(struct xfs_attr_sf_hdr);
+	int			size = 0;
+	int			end;
+	int			i;
+
+	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
+	sfe = &sf->list[0];
+	end = sf->hdr.count;
+	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
+			     base += size, i++) {
+		size = XFS_ATTR_SF_ENTSIZE(sfe);
+		if (!xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				    sfe->flags))
+			continue;
+		break;
+	}
+
+	if (sfep != NULL)
+		*sfep = sfe;
+
+	if (basep != NULL)
+		*basep = base;
+
+	if (i == end)
+		return -ENOATTR;
+	return -EEXIST;
+}
+
+/*
  * Add a name/value pair to the shortform attribute list.
  * Overflow from the inode has already been checked for.
  */
 void
-xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
+xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff)
 {
-	xfs_attr_shortform_t *sf;
-	xfs_attr_sf_entry_t *sfe;
-	int i, offset, size;
-	xfs_mount_t *mp;
-	xfs_inode_t *dp;
-	struct xfs_ifork *ifp;
+	struct xfs_attr_shortform	*sf;
+	struct xfs_attr_sf_entry	*sfe;
+	int				offset, size, error;
+	struct xfs_mount		*mp;
+	struct xfs_inode		*dp;
+	struct xfs_ifork		*ifp;
 
 	trace_xfs_attr_sf_add(args);
 
@@ -679,11 +724,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
 	ifp = dp->i_afp;
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
-	sfe = &sf->list[0];
-	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
-		ASSERT(!xfs_attr_match(args, sfe->namelen, sfe->nameval,
-			sfe->flags));
-	}
+	error = xfs_attr_sf_findname(args, &sfe, NULL);
+	ASSERT(error != -EEXIST);
 
 	offset = (char *)sfe - (char *)sf;
 	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
@@ -726,31 +768,26 @@ xfs_attr_fork_remove(
  * Remove an attribute from the shortform attribute list structure.
  */
 int
-xfs_attr_shortform_remove(xfs_da_args_t *args)
+xfs_attr_shortform_remove(struct xfs_da_args *args)
 {
-	xfs_attr_shortform_t *sf;
-	xfs_attr_sf_entry_t *sfe;
-	int base, size=0, end, totsize, i;
-	xfs_mount_t *mp;
-	xfs_inode_t *dp;
+	struct xfs_attr_shortform	*sf;
+	struct xfs_attr_sf_entry	*sfe;
+	int				size = 0, end, totsize;
+	unsigned int			base;
+	struct xfs_mount		*mp;
+	struct xfs_inode		*dp;
+	int				error;
 
 	trace_xfs_attr_sf_remove(args);
 
 	dp = args->dp;
 	mp = dp->i_mount;
-	base = sizeof(xfs_attr_sf_hdr_t);
 	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
-	sfe = &sf->list[0];
-	end = sf->hdr.count;
-	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
-					base += size, i++) {
-		size = XFS_ATTR_SF_ENTSIZE(sfe);
-		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
-				sfe->flags))
-			break;
-	}
-	if (i == end)
-		return -ENOATTR;
+
+	error = xfs_attr_sf_findname(args, &sfe, &base);
+	if (error != -EEXIST)
+		return error;
+	size = XFS_ATTR_SF_ENTSIZE(sfe);
 
 	/*
 	 * Fix up the attribute fork data, covering the hole
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index 6dd2d93..88ec042 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -52,6 +52,9 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
 			struct xfs_buf **leaf_bp);
 int	xfs_attr_shortform_remove(struct xfs_da_args *args);
+int	xfs_attr_sf_findname(struct xfs_da_args *args,
+			     struct xfs_attr_sf_entry **sfep,
+			     unsigned int *basep);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
 xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
-- 
2.7.4

