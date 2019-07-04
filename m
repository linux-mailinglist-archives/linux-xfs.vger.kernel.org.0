Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79DDA5F11D
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Jul 2019 04:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfGDCEn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 3 Jul 2019 22:04:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57390 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfGDCEn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jul 2019 22:04:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6423aj4054404;
        Thu, 4 Jul 2019 02:04:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=utrJ97j4pwcxqcEaKIBqg0agVqV6lX7oF1BfQZbt1bg=;
 b=Egvlveh3z20ddxr8hLcDfYOL863HEVj9KHXMPeB4pRcNa4YMIq+6rVB0sk5h2/IhSwDg
 2lhR27kgD1732iVxFIdIrVUIa/YCIFBLN2puu4g7x4uTeQPgceVJF0HGXYDV/qrXGMEW
 +iYW26QmmEs4oTE/pjZUDVa0P4R0oPU11uLf8WO/qJw/GeeSlY1cTcrBUsxk03c0fF6G
 nhsPkvt5822Pb6fxNMYyulJ38Gh7QW58yW2ZZfq74tLBcbtBIJFqZYYpWQdOZMbwqf02
 T9ecIIx4t19jK8wkHlTPp42+b/CqPN9x3AAJRQb8+ttKR46ZCl44rucdcH4tXaemwmM1 +w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2te61ec8xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Jul 2019 02:04:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6423OGh173577;
        Thu, 4 Jul 2019 02:04:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tebkv68qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Jul 2019 02:04:37 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6424afk026543;
        Thu, 4 Jul 2019 02:04:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jul 2019 19:04:35 -0700
Date:   Wed, 3 Jul 2019 19:04:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] man: create a separate GETXATTR/SETXATTR ioctl
 manpage
Message-ID: <20190704020434.GE1654093@magnolia>
References: <156104944877.1174403.14568482035189263260.stgit@magnolia>
 <156104945493.1174403.4930583691574810947.stgit@magnolia>
 <82a5ede1-7b80-92a6-d3b0-4d09642e4015@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82a5ede1-7b80-92a6-d3b0-4d09642e4015@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907040026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907040026
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 03, 2019 at 05:48:15PM -0500, Eric Sandeen wrote:
> On 6/20/19 11:50 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Break out the xfs file attribute get and set ioctls into a separate
> > manpage to reduce clutter in xfsctl.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  man/man2/ioctl_xfs_fsgetxattr.2  |  245 ++++++++++++++++++++++++++++++++++++++
> >  man/man2/ioctl_xfs_fsgetxattra.2 |    1 
> >  man/man2/ioctl_xfs_fssetxattr.2  |    1 
> >  man/man3/xfsctl.3                |  159 +------------------------
> >  4 files changed, 255 insertions(+), 151 deletions(-)
> >  create mode 100644 man/man2/ioctl_xfs_fsgetxattr.2
> >  create mode 100644 man/man2/ioctl_xfs_fsgetxattra.2
> >  create mode 100644 man/man2/ioctl_xfs_fssetxattr.2
> > 
> 
> Ok I started nitpicking again but realized that lots of this is inherited;
> perhaps we should have just done a 100% pure move, followed by an improvement
> patch.  So anything bothersome that was just inherited here I'll...
> try to ignore, and focus on stuff that is new and unclear or incorrect.
> 
> If I get acks for the suggestions below I'll just do it on the way in.

Ok.

