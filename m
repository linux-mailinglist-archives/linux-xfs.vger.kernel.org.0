Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08CA3395A1
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 21:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbfFGTaC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Jun 2019 15:30:02 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46108 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730285AbfFGT34 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 15:29:56 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JSTT4101063;
        Fri, 7 Jun 2019 19:29:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=tAQPRBpnioREvLDBdvWpQdt+dZcK3dL9Wm/Zcvbs5DI=;
 b=wdpfVxwAJ08o3/QFxMDG/a2pmmAIoePVXcdGCfWR7RG+Av1BFvXfzuk7uU0hr2QGsNE5
 kgelaVIDgJPmLMRPbNjU3ffCOet44s0h9J7UozFKoZCNjLoxJ95bBuamHfth1ehvjIMZ
 T804iQ+6klDKVaJrA8PTXtL5ScBJkTwKjTti9c9VgM+1F/o3wd7tdeITreHYIZ0BFh8Y
 ZGABkGoAbzhbQsc7Dza6BWGQ4/B/J+rsHmRFeTyokqCYuv6vjJn1gqNVCpaWoIxe9PRN
 EymtgXUkJpc1yG+lFEP3+jH6YJws9BghXKXkTnrgasHfpK0NIcfIL54780VsSddo2t8Q 6g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2sueve0efs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:29:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JT84x170596;
        Fri, 7 Jun 2019 19:29:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2swngn8af7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:29:53 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x57JTq10015591;
        Fri, 7 Jun 2019 19:29:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Jun 2019 12:29:52 -0700
Subject: [PATCH 8/9] libxfs: break out GETBMAP manpage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 07 Jun 2019 12:29:51 -0700
Message-ID: <155993579119.2343530.16520349159321377883.stgit@magnolia>
In-Reply-To: <155993574034.2343530.12919951702156931143.stgit@magnolia>
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906070130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906070130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a separate manual page for the BMAP ioctls so we can document how
they work.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_getbmap.2 |  165 ++++++++++++++++++++++++++++++++++++++++++
 man/man3/xfsctl.3            |   61 +++-------------
 2 files changed, 175 insertions(+), 51 deletions(-)
 create mode 100644 man/man2/ioctl_xfs_getbmap.2


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
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 25e51417..e0986afb 100644
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
@@ -428,6 +386,7 @@ as they are not of general use to applications.
 .BR ioctl_xfs_fsinumbers (2),
 .BR ioctl_xfs_fscounts (2),
 .BR ioctl_xfs_getresblks (2),
+.BR ioctl_xfs_getbmap (2),
 .BR fstatfs (2),
 .BR statfs (2),
 .BR xfs (5),

