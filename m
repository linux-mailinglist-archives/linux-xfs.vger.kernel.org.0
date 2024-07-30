Return-Path: <linux-xfs+bounces-11120-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0246F940385
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2024 03:24:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADB6B283253
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2024 01:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2752BDDBC;
	Tue, 30 Jul 2024 01:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cUvs85XM"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB751854
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302644; cv=none; b=tsqKAAoPZfD8qwqp3cFYc82LK8RU/q1WVTe8LAm7RpSv3o+GFiuAVIjFFUaLPmlecSN96vZemIY1xz56ceneZjjS5OTnSZqPMQE6JNyK5g8C/0/Ah/Rkoq2ue2LHBfrpIuyBlih2ZyUqzkvnvV9hudVMXdr6IX9Pe95ZczRteEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302644; c=relaxed/simple;
	bh=mWaMhT3lBvvp4UPeGeYKqO77cUYne8O0SJ0ThqkFKgk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FpuFWuktGzxcR+5wU04zppNE3OEQ6OjZPnULEukKMd2LimioUuPX+bR15IrKIl9aKcorGxA4u6Zqr9OeA+cOu8SBi+QS+GxB1RNz8+CZnRp1rAJ90i73HJm2YnRNOskhd09dGcj9+hfH+/+Z/6fuBejOMDEKqWIVofzKCzNbARY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cUvs85XM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F37C32786;
	Tue, 30 Jul 2024 01:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302644;
	bh=mWaMhT3lBvvp4UPeGeYKqO77cUYne8O0SJ0ThqkFKgk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cUvs85XMBrSmzqc/Tyfai+X55LnyKhWqL26hQTw2/d5yKk4uPzNFAmlVBMKaE2n3F
	 duDBi6mu22c6BfTwPleuqZbVgKyf41O1/DTBhwjJ9qAwwkP4XiK0/5SEhYq3oPcVUm
	 94yMFSqayknGd0Tm6w2jZdScq6KwC7EQa8ledCLWGYb/sfSCUaVwZSiBTI0SQV1B1G
	 pMKRO7+FD9HfIpJxhNXPPdufWcSB8dRLd/JAGkl3VZsCMj4hC7EES1y/q+rdTQdZ+l
	 AAAvV7I0CFZTrZooLSgp50s76zqYjui/CnHkIrieRrk2As1QeCtDXwJqLEllynvma/
	 He4wuowjYT/SA==
Date: Mon, 29 Jul 2024 18:24:04 -0700
Subject: [PATCH 20/24] xfs_db: add link and unlink expert commands
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229850778.1350924.5145698799172358392.stgit@frogsfrogsfrogs>
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

Create a pair of commands to create and remove directory entries to
support functional testing of directory tree corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/namei.c               |  378 ++++++++++++++++++++++++++++++++++++++++++++++
 include/xfs_inode.h      |    4 
 libxfs/libxfs_api_defs.h |    8 +
 man/man8/xfs_db.8        |   20 ++
 4 files changed, 409 insertions(+), 1 deletion(-)


diff --git a/db/namei.c b/db/namei.c
index 46b4cacb5..d57ead4f1 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -916,6 +916,376 @@ static struct cmdinfo parent_cmd = {
 	.help		= parent_help,
 };
 
