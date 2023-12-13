Return-Path: <linux-xfs+bounces-603-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9DAA80D20E
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Dec 2023 17:38:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 662451F215E5
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Dec 2023 16:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B39F513AF7;
	Mon, 11 Dec 2023 16:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L4NCEbov"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD88BD
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mu1ksTTE57Ss8gfAcKRmIc2AK4SWs4x4c/UjztWn9TY=; b=L4NCEbovdQHCTdusfiasRXRamI
	2TZ8nFmA4YgdgFV8z/d53jNzKtBdtmIXKAG/alqTJ1JHPW3IIGclDC2NisBnRpODvTjrF/LydI4sw
	d5u65nrWX2yuJPC/t/y85WYQIbMb6LHbmiSjTqCz7XTV5G0WYF28gIuikc5hbpNCjJwta1ZUaUJql
	fYZ+ZxKQdbI9a2wRKbzBQqQnVd9xvzZTGmpgcS6CGEipnTEj1CvRTJxzZU1pnNgCU/s3R8Wa6x81h
	lkyG7nS2PIc1rE+aLslZGOIElPOQsEQXmJeJDuqpTpGk0UuLsS8a+Xi/2QwQHoZOJFwaFHhut90aZ
	VeoTKtWA==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjI6-005sva-0m;
	Mon, 11 Dec 2023 16:37:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 04/23] libxfs: remove the volname concept
Date: Mon, 11 Dec 2023 17:37:23 +0100
Message-Id: <20231211163742.837427-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231211163742.837427-1-hch@lst.de>
References: <20231211163742.837427-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

IRIX has the concept of a volume that has data/log/rt subvolumes (that's
where the subvolume name in Linux comes from), but in the current
Linux-only xfsprogs version trying to pretend we do anything with that
it is just utterly confusing.  The volname is basically just a very
obsfucated second way to pass the data device name, so get rid of it
in the libxfs and progs internals.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 copy/xfs_copy.c   |  7 ++----
 db/info.c         |  2 +-
 db/init.c         | 13 +++-------
 db/init.h         |  1 -
 db/output.c       |  2 +-
 include/libxfs.h  |  1 -
 libxfs/init.c     | 24 ++++--------------
 libxfs/topology.c | 10 ++++----
 mkfs/xfs_mkfs.c   | 63 ++++++++++-------------------------------------
 repair/init.c     | 11 ++-------
 10 files changed, 33 insertions(+), 101 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 79f659467..66728f199 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -718,11 +718,8 @@ main(int argc, char **argv)
 	xargs.isdirect = LIBXFS_DIRECT;
 	xargs.isreadonly = LIBXFS_ISREADONLY;
 
