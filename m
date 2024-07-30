Return-Path: <linux-xfs+bounces-11118-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A1BA94037E
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2024 03:24:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C986D283158
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2024 01:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C40C17464;
	Tue, 30 Jul 2024 01:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vAt2fnuQ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8494D28EB
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302613; cv=none; b=coIS2vTFfhZjrFeNR2w/3x0unJoEFXDv/rvVhSUremRLryknUiLB/J32jNUfVNOuPbcG7BnQxOT/c+T+3aMgJhPCU4InYqVb9AVPb6llQHTQ5cDocBe6lKlmQC5WsnTRzLGhGfnQJx76F1rCeuDSG5CFXHBQIYni5nD1002Wfrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302613; c=relaxed/simple;
	bh=XfXJ56Ijz6vK3lDCY0CYbpA3Ovc6cud6ADZlbKArArI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ty83RGhmFw+hAPFVJTLgc9NT2Kon46A07WaV6jO1lCXwHaGm1DbsFWSAtOMaQPYMYK5oA64APfUfZxs1xtkRip5fTRcRafjg/D7DsydCRLqRe+Xi6VfXoW2XyEyu39xgPo5EcAFGh7faSN7Hh259vfCHMDBcm7JVGEoD79hqm20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vAt2fnuQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2E1C32786;
	Tue, 30 Jul 2024 01:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302613;
	bh=XfXJ56Ijz6vK3lDCY0CYbpA3Ovc6cud6ADZlbKArArI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vAt2fnuQwyY6zzpkrjR4K/C2kZlgPL+FBsQd+/mk+0nH1H5wkadZyfMDntbno2kNI
	 utD6jvEujmI2QCJr6TfBPnk/saQPfW0Qrqy3LIWmiMRSE4/Yz2j+yeW7VuAyVZMpWh
	 7UE2XF/Wf53vUJl8UJO4ry/pYbOyAb6CFI0TNSJdG99erYjKPJJCCmjSR0Q+Lrv/22
	 e5Tap8jUKjq8WwjLD5TBntJeIm1CC8GvdGZi1qNPrD8qDwwa8buks+KlOksGRhbSrx
	 PaDDCV1Aq8R8gGYGmFVVieHuhGheIbcBI/5vuIHp++04j5ewumvyen3VzoLx8BzCMI
	 qMcUE5TeAyzmQ==
Date: Mon, 29 Jul 2024 18:23:32 -0700
Subject: [PATCH 18/24] xfs_db: add a parents command to list the parents of a
 file
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229850752.1350924.8445323138154231292.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
References: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
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

Create a command to dump the parents of a file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/namei.c        |  323 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |    9 +
 2 files changed, 332 insertions(+)


diff --git a/db/namei.c b/db/namei.c
index 41ccaa04b..46b4cacb5 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -596,6 +596,326 @@ static struct cmdinfo ls_cmd = {
 	.help		= ls_help,
 };
 