+static void
+link_help(void)
+{
+	dbprintf(_(
+"\n"
+" Create a directory entry in the current directory that points to the\n"
+" specified file.\n"
+"\n"
+" Options:\n"
+"   -i   -- Point to this specific inode number.\n"
+"   -p   -- Point to the inode given by this path.\n"
+"   -t   -- Set the file type to this value.\n"
+"   name -- Create this directory entry with this name.\n"
+	));
+}
+
+static int
+create_child(
+	struct xfs_mount	*mp,
+	xfs_ino_t		parent_ino,
+	const char		*name,
+	unsigned int		ftype,
+	xfs_ino_t		child_ino)
+{
+	struct xfs_name		xname = {
+		.name		= (const unsigned char *)name,
+		.len		= strlen(name),
+		.type		= ftype,
+	};
+	struct xfs_parent_args	*ppargs = NULL;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*dp, *ip;
+	unsigned int		resblks;
+	bool			isdir;
+	int			error;
+
+	error = -libxfs_iget(mp, NULL, parent_ino, 0, &dp);
+	if (error)
+		return error;
+
+	if (!S_ISDIR(VFS_I(dp)->i_mode)) {
+		error = -ENOTDIR;
+		goto out_dp;
+	}
+
+	error = -libxfs_iget(mp, NULL, child_ino, 0, &ip);
+	if (error)
+		goto out_dp;
+	isdir = S_ISDIR(VFS_I(ip)->i_mode);
+
+	if (xname.type == XFS_DIR3_FT_UNKNOWN)
+		xname.type = libxfs_mode_to_ftype(VFS_I(ip)->i_mode);
+
+	error = -libxfs_parent_start(mp, &ppargs);
+	if (error)
+		goto out_ip;
+
+	resblks = libxfs_link_space_res(mp, MAXNAMELEN);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_link, resblks, 0, 0,
+			&tp);
+	if (error)
+		goto out_parent;
+
+	libxfs_trans_ijoin(tp, dp, 0);
+	libxfs_trans_ijoin(tp, ip, 0);
+
+	error = -libxfs_dir_createname(tp, dp, &xname, ip->i_ino, resblks);
+	if (error)
+		goto out_trans;
+
+	/* bump dp's link to ip */
+	libxfs_bumplink(tp, ip);
+
+	/* bump ip's dotdot link to dp */
+	if (isdir)
+		libxfs_bumplink(tp, dp);
+
+	/* Replace the dotdot entry in the child directory. */
+	if (isdir) {
+		error = -libxfs_dir_replace(tp, ip, &xfs_name_dotdot,
+				dp->i_ino, resblks);
+		if (error)
+			goto out_trans;
+	}
+
+	if (ppargs) {
+		error = -libxfs_parent_addname(tp, ppargs, dp, &xname, ip);
+		if (error)
+			goto out_trans;
+	}
+
+	error = -libxfs_trans_commit(tp);
+	goto out_parent;
+
+out_trans:
+	libxfs_trans_cancel(tp);
+out_parent:
+	libxfs_parent_finish(mp, ppargs);
+out_ip:
+	libxfs_irele(ip);
+out_dp:
+	libxfs_irele(dp);
+	return error;
+}
+
+static const char *ftype_map[] = {
+	[XFS_DIR3_FT_REG_FILE]	= "reg",
+	[XFS_DIR3_FT_DIR]	= "dir",
+	[XFS_DIR3_FT_CHRDEV]	= "cdev",
+	[XFS_DIR3_FT_BLKDEV]	= "bdev",
+	[XFS_DIR3_FT_FIFO]	= "fifo",
+	[XFS_DIR3_FT_SOCK]	= "sock",
+	[XFS_DIR3_FT_SYMLINK]	= "symlink",
+	[XFS_DIR3_FT_WHT]	= "whiteout",
+};
+
+static int
+link_f(
+	int			argc,
+	char			**argv)
+{
+	xfs_ino_t		child_ino = NULLFSINO;
+	int			ftype = XFS_DIR3_FT_UNKNOWN;
+	unsigned int		i;
+	int			c;
+	int			error = 0;
+
+	while ((c = getopt(argc, argv, "i:p:t:")) != -1) {
+		switch (c) {
+		case 'i':
+			errno = 0;
+			child_ino = strtoull(optarg, NULL, 0);
+			if (errno == ERANGE) {
+				printf("%s: unknown inode number\n", optarg);
+				exitcode = 1;
+				return 0;
+			}
+			break;
+		case 'p':
+			push_cur();
+			error = path_walk(optarg);
+			if (error) {
+				printf("%s: %s\n", optarg, strerror(error));
+				exitcode = 1;
+				return 0;
+			} else if (iocur_top->typ != &typtab[TYP_INODE]) {
+				printf("%s: does not point to an inode\n",
+						optarg);
+				exitcode = 1;
+				return 0;
+			} else {
+				child_ino = iocur_top->ino;
+			}
+			pop_cur();
+			break;
+		case 't':
+			for (i = 0; i < ARRAY_SIZE(ftype_map); i++) {
+				if (ftype_map[i] &&
+				    !strcmp(ftype_map[i], optarg)) {
+					ftype = i;
+					break;
+				}
+			}
+			if (i == ARRAY_SIZE(ftype_map)) {
+				printf("%s: unknown file type\n", optarg);
+				exitcode = 1;
+				return 0;
+			}
+			break;
+		default:
+			link_help();
+			return 0;
+		}
+	}
+
+	if (child_ino == NULLFSINO) {
+		printf("link: need to specify child via -i or -p\n");
+		exitcode = 1;
+		return 0;
+	}
+
+	if (iocur_top->typ != &typtab[TYP_INODE]) {
+		printf("io cursor does not point to an inode.\n");
+		exitcode = 1;
+		return 0;
+	}
+
+	if (optind + 1 != argc) {
+		printf("link: need directory entry name");
+		exitcode = 1;
+		return 0;
+	}
+
+	error = create_child(mp, iocur_top->ino, argv[optind], ftype,
+			child_ino);
+	if (error) {
+		printf("link failed: %s\n", strerror(error));
+		exitcode = 1;
+		return 0;
+	}
+
+	return 0;
+}
+
+static struct cmdinfo link_cmd = {
+	.name		= "link",
+	.cfunc		= link_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.canpush	= 0,
+	.args		= "[-i ino] [-p path] [-t ftype] name",
+	.help		= link_help,
+};
+
+static void
+unlink_help(void)
+{
+	dbprintf(_(
+"\n"
+" Remove a directory entry from the current directory.\n"
+"\n"
+" Options:\n"
+"   name -- Remove the directory entry with this name.\n"
+	));
+}
+
+static void
+droplink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	libxfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+
+	if (inode->i_nlink != XFS_NLINK_PINNED)
+		drop_nlink(VFS_I(ip));
+
+	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
+
+static int
+remove_child(
+	struct xfs_mount	*mp,
+	xfs_ino_t		parent_ino,
+	const char		*name)
+{
+	struct xfs_name		xname = {
+		.name		= (const unsigned char *)name,
+		.len		= strlen(name),
+	};
+	struct xfs_parent_args	*ppargs;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*dp, *ip;
+	xfs_ino_t		child_ino;
+	unsigned int		resblks;
+	int			error;
+
+	error = -libxfs_iget(mp, NULL, parent_ino, 0, &dp);
+	if (error)
+		return error;
+
+	if (!S_ISDIR(VFS_I(dp)->i_mode)) {
+		error = -ENOTDIR;
+		goto out_dp;
+	}
+
+	error = -libxfs_dir_lookup(NULL, dp, &xname, &child_ino, NULL);
+	if (error)
+		goto out_dp;
+
+	error = -libxfs_iget(mp, NULL, child_ino, 0, &ip);
+	if (error)
+		goto out_dp;
+
+	error = -libxfs_parent_start(mp, &ppargs);
+	if (error)
+		goto out_ip;
+
+	resblks = libxfs_remove_space_res(mp, MAXNAMELEN);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, resblks, 0, 0,
+			&tp);
+	if (error)
+		goto out_parent;
+
+	libxfs_trans_ijoin(tp, dp, 0);
+	libxfs_trans_ijoin(tp, ip, 0);
+
+	if (S_ISDIR(VFS_I(ip)->i_mode)) {
+		/* drop ip's dotdot link to dp */
+		droplink(tp, dp);
+	} else {
+		libxfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+	}
+
+	/* drop dp's link to ip */
+	droplink(tp, ip);
+
+	error = -libxfs_dir_removename(tp, dp, &xname, ip->i_ino, resblks);
+	if (error)
+		goto out_trans;
+
+	if (ppargs) {
+		error = -libxfs_parent_removename(tp, ppargs, dp, &xname, ip);
+		if (error)
+			goto out_trans;
+	}
+
+	error = -libxfs_trans_commit(tp);
+	goto out_parent;
+
+out_trans:
+	libxfs_trans_cancel(tp);
+out_parent:
+	libxfs_parent_finish(mp, ppargs);
+out_ip:
+	libxfs_irele(ip);
+out_dp:
+	libxfs_irele(dp);
+	return error;
+}
+
+static int
+unlink_f(
+	int			argc,
+	char			**argv)
+{
+	int			c;
+	int			error = 0;
+
+	while ((c = getopt(argc, argv, "")) != -1) {
+		switch (c) {
+		default:
+			unlink_help();
+			return 0;
+		}
+	}
+
+	if (iocur_top->typ != &typtab[TYP_INODE]) {
+		printf("io cursor does not point to an inode.\n");
+		exitcode = 1;
+		return 0;
+	}
+
+	if (optind + 1 != argc) {
+		printf("unlink: need directory entry name");
+		exitcode = 1;
+		return 0;
+	}
+
+	error = remove_child(mp, iocur_top->ino, argv[optind]);
+	if (error) {
+		printf("unlink failed: %s\n", strerror(error));
+		exitcode = 1;
+		return 0;
+	}
+
+	return 0;
+}
+
+static struct cmdinfo unlink_cmd = {
+	.name		= "unlink",
+	.cfunc		= unlink_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.canpush	= 0,
+	.args		= "name",
+	.help		= unlink_help,
+};
+
 void
 namei_init(void)
 {
@@ -927,4 +1297,12 @@ namei_init(void)
 
 	parent_cmd.oneline = _("list parent pointers");
 	add_command(&parent_cmd);
+
+	if (expert_mode) {
+		link_cmd.oneline = _("create directory link");
+		add_command(&link_cmd);
+
+		unlink_cmd.oneline = _("remove directory link");
+		add_command(&unlink_cmd);
+	}
 }
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 45339b426..9bbf37225 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -315,6 +315,10 @@ static inline void inc_nlink(struct inode *inode)
 {
 	inode->i_nlink++;
 }
