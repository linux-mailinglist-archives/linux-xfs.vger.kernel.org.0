Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61EEA4D434
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 18:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfFTQvC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 12:51:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43744 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTQvC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:51:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGnlY3078166;
        Thu, 20 Jun 2019 16:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=oIR1Q7aKIr3ysKahMCe9BVP/Dwr/xzAYUBwzywKYsFw=;
 b=HcDkd75EshyzUp/8dJ9F9GJMYvEcAOFYY/TRMkfNQb2lu7K2CFEtwGBCeLiPRar+HCJL
 ehOU+qWOTi6KFsH73nTJJj9Ev8F06UF2mpI3Y8L2RaA6qWCbpblXSjBM00wzOal4rvpu
 CI8RRJOzHk8OzNEB4yRd8aH+ivIwzB2+1jVnu4V/Rp7hDk+SSo1ErOmVA9UC6SiP9Tbh
 hJ3loOrK+SSAm2Gp3cjgnjrevip1+y3Ne6KHKKpn7DYh2NTLOSUXxVeC8nTkEBuwnzq8
 V7IIBu+ziQq2dC+MZwulyR/xaTX6Fxv3nmaAXgwNkjZ0qtBviswE2YpxTduSsvPjTL4A YA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2t7809j8qm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:50:57 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGnerE057749;
        Thu, 20 Jun 2019 16:50:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2t77ynqpq6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:50:56 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5KGouZB025037;
        Thu, 20 Jun 2019 16:50:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 09:50:55 -0700
Subject: [PATCH 1/9] man: create a separate GETXATTR/SETXATTR ioctl manpage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 20 Jun 2019 09:50:54 -0700
Message-ID: <156104945493.1174403.4930583691574810947.stgit@magnolia>
In-Reply-To: <156104944877.1174403.14568482035189263260.stgit@magnolia>
References: <156104944877.1174403.14568482035189263260.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906200122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906200122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Break out the xfs file attribute get and set ioctls into a separate
manpage to reduce clutter in xfsctl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_fsgetxattr.2  |  245 ++++++++++++++++++++++++++++++++++++++
 man/man2/ioctl_xfs_fsgetxattra.2 |    1 
 man/man2/ioctl_xfs_fssetxattr.2  |    1 
 man/man3/xfsctl.3                |  159 +------------------------
 4 files changed, 255 insertions(+), 151 deletions(-)
 create mode 100644 man/man2/ioctl_xfs_fsgetxattr.2
 create mode 100644 man/man2/ioctl_xfs_fsgetxattra.2
 create mode 100644 man/man2/ioctl_xfs_fssetxattr.2


