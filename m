Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D23E2C492E
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Nov 2020 21:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbgKYUis (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Nov 2020 15:38:48 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:42620 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730181AbgKYUis (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 15:38:48 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0APKOpoL027916;
        Wed, 25 Nov 2020 20:38:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=r4fZ4JF0vSefW5Rb1lZ8eAanYM6H81wRbzUxD6ELo58=;
 b=GfPKT17+QwY38X2YaT5Xpv/tPPplsiDfRNNQ7D4cZn9ijoMfrdhnDwa0Ud/rsPgZ0nvY
 9Jd406+Qpx9U7PNpzGtRQ+m8vEr+YQCO12JBgre3zIxg8JxwgR81hXBNuc9dSL+2hrFO
 QkZFeFEFy6aQ6UuwaFxbd80ALEAx7dCU2eu5WyRdtpr6s9i4wFCopV2cFdUXDmEiHaKg
 jY7gzixW+2QhQOXSjxbItgQlCBCTei8+LkeQezfbdZdCrPQjs+8G/P0JrZRWua4amlOK
 UuDb2EVdk+Pxfh5yK2wHI2flXImZkdER88E6x96Qg99YpbKJ/Vn+YOvZ0DBVA+QU6vX4 Mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 351kwhbbaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 25 Nov 2020 20:38:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0APKQ4Qr066428;
        Wed, 25 Nov 2020 20:38:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 351n2je03t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Nov 2020 20:38:44 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0APKciqh029274;
        Wed, 25 Nov 2020 20:38:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Nov 2020 12:38:43 -0800
Subject: [PATCH 2/2] xfs_db: add an ls command
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Nov 2020 12:38:42 -0800
Message-ID: <160633672276.635630.209542592059319318.stgit@magnolia>
In-Reply-To: <160633671056.635630.15067741092455507598.stgit@magnolia>
References: <160633671056.635630.15067741092455507598.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9816 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9816 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 impostorscore=0
 suspectscore=2 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011250127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add to xfs_db the ability to list a directory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/namei.c               |  389 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    1 
 man/man8/xfs_db.8        |   16 ++
 3 files changed, 406 insertions(+)


diff --git a/db/namei.c b/db/namei.c
index 13ae7f7d116b..4b467ff8f1f5 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -215,9 +215,398 @@ static struct cmdinfo path_cmd = {
 	.help		= path_help,
 };
 
+/* List a directory's entries. */
+
+static const char *filetype_strings[XFS_DIR3_FT_MAX] = {
+	[XFS_DIR3_FT_UNKNOWN]	= "unknown",
+	[XFS_DIR3_FT_REG_FILE]	= "regular",
+	[XFS_DIR3_FT_DIR]	= "directory",
+	[XFS_DIR3_FT_CHRDEV]	= "chardev",
+	[XFS_DIR3_FT_BLKDEV]	= "blkdev",
+	[XFS_DIR3_FT_FIFO]	= "fifo",
+	[XFS_DIR3_FT_SOCK]	= "socket",
+	[XFS_DIR3_FT_SYMLINK]	= "symlink",
+	[XFS_DIR3_FT_WHT]	= "whiteout",
+};
+
+static const char *
+get_dstr(
+	struct xfs_mount	*mp,
+	uint8_t			filetype)
+{
+	if (!xfs_sb_version_hasftype(&mp->m_sb))
+		return filetype_strings[XFS_DIR3_FT_UNKNOWN];
+
+	if (filetype >= XFS_DIR3_FT_MAX)
+		return filetype_strings[XFS_DIR3_FT_UNKNOWN];
+
+	return filetype_strings[filetype];
+}
+
+static void
+dir_emit(
+	struct xfs_mount	*mp,
+	xfs_dir2_dataptr_t	off,
+	char			*name,
+	ssize_t			namelen,
+	xfs_ino_t		ino,
+	uint8_t			dtype)
+{
+	char			*display_name;
+	struct xfs_name		xname = { .name = name };
+	const char		*dstr = get_dstr(mp, dtype);
+	xfs_dahash_t		hash;
+	bool			good;
+
+	if (namelen < 0) {
+		/* Negative length means that name is null-terminated. */
+		display_name = name;
+		xname.len = strlen(name);
+		good = true;
+	} else {
+		/*
+		 * Otherwise, name came from a directory entry, so we have to
+		 * copy the string to a buffer so that we can add the null
+		 * terminator.
+		 */
+		display_name = malloc(namelen + 1);
+		memcpy(display_name, name, namelen);
+		display_name[namelen] = 0;
+		xname.len = namelen;
+		good = libxfs_dir2_namecheck(name, namelen);
+	}
+	hash = libxfs_dir2_hashname(mp, &xname);
+
+	dbprintf("%-10u %-18llu %-14s 0x%08llx %3d %s %s\n", off & 0xFFFFFFFF,
+			ino, dstr, hash, xname.len,
+			display_name, good ? _("(good)") : _("(corrupt)"));
+
+	if (display_name != name)
+		free(display_name);
+}
+
+static int
+list_sfdir(
+	struct xfs_da_args		*args)
+{
+	struct xfs_inode		*dp = args->dp;
+	struct xfs_mount		*mp = dp->i_mount;
+	struct xfs_da_geometry		*geo = args->geo;
+	struct xfs_dir2_sf_entry	*sfep;
+	struct xfs_dir2_sf_hdr		*sfp;
+	xfs_ino_t			ino;
+	xfs_dir2_dataptr_t		off;
+	unsigned int			i;
+	uint8_t				filetype;
+
+	sfp = (struct xfs_dir2_sf_hdr *)dp->i_df.if_u1.if_data;
+
+	/* . and .. entries */
+	off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
+			geo->data_entry_offset);
+	dir_emit(args->dp->i_mount, off, ".", -1, dp->i_ino, XFS_DIR3_FT_DIR);
+
+	ino = libxfs_dir2_sf_get_parent_ino(sfp);
+	off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
+			geo->data_entry_offset +
+			libxfs_dir2_data_entsize(mp, sizeof(".") - 1));
+	dir_emit(args->dp->i_mount, off, "..", -1, ino, XFS_DIR3_FT_DIR);
+
+	/* Walk everything else. */
+	sfep = xfs_dir2_sf_firstentry(sfp);
+	for (i = 0; i < sfp->count; i++) {
+		ino = libxfs_dir2_sf_get_ino(mp, sfp, sfep);
+		filetype = libxfs_dir2_sf_get_ftype(mp, sfep);
+		off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
+				xfs_dir2_sf_get_offset(sfep));
+
+		dir_emit(args->dp->i_mount, off, (char *)sfep->name,
+				sfep->namelen, ino, filetype);
+		sfep = libxfs_dir2_sf_nextentry(mp, sfp, sfep);
+	}
+
+	return 0;
+}
+
+/* List entries in block format directory. */
+static int
+list_blockdir(
+	struct xfs_da_args	*args)
+{
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_buf		*bp;
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
+	xfs_dir2_dataptr_t	diroff;
+	unsigned int		offset;
+	unsigned int		end;
+	int			error;
+
+	error = xfs_dir3_block_read(NULL, dp, &bp);
+	if (error)
+		return error;
+
+	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
+	for (offset = geo->data_entry_offset; offset < end;) {
+		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
+		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+		uint8_t				filetype;
+
+		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
+			/* Unused entry */
+			offset += be16_to_cpu(dup->length);
+			continue;
+		}
+
+		/* Real entry */
+		diroff = xfs_dir2_db_off_to_dataptr(geo, geo->datablk, offset);
+		offset += libxfs_dir2_data_entsize(mp, dep->namelen);
+		filetype = libxfs_dir2_data_get_ftype(dp->i_mount, dep);
+		dir_emit(mp, diroff, (char *)dep->name, dep->namelen,
+				be64_to_cpu(dep->inumber), filetype);
+	}
+
+	libxfs_trans_brelse(args->trans, bp);
+	return error;
+}
+
+/* List entries in leaf format directory. */
+static int
+list_leafdir(
+	struct xfs_da_args	*args)
+{
+	struct xfs_bmbt_irec	map;
+	struct xfs_iext_cursor	icur;
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_buf		*bp = NULL;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(dp, XFS_DATA_FORK);
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
+	xfs_dir2_off_t		dirboff;
+	xfs_dablk_t		dabno = 0;
+	int			error = 0;
+
+	/* Read extent map. */
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = -libxfs_iread_extents(NULL, dp, XFS_DATA_FORK);
+		if (error)
+			return error;
+	}
+
+	while (dabno < geo->leafblk) {
+		unsigned int	offset;
+		unsigned int	length;
+
+		/* Find mapping for leaf block. */
+		if (!xfs_iext_lookup_extent(dp, ifp, dabno, &icur, &map))
+			break;
+		if (map.br_startoff >= geo->leafblk)
+			break;
+		libxfs_trim_extent(&map, dabno, geo->leafblk - dabno);
+
+		/* Read the directory block of that first mapping. */
+		error = xfs_dir3_data_read(NULL, dp, map.br_startoff, 0, &bp);
+		if (error)
+			break;
+
+		dirboff = xfs_dir2_da_to_byte(geo, map.br_startoff);
+		for (offset = geo->data_entry_offset; offset < geo->blksize;) {
+			struct xfs_dir2_data_entry	*dep;
+			struct xfs_dir2_data_unused	*dup;
+			uint8_t				filetype;
+
+			dup = bp->b_addr + offset;
+			dep = bp->b_addr + offset;
+
+			if (be16_to_cpu(dup->freetag) ==
+			    XFS_DIR2_DATA_FREE_TAG) {
+				/* Skip unused entry */
+				length = be16_to_cpu(dup->length);
+				offset += length;
+				continue;
+			}
+
+			offset += libxfs_dir2_data_entsize(mp, dep->namelen);
+			filetype = libxfs_dir2_data_get_ftype(mp, dep);
+
+			dir_emit(mp, xfs_dir2_byte_to_dataptr(dirboff + offset),
+					(char *)dep->name, dep->namelen,
+					be64_to_cpu(dep->inumber), filetype);
+		}
+
+		dabno += XFS_DADDR_TO_FSB(mp, bp->b_length);
+		libxfs_buf_relse(bp);
+		bp = NULL;
+	}
+
+	if (bp)
+		libxfs_buf_relse(bp);
+
+	return error;
+}
+
+/* Read the directory, display contents. */
+int
+listdir(
+	struct xfs_inode	*dp)
+{
+	struct xfs_da_args	args = {
+		.dp		= dp,
+		.geo		= dp->i_mount->m_dir_geo,
+	};
+	int			error;
+	int			isblock;
+
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+		return list_sfdir(&args);
+
+	error = -libxfs_dir2_isblock(&args, &isblock);
+	if (error)
+		return error;
+
+	if (isblock)
+		return list_blockdir(&args);
+	return list_leafdir(&args);
+}
+
+/* List the inode number of the currently selected inode. */
+static int
+inum_cur(void)
+{
+	if (iocur_top->typ != &typtab[TYP_INODE])
+		return ENOENT;
+
+	dbprintf("%llu\n", iocur_top->ino);
+	return 0;
+}
+
+/* If the io cursor points to a directory, list its contents. */
+static int
+ls_cur(
+	char			*tag)
+{
+	struct xfs_inode	*dp;
+	int			error = 0;
+
+	if (iocur_top->typ != &typtab[TYP_INODE] ||
+	    !S_ISDIR(iocur_top->mode))
+		return ENOTDIR;
+
+	error = -libxfs_iget(mp, NULL, iocur_top->ino, 0, &dp);
+	if (error)
+		return error;
+
+	if (!S_ISDIR(VFS_I(dp)->i_mode)) {
+		error = ENOTDIR;
+		goto rele;
+	}
+
+	/* List the contents of a directory. */
+	if (tag)
+		dbprintf(_("%s:\n"), tag);
+
+	error = listdir(dp);
+	if (error)
+		goto rele;
+
+rele:
+	libxfs_irele(dp);
+	return error;
+}
+
+static void
+ls_help(void)
+{
+	dbprintf(_(
+"\n"
+" List the contents of the currently selected directory inode.\n"
+"\n"
+" Options:\n"
+"   -i -- Resolve the given paths to their corresponding inode numbers.\n"
+"         If no paths are given, display the current inode number.\n"
+"\n"
+" Directory contents will be listed in the format:\n"
+" dir_cookie	inode_number	type	hash	name_length	name\n"
+	));
+}
+
+static int
+ls_f(
+	int			argc,
+	char			**argv)
+{
+	bool			inum_only = false;
+	int			c;
+	int			error = 0;
+
+	while ((c = getopt(argc, argv, "i")) != -1) {
+		switch (c) {
+		case 'i':
+			inum_only = true;
+			break;
+		default:
+			ls_help();
+			return 0;
+		}
+	}
+
+	if (optind == argc) {
+		if (inum_only)
+			error = inum_cur();
+		else
+			error = ls_cur(NULL);
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
+		if (inum_only)
+			error = inum_cur();
+		else
+			error = ls_cur(argv[c]);
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
+static struct cmdinfo ls_cmd = {
+	.name		= "ls",
+	.altname	= "l",
+	.cfunc		= ls_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.canpush	= 0,
+	.args		= "[-i] [paths...]",
+	.help		= ls_help,
+};
+
 void
 namei_init(void)
 {
 	path_cmd.oneline = _("navigate to an inode by path");
 	add_command(&path_cmd);
+
+	ls_cmd.oneline = _("list directory contents");
+	add_command(&ls_cmd);
 }
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 9492955d84f9..9a00ce6609b3 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -190,6 +190,7 @@
 #define xfs_trans_resv_calc		libxfs_trans_resv_calc
 #define xfs_trans_roll_inode		libxfs_trans_roll_inode
 #define xfs_trans_roll			libxfs_trans_roll
+#define xfs_trim_extent			libxfs_trim_extent
 
 #define xfs_verify_agbno		libxfs_verify_agbno
 #define xfs_verify_agino		libxfs_verify_agino
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 4df265ecd59e..587274957de3 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -806,6 +806,22 @@ This makes it easier to find discrepancies in the reservation calculations
 between xfsprogs and the kernel, which will help when diagnosing minimum
 log size calculation errors.
 .TP
+.BI "ls [\-i] [" paths "]..."
+List the contents of a directory.
+If a path resolves to a directory, the directory will be listed.
+If no paths are supplied and the IO cursor points at a directory inode,
+the contents of that directory will be listed.
+
+The output format is:
+directory cookie, inode number, file type, hash, name length, name.
+.RS 1.0i
+.TP 0.4i
+.B \-i
+Resolve each of the given paths to an inode number and print that number.
+If no paths are given and the IO cursor points to an inode, print the inode
+number.
+.RE
+.TP
 .BI "metadump [\-egow] " filename
 Dumps metadata to a file. See
 .BR xfs_metadump (8)

