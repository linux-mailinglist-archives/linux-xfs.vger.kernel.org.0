Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8F425640
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 18:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfEUQ61 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 12:58:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41600 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbfEUQ60 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 12:58:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LGn0Po188788;
        Tue, 21 May 2019 16:58:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=ZSV+j0Ggk6wYo/h8X7y/f4+8vjRrMz0FrreXyEL/v0Q=;
 b=qVb1iksJGQnRgMtg9SkfBca96gTrC88ccFzMb12Wz87ssEy29gZ5MfK5kKrh0Wjmi/PL
 thNClbEIDWUTpZ8Dqm+YcAr9Q7/aPs5l2I92o/wCiYiqsjmoCf6HhTvQJt3m9wUtzFlN
 uZBkbdreO96WRtIfD8u8pN8lx0ISjqSopFWFc8hIl6oyc7OyJRss0lXdtXigp3I3fz48
 cTyLodVhF9+YuxuT6MkzH+Hs+NtkO7bzhGy+qlBRdh9W+qoLHqmXraS196vGTM8vNHh6
 dZkE0mSPbzV1Km1Gp/J7+TxG7N2LmMMaqOSome1NhQ9UQDA0yloGrwS9GJFt0ql2J+cx zQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2sj9fteur4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 16:58:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LGvfr7126164;
        Tue, 21 May 2019 16:58:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2sks1jjg2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 16:58:24 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4LGwNlJ010225;
        Tue, 21 May 2019 16:58:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 May 2019 16:58:22 +0000
Date:   Tue, 21 May 2019 09:58:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] misc: remove all use of xfs_fsop_geom_t
Message-ID: <20190521165822.GC5141@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839423901.68606.18360420363137361199.stgit@magnolia>
 <210bdf1c-646c-96dd-287d-929178a62b7d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <210bdf1c-646c-96dd-287d-929178a62b7d@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905210104
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905210103
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 11:43:43AM -0500, Eric Sandeen wrote:
> On 5/20/19 6:17 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Remove all the uses of the old xfs_fsop_geom_t typedef.
> 
> Ok.  Any complaint if I tab stuff out to line up again when I commit
> it, assuming it doesn't cause 80char problems?

None here.