diff --git a/man/man2/ioctl_xfs_fsgetxattr.2 b/man/man2/ioctl_xfs_fsgetxattr.2
new file mode 100644
index 00000000..7462c46c
--- /dev/null
+++ b/man/man2/ioctl_xfs_fsgetxattr.2
@@ -0,0 +1,245 @@
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0+
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-FSGETXATTR 2 2019-06-17 "XFS"
+.SH NAME
+ioctl_xfs_fsgetxattr \- query information for an open file
+.SH SYNOPSIS
+.br
+.B #include <linux/fs.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_FSGETXATTR, struct fsxattr *" arg );
+.br
+.BI "int ioctl(int " fd ", XFS_IOC_FSGETXATTRA, struct fsxattr *" arg );
+.br
+.BI "int ioctl(int " fd ", XFS_IOC_FSSETXATTR, struct fsxattr *" arg );
+.SH DESCRIPTION
+Query or set additional attributes associated with files in various file
+systems.
+The attributes are conveyed in a structure of the form:
+.PP
+.in +4n
+.nf
+struct fsxattr {
+	__u32         fsx_xflags;
+	__u32         fsx_extsize;
+	__u32         fsx_nextents;
+	__u32         fsx_projid;
+	__u32         fsx_cowextsize;
+	unsigned char fsx_pad[8];
+};
+.fi
+.in
+.PP
+.I fsx_xflags
+are extended flags that apply to this file.
+Refer to the section
+.B XFS INODE FLAGS
+below for more information.
+
+.PP
+.I fsx_extsize
+is the preferred extent allocation size for data blocks mapped to this file,
+in units of filesystem blocks.
+If this value is zero, the filesystem will choose a default option, which
+is currently zero.
+If
+.B XFS_IOC_FSSETXATTR
+is called with
+.B XFS_XFLAG_EXTSIZE
+set in
+.I fsx_xflags
+and this field is zero, the XFLAG will be cleared instead.
+.PP
+.I fsx_nextents
+is the number of data extents in this file.
+If
+.B XFS_IOC_FSGETXATTRA
+was used, then this is the number of extended attribute extents in the file.
+.PP
+.I fsx_projid
+is the project ID of this file.
+.PP
+.I fsx_cowextsize
+is the preferred extent allocation size for copy on write operations
+targeting this file, in units of filesystem blocks.
+If this field is zero, the filesystem will choose a default option,
+which is currently 128 filesystem blocks.
+If
+.B XFS_IOC_FSSETXATTR
+is called with
+.B XFS_XFLAG_COWEXTSIZE
+set in
+.I fsx_xflags
+and this field is zero, the XFLAG will be cleared instead.
+
+.PP
+.I fsx_pad
+must be zeroed.
+
+.SH XFS INODE FLAGS
+This field can be a combination of the following:
+
+.TP
+.B XFS_XFLAG_REALTIME
+The file is a realtime file.
+This bit can only be changed when the file is empty.
+.TP
+.B XFS_XFLAG_PREALLOC
+The file has preallocated space.
+.TP
+.B XFS_XFLAG_IMMUTABLE
+The file is immutable - it cannot be modified, deleted or renamed,
+no link can be created to this file and no data can be written to the
+file.
+Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
+capability can set or clear this flag.
+If this flag is set before a
+.B XFS_IOC_FSSETXATTR
+call and would not be cleared by the call, then no other attributes can be
+changed and
+.B EPERM
+will be returned.
+.TP
+.B XFS_XFLAG_APPEND
+The file is append-only - it can only be open in append mode for
+writing.
+Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
+capability can set or clear this flag.
+.TP
+.B XFS_XFLAG_SYNC
+All writes to the file are synchronous.
+If set on a directory and the
+.B /proc/sys/fs/xfs/inherit_sync
+knob is set, new files and subdirectories created in the directory
+will also have the flag set.
+.TP
+.B XFS_XFLAG_NOATIME
+When the file is accessed, its atime record is not modified.
+If set on a directory and the
+.B /proc/sys/fs/xfs/inherit_noatime
+knob is set, new files and subdirectories created in the directory
+will also have the flag set.
+.TP
+.B XFS_XFLAG_NODUMP
+The file should be skipped by backup utilities.
+If set on a directory and the
+.B /proc/sys/fs/xfs/inherit_nodump
+knob is set, new files and subdirectories created in the directory
+will also have the flag set.
+.TP
+.B XFS_XFLAG_RTINHERIT
+Realtime inheritance bit - new files created in the directory
+will be automatically as realtime times.
+If set on a directory, new subdirectories created in the directory will also
+have the inheritance flag set.
+.TP
+.B XFS_XFLAG_PROJINHERIT
+Project inheritance bit - new files and directories created in
+this directory will inherit the project ID of this directory.
+If set on a directory, new subdirectories created in the directory will also
+have the inheritance flag set.
+.TP
+.B XFS_XFLAG_NOSYMLINKS
+Disallows creation of symbolic links in the directory.
+This flag can only be set on a directory.
+If set on a directory and the
+.B /proc/sys/fs/xfs/inherit_nosymlinks
+knob is set, new files and subdirectories created in the directory
+will also have the flag set.
+.TP
+.B XFS_XFLAG_EXTSIZE
+Extent size bit - if a basic extent size value is set on the file
+then the allocator will allocate in multiples of the set size for
+this file (see
+.B fsx_extsize
+below).
+This flag can only be set on a file if it is empty.
+.TP
+.B XFS_XFLAG_EXTSZINHERIT
+Extent size inheritance bit - new files and directories created in
+the directory will inherit the extent size value (see
+.B fsx_extsize
+below) of the parent directory.
+New subdirectories created in the directory will inherit the extent size
+inheritance bit.
+.TP
+.B XFS_XFLAG_NODEFRAG
+No defragment file bit - the file should be skipped during a defragmentation
+operation.
+If set on a directory and the
+.B /proc/sys/fs/xfs/inherit_nodefrag
+knob is set, new files and subdirectories created in the directory
+will also have the flag set.
+.TP
+.B XFS_XFLAG_FILESTREAM
+Filestream allocator bit - allows a directory to reserve an allocation group
+for exclusive use by files created within that directory.
+Files being written in other directories will not use the same allocation group
+and so files within different directories will not interleave extents on disk.
+The reservation is only active while files are being created and written into
+the directory.
+If set on a directory, new files and subdirectories created in the directory
+will also have the flag set.
+.TP
+.B XFS_XFLAG_DAX
+If the filesystem lives on directly accessible persistent memory, reads and
+writes to this file will go straight to the persistent memory, bypassing the
+page cache.
+A file cannot be reflinked and have the
+.BR XFS_XFLAG_DAX
+set at the same time.
+That is to say that DAX files cannot share blocks.
+If set on a directory, new files and subdirectories created in the directory
+will also have the flag set.
+.TP
+.B XFS_XFLAG_COWEXTSIZE
+Copy on Write Extent size bit - if a CoW extent size value is set on the file,
+the allocator will allocate extents for staging a copy on write operation
+in multiples of the set size for this file (see
+.B fsx_cowextsize
+below).
+If set on a directory, new files and subdirectories created in the directory
+will have both the flag and the CoW extent size value set.
+.TP
+.B XFS_XFLAG_HASATTR
+The file has extended attributes associated with it.
+
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
+.TP
+.B EACCESS
+Caller does not have sufficient access to change the attributes.
+.TP
+.B EFAULT
+The kernel was not able to copy into the userspace buffer.
+.TP
+.B EFSBADCRC
+Metadata checksum validation failed while performing the query.
+.TP
+.B EFSCORRUPTED
+Metadata corruption was encountered while performing the query.
+.TP
+.B EINVAL
+One of the arguments was not valid.
+.TP
+.B EIO
+An I/O error was encountered while performing the query.
+.TP
+.B ENOMEM
+There was insufficient memory to perform the query.
+.TP
+.B EPERM
+Caller did not have permission to change the attributes.
+.SH CONFORMING TO
+This API is implemented by the ext4, xfs, btrfs, and f2fs filesystems on the
+Linux kernel.
+Not all fields may be understood by filesystems other than xfs.
+.SH SEE ALSO
+.BR ioctl (2),
+.BR ioctl_iflags (2)
diff --git a/man/man2/ioctl_xfs_fsgetxattra.2 b/man/man2/ioctl_xfs_fsgetxattra.2
new file mode 100644
index 00000000..9bd595ae
--- /dev/null
+++ b/man/man2/ioctl_xfs_fsgetxattra.2
@@ -0,0 +1 @@
+.so man2/ioctl_xfs_fsgetxattr.2
diff --git a/man/man2/ioctl_xfs_fssetxattr.2 b/man/man2/ioctl_xfs_fssetxattr.2
new file mode 100644
index 00000000..9bd595ae
--- /dev/null
+++ b/man/man2/ioctl_xfs_fssetxattr.2
@@ -0,0 +1 @@
+.so man2/ioctl_xfs_fsgetxattr.2
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 462ccbd8..2992b5be 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -132,161 +132,17 @@ will fail with EINVAL.
 All I/O requests are kept consistent with any data brought into
 the cache with an access through a non-direct I/O file descriptor.
 
