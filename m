Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9924C4D439
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 18:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfFTQvf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 12:51:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44272 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbfFTQvf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:51:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGnAOU069698;
        Thu, 20 Jun 2019 16:51:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=YgXlZArZKS/T0BCQGFr6HUR8R5l5m5wkofr8sEOWKZw=;
 b=11PIwLU7UWLO4TwSj/NvZbceTNG2r7DjZ/HH2uHqOwbA0B8T5AQ4q16h+JwJlWfhu3nY
 UCaQqZ8dj5l/lSG7Tv5b8ReJaMqm4NJlK2lUf/QD0cIFmVi07rf3+xR8vJ51Z6cEf7L0
 KyqG3w6EZyk8PN1sJr1KRy4d37ZkLlm+Z9d8vn6zr6N7EBVgpFKTnt0L0RuGhbcS4LeL
 hJ0/KnVDICHNhzaxcqMtLn6PG8RjkEg1lVmelIErp9JRJsW2yW5LNBMqZZaxT0OZCNY6
 EzyoDofu4yxHFps+DKJ7IYFr7H0Pcei67e5ULK5gwtzzzjFeAd9Pc5RrV/DHMGGi/Ygs DQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t7809j9vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:51:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGnkbJ058056;
        Thu, 20 Jun 2019 16:51:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t77ynqq07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:51:32 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5KGpV9h013596;
        Thu, 20 Jun 2019 16:51:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 09:51:31 -0700
Subject: [PATCH 6/9] man: create a separate FSCOUNTS ioctl manpage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 20 Jun 2019 09:51:26 -0700
Message-ID: <156104948638.1174403.13393187882783073949.stgit@magnolia>
In-Reply-To: <156104944877.1174403.14568482035189263260.stgit@magnolia>
References: <156104944877.1174403.14568482035189263260.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906200122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906200122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a separate manual page for the xfs FSCOUNTS ioctl so we can
document how it works.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_fscounts.2 |   69 +++++++++++++++++++++++++++++++++++++++++
 man/man3/xfsctl.3             |   14 +++++---
 2 files changed, 77 insertions(+), 6 deletions(-)
 create mode 100644 man/man2/ioctl_xfs_fscounts.2


diff --git a/man/man2/ioctl_xfs_fscounts.2 b/man/man2/ioctl_xfs_fscounts.2
new file mode 100644
index 00000000..eb7df89c
--- /dev/null
+++ b/man/man2/ioctl_xfs_fscounts.2
@@ -0,0 +1,69 @@
+.\" Copyright (c) 2019, Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0+
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-FSCOUNTS 2 2019-06-17 "XFS"
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
+alterations or limits set by project quotas.
+The counter information is conveyed in a structure of the following form:
+.PP
+.in +4n
+.nf
+struct xfs_fsop_counts {
+	__u64   freedata;
+	__u64   freertx;
+	__u64   freeino;
+	__u64   allocino;
+};
+.fi
+.in
+.PP
+The fields of this structure are as follows:
+.PP
+.I freedata
+is the number of free filesystem blocks on the data device.
+.PP
+.I freertx
+is the number of free extents on the realtime device.
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
index c14f7d33..ee3188ec 100644
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
 
@@ -417,6 +418,7 @@ as they are not of general use to applications.
 .BR ioctl_xfs_fsbulkstat (2),
 .BR ioctl_xfs_scrub_metadata (2),
 .BR ioctl_xfs_fsinumbers (2),
+.BR ioctl_xfs_fscounts (2),
 .BR fstatfs (2),
 .BR statfs (2),
 .BR xfs (5),

