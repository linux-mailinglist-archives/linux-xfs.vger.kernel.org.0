Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0065439593
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 21:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbfFGT3S (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Jun 2019 15:29:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55058 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729625AbfFGT3S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 15:29:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JSdGx086514;
        Fri, 7 Jun 2019 19:29:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Xa9xPgk97uoE7q6cO6J7aVZXLzUfTXF0FsDMlehYWSI=;
 b=DWS1xwFPJfIplEFBq0/T508ISrQ5J0Femur4XyZPhRcHWCyCRG7FhUC9NR3TM/1rGz75
 srRN2dLcvn2GwwBaSpulnQA/VK6qO1rOW396iwvo9LopW9Fc7ZrO5d4NffTOQiVl83Jw
 Se0AqVg/svBHNpeq4B7CeXzim9OAXqblLbwo1tplRKN9k7CkQGcf+c5F7JHPXu3sEQYa
 2pWX8FAlKdqTM6nUT+h+YV0Q2rMtoVFHG92sJICb0fUkD9SP6U1UfbvDzcja5JwvazJm
 Hc+V5gP98VqP4HJdwDYDVCz9iUbGqXz1CId4mY4Yb9JGq860rwfvWNCQY+o9I+x5Sas6 DQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2suj0r030e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:29:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JT7nX170423;
        Fri, 7 Jun 2019 19:29:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2swngn8a8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:29:15 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x57JTEmb015280;
        Fri, 7 Jun 2019 19:29:15 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Jun 2019 12:29:14 -0700
Subject: [PATCH 2/9] libxfs: break out the fsop geometry manpage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 07 Jun 2019 12:29:13 -0700
Message-ID: <155993575303.2343530.6107806014092743035.stgit@magnolia>
In-Reply-To: <155993574034.2343530.12919951702156931143.stgit@magnolia>
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906070130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906070130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Break out the fs geometry ioctl into a separate manpage so that we can
document how it works.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_fsop_geometry.2 |  214 ++++++++++++++++++++++++++++++++++++
 man/man3/xfsctl.3                  |   11 +-
 2 files changed, 221 insertions(+), 4 deletions(-)
 create mode 100644 man/man2/ioctl_xfs_fsop_geometry.2


diff --git a/man/man2/ioctl_xfs_fsop_geometry.2 b/man/man2/ioctl_xfs_fsop_geometry.2
new file mode 100644
index 00000000..4045e03b
--- /dev/null
+++ b/man/man2/ioctl_xfs_fsop_geometry.2
@@ -0,0 +1,214 @@
+.\" Copyright (c) 2019, Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0+
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-FSOP-GEOMETRY 2 2019-04-11 "XFS"
+.SH NAME
+ioctl_xfs_fsop_geometry \- report XFS filesystem shape
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY, struct xfs_fsop_geometry *" arg );
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_FSOP_GEOMETRY_V1, struct xfs_fsop_geometry_v1 *" arg );
+.SH DESCRIPTION
+Report the storage space parameters that influence allocation decisions in
+this XFS filesystem.
+This information is conveyed in a structure of the following form:
+.PP
+.in +4n
+.nf
+struct xfs_fsop_geom {
+	__u32         blocksize;
+	__u32         rtextsize;
+	__u32         agblocks;
+	__u32         agcount;
+	__u32         logblocks;
+	__u32         sectsize;
+	__u32         inodesize;
+	__u32         imaxpct;
+	__u64         datablocks;
+	__u64         rtblocks;
+	__u64         rtextents;
+	__u64         logstart;
+	unsigned char uuid[16];
+	__u32         sunit;
+	__u32         swidth;
+	__s32         version;
+	__u32         flags;
+	__u32         logsectsize;
+	__u32         rtsectsize;
+	__u32         dirblocksize;
+	/* struct xfs_fsop_geom_v1 stops here. */
+
+	__u32         logsunit;
+};
+.fi
+.in
+.PP
+.I blocksize
+is the size of a fundamental filesystem block, in bytes.
+.PP
+.I rtextsize
+is the size of an extent on the realtime volume, in bytes.
+.PP
+.I agblocks
+is the size of an allocation group, in units of filesystem blocks.
+.PP
+.I agcount
+is the number of allocation groups in the filesystem.
+.PP
+.I logblocks
+is the size of the log, in units of filesystem blocks.
+.PP
+.I sectsize
+is the smallest amount of data that can be written to the data device
+atomically, in bytes.
+.PP
+.I inodesize
+is the size of an inode record, in bytes.
+.PP
+.I imaxpct
+is the maximum percentage of the filesystem that can be allocated to inode
+record blocks.
+.PP
+.I datablocks
+is the size of the data device, in units of filesystem blocks.
+.PP
+.I rtblocks
+is the size of the realtime device, in units of filesystem blocks.
+.PP
+.I rtextents
+is the number of extents that can be allocated on the realtime device.
+This ought to be
+.RB "( " rtblocks " * " blocksize " ) / " rtextsize .
+.PP
+.I logstart
+tells the start of the log, in units of filesystem blocks.
+If the filesystem has an external log, this will be zero.
+.PP
+.I uuid
+is the universal unique identifier of the filesystem.
+.PP
+.I sunit
+is what the filesystem has been told is the size of a RAID stripe unit on the
+underlying data device, in filesystem blocks.
+.PP
+.I swidth
+is what the filesystem has been told is the width of a RAID stripe on the
+underlying data device, in units of RAID stripe units.
+.PP
+.I version
+is the version of this structure.
+This value will be XFS_FSOP_GEOM_VERSION.
+.PP
+.I flags
+tell us what features are enabled on the filesystem.
+This field can be any combination of the following:
+.RS 0.4i
+.TP
+.B XFS_FSOP_GEOM_FLAGS_ATTR
+Extended attributes are present.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_NLINK
+This filesystem supports up to 2^32 links.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_QUOTA
+Quotas are enabled.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_IALIGN
+Inodes are aligned for better performance.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_DALIGN
+Data blocks are aligned for better performance.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_SHARED
+Unused.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_EXTFLG
+Filesystem supports unwritten extents.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_DIRV2
+Directories maintain free space data for better performance.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_LOGV2
+Log uses the V2 format.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_SECTOR
+The log device has a sector size larger than 512 bytes.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_ATTR2
+Filesystem contains V2 extended attributes.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_PROJID32
+Project IDs can be as large as 2^32.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_DIRV2CI
+Case-insensitive lookups are supported on directories.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_LAZYSB
+On-disk superblock counters are updated only at unmount time.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_V5SB
+Metadata blocks are self describing and contain checksums.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_FTYPE
+Directories cache inode types in directory entries.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_FINOBT
+Filesystem maintains an index of free inodes.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_SPINODES
+Filesystem tries harder to allocate inodes when free space is fragmented.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_RMAPBT
+Filesystem stores reverse mappings of blocks to owners.
+.TP
+.B XFS_FSOP_GEOM_FLAGS_REFLINK
+Filesystem supports sharing blocks.
+.RE
+
+.PD 1
+.PP
+.I logsectsize
+is the smallest amount of data that can be written to the log device atomically,
+in bytes.
+.PP
+.I rtsectsize
+is the smallest amount of data that can be written to the realtime device
+atomically, in bytes.
+.PP
+.I dirblocksize
+is the size of directory blocks, in bytes.
+.PP
+.I logsunit
+is what the filesystem has been told is the size of a RAID stripe unit on the
+underlying log device, in filesystem blocks.
+This field is meaningful only if the flag
+.B  XFS_FSOP_GEOM_FLAGS_LOGV2
+is set.
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
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
+.B EIO
+An I/O error was encountered while performing the query.
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH SEE ALSO
+.BR ioctl (2)
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 2992b5be..1237eac6 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -479,6 +479,12 @@ the kernel, except no output count parameter is used (should
 be initialized to zero).
 An error is returned if the inode number is invalid.
 
+.TP
+.B XFS_IOC_FSGEOMETRY
+See
+.BR ioctl_xfs_fsop_geometry (2)
+for more information.
+
 .PP
 .nf
 .B XFS_IOC_THAW
@@ -494,10 +500,6 @@ An error is returned if the inode number is invalid.
 These interfaces are used to implement various filesystem internal
 operations on XFS filesystems.
 For
-.B XFS_IOC_FSGEOMETRY
-(get filesystem mkfs time information), the output structure is of type
-.BR struct xfs_fsop_geom .
-For
 .B XFS_FS_COUNTS
 (get filesystem dynamic global information), the output structure is of type
 .BR xfs_fsop_counts_t .
@@ -506,6 +508,7 @@ as they are not of general use to applications.
 
 .SH SEE ALSO
 .BR ioctl_xfs_fsgetxattr (2),
+.BR ioctl_xfs_fsop_geometry (2),
 .BR fstatfs (2),
 .BR statfs (2),
 .BR xfs (5),

