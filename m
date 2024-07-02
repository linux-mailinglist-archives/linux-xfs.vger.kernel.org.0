Return-Path: <linux-xfs+bounces-10029-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1685D91EC01
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 02:54:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8AB291F2207C
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 00:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40447D518;
	Tue,  2 Jul 2024 00:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhiPKYSu"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3468D50F
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881657; cv=none; b=tYw5xG3R909URXt6raXMuPzGkzrRjbavhsHH3tdtHBxv9vRW7YWNu4xZkRWIn6UIuHhFq9l+epnjQp5JVeI5Pv5x9zYri+f4u/kJe3/kRNjuAm53UXWjTSAhB/l2E++9jJz+n0IlGrbrPRR9uW8SgkmkmoDaF7OrqjvVJfmgIWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881657; c=relaxed/simple;
	bh=yY4T8VhpKvz+9XmPpMI9zDFb48sJjKsY/z1dVD6kkNw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JcYhjQ8geAxANRVAuRnRi/q6t15oi3fJhtsLDEdZig0kZkO7ZJL0eDeODeNujlceAW7LwGebui52yelPKjxakiCE7xOFnqfl8rHy0Y3m46BDuJJffL1rM9jmBeDMWx/mmAmiO14ZwYyddbZYjunqEgr53LnaFAs1p7ULaRo0Xj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhiPKYSu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777A5C116B1;
	Tue,  2 Jul 2024 00:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881656;
	bh=yY4T8VhpKvz+9XmPpMI9zDFb48sJjKsY/z1dVD6kkNw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nhiPKYSuOfA5x4RuO0kdaK2Z2alEhozRNPrJqoelpJ4RqdcEhAQpiJRf5bl/j8vRN
	 Nb5hB40wFXeby4IZRMMhcf6J8mr2LJ8fINFo6UYH7K+RkrESoCbrIdV0BIMpmyz/Bb
	 BIIHw5/Yuy+ZAixLkhyOxb/mx5pmi+AuibZuGpKp2U9A3tyMkUwyEKZpDZoN/r5RVt
	 rjF2ktJL/j3rRrK2MuaQKh6/Gwtdtb5zYXfTftj8I6DHu+GtGYYF5UJdIXWZ60Sa7s
	 FHVl2zcLK1iriuNPrRwO0sHjEuzCw/6kqF0jXOM6ihpl67qCKuCVVkgxK3E8+aCW3d
	 X8pn9kGqXTLcg==
Date: Mon, 01 Jul 2024 17:54:16 -0700
Subject: [PATCH 03/12] libhandle: add support for bulkstat v5
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988116756.2006519.10115349070206614078.stgit@frogsfrogsfrogs>
In-Reply-To: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs>
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

Add support to libhandle for generating file handles with bulkstat v5
structures.  xfs_fsr will need this to be able to interface with the new
vfs range swap ioctl, and other client programs will probably want this
over time.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/jdm.h   |   24 +++++++++++
 libhandle/jdm.c |  117 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 141 insertions(+)


diff --git a/include/jdm.h b/include/jdm.h
index c57fcae7fcac..445737a6b5f8 100644
--- a/include/jdm.h
+++ b/include/jdm.h
@@ -11,6 +11,7 @@ typedef void	jdm_fshandle_t;		/* filesystem handle */
 typedef void	jdm_filehandle_t;	/* filehandle */
 
 struct xfs_bstat;
+struct xfs_bulkstat;
 struct attrlist_cursor;
 struct parent;
 
@@ -23,6 +24,9 @@ jdm_new_filehandle( jdm_filehandle_t **handlep,	/* new filehandle */
 		    jdm_fshandle_t *fshandlep,	/* filesystem filehandle */
 		    struct xfs_bstat *sp);	/* bulkstat info */
 
+extern void jdm_new_filehandle_v5(jdm_filehandle_t **handlep, size_t *hlen,
+		jdm_fshandle_t *fshandlep, struct xfs_bulkstat *sp);
+
 extern void
 jdm_delete_filehandle( jdm_filehandle_t *handlep,/* filehandle to delete */
 		       size_t hlen);		/* filehandle size */