+static inline void drop_nlink(struct inode *inode)
+{
+	inode->i_nlink--;
+}
 
 static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 {
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index bceaab8ba..b7edaf788 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -147,12 +147,16 @@
 #define xfs_dir_init			libxfs_dir_init
 #define xfs_dir_ino_validate		libxfs_dir_ino_validate
 #define xfs_dir_lookup			libxfs_dir_lookup
+#define xfs_dir_removename		libxfs_dir_removename
 #define xfs_dir_replace			libxfs_dir_replace
 
 #define xfs_dqblk_repair		libxfs_dqblk_repair
 #define xfs_dquot_from_disk_ts		libxfs_dquot_from_disk_ts
 #define xfs_dquot_verify		libxfs_dquot_verify
 
+#define xfs_bumplink			libxfs_bumplink
+#define xfs_droplink			libxfs_droplink
+
 #define xfs_finobt_calc_reserves	libxfs_finobt_calc_reserves
 #define xfs_finobt_init_cursor		libxfs_finobt_init_cursor
 #define xfs_free_extent			libxfs_free_extent
@@ -191,13 +195,15 @@
 
 #define xfs_iread_extents		libxfs_iread_extents
 #define xfs_irele			libxfs_irele
+#define xfs_link_space_res		libxfs_link_space_res
 #define xfs_log_calc_minimum_size	libxfs_log_calc_minimum_size
 #define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res
 #define xfs_log_sb			libxfs_log_sb
 #define xfs_mode_to_ftype		libxfs_mode_to_ftype
 #define xfs_mkdir_space_res		libxfs_mkdir_space_res
-#define xfs_parent_add			libxfs_parent_add
+#define xfs_parent_addname		libxfs_parent_addname
 #define xfs_parent_finish		libxfs_parent_finish
+#define xfs_parent_removename		libxfs_parent_removename
 #define xfs_parent_start		libxfs_parent_start
 #define xfs_parent_from_attr		libxfs_parent_from_attr
 #define xfs_perag_get			libxfs_perag_get
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index a561bdc49..f8db6c36f 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -901,6 +901,21 @@ will result in truncation and a warning will be issued. If no
 .I label
 is given, the current filesystem label is printed.
 .TP
+.BI "link [-i " ino "] [-p " path "] [-t " ftype "] name"
+In the current directory, create a directory entry with the given
+.I name
+pointing to a file.
+The file must be specified either as a directory tree path as given by the
+.I path
+option; or directly as an inode number as given by the
+.I ino
+option.
+The file type in the directory entry will be determined from the mode of the
+child file unless the
+.I ftype
+option is given.
+The file being targetted must not be on the iunlink list.
+.TP
 .BI "log [stop | start " filename ]
 Start logging output to
 .IR filename ,
@@ -1052,6 +1067,11 @@ Print the timestamps in the current locale's date and time format instead of
 raw seconds since the Unix epoch.
 .RE
 .TP
+.BI "unlink name"
+In the current directory, remove a directory entry with the given
+.IR name .
+The file being targetted will not be put on the iunlink list.
+.TP
 .BI "uuid [" uuid " | " generate " | " rewrite " | " restore ]
 Set the filesystem universally unique identifier (UUID).
 The filesystem UUID can be used by


