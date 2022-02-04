Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3C44AA42F
	for <lists+linux-xfs@lfdr.de>; Sat,  5 Feb 2022 00:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbiBDXSO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 4 Feb 2022 18:18:14 -0500
Received: from sandeen.net ([63.231.237.45]:54450 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377951AbiBDXSO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Feb 2022 18:18:14 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 376C87BCB;
        Fri,  4 Feb 2022 17:17:50 -0600 (CST)
Message-ID: <bb88560e-bbdf-80c5-b4d6-6c00f4ab3ef1@sandeen.net>
Date:   Fri, 4 Feb 2022 17:18:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263811682.863810.12064586264139896800.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 04/17] libfrog: move the GETFSMAP definitions into libfrog
In-Reply-To: <164263811682.863810.12064586264139896800.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 6:21 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Move our private copy of the GETFSMAP definition into a libfrog header
> file that (preferentially) uses the system header files.  We have no
> business shipping kernel headers in the xfslibs package, but this shim
> is still needed to build fully functional xfsprogs on old userspace.

Hm. Fine, but I wonder if we can get a bit more intentional about how
we handle this kind of thing, I understand why we copy this stuff into
xfsprogs early, but then we never know how to get rid of it.

Do we /need/ to build fully functional xfsprogs on old userspace?
(really: systems with old kernel headers?)  How far back do we go,
I wonder?  Anyway...

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  include/linux.h   |  105 ------------------------------------------------
>  io/fsmap.c        |    1 
>  io/io.h           |    5 --
>  libfrog/Makefile  |    1 
>  libfrog/fsmap.h   |  117 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  scrub/phase6.c    |    1 
>  scrub/phase7.c    |    1 
>  scrub/spacemap.c  |    1 
>  spaceman/freesp.c |    1 
>  spaceman/space.h  |    4 --
>  10 files changed, 123 insertions(+), 114 deletions(-)
>  create mode 100644 libfrog/fsmap.h
> 
> 
> diff --git a/include/linux.h b/include/linux.h
> index de8a7122..3d9f4e3d 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -251,111 +251,6 @@ struct fsxattr {
>  #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
>  #endif
>  
> -#ifdef HAVE_GETFSMAP
> -# include <linux/fsmap.h>
> -#else
> -/*
> - *	Structure for FS_IOC_GETFSMAP.
> - *
> - *	The memory layout for this call are the scalar values defined in
> - *	struct fsmap_head, followed by two struct fsmap that describe
> - *	the lower and upper bound of mappings to return, followed by an
> - *	array of struct fsmap mappings.
> - *
> - *	fmh_iflags control the output of the call, whereas fmh_oflags report
> - *	on the overall record output.  fmh_count should be set to the
> - *	length of the fmh_recs array, and fmh_entries will be set to the
> - *	number of entries filled out during each call.  If fmh_count is
> - *	zero, the number of reverse mappings will be returned in
> - *	fmh_entries, though no mappings will be returned.  fmh_reserved
> - *	must be set to zero.
> - *
> - *	The two elements in the fmh_keys array are used to constrain the
> - *	output.  The first element in the array should represent the
> - *	lowest disk mapping ("low key") that the user wants to learn
> - *	about.  If this value is all zeroes, the filesystem will return
> - *	the first entry it knows about.  For a subsequent call, the
> - *	contents of fsmap_head.fmh_recs[fsmap_head.fmh_count - 1] should be
> - *	copied into fmh_keys[0] to have the kernel start where it left off.
> - *
> - *	The second element in the fmh_keys array should represent the
> - *	highest disk mapping ("high key") that the user wants to learn
> - *	about.  If this value is all ones, the filesystem will not stop
> - *	until it runs out of mapping to return or runs out of space in
> - *	fmh_recs.
> - *
> - *	fmr_device can be either a 32-bit cookie representing a device, or
> - *	a 32-bit dev_t if the FMH_OF_DEV_T flag is set.  fmr_physical,
> - *	fmr_offset, and fmr_length are expressed in units of bytes.
> - *	fmr_owner is either an inode number, or a special value if
> - *	FMR_OF_SPECIAL_OWNER is set in fmr_flags.
> - */
> -struct fsmap {
> -	__u32		fmr_device;	/* device id */
> -	__u32		fmr_flags;	/* mapping flags */
> -	__u64		fmr_physical;	/* device offset of segment */
> -	__u64		fmr_owner;	/* owner id */
> -	__u64		fmr_offset;	/* file offset of segment */
> -	__u64		fmr_length;	/* length of segment */
> -	__u64		fmr_reserved[3];	/* must be zero */
> -};
> -
> -struct fsmap_head {
> -	__u32		fmh_iflags;	/* control flags */
> -	__u32		fmh_oflags;	/* output flags */
> -	__u32		fmh_count;	/* # of entries in array incl. input */
> -	__u32		fmh_entries;	/* # of entries filled in (output). */
> -	__u64		fmh_reserved[6];	/* must be zero */
> -
> -	struct fsmap	fmh_keys[2];	/* low and high keys for the mapping search */
> -	struct fsmap	fmh_recs[];	/* returned records */
> -};
> -
> -/* Size of an fsmap_head with room for nr records. */
> -static inline size_t
> -fsmap_sizeof(
> -	unsigned int	nr)
> -{
> -	return sizeof(struct fsmap_head) + nr * sizeof(struct fsmap);
> -}
> -
> -/* Start the next fsmap query at the end of the current query results. */
> -static inline void
> -fsmap_advance(
> -	struct fsmap_head	*head)
> -{
> -	head->fmh_keys[0] = head->fmh_recs[head->fmh_entries - 1];
> -}
> -
> -/*	fmh_iflags values - set by XFS_IOC_GETFSMAP caller in the header. */
> -/* no flags defined yet */
> -#define FMH_IF_VALID		0
> -
> -/*	fmh_oflags values - returned in the header segment only. */
> -#define FMH_OF_DEV_T		0x1	/* fmr_device values will be dev_t */
> -
> -/*	fmr_flags values - returned for each non-header segment */
> -#define FMR_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
> -#define FMR_OF_ATTR_FORK	0x2	/* segment = attribute fork */
> -#define FMR_OF_EXTENT_MAP	0x4	/* segment = extent map */
> -#define FMR_OF_SHARED		0x8	/* segment = shared with another file */
> -#define FMR_OF_SPECIAL_OWNER	0x10	/* owner is a special value */
> -#define FMR_OF_LAST		0x20	/* segment is the last in the FS */
> -
> -/* Each FS gets to define its own special owner codes. */
> -#define FMR_OWNER(type, code)	(((__u64)type << 32) | \
> -				 ((__u64)code & 0xFFFFFFFFULL))
> -#define FMR_OWNER_TYPE(owner)	((__u32)((__u64)owner >> 32))
> -#define FMR_OWNER_CODE(owner)	((__u32)(((__u64)owner & 0xFFFFFFFFULL)))
> -#define FMR_OWN_FREE		FMR_OWNER(0, 1) /* free space */
> -#define FMR_OWN_UNKNOWN		FMR_OWNER(0, 2) /* unknown owner */
> -#define FMR_OWN_METADATA	FMR_OWNER(0, 3) /* metadata */
> -
> -#define FS_IOC_GETFSMAP		_IOWR('X', 59, struct fsmap_head)
> -
> -#define HAVE_GETFSMAP
> -#endif /* HAVE_GETFSMAP */
> -
>  #ifndef HAVE_MAP_SYNC
>  #define MAP_SYNC 0
>  #define MAP_SHARED_VALIDATE 0
> diff --git a/io/fsmap.c b/io/fsmap.c
> index f540a7c0..9ff36bf4 100644
> --- a/io/fsmap.c
> +++ b/io/fsmap.c
> @@ -10,6 +10,7 @@
>  #include "io.h"
>  #include "input.h"
>  #include "libfrog/fsgeom.h"
> +#include "libfrog/fsmap.h"
>  
>  static cmdinfo_t	fsmap_cmd;
>  static dev_t		xfs_data_dev;
> diff --git a/io/io.h b/io/io.h
> index 49db902f..39fb5878 100644
> --- a/io/io.h
> +++ b/io/io.h
> @@ -167,12 +167,7 @@ extern void		readdir_init(void);
>  extern void		reflink_init(void);
>  
>  extern void		cowextsize_init(void);
> -
> -#ifdef HAVE_GETFSMAP
>  extern void		fsmap_init(void);
> -#else
> -# define fsmap_init()	do { } while (0)
> -#endif
>  
>  #ifdef HAVE_DEVMAPPER
>  extern void		log_writes_init(void);
> diff --git a/libfrog/Makefile b/libfrog/Makefile
> index 01107082..d6044455 100644
> --- a/libfrog/Makefile
> +++ b/libfrog/Makefile
> @@ -40,6 +40,7 @@ crc32cselftest.h \
>  crc32defs.h \
>  crc32table.h \
>  fsgeom.h \
> +fsmap.h \
>  logging.h \
>  paths.h \
>  projects.h \
> diff --git a/libfrog/fsmap.h b/libfrog/fsmap.h
> new file mode 100644
> index 00000000..dc290962
> --- /dev/null
> +++ b/libfrog/fsmap.h
> @@ -0,0 +1,117 @@
> +#ifdef HAVE_GETFSMAP
> +# include <linux/fsmap.h>
> +#endif
> +
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * FS_IOC_GETFSMAP ioctl infrastructure.
> + *
> + * Copyright (C) 2017 Oracle.  All Rights Reserved.
> + *
> + * Author: Darrick J. Wong <djwong@kernel.org>
> + */
> +#ifndef _LINUX_FSMAP_H
> +#define _LINUX_FSMAP_H
> +
> +#include <linux/types.h>
> +
> +/*
> + *	Structure for FS_IOC_GETFSMAP.
> + *
> + *	The memory layout for this call are the scalar values defined in
> + *	struct fsmap_head, followed by two struct fsmap that describe
> + *	the lower and upper bound of mappings to return, followed by an
> + *	array of struct fsmap mappings.
> + *
> + *	fmh_iflags control the output of the call, whereas fmh_oflags report
> + *	on the overall record output.  fmh_count should be set to the
> + *	length of the fmh_recs array, and fmh_entries will be set to the
> + *	number of entries filled out during each call.  If fmh_count is
> + *	zero, the number of reverse mappings will be returned in
> + *	fmh_entries, though no mappings will be returned.  fmh_reserved
> + *	must be set to zero.
> + *
> + *	The two elements in the fmh_keys array are used to constrain the
> + *	output.  The first element in the array should represent the
> + *	lowest disk mapping ("low key") that the user wants to learn
> + *	about.  If this value is all zeroes, the filesystem will return
> + *	the first entry it knows about.  For a subsequent call, the
> + *	contents of fsmap_head.fmh_recs[fsmap_head.fmh_count - 1] should be
> + *	copied into fmh_keys[0] to have the kernel start where it left off.
> + *
> + *	The second element in the fmh_keys array should represent the
> + *	highest disk mapping ("high key") that the user wants to learn
> + *	about.  If this value is all ones, the filesystem will not stop
> + *	until it runs out of mapping to return or runs out of space in
> + *	fmh_recs.
> + *
> + *	fmr_device can be either a 32-bit cookie representing a device, or
> + *	a 32-bit dev_t if the FMH_OF_DEV_T flag is set.  fmr_physical,
> + *	fmr_offset, and fmr_length are expressed in units of bytes.
> + *	fmr_owner is either an inode number, or a special value if
> + *	FMR_OF_SPECIAL_OWNER is set in fmr_flags.
> + */
> +struct fsmap {
> +	__u32		fmr_device;	/* device id */
> +	__u32		fmr_flags;	/* mapping flags */
> +	__u64		fmr_physical;	/* device offset of segment */
> +	__u64		fmr_owner;	/* owner id */
> +	__u64		fmr_offset;	/* file offset of segment */
> +	__u64		fmr_length;	/* length of segment */
> +	__u64		fmr_reserved[3];	/* must be zero */
> +};
> +
> +struct fsmap_head {
> +	__u32		fmh_iflags;	/* control flags */
> +	__u32		fmh_oflags;	/* output flags */
> +	__u32		fmh_count;	/* # of entries in array incl. input */
> +	__u32		fmh_entries;	/* # of entries filled in (output). */
> +	__u64		fmh_reserved[6];	/* must be zero */
> +
> +	struct fsmap	fmh_keys[2];	/* low and high keys for the mapping search */
> +	struct fsmap	fmh_recs[];	/* returned records */
> +};
> +
> +/* Size of an fsmap_head with room for nr records. */
> +static __inline__ size_t
> +fsmap_sizeof(
> +	unsigned int	nr)
> +{
> +	return sizeof(struct fsmap_head) + nr * sizeof(struct fsmap);
> +}
> +
> +/* Start the next fsmap query at the end of the current query results. */
> +static __inline__ void
> +fsmap_advance(
> +	struct fsmap_head	*head)
> +{
> +	head->fmh_keys[0] = head->fmh_recs[head->fmh_entries - 1];
> +}
> +
> +/*	fmh_iflags values - set by FS_IOC_GETFSMAP caller in the header. */
> +/* no flags defined yet */
> +#define FMH_IF_VALID		0
> +
> +/*	fmh_oflags values - returned in the header segment only. */
> +#define FMH_OF_DEV_T		0x1	/* fmr_device values will be dev_t */
> +
> +/*	fmr_flags values - returned for each non-header segment */
> +#define FMR_OF_PREALLOC		0x1	/* segment = unwritten pre-allocation */
> +#define FMR_OF_ATTR_FORK	0x2	/* segment = attribute fork */
> +#define FMR_OF_EXTENT_MAP	0x4	/* segment = extent map */
> +#define FMR_OF_SHARED		0x8	/* segment = shared with another file */
> +#define FMR_OF_SPECIAL_OWNER	0x10	/* owner is a special value */
> +#define FMR_OF_LAST		0x20	/* segment is the last in the dataset */
> +
> +/* Each FS gets to define its own special owner codes. */
> +#define FMR_OWNER(type, code)	(((__u64)type << 32) | \
> +				 ((__u64)code & 0xFFFFFFFFULL))
> +#define FMR_OWNER_TYPE(owner)	((__u32)((__u64)owner >> 32))
> +#define FMR_OWNER_CODE(owner)	((__u32)(((__u64)owner & 0xFFFFFFFFULL)))
> +#define FMR_OWN_FREE		FMR_OWNER(0, 1) /* free space */
> +#define FMR_OWN_UNKNOWN		FMR_OWNER(0, 2) /* unknown owner */
> +#define FMR_OWN_METADATA	FMR_OWNER(0, 3) /* metadata */
> +
> +#define FS_IOC_GETFSMAP		_IOWR('X', 59, struct fsmap_head)
> +
> +#endif /* _LINUX_FSMAP_H */
> diff --git a/scrub/phase6.c b/scrub/phase6.c
> index 87828b60..dd42b66c 100644
> --- a/scrub/phase6.c
> +++ b/scrub/phase6.c
> @@ -10,6 +10,7 @@
>  #include "handle.h"
>  #include "libfrog/paths.h"
>  #include "libfrog/workqueue.h"
> +#include "libfrog/fsmap.h"
>  #include "xfs_scrub.h"
>  #include "common.h"
>  #include "libfrog/bitmap.h"
> diff --git a/scrub/phase7.c b/scrub/phase7.c
> index bc652ab6..e24906d1 100644
> --- a/scrub/phase7.c
> +++ b/scrub/phase7.c
> @@ -9,6 +9,7 @@
>  #include <sys/statvfs.h>
>  #include "libfrog/paths.h"
>  #include "libfrog/ptvar.h"
> +#include "libfrog/fsmap.h"
>  #include "list.h"
>  #include "xfs_scrub.h"
>  #include "common.h"
> diff --git a/scrub/spacemap.c b/scrub/spacemap.c
> index a5508d56..b7f17e57 100644
> --- a/scrub/spacemap.c
> +++ b/scrub/spacemap.c
> @@ -10,6 +10,7 @@
>  #include <sys/statvfs.h>
>  #include "libfrog/workqueue.h"
>  #include "libfrog/paths.h"
> +#include "libfrog/fsmap.h"
>  #include "xfs_scrub.h"
>  #include "common.h"
>  #include "spacemap.h"
> diff --git a/spaceman/freesp.c b/spaceman/freesp.c
> index de301c19..4e46ab26 100644
> --- a/spaceman/freesp.c
> +++ b/spaceman/freesp.c
> @@ -9,6 +9,7 @@
>  #include "libxfs.h"
>  #include <linux/fiemap.h>
>  #include "libfrog/fsgeom.h"
> +#include "libfrog/fsmap.h"
>  #include "command.h"
>  #include "init.h"
>  #include "libfrog/paths.h"
> diff --git a/spaceman/space.h b/spaceman/space.h
> index 723209ed..a8055535 100644
> --- a/spaceman/space.h
> +++ b/spaceman/space.h
> @@ -26,11 +26,7 @@ extern void	help_init(void);
>  extern void	prealloc_init(void);
>  extern void	quit_init(void);
>  extern void	trim_init(void);
> -#ifdef HAVE_GETFSMAP
>  extern void	freesp_init(void);
> -#else
> -# define freesp_init()	do { } while (0)
> -#endif
>  extern void	info_init(void);
>  extern void	health_init(void);
>  
> 
