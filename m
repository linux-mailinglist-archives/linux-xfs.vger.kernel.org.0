Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290D724411
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 01:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfETXTE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 19:19:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39964 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfETXTE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:19:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNIe9g152410;
        Mon, 20 May 2019 23:19:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=BgAmkezUA63JCceB1W17eLxQVyNu3+QnfcEyYCkfmj4=;
 b=5baotXNILOr6Z21x0CkWAyFaopitEBMIebUIbCEOGhB44usTP3YL1BICGgkJVM5RaXI2
 Yq1q7ly+KDBe8sWltfXYcRhvOxCO8yvpXdq4OsKk0XskxOWGHvlpTkL2RTUGm19KM4tW
 er2AFMmQx7A4pkx49VfIWTXsblE/PAOURuUEnLhBHB2tChjSkLvZLOZW179NWR4xK6HF
 cmBF1uyqueGelq9BsTVCMRynpk7+cF80U6nYrispquo1V3jOlLTJurDrQW30LUKnPhqy
 4bxglUatO4k1urxULGPQg4TRRxX3ssgIN1SQYb8bxUVbC0XujH1otIWoUyi2xF+9VpAj fA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2sjapq9uh3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:19:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNIIFL079631;
        Mon, 20 May 2019 23:19:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2skudb29ja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:19:01 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4KNJ0rN031285;
        Mon, 20 May 2019 23:19:00 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 23:19:00 +0000
Subject: [PATCH 7/8] libxfs: break out the RESBLKS manpage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 20 May 2019 16:18:51 -0700
Message-ID: <155839433185.68923.4176524000480709248.stgit@magnolia>
In-Reply-To: <155839428721.68923.11962490742479847985.stgit@magnolia>
References: <155839428721.68923.11962490742479847985.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=942
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200143
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=984 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a separate manual page for the RESBLKS ioctls so we can document
how they work.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_getresblks.2 |   65 +++++++++++++++++++++++++++++++++++++++
 man/man3/xfsctl.3               |   13 +++++++-
 2 files changed, 76 insertions(+), 2 deletions(-)
 create mode 100644 man/man2/ioctl_xfs_getresblks.2


diff --git a/man/man2/ioctl_xfs_getresblks.2 b/man/man2/ioctl_xfs_getresblks.2
new file mode 100644
index 00000000..57533927
--- /dev/null
+++ b/man/man2/ioctl_xfs_getresblks.2
@@ -0,0 +1,65 @@
+.\" Copyright (c) 2019, Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0+
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-GETRESBLKS 2 2019-04-16 "XFS"
+.SH NAME
+ioctl_xfs_getresblks \- query XFS summary counter information
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_GET_RESBLKS, struct xfs_fsop_resblks *" arg );
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_SET_RESBLKS, struct xfs_fsop_resblks *" arg );
+.SH DESCRIPTION
+Query or set the free space reservation information.
+These blocks are reserved by the filesystem as a last-ditch attempt to prevent
+metadata update failures due to insufficient space.
+Only the system administrator can call these ioctls, because overriding the
+defaults is extremely dangerous and should never be tried by anyone.
+.PP
+The reservation information is conveyed in a structure of the following form:
+.PP
+.in +4n
+.nf
+struct xfs_fsop_resblks {
+	__u64  resblks;
+	__u64  resblks_avail;
+};
+.fi
+.in
+.PP
+.I resblks
+is the number of blocks that the filesystem will try to maintain to prevent
+critical out of space situations.
+.PP
+.I resblks_avail
+is the number of reserved blocks remaining.
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
+Caller does not have permission to call this ioctl.
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH SEE ALSO
+.BR ioctl (2)
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 9b8b52f4..3b84ac2b 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -396,12 +396,21 @@ See
 .BR ioctl_xfs_fscounts (2)
 for more information.
 
+.TP
+.nf
+.B XFS_IOC_GET_RESBLKS
+.fi
+.TP
+.B XFS_IOC_SET_RESBLKS
+See
+.BR ioctl_xfs_getresblks (2)
+for more information.
+Save yourself a lot of frustration and avoid these ioctls.
+
 .PP
 .nf
 .B XFS_IOC_THAW
 .B XFS_IOC_FREEZE
-.B XFS_IOC_GET_RESBLKS
-.B XFS_IOC_SET_RESBLKS
 .B XFS_IOC_FSGROWFSDATA
 .B XFS_IOC_FSGROWFSLOG
 .fi

