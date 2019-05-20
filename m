Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 001BB2440F
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 01:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfETXSu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 19:18:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39722 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfETXSu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:18:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNImfC152848;
        Mon, 20 May 2019 23:18:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=+mipagl2tU1Zequq2RatLprDiR6zY0jVj5YvciotZzM=;
 b=gc9ELDn8O7F1vikoqtldbuVOzkBZRQTWLmrZ/xNQyhLnBcpwMpmLVgVSkdzCtfHMn9Mz
 LOYWd4MkPlrDEJPI4607Rjw6fBwzsiwK+d4iKdy7EnoEbHBkOQ3wp61lAd3AjGz+3MdW
 hMIJXIwZLmV25lnFk/EzHE6qh9aebbhRBKLksoiFyGGzCYwHEiqwLEfQ4YWXW3uc8kG4
 cT7K9x7m2jbvfac1TosfzVA2j6VOaKg3zep3X0Df0sU+AF4q4qrVKE6AbEi/kJD4r869
 8uK81DyBg8DjFI3wcHBtylRS8Arf91yN4+IfThTIyctbMIdTG5IV9CXD64qBhsZBqwtx Ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2sjapq9ufv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:18:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNI5qv154255;
        Mon, 20 May 2019 23:18:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2sm046n4x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:18:47 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4KNIkCm029934;
        Mon, 20 May 2019 23:18:46 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 23:18:46 +0000
Subject: [PATCH 6/8] libxfs: break out FSCOUNTS manpage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 20 May 2019 16:18:45 -0700
Message-ID: <155839432577.68923.82903957299262051.stgit@magnolia>
In-Reply-To: <155839428721.68923.11962490742479847985.stgit@magnolia>
References: <155839428721.68923.11962490742479847985.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200143
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a separate manual page for the FSCOUNTS ioctl so we can document
how it works.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_fscounts.2 |   67 +++++++++++++++++++++++++++++++++++++++++
 man/man3/xfsctl.3             |   13 ++++----
 2 files changed, 74 insertions(+), 6 deletions(-)
 create mode 100644 man/man2/ioctl_xfs_fscounts.2


diff --git a/man/man2/ioctl_xfs_fscounts.2 b/man/man2/ioctl_xfs_fscounts.2
new file mode 100644
index 00000000..44b214a1
--- /dev/null
+++ b/man/man2/ioctl_xfs_fscounts.2
@@ -0,0 +1,67 @@
+.\" Copyright (c) 2019, Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0+
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-FSCOUNTS 2 2019-04-16 "XFS"
+.SH NAME
+ioctl_xfs_fscounts \- query XFS summary counter information
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_FSCOUNTS, struct xfs_fsop_counts *" arg );
+.SH DESCRIPTION
+Query the raw filesystem summary counters.
+Unlike
+.BR statvfs (3),
+the values returned here are the raw values, which do not reflect any
+alterations or limits set by quotas.
+The counter information is conveyed in a structure of the following form:
+.PP
+.in +4n
+.nf
+struct xfs_fscounts {
+	__u64   freedata;
+	__u64   freertx;
+	__u64   freeino;
+	__u64   allocino;
+};
+.fi
+.in
+.PP
+.I freedata
+is the number of free filesystem blocks on the data device.
+.PP
+.I freertx
+is the number of free xtents on the realtime device.
+.PP
+.I freeino
+is the number of inode records that are not in use within the space that has
+been allocated for them.
+.PP
+.I allocino
+is the number of inode records for which space has been allocated.
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
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH SEE ALSO
+.BR ioctl (2)
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index dab4243d..9b8b52f4 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -390,6 +390,12 @@ See
 .BR ioctl_xfs_scrub_metadata (2)
 for more information.
 
+.TP
+.B XFS_IOC_FSCOUNTS
+See
+.BR ioctl_xfs_fscounts (2)
+for more information.
+
 .PP
 .nf
 .B XFS_IOC_THAW
@@ -398,16 +404,11 @@ for more information.
 .B XFS_IOC_SET_RESBLKS
 .B XFS_IOC_FSGROWFSDATA
 .B XFS_IOC_FSGROWFSLOG
-.B XFS_IOC_FSGROWFSRT
 .fi
 .TP
-.B XFS_IOC_FSCOUNTS
+.B XFS_IOC_FSGROWFSRT
 These interfaces are used to implement various filesystem internal
 operations on XFS filesystems.
-For
-.B XFS_FS_COUNTS
-(get filesystem dynamic global information), the output structure is of type
-.BR xfs_fsop_counts_t .
 The remainder of these operations will not be described further
 as they are not of general use to applications.
 

