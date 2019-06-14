Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1364E46C95
	for <lists+linux-xfs@lfdr.de>; Sat, 15 Jun 2019 01:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbfFNXCF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Jun 2019 19:02:05 -0400
Received: from sandeen.net ([63.231.237.45]:59566 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbfFNXCF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jun 2019 19:02:05 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9F0E6182F2;
        Fri, 14 Jun 2019 18:01:29 -0500 (CDT)
Subject: Re: [PATCH 3/9] libxfs: break out the bulkstat manpage
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
 <155993575992.2343530.15511255417353913747.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <bc6c48c9-fce3-d377-5f0c-843e5c456f5f@sandeen.net>
Date:   Fri, 14 Jun 2019 18:02:03 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <155993575992.2343530.15511255417353913747.stgit@magnolia>
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
> Break out the bulkstat ioctl into a separate manpage so that we can
> document how it works.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man/man2/ioctl_xfs_fsbulkstat.2 |  212 +++++++++++++++++++++++++++++++++++++++
>  man/man3/xfsctl.3               |   87 +---------------
>  2 files changed, 219 insertions(+), 80 deletions(-)
>  create mode 100644 man/man2/ioctl_xfs_fsbulkstat.2
> 
> 
> diff --git a/man/man2/ioctl_xfs_fsbulkstat.2 b/man/man2/ioctl_xfs_fsbulkstat.2
> new file mode 100644
> index 00000000..8908631a
> --- /dev/null
> +++ b/man/man2/ioctl_xfs_fsbulkstat.2
> @@ -0,0 +1,212 @@
> +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> +.\"
> +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> +.\" SPDX-License-Identifier: GPL-2.0+
> +.\" %%%LICENSE_END
> +.TH IOCTL-XFS-FSBULKSTAT 2 2019-04-11 "XFS"
> +.SH NAME
> +ioctl_xfs_fsbulkstat \- query information for a batch of XFS inodes
> +.SH SYNOPSIS
> +.br
> +.B #include <xfs/xfs_fs.h>
> +.PP
> +.BI "int ioctl(int " fd ", XFS_IOC_FSBULKSTAT, struct xfs_fsop_bulkreq *" arg );
> +.PP

.br   *shrug* maybe not, seems like you have a plan here ;)

> +.BI "int ioctl(int " fd ", XFS_IOC_FSBULKSTAT_SINGLE, struct xfs_fsop_bulkreq *" arg );
> +.SH DESCRIPTION
> +Query stat information for a bunch of XFS inodes.

s/bunch/group/ or s/a bunch of//

> +These ioctls use
> +.B struct xfs_fsop_bulkreq
> +to set up a bulk transfer with the kernel:
> +.PP
> +.in +4n
> +.nf
> +struct xfs_fsop_bulkreq {
> +	__u64             *lastip;
> +	__s32             count;
> +	void              *ubuffer;
> +	__s32             *ocount;
> +};
> +.fi
> +.in
> +.PP
> +.I lastip
> +points to a value that will receive the number of the "last inode".

can it be NULL?

> +For
> +.BR FSBULKSTAT ,
> +this should be set to one less than the number of the first inode for which the
> +caller wants information, or zero to start with the first inode in the
> +filesystem.
> +For
> +.BR FSBULKSTAT_SINGLE ,
> +this should be set to the number of the inode for which the caller wants
> +information.
> +After the call, this value will be set to the number of the last inode for
> +which information was supplied.
> +This field will not be updated if
> +.I ocount
> +is NULL.
> +.PP
> +.I count
> +is the number of inodes to examine.

