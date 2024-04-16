Return-Path: <linux-xfs+bounces-6723-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 057818A5EBE
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Apr 2024 01:46:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EFA91C20BF6
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Apr 2024 23:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD490158A23;
	Mon, 15 Apr 2024 23:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bA7uDHrF"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D889156F4B
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224808; cv=none; b=eZgJ+Dcr+cbNsSxn2tyKQvwb0WLypIHIxS19iw/U2wKY+2QfNMwMlNF1wKhKCzIDMxmnUbZ2XqudO2KniBy00+kLXZJ8DUMnx7OuziUIY+9VFyjyZDNUYsApPfrj9ho2vC23jCaV59ZVOaFlMeYEOMG5hhpdR0ukTeGTssOSbLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224808; c=relaxed/simple;
	bh=P2UpURWZYFTpnEp3pqP7kLZGOZV5Z0oPWcMNCv1BKmI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JCeMav6G6o5qxbAOvCbnUEHkz+jK22G/D5kirmDXWR7Eg9no0RksnbhzixbLWJa+7G4WLJ2FrPF1x1hLNUuj2WykmQ6jULe6sNoVFE/fE1Fwuj3xxMhVPc0K8zG8hb5+uDv1oEvJZSfLig+8JsZs0jxJJKW9Q90CjL3Wq9+KT2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bA7uDHrF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B3EC113CC;
	Mon, 15 Apr 2024 23:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224808;
	bh=P2UpURWZYFTpnEp3pqP7kLZGOZV5Z0oPWcMNCv1BKmI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bA7uDHrFHU+GjXCO+91vdSLM+Wdmzn2VcTwgoJyhHZP7asJ7l5IvcYrY2Kkd5eqLV
	 cS6NBWDj+LI3Y5CNY9Icu6PgBJa4hTlGnXlXXPrHrYS+SK5OAakkOhDeFD3P261gRK
	 6pXnOVYfNgrHNGV2iwmVJ3jvWE39yMj8jow9HOW8jw9H0QDgqb6PkbgjifV8nn0bO9
	 gEX8xmeThUlqG2Kt5TAFhMalepHBUNuZRb86w4V9my01EWL5eOS/7r6t17Q5INMbhW
	 xzy1Nut/O+W2OuT/66Lvc0R3km073yPBmVlkAoX/L6iM4uahVizn4ALFEAQ82IOCXi
	 U6SfcYom8UFSg==
Date: Mon, 15 Apr 2024 16:46:47 -0700
Subject: [PATCH 01/10] xfs: add an explicit owner field to xfs_da_args
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322382594.88250.13931532339050791869.stgit@frogsfrogsfrogs>
In-Reply-To: <171322382551.88250.5431690184825585631.stgit@frogsfrogsfrogs>
References: <171322382551.88250.5431690184825585631.stgit@frogsfrogsfrogs>
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

Add an explicit owner field to xfs_da_args, which will make it easier
for online fsck to set the owner field of the temporary directory and
xattr structures that it builds to repair damaged metadata.

Note: I hopefully found all the xfs_da_args definitions by looking for
automatic stack variable declarations and xfs_da_args.dp assignments:

git grep -E '(args.*dp =|struct xfs_da_args[[:space:]]*[a-z0-9][a-z0-9]*)'