@@ -32,35 +36,55 @@ jdm_open( jdm_fshandle_t *fshandlep,
 	  struct xfs_bstat *sp,
 	  intgen_t oflags);
 
+extern intgen_t jdm_open_v5(jdm_fshandle_t *fshandlep, struct xfs_bulkstat *sp,
+		intgen_t oflags);
+
 extern intgen_t
 jdm_readlink( jdm_fshandle_t *fshandlep,
 	      struct xfs_bstat *sp,
 	      char *bufp,
 	      size_t bufsz);
 
+extern intgen_t jdm_readlink_v5(jdm_fshandle_t *fshandlep,
+		struct xfs_bulkstat *sp, char *bufp, size_t bufsz);
+
 extern intgen_t
 jdm_attr_multi(	jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
 		char *bufp, int rtrvcnt, int flags);
 
+extern intgen_t jdm_attr_multi_v5(jdm_fshandle_t *fshp,
+		struct xfs_bulkstat *statp, char *bufp, int rtrvcnt,
+		int flags);
+
 extern intgen_t
 jdm_attr_list(	jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
 		char *bufp, size_t bufsz, int flags,
 		struct attrlist_cursor *cursor);
 
+extern intgen_t jdm_attr_list_v5(jdm_fshandle_t *fshp,
+		struct xfs_bulkstat *statp, char *bufp, size_t bufsz, int
+		flags, struct attrlist_cursor *cursor);
+
 extern int
 jdm_parents( jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
 		struct parent *bufp, size_t bufsz,
 		unsigned int *count);
 
+extern int jdm_parents_v5(jdm_fshandle_t *fshp, struct xfs_bulkstat *statp,
+		struct parent *bufp, size_t bufsz, unsigned int *count);
+
 extern int
 jdm_parentpaths( jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
 		struct parent *bufp, size_t bufsz,
 		unsigned int *count);
 
+extern int jdm_parentpaths_v5(jdm_fshandle_t *fshp, struct xfs_bulkstat *statp,
+		struct parent *bufp, size_t bufsz, unsigned int *count);
+
 /* macro for determining the size of a structure member */
 #define sizeofmember( t, m )	sizeof( ( ( t * )0 )->m )
 
diff --git a/libhandle/jdm.c b/libhandle/jdm.c
index 07b0c60985ee..e21aff2b2c19 100644
--- a/libhandle/jdm.c
+++ b/libhandle/jdm.c
@@ -41,6 +41,19 @@ jdm_fill_filehandle( filehandle_t *handlep,
 	handlep->fh_ino = statp->bs_ino;
 }
 
+static void
+jdm_fill_filehandle_v5(
+	struct filehandle	*handlep,
+	struct fshandle		*fshandlep,
+	struct xfs_bulkstat	*statp)
+{
+	handlep->fh_fshandle = *fshandlep;
+	handlep->fh_sz_following = FILEHANDLE_SZ_FOLLOWING;
+	memset(handlep->fh_pad, 0, FILEHANDLE_SZ_PAD);
+	handlep->fh_gen = statp->bs_gen;
+	handlep->fh_ino = statp->bs_ino;
+}
+
 jdm_fshandle_t *
 jdm_getfshandle( char *mntpnt )
 {
@@ -90,6 +103,22 @@ jdm_new_filehandle( jdm_filehandle_t **handlep,
 		jdm_fill_filehandle(*handlep, (fshandle_t *) fshandlep, statp);
 }
 
+void
+jdm_new_filehandle_v5(
+	jdm_filehandle_t	**handlep,
+	size_t			*hlen,
+	jdm_fshandle_t		*fshandlep,
+	struct xfs_bulkstat	*statp)
+{
+	/* allocate and fill filehandle */
+	*hlen = sizeof(filehandle_t);
+	*handlep = (filehandle_t *) malloc(*hlen);
+	if (!*handlep)
+		return;
+
+	jdm_fill_filehandle_v5(*handlep, (struct fshandle *)fshandlep, statp);
+}
+
 /* ARGSUSED */
 void
 jdm_delete_filehandle( jdm_filehandle_t *handlep, size_t hlen )
@@ -111,6 +140,19 @@ jdm_open( jdm_fshandle_t *fshp, struct xfs_bstat *statp, intgen_t oflags )
 	return fd;
 }
 
