Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC44864AF
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Aug 2019 16:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfHHOr0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 8 Aug 2019 10:47:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48816 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbfHHOr0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Aug 2019 10:47:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x78EhtoU084336;
        Thu, 8 Aug 2019 14:47:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=h8wz7GdQeZwfj80I6bv8Nh3YB7Has2GVytC0FcQ3RGQ=;
 b=aq75UDlhy/iAsd2BbQ9dSzEyxP4K1XkhcKYHHL7TgjV0iIsCh9wZU/l8m1S9/tZIWl/9
 DMEq4JZtAfXwuX/U4FFH8qHBn2KjmK3/apO99lZXBINRcWkHKq+qB2G8Y/f/+2sSwVzs
 2DOzfasqhbc13/n1VZGrO2b800+r9IesamXDp5W/jcng5kjIN2B5QrW6JNQBad5f09Xa
 IadZly+aViqQxT7CmaztpjI1CVmWn08RrKa9pvvVaWE8tmmf2/A3xULD9McPSJtRD9fm
 U40tMzJswbE0dwxdfU0baVZmqHRB3GJpYIrvbc7Pg68X4aDlgCKqynL7ZnXZl6aQYQKB 0g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=h8wz7GdQeZwfj80I6bv8Nh3YB7Has2GVytC0FcQ3RGQ=;
 b=uLUbX4//KkMvJkd0/jvlkdLjMpmNyB1yiIOEM1sUzotqkBCAJG0erTqhdpICWTLTCdMq
 fF2EWrSzXWFVdEuInDY1wgQD1mZnZbPPzXSJ/p0CZ6XHdt91cAqAN7rQ9Op/sTofPolt
 BMS69mSo2y3oVItwm09U0uRtP/U8CWC2aR5qkn7fgr1hAtnmv6KUpozwdJyVKVTaJg4e
 N7XEPjiDEHN39DUlkAGp94TpGRCDlHK8ShOBL7dCJxAPmFvfspNASF/LgEDo2BFqhnmC
 BEZSLCgIPxIS3L5Xn1aDzSWq4B/wweMqcFyy0fE6tonHaZyIEdIbdvNvu08IoIpF2Vs5 gA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u8hgp1qat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 14:47:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x78EgwTp170802;
        Thu, 8 Aug 2019 14:47:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u763kef5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 14:47:10 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x78El9kE015120;
        Thu, 8 Aug 2019 14:47:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Aug 2019 07:47:09 -0700
Subject: [PATCH 3/3] xfs: don't crash on null attr fork xfs_bmapi_read
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Zorro Lang <zlang@redhat.com>
Date:   Thu, 08 Aug 2019 07:47:08 -0700
Message-ID: <156527562842.1960675.5982698585427580223.stgit@magnolia>
In-Reply-To: <156527561023.1960675.17007470833732765300.stgit@magnolia>
References: <156527561023.1960675.17007470833732765300.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908080147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908080147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Zorro Lang reported a crash in generic/475 if we try to inactivate a
corrupt inode with a NULL attr fork (stack trace shortened somewhat):

RIP: 0010:xfs_bmapi_read+0x311/0xb00 [xfs]
RSP: 0018:ffff888047f9ed68 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888047f9f038 RCX: 1ffffffff5f99f51
RDX: 0000000000000002 RSI: 0000000000000008 RDI: 0000000000000012
RBP: ffff888002a41f00 R08: ffffed10005483f0 R09: ffffed10005483ef
R10: ffffed10005483ef R11: ffff888002a41f7f R12: 0000000000000004
R13: ffffe8fff53b5768 R14: 0000000000000005 R15: 0000000000000001
FS:  00007f11d44b5b80(0000) GS:ffff888114200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000ef6000 CR3: 000000002e176003 CR4: 00000000001606e0
Call Trace:
 xfs_dabuf_map.constprop.18+0x696/0xe50 [xfs]
 xfs_da_read_buf+0xf5/0x2c0 [xfs]
 xfs_da3_node_read+0x1d/0x230 [xfs]
 xfs_attr_inactive+0x3cc/0x5e0 [xfs]
 xfs_inactive+0x4c8/0x5b0 [xfs]
 xfs_fs_destroy_inode+0x31b/0x8e0 [xfs]
 destroy_inode+0xbc/0x190
 xfs_bulkstat_one_int+0xa8c/0x1200 [xfs]
 xfs_bulkstat_one+0x16/0x20 [xfs]
 xfs_bulkstat+0x6fa/0xf20 [xfs]
 xfs_ioc_bulkstat+0x182/0x2b0 [xfs]
 xfs_file_ioctl+0xee0/0x12a0 [xfs]
 do_vfs_ioctl+0x193/0x1000
 ksys_ioctl+0x60/0x90
 __x64_sys_ioctl+0x6f/0xb0
 do_syscall_64+0x9f/0x4d0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f11d39a3e5b

The "obvious" cause is that the attr ifork is null despite the inode
claiming an attr fork having at least one extent, but it's not so
obvious why we ended up with an inode in that state.

Reported-by: Zorro Lang <zlang@redhat.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204031
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index baf0b72c0a37..07aad70f3931 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3835,15 +3835,28 @@ xfs_bmapi_read(
 	XFS_STATS_INC(mp, xs_blk_mapr);
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
+	if (!ifp) {
+		/* No CoW fork?  Return a hole. */
+		if (whichfork == XFS_COW_FORK) {
+			mval->br_startoff = bno;
+			mval->br_startblock = HOLESTARTBLOCK;
+			mval->br_blockcount = len;
+			mval->br_state = XFS_EXT_NORM;
+			*nmap = 1;
+			return 0;
+		}
 
-	/* No CoW fork?  Return a hole. */
-	if (whichfork == XFS_COW_FORK && !ifp) {
-		mval->br_startoff = bno;
-		mval->br_startblock = HOLESTARTBLOCK;
-		mval->br_blockcount = len;
-		mval->br_state = XFS_EXT_NORM;
-		*nmap = 1;
-		return 0;
+		/*
+		 * A missing attr ifork implies that the inode says we're in
+		 * extents or btree format but failed to pass the inode fork
+		 * verifier while trying to load it.  Treat that as a file
+		 * corruption too.
+		 */
+#ifdef DEBUG
+		xfs_alert(mp, "%s: inode %llu missing fork %d",
+				__func__, ip->i_ino, whichfork);
+#endif /* DEBUG */
+		return -EFSCORRUPTED;
 	}
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {

