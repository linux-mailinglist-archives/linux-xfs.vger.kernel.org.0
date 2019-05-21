Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12095255E3
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 18:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbfEUQnp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 12:43:45 -0400
Received: from sandeen.net ([63.231.237.45]:59806 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727946AbfEUQnp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 May 2019 12:43:45 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 29849325F;
        Tue, 21 May 2019 11:43:41 -0500 (CDT)
Subject: Re: [PATCH 06/12] misc: remove all use of xfs_fsop_geom_t
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839423901.68606.18360420363137361199.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <210bdf1c-646c-96dd-287d-929178a62b7d@sandeen.net>
Date:   Tue, 21 May 2019 11:43:43 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <155839423901.68606.18360420363137361199.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/20/19 6:17 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove all the uses of the old xfs_fsop_geom_t typedef.

Ok.  Any complaint if I tab stuff out to line up again when I commit
it, assuming it doesn't cause 80char problems?

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  growfs/xfs_growfs.c |    4 ++--
>  io/init.c           |    2 +-
>  io/io.h             |    6 +++---
>  io/open.c           |    6 +++---
>  man/man3/xfsctl.3   |    2 +-
>  spaceman/file.c     |    4 ++--
>  spaceman/init.c     |    2 +-
>  spaceman/space.h    |    6 +++---
>  8 files changed, 16 insertions(+), 16 deletions(-)
> 
> 
> diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> index 392e4a00..ffd82f95 100644
> --- a/growfs/xfs_growfs.c
> +++ b/growfs/xfs_growfs.c
> @@ -44,7 +44,7 @@ main(int argc, char **argv)
>  	int			error;	/* we have hit an error */
>  	long			esize;	/* new rt extent size */
>  	int			ffd;	/* mount point file descriptor */
> -	xfs_fsop_geom_t		geo;	/* current fs geometry */
> +	struct xfs_fsop_geom	geo;	/* current fs geometry */
>  	int			iflag;	/* -i flag */
>  	int			isint;	/* log is currently internal */
>  	int			lflag;	/* -l flag */
> @@ -52,7 +52,7 @@ main(int argc, char **argv)
>  	int			maxpct;	/* -m flag value */
>  	int			mflag;	/* -m flag */
>  	int			nflag;	/* -n flag */
> -	xfs_fsop_geom_t		ngeo;	/* new fs geometry */
> +	struct xfs_fsop_geom	ngeo;	/* new fs geometry */
>  	int			rflag;	/* -r flag */
>  	long long		rsize;	/* new rt size in fs blocks */
>  	int			xflag;	/* -x flag */
> diff --git a/io/init.c b/io/init.c
> index 83f08f2d..7025aea5 100644
> --- a/io/init.c
> +++ b/io/init.c
> @@ -133,7 +133,7 @@ init(
>  	int		c, flags = 0;
>  	char		*sp;
>  	mode_t		mode = 0600;
> -	xfs_fsop_geom_t	geometry = { 0 };
> +	struct xfs_fsop_geom geometry = { 0 };
>  	struct fs_path	fsp;
>  
>  	progname = basename(argv[0]);
> diff --git a/io/io.h b/io/io.h
> index 6469179e..0848ab98 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -38,7 +38,7 @@ typedef struct fileio {
>  	int		fd;		/* open file descriptor */
>  	int		flags;		/* flags describing file state */
>  	char		*name;		/* file name at time of open */
> -	xfs_fsop_geom_t	geom;		/* XFS filesystem geometry */
> +	struct xfs_fsop_geom geom;	/* XFS filesystem geometry */
>  	struct fs_path	fs_path;	/* XFS path information */
>  } fileio_t;
>  
> @@ -70,9 +70,9 @@ extern void *check_mapping_range(mmap_region_t *, off64_t, size_t, int);
>   */
>  
>  extern off64_t		filesize(void);
> -extern int		openfile(char *, xfs_fsop_geom_t *, int, mode_t,
> +extern int		openfile(char *, struct xfs_fsop_geom *, int, mode_t,
>  				 struct fs_path *);
> -extern int		addfile(char *, int , xfs_fsop_geom_t *, int,
> +extern int		addfile(char *, int , struct xfs_fsop_geom *, int,
>  				struct fs_path *);
>  extern void		printxattr(uint, int, int, const char *, int, int);
>  
> diff --git a/io/open.c b/io/open.c
> index 11805cd7..ce7a5362 100644
> --- a/io/open.c
> +++ b/io/open.c
> @@ -51,7 +51,7 @@ static long extsize;
>  int
>  openfile(
>  	char		*path,
> -	xfs_fsop_geom_t	*geom,
> +	struct xfs_fsop_geom *geom,
>  	int		flags,
>  	mode_t		mode,
>  	struct fs_path	*fs_path)
> @@ -156,7 +156,7 @@ int
>  addfile(
>  	char		*name,
>  	int		fd,
> -	xfs_fsop_geom_t	*geometry,
> +	struct xfs_fsop_geom *geometry,
>  	int		flags,
>  	struct fs_path	*fs_path)
>  {
> @@ -229,7 +229,7 @@ open_f(
>  	int		c, fd, flags = 0;
>  	char		*sp;
>  	mode_t		mode = 0600;
> -	xfs_fsop_geom_t	geometry = { 0 };
> +	struct xfs_fsop_geom geometry = { 0 };
>  	struct fs_path	fsp;
>  
>  	if (argc == 1) {
> diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> index 6e5027c4..462ccbd8 100644
> --- a/man/man3/xfsctl.3
> +++ b/man/man3/xfsctl.3
> @@ -640,7 +640,7 @@ operations on XFS filesystems.
>  For
>  .B XFS_IOC_FSGEOMETRY
>  (get filesystem mkfs time information), the output structure is of type
> -.BR xfs_fsop_geom_t .
> +.BR struct xfs_fsop_geom .
>  For
>  .B XFS_FS_COUNTS
>  (get filesystem dynamic global information), the output structure is of type
> diff --git a/spaceman/file.c b/spaceman/file.c
> index d2acf5db..a9b8461f 100644
> --- a/spaceman/file.c
> +++ b/spaceman/file.c
> @@ -44,7 +44,7 @@ print_f(
>  int
>  openfile(
>  	char		*path,
> -	xfs_fsop_geom_t	*geom,
> +	struct xfs_fsop_geom *geom,
>  	struct fs_path	*fs_path)
>  {
>  	struct fs_path	*fsp;
> @@ -84,7 +84,7 @@ int
>  addfile(
>  	char		*name,
>  	int		fd,
> -	xfs_fsop_geom_t	*geometry,
> +	struct xfs_fsop_geom *geometry,
>  	struct fs_path	*fs_path)
>  {
>  	char		*filename;
> diff --git a/spaceman/init.c b/spaceman/init.c
> index 181a3446..c845f920 100644
> --- a/spaceman/init.c
> +++ b/spaceman/init.c
> @@ -60,7 +60,7 @@ init(
>  	char		**argv)
>  {
>  	int		c;
> -	xfs_fsop_geom_t	geometry = { 0 };
> +	struct xfs_fsop_geom geometry = { 0 };
>  	struct fs_path	fsp;
>  
>  	progname = basename(argv[0]);
> diff --git a/spaceman/space.h b/spaceman/space.h
> index bf9cc2bf..b246f602 100644
> --- a/spaceman/space.h
> +++ b/spaceman/space.h
> @@ -7,7 +7,7 @@
>  #define XFS_SPACEMAN_SPACE_H_
>  
>  typedef struct fileio {
> -	xfs_fsop_geom_t	geom;		/* XFS filesystem geometry */
> +	struct xfs_fsop_geom geom;		/* XFS filesystem geometry */
>  	struct fs_path	fs_path;	/* XFS path information */
>  	char		*name;		/* file name at time of open */
>  	int		fd;		/* open file descriptor */
> @@ -17,8 +17,8 @@ extern fileio_t		*filetable;	/* open file table */
>  extern int		filecount;	/* number of open files */
>  extern fileio_t		*file;		/* active file in file table */
>  
> -extern int	openfile(char *, xfs_fsop_geom_t *, struct fs_path *);
> -extern int	addfile(char *, int , xfs_fsop_geom_t *, struct fs_path *);
> +extern int	openfile(char *, struct xfs_fsop_geom *, struct fs_path *);
> +extern int	addfile(char *, int , struct xfs_fsop_geom *, struct fs_path *);
>  
>  extern void	print_init(void);
>  extern void	help_init(void);
> 
