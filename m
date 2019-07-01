Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D24224413
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 01:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfETXTK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 19:19:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40050 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfETXTK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:19:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNIoYl153103;
        Mon, 20 May 2019 23:19:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=jvaXaIzrcGN23gIb1fOERyqqqwZZj91EE0GkNcxO9mI=;
 b=Mm+69ZCsabm5cM+LajzbG3NXyzve4sFSTjc2MthQoqkTVW/AzUf8qvNV/oAkksqEkrte
 6n18TwANdz0IWNiu1mlpUwVMwgzM+0rX5w9yEHuCmgvL00CIzge2IM3OS/sKPFx9zKbZ
 9olwcm8KMeLR0PXg/YSykPxmOeZot8YC/k1rrNVomtnCFh2rKjyIMPkIJf/Xp85+G+Ey
 uAkcVlUD8q4G4m+lgWJZ96TKsbRI2cYXEBZQI8pSFc5WJ3cSbjUvFO78TVcxgyJDFXY+
 ydCc1ASGrlhFlZoKFKMcqPRb3o0GyoyosfkCWFG4Bi4MyUPvHpv0b/1RovqHA7BAGwGo Lg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2sjapq9uhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:19:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNHfab124282;
        Mon, 20 May 2019 23:19:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2sks1xv9nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:19:07 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4KNJ6av031573;
        Mon, 20 May 2019 23:19:06 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 23:19:06 +0000
Subject: [PATCH 8/8] libxfs: break out GETBMAP manpage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 20 May 2019 16:19:05 -0700
Message-ID: <155839434566.68923.8410471590238448158.stgit@magnolia>
In-Reply-To: <155839428721.68923.11962490742479847985.stgit@magnolia>
References: <155839428721.68923.11962490742479847985.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200143
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a separate manual page for the BMAP ioctls so we can document how
they work.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_getbmap.2   |  165 ++++++++++++++++++++++++++++++++++++++++
 man/man2/ioctl_xfs_goingdown.2 |   61 +++++++++++++++
 man/man3/xfsctl.3              |   66 ++++------------
 3 files changed, 241 insertions(+), 51 deletions(-)
 create mode 100644 man/man2/ioctl_xfs_getbmap.2
 create mode 100644 man/man2/ioctl_xfs_goingdown.2