--D

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  growfs/xfs_growfs.c |    4 ++--
> >  io/init.c           |    2 +-
> >  io/io.h             |    6 +++---
> >  io/open.c           |    6 +++---
> >  man/man3/xfsctl.3   |    2 +-
> >  spaceman/file.c     |    4 ++--
> >  spaceman/init.c     |    2 +-
> >  spaceman/space.h    |    6 +++---
> >  8 files changed, 16 insertions(+), 16 deletions(-)
> > 
> > 
> > diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
> > index 392e4a00..ffd82f95 100644
> > --- a/growfs/xfs_growfs.c
> > +++ b/growfs/xfs_growfs.c
> > @@ -44,7 +44,7 @@ main(int argc, char **argv)
> >  	int			error;	/* we have hit an error */
> >  	long			esize;	/* new rt extent size */
> >  	int			ffd;	/* mount point file descriptor */
> > -	xfs_fsop_geom_t		geo;	/* current fs geometry */
> > +	struct xfs_fsop_geom	geo;	/* current fs geometry */
> >  	int			iflag;	/* -i flag */
> >  	int			isint;	/* log is currently internal */
> >  	int			lflag;	/* -l flag */
> > @@ -52,7 +52,7 @@ main(int argc, char **argv)
> >  	int			maxpct;	/* -m flag value */
> >  	int			mflag;	/* -m flag */
> >  	int			nflag;	/* -n flag */
> > -	xfs_fsop_geom_t		ngeo;	/* new fs geometry */
> > +	struct xfs_fsop_geom	ngeo;	/* new fs geometry */
> >  	int			rflag;	/* -r flag */
> >  	long long		rsize;	/* new rt size in fs blocks */
> >  	int			xflag;	/* -x flag */
> > diff --git a/io/init.c b/io/init.c
> > index 83f08f2d..7025aea5 100644
> > --- a/io/init.c
> > +++ b/io/init.c
> > @@ -133,7 +133,7 @@ init(
> >  	int		c, flags = 0;
> >  	char		*sp;
> >  	mode_t		mode = 0600;
> > -	xfs_fsop_geom_t	geometry = { 0 };
> > +	struct xfs_fsop_geom geometry = { 0 };
> >  	struct fs_path	fsp;
> >  
> >  	progname = basename(argv[0]);
> > diff --git a/io/io.h b/io/io.h
> > index 6469179e..0848ab98 100644
> > --- a/io/io.h
> > +++ b/io/io.h
> > @@ -38,7 +38,7 @@ typedef struct fileio {
> >  	int		fd;		/* open file descriptor */
> >  	int		flags;		/* flags describing file state */
> >  	char		*name;		/* file name at time of open */
> > -	xfs_fsop_geom_t	geom;		/* XFS filesystem geometry */
> > +	struct xfs_fsop_geom geom;	/* XFS filesystem geometry */
> >  	struct fs_path	fs_path;	/* XFS path information */
> >  } fileio_t;
> >  
> > @@ -70,9 +70,9 @@ extern void *check_mapping_range(mmap_region_t *, off64_t, size_t, int);
> >   */
> >  
> >  extern off64_t		filesize(void);
> > -extern int		openfile(char *, xfs_fsop_geom_t *, int, mode_t,
> > +extern int		openfile(char *, struct xfs_fsop_geom *, int, mode_t,
> >  				 struct fs_path *);
> > -extern int		addfile(char *, int , xfs_fsop_geom_t *, int,
> > +extern int		addfile(char *, int , struct xfs_fsop_geom *, int,
> >  				struct fs_path *);
> >  extern void		printxattr(uint, int, int, const char *, int, int);
> >  
> > diff --git a/io/open.c b/io/open.c
> > index 11805cd7..ce7a5362 100644
> > --- a/io/open.c
> > +++ b/io/open.c
> > @@ -51,7 +51,7 @@ static long extsize;
> >  int
> >  openfile(
> >  	char		*path,
> > -	xfs_fsop_geom_t	*geom,
> > +	struct xfs_fsop_geom *geom,
> >  	int		flags,
> >  	mode_t		mode,
> >  	struct fs_path	*fs_path)
> > @@ -156,7 +156,7 @@ int
> >  addfile(
> >  	char		*name,
> >  	int		fd,
> > -	xfs_fsop_geom_t	*geometry,
> > +	struct xfs_fsop_geom *geometry,
> >  	int		flags,
> >  	struct fs_path	*fs_path)
> >  {
> > @@ -229,7 +229,7 @@ open_f(
> >  	int		c, fd, flags = 0;
> >  	char		*sp;
> >  	mode_t		mode = 0600;
> > -	xfs_fsop_geom_t	geometry = { 0 };
> > +	struct xfs_fsop_geom geometry = { 0 };
> >  	struct fs_path	fsp;
> >  
> >  	if (argc == 1) {
> > diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> > index 6e5027c4..462ccbd8 100644
> > --- a/man/man3/xfsctl.3
> > +++ b/man/man3/xfsctl.3
> > @@ -640,7 +640,7 @@ operations on XFS filesystems.
> >  For
> >  .B XFS_IOC_FSGEOMETRY
> >  (get filesystem mkfs time information), the output structure is of type
> > -.BR xfs_fsop_geom_t .
> > +.BR struct xfs_fsop_geom .
> >  For
> >  .B XFS_FS_COUNTS
> >  (get filesystem dynamic global information), the output structure is of type
> > diff --git a/spaceman/file.c b/spaceman/file.c
> > index d2acf5db..a9b8461f 100644
> > --- a/spaceman/file.c
> > +++ b/spaceman/file.c
> > @@ -44,7 +44,7 @@ print_f(
> >  int
> >  openfile(
> >  	char		*path,
> > -	xfs_fsop_geom_t	*geom,
> > +	struct xfs_fsop_geom *geom,
> >  	struct fs_path	*fs_path)
> >  {
> >  	struct fs_path	*fsp;
> > @@ -84,7 +84,7 @@ int
> >  addfile(
> >  	char		*name,
> >  	int		fd,
> > -	xfs_fsop_geom_t	*geometry,
> > +	struct xfs_fsop_geom *geometry,
> >  	struct fs_path	*fs_path)
> >  {
> >  	char		*filename;
> > diff --git a/spaceman/init.c b/spaceman/init.c
> > index 181a3446..c845f920 100644
> > --- a/spaceman/init.c
> > +++ b/spaceman/init.c
> > @@ -60,7 +60,7 @@ init(
> >  	char		**argv)
> >  {
> >  	int		c;
> > -	xfs_fsop_geom_t	geometry = { 0 };
> > +	struct xfs_fsop_geom geometry = { 0 };
> >  	struct fs_path	fsp;
> >  
> >  	progname = basename(argv[0]);
> > diff --git a/spaceman/space.h b/spaceman/space.h
> > index bf9cc2bf..b246f602 100644
> > --- a/spaceman/space.h
> > +++ b/spaceman/space.h
> > @@ -7,7 +7,7 @@
> >  #define XFS_SPACEMAN_SPACE_H_
> >  
> >  typedef struct fileio {
> > -	xfs_fsop_geom_t	geom;		/* XFS filesystem geometry */
> > +	struct xfs_fsop_geom geom;		/* XFS filesystem geometry */
> >  	struct fs_path	fs_path;	/* XFS path information */
> >  	char		*name;		/* file name at time of open */
> >  	int		fd;		/* open file descriptor */
> > @@ -17,8 +17,8 @@ extern fileio_t		*filetable;	/* open file table */
> >  extern int		filecount;	/* number of open files */
> >  extern fileio_t		*file;		/* active file in file table */
> >  
> > -extern int	openfile(char *, xfs_fsop_geom_t *, struct fs_path *);
> > -extern int	addfile(char *, int , xfs_fsop_geom_t *, struct fs_path *);
> > +extern int	openfile(char *, struct xfs_fsop_geom *, struct fs_path *);
> > +extern int	addfile(char *, int , struct xfs_fsop_geom *, struct fs_path *);
> >  
> >  extern void	print_init(void);
> >  extern void	help_init(void);
> > 