> > diff --git a/man/man2/ioctl_xfs_fsgetxattr.2 b/man/man2/ioctl_xfs_fsgetxattr.2
> > new file mode 100644
> > index 00000000..7462c46c
> > --- /dev/null
> > +++ b/man/man2/ioctl_xfs_fsgetxattr.2
> > @@ -0,0 +1,245 @@
> > +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> > +.\" SPDX-License-Identifier: GPL-2.0+
> > +.\" %%%LICENSE_END
> > +.TH IOCTL-XFS-FSGETXATTR 2 2019-06-17 "XFS"
> > +.SH NAME
> > +ioctl_xfs_fsgetxattr \- query information for an open file
> > +.SH SYNOPSIS
> > +.br
> > +.B #include <linux/fs.h>
> > +.PP
> > +.BI "int ioctl(int " fd ", XFS_IOC_FSGETXATTR, struct fsxattr *" arg );
> > +.br
> > +.BI "int ioctl(int " fd ", XFS_IOC_FSGETXATTRA, struct fsxattr *" arg );
> > +.br
> > +.BI "int ioctl(int " fd ", XFS_IOC_FSSETXATTR, struct fsxattr *" arg );
> > +.SH DESCRIPTION
> > +Query or set additional attributes associated with files in various file
> > +systems.
> > +The attributes are conveyed in a structure of the form:
> > +.PP
> > +.in +4n
> > +.nf
> > +struct fsxattr {
> > +	__u32         fsx_xflags;
> > +	__u32         fsx_extsize;
> > +	__u32         fsx_nextents;
> > +	__u32         fsx_projid;
> > +	__u32         fsx_cowextsize;
> > +	unsigned char fsx_pad[8];
> > +};
> > +.fi
> > +.in
> > +.PP
> > +.I fsx_xflags
> > +are extended flags that apply to this file.
> > +Refer to the section
> > +.B XFS INODE FLAGS
> > +below for more information.
> > +
> > +.PP
> > +.I fsx_extsize
> > +is the preferred extent allocation size for data blocks mapped to this file,
> > +in units of filesystem blocks.
> > +If this value is zero, the filesystem will choose a default option, which
> > +is currently zero.
> > +If
> > +.B XFS_IOC_FSSETXATTR
> > +is called with
> > +.B XFS_XFLAG_EXTSIZE
> > +set in
> > +.I fsx_xflags
> > +and this field is zero, the XFLAG will be cleared instead.
> 
> "instead" implies that the value is ignored, I think, so:
> 
> "and this field set to zero, the XFLAG will also be cleared."

LGTM

> > +.PP
> > +.I fsx_nextents
> > +is the number of data extents in this file.
> > +If
> > +.B XFS_IOC_FSGETXATTRA
> > +was used, then this is the number of extended attribute extents in the file.
> > +.PP
> > +.I fsx_projid
> > +is the project ID of this file.
> > +.PP
> > +.I fsx_cowextsize
> > +is the preferred extent allocation size for copy on write operations
> > +targeting this file, in units of filesystem blocks.
> > +If this field is zero, the filesystem will choose a default option,
> > +which is currently 128 filesystem blocks.
> > +If
> > +.B XFS_IOC_FSSETXATTR
> > +is called with
> > +.B XFS_XFLAG_COWEXTSIZE
> > +set in
> > +.I fsx_xflags
> > +and this field is zero, the XFLAG will be cleared instead.
> 
> "and this field set to zero, the XFLAG will also be cleared."

LGTM

> > +
> > +.PP
> > +.I fsx_pad
> > +must be zeroed.
> > +
> > +.SH XFS INODE FLAGS
> > +This field can be a combination of the following:
> > +
> > +.TP
> > +.B XFS_XFLAG_REALTIME
> > +The file is a realtime file.
> > +This bit can only be changed when the file is empty.
> > +.TP
> > +.B XFS_XFLAG_PREALLOC
> > +The file has preallocated space.
> 
> > +.TP
> > +.B XFS_XFLAG_IMMUTABLE
> > +The file is immutable - it cannot be modified, deleted or renamed,
> > +no link can be created to this file and no data can be written to the
> > +file.
> > +Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
> > +capability can set or clear this flag.
> > +If this flag is set before a
> > +.B XFS_IOC_FSSETXATTR
> > +call and would not be cleared by the call, then no other attributes can be
> > +changed and
> > +.B EPERM
> > +will be returned.
> > +.TP
> > +.B XFS_XFLAG_APPEND
> > +The file is append-only - it can only be open in append mode for
> 
> opened?

