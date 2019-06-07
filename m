Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93219395A0
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 21:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbfFGTaB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Jun 2019 15:30:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44648 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730198AbfFGTaB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 15:30:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JSxIn078602;
        Fri, 7 Jun 2019 19:29:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=ufd4Bebwb15DeRl+TSwPA28YLnM+SlrvbvMOoKLqUHU=;
 b=0E9z6yc4E9uyjkbpX6DEGXow6RwX22RxqCSZM6aGhtZEAhTmo4LkMYeLiR+6OWZNgixF
 BtIWtvI2GCeR+p8IOlkQNyYRdPcJjPypo+cq4oCv7nzPXj13uTQ+PRggbOyTtYOOpH6d
 aYba3NOFr00G8SVz1syGVWJNST59OTwM0WTAb1Os/icV58Mqco2WryntKgWvEXB9cqnx
 XpbkUEde6W3Wghk1cMN++z1bvqG+D1IoZq6/lotgG8cqSFkCRl1Y9bsdWxoRHRA2B8Pl
 tPY8xcrbL+NS2BeybJnSQ20r/L5O5+98eAaS96fiP9E0NTD2bcXGD2iYzYhGJ7llpRwp ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2sugsu0626-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:29:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JT7Du170555;
        Fri, 7 Jun 2019 19:29:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2swngn8agk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:29:59 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x57JTwpE015626;
        Fri, 7 Jun 2019 19:29:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Jun 2019 12:29:58 -0700
Subject: [PATCH 9/9] libxfs: break out fs shutdown manpage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 07 Jun 2019 12:29:57 -0700
Message-ID: <155993579746.2343530.1053923086240021800.stgit@magnolia>
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

Create a separate manual page for the fs shutdown ioctl so we can
document how it works.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_goingdown.2 |   61 ++++++++++++++++++++++++++++++++++++++++
 man/man3/xfsctl.3              |    7 +++++
 2 files changed, 68 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_goingdown.2


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
index e0986afb..ca96a007 100644
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
@@ -387,6 +393,7 @@ as they are not of general use to applications.
 .BR ioctl_xfs_fscounts (2),
 .BR ioctl_xfs_getresblks (2),
 .BR ioctl_xfs_getbmap (2),
+.BR ioctl_xfs_goingdown (2),
 .BR fstatfs (2),
 .BR statfs (2),
 .BR xfs (5),

