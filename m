Return-Path: <linux-xfs+bounces-21831-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DBDF8A99968
	for <lists+linux-xfs@lfdr.de>; Wed, 23 Apr 2025 22:24:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A40E7A72EF
	for <lists+linux-xfs@lfdr.de>; Wed, 23 Apr 2025 20:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30ADF263C8C;
	Wed, 23 Apr 2025 20:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t6dzsva+"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FC526770B
	for <linux-xfs@vger.kernel.org>; Wed, 23 Apr 2025 20:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745439840; cv=none; b=LqnPFzcIAwPQtcIvTyTXt6WFEza25WmvUGuTzR3tuwVLPNhGywTAZl8lD/6aPFrcQO3WskimhmLSnI0FicWh8XUVizN3wnH543FGz9GwdCzWrMpqqz9lTTKNabCZSRjUQcx/mSGHB3H23lsGDp8Eukn0lsyIaS2SPcgth/KWVEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745439840; c=relaxed/simple;
	bh=GnoR3LE++xU5cIEeJP0tlX+QtNp4cUeM7ESg0PekMy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qK1XiC14SvBUknIa52StP2xNRztm1+bE6Xz8/jCF1KFKZ34aJ7n0fJNKMGnT3MfiMUGbKcAEO1SxxGeH5MeYXK8dNk6pF83dd/2/fMPMSguTIyYM0znDljDJSI4Wn7ZvsTR2XQ910SUpdGGE80w29BeH6DDSyPJiID5ENPbisnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t6dzsva+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661F3C4CEE2;
	Wed, 23 Apr 2025 20:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745439839;
	bh=GnoR3LE++xU5cIEeJP0tlX+QtNp4cUeM7ESg0PekMy8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t6dzsva+2n6beVS7x14pogqEQ+porK2167Tl/f80kMWBjYtUnmQUhbmQv1DEZw76d
	 H4sdf1ylq7zvmqUxw1DqLrbc520ZLlmOagTXtyaCcZz87M01g26g203mliqmNmGA1Z
	 aukTMl+q6TioUCAybPbLNJSZPJkIdIH5u39Jp+qPnprwZO86SNsOdrIwUPDqjsvA5T
	 BFRwfqMwy++kxyTYap30fL51jJ5bL97VHC9uey9c4SsrAcAP6xcwbFmAjjckmD3Pni
	 B69hl17DVIkL3KgcHgeYUDsGVZ2+Or6IRfchlSyMuBJYYi+q0pVsrx6afmh63azowA
	 zVHPAwQr8WQow==
Date: Wed, 23 Apr 2025 13:23:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev,
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v6 2/4] populate: add ability to populate a filesystem
 from a directory
Message-ID: <20250423202358.GI25675@frogsfrogsfrogs>
References: <20250423160319.810025-1-luca.dimaio1@gmail.com>
 <20250423160319.810025-3-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423160319.810025-3-luca.dimaio1@gmail.com>

On Wed, Apr 23, 2025 at 06:03:17PM +0200, Luca Di Maio wrote:
> This patch implements the functionality to populate a newly created XFS
> filesystem directly from an existing directory structure.
> 
> The population process steps are as follows:
>   - create the root inode before populating content
>   - recursively process nested directories
>   - handle regular files, directories, symlinks, char devices, block
>     devices, and fifos
>   - preserve file and directory attributes (ownership, permissions)
>   - preserve timestamps from source files to maintain file history
>   - preserve file extended attributes
> 
> This functionality makes it easier to create populated filesystems
> without having to write protofiles manually.
> It's particularly useful for reproducible builds.
> 
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> ---
>  mkfs/Makefile   |   2 +-
>  mkfs/populate.c | 313 ++++++++++++++++++++++++++++++++++++++++++++++++
>  mkfs/populate.h |  10 ++
>  3 files changed, 324 insertions(+), 1 deletion(-)
>  create mode 100644 mkfs/populate.c
>  create mode 100644 mkfs/populate.h
> 
> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index 04905bd..1611751 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -9,7 +9,7 @@ LTCOMMAND = mkfs.xfs
>  XFS_PROTOFILE = xfs_protofile.py
> 
>  HFILES =
> -CFILES = proto.c xfs_mkfs.c
> +CFILES = populate.c proto.c xfs_mkfs.c
>  CFGFILES = \
>  	dax_x86_64.conf \
>  	lts_4.19.conf \
> diff --git a/mkfs/populate.c b/mkfs/populate.c
> new file mode 100644
> index 0000000..f5eacbf
> --- /dev/null
> +++ b/mkfs/populate.c
> @@ -0,0 +1,313 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2025 Chainguard, Inc.
> + * All Rights Reserved.
> + * Author: Luca Di Maio <luca.dimaio1@gmail.com>
> + */
> +#include <fcntl.h>
> +#include <limits.h>
> +#include <linux/fs.h>
> +#include <stdio.h>
> +#include <string.h>
> +#include <dirent.h>
> +#include <sys/stat.h>
> +#include "libxfs.h"
> +#include "proto.h"
> +
> +static void walk_dir(struct xfs_mount *mp, struct xfs_inode *pip,
> +			    struct fsxattr *fsxp, char *cur_path);
> +
> +static void fail(char *msg, int i)
> +{
> +	fprintf(stderr, _("%s: %s [%d - %s]\n"), progname, msg, i, strerror(i));
> +	exit(1);
> +}
> +
> +static int newregfile(char *fname)
> +{
> +	int fd;
> +	off_t size;
> +
> +	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
> +		fprintf(stderr, _("%s: cannot open %s: %s\n"), progname, fname,
> +			strerror(errno));
> +		exit(1);
> +	}
> +
> +	return fd;
> +}