diff --git a/man/man2/ioctl_xfs_getbmap.2 b/man/man2/ioctl_xfs_getbmap.2
new file mode 100644
index 00000000..5097173b
--- /dev/null
+++ b/man/man2/ioctl_xfs_getbmap.2
@@ -0,0 +1,165 @@
+.\" Copyright (c) 2019, Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0+
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-GETBMAP 2 2019-04-11 "XFS"
+.SH NAME
+ioctl_xfs_getbmap \- query extent information for an open file
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_GETBMAP, struct getbmap *" arg );
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_GETBMAPA, struct getbmap *" arg );
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_GETBMAPX, struct getbmapx *" arg );
+.SH DESCRIPTION
+Get the block map for a segment of a file in an XFS file system.
+The mapping information is conveyed in a structure of the following form:
+.PP
+.in +4n
+.nf
+struct getbmap {
+	__s64   bmv_offset;
+	__s64   bmv_block;
+	__s64   bmv_length;
+	__s32   bmv_count;
+	__s32   bmv_entries;
+};
+.fi
+.in
+.PP
+The
+.B XFS_IOC_GETBMAPX
+ioctl uses a larger version of that structure:
+.PP
+.in +4n
+.nf
+struct getbmapx {
+	__s64   bmv_offset;
+	__s64   bmv_block;
+	__s64   bmv_length;
+	__s32   bmv_count;
+	__s32   bmv_entries;
+	__s32   bmv_iflags;
+	__s32   bmv_oflags;
+	__s32   bmv_unused1;
+	__s32   bmv_unused2;
+};
+.fi
+.in
+.PP
+All sizes and offsets in the structure are in units of 512 bytes.
+.PP
+The first structure in the array is a header and the remaining structures in
+the array contain block map information on return.
+The header controls iterative calls to the command and should be filled out as
+follows:
+.TP
+.B bmv_offset
+The file offset of the area of interest in the file.
+.TP
+.B bmv_length
+The length of the area of interest in the file.
+If this value is set to -1, the length of the interesting area is the rest of
+the file.
+.TP
+.B bmv_count
+The length of the array, including this header.
+.TP
+.B bmv_entries
+The number of entries actually filled in by the call.
+This does not need to be filled out before the call.
+.TP
+.B bmv_iflags
+For the
+.B XFS_IOC_GETBMAPX
+function, this is a combination of the following flags:
+.RS 0.4i
+.TP
+.B BMV_IF_ATTRFORK
+Return information about the extended attribute fork.
+.TP
+.B BMV_IF_PREALLOC
+Return information about unwritten pre-allocated segments.
+.TP
+.B BMV_IF_DELALLOC
+Return information about delayed allocation reservation segments.
+.TP
+.B BMV_IF_NO_HOLES
+Do not return information about holes.
+.RE
+.PD 1
+
+.PP
+On return from a call, the header is updated so that the command can be
+reused to obtain more information without re-initializing the structures.
+The remainder of the array will be filled out by the call as follows:
+
+.TP
+.B bmv_offset
+File offset of segment.
+.TP
+.B bmv_block
+Physical starting block of segment.
+If this is -1, then the segment is a hole.
+.TP
+.B bmv_length
+Length of segment.
+.TP
+.B bmv_oflags
+The
+.B XFS_IOC_GETBMAPX
+function will fill this field with a combination of the following flags:
+.RS 0.4i
+.TP
+.B BMV_OF_PREALLOC
+The segment is an unwritten pre-allocation.
+.TP
+.B BMV_OF_DELALLOC
+The segment is a delayed allocation reservation.
+.TP
+.B BMV_OF_LAST
+This segment is the last in the file.
+.TP
+.B BMV_OF_SHARED
+This segment shares blocks with other files.
+.RE
+.PD 1
+.PP
+The
+.B XFS_IOC_GETBMAPA
+command is identical to
+.B XFS_IOC_GETBMAP
+except that information about the attribute fork of the file is returned.
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
+.B EINVAL
+One of the arguments was not valid.
+.TP
+.B EIO
+An I/O error was encountered while performing the query.
+.TP
+.B ENOMEM
+There was insufficient memory to perform the query.
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH SEE ALSO
+.BR ioctl (2)
diff --git a/man/man2/ioctl_xfs_goingdown.2 b/man/man2/ioctl_xfs_goingdown.2
new file mode 100644
index 00000000..e9a56f28
--- /dev/null
+++ b/man/man2/ioctl_xfs_goingdown.2
@@ -0,0 +1,61 @@
+.\" Copyright (c) 2019, Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0+
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-GOINGDOWN 2 2019-04-16 "XFS"
+.SH NAME
+ioctl_xfs_goingdown \- shut down an XFS filesystem
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_GOINGDOWN, uint32_t " flags );
+.SH DESCRIPTION
+Shuts down a live XFS filesystem.
+This is a software initiated hard shutdown and should be avoided whenever
+possible.
+After this call completes, the filesystem will be totally unusable and must be
+unmounted.
+
+.PP
+.I flags
+can be one of the following:
+.RS 0.4i
+.TP
+.B XFS_FSOP_GOING_FLAGS_DEFAULT
+Flush all dirty data and in-core state to disk, flush the log, then shut down.
+.TP
+.B XFS_FSOP_GOING_FLAGS_LOGFLUSH
+Flush all pending transactions to the log, then shut down, leaving all dirty
+data unwritten.
+.TP
+.B XFS_FSOP_GOING_FLAGS_NOLOGFLUSH
+Shut down, leaving all dirty transactions and dirty data.
+
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
+.TP
+.B EFSBADCRC
+Metadata checksum validation failed while performing the query.
+.TP
+.B EFSCORRUPTED
+Metadata corruption was encountered while performing the query.
+.TP
+.B EINVAL
+The specified allocation group number is not valid for this filesystem.
+.TP
+.B EIO
+An I/O error was encountered while performing the query.
+.TP
+.B EPERM
+Caller did not have permission to shut down the filesystem.
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH SEE ALSO
+.BR ioctl (2)
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 3b84ac2b..74c502cf 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -144,59 +144,17 @@ See
 .BR ioctl_xfs_fsgetxattr (2)
 for more information.
 
-.TP
-.B XFS_IOC_GETBMAP
-Get the block map for a segment of a file in an XFS file system.
-The final argument points to an arry of variables of type
-.BR "struct getbmap" .
-All sizes and offsets in the structure are in units of 512 bytes.
-The structure fields include:
-.B bmv_offset
-(file offset of segment),
-.B bmv_block
-(starting block of segment),
-.B bmv_length
-(length of segment),
-.B bmv_count
-(number of array entries, including the first), and
-.B bmv_entries
-(number of entries filled in).
-The first structure in the array is a header, and the remaining
-structures in the array contain block map information on return.
-The header controls iterative calls to the
+.PP
+.nf
 .B XFS_IOC_GETBMAP
-command.
-The caller fills in the
-.B bmv_offset
-and
-.B bmv_length
-fields of the header to indicate the area of interest in the file,
-and fills in the
-.B bmv_count
-field to indicate the length of the array.
-If the
-.B bmv_length
-value is set to \-1 then the length of the interesting area is the rest
-of the file.
-On return from a call, the header is updated so that the command can be
-reused to obtain more information, without re-initializing the structures.
-Also on return, the
-.B bmv_entries
-field of the header is set to the number of array entries actually filled in.
-The non-header structures will be filled in with
-.BR bmv_offset ,
-.BR bmv_block ,
-and
-.BR bmv_length .
-If a region of the file has no blocks (is a hole in the file) then the
-.B bmv_block
-field is set to \-1.
-
-.TP
 .B XFS_IOC_GETBMAPA
-Identical to
-.B XFS_IOC_GETBMAP
-except that information about the attribute fork of the file is returned.
+.fi
+.PD 0
+.TP
+.B XFS_IOC_GETBMAPX
+See
+.BR ioctl_getbmap (2)
+for more information.
 
 .PP
 .B XFS_IOC_RESVSP
@@ -407,6 +365,12 @@ See
 for more information.
 Save yourself a lot of frustration and avoid these ioctls.
 
+.TP
+.B XFS_IOC_GOINGDOWN
+See
+.BR ioctl_xfs_goingdown (2)
+for more information.
+
 .PP
 .nf
 .B XFS_IOC_THAW