and the size of the area pointed to by *ubuffer?
(I guess that's covered in the *ubuffer description)

> +This value must be set to 1 for
> +.BR FSBULKSTAT_SINGLE .
> +.PP
> +.I ocount
> +points to a value that will receive the number of records returned.
> +If this value is NULL, then neither
> +.I ocount
> +nor
> +.I lastip
> +will be updated.
> +.PP
> +.I ubuffer
> +points to a memory buffer where information will be copied.

into which inode information will be copied?

> +This buffer must be an array of
> +.B struct xfs_bstat
> +which is described below.
> +The array must have at least
> +.I count
> +elements.
> +.PP
> +.in +4n
> +.nf
> +struct xfs_bstat {
> +	__u64             bs_ino;
> +	__u16             bs_mode;
> +	__u16             bs_nlink;
> +	__u32             bs_uid;
> +	__u32             bs_gid;
> +	__u32             bs_rdev;
> +	__s32             bs_blksize;
> +	__s64             bs_size;
> +	struct xfs_bstime bs_atime;
> +	struct xfs_bstime bs_mtime;
> +	struct xfs_bstime bs_ctime;
> +	int64_t           bs_blocks;
> +	__u32             bs_xflags;
> +	__s32             bs_extsize;
> +	__s32             bs_extents;
> +	__u32             bs_gen;
> +	__u16             bs_projid_lo;
> +	__u16             bs_forkoff;
> +	__u16             bs_projid_hi;
> +	unsigned char     bs_pad[6];
> +	__u32             bs_cowextsize;
> +	__u32             bs_dmevmask;
> +	__u16             bs_dmstate;
> +	__u16             bs_aextents;
> +};
> +.fi
> +.in
> +.PP

The structure members are as follows:

> +.I bs_ino
> +is the number of this inode record.

is the inode number for this record

> +.PP
> +.I bs_mode
> +is the file type and mode.
> +.PP
> +.I bs_nlink
> +is the number of hard links to this inode.
> +.PP
> +.I bs_uid
> +is the user id.
> +.PP
> +.I bs_gid
> +is the group id.
> +.PP
> +.I bs_rdev
> +is the encoded device id if this is a special file.
> +.PP
> +.I bs_blksize
> +is the size of a data block for this file, in units of bytes.
> +.PP
> +.I bs_size
> +is the size of the file, in bytes.
> +.PP
> +.I bs_atime
> +is the last time this file was accessed.
> +.PP
> +.I bs_mtime
> +is the last time the contents of this file were modified.
> +.PP
> +.I bs_ctime
> +is the last time this inode record was modified.
> +.PP
> +.I bs_blocks
> +is the number of filesystem blocks allocated to this file, including metadata.
> +.PP
> +.I bs_xflags
> +tell us what extended flags are set this inode.

contains the extended flags which are set in this inode

> +These flags are the same values as those set in the
> +.I fsx_xflags
> +field of
> +.BR "struct fsxattr" ;
> +please see the
> +.BR ioctl_fsgetxattr (2)
> +manpage for more information.

I dig it but you made an ioctl_xfs_fsgetxattr(2) manpage...

(I forget, how do we alias manpages?)

also this should go in SEE ALSO

> +
> +.PD 1
> +.PP
> +.I bs_extsize
> +is the extent size hint for this file, in bytes.
> +.PP
> +.I bs_extents
> +is the number of storage space extents associated with this file's data.

storage space extents sounds odd...

is the number of data extents in this file.

> +.PP
> +.I bs_gen
> +is the generation number of the inode record.
> +.PP
> +.I bs_projid_lo
> +is the lower 16-bits of the project id.
> +.PP
> +.I bs_forkoff
> +is the offset of the attribute fork in the inode record, in bytes.
> +.PP
> +.I bs_projid_hi
> +is the upper 16-bits of the project id.
> +.PP
> +.I bs_pad[6]
> +is zeroed.
> +.PP
> +.I bs_cowextsize
> +is the Copy on Write extent size hint for this file, in bytes.
> +.PP
> +.I bs_dmevmask
> +is unused on Linux.
> +.PP
> +.I bs_dmstate
> +is unused on Linux.
> +.PP
> +.I bs_aextents
> +is the number of storage space extents associated with this file's extended
> +attributes.

is the number of extended attribute extents in this file?  *shrug*

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
> +.B EINVAL
> +One of the arguments was not valid.
> +.TP
> +.B EIO
> +An I/O error was encountered while performing the query.
> +.TP
> +.B ENOMEM
> +There was insufficient memory to perform the query.
> +.SH CONFORMING TO
> +This API is specific to XFS filesystem on the Linux kernel.
> +.SH SEE ALSO
> +.BR ioctl (2)
> diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> index 1237eac6..94a6ad4b 100644
> --- a/man/man3/xfsctl.3
> +++ b/man/man3/xfsctl.3
> @@ -399,92 +399,18 @@ An output
>  .B ocount
>  value of zero means that the inode table has been exhausted.
>  
> -.TP
> -.B XFS_IOC_FSBULKSTAT
> -This interface is used to extract inode information (stat
> -information) "in bulk" from a filesystem.  It is intended to
> -be called iteratively, to obtain information about the entire
> -set of inodes in a filesystem.
> -The information is passed in and out via a structure of type
> -.B xfs_fsop_bulkreq_t
> -pointed to by the final argument.
> -.B lastip
> -is a pointer to a variable containing the last inode number returned,
> -initially it should be zero.
> -.B icount
> -indicates the size of the array of structures specified by
> -.B ubuffer.
> -.B ubuffer
> -is the address of an array of structures of type
> -.BR xfs_bstat_t .
> -Many of the elements in the structure are the same as for the stat
> -structure.
> -The structure has the following elements:
> -.B bs_ino
> -(inode number),
> -.B bs_mode
> -(type and mode),
> -.B bs_nlink
> -(number of links),
> -.B bs_uid
> -(user id),
> -.B bs_gid
> -(group id),
> -.B bs_rdev
> -(device value),
> -.B bs_blksize
> -(block size of the filesystem),
> -.B bs_size
> -(file size in bytes),
> -.B bs_atime
> -(access time),
> -.B bs_mtime
> -(modify time),
> -.B bs_ctime
> -(inode change time),
> -.B bs_blocks
> -(number of blocks used by the file),
> -.B bs_xflags
> -(extended flags),
> -.B bs_extsize
> -(extent size),
> -.B bs_extents
> -(number of extents),
> -.B bs_gen
> -(generation count),
> -.B bs_projid_lo
> -(project id - low word),
> -.B bs_projid_hi
> -(project id - high word, used when projid32bit feature is enabled),
> -.B bs_dmevmask
> -(DMIG event mask),
> -.B bs_dmstate
> -(DMIG state information), and
> -.B bs_aextents
> -(attribute extent count).
> -.B ocount
> -is a pointer to a count of returned values, filled in by the call.
> -An output
> -.B ocount
> -value of zero means that the inode table has been exhausted.
> -
> -.TP
> -.B XFS_IOC_FSBULKSTAT_SINGLE
> -This interface is a variant of the
> -.B XFS_IOC_FSBULKSTAT
> -interface, used to obtain information about a single inode.
> -for an open file in the filesystem of interest.
> -The same structure is used to pass information in and out of
> -the kernel, except no output count parameter is used (should
> -be initialized to zero).
> -An error is returned if the inode number is invalid.
> -
>  .TP
>  .B XFS_IOC_FSGEOMETRY
>  See
>  .BR ioctl_xfs_fsop_geometry (2)
>  for more information.
>  
> +.TP
> +.BR XFS_IOC_FSBULKSTAT " or " XFS_IOC_FSBULKSTAT_SINGLE
> +See
> +.BR ioctl_xfs_fsbulkstat (2)
> +for more information.
> +
>  .PP
>  .nf
>  .B XFS_IOC_THAW
> @@ -509,6 +435,7 @@ as they are not of general use to applications.
>  .SH SEE ALSO
>  .BR ioctl_xfs_fsgetxattr (2),
>  .BR ioctl_xfs_fsop_geometry (2),
> +.BR ioctl_xfs_fsbulkstat (2),
>  .BR fstatfs (2),
>  .BR statfs (2),
>  .BR xfs (5),
> 