Yes.

> > +writing.
> > +Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
> > +capability can set or clear this flag.
> > +.TP
> > +.B XFS_XFLAG_SYNC
> > +All writes to the file are synchronous.
> > +If set on a directory and the
> > +.B /proc/sys/fs/xfs/inherit_sync
> > +knob is set, new files and subdirectories created in the directory
> 
> Ok ignoring the colloquial knob for now ;)

What's the colloquialism?  "subdirectory"?

> > +will also have the flag set.
> > +.TP
> > +.B XFS_XFLAG_NOATIME
> > +When the file is accessed, its atime record is not modified.
> > +If set on a directory and the
> > +.B /proc/sys/fs/xfs/inherit_noatime
> > +knob is set, new files and subdirectories created in the directory
> > +will also have the flag set.
> > +.TP
> > +.B XFS_XFLAG_NODUMP
> > +The file should be skipped by backup utilities.
> > +If set on a directory and the
> > +.B /proc/sys/fs/xfs/inherit_nodump
> > +knob is set, new files and subdirectories created in the directory
> > +will also have the flag set.
> > +.TP
> > +.B XFS_XFLAG_RTINHERIT
> > +Realtime inheritance bit - new files created in the directory
> > +will be automatically as realtime times.
> 
> "will be automatically created as realtime files."

Ok.