-.TP
-.B XFS_IOC_FSGETXATTR
-Get additional attributes associated with files in XFS file systems.
-The final argument points to a variable of type
-.BR "struct fsxattr" ,
-whose fields include:
-.B fsx_xflags
-(extended flag bits),
-.B fsx_extsize
-(nominal extent size in file system blocks),
-.B fsx_nextents
-(number of data extents in the file).
-A
-.B fsx_extsize
-value returned indicates that a preferred extent size was previously
-set on the file, a
-.B fsx_extsize
-of zero indicates that the defaults for that filesystem will be used.
-A
-.B fsx_cowextsize
-value returned indicates that a preferred copy on write extent size was
-previously set on the file, whereas a
-.B fsx_cowextsize
-of zero indicates that the defaults for that filesystem will be used.
-The current default for
-.B fsx_cowextsize
-is 128 blocks.
-Currently the meaningful bits for the
-.B fsx_xflags
-field are:
-.PD 0
-.RS
-.TP 1.0i
-.SM "Bit 0 (0x1) \- XFS_XFLAG_REALTIME"
-The file is a realtime file.
-.TP
-.SM "Bit 1 (0x2) \- XFS_XFLAG_PREALLOC"
-The file has preallocated space.
-.TP
-.SM "Bit 3 (0x8) \- XFS_XFLAG_IMMUTABLE"
-The file is immutable - it cannot be modified, deleted or renamed,
-no link can be created to this file and no data can be written to the
-file.
-Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
-capability can set or clear this flag.
-.TP
-.SM "Bit 4 (0x10) \- XFS_XFLAG_APPEND"
-The file is append-only - it can only be open in append mode for
-writing.
-Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE
-capability can set or clear this flag.
-.TP
-.SM "Bit 5 (0x20) \- XFS_XFLAG_SYNC"
-All writes to the file are synchronous.
-.TP
-.SM "Bit 6 (0x40) \- XFS_XFLAG_NOATIME"
-When the file is accessed, its atime record is not modified.
-.TP
-.SM "Bit 7 (0x80) \- XFS_XFLAG_NODUMP"
-The file should be skipped by backup utilities.
-.TP
-.SM "Bit 8 (0x100) \- XFS_XFLAG_RTINHERIT"
-Realtime inheritance bit - new files created in the directory
-will be automatically realtime, and new directories created in
-the directory will inherit the inheritance bit.
-.TP
-.SM "Bit 9 (0x200) \- XFS_XFLAG_PROJINHERIT"
-Project inheritance bit - new files and directories created in
-the directory will inherit the parents project ID.  New
-directories also inherit the project inheritance bit.
-.TP
-.SM "Bit 10 (0x400) \- XFS_XFLAG_NOSYMLINKS"
-Can only be set on a directory and disallows creation of
-symbolic links in that directory.
-.TP
-.SM "Bit 11 (0x800) \- XFS_XFLAG_EXTSIZE"
-Extent size bit - if a basic extent size value is set on the file
-then the allocator will allocate in multiples of the set size for
-this file (see
-.B XFS_IOC_FSSETXATTR
-below).
-.TP
-.SM "Bit 12 (0x1000) \- XFS_XFLAG_EXTSZINHERIT"
-Extent size inheritance bit - new files and directories created in
-the directory will inherit the parents basic extent size value (see
-.B XFS_IOC_FSSETXATTR
-below).
-Can only be set on a directory.
-.TP
-.SM "Bit 13 (0x2000) \- XFS_XFLAG_NODEFRAG"
-No defragment file bit - the file should be skipped during a defragmentation
-operation. When applied to a directory, new files and directories created will
-inherit the no\-defrag bit.
-.TP
-.SM "Bit 14 (0x4000) \- XFS_XFLAG_FILESTREAM"
-Filestream allocator bit - allows a directory to reserve an allocation
-group for exclusive use by files created within that directory. Files
-being written in other directories will not use the same allocation
-group and so files within different directories will not interleave
-extents on disk. The reservation is only active while files are being
-created and written into the directory.
-.TP
-.SM "Bit 15 (0x8000) \- XFS_XFLAG_DAX"
-If the filesystem lives on directly accessible persistent memory, reads and
-writes to this file will go straight to the persistent memory, bypassing the
-page cache.
-A file cannot be reflinked and have the
-.BR XFS_XFLAG_DAX
-set at the same time.
-That is to say that DAX files cannot share blocks.
-.TP
-.SM "Bit 16 (0x10000) \- XFS_XFLAG_COWEXTSIZE"
-Copy on Write Extent size bit - if a CoW extent size value is set on the file,
-the allocator will allocate extents for staging a copy on write operation
-in multiples of the set size for this file (see
-.B XFS_IOC_FSSETXATTR
-below).
-If the CoW extent size is set on a directory, then new file and directories
-created in the directory will inherit the parent's CoW extent size value.
-.TP
-.SM "Bit 31 (0x80000000) \- XFS_XFLAG_HASATTR"
-The file has extended attributes associated with it.
-.RE
 .PP