+intgen_t
+jdm_open_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	intgen_t		oflags)
+{
+	struct fshandle		*fshandlep = (struct fshandle *)fshp;
+	struct filehandle	filehandle;
+
+	jdm_fill_filehandle_v5(&filehandle, fshandlep, statp);
+	return open_by_fshandle(&filehandle, sizeof(filehandle), oflags);
+}
+
 intgen_t
 jdm_readlink( jdm_fshandle_t *fshp,
 	      struct xfs_bstat *statp,
@@ -128,6 +170,20 @@ jdm_readlink( jdm_fshandle_t *fshp,
 	return rval;
 }
 
+intgen_t
+jdm_readlink_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	char			*bufp,
+	size_t			bufsz)
+{
+	struct fshandle		*fshandlep = (struct fshandle *)fshp;
+	struct filehandle	filehandle;
+
+	jdm_fill_filehandle_v5(&filehandle, fshandlep, statp);
+	return readlink_by_handle(&filehandle, sizeof(filehandle), bufp, bufsz);
+}
+
 int
 jdm_attr_multi(	jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
@@ -145,6 +201,22 @@ jdm_attr_multi(	jdm_fshandle_t *fshp,
 	return rval;
 }
 
+int
+jdm_attr_multi_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	char			*bufp,
+	int			rtrvcnt,
+	int			flags)
+{
+	struct fshandle		*fshandlep = (struct fshandle *)fshp;
+	struct filehandle	filehandle;
+
+	jdm_fill_filehandle_v5(&filehandle, fshandlep, statp);
+	return attr_multi_by_handle(&filehandle, sizeof(filehandle), bufp,
+			rtrvcnt, flags);
+}
+
 int
 jdm_attr_list(	jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
@@ -166,6 +238,27 @@ jdm_attr_list(	jdm_fshandle_t *fshp,
 	return rval;
 }
 
+int
+jdm_attr_list_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	char			*bufp,
+	size_t			bufsz,
+	int			flags,
+	struct attrlist_cursor	*cursor)
+{
+	struct fshandle		*fshandlep = (struct fshandle *)fshp;
+	struct filehandle	filehandle;
+
+	/* prevent needless EINVAL from the kernel */
+	if (bufsz > XFS_XATTR_LIST_MAX)
+		bufsz = XFS_XATTR_LIST_MAX;
+
+	jdm_fill_filehandle_v5(&filehandle, fshandlep, statp);
+	return attr_list_by_handle(&filehandle, sizeof(filehandle), bufp,
+			bufsz, flags, cursor);
+}
+
 int
 jdm_parents( jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
@@ -176,6 +269,18 @@ jdm_parents( jdm_fshandle_t *fshp,
 	return -1;
 }
 
+int
+jdm_parents_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	struct parent		*bufp,
+	size_t			bufsz,
+	unsigned int		*count)
+{
+	errno = EOPNOTSUPP;
+	return -1;
+}
+
 int
 jdm_parentpaths( jdm_fshandle_t *fshp,
 		struct xfs_bstat *statp,
@@ -185,3 +290,15 @@ jdm_parentpaths( jdm_fshandle_t *fshp,
 	errno = EOPNOTSUPP;
 	return -1;
 }
+
+int
+jdm_parentpaths_v5(
+	jdm_fshandle_t		*fshp,
+	struct xfs_bulkstat	*statp,
+	struct parent		*bufp,
+	size_t			bufsz,
+	unsigned int		*count)
+{
+	errno = EOPNOTSUPP;
+	return -1;
+}


