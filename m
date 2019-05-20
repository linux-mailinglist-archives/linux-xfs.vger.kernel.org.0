Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C223424431
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 01:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfETXUp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 19:20:45 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40164 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727173AbfETXUo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:20:44 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNIctv153047;
        Mon, 20 May 2019 23:20:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=x1uGlPq2JxFyHvifcb9+xj5OxQMgedgCnuRNTAgQygY=;
 b=C5peH0yJwxcjhefhFFn2QET9/YEqk/tSwIzcaYNOW4SxXPw01UMrW9Vn88fGQxbVjuSB
 0YOX3w//nW0te+X01fO9m0Zziz+N3uqfsRINfaByFu2q6OSFy1UJQmkmQhdpfTx5ihBP
 utRF++xrA7RBXfI9rzRKD3IIdRn10L6pNp87VKwUdGXhyu50CECqPlJNrl62jARjQbX+
 LmcR/XnO2olCoB+718lMPsg3zZC3yX5EfCbgPtk5hd15xkW9u+P/QLVDVPDcG1/aYU5J
 8KF1jjdrWhwJlHHFoAvSJmJowOMaMXXy/XXd6gNS8vdtSkmGXUu60DPcWHlEf77kEA7a /A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2sj7jdj5xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:20:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNIG2d079381;
        Mon, 20 May 2019 23:18:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2skudb29b6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:18:41 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4KNIeQP022822;
        Mon, 20 May 2019 23:18:40 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 23:18:40 +0000
Subject: [PATCH 5/8] libxfs: break out the INUMBERS manpage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 20 May 2019 16:18:39 -0700
Message-ID: <155839431959.68923.5655229761721642.stgit@magnolia>
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

Create a separate manual page for the INUMBERS ioctl so we can document
how it works.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man2/ioctl_xfs_fsinumbers.2 |  114 +++++++++++++++++++++++++++++++++++++++
 man/man3/xfsctl.3               |   33 +----------
 2 files changed, 117 insertions(+), 30 deletions(-)
 create mode 100644 man/man2/ioctl_xfs_fsinumbers.2


diff --git a/man/man2/ioctl_xfs_fsinumbers.2 b/man/man2/ioctl_xfs_fsinumbers.2
new file mode 100644
index 00000000..b0636f01
--- /dev/null
+++ b/man/man2/ioctl_xfs_fsinumbers.2
@@ -0,0 +1,114 @@
+.\" Copyright (c) 2019, Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0+
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-FSINUMBERS 2 2019-04-16 "XFS"
+.SH NAME
+ioctl_xfs_fsinumbers \- extract a list of valid inode numbers from an XFS filesystem
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_FSINUMBERS, struct xfs_fsop_bulkreq *" arg );
+.SH DESCRIPTION
+Query a list of valid inode numbers from an XFS filesystem.
+It is intended to be called iteratively to obtain the entire set of inodes.
+These ioctls use
+.B struct xfs_fsop_bulkreq
+to set up a bulk transfer with the kernel:
+.PP
+.in +4n
+.nf
+struct xfs_fsop_bulkreq {
+	__u64   *lastip;
+	__s32   count;
+	void    *ubuffer;
+	__s32   *ocount;
+};
+.fi
+.in
+.PP
+.I lastip
+points to a value that will receive the number of the "last inode".
+Prior to the call, this value should be set to one less than the number of the
+first inode for which the caller wants information.
+After the call, this value will be set to the number of the last inode for
+which information is supplied.
+This field will not be updated if
+.I ocount
+is NULL.
+.PP
+.I count
+is the number of inodes to examine.
+.PP
+.I ocount
+points to a value that will receive the number of records returned.
+An output value of zero means that there are no more inodes left to enumerate.
+If this value is NULL, then neither
+.I ocount
+nor
+.I lastip
+will be updated.
+.PP
+.I ubuffer
+points to a memory buffer where information will be copied.
+This buffer must be an array of
+.B struct xfs_inogrp
+which is described below.
+The array must have at least
+.I count
+elements.
+.PP
+.in +4n
+.nf
+struct xfs_inogrp {
+	__u64   xi_startino;
+	__s32   xi_alloccount;
+	__u64   xi_allocmask;
+}
+.fi
+.in
+.PP
+.I xi_startino
+is the number of this inode numbers record.
+Each inode numbers record will correspond roughly to a record in the inode
+btree, though this is not guaranteed.
+.PP
+.I xi_alloccount
+is the number of bits that are set in
+.IR xi_allocmask .
+.PP
+.I xi_allocmask
+is the mask of inodes that are in use for this inode.
+The bitmask is 64 bits long, and the least significant bit corresponds to inode
+.BR xi_startino .
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
index 1e98b2a4..dab4243d 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -368,36 +368,9 @@ can be any open file in the XFS filesystem in question.
 .PP
 .TP
 .B XFS_IOC_FSINUMBERS
-This interface is used to extract a list of valid inode numbers from an
-XFS filesystem.
-It is intended to be called iteratively, to obtain the entire set of inodes.
-The information is passed in and out via a structure of type
-.B xfs_fsop_bulkreq_t
-pointed to by the final argument.
-.B lastip
-is a pointer to a variable containing the last inode number returned,
-initially it should be zero.
-.B icount
-is the size of the array of structures specified by
-.BR ubuffer .
-.B ubuffer
-is the address of an array of structures, of type
-.BR xfs_inogrp_t .
-This structure has the following elements:
-.B xi_startino
-(starting inode number),
-.B xi_alloccount
-(count of bits set in xi_allocmask), and
-.B xi_allocmask
-(mask of allocated inodes in this group).
-The bitmask is 64 bits long, and the least significant bit corresponds to inode
-.B xi_startino.
-Each bit is set if the corresponding inode is in use.
-.B ocount
-is a pointer to a count of returned values, filled in by the call.
-An output
-.B ocount
-value of zero means that the inode table has been exhausted.
+See
+.BR ioctl_xfs_fsinumbers (2)
+for more information.
 
 .TP
 .B XFS_IOC_FSGEOMETRY