-.PD
-
-.TP
-.B XFS_IOC_FSGETXATTRA
-Identical to
+.nf
 .B XFS_IOC_FSGETXATTR
-except that the
-.B fsx_nextents
-field contains the number of attribute extents in the file.
-
+.B XFS_IOC_FSGETXATTRA
+.fi
+.PD 0
 .TP
 .B XFS_IOC_FSSETXATTR
-Set additional attributes associated with files in XFS file systems.
-The final argument points to a variable of type
-.BR "struct fsxattr" ,
-but only the following fields are used in this call:
-.BR fsx_xflags ,
-.BR fsx_extsize ,
-.BR fsx_cowextsize ,
-and
-.BR fsx_projid .
-The
-.B fsx_xflags
-realtime file bit and the file's extent size may be changed only
-when the file is empty, except in the case of a directory where
-the extent size can be set at any time (this value is only used
-for regular file allocations, so should only be set on a directory
-in conjunction with the XFS_XFLAG_EXTSZINHERIT flag).
-The copy on write extent size,
-.BR fsx_cowextsize ,
-can be set at any time.
+See
+.BR ioctl_xfs_fsgetxattr (2)
+for more information.
 
 .TP
 .B XFS_IOC_GETBMAP
@@ -649,6 +505,7 @@ The remainder of these operations will not be described further
 as they are not of general use to applications.
 
 .SH SEE ALSO
+.BR ioctl_xfs_fsgetxattr (2),
 .BR fstatfs (2),
 .BR statfs (2),
 .BR xfs (5),

