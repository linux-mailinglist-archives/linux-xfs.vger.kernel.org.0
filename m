Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79554191FB6
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Mar 2020 04:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgCYDYl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Mar 2020 23:24:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44336 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbgCYDYk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 23:24:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P3OLEV064951
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GV3u8ZB9rd6XdoxvlPmMMsTGrCGwGwJqHaILmTHWqFM=;
 b=LKoWcNO3rSOsZHMDKPyIL5tIU7kT+yjYGif1EnVOi2g5cp+v9+3IjwBbLdqSFgydQCDL
 uInyzsZDwkBJIyIZIoUG4zLBcUOP5XBqfFzl6Wb3R8LEQ4NfOgbOlU1qkWBSE1vmnxHE
 ic5w9U9r9Mwe8qmQQws2BqC1iACuhe7jjSk0epjoqLvrYMH+/qlMHPXNjxnyPTRMxiir
 sST044/RWadajrHzmQcr4cB/PbnAvFQ17cinzlLOpjYHFEUXQzTvU0M1jvB0tvcQBTln
 wQJHx2D7s0la2JTr4/VzdxZ2A8dJLmSYMvrCQDv41RYbKBMO6U4wiN2SrmVp0Pfmz5kK Zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yx8ac4j5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P3NZJm139070
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2yxw6p0nm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:38 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02P3Oc06000571
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 20:24:37 -0700
Subject: [PATCH 1/4] xfs: prohibit fs freezing when using empty transactions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 24 Mar 2020 20:24:36 -0700
Message-ID: <158510667670.922633.9371387481128286027.stgit@magnolia>
In-Reply-To: <158510667039.922633.6138311243444001882.stgit@magnolia>
References: <158510667039.922633.6138311243444001882.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=1 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250028
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

I noticed that fsfreeze can take a very long time to freeze an XFS if
there happens to be a GETFSMAP caller running in the background.  I also
happened to notice the following in dmesg:

------------[ cut here ]------------
WARNING: CPU: 2 PID: 43492 at fs/xfs/xfs_super.c:853 xfs_quiesce_attr+0x83/0x90 [xfs]
Modules linked in: xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 ip_set_hash_ip ip_set_hash_net xt_tcpudp xt_set ip_set_hash_mac ip_set nfnetlink ip6table_filter ip6_tables bfq iptable_filter sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: xfs]
CPU: 2 PID: 43492 Comm: xfs_io Not tainted 5.6.0-rc4-djw #rc4
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
RIP: 0010:xfs_quiesce_attr+0x83/0x90 [xfs]
Code: 7c 07 00 00 85 c0 75 22 48 89 df 5b e9 96 c1 00 00 48 c7 c6 b0 2d 38 a0 48 89 df e8 57 64 ff ff 8b 83 7c 07 00 00 85 c0 74 de <0f> 0b 48 89 df 5b e9 72 c1 00 00 66 90 0f 1f 44 00 00 41 55 41 54
RSP: 0018:ffffc900030f3e28 EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff88802ac54000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff81e4a6f0 RDI: 00000000ffffffff
RBP: ffff88807859f070 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000010 R12: 0000000000000000
R13: ffff88807859f388 R14: ffff88807859f4b8 R15: ffff88807859f5e8
FS:  00007fad1c6c0fc0(0000) GS:ffff88807e000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0c7d237000 CR3: 0000000077f01003 CR4: 00000000001606a0
Call Trace:
 xfs_fs_freeze+0x25/0x40 [xfs]
 freeze_super+0xc8/0x180
 do_vfs_ioctl+0x70b/0x750
 ? __fget_files+0x135/0x210
 ksys_ioctl+0x3a/0xb0
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x50/0x1a0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

These two things appear to be related.  The assertion trips when another
thread initiates a fsmap request (which uses an empty transaction) after
the freezer waited for m_active_trans to hit zero but before the the
freezer executes the WARN_ON just prior to calling xfs_log_quiesce.

The lengthy delays in freezing happen because the freezer calls
xfs_wait_buftarg to clean out the buffer lru list.  Meanwhile, the
GETFSMAP caller is continuing to grab and release buffers, which means
that it can take a very long time for the buffer lru list to empty out.

We fix both of these races by calling sb_start_write to obtain freeze
protection while using empty transactions for GETFSMAP and for metadata
scrubbing.  The other two users occur during mount, during which time we
cannot fs freeze.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/scrub.c |    4 ++++
 fs/xfs/xfs_fsmap.c   |    4 ++++
 fs/xfs/xfs_trans.c   |    5 +++++
 3 files changed, 13 insertions(+)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index f1775bb19313..a42bb66b335d 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -168,6 +168,7 @@ xchk_teardown(
 			xfs_irele(sc->ip);
 		sc->ip = NULL;
 	}
+	sb_end_write(sc->mp->m_super);
 	if (sc->flags & XCHK_REAPING_DISABLED)
 		xchk_start_reaping(sc);
 	if (sc->flags & XCHK_HAS_QUOTAOFFLOCK) {
@@ -490,6 +491,9 @@ xfs_scrub_metadata(
 	sc.ops = &meta_scrub_ops[sm->sm_type];
 	sc.sick_mask = xchk_health_mask_for_scrub_type(sm->sm_type);
 retry_op:
+	/* Avoid conflicts with fs freeze. */
+	sb_start_write(mp->m_super);
+
 	/* Set up for the operation. */
 	error = sc.ops->setup(&sc, ip);
 	if (error)
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 918456ca29e1..2bb2cd1e63cf 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -896,6 +896,9 @@ xfs_getfsmap(
 	info.format_arg = arg;
 	info.head = head;
 
+	/* Avoid conflicts with fs freeze. */
+	sb_start_write(mp->m_super);
+
 	/* For each device we support... */
 	for (i = 0; i < XFS_GETFSMAP_DEVS; i++) {
 		/* Is this device within the range the user asked for? */
@@ -935,6 +938,7 @@ xfs_getfsmap(
 
 	if (tp)
 		xfs_trans_cancel(tp);
+	sb_end_write(mp->m_super);
 	head->fmh_oflags = FMH_OF_DEV_T;
 	return error;
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3b208f9a865c..a65dc227e40d 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -306,6 +306,11 @@ xfs_trans_alloc(
  *
  * Note the zero-length reservation; this transaction MUST be cancelled
  * without any dirty data.
+ *
+ * Callers should obtain freeze protection to avoid two conflicts with fs
+ * freezing: (1) having active transactions trip the m_active_trans ASSERTs;
+ * and (2) grabbing buffers at the same time that freeze is trying to drain
+ * the buffer LRU list.
  */
 int
 xfs_trans_alloc_empty(

