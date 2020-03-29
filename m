Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32064196EA2
	for <lists+linux-xfs@lfdr.de>; Sun, 29 Mar 2020 19:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgC2RWO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 29 Mar 2020 13:22:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36968 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgC2RWO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Mar 2020 13:22:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02THJKvJ107383
        for <linux-xfs@vger.kernel.org>; Sun, 29 Mar 2020 17:22:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=eeH4X6NOjJ5QM3YfIeylChVVPAtSVxzZ/NSdTu8b5Gg=;
 b=CHEpD+ReQ7O2g8FtCE+Gna3YAUgcq9xmpMhPkSYvMX3xzIXXbdkVlICSzQqFL+1XiOPQ
 4zposULQz5E5+xVa1NMkEntOMophL6Bj9AVJomi0wVUoO07c4fEMna1l/Qki/+eGr5NJ
 aO4RqqHBPNPKeKM+cgtB33EJNQKftIZ8ID/lyIMR9lB/zP/0uZn79Br03ZPTdXtT2uTs
 7SBL/96n0PvY7bV+qHkfyDijSdd8q0HtssTcISbhA20+yKi3Fz/iw/9R5znhs2Wut2z7
 TexJ6/a277M5GN5xWXyFuqEVzqEEPpw4Za3UWbdnxwsXLP3HzZ/Che8lyfvALozzGlk2 Dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 301xhkkhe3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 29 Mar 2020 17:22:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02THKop6107404
        for <linux-xfs@vger.kernel.org>; Sun, 29 Mar 2020 17:22:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 302g2a6nhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 29 Mar 2020 17:22:11 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02THMAvK024195
        for <linux-xfs@vger.kernel.org>; Sun, 29 Mar 2020 17:22:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 29 Mar 2020 10:22:10 -0700
Date:   Sun, 29 Mar 2020 10:22:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: ratelimit inode flush on buffered write ENOSPC
Message-ID: <20200329172209.GA80283@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9575 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=2 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003290163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9575 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=2 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 clxscore=1015 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003290163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

A customer reported rcu stalls and softlockup warnings on a computer
with many CPU cores and many many more IO threads trying to write to a
filesystem that is totally out of space.  Subsequent analysis pointed to
the many many IO threads calling xfs_flush_inodes -> sync_inodes_sb,
which causes a lot of wb_writeback_work to be queued.  The writeback
worker spends so much time trying to wake the many many threads waiting
for writeback completion that it trips the softlockup detector, and (in
this case) the system automatically reboots.

In addition, they complain that the lengthy xfs_flush_inodes scan traps
all of those threads in uninterruptible sleep, which hampers their
ability to kill the program or do anything else to escape the situation.

If there's thousands of threads trying to write to files on a full
filesystem, each of those threads will start separate copies of the
inode flush scan.  This is kind of pointless since we only need one
scan, so rate limit the inode flush.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_mount.h |    1 +
 fs/xfs/xfs_super.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 88ab09ed29e7..50c43422fa17 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -167,6 +167,7 @@ typedef struct xfs_mount {
 	struct xfs_kobj		m_error_meta_kobj;
 	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
 	struct xstats		m_stats;	/* per-fs stats */
+	struct ratelimit_state	m_flush_inodes_ratelimit;
 
 	struct workqueue_struct *m_buf_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 68fea439d974..abf06bf9c3f3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -528,6 +528,9 @@ xfs_flush_inodes(
 {
 	struct super_block	*sb = mp->m_super;
 
+	if (!__ratelimit(&mp->m_flush_inodes_ratelimit))
+		return;
+
 	if (down_read_trylock(&sb->s_umount)) {
 		sync_inodes_sb(sb);
 		up_read(&sb->s_umount);
@@ -1366,6 +1369,17 @@ xfs_fc_fill_super(
 	if (error)
 		goto out_free_names;
 
+	/*
+	 * Cap the number of invocations of xfs_flush_inodes to 16 for every
+	 * quarter of a second.  The magic numbers here were determined by
+	 * observation neither to cause stalls in writeback when there are a
+	 * lot of IO threads and the fs is near ENOSPC, nor cause any fstest
+	 * regressions.  YMMV.
+	 */
+	ratelimit_state_init(&mp->m_flush_inodes_ratelimit, HZ / 4, 16);
+	ratelimit_set_flags(&mp->m_flush_inodes_ratelimit,
+			RATELIMIT_MSG_ON_RELEASE);
+
 	error = xfs_init_mount_workqueues(mp);
 	if (error)
 		goto out_close_devices;