Note that callers of xfs_attr_{get,set,change} can set the owner to zero
(or leave it unset) to have the default set to args->dp.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c      |    4 ++++
 fs/xfs/libxfs/xfs_attr_leaf.c |    2 ++
 fs/xfs/libxfs/xfs_bmap.c      |    1 +
 fs/xfs/libxfs/xfs_da_btree.h  |    1 +
 fs/xfs/libxfs/xfs_dir2.c      |    5 +++++
 fs/xfs/libxfs/xfs_exchmaps.c  |    2 ++
 fs/xfs/scrub/attr.c           |    1 +
 fs/xfs/scrub/dabtree.c        |    1 +
 fs/xfs/scrub/dir.c            |    3 ++-
 fs/xfs/scrub/readdir.c        |    2 ++
 fs/xfs/xfs_attr_item.c        |    1 +
 fs/xfs/xfs_dir2_readdir.c     |    1 +
 fs/xfs/xfs_trace.h            |    7 +++++--
 13 files changed, 28 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 673a4b6d2e8d..74d769461443 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -264,6 +264,8 @@ xfs_attr_get(
 	if (xfs_is_shutdown(args->dp->i_mount))
 		return -EIO;
 
+	if (!args->owner)
+		args->owner = args->dp->i_ino;
 	args->geo = args->dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
@@ -937,6 +939,8 @@ xfs_attr_set(
 	if (error)
 		return error;
 
+	if (!args->owner)
+		args->owner = args->dp->i_ino;
 	args->geo = mp->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index ac904cc1a97b..e606eae8d377 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -904,6 +904,7 @@ xfs_attr_shortform_to_leaf(
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
 	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.owner = args->owner;
 
 	sfe = xfs_attr_sf_firstentry(sf);
 	for (i = 0; i < sf->count; i++) {
@@ -1106,6 +1107,7 @@ xfs_attr3_leaf_to_shortform(
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
 	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.owner = args->owner;
 
 	for (i = 0; i < ichdr.count; entry++, i++) {
 		if (entry->flags & XFS_ATTR_INCOMPLETE)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 656c95a22f2e..46bbc9f0a117 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -976,6 +976,7 @@ xfs_bmap_add_attrfork_local(
 		dargs.total = dargs.geo->fsbcount;
 		dargs.whichfork = XFS_DATA_FORK;
 		dargs.trans = tp;
+		dargs.owner = ip->i_ino;
 		return xfs_dir2_sf_to_block(&dargs);
 	}
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 706baf36e175..7fb13f26edaa 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -79,6 +79,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_ino_t	owner;		/* inode that owns the dir/attr data */
 } xfs_da_args_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 4821519efad4..9da99fa20c75 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -250,6 +250,7 @@ xfs_dir_init(
 	args->geo = dp->i_mount->m_dir_geo;
 	args->dp = dp;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 	error = xfs_dir2_sf_create(args, pdp->i_ino);
 	kfree(args);
 	return error;
@@ -295,6 +296,7 @@ xfs_dir_createname(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
+	args->owner = dp->i_ino;
 	if (!inum)
 		args->op_flags |= XFS_DA_OP_JUSTCHECK;
 
@@ -383,6 +385,7 @@ xfs_dir_lookup(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_OKNOENT;
+	args->owner = dp->i_ino;
 	if (ci_name)
 		args->op_flags |= XFS_DA_OP_CILOOKUP;
 
@@ -456,6 +459,7 @@ xfs_dir_removename(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_removename(args);
@@ -517,6 +521,7 @@ xfs_dir_replace(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_replace(args);
diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 7fa244228750..8d28e8cce5e9 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -429,6 +429,7 @@ xfs_exchmaps_attr_to_sf(
 		.geo		= tp->t_mountp->m_attr_geo,
 		.whichfork	= XFS_ATTR_FORK,
 		.trans		= tp,
+		.owner		= xmi->xmi_ip2->i_ino,
 	};
 	struct xfs_buf		*bp;
 	int			forkoff;
@@ -459,6 +460,7 @@ xfs_exchmaps_dir_to_sf(
 		.geo		= tp->t_mountp->m_dir_geo,
 		.whichfork	= XFS_DATA_FORK,
 		.trans		= tp,
+		.owner		= xmi->xmi_ip2->i_ino,
 	};
 	struct xfs_dir2_sf_hdr	sfh;
 	struct xfs_buf		*bp;
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 83c7feb38714..0c467f4f8e77 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -169,6 +169,7 @@ xchk_xattr_listent(
 		.hashval		= xfs_da_hashname(name, namelen),
 		.trans			= context->tp,
 		.valuelen		= valuelen,
+		.owner			= context->dp->i_ino,
 	};
 	struct xchk_xattr_buf		*ab;
 	struct xchk_xattr		*sx;
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 82b150d3b8b7..fa6385a99ac4 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -494,6 +494,7 @@ xchk_da_btree(
 	ds->dargs.whichfork = whichfork;
 	ds->dargs.trans = sc->tp;
 	ds->dargs.op_flags = XFS_DA_OP_OKNOENT;
+	ds->dargs.owner = sc->ip->i_ino;
 	ds->state = xfs_da_state_alloc(&ds->dargs);
 	ds->sc = sc;
 	ds->private = private;
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 076a310b8eb0..042e28547e04 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -621,10 +621,11 @@ xchk_directory_blocks(
 {
 	struct xfs_bmbt_irec	got;
 	struct xfs_da_args	args = {
-		.dp		= sc ->ip,
+		.dp		= sc->ip,
 		.whichfork	= XFS_DATA_FORK,
 		.geo		= sc->mp->m_dir_geo,
 		.trans		= sc->tp,
+		.owner		= sc->ip->i_ino,
 	};
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
 	struct xfs_mount	*mp = sc->mp;
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index dfdcb96b6c16..fb98b7624994 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -273,6 +273,7 @@ xchk_dir_walk(
 		.dp		= dp,
 		.geo		= dp->i_mount->m_dir_geo,
 		.trans		= sc->tp,
+		.owner		= dp->i_ino,
 	};
 	bool			isblock;
 	int			error;
@@ -324,6 +325,7 @@ xchk_dir_lookup(
 		.hashval	= xfs_dir2_hashname(dp->i_mount, name),
 		.whichfork	= XFS_DATA_FORK,
 		.op_flags	= XFS_DA_OP_OKNOENT,
+		.owner		= dp->i_ino,
 	};
 	bool			isblock, isleaf;
 	int			error;
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 9b4c61e1c22e..d46034705694 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -540,6 +540,7 @@ xfs_attri_recover_work(
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
+	args->owner = args->dp->i_ino;
 
 	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index cf9296b7e06f..4e811fa393ad 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -532,6 +532,7 @@ xfs_readdir(
 	args.dp = dp;
 	args.geo = dp->i_mount->m_dir_geo;
 	args.trans = tp;
+	args.owner = dp->i_ino;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_dir2_sf_getdents(&args, ctx);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index caef95f2c87c..939baf08331b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1931,6 +1931,7 @@ DECLARE_EVENT_CLASS(xfs_da_class,
 		__field(xfs_dahash_t, hashval)
 		__field(xfs_ino_t, inumber)
 		__field(uint32_t, op_flags)
+		__field(xfs_ino_t, owner)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
@@ -1941,9 +1942,10 @@ DECLARE_EVENT_CLASS(xfs_da_class,
 		__entry->hashval = args->hashval;
 		__entry->inumber = args->inumber;
 		__entry->op_flags = args->op_flags;
+		__entry->owner = args->owner;
 	),
 	TP_printk("dev %d:%d ino 0x%llx name %.*s namelen %d hashval 0x%x "
-		  "inumber 0x%llx op_flags %s",
+		  "inumber 0x%llx op_flags %s owner 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->namelen,
@@ -1951,7 +1953,8 @@ DECLARE_EVENT_CLASS(xfs_da_class,
 		  __entry->namelen,
 		  __entry->hashval,
 		  __entry->inumber,
-		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS))
+		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS),
+		  __entry->owner)
 )
 
 #define DEFINE_DIR2_EVENT(name) \


