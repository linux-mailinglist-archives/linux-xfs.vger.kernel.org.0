Return-Path: <linux-xfs+bounces-18149-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8251A0A168
	for <lists+linux-xfs@lfdr.de>; Sat, 11 Jan 2025 08:11:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B77613AA588
	for <lists+linux-xfs@lfdr.de>; Sat, 11 Jan 2025 07:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E52DF15DBB3;
	Sat, 11 Jan 2025 07:10:59 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A33B1114
	for <linux-xfs@vger.kernel.org>; Sat, 11 Jan 2025 07:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736579459; cv=none; b=QwbZGFnwFkp674CNOC4c8v9sg4n/1532SbmxdFfalq0NLFAXC66RC+A8+DWdtjG/tzesxmlmEUvISnvutkgCzt95nL1OARUSaao5IUGEaodQyP80CEoX+ifx9dkSSmoHU+10jHainNdpFHr///8smbeEULgWHBGk/ECfCNAabO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736579459; c=relaxed/simple;
	bh=O3WeF/ZIBg/+a6rGGg3qfc9TOyK/73hinWnY/nZ5HNk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=V45nPBRSkBx8h2rzW0ExOEZM5Eylg8U2jdy4X0AWXnMszRhk4QuCedwtEAWydVQSw1+fFniCICtQuTapawdO1mfw4JftmdHXUjEb8vrITR6m22JNapIk47vvAHicyFJT1Q1HbC+Iadk3O4Ef9l5lVXyMCTgZn+jdaxtlXJ9dHxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4YVV376V4xz1V4Qc;
	Sat, 11 Jan 2025 15:07:47 +0800 (CST)
Received: from dggpemf500017.china.huawei.com (unknown [7.185.36.126])
	by mail.maildlp.com (Postfix) with ESMTPS id 8B244180043;
	Sat, 11 Jan 2025 15:10:53 +0800 (CST)
Received: from huawei.com (10.175.104.67) by dggpemf500017.china.huawei.com
 (7.185.36.126) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 11 Jan
 2025 15:10:52 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH v3] xfs: fix mount hang during primary superblock recovery failure
Date: Sat, 11 Jan 2025 15:05:44 +0800
Message-ID: <20250111070544.896052-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemf500017.china.huawei.com (7.185.36.126)

When mounting an image containing a log with sb modifications that require
log replay, the mount process hang all the time and stack as follows:

  [root@localhost ~]# cat /proc/557/stack
  [<0>] xfs_buftarg_wait+0x31/0x70
  [<0>] xfs_buftarg_drain+0x54/0x350
  [<0>] xfs_mountfs+0x66e/0xe80
  [<0>] xfs_fs_fill_super+0x7f1/0xec0
  [<0>] get_tree_bdev_flags+0x186/0x280
  [<0>] get_tree_bdev+0x18/0x30
  [<0>] xfs_fs_get_tree+0x1d/0x30
  [<0>] vfs_get_tree+0x2d/0x110
  [<0>] path_mount+0xb59/0xfc0
  [<0>] do_mount+0x92/0xc0
  [<0>] __x64_sys_mount+0xc2/0x160
  [<0>] x64_sys_call+0x2de4/0x45c0
  [<0>] do_syscall_64+0xa7/0x240
  [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

During log recovery, while updating the in-memory superblock from the
primary SB buffer, if an error is encountered, such as superblock
corruption occurs or some other reasons, we will proceed to out_release
and release the xfs_buf. However, this is insufficient because the
xfs_buf's log item has already been initialized and the xfs_buf is held
by the buffer log item as follows, the xfs_buf will not be released,
causing the mount thread to hang.

  xlog_recover_do_primary_sb_buffer
    xlog_recover_do_reg_buffer
      xlog_recover_validate_buf_type
        xfs_buf_item_init(bp, mp)

The solution is straightforward, we simply need to allow it to be
handled by the normal buffer write process. The filesystem will be
shutdown before the submission of buffer_list in xlog_do_recovery_pass(),
ensuring the correct release of the xfs_buf as follows:

  xlog_do_recovery_pass
    error = xlog_recover_process
      xlog_recover_process_data
        xlog_recover_process_ophdr
          xlog_recovery_process_trans
            ...
              xlog_recover_buf_commit_pass2
                error = xlog_recover_do_primary_sb_buffer
                  //Encounter error and return
                if (error)
                  goto out_writebuf
                ...
              out_writebuf:
                xfs_buf_delwri_queue(bp, buffer_list) //add bp to list
                return  error
            ...
    if (!list_empty(&buffer_list))
      if (error)
        xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR); //shutdown first
      xfs_buf_delwri_submit(&buffer_list); //submit buffers in list
        __xfs_buf_submit
          if (bp->b_mount->m_log && xlog_is_shutdown(bp->b_mount->m_log))
            xfs_buf_ioend_fail(bp)  //release bp correctly

Fixes: 6a18765b54e2 ("xfs: update the file system geometry after recoverying superblock buffers")
Cc: <stable@vger.kernel.org> # v6.12
Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v2-v3:
  - Add reviewed tag and cc stable tag.
  - Corrected the syntax in code comments.
 fs/xfs/xfs_buf_item_recover.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 3d0c6402cb36..6b10390ad3d2 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1079,7 +1079,7 @@ xlog_recover_buf_commit_pass2(
 		error = xlog_recover_do_primary_sb_buffer(mp, item, bp, buf_f,
 				current_lsn);
 		if (error)
-			goto out_release;
+			goto out_writebuf;
 
 		/* Update the rt superblock if we have one. */
 		if (xfs_has_rtsb(mp) && mp->m_rtsb_bp) {
@@ -1096,6 +1096,15 @@ xlog_recover_buf_commit_pass2(
 		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
 	}
 
+	/*
+	 * Buffer held by buf log item during 'normal' buffer recovery must
+	 * be committed through buffer I/O submission path to ensure proper
+	 * release. When error occurs during sb buffer recovery, log shutdown
+	 * will be done before submitting buffer list so that buffers can be
+	 * released correctly through ioend failure path.
+	 */
+out_writebuf:
+
 	/*
 	 * Perform delayed write on the buffer.  Asynchronous writes will be
 	 * slower when taking into account all the buffers to be flushed.
-- 
2.39.2


