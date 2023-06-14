Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0789711CA0
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 03:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbjEZBak (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 21:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjEZBaj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:30:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779CC189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:30:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1446660C2B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CE3C433D2;
        Fri, 26 May 2023 01:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064637;
        bh=W7FgAIBXRBdh6PZFQzW7D2EM5iWvhLiTj/S03goQOZU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=FPUhAIvNDhZps33OiFyXPzelRglQljPQsEL6P4XOj9Bd63lEM6RDdHwVdnkxJ0fKR
         5FAIBBWNLmOvDS0gczK4cn9a2hU0T/i5YoZl6wkGxn5Zas3oguKAb2WUe6lyuGG6+F
         gmHFw9453m1w98c61GyCK7YtkNrk1tTSlkrWPMZC4ID5nzooLn5Vo3CV+9KuRaoINU
         QGlgbAEiJR+WyLBbwm5pCHfceJDEtYN7bIAwsLprTO7rIiVu4M9M7pLqj8QxoB7gYE
         L3OZz/mH89R2dRSzPnd3bX7WZAcCoC2BOzLlPyOURmyGlWuoK/E+KwYilOVGg9xdnz
         5S093yrG/O7fQ==
Date:   Thu, 25 May 2023 18:30:37 -0700
Subject: [PATCH 1/9] xfs: add an explicit owner field to xfs_da_args
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506066388.3735378.6273276793743249790.stgit@frogsfrogsfrogs>
In-Reply-To: <168506066363.3735378.3534676169269107254.stgit@frogsfrogsfrogs>
References: <168506066363.3735378.3534676169269107254.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add an explicit owner field to xfs_da_args, which will make it easier
for online fsck to set the owner field of the temporary directory and
xattr structures that it builds to repair damaged metadata.

Note: I hopefully found all the xfs_da_args definitions by looking for
automatic stack variable declarations and xfs_da_args.dp assignments:

git grep -E '(args.*dp =|struct xfs_da_args[[:space:]]*[a-z0-9][a-z0-9]*)'

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |    2 ++
 fs/xfs/libxfs/xfs_bmap.c      |    1 +
 fs/xfs/libxfs/xfs_da_btree.h  |    1 +
 fs/xfs/libxfs/xfs_dir2.c      |    5 +++++
 fs/xfs/libxfs/xfs_swapext.c   |    2 ++
 fs/xfs/scrub/attr.c           |    1 +
 fs/xfs/scrub/dabtree.c        |    1 +
 fs/xfs/scrub/dir.c            |    3 ++-
 fs/xfs/scrub/readdir.c        |    2 ++
 fs/xfs/xfs_acl.c              |    2 ++
 fs/xfs/xfs_attr_item.c        |    1 +
 fs/xfs/xfs_dir2_readdir.c     |    1 +
 fs/xfs/xfs_ioctl.c            |    2 ++
 fs/xfs/xfs_iops.c             |    1 +
 fs/xfs/xfs_trace.h            |    7 +++++--
 fs/xfs/xfs_xattr.c            |    2 ++
 16 files changed, 31 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 1ba16c369f26..e771167c8766 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -975,6 +975,7 @@ xfs_attr_shortform_to_leaf(
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
 	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.owner = args->owner;
 
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count; i++) {
@@ -1195,6 +1196,7 @@ xfs_attr3_leaf_to_shortform(
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
 	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.owner = args->owner;
 
 	for (i = 0; i < ichdr.count; entry++, i++) {
 		if (entry->flags & XFS_ATTR_INCOMPLETE)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 52861349632e..687ff18e52c1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -952,6 +952,7 @@ xfs_bmap_add_attrfork_local(
 		dargs.total = dargs.geo->fsbcount;
 		dargs.whichfork = XFS_DATA_FORK;
 		dargs.trans = tp;
+		dargs.owner = ip->i_ino;
 		return xfs_dir2_sf_to_block(&dargs);
 	}
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ffa3df5b2893..52694dc0cd3c 100644
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
index 748fe2c51492..51eed639f2df 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -250,6 +250,7 @@ xfs_dir_init(
 	args->geo = dp->i_mount->m_dir_geo;
 	args->dp = dp;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 	error = xfs_dir2_sf_create(args, pdp->i_ino);
 	kmem_free(args);
 	return error;
@@ -295,6 +296,7 @@ xfs_dir_createname(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
+	args->owner = dp->i_ino;
 	if (!inum)
 		args->op_flags |= XFS_DA_OP_JUSTCHECK;
 
@@ -389,6 +391,7 @@ xfs_dir_lookup(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_OKNOENT;
+	args->owner = dp->i_ino;
 	if (ci_name)
 		args->op_flags |= XFS_DA_OP_CILOOKUP;
 
@@ -462,6 +465,7 @@ xfs_dir_removename(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_removename(args);
@@ -523,6 +527,7 @@ xfs_dir_replace(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_replace(args);
diff --git a/fs/xfs/libxfs/xfs_swapext.c b/fs/xfs/libxfs/xfs_swapext.c
index 69d08e32df1a..a656182c9b38 100644
--- a/fs/xfs/libxfs/xfs_swapext.c
+++ b/fs/xfs/libxfs/xfs_swapext.c
@@ -539,6 +539,7 @@ xfs_swapext_attr_to_sf(
 		.geo		= tp->t_mountp->m_attr_geo,
 		.whichfork	= XFS_ATTR_FORK,
 		.trans		= tp,
+		.owner		= sxi->sxi_ip2->i_ino,
 	};
 	struct xfs_buf		*bp;
 	int			forkoff;
@@ -569,6 +570,7 @@ xfs_swapext_dir_to_sf(
 		.geo		= tp->t_mountp->m_dir_geo,
 		.whichfork	= XFS_DATA_FORK,
 		.trans		= tp,
+		.owner		= sxi->sxi_ip2->i_ino,
 	};
 	struct xfs_dir2_sf_hdr	sfh;
 	struct xfs_buf		*bp;
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 6c16d9530cca..40a59b24c209 100644
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
index a849c5d2be78..4a1d38af0804 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -619,10 +619,11 @@ xchk_directory_blocks(
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
index e51c1544be63..20375c0972db 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -275,6 +275,7 @@ xchk_dir_walk(
 		.dp		= dp,
 		.geo		= dp->i_mount->m_dir_geo,
 		.trans		= sc->tp,
+		.owner		= dp->i_ino,
 	};
 	bool			isblock;
 	int			error;
@@ -326,6 +327,7 @@ xchk_dir_lookup(
 		.hashval	= xfs_dir2_hashname(dp->i_mount, name),
 		.whichfork	= XFS_DATA_FORK,
 		.op_flags	= XFS_DA_OP_OKNOENT,
+		.owner		= dp->i_ino,
 	};
 	bool			isblock, isleaf;
 	int			error;
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 791db7d9c849..6fac38807eb9 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -135,6 +135,7 @@ xfs_get_acl(struct inode *inode, int type, bool rcu)
 		.dp		= ip,
 		.attr_filter	= XFS_ATTR_ROOT,
 		.valuelen	= XFS_ACL_MAX_SIZE(mp),
+		.owner		= ip->i_ino,
 	};
 	int			error;
 
@@ -178,6 +179,7 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	struct xfs_da_args	args = {
 		.dp		= ip,
 		.attr_filter	= XFS_ATTR_ROOT,
+		.owner		= ip->i_ino,
 	};
 	int			error;
 
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 2788a6f2edcd..0891d739666e 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -593,6 +593,7 @@ xfs_attri_item_recover(
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
+	args->owner = ip->i_ino;
 
 	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 4c061b48da18..fc2524b8f1f1 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -532,6 +532,7 @@ xfs_readdir(
 	args.dp = dp;
 	args.geo = dp->i_mount->m_dir_geo;
 	args.trans = tp;
+	args.owner = dp->i_ino;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_dir2_sf_getdents(&args, ctx);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 84e51745e2fd..b02fe7e5945e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -479,6 +479,7 @@ xfs_attrmulti_attr_get(
 		.name		= name,
 		.namelen	= strlen(name),
 		.valuelen	= *len,
+		.owner		= XFS_I(inode)->i_ino,
 	};
 	int			error;
 
@@ -512,6 +513,7 @@ xfs_attrmulti_attr_set(
 		.attr_flags	= xfs_attr_flags(flags),
 		.name		= name,
 		.namelen	= strlen(name),
+		.owner		= XFS_I(inode)->i_ino,
 	};
 	int			error;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 250568281a38..f90fafa15b3d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -62,6 +62,7 @@ xfs_initxattrs(
 			.namelen	= strlen(xattr->name),
 			.value		= xattr->value,
 			.valuelen	= xattr->value_len,
+			.owner		= ip->i_ino,
 		};
 		error = xfs_attr_change(&args);
 		if (error < 0)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 965a5f5b50ee..ecc2d4a8ce38 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1957,6 +1957,7 @@ DECLARE_EVENT_CLASS(xfs_da_class,
 		__field(xfs_dahash_t, hashval)
 		__field(xfs_ino_t, inumber)
 		__field(uint32_t, op_flags)
+		__field(xfs_ino_t, owner)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
@@ -1967,9 +1968,10 @@ DECLARE_EVENT_CLASS(xfs_da_class,
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
@@ -1977,7 +1979,8 @@ DECLARE_EVENT_CLASS(xfs_da_class,
 		  __entry->namelen,
 		  __entry->hashval,
 		  __entry->inumber,
-		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS))
+		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS),
+		  __entry->owner)
 )
 
 #define DEFINE_DIR2_EVENT(name) \
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 021360bbb8fb..71f6263505d3 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -122,6 +122,7 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 		.namelen	= strlen(name),
 		.value		= value,
 		.valuelen	= size,
+		.owner		= XFS_I(inode)->i_ino,
 	};
 	int			error;
 
@@ -145,6 +146,7 @@ xfs_xattr_set(const struct xattr_handler *handler,
 		.namelen	= strlen(name),
 		.value		= (void *)value,
 		.valuelen	= size,
+		.owner		= XFS_I(inode)->i_ino,
 	};
 	int			error;
 

