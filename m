Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4794B66FCE
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Jul 2019 15:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfGLNOL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 12 Jul 2019 09:14:11 -0400
Received: from sandeen.net ([63.231.237.45]:57928 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbfGLNOL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Jul 2019 09:14:11 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 43B901164B;
        Fri, 12 Jul 2019 08:14:00 -0500 (CDT)
Subject: Re: [PATCH 01/10] libfrog: refactor online geometry queries
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <156151660523.2286979.13694849827562044045.stgit@magnolia>
 <156151661143.2286979.2427399743977199397.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <4b0f0074-b509-1a98-dc0b-9f21be4f95ae@sandeen.net>
Date:   Fri, 12 Jul 2019 08:14:08 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <156151661143.2286979.2427399743977199397.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/25/19 9:36 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor all the open-coded XFS_IOC_FSGEOMETRY queries into a single
> helper that we can use to standardize behaviors across mixed xfslibs
> versions.  This is the prelude to introducing a new FSGEOMETRY version
> in 5.2 and needing to fix the (relatively few) client programs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  Makefile            |    1 +
>  fsr/xfs_fsr.c       |   26 ++++----------------------
>  growfs/xfs_growfs.c |   25 +++++++++----------------
>  include/xfrog.h     |   22 ++++++++++++++++++++++
>  io/bmap.c           |    3 ++-
>  io/fsmap.c          |    3 ++-
>  io/open.c           |    3 ++-
>  io/stat.c           |    5 +++--
>  libfrog/fsgeom.c    |   18 ++++++++++++++++++
>  quota/free.c        |    6 +++---
>  repair/xfs_repair.c |    5 +++--
>  rtcp/Makefile       |    3 +++
>  rtcp/xfs_rtcp.c     |    7 ++++---
>  scrub/phase1.c      |    5 +++--
>  spaceman/file.c     |    3 ++-
>  spaceman/info.c     |   27 +++++++++------------------
>  16 files changed, 90 insertions(+), 72 deletions(-)
>  create mode 100644 include/xfrog.h
> 
> 
> diff --git a/Makefile b/Makefile
> index 9204bed8..0edc2700 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -107,6 +107,7 @@ copy: libxlog
>  mkfs: libxcmd
>  spaceman: libxcmd
>  scrub: libhandle libxcmd
> +rtcp: libfrog
>  
>  ifeq ($(HAVE_BUILDDEFS), yes)
>  include $(BUILDRULES)
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index fef6262c..0bfecf37 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -11,6 +11,7 @@
>  #include "xfs_bmap_btree.h"
>  #include "xfs_attr_sf.h"
>  #include "path.h"
> +#include "xfrog.h"
>  
>  #include <fcntl.h>
>  #include <errno.h>
> @@ -83,9 +84,8 @@ int cmp(const void *, const void *);
>  static void tmp_init(char *mnt);
>  static char * tmp_next(char *mnt);
>  static void tmp_close(char *mnt);
> -int xfs_getgeom(int , xfs_fsop_geom_v1_t * );
>  
> -static xfs_fsop_geom_v1_t fsgeom;	/* geometry of active mounted system */
> +static struct xfs_fsop_geom fsgeom;	/* geometry of active mounted system */
>  
>  #define NMOUNT 64
>  static int numfs;
> @@ -102,12 +102,6 @@ static int	nfrags = 0;	/* Debug option: Coerse into specific number
>  				 * of extents */
>  static int	openopts = O_CREAT|O_EXCL|O_RDWR|O_DIRECT;
>  
> -static int
> -xfs_fsgeometry(int fd, xfs_fsop_geom_v1_t *geom)
> -{
> -    return ioctl(fd, XFS_IOC_FSGEOMETRY_V1, geom);
> -}
> -
>  static int
>  xfs_bulkstat_single(int fd, xfs_ino_t *lastip, xfs_bstat_t *ubuffer)
>  {
> @@ -630,7 +624,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
>  		return -1;
>  	}
>  
> -	if (xfs_getgeom(fsfd, &fsgeom) < 0 ) {
> +	if (xfrog_geometry(fsfd, &fsgeom) < 0 ) {
>  		fsrprintf(_("Skipping %s: could not get XFS geometry\n"),
>  			  mntdir);
>  		close(fsfd);
> @@ -772,7 +766,7 @@ fsrfile(char *fname, xfs_ino_t ino)
>  	}
>  
>  	/* Get the fs geometry */
> -	if (xfs_getgeom(fsfd, &fsgeom) < 0 ) {
> +	if (xfrog_geometry(fsfd, &fsgeom) < 0 ) {
>  		fsrprintf(_("Unable to get geom on fs for: %s\n"), fname);
>  		goto out;
>  	}
> @@ -1612,18 +1606,6 @@ getnextents(int fd)
>  	return(nextents);
>  }
>  
> -/*
> - * Get the fs geometry
> - */
> -int
> -xfs_getgeom(int fd, xfs_fsop_geom_v1_t * fsgeom)
> -{
> -	if (xfs_fsgeometry(fd, fsgeom) < 0) {
> -		return -1;
> -	}
> -	return 0;
> -}
> -
>  /*
>   * Get xfs realtime space information
>   */
> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index 20089d2b..86b1d542 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -7,6 +7,7 @@
>  #include "libxfs.h"
>  #include "path.h"
>  #include "fsgeom.h"
> +#include "xfrog.h"
>  
>  static void
>  usage(void)
> @@ -165,22 +166,14 @@ main(int argc, char **argv)
>  	}
>  
>  	/* get the current filesystem size & geometry */
> -	if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY, &geo) < 0) {
> -		/*
> -		 * OK, new xfsctl barfed - back off and try earlier version
> -		 * as we're probably running an older kernel version.
> -		 * Only field added in the v2 geometry xfsctl is "logsunit"
> -		 * so we'll zero that out for later display (as zero).
> -		 */
> -		geo.logsunit = 0;
> -		if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY_V1, &geo) < 0) {
> -			fprintf(stderr, _(
> -				"%s: cannot determine geometry of filesystem"
> -				" mounted at %s: %s\n"),
> -				progname, fname, strerror(errno));
> -			exit(1);
> -		}
> +	if (xfrog_geometry(ffd, &geo) < 0) {
> +		fprintf(stderr, _(
> +			"%s: cannot determine geometry of filesystem"
> +			" mounted at %s: %s\n"),
> +			progname, fname, strerror(errno));
> +		exit(1);
>  	}
> +
>  	isint = geo.logstart > 0;
>  
>  	/*
> @@ -359,7 +352,7 @@ main(int argc, char **argv)
>  		}
>  	}
>  
> -	if (xfsctl(fname, ffd, XFS_IOC_FSGEOMETRY_V1, &ngeo) < 0) {
> +	if (xfrog_geometry(ffd, &ngeo) < 0) {
>  		fprintf(stderr, _("%s: XFS_IOC_FSGEOMETRY xfsctl failed: %s\n"),
>  			progname, strerror(errno));
>  		exit(1);
> diff --git a/include/xfrog.h b/include/xfrog.h
> new file mode 100644
> index 00000000..5420b47c
> --- /dev/null
> +++ b/include/xfrog.h
> @@ -0,0 +1,22 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2000-2002 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + */
> +#ifndef __XFROG_H__
> +#define __XFROG_H__
> +
> +/*
> + * XFS Filesystem Random Online Gluecode
> + * =====================================
> + *
> + * These support functions wrap the more complex xfs ioctls so that xfs
> + * utilities can take advantage of them without having to deal with graceful
> + * degradation in the face of new ioctls.  They will also provide higher level
> + * abstractions when possible.
> + */
> +
> +struct xfs_fsop_geom;
> +int xfrog_geometry(int fd, struct xfs_fsop_geom *fsgeo);
> +
> +#endif	/* __XFROG_H__ */
> diff --git a/io/bmap.c b/io/bmap.c
> index d408826a..5f0d12ca 100644
> --- a/io/bmap.c
> +++ b/io/bmap.c
> @@ -9,6 +9,7 @@
>  #include "input.h"
>  #include "init.h"
>  #include "io.h"
> +#include "xfrog.h"
>  
>  static cmdinfo_t bmap_cmd;
>  
> @@ -105,7 +106,7 @@ bmap_f(
>  		bmv_iflags &= ~(BMV_IF_PREALLOC|BMV_IF_NO_DMAPI_READ);
>  
>  	if (vflag) {
> -		c = xfsctl(file->name, file->fd, XFS_IOC_FSGEOMETRY_V1, &fsgeo);
> +		c = xfrog_geometry(file->fd, &fsgeo);
>  		if (c < 0) {
>  			fprintf(stderr,
>  				_("%s: can't get geometry [\"%s\"]: %s\n"),
> diff --git a/io/fsmap.c b/io/fsmap.c
> index 477c36fc..d3ff7dea 100644
> --- a/io/fsmap.c
> +++ b/io/fsmap.c
> @@ -9,6 +9,7 @@
>  #include "path.h"
>  #include "io.h"
>  #include "input.h"
> +#include "xfrog.h"
>  
>  static cmdinfo_t	fsmap_cmd;
>  static dev_t		xfs_data_dev;
> @@ -447,7 +448,7 @@ fsmap_f(
>  	}
>  
>  	if (vflag) {
> -		c = ioctl(file->fd, XFS_IOC_FSGEOMETRY, &fsgeo);
> +		c = xfrog_geometry(file->fd, &fsgeo);
>  		if (c < 0) {
>  			fprintf(stderr,
>  				_("%s: can't get geometry [\"%s\"]: %s\n"),
> diff --git a/io/open.c b/io/open.c
> index c7f5248a..e70c8cb0 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -9,6 +9,7 @@
>  #include "init.h"
>  #include "io.h"
>  #include "libxfs.h"
> +#include "xfrog.h"
>  
>  #ifndef __O_TMPFILE
>  #if defined __alpha__
> @@ -118,7 +119,7 @@ openfile(
>  	if (flags & IO_PATH) {
>  		/* Can't call ioctl() on O_PATH fds */
>  		memset(geom, 0, sizeof(*geom));
> -	} else if (xfsctl(path, fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
> +	} else if (xfrog_geometry(fd, geom) < 0) {
>  		perror("XFS_IOC_FSGEOMETRY");
>  		close(fd);
>  		return -1;
> diff --git a/io/stat.c b/io/stat.c
> index 37c0b2e8..f7bbe08b 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -12,6 +12,7 @@
>  #include "io.h"
>  #include "statx.h"
>  #include "libxfs.h"
> +#include "xfrog.h"
>  
>  #include <fcntl.h>
>  
> @@ -194,8 +195,8 @@ statfs_f(
>  	}
>  	if (file->flags & IO_FOREIGN)
>  		return 0;
> -	if ((xfsctl(file->name, file->fd, XFS_IOC_FSGEOMETRY_V1, &fsgeo)) < 0) {
> -		perror("XFS_IOC_FSGEOMETRY_V1");
> +	if (xfrog_geometry(file->fd, &fsgeo) < 0) {
> +		perror("XFS_IOC_FSGEOMETRY");
>  	} else {
>  		printf(_("geom.bsize = %u\n"), fsgeo.blocksize);
>  		printf(_("geom.agcount = %u\n"), fsgeo.agcount);
> diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
> index 8879d161..a6dab3a8 100644
> --- a/libfrog/fsgeom.c
> +++ b/libfrog/fsgeom.c
> @@ -4,6 +4,7 @@
>   */
>  #include "libxfs.h"
>  #include "fsgeom.h"
> +#include "xfrog.h"
>  
>  void
>  xfs_report_geom(
> @@ -67,3 +68,20 @@ xfs_report_geom(
>  		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
>  			(unsigned long long)geo->rtextents);
>  }
> +
> +/* Try to obtain the xfs geometry. */
> +int
> +xfrog_geometry(
> +	int			fd,
> +	struct xfs_fsop_geom	*fsgeo)
> +{
> +	int			ret;
> +
> +	memset(fsgeo, 0, sizeof(*fsgeo));
> +
> +	ret = ioctl(fd, XFS_IOC_FSGEOMETRY, fsgeo);
> +	if (!ret)
> +		return 0;
> +
> +	return ioctl(fd, XFS_IOC_FSGEOMETRY_V1, fsgeo);
> +}
> diff --git a/quota/free.c b/quota/free.c
> index 1d13006e..5432b6a8 100644
> --- a/quota/free.c
> +++ b/quota/free.c
> @@ -8,6 +8,7 @@
>  #include "command.h"
>  #include "init.h"
>  #include "quota.h"
> +#include "xfrog.h"
>  
>  static cmdinfo_t free_cmd;
>  
> @@ -67,9 +68,8 @@ mount_free_space_data(
>  	}
>  
>  	if (!(mount->fs_flags & FS_FOREIGN)) {
> -		if ((xfsctl(mount->fs_dir, fd, XFS_IOC_FSGEOMETRY_V1,
> -							&fsgeo)) < 0) {
> -			perror("XFS_IOC_FSGEOMETRY_V1");
> +		if (xfrog_geometry(fd, &fsgeo) < 0) {
> +			perror("XFS_IOC_FSGEOMETRY");
>  			close(fd);
>  			return 0;
>  		}
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 9657503f..2efeff2d 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -22,6 +22,7 @@
>  #include "dinode.h"
>  #include "slab.h"
>  #include "rmap.h"
> +#include "xfrog.h"
>  
>  /*
>   * option tables for getsubopt calls
> @@ -636,11 +637,11 @@ check_fs_vs_host_sectsize(
>  {
>  	int	fd;
>  	long	old_flags;
> -	struct xfs_fsop_geom_v1 geom = { 0 };
> +	struct xfs_fsop_geom	geom = { 0 };
>  
>  	fd = libxfs_device_to_fd(x.ddev);
>  
> -	if (ioctl(fd, XFS_IOC_FSGEOMETRY_V1, &geom) < 0) {
> +	if (xfrog_geometry(fd, &geom) < 0) {
>  		do_log(_("Cannot get host filesystem geometry.\n"
>  	"Repair may fail if there is a sector size mismatch between\n"
>  	"the image and the host filesystem.\n"));
> diff --git a/rtcp/Makefile b/rtcp/Makefile
> index 808b5378..264b4f27 100644
> --- a/rtcp/Makefile
> +++ b/rtcp/Makefile
> @@ -9,6 +9,9 @@ LTCOMMAND = xfs_rtcp
>  CFILES = xfs_rtcp.c
>  LLDFLAGS = -static
>  
> +LLDLIBS = $(LIBFROG)
> +LTDEPENDENCIES = $(LIBFROG)
> +
>  default: depend $(LTCOMMAND)
>  
>  include $(BUILDRULES)
> diff --git a/rtcp/xfs_rtcp.c b/rtcp/xfs_rtcp.c
> index f928a86a..0b37ee89 100644
> --- a/rtcp/xfs_rtcp.c
> +++ b/rtcp/xfs_rtcp.c
> @@ -5,6 +5,7 @@
>   */
>  
>  #include "libxfs.h"
> +#include "xfrog.h"
>  
>  int rtcp(char *, char *, int);
>  int xfsrtextsize(char *path);
> @@ -368,8 +369,8 @@ rtcp( char *source, char *target, int fextsize)
>  int
>  xfsrtextsize( char *path)
>  {
> -	int fd, rval, rtextsize;
> -	xfs_fsop_geom_v1_t geo;
> +	struct xfs_fsop_geom	geo;
> +	int			fd, rval, rtextsize;
>  
>  	fd = open( path, O_RDONLY );
>  	if ( fd < 0 ) {
> @@ -377,7 +378,7 @@ xfsrtextsize( char *path)
>  			progname, path, strerror(errno));
>  		return -1;
>  	}
> -	rval = xfsctl( path, fd, XFS_IOC_FSGEOMETRY_V1, &geo );
> +	rval = xfrog_geometry(fd, &geo);
>  	close(fd);
>  	if ( rval < 0 )
>  		return -1;
> diff --git a/scrub/phase1.c b/scrub/phase1.c
> index 04a5f4a9..bd7c9fee 100644
> --- a/scrub/phase1.c
> +++ b/scrub/phase1.c
> @@ -26,6 +26,7 @@
>  #include "disk.h"
>  #include "scrub.h"
>  #include "repair.h"
> +#include "xfrog.h"
>  
>  /* Phase 1: Find filesystem geometry (and clean up after) */
>  
> @@ -129,8 +130,8 @@ _("Does not appear to be an XFS filesystem!"));
>  	}
>  
>  	/* Retrieve XFS geometry. */
> -	error = ioctl(ctx->mnt_fd, XFS_IOC_FSGEOMETRY, &ctx->geo);
> -	if (error) {
> +	error = xfrog_geometry(ctx->mnt_fd, &ctx->geo);
> +	if (error < 0) {
>  		str_errno(ctx, ctx->mntpoint);
>  		return false;
>  	}
> diff --git a/spaceman/file.c b/spaceman/file.c
> index 7e33e07e..ef627fdb 100644
> --- a/spaceman/file.c
> +++ b/spaceman/file.c
> @@ -6,6 +6,7 @@
>   */
>  
>  #include "libxfs.h"
> +#include "xfrog.h"
>  #include <sys/mman.h>
>  #include "command.h"
>  #include "input.h"
> @@ -56,7 +57,7 @@ openfile(
>  		return -1;
>  	}
>  
> -	if (ioctl(fd, XFS_IOC_FSGEOMETRY, geom) < 0) {
> +	if (xfrog_geometry(fd, geom) < 0) {
>  		if (errno == ENOTTY)
>  			fprintf(stderr,
>  _("%s: Not on a mounted XFS filesystem.\n"),
> diff --git a/spaceman/info.c b/spaceman/info.c
> index 01d0744a..5357b430 100644
> --- a/spaceman/info.c
> +++ b/spaceman/info.c
> @@ -4,6 +4,7 @@
>   * Author: Darrick J. Wong <darrick.wong@oracle.com>
>   */
>  #include "libxfs.h"
> +#include "xfrog.h"
>  #include "command.h"
>  #include "init.h"
>  #include "path.h"
> @@ -37,24 +38,14 @@ info_f(
>  	}
>  
>  	/* get the current filesystem size & geometry */
> -	error = ioctl(file->fd, XFS_IOC_FSGEOMETRY, &geo);
> -	if (error) {
> -		/*
> -		 * OK, new xfsctl barfed - back off and try earlier version
> -		 * as we're probably running an older kernel version.
> -		 * Only field added in the v2 geometry xfsctl is "logsunit"
> -		 * so we'll zero that out for later display (as zero).
> -		 */
> -		geo.logsunit = 0;
> -		error = ioctl(file->fd, XFS_IOC_FSGEOMETRY_V1, &geo);
> -		if (error) {
> -			fprintf(stderr, _(
> -				"%s: cannot determine geometry of filesystem"
> -				" mounted at %s: %s\n"),
> -				progname, file->name, strerror(errno));
> -			exitcode = 1;
> -			return 0;
> -		}
> +	error = xfrog_geometry(file->fd, &geo);
> +	if (error < 0) {
> +		fprintf(stderr, _(
> +			"%s: cannot determine geometry of filesystem"
> +			" mounted at %s: %s\n"),
> +			progname, file->name, strerror(errno));
> +		exitcode = 1;
> +		return 0;
>  	}
>  
>  	xfs_report_geom(&geo, file->fs_path.fs_name, file->fs_path.fs_log,
> 