+static void
+pptr_emit(
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const uint8_t		*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_ino_t		parent_ino;
+	uint32_t		parent_gen;
+	int			error;
+
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return;
+
+	error = -libxfs_parent_from_attr(mp, attr_flags, name, namelen, value,
+			valuelen, &parent_ino, &parent_gen);
+	if (error)
+		return;
+
+	dbprintf("%18llu:0x%08x %3d %.*s\n", parent_ino, parent_gen, namelen,
+			namelen, name);
+}
+
+static int
+list_sf_pptrs(
+	struct xfs_inode		*ip)
+{
+	struct xfs_attr_sf_hdr		*hdr = ip->i_af.if_data;
+	struct xfs_attr_sf_entry	*sfe;
+	unsigned int			i;
+
+	sfe = libxfs_attr_sf_firstentry(hdr);
+	for (i = 0; i < hdr->count; i++) {
+		pptr_emit(ip, sfe->flags, sfe->nameval, sfe->namelen,
+				sfe->nameval + sfe->valuelen, sfe->valuelen);
+
+		sfe = xfs_attr_sf_nextentry(sfe);
+	}
+
+	return 0;
+}
+
+static void
+list_leaf_pptr_entries(
+	struct xfs_inode		*ip,
+	struct xfs_buf			*bp)
+{
+	struct xfs_attr3_icleaf_hdr	ichdr;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_attr_leafblock	*leaf = bp->b_addr;
+	struct xfs_attr_leaf_entry	*entry;
+	unsigned int			i;
+
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
+	entry = xfs_attr3_leaf_entryp(leaf);
+
+	for (i = 0; i < ichdr.count; entry++, i++) {
+		struct xfs_attr_leaf_name_local	*name_loc;
+
+		/*
+		 * Parent pointers cannot be remote values; don't bother
+		 * decoding this xattr name.
+		 */
+		if (!(entry->flags & XFS_ATTR_LOCAL))
+			continue;
+
+		name_loc = xfs_attr3_leaf_name_local(leaf, i);
+		pptr_emit(ip, entry->flags, name_loc->nameval,
+				name_loc->namelen,
+				name_loc->nameval + name_loc->namelen,
+				be16_to_cpu(name_loc->valuelen));
+	}
+}
+
+static int
+list_leaf_pptrs(
+	struct xfs_inode		*ip)
+{
+	struct xfs_buf			*leaf_bp;
+	int				error;
+
+	error = -libxfs_attr3_leaf_read(NULL, ip, ip->i_ino, 0, &leaf_bp);
+	if (error)
+		return error;
+
+	list_leaf_pptr_entries(ip, leaf_bp);
+	libxfs_trans_brelse(NULL, leaf_bp);
+	return 0;
+}
+
+static int
+find_leftmost_attr_leaf(
+	struct xfs_inode		*ip,
+	struct xfs_buf			**leaf_bpp)
+{
+	struct xfs_da3_icnode_hdr	nodehdr;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_da_intnode		*node;
+	struct xfs_da_node_entry	*btree;
+	struct xfs_buf			*bp;
+	xfs_dablk_t			blkno = 0;
+	unsigned int			expected_level = 0;
+	int				error;
+
+	for (;;) {
+		uint16_t		magic;
+
+		error = -libxfs_da3_node_read(NULL, ip, blkno, &bp,
+				XFS_ATTR_FORK);
+		if (error)
+			return error;
+
+		node = bp->b_addr;
+		magic = be16_to_cpu(node->hdr.info.magic);
+		if (magic == XFS_ATTR_LEAF_MAGIC ||
+		    magic == XFS_ATTR3_LEAF_MAGIC)
+			break;
+
+		error = EFSCORRUPTED;
+		if (magic != XFS_DA_NODE_MAGIC &&
+		    magic != XFS_DA3_NODE_MAGIC)
+			goto out_buf;
+
+		libxfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
+
+		if (nodehdr.count == 0 || nodehdr.level >= XFS_DA_NODE_MAXDEPTH)
+			goto out_buf;
+
+		/* Check the level from the root node. */
+		if (blkno == 0)
+			expected_level = nodehdr.level - 1;
+		else if (expected_level != nodehdr.level)
+			goto out_buf;
+		else
+			expected_level--;
+
+		/* Find the next level towards the leaves of the dabtree. */
+		btree = nodehdr.btree;
+		blkno = be32_to_cpu(btree->before);
+		libxfs_trans_brelse(NULL, bp);
+	}
+
+	error = EFSCORRUPTED;
+	if (expected_level != 0)
+		goto out_buf;
+
+	*leaf_bpp = bp;
+	return 0;
+
+out_buf:
+	libxfs_trans_brelse(NULL, bp);
+	return error;
+}
+
+static int
+list_node_pptrs(
+	struct xfs_inode		*ip)
+{
+	struct xfs_attr3_icleaf_hdr	leafhdr;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_attr_leafblock	*leaf;
+	struct xfs_buf			*leaf_bp;
+	int				error;
+
+	error = find_leftmost_attr_leaf(ip, &leaf_bp);
+	if (error)
+		return error;
+
+	for (;;) {
+		list_leaf_pptr_entries(ip, leaf_bp);
+
+		/* Find the right sibling of this leaf block. */
+		leaf = leaf_bp->b_addr;
+		libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+		if (leafhdr.forw == 0)
+			goto out_leaf;
+
+		libxfs_trans_brelse(NULL, leaf_bp);
+
+		error = -libxfs_attr3_leaf_read(NULL, ip, ip->i_ino,
+				leafhdr.forw, &leaf_bp);
+		if (error)
+			return error;
+	}
+
+out_leaf:
+	libxfs_trans_brelse(NULL, leaf_bp);
+	return error;
+}
+
+static int
+list_pptrs(
+	struct xfs_inode	*ip)
+{
+	int			error;
+
+	if (!libxfs_inode_hasattr(ip))
+		return 0;
+
+	if (ip->i_af.if_format == XFS_DINODE_FMT_LOCAL)
+		return list_sf_pptrs(ip);
+
+	/* attr functions require that the attr fork is loaded */
+	error = -libxfs_iread_extents(NULL, ip, XFS_ATTR_FORK);
+	if (error)
+		return error;
+
+	if (libxfs_attr_is_leaf(ip))
+		return list_leaf_pptrs(ip);
+
+	return list_node_pptrs(ip);
+}
+
+/* If the io cursor points to a file, list its parents. */
+static int
+parent_cur(
+	char			*tag)
+{
+	struct xfs_inode	*ip;
+	int			error = 0;
+
+	if (!xfs_has_parent(mp))
+		return 0;
+
+	if (iocur_top->typ != &typtab[TYP_INODE])
+		return ENOTDIR;
+
+	error = -libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip);
+	if (error)
+		return error;
+
+	/* List the parents of a file. */
+	if (tag)
+		dbprintf(_("%s:\n"), tag);
+
+	error = list_pptrs(ip);
+	if (error)
+		goto rele;
+
+rele:
+	libxfs_irele(ip);
+	return error;
+}
+
+static void
+parent_help(void)
+{
+	dbprintf(_(
+"\n"
+" List the parents of the currently selected file.\n"
+"\n"
+" Parent pointers will be listed in the format:\n"
+" inode_number:inode_gen	ondisk_namehash:namehash	name_length	name\n"
+	));
+}
+
+static int
+parent_f(
+	int			argc,
+	char			**argv)
+{
+	int			c;
+	int			error = 0;
+
+	while ((c = getopt(argc, argv, "")) != -1) {
+		switch (c) {
+		default:
+			ls_help();
+			return 0;
+		}
+	}
+
+	if (optind == argc) {
+		error = parent_cur(NULL);
+		if (error) {
+			dbprintf("%s\n", strerror(error));
+			exitcode = 1;
+		}
+
+		return 0;
+	}
+
+	for (c = optind; c < argc; c++) {
+		push_cur();
+
+		error = path_walk(argv[c]);
+		if (error)
+			goto err_cur;
+
+		error = parent_cur(argv[c]);
+		if (error)
+			goto err_cur;
+
+		pop_cur();
+	}
+
+	return 0;
+err_cur:
+	pop_cur();
+	if (error) {
+		dbprintf("%s: %s\n", argv[c], strerror(error));
+		exitcode = 1;
+	}
+	return 0;
+}
+
+static struct cmdinfo parent_cmd = {
+	.name		= "parent",
+	.altname	= "pptr",
+	.cfunc		= parent_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.canpush	= 0,
+	.args		= "[paths...]",
+	.help		= parent_help,
+};
+
 void
 namei_init(void)
 {
@@ -604,4 +924,7 @@ namei_init(void)
 
 	ls_cmd.oneline = _("list directory contents");
 	add_command(&ls_cmd);
+
+	parent_cmd.oneline = _("list parent pointers");
+	add_command(&parent_cmd);
 }
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index a7f6d55ed..937b17e79 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -943,6 +943,15 @@ See the
 .B print
 command.
 .TP
+.BI "parent [" paths "]..."
+List the parents of a file.
+If a path resolves to a file, the parents of that file will be listed.
+If no paths are supplied and the IO cursor points at an inode, the parents of
+that file will be listed.
+
+The output format is:
+inode number, inode generation, ondisk namehash, namehash, name length, name.
+.TP
 .BI "path " dir_path
 Walk the directory tree to an inode using the supplied path.
 Absolute and relative paths are supported.


