Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A727846C2C
	for <lists+linux-xfs@lfdr.de>; Sat, 15 Jun 2019 00:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfFNWAb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Jun 2019 18:00:31 -0400
Received: from sandeen.net ([63.231.237.45]:54806 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbfFNWAb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jun 2019 18:00:31 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1465F182F2;
        Fri, 14 Jun 2019 16:59:56 -0500 (CDT)
Subject: Re: [PATCH 2/9] libxfs: break out the fsop geometry manpage
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
 <155993575303.2343530.6107806014092743035.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <f8d67b57-33ed-7e2a-ffc3-4b862811e845@sandeen.net>
Date:   Fri, 14 Jun 2019 17:00:30 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <155993575303.2343530.6107806014092743035.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/7/19 2:29 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Break out the fs geometry ioctl into a separate manpage so that we can
> document how it works.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man/man2/ioctl_xfs_fsop_geometry.2 |  214 ++++++++++++++++++++++++++++++++++++
>  man/man3/xfsctl.3                  |   11 +-
>  2 files changed, 221 insertions(+), 4 deletions(-)
>  create mode 100644 man/man2/ioctl_xfs_fsop_geometry.2
> 
> 
> diff --git a/man/man2/ioctl_xfs_fsop_geometry.2 b/man/man2/ioctl_xfs_fsop_geometry.2
> new file mode 100644
> index 00000000..4045e03b
> --- /dev/null
> +++ b/man/man2/ioctl_xfs_fsop_geometry.2
> @@ -0,0 +1,214 @@
> +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> +.\"
> +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> +.\" SPDX-License-Identifier: GPL-2.0+
> +.\" %%%LICENSE_END
> +.TH IOCTL-XFS-FSOP-GEOMETRY 2 2019-04-11 "XFS"
> +.SH NAME
> +ioctl_xfs_fsop_geometry \- report XFS filesystem shape
> +.SH SYNOPSIS
> +.br
> +.B #include <xfs/xfs_fs.h>
> +.PP
> +.BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY, struct xfs_fsop_geometry *" arg );
> +.PP

ditto on the .br?

also xfs_fsop_geometry isn't a thing, is it?  xfs_fsop_geom?

> +.BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY_V1, struct xfs_fsop_geometry_v1 *" arg );

and xfs_fsop_geom_v1

> +.SH DESCRIPTION
> +Report the storage space parameters that influence allocation decisions in
> +this XFS filesystem.
> +This information is conveyed in a structure of the following form:
> +.PP
> +.in +4n
> +.nf
> +struct xfs_fsop_geom {
> +	__u32         blocksize;
> +	__u32         rtextsize;
> +	__u32         agblocks;
> +	__u32         agcount;
> +	__u32         logblocks;
> +	__u32         sectsize;
> +	__u32         inodesize;
> +	__u32         imaxpct;
> +	__u64         datablocks;
> +	__u64         rtblocks;
> +	__u64         rtextents;
> +	__u64         logstart;
> +	unsigned char uuid[16];
> +	__u32         sunit;
> +	__u32         swidth;
> +	__s32         version;
> +	__u32         flags;
> +	__u32         logsectsize;
> +	__u32         rtsectsize;
> +	__u32         dirblocksize;
> +	/* struct xfs_fsop_geom_v1 stops here. */
> +
> +	__u32         logsunit;
> +};
> +.fi
> +.in
> +.PP
> +.I blocksize
> +is the size of a fundamental filesystem block, in bytes.
> +.PP
> +.I rtextsize
> +is the size of an extent on the realtime volume, in bytes.
> +.PP
> +.I agblocks
> +is the size of an allocation group, in units of filesystem blocks.
> +.PP
> +.I agcount
> +is the number of allocation groups in the filesystem.
> +.PP
> +.I logblocks
> +is the size of the log, in units of filesystem blocks.
> +.PP
> +.I sectsize
> +is the smallest amount of data that can be written to the data device
> +atomically, in bytes.
> +.PP
> +.I inodesize
> +is the size of an inode record, in bytes.
> +.PP
> +.I imaxpct
> +is the maximum percentage of the filesystem that can be allocated to inode
> +record blocks.
> +.PP
> +.I datablocks
> +is the size of the data device, in units of filesystem blocks.
> +.PP
> +.I rtblocks
> +is the size of the realtime device, in units of filesystem blocks.
> +.PP
> +.I rtextents
> +is the number of extents that can be allocated on the realtime device.
> +This ought to be
> +.RB "( " rtblocks " * " blocksize " ) / " rtextsize .

ought to be?  I'm not sure what that means?

> +.PP
> +.I logstart
> +tells the start of the log, in units of filesystem blocks.

contains?

> +If the filesystem has an external log, this will be zero.
> +.PP
> +.I uuid
> +is the universal unique identifier of the filesystem.
> +.PP
> +.I sunit
> +is what the filesystem has been told is the size of a RAID stripe unit on the
> +underlying data device, in filesystem blocks.
> +.PP
> +.I swidth
> +is what the filesystem has been told is the width of a RAID stripe on the
> +underlying data device, in units of RAID stripe units.
> +.PP
> +.I version
> +is the version of this structure.
> +This value will be XFS_FSOP_GEOM_VERSION.
> +.PP
> +.I flags
> +tell us what features are enabled on the filesystem.
> +This field can be any combination of the following:
> +.RS 0.4i
> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_ATTR
> +Extended attributes are present.
> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_NLINK
> +This filesystem supports up to 2^32 links.

and if not it supports what?

> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_QUOTA
> +Quotas are enabled.
> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_IALIGN
> +Inodes are aligned for better performance.

aligned to ____ ? (worth trying to explain?)

> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_DALIGN
> +Data blocks are aligned for better performance.
> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_SHARED
> +Unused.
> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_EXTFLG
> +Filesystem supports unwritten extents.
> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_DIRV2
> +Directories maintain free space data for better performance.

I don't remember all the v1->v2 differences but in other places
you simply say "contains version 2 format" or whatnot, so that might
suffice here.  Also can't do v1 since forever, anyway.  ;)

> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_LOGV2
> +Log uses the V2 format.
> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_SECTOR
> +The log device has a sector size larger than 512 bytes.
> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_ATTR2
> +Filesystem contains V2 extended attributes.
> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_PROJID32
> +Project IDs can be as large as 2^32.

otherwise 2^16?

> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_DIRV2CI
> +Case-insensitive lookups are supported on directories.
> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_LAZYSB
> +On-disk superblock counters are updated only at unmount time.
> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_V5SB
> +Metadata blocks are self describing and contain checksums.
> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_FTYPE
> +Directories cache inode types in directory entries.

s/cache/contain/

> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_FINOBT
> +Filesystem maintains an index of free inodes.
> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_SPINODES
> +Filesystem tries harder to allocate inodes when free space is fragmented.

Filesystem may allocate discontinuous inode chunks when free space is fragmented?

> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_RMAPBT
> +Filesystem stores reverse mappings of blocks to owners.
> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_REFLINK
> +Filesystem supports sharing blocks.

between inodes?

> +.RE
> +
> +.PD 1
> +.PP
> +.I logsectsize
> +is the smallest amount of data that can be written to the log device atomically,
> +in bytes.

oh hello, we're back to the structure members again!

I wonder if it'd be better to move the flag details down below all the structure descriptions.

> +.PP
> +.I rtsectsize
> +is the smallest amount of data that can be written to the realtime device
> +atomically, in bytes.
> +.PP
> +.I dirblocksize
> +is the size of directory blocks, in bytes.
> +.PP
> +.I logsunit
> +is what the filesystem has been told is the size of a RAID stripe unit on the
> +underlying log device, in filesystem blocks.
> +This field is meaningful only if the flag
> +.B  XFS_FSOP_GEOM_FLAGS_LOGV2
> +is set.
> +.SH RETURN VALUE
> +On error, \-1 is returned, and
> +.I errno
> +is set to indicate the error.
> +.PP
> +.SH ERRORS
> +Error codes can be one of, but are not limited to, the following:
> +.TP
> +.B EFAULT
> +The kernel was not able to copy into the userspace buffer.
> +.TP
> +.B EFSBADCRC
> +Metadata checksum validation failed while performing the query.
> +.TP
> +.B EFSCORRUPTED
> +Metadata corruption was encountered while performing the query.
> +.TP
> +.B EIO
> +An I/O error was encountered while performing the query.
> +.SH CONFORMING TO
> +This API is specific to XFS filesystem on the Linux kernel.
> +.SH SEE ALSO
> +.BR ioctl (2)
> diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> index 2992b5be..1237eac6 100644
> --- a/man/man3/xfsctl.3
> +++ b/man/man3/xfsctl.3
> @@ -479,6 +479,12 @@ the kernel, except no output count parameter is used (should
>  be initialized to zero).
>  An error is returned if the inode number is invalid.
>  
> +.TP
> +.B XFS_IOC_FSGEOMETRY
> +See
> +.BR ioctl_xfs_fsop_geometry (2)
> +for more information.
> +
>  .PP
>  .nf
>  .B XFS_IOC_THAW
> @@ -494,10 +500,6 @@ An error is returned if the inode number is invalid.
>  These interfaces are used to implement various filesystem internal
>  operations on XFS filesystems.
>  For
> -.B XFS_IOC_FSGEOMETRY
> -(get filesystem mkfs time information), the output structure is of type
> -.BR struct xfs_fsop_geom .
> -For
>  .B XFS_FS_COUNTS
>  (get filesystem dynamic global information), the output structure is of type
>  .BR xfs_fsop_counts_t .
> @@ -506,6 +508,7 @@ as they are not of general use to applications.
>  
>  .SH SEE ALSO
>  .BR ioctl_xfs_fsgetxattr (2),
> +.BR ioctl_xfs_fsop_geometry (2),
>  .BR fstatfs (2),
>  .BR statfs (2),
>  .BR xfs (5),
> 
