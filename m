Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3E971692EC
	for <lists+linux-xfs@lfdr.de>; Sun, 23 Feb 2020 03:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgBWCGF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 22 Feb 2020 21:06:05 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45606 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbgBWCGE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 21:06:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N21BWa188983
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=TWyfhHLgDFuCeIPb9IzkuLzRLs3o0Ydy+jTeH3Qka0I=;
 b=YX9tmH1NHU0h1d5jJ8tiWJK6rDH1C9K9LLUJCEGQr9OQVhXejfEmTHEbUrjwRlJ+K4Fi
 lrNvj03bZc3FXxsxEdLNgPf/9UStZxQcg97zyelKzT4oxHlhQPKWfMr/EYU1mQMwK3ev
 /pUoKPtImZwzfFECJbnla8SiE8fUal1bDDie/h81WJplVu1iuwaHq+9t4x25bpPN935m
 83QLtngbhDMXdZka92x1N5M6lQlGGIIOJ1xCeZNGZ0qgH3JWlwVkAn5uXOl3wvaPZueO
 QsHnU5xWXa06RdkDXeSY3wPzdYm/Unj1Aryhl2TkqRyy4pFvD2gCCVZjfSIqpz+f5Kb/ gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2yauqu21x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N1wG48054340
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ybe38mctq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:02 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01N261fD028804
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:01 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 02:06:00 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 04/20] xfsprogs: Add xfs_has_attr and subroutines
Date:   Sat, 22 Feb 2020 19:05:38 -0700
Message-Id: <20200223020554.1731-5-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223020554.1731-1-allison.henderson@oracle.com>
References: <20200223020554.1731-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=4 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 bulkscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a new functions to check for the existence of an attribute.
Subroutines are also added to handle the cases of leaf blocks, nodes or shortform.
Common code that appears in existing attr add and remove functions have been
factored out to help reduce the appearance of duplicated code.  We will need these
routines later for delayed attributes since delayed operations cannot return error
codes.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c      | 170 ++++++++++++++++++++++++++++++++-----------------
 libxfs/xfs_attr.h      |   1 +
 libxfs/xfs_attr_leaf.c | 111 ++++++++++++++++++++------------
 libxfs/xfs_attr_leaf.h |   3 +
 4 files changed, 187 insertions(+), 98 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 4fe27f1..9d4c79a 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -45,6 +45,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -52,6 +53,8 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
+				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 
@@ -309,6 +312,37 @@ xfs_attr_set_args(
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
@@ -582,26 +616,20 @@ STATIC int
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
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
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
+
 	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
 		xfs_trans_brelse(args->trans, bp);
 		return retval;
@@ -753,6 +781,27 @@ xfs_attr_leaf_addname(
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
+	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, -1, bp);
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
@@ -772,12 +821,10 @@ xfs_attr_leaf_removename(
 	 * Remove the attribute.
 	 */
 	dp = args->dp;
-	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
-	if (error)
+	error = xfs_attr_leaf_hasname(args, &bp);
+	if (error != -ENOATTR && error != -EEXIST)
 		return error;
 
-	error = xfs_attr3_leaf_lookup_int(bp, args);
 	if (error == -ENOATTR) {
 		xfs_trans_brelse(args->trans, bp);
 		return error;
@@ -816,12 +863,10 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 
 	trace_xfs_attr_leaf_get(args);
 
-	args->blkno = 0;
-	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, -1, &bp);
-	if (error)
+	error = xfs_attr_leaf_hasname(args, &bp);
+	if (error != -ENOATTR && error != -EEXIST)
 		return error;
 
-	error = xfs_attr3_leaf_lookup_int(bp, args);
 	if (error != -EEXIST)  {
 		xfs_trans_brelse(args->trans, bp);
 		return error;
@@ -831,6 +876,41 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
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
@@ -863,20 +943,17 @@ xfs_attr_node_addname(
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
-	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
+	if (retval == -ENOATTR && args->name.type & ATTR_REPLACE) {
 		goto out;
 	} else if (retval == -EEXIST) {
 		if (args->name.type & ATTR_CREATE)
@@ -1078,29 +1155,15 @@ xfs_attr_node_removename(
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
@@ -1195,7 +1258,8 @@ xfs_attr_node_removename(
 	error = 0;
 
 out:
-	xfs_da_state_free(state);
+	if (state)
+		xfs_da_state_free(state);
 	return error;
 }
 
@@ -1317,31 +1381,23 @@ xfs_attr_node_get(xfs_da_args_t *args)
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
@@ -1353,7 +1409,7 @@ out_release:
 	}
 
 	xfs_da_state_free(state);
-	return retval;
+	return error;
 }
 
 /* Returns true if the attribute entry name is valid. */
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 44dd07a..3b5dad4 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -150,6 +150,7 @@ int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
 		 unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
+int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 1389970..542315e 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -586,18 +586,66 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
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
+			base += size, i++) {
+		size = XFS_ATTR_SF_ENTSIZE(sfe);
+		if (sfe->namelen != args->name.len)
+			continue;
+		if (memcmp(sfe->nameval, args->name.name, args->name.len) != 0)
+			continue;
+		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
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
 
@@ -608,18 +656,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
 	ifp = dp->i_afp;
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
-	sfe = &sf->list[0];
-	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
-#ifdef DEBUG
-		if (sfe->namelen != args->name.len)
-			continue;
-		if (memcmp(args->name.name, sfe->nameval, args->name.len) != 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
-			continue;
-		ASSERT(0);
-#endif
-	}
+	error = xfs_attr_sf_findname(args, &sfe, NULL);
+	ASSERT(error != -EEXIST);
 
 	offset = (char *)sfe - (char *)sf;
 	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
@@ -662,35 +700,26 @@ xfs_attr_fork_remove(
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
-		if (sfe->namelen != args->name.len)
-			continue;
-		if (memcmp(sfe->nameval, args->name.name, args->name.len) != 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
-			continue;
-		break;
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
index 7b74e18..736a9ba 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -39,6 +39,9 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
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

