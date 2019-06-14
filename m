Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA80946BB0
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Jun 2019 23:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfFNVRM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Jun 2019 17:17:12 -0400
Received: from sandeen.net ([63.231.237.45]:51618 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbfFNVRL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jun 2019 17:17:11 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 10435147566;
        Fri, 14 Jun 2019 16:16:36 -0500 (CDT)
Subject: Re: [PATCH 1/9] libxfs: break out the GETXATTR/SETXATTR manpage
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
 <155993574662.2343530.11024375240678275350.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <1def4f4f-e938-76e2-2583-a07fc18b3ed8@sandeen.net>
Date:   Fri, 14 Jun 2019 16:17:10 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <155993574662.2343530.11024375240678275350.stgit@magnolia>
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
> Break out the xfs file attribute get and set ioctls into a separate
> manpage to reduce clutter in xfsctl.

<comes up for air>

Now that we've uh, hoisted it to be a generic vfs interface,
FS_IOC_FSGETXATTR, shouldn't we be documenting it as that instead
of the (old) xfs variant?

(honestly that'd be mostly just search and replace for this patch)

Except of course XFS_IOC_FSGETXATTRA has no vfs variant.  :/

I also wonder if FS_IOC_SETFLAGS should be mentioned, and/or a
SEE_ALSO because some of the functionality overlaps?

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man/man2/ioctl_xfs_fsgetxattr.2 |  219 +++++++++++++++++++++++++++++++++++++++
>  man/man3/xfsctl.3               |  159 +---------------------------
>  2 files changed, 227 insertions(+), 151 deletions(-)
>  create mode 100644 man/man2/ioctl_xfs_fsgetxattr.2
> 
> 
> diff --git a/man/man2/ioctl_xfs_fsgetxattr.2 b/man/man2/ioctl_xfs_fsgetxattr.2
> new file mode 100644
> index 00000000..17276dec
> --- /dev/null
> +++ b/man/man2/ioctl_xfs_fsgetxattr.2
> @@ -0,0 +1,219 @@
> +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> +.\" SPDX-License-Identifier: GPL-2.0+
> +.\" %%%LICENSE_END
> +.TH IOCTL-XFS-FSGETXATTR 2 2019-04-16 "XFS"
> +.SH NAME
> +ioctl_xfs_fsgetxattr \- query information for an open file
> +.SH SYNOPSIS
> +.br
> +.B #include <linux/fs.h>
> +.PP
> +.BI "int ioctl(int " fd ", XFS_IOC_FSGETXATTR, struct fsxattr *" arg );
> +.PP

maybe

.br

here to keep it more compact?  Unless there's a manpage style I'm unaware
of?

> +.BI "int ioctl(int " fd ", XFS_IOC_FSGETXATTRA, struct fsxattr *" arg );
> +.PP
> +.BI "int ioctl(int " fd ", XFS_IOC_FSSETXATTR, struct fsxattr *" arg );
> +.SH DESCRIPTION
> +Query or set additional attributes associated with files in various file
> +systems.

(it was the "various filesystems" which caught my eye and reminded me to
ask the first question)

> +The attributes are conveyed in a structure of the form:
> +.PP
> +.in +4n
> +.nf
> +struct fsxattr {
> +	__u32         fsx_xflags;
> +	__u32         fsx_extsize;
> +	__u32         fsx_nextents;
> +	__u32         fsx_projid;
> +	__u32         fsx_cowextsize;
> +	unsigned char fsx_pad[8];
> +};
> +.fi
> +.in
> +.PP
> +.I fsx_xflags
> +are extended flags that apply to this file.
> +This field can be a combination of the following:
> +
> +.RS 0.4i
> +.TP
> +.B FS_XFLAG_REALTIME
> +The file is a realtime file.
> +This bit can only be changed when the file is empty.
> +.TP
> +.B FS_XFLAG_PREALLOC
> +The file has preallocated space.
> +.TP
> +.B FS_XFLAG_IMMUTABLE
> +The file is immutable - it cannot be modified, deleted or renamed,
> +no link can be created to this file and no data can be written to the
> +file.
> +Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
> +capability can set or clear this flag.
> +If this flag is set before a
> +.B FS_IOC_SETXATTR

(and here you do refer to the non-XFS variant)