-	if (source_is_file)  {
-		xargs.dname = source_name;
-		xargs.disfile = 1;
-	} else
-		xargs.volname = source_name;
+	xargs.dname = source_name;
+	xargs.disfile = source_is_file;
 
 	if (!libxfs_init(&xargs))  {
 		do_log(_("%s: couldn't initialize XFS library\n"
diff --git a/db/info.c b/db/info.c
index 0f6c29429..b30ada3aa 100644
--- a/db/info.c
+++ b/db/info.c
@@ -30,7 +30,7 @@ info_f(
 	struct xfs_fsop_geom	geo;
 
 	libxfs_fs_geometry(mp, &geo, XFS_FS_GEOM_MAX_STRUCT_VER);
-	xfs_report_geom(&geo, fsdevice, x.logname, x.rtname);
+	xfs_report_geom(&geo, x.dname, x.logname, x.rtname);
 	return 0;
 }
 
diff --git a/db/init.c b/db/init.c
index 4599cc00d..18d9dfdd9 100644
--- a/db/init.c
+++ b/db/init.c
@@ -19,7 +19,6 @@
 
 static char		**cmdline;
 static int		ncmdline;
-char			*fsdevice;
 int			blkbb;
 int			exitcode;
 int			expert_mode;
@@ -91,11 +90,7 @@ init(
 	if (optind + 1 != argc)
 		usage();
 
-	fsdevice = argv[optind];
-	if (!x.disfile)
-		x.volname = fsdevice;
-	else
-		x.dname = fsdevice;
+	x.dname = argv[optind];
 	x.isdirect = LIBXFS_DIRECT;
 
 	x.bcache_flags = CACHE_MISCOMPARE_PURGE;
@@ -115,7 +110,7 @@ init(
 			1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, &bp, NULL);
 	if (error) {
 		fprintf(stderr, _("%s: %s is invalid (cannot read first 512 "
-			"bytes)\n"), progname, fsdevice);
+			"bytes)\n"), progname, x.dname);
 		exit(1);
 	}
 
@@ -126,7 +121,7 @@ init(
 	sbp = &xmount.m_sb;
 	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
 		fprintf(stderr, _("%s: %s is not a valid XFS filesystem (unexpected SB magic number 0x%08x)\n"),
-			progname, fsdevice, sbp->sb_magicnum);
+			progname, x.dname, sbp->sb_magicnum);
 		if (!force) {
 			fprintf(stderr, _("Use -F to force a read attempt.\n"));
 			exit(EXIT_FAILURE);
@@ -139,7 +134,7 @@ init(
 	if (!mp) {
 		fprintf(stderr,
 			_("%s: device %s unusable (not an XFS filesystem?)\n"),
-			progname, fsdevice);
+			progname, x.dname);
 		exit(1);
 	}
 	mp->m_log = &xlog;
diff --git a/db/init.h b/db/init.h
index 16dc13f2b..05e75c100 100644
--- a/db/init.h
+++ b/db/init.h
@@ -4,7 +4,6 @@
  * All Rights Reserved.
  */
 
-extern char		*fsdevice;
 extern int		blkbb;
 extern int		exitcode;
 extern int		expert_mode;
diff --git a/db/output.c b/db/output.c
index 422148afa..30ae82ced 100644
--- a/db/output.c
+++ b/db/output.c
@@ -34,7 +34,7 @@ dbprintf(const char *fmt, ...)
 	blockint();
 	i = 0;
 	if (dbprefix)
-		i += printf("%s: ", fsdevice);
+		i += printf("%s: ", x.dname);
 	i += vprintf(fmt, ap);
 	unblockint();
 	va_end(ap);
diff --git a/include/libxfs.h b/include/libxfs.h
index 9b0294cb8..b35dc2184 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -94,7 +94,6 @@ struct iomap;
  */
 typedef struct libxfs_xinit {
 				/* input parameters */
-	char            *volname;       /* pathname of volume */
 	char            *dname;         /* pathname of data "subvolume" */
 	char            *logname;       /* pathname of log "subvolume" */
 	char            *rtname;        /* pathname of realtime "subvolume" */
diff --git a/libxfs/init.c b/libxfs/init.c
index 9cfd20e3f..894d84057 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -294,10 +294,8 @@ int
 libxfs_init(libxfs_init_t *a)
 {
 	char		*dname;
-	int		fd;
 	char		*logname;
 	char		*rtname;
-	int		rval = 0;
 	int		flags;
 
 	dname = a->dname;
@@ -308,20 +306,12 @@ libxfs_init(libxfs_init_t *a)
 	a->dsize = a->lbsize = a->rtbsize = 0;
 	a->dbsize = a->logBBsize = a->logBBstart = a->rtsize = 0;
 
-	fd = -1;
 	flags = (a->isreadonly | a->isdirect);
 
 	rcu_init();
 	rcu_register_thread();
 	radix_tree_init();
 
-	if (a->volname) {
-		if (!check_open(a->volname, flags))
-			goto done;
-		fd = open(a->volname, O_RDONLY);
-		dname = a->dname = a->volname;
-		a->volname = NULL;
-	}
 	if (dname) {
 		if (a->disfile) {
 			a->ddev= libxfs_device_open(dname, a->dcreat, flags,
@@ -398,16 +388,12 @@ libxfs_init(libxfs_init_t *a)
 	use_xfs_buf_lock = a->usebuflock;
 	xfs_dir_startup();
 	init_caches();
-	rval = 1;
-done:
-	if (fd >= 0)
-		close(fd);
-	if (!rval) {
-		libxfs_close_devices(a);
-		rcu_unregister_thread();
-	}
+	return 1;
 
-	return rval;
+done:
+	libxfs_close_devices(a);
+	rcu_unregister_thread();
+	return 0;
 }
 
 
diff --git a/libxfs/topology.c b/libxfs/topology.c
index a17c19691..25f47beda 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -292,7 +292,6 @@ void get_topology(
 	int			force_overwrite)
 {
 	struct stat statbuf;
-	char *dfile = xi->volname ? xi->volname : xi->dname;
 
 	/*
 	 * If our target is a regular file, use platform_findsizes
@@ -300,7 +299,7 @@ void get_topology(
 	 * for direct IO; we'll set our sector size to that if possible.
 	 */
 	if (xi->disfile ||
-	    (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode))) {
+	    (!stat(xi->dname, &statbuf) && S_ISREG(statbuf.st_mode))) {
 		int fd;
 		int flags = O_RDONLY;
 		long long dummy;
@@ -309,15 +308,16 @@ void get_topology(
 		if (xi->disfile)
 			flags |= O_CREAT;
 
-		fd = open(dfile, flags, 0666);
+		fd = open(xi->dname, flags, 0666);
 		if (fd >= 0) {
-			platform_findsizes(dfile, fd, &dummy, &ft->lsectorsize);
+			platform_findsizes(xi->dname, fd, &dummy,
+					&ft->lsectorsize);
 			close(fd);
 			ft->psectorsize = ft->lsectorsize;
 		} else
 			ft->psectorsize = ft->lsectorsize = BBSIZE;
 	} else {
-		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth,
+		blkid_get_topology(xi->dname, &ft->dsunit, &ft->dswidth,
 				   &ft->lsectorsize, &ft->psectorsize,
 				   force_overwrite);
 	}
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index c522cb4df..19849ed21 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1959,7 +1959,6 @@ validate_sectorsize(
 	struct cli_params	*cli,
 	struct mkfs_default_params *dft,
 	struct fs_topology	*ft,
-	char			*dfile,
 	int			dry_run,
 	int			force_overwrite)
 {
@@ -1967,7 +1966,8 @@ validate_sectorsize(
 	 * Before anything else, verify that we are correctly operating on
 	 * files or block devices and set the control parameters correctly.
 	 */
-	check_device_type(dfile, &cli->xi->disfile, !cli->dsize, !dfile,
+	check_device_type(cli->xi->dname, &cli->xi->disfile,
+			  !cli->dsize, !cli->xi->dname,
 			  dry_run ? NULL : &cli->xi->dcreat, "d");
 	if (!cli->loginternal)
 		check_device_type(cli->xi->logname, &cli->xi->lisfile,
@@ -2929,36 +2929,17 @@ reported by the device (%u).\n"),
 	}
 }
 
-/*
- * This is more complex than it needs to be because we still support volume
- * based external logs. They are only discovered *after* the devices have been
- * opened, hence the crazy "is this really an internal log" checks here.
- */
 static void
 validate_logdev(
 	struct mkfs_params	*cfg,
-	struct cli_params	*cli,
-	char			**devname)
+	struct cli_params	*cli)
 {
 	struct libxfs_xinit	*xi = cli->xi;
 
-	*devname = NULL;
-
-	/* check for volume log first */
-	if (cli->loginternal && xi->volname && xi->logdev) {
-		*devname = _("volume log");
-		cfg->loginternal = false;
-	} else
-		cfg->loginternal = cli->loginternal;
+	cfg->loginternal = cli->loginternal;
 
 	/* now run device checks */
 	if (cfg->loginternal) {
-		if (xi->logdev) {
-			fprintf(stderr,
-_("can't have both external and internal logs\n"));
-			usage();
-		}
-
 		/*
 		 * if no sector size has been specified on the command line,
 		 * use what has been configured and validated for the data
@@ -2980,14 +2961,11 @@ _("log size %lld too large for internal log\n"),
 				(long long)cfg->logblocks);
 			usage();
 		}
-		*devname = _("internal log");
 		return;
 	}
 
 	/* External/log subvolume checks */
-	if (xi->logname)
-		*devname = xi->logname;
-	if (!*devname || !xi->logdev) {
+	if (!*xi->logname || !xi->logdev) {
 		fprintf(stderr, _("no log subvolume or external log.\n"));
 		usage();
 	}
@@ -3018,13 +2996,10 @@ reported by the device (%u).\n"),
 static void
 validate_rtdev(
 	struct mkfs_params	*cfg,
-	struct cli_params	*cli,
-	char			**devname)
+	struct cli_params	*cli)
 {
 	struct libxfs_xinit	*xi = cli->xi;
 
-	*devname = NULL;
-
 	if (!xi->rtdev) {
 		if (cli->rtsize) {
 			fprintf(stderr,
@@ -3032,7 +3007,6 @@ _("size specified for non-existent rt subvolume\n"));
 			usage();
 		}
 
-		*devname = _("none");
 		cfg->rtblocks = 0;
 		cfg->rtextents = 0;
 		cfg->rtbmblocks = 0;
@@ -3043,12 +3017,6 @@ _("size specified for non-existent rt subvolume\n"));
 		usage();
 	}
 
-	/* volume rtdev */
-	if (xi->volname)
-		*devname = _("volume rt");
-	else
-		*devname = xi->rtname;
-
 	if (cli->rtsize) {
 		if (cfg->rtblocks > DTOBT(xi->rtsize, cfg->blocklog)) {
 			fprintf(stderr,
@@ -4080,9 +4048,6 @@ main(
 	xfs_agnumber_t		agno;
 	struct xfs_buf		*buf;
 	int			c;
-	char			*dfile = NULL;
-	char			*logfile = NULL;
-	char			*rtfile = NULL;
 	int			dry_run = 0;
 	int			discard = 1;
 	int			force_overwrite = 0;
@@ -4222,9 +4187,8 @@ main(
 		fprintf(stderr, _("extra arguments\n"));
 		usage();
 	} else if (argc - optind == 1) {
-		dfile = xi.volname = getstr(argv[optind], &dopts, D_NAME);
-	} else
-		dfile = xi.dname;
+		xi.dname = getstr(argv[optind], &dopts, D_NAME);
+	}
 
 	/*
 	 * Now we have all the options parsed, we can read in the option file
@@ -4241,8 +4205,7 @@ main(
 	 * before opening the libxfs devices.
 	 */
 	validate_blocksize(&cfg, &cli, &dft);
-	validate_sectorsize(&cfg, &cli, &dft, &ft, dfile, dry_run,
-			    force_overwrite);
+	validate_sectorsize(&cfg, &cli, &dft, &ft, dry_run, force_overwrite);
 
 	/*
 	 * XXX: we still need to set block size and sector size global variables
@@ -4277,10 +4240,10 @@ main(
 	 * Open and validate the device configurations
 	 */
 	open_devices(&cfg, &xi);
-	validate_overwrite(dfile, force_overwrite);
+	validate_overwrite(xi.dname, force_overwrite);
 	validate_datadev(&cfg, &cli);
-	validate_logdev(&cfg, &cli, &logfile);
-	validate_rtdev(&cfg, &cli, &rtfile);
+	validate_logdev(&cfg, &cli);
+	validate_rtdev(&cfg, &cli);
 	calc_stripe_factors(&cfg, &cli, &ft);
 
 	/*
@@ -4321,7 +4284,7 @@ main(
 		struct xfs_fsop_geom	geo;
 
 		libxfs_fs_geometry(mp, &geo, XFS_FS_GEOM_MAX_STRUCT_VER);
-		xfs_report_geom(&geo, dfile, logfile, rtfile);
+		xfs_report_geom(&geo, xi.dname, xi.logname, xi.rtname);
 		if (dry_run)
 			exit(0);
 	}
diff --git a/repair/init.c b/repair/init.c
index 0d5bfabcf..6d019b393 100644
--- a/repair/init.c
+++ b/repair/init.c
@@ -54,15 +54,8 @@ xfs_init(libxfs_init_t *args)
 {
 	memset(args, 0, sizeof(libxfs_init_t));
 
-	if (isa_file)  {
-		args->disfile = 1;
-		args->dname = fs_name;
-		args->volname = NULL;
-	} else  {
-		args->disfile = 0;
-		args->volname = fs_name;
-		args->dname = NULL;
-	}
+	args->dname = fs_name;
+	args->disfile = isa_file;
 
 	if (log_spec)  {	/* External log specified */
 		args->logname = log_name;
-- 
2.39.2


