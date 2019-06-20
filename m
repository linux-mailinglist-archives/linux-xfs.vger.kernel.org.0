Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 778A64D43F
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 18:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfFTQvy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 12:51:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44668 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfFTQvx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 12:51:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGnGaZ069756;
        Thu, 20 Jun 2019 16:51:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=mofIEMK4vNTkcKxCjRoez17o39I3+bIzNe25rfxM00g=;
 b=oVMjYY6B/ccFk7QqeS68YCuj4YbJFPpQ4vwSD4CcNIKTOOxCdyt1gdAobqZJzoVP31J5
 F8ghngUYtF0n48Uy7Ii0tpuZIE7sHt+QHQ1BI4juJokxgSeZ7aWTrGM8VZ4p5TJY7laq
 9Nfs7U+L/06IKVKxvThkDHMdIVRn6I9YMrFoPlht00J/m++2YQshcj8I1Cj1Hs+kZfnE
 mYnQcxfBQrSKMAo69WhYJFTBmed3DsOtA8OtXhbzUDj4wS6bbPfA9H4P0jCjOT+f5boN
 YqbVA3DEg02psJgD+XcjMByuV35XxlGJKvZLBWiqIEV3MT35LcDZIadqyzkK+0XgoHAR Xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2t7809j9x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:51:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KGpIoD187377;
        Thu, 20 Jun 2019 16:51:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2t7rdx93g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 16:51:50 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5KGpo6i021996;
        Thu, 20 Jun 2019 16:51:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 09:51:50 -0700
Subject: [PATCH 9/9] man: create a separate xfs shutdown ioctl manpage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 20 Jun 2019 09:51:49 -0700
Message-ID: <156104950912.1174403.4990641877651635072.stgit@magnolia>
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

Create a separate manual page for the xfs shutdown ioctl so we can
document how it works.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_goingdown.2 |   63 ++++++++++++++++++++++++++++++++++++++++
 man/man3/xfsctl.3              |    7 ++++
 2 files changed, 70 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_goingdown.2


diff --git a/man/man2/ioctl_xfs_goingdown.2 b/man/man2/ioctl_xfs_goingdown.2
new file mode 100644
index 00000000..bedc85c8
--- /dev/null
+++ b/man/man2/ioctl_xfs_goingdown.2
@@ -0,0 +1,63 @@
+.\" Copyright (c) 2019, Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0+
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-GOINGDOWN 2 2019-06-17 "XFS"
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
+Flush all dirty data and in-core state to disk, flush pending transactions to
+the log, and shut down.
+.TP
+.B XFS_FSOP_GOING_FLAGS_LOGFLUSH
+Flush all pending transactions to the log and shut down, leaving all dirty
+data unwritten.
+.TP
+.B XFS_FSOP_GOING_FLAGS_NOLOGFLUSH
+Shut down immediately, without writing pending transactions or dirty data
+to disk.
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
index 077dd411..7e6588b8 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -365,6 +365,12 @@ See
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
@@ -388,6 +394,7 @@ as they are not of general use to applications.
 .BR ioctl_xfs_fscounts (2),
 .BR ioctl_xfs_getresblks (2),
 .BR ioctl_xfs_getbmap (2),
+.BR ioctl_xfs_goingdown (2),
 .BR fstatfs (2),
 .BR statfs (2),
 .BR xfs (5),