Why is this copy-pasting code from proto.c?  Put the new functions
there, and then you don't need all this externing.

> +
> +static void writetimestamps(struct xfs_inode *ip, struct stat statbuf)
> +{
> +	struct timespec64 ts;
> +
> +	/*
> +	 * Copy timestamps from source file to destination inode.
> +	 *  In order to not be influenced by our own access timestamp,
> +	 *  we set atime and ctime to mtime of the source file.
> +	 *  Usually reproducible archives will delete or not register
> +	 *  atime and ctime, for example:
> +	 *     https://www.gnu.org/software/tar/manual/html_section/Reproducibility.html
> +	 */
> +	ts.tv_sec = statbuf.st_mtime;
> +	ts.tv_nsec = statbuf.st_mtim.tv_nsec;
> +	inode_set_atime_to_ts(VFS_I(ip), ts);
> +	inode_set_ctime_to_ts(VFS_I(ip), ts);
> +	inode_set_mtime_to_ts(VFS_I(ip), ts);

This seems weird to me that you'd set [ac]time to mtime.  Why not open
the source file O_ATIME and copy atime?  And why would copying ctime not
result in a reproducible build?

Not sure what you do about crtime.

> +
> +	return;
> +}
> +
> +static void create_file(struct xfs_mount *mp, struct xfs_inode *pip,
> +			struct fsxattr *fsxp, int mode, struct cred creds,
> +			struct xfs_name xname, int flags, struct stat file_stat,
> +			xfs_dev_t rdev, int fd, char *fname, char *path)
> +{
> +	int error;
> +	struct xfs_parent_args *ppargs = NULL;
> +	struct xfs_inode *ip;
> +	struct xfs_trans *tp;
> +
> +	tp = getres(mp, 0);
> +	ppargs = newpptr(mp);
> +	error = creatproto(&tp, pip, mode, rdev, &creds, fsxp, &ip);
> +	if (error)
> +		fail(_("Inode allocation failed"), error);
> +	libxfs_trans_ijoin(tp, pip, 0);
> +	newdirent(mp, tp, pip, &xname, ip, ppargs);
> +
> +	/*
> +	 * copy over timestamps
> +	 */
> +	writetimestamps(ip, file_stat);
> +
> +	libxfs_trans_log_inode(tp, ip, flags);
> +	error = -libxfs_trans_commit(tp);
> +	if (error)
> +		fail(_("Error encountered creating file from prototype file"),
> +		     error);
> +
> +	libxfs_parent_finish(mp, ppargs);
> +
> +	/*
> +	 * copy over file content, attributes and
> +	 * timestamps
> +	 */
> +	if (fd != 0) {
> +		writefile(ip, fname, fd);
> +		writeattrs(ip, fname, fd);

Since we're adding features, should this read the fsxattr info from the
source file, override it with the set fields in *fsxp, and set that on
the file?  If you're going to slurp up a directory, you might as well
get all the non-xattr file attributes.

> +		close(fd);
> +	}
> +
> +	libxfs_irele(ip);
> +}
> +
> +static void handle_direntry(struct xfs_mount *mp, struct xfs_inode *pip,
> +			    struct fsxattr *fsxp, char* cur_path, struct dirent *entry)
> +{
> +	char link_target[PATH_MAX];
> +	char path[PATH_MAX];
> +	int error;
> +	int fd = -1;
> +	int flags;
> +	int majdev;
> +	int mindev;
> +	int mode;
> +	off_t len;
> +	struct cred creds;
> +	struct stat file_stat;
> +	struct xfs_name xname;
> +	struct xfs_parent_args *ppargs = NULL;
> +	struct xfs_inode *ip;
> +	struct xfs_trans *tp;
> +
> +	/*
> +	 * Skip "." and ".." directories
> +	 */
> +	if (strcmp(entry->d_name, ".") == 0 ||
> +	    strcmp(entry->d_name, "..") == 0) {
> +		return;
> +	}
> +
> +	/*
> +	 * Create the full path to the original file or directory
> +	 */
> +	snprintf(path, sizeof(path), "%s/%s", cur_path, entry->d_name);
> +
> +	if (lstat(path, &file_stat) < 0) {
> +		printf("%s (error accessing)\n", entry->d_name);
> +		return;
> +	}
> +
> +	memset(&creds, 0, sizeof(creds));
> +	creds.cr_uid = file_stat.st_uid;
> +	creds.cr_gid = file_stat.st_gid;
> +	xname.name = (unsigned char *)entry->d_name;
> +	xname.len = strlen(entry->d_name);
> +	xname.type = 0;
> +	mode = file_stat.st_mode;
> +	flags = XFS_ILOG_CORE;
> +	switch (file_stat.st_mode & S_IFMT) {
> +	case S_IFDIR:
> +		tp = getres(mp, 0);
> +		error = creatproto(&tp, pip, mode, 0, &creds, fsxp, &ip);
> +		if (error)
> +			fail(_("Inode allocation failed"), error);
> +		ppargs = newpptr(mp);
> +		libxfs_trans_ijoin(tp, pip, 0);
> +		xname.type = XFS_DIR3_FT_DIR;
> +		newdirent(mp, tp, pip, &xname, ip, ppargs);
> +		libxfs_bumplink(tp, pip);
> +		libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
> +		newdirectory(mp, tp, ip, pip);
> +
> +		/*
> +		 * copy over timestamps
> +		 */
> +		writetimestamps(ip, file_stat);
> +
> +		libxfs_trans_log_inode(tp, ip, flags);
> +		error = -libxfs_trans_commit(tp);
> +		if (error)
> +			fail(_("Directory inode allocation failed."), error);
> +
> +		libxfs_parent_finish(mp, ppargs);
> +		tp = NULL;

Shouldn't this copy xattrs and fsxattrs to directories and symlinks too?

> +
> +		walk_dir(mp, ip, fsxp, path);
> +
> +		libxfs_irele(ip);
> +		break;
> +	case S_IFREG:
> +		fd = newregfile(path);
> +		xname.type = XFS_DIR3_FT_REG_FILE;
> +		create_file(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
> +			    0, fd, entry->d_name, path);
> +		break;
> +	case S_IFLNK:
> +		len = readlink(path, link_target, PATH_MAX - 1);
> +		tp = getres(mp, XFS_B_TO_FSB(mp, len));
> +		ppargs = newpptr(mp);
> +		error = creatproto(&tp, pip, mode, 0, &creds, fsxp, &ip);
> +		if (error)
> +			fail(_("Inode allocation failed"), error);
> +		writesymlink(tp, ip, link_target, len);
> +		libxfs_trans_ijoin(tp, pip, 0);
> +		xname.type = XFS_DIR3_FT_SYMLINK;
> +		newdirent(mp, tp, pip, &xname, ip, ppargs);
> +
> +		/*
> +		 * copy over timestamps
> +		 */
> +		writetimestamps(ip, file_stat);
> +
> +		libxfs_trans_log_inode(tp, ip, flags);
> +		error = -libxfs_trans_commit(tp);
> +		if (error)
> +			fail(_("Error encountered creating file from prototype file"),
> +			     error);
> +		libxfs_parent_finish(mp, ppargs);
> +		libxfs_irele(ip);
> +		break;
> +	case S_IFCHR:
> +		xname.type = XFS_DIR3_FT_CHRDEV;
> +		majdev = major(file_stat.st_rdev);
> +		mindev = minor(file_stat.st_rdev);
> +		create_file(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
> +			    IRIX_MKDEV(majdev, mindev), 0, entry->d_name, path);
> +		break;
> +	case S_IFBLK:
> +		xname.type = XFS_DIR3_FT_BLKDEV;
> +		majdev = major(file_stat.st_rdev);
> +		mindev = minor(file_stat.st_rdev);
> +		create_file(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
> +			    IRIX_MKDEV(majdev, mindev), 0, entry->d_name, path);
> +		break;
> +	case S_IFIFO:
> +		flags |= XFS_ILOG_DEV;
> +		create_file(mp, pip, fsxp, mode, creds, xname, flags, file_stat,
> +			    0, 0, entry->d_name, path);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +/*
> + * walk_dir will recursively list files and directories
> + * and populate the mountpoint *mp with them using handle_direntry().
> + */
> +static void walk_dir(struct xfs_mount *mp, struct xfs_inode *pip,
> +			    struct fsxattr *fsxp, char *cur_path)
> +{
> +	DIR *dir;
> +	struct dirent *entry;
> +
> +	/*
> +	 * open input directory and iterate over all entries in it.
> +	 * when another directory is found, we will recursively call
> +	 * populatefromdir.
> +	 */
> +	if ((dir = opendir(cur_path)) == NULL)
> +		fail(_("cannot open input dir"), 1);
> +	while ((entry = readdir(dir)) != NULL) {
> +		handle_direntry(mp, pip, fsxp, cur_path, entry);
> +	}
> +	closedir(dir);
> +}

nftw() ?  Which has the nice feature of constraining the number of open
dirs at any given time.

--D

> +
> +void populate_from_dir(struct xfs_mount *mp, struct xfs_inode *pip,
> +		       struct fsxattr *fsxp, char *cur_path)
> +{
> +	int error;
> +	int mode;
> +	struct cred creds;
> +	struct xfs_inode *ip;
> +	struct xfs_trans *tp;
> +
> +	/*
> +	 * we first ensure we have the root inode
> +	 */
> +	memset(&creds, 0, sizeof(creds));
> +	creds.cr_uid = 0;
> +	creds.cr_gid = 0;
> +	mode = S_IRWXU | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH;
> +	tp = getres(mp, 0);
> +	error = creatproto(&tp, pip, mode | S_IFDIR, 0, &creds, fsxp, &ip);
> +	if (error)
> +		fail(_("Inode allocation failed"), error);
> +	pip = ip;
> +	mp->m_sb.sb_rootino = ip->i_ino;
> +	libxfs_log_sb(tp);
> +	newdirectory(mp, tp, ip, pip);
> +	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	error = -libxfs_trans_commit(tp);
> +	if (error)
> +		fail(_("Inode allocation failed"), error);
> +
> +	libxfs_parent_finish(mp, NULL);
> +
> +	/*
> +	 * RT initialization.  Do this here to ensure that
> +	 * the RT inodes get placed after the root inode.
> +	 */
> +	error = create_metadir(mp);
> +	if (error)
> +		fail(_("Creation of the metadata directory inode failed"),
> +		     error);
> +
> +	rtinit(mp);
> +
> +	/*
> +	 * now that we have a root inode, let's
> +	 * walk the input dir and populate the partition
> +	 */
> +	walk_dir(mp, ip, fsxp, cur_path);
> +
> +	/*
> +	 * we free up our root inode
> +	 * only when we finished populating the
> +	 * root filesystem
> +	 */
> +	libxfs_irele(ip);
> +}
> diff --git a/mkfs/populate.h b/mkfs/populate.h
> new file mode 100644
> index 0000000..d65df57
> --- /dev/null
> +++ b/mkfs/populate.h
> @@ -0,0 +1,10 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2025 Chainguard, Inc.
> + * All Rights Reserved.
> + * Author: Luca Di Maio <luca.dimaio1@gmail.com>
> + */
> +#ifndef MKFS_POPULATE_H_
> +#define MKFS_POPULATE_H_
> +void populate_from_dir(xfs_mount_t *mp, xfs_inode_t *pip, struct fsxattr *fsxp, char *name);
> +#endif /* MKFS_POPULATE_H_ */
> --
> 2.49.0
> 