> > +If set on a directory, new subdirectories created in the directory will also
> > +have the inheritance flag set.
> (I almost wonder if we should just group the inheritable flags together
> and mention it once.  "For the following flags, if the flag is set on
> a directory ...") ((I'll worry about that later))

Yeah, that would be a nice cleanup.

> > +.TP
> > +.B XFS_XFLAG_PROJINHERIT
> > +Project inheritance bit - new files and directories created in
> > +this directory will inherit the project ID of this directory.
> > +If set on a directory, new subdirectories created in the directory will also
> > +have the inheritance flag set.> +.TP
> > +.B XFS_XFLAG_NOSYMLINKS
> > +Disallows creation of symbolic links in the directory.
> > +This flag can only be set on a directory.
> > +If set on a directory and the
> > +.B /proc/sys/fs/xfs/inherit_nosymlinks
> > +knob is set, new files and subdirectories created in the directory
> > +will also have the flag set.
> > +.TP
> > +.B XFS_XFLAG_EXTSIZE
> > +Extent size bit - if a basic extent size value is set on the file
> > +then the allocator will allocate in multiples of the set size for
> > +this file (see
> > +.B fsx_extsize
> > +below).
> > +This flag can only be set on a file if it is empty.
> 
> I feel like "set" is ambiguous, it can mean "toggled from unset to set"
> or "is currently set" - if interpreted on the latter, it sounds like a
> GET operation should never see the flag unless it is empty. so:
> 
> "This flag can only be initially set on a file when it is empty" ?

AFAICT it can be set if the file is truncated back to empty.

"This flag can only be enabled on a file when it is empty"?

> > +.TP
> > +.B XFS_XFLAG_EXTSZINHERIT
> > +Extent size inheritance bit - new files and directories created in
> > +the directory will inherit the extent size value (see
> > +.B fsx_extsize
> > +below) of the parent directory.
> > +New subdirectories created in the directory will inherit the extent size
> > +inheritance bit.
> > +.TP
> > +.B XFS_XFLAG_NODEFRAG
> > +No defragment file bit - the file should be skipped during a defragmentation
> > +operation.
> > +If set on a directory and the
> > +.B /proc/sys/fs/xfs/inherit_nodefrag
> > +knob is set, new files and subdirectories created in the directory
> > +will also have the flag set.
> > +.TP
> > +.B XFS_XFLAG_FILESTREAM
> > +Filestream allocator bit - allows a directory to reserve an allocation group
> > +for exclusive use by files created within that directory.
> > +Files being written in other directories will not use the same allocation group
> > +and so files within different directories will not interleave extents on disk.
> > +The reservation is only active while files are being created and written into
> > +the directory.
> > +If set on a directory, new files and subdirectories created in the directory
> > +will also have the flag set.
> > +.TP
> > +.B XFS_XFLAG_DAX
> > +If the filesystem lives on directly accessible persistent memory, reads and
> > +writes to this file will go straight to the persistent memory, bypassing the
> > +page cache.
> > +A file cannot be reflinked and have the
> > +.BR XFS_XFLAG_DAX
> > +set at the same time.
> > +That is to say that DAX files cannot share blocks.
> 
> Should we just say that this flag cannot be set on filesystems with the 
> reflink feature enabled?

Yes.

Thanks for picking this up, sorry I was sloppy. :( :(

Happy Independence Day!~!

--D

> > +If set on a directory, new files and subdirectories created in the directory
> > +will also have the flag set.
> > +.TP
> > +.B XFS_XFLAG_COWEXTSIZE
> > +Copy on Write Extent size bit - if a CoW extent size value is set on the file,
> > +the allocator will allocate extents for staging a copy on write operation
> > +in multiples of the set size for this file (see
> > +.B fsx_cowextsize
> > +below).
> > +If set on a directory, new files and subdirectories created in the directory
> > +will have both the flag and the CoW extent size value set.
> > +.TP
> > +.B XFS_XFLAG_HASATTR
> > +The file has extended attributes associated with it.
> > +
> > +.SH RETURN VALUE
> > +On error, \-1 is returned, and
> > +.I errno
> > +is set to indicate the error.
> > +.PP
> > +.SH ERRORS
> > +Error codes can be one of, but are not limited to, the following:
> > +.TP
> > +.B EACCESS
> > +Caller does not have sufficient access to change the attributes.
> > +.TP
> > +.B EFAULT
> > +The kernel was not able to copy into the userspace buffer.
> > +.TP
> > +.B EFSBADCRC
> > +Metadata checksum validation failed while performing the query.
> > +.TP
> > +.B EFSCORRUPTED
> > +Metadata corruption was encountered while performing the query.
> > +.TP
> > +.B EINVAL
> > +One of the arguments was not valid.
> > +.TP
> > +.B EIO
> > +An I/O error was encountered while performing the query.
> > +.TP
> > +.B ENOMEM
> > +There was insufficient memory to perform the query.
> > +.TP
> > +.B EPERM
> > +Caller did not have permission to change the attributes.
> > +.SH CONFORMING TO
> > +This API is implemented by the ext4, xfs, btrfs, and f2fs filesystems on the
> > +Linux kernel.
> > +Not all fields may be understood by filesystems other than xfs.
> > +.SH SEE ALSO
> > +.BR ioctl (2),
> > +.BR ioctl_iflags (2)
> > diff --git a/man/man2/ioctl_xfs_fsgetxattra.2 b/man/man2/ioctl_xfs_fsgetxattra.2
> > new file mode 100644
> > index 00000000..9bd595ae
> > --- /dev/null
> > +++ b/man/man2/ioctl_xfs_fsgetxattra.2
> > @@ -0,0 +1 @@
> > +.so man2/ioctl_xfs_fsgetxattr.2
> > diff --git a/man/man2/ioctl_xfs_fssetxattr.2 b/man/man2/ioctl_xfs_fssetxattr.2
> > new file mode 100644
> > index 00000000..9bd595ae
> > --- /dev/null
> > +++ b/man/man2/ioctl_xfs_fssetxattr.2
> > @@ -0,0 +1 @@
> > +.so man2/ioctl_xfs_fsgetxattr.2
> > diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> > index 462ccbd8..2992b5be 100644
> > --- a/man/man3/xfsctl.3
> > +++ b/man/man3/xfsctl.3
> > @@ -132,161 +132,17 @@ will fail with EINVAL.
> >  All I/O requests are kept consistent with any data brought into
> >  the cache with an access through a non-direct I/O file descriptor.
> >  
> > -.TP
> > -.B XFS_IOC_FSGETXATTR
> > -Get additional attributes associated with files in XFS file systems.
> > -The final argument points to a variable of type
> > -.BR "struct fsxattr" ,
> > -whose fields include:
> > -.B fsx_xflags
> > -(extended flag bits),
> > -.B fsx_extsize
> > -(nominal extent size in file system blocks),
> > -.B fsx_nextents
> > -(number of data extents in the file).
> > -A
> > -.B fsx_extsize
> > -value returned indicates that a preferred extent size was previously
> > -set on the file, a
> > -.B fsx_extsize
> > -of zero indicates that the defaults for that filesystem will be used.
> > -A
> > -.B fsx_cowextsize
> > -value returned indicates that a preferred copy on write extent size was
> > -previously set on the file, whereas a
> > -.B fsx_cowextsize
> > -of zero indicates that the defaults for that filesystem will be used.
> > -The current default for
> > -.B fsx_cowextsize
> > -is 128 blocks.
> > -Currently the meaningful bits for the
> > -.B fsx_xflags
> > -field are:
> > -.PD 0
> > -.RS
> > -.TP 1.0i
> > -.SM "Bit 0 (0x1) \- XFS_XFLAG_REALTIME"
> > -The file is a realtime file.
> > -.TP
> > -.SM "Bit 1 (0x2) \- XFS_XFLAG_PREALLOC"
> > -The file has preallocated space.
> > -.TP
> > -.SM "Bit 3 (0x8) \- XFS_XFLAG_IMMUTABLE"
> > -The file is immutable - it cannot be modified, deleted or renamed,
> > -no link can be created to this file and no data can be written to the
> > -file.
> > -Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
> > -capability can set or clear this flag.
> > -.TP
> > -.SM "Bit 4 (0x10) \- XFS_XFLAG_APPEND"
> > -The file is append-only - it can only be open in append mode for
> > -writing.
> > -Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
> > -capability can set or clear this flag.
> > -.TP
> > -.SM "Bit 5 (0x20) \- XFS_XFLAG_SYNC"
> > -All writes to the file are synchronous.
> > -.TP
> > -.SM "Bit 6 (0x40) \- XFS_XFLAG_NOATIME"
> > -When the file is accessed, its atime record is not modified.
> > -.TP
> > -.SM "Bit 7 (0x80) \- XFS_XFLAG_NODUMP"
> > -The file should be skipped by backup utilities.
> > -.TP
> > -.SM "Bit 8 (0x100) \- XFS_XFLAG_RTINHERIT"
> > -Realtime inheritance bit - new files created in the directory
> > -will be automatically realtime, and new directories created in
> > -the directory will inherit the inheritance bit.
> > -.TP
> > -.SM "Bit 9 (0x200) \- XFS_XFLAG_PROJINHERIT"
> > -Project inheritance bit - new files and directories created in
> > -the directory will inherit the parents project ID.  New
> > -directories also inherit the project inheritance bit.
> > -.TP
> > -.SM "Bit 10 (0x400) \- XFS_XFLAG_NOSYMLINKS"
> > -Can only be set on a directory and disallows creation of
> > -symbolic links in that directory.
> > -.TP
> > -.SM "Bit 11 (0x800) \- XFS_XFLAG_EXTSIZE"
> > -Extent size bit - if a basic extent size value is set on the file
> > -then the allocator will allocate in multiples of the set size for
> > -this file (see
> > -.B XFS_IOC_FSSETXATTR
> > -below).
> > -.TP
> > -.SM "Bit 12 (0x1000) \- XFS_XFLAG_EXTSZINHERIT"
> > -Extent size inheritance bit - new files and directories created in
> > -the directory will inherit the parents basic extent size value (see
> > -.B XFS_IOC_FSSETXATTR
> > -below).
> > -Can only be set on a directory.
> > -.TP
> > -.SM "Bit 13 (0x2000) \- XFS_XFLAG_NODEFRAG"
> > -No defragment file bit - the file should be skipped during a defragmentation
> > -operation. When applied to a directory, new files and directories created will
> > -inherit the no\-defrag bit.
> > -.TP
> > -.SM "Bit 14 (0x4000) \- XFS_XFLAG_FILESTREAM"
> > -Filestream allocator bit - allows a directory to reserve an allocation
> > -group for exclusive use by files created within that directory. Files
> > -being written in other directories will not use the same allocation
> > -group and so files within different directories will not interleave
> > -extents on disk. The reservation is only active while files are being
> > -created and written into the directory.
> > -.TP
> > -.SM "Bit 15 (0x8000) \- XFS_XFLAG_DAX"
> > -If the filesystem lives on directly accessible persistent memory, reads and
> > -writes to this file will go straight to the persistent memory, bypassing the
> > -page cache.
> > -A file cannot be reflinked and have the
> > -.BR XFS_XFLAG_DAX
> > -set at the same time.
> > -That is to say that DAX files cannot share blocks.
> > -.TP
> > -.SM "Bit 16 (0x10000) \- XFS_XFLAG_COWEXTSIZE"
> > -Copy on Write Extent size bit - if a CoW extent size value is set on the file,
> > -the allocator will allocate extents for staging a copy on write operation
> > -in multiples of the set size for this file (see
> > -.B XFS_IOC_FSSETXATTR
> > -below).
> > -If the CoW extent size is set on a directory, then new file and directories
> > -created in the directory will inherit the parent's CoW extent size value.
> > -.TP
> > -.SM "Bit 31 (0x80000000) \- XFS_XFLAG_HASATTR"
> > -The file has extended attributes associated with it.
> > -.RE
> >  .PP
> > -.PD
> > -
> > -.TP
> > -.B XFS_IOC_FSGETXATTRA
> > -Identical to
> > +.nf
> >  .B XFS_IOC_FSGETXATTR
> > -except that the
> > -.B fsx_nextents
> > -field contains the number of attribute extents in the file.
> > -
> > +.B XFS_IOC_FSGETXATTRA
> > +.fi
> > +.PD 0
> >  .TP
> >  .B XFS_IOC_FSSETXATTR
> > -Set additional attributes associated with files in XFS file systems.
> > -The final argument points to a variable of type
> > -.BR "struct fsxattr" ,
> > -but only the following fields are used in this call:
> > -.BR fsx_xflags ,
> > -.BR fsx_extsize ,
> > -.BR fsx_cowextsize ,
> > -and
> > -.BR fsx_projid .
> > -The
> > -.B fsx_xflags
> > -realtime file bit and the file's extent size may be changed only
> > -when the file is empty, except in the case of a directory where
> > -the extent size can be set at any time (this value is only used
> > -for regular file allocations, so should only be set on a directory
> > -in conjunction with the XFS_XFLAG_EXTSZINHERIT flag).
> > -The copy on write extent size,
> > -.BR fsx_cowextsize ,
> > -can be set at any time.
> > +See
> > +.BR ioctl_xfs_fsgetxattr (2)
> > +for more information.
> >  
> >  .TP
> >  .B XFS_IOC_GETBMAP
> > @@ -649,6 +505,7 @@ The remainder of these operations will not be described further
> >  as they are not of general use to applications.
> >  
> >  .SH SEE ALSO
> > +.BR ioctl_xfs_fsgetxattr (2),
> >  .BR fstatfs (2),
> >  .BR statfs (2),
> >  .BR xfs (5),
> > 