> +call and would not be cleared by the call, then no other attributes can be
> +changed and
> +.B EPERM
> +will be returned.
> +.TP
> +.B FS_XFLAG_APPEND
> +The file is append-only - it can only be open in append mode for
> +writing.
> +Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
> +capability can set or clear this flag.
> +.TP
> +.B FS_XFLAG_SYNC
> +All writes to the file are synchronous.
> +.TP
> +.B FS_XFLAG_NOATIME
> +When the file is accessed, its atime record is not modified.
> +.TP
> +.B FS_XFLAG_NODUMP
> +The file should be skipped by backup utilities.
> +.TP
> +.B FS_XFLAG_RTINHERIT
> +Realtime inheritance bit - new files created in the directory
> +will be automatically realtime, and new directories created in
> +the directory will inherit the inheritance bit.
> +.TP
> +.B FS_XFLAG_PROJINHERIT
> +Project inheritance bit - new files and directories created in
> +the directory will inherit the parents project ID.

s/parents/parent directory's/

> +New directories also inherit the project inheritance bit.

also may as well keep the text for RTINHERIT and PROJINHERIT
identical other than the bit name/description.

> +.TP
> +.B FS_XFLAG_NOSYMLINKS
> +Can only be set on a directory and disallows creation of
> +symbolic links in that directory.
> +.TP
> +.B FS_XFLAG_EXTSIZE
> +Extent size bit - if a basic extent size value is set on the file
> +then the allocator will allocate in multiples of the set size for
> +this file (see
> +.B fsx_extsize
> +below).
> +This flag can only be set on a file if it is empty.
> +.TP
> +.B FS_XFLAG_EXTSZINHERIT
> +Extent size inheritance bit - new files and directories created in
> +the directory will inherit the parents basic extent size value (see

s/parents/parent directory's/

again probably keep text same as RTINHERIT/PROJINHERIT modulo bit name.

> +.B fsx_extsize
> +below).
> +Can only be set on a directory.

(i.e. the others "can only be set on a directory" too right?)

> +.TP
> +.B FS_XFLAG_NODEFRAG
> +No defragment file bit - the file should be skipped during a defragmentation
> +operation. When applied to a directory, new files and directories created will
> +inherit the no\-defrag bit.
> +.TP
> +.B FS_XFLAG_FILESTREAM
> +Filestream allocator bit - allows a directory to reserve an allocation group
> +for exclusive use by files created within that directory.
> +Files being written in other directories will not use the same allocation group
> +and so files within different directories will not interleave extents on disk.
> +The reservation is only active while files are being created and written into
> +the directory.
> +.TP
> +.B FS_XFLAG_DAX
> +If the filesystem lives on directly accessible persistent memory, reads and
> +writes to this file will go straight to the persistent memory, bypassing the
> +page cache.
> +A file cannot be reflinked and have the
> +.BR FS_XFLAG_DAX
> +set at the same time.

Since you can't even mount that way, I suppose not ....

> +That is to say that DAX files cannot share blocks.
> +If this flag is set on a directory, files created within that directory will
> +have this flag set.

Documenting DAX is a bold move...

Do subdirs not inherit the flag?


> +.TP
> +.B FS_XFLAG_COWEXTSIZE
> +Copy on Write Extent size bit - if a CoW extent size value is set on the file,
> +the allocator will allocate extents for staging a copy on write operation
> +in multiples of the set size for this file (see
> +.B fsx_cowextsize
> +below).
> +If the CoW extent size is set on a directory, then new file and directories
> +created in the directory will inherit the parent's CoW extent size value.
> +.TP
> +.B FS_XFLAG_HASATTR
> +The file has extended attributes associated with it.
> +.RE
> +.PP
> +.PD
> +
> +.PP
> +.I fsx_extsize
> +is the preferred extent allocation size for data blocks mapped to this file,
> +in units of filesystem blocks.
> +If this value is zero, the filesystem will choose a default option, which
> +is currently zero.
> +If
> +.B XFS_IOC_FSSETXATTR
> +is called with
> +.B FS_XFLAG_EXTSIZE
> +set in
> +.I fsx_xflags
> +and this field is zero, the XFLAG will be cleared instead.
> +.PP
> +.I fsx_nextents
> +is the number of data extents in this file.
> +If
> +.B XFS_IOC_FSGETXATTRA
> +was used, then this is the number of extended attribute extents in the file.
> +.PP
> +.I fsx_projid
> +is the project ID of this file.
> +.PP
> +.I fsx_cowextsize
> +is the preferred extent allocation size for copy on write operations
> +targeting this file, in units of filesystem blocks.
> +If this field is zero, the filesystem will choose a default option,
> +which is currently 128 filesystem blocks.
> +If
> +.B XFS_IOC_FSSETXATTR
> +is called with
> +.B FS_XFLAG_COWEXTSIZE
> +set in
> +.I fsx_xflags
> +and this field is zero, the XFLAG will be cleared instead.
> +
> +.PP
> +.I fsx_pad
> +must be zeroed.
> +
> +.SH RETURN VALUE
> +On error, \-1 is returned, and
> +.I errno
> +is set to indicate the error.
> +.PP
> +.SH ERRORS
> +Error codes can be one of, but are not limited to, the following:
> +.TP
> +.B EACCESS
> +Caller does not have sufficient access to change the attributes.
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
> +.TP
> +.B EPERM
> +Caller did not have permission to change the attributes.
> +.SH CONFORMING TO
> +This API is implemented by the ext4, xfs, btrfs, and f2fs filesystems on the
> +Linux kernel.
> +Not all fields may be understood by filesystems other than xfs.
> +.SH SEE ALSO
> +.BR ioctl (2)
> diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> index 462ccbd8..2992b5be 100644
> --- a/man/man3/xfsctl.3
> +++ b/man/man3/xfsctl.3
> @@ -132,161 +132,17 @@ will fail with EINVAL.
>  All I/O requests are kept consistent with any data brought into
>  the cache with an access through a non-direct I/O file descriptor.
>  
> -.TP
> -.B XFS_IOC_FSGETXATTR
> -Get additional attributes associated with files in XFS file systems.
> -The final argument points to a variable of type
> -.BR "struct fsxattr" ,
> -whose fields include:
> -.B fsx_xflags
> -(extended flag bits),
> -.B fsx_extsize
> -(nominal extent size in file system blocks),
> -.B fsx_nextents
> -(number of data extents in the file).
> -A
> -.B fsx_extsize
> -value returned indicates that a preferred extent size was previously
> -set on the file, a
> -.B fsx_extsize
> -of zero indicates that the defaults for that filesystem will be used.
> -A
> -.B fsx_cowextsize
> -value returned indicates that a preferred copy on write extent size was
> -previously set on the file, whereas a
> -.B fsx_cowextsize
> -of zero indicates that the defaults for that filesystem will be used.
> -The current default for
> -.B fsx_cowextsize
> -is 128 blocks.
> -Currently the meaningful bits for the
> -.B fsx_xflags
> -field are:
> -.PD 0
> -.RS
> -.TP 1.0i
> -.SM "Bit 0 (0x1) \- XFS_XFLAG_REALTIME"
> -The file is a realtime file.
> -.TP
> -.SM "Bit 1 (0x2) \- XFS_XFLAG_PREALLOC"
> -The file has preallocated space.
> -.TP
> -.SM "Bit 3 (0x8) \- XFS_XFLAG_IMMUTABLE"
> -The file is immutable - it cannot be modified, deleted or renamed,
> -no link can be created to this file and no data can be written to the
> -file.
> -Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
> -capability can set or clear this flag.
> -.TP
> -.SM "Bit 4 (0x10) \- XFS_XFLAG_APPEND"
> -The file is append-only - it can only be open in append mode for
> -writing.
> -Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
> -capability can set or clear this flag.
> -.TP
> -.SM "Bit 5 (0x20) \- XFS_XFLAG_SYNC"
> -All writes to the file are synchronous.
> -.TP
> -.SM "Bit 6 (0x40) \- XFS_XFLAG_NOATIME"
> -When the file is accessed, its atime record is not modified.
> -.TP
> -.SM "Bit 7 (0x80) \- XFS_XFLAG_NODUMP"
> -The file should be skipped by backup utilities.
> -.TP
> -.SM "Bit 8 (0x100) \- XFS_XFLAG_RTINHERIT"
> -Realtime inheritance bit - new files created in the directory
> -will be automatically realtime, and new directories created in
> -the directory will inherit the inheritance bit.
> -.TP
> -.SM "Bit 9 (0x200) \- XFS_XFLAG_PROJINHERIT"
> -Project inheritance bit - new files and directories created in
> -the directory will inherit the parents project ID.  New
> -directories also inherit the project inheritance bit.
> -.TP
> -.SM "Bit 10 (0x400) \- XFS_XFLAG_NOSYMLINKS"
> -Can only be set on a directory and disallows creation of
> -symbolic links in that directory.
> -.TP
> -.SM "Bit 11 (0x800) \- XFS_XFLAG_EXTSIZE"
> -Extent size bit - if a basic extent size value is set on the file
> -then the allocator will allocate in multiples of the set size for
> -this file (see
> -.B XFS_IOC_FSSETXATTR
> -below).
> -.TP
> -.SM "Bit 12 (0x1000) \- XFS_XFLAG_EXTSZINHERIT"
> -Extent size inheritance bit - new files and directories created in
> -the directory will inherit the parents basic extent size value (see
> -.B XFS_IOC_FSSETXATTR
> -below).
> -Can only be set on a directory.
> -.TP
> -.SM "Bit 13 (0x2000) \- XFS_XFLAG_NODEFRAG"
> -No defragment file bit - the file should be skipped during a defragmentation
> -operation. When applied to a directory, new files and directories created will
> -inherit the no\-defrag bit.
> -.TP
> -.SM "Bit 14 (0x4000) \- XFS_XFLAG_FILESTREAM"
> -Filestream allocator bit - allows a directory to reserve an allocation
> -group for exclusive use by files created within that directory. Files
> -being written in other directories will not use the same allocation
> -group and so files within different directories will not interleave
> -extents on disk. The reservation is only active while files are being
> -created and written into the directory.
> -.TP
> -.SM "Bit 15 (0x8000) \- XFS_XFLAG_DAX"
> -If the filesystem lives on directly accessible persistent memory, reads and
> -writes to this file will go straight to the persistent memory, bypassing the
> -page cache.
> -A file cannot be reflinked and have the
> -.BR XFS_XFLAG_DAX
> -set at the same time.
> -That is to say that DAX files cannot share blocks.
> -.TP
> -.SM "Bit 16 (0x10000) \- XFS_XFLAG_COWEXTSIZE"
> -Copy on Write Extent size bit - if a CoW extent size value is set on the file,
> -the allocator will allocate extents for staging a copy on write operation
> -in multiples of the set size for this file (see
> -.B XFS_IOC_FSSETXATTR
> -below).
> -If the CoW extent size is set on a directory, then new file and directories
> -created in the directory will inherit the parent's CoW extent size value.
> -.TP
> -.SM "Bit 31 (0x80000000) \- XFS_XFLAG_HASATTR"
> -The file has extended attributes associated with it.
> -.RE
>  .PP
> -.PD
> -
> -.TP
> -.B XFS_IOC_FSGETXATTRA
> -Identical to
> +.nf
>  .B XFS_IOC_FSGETXATTR
> -except that the
> -.B fsx_nextents
> -field contains the number of attribute extents in the file.
> -
> +.B XFS_IOC_FSGETXATTRA
> +.fi
> +.PD 0
>  .TP
>  .B XFS_IOC_FSSETXATTR
> -Set additional attributes associated with files in XFS file systems.
> -The final argument points to a variable of type
> -.BR "struct fsxattr" ,
> -but only the following fields are used in this call:
> -.BR fsx_xflags ,
> -.BR fsx_extsize ,
> -.BR fsx_cowextsize ,
> -and
> -.BR fsx_projid .
> -The
> -.B fsx_xflags
> -realtime file bit and the file's extent size may be changed only
> -when the file is empty, except in the case of a directory where
> -the extent size can be set at any time (this value is only used
> -for regular file allocations, so should only be set on a directory
> -in conjunction with the XFS_XFLAG_EXTSZINHERIT flag).
> -The copy on write extent size,
> -.BR fsx_cowextsize ,
> -can be set at any time.
> +See
> +.BR ioctl_xfs_fsgetxattr (2)
> +for more information.
>  
>  .TP
>  .B XFS_IOC_GETBMAP
> @@ -649,6 +505,7 @@ The remainder of these operations will not be described further
>  as they are not of general use to applications.
>  
>  .SH SEE ALSO
> +.BR ioctl_xfs_fsgetxattr (2),
>  .BR fstatfs (2),
>  .BR statfs (2),
>  .BR xfs (5),
> 
