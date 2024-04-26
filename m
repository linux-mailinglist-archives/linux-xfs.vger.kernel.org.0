Return-Path: <linux-xfs+bounces-7694-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C49388B419F
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Apr 2024 23:56:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B2722836C3
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Apr 2024 21:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0A5E3A1B0;
	Fri, 26 Apr 2024 21:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="knKsGi4+"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2728839AC9
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168567; cv=none; b=rgTCNwoYIaJpKm8XltEwAfHPEnTTqfIiIyl+qFhYulTEY8HhhRaF0NumuZ9V4BZBKlnSmAyJfDB93ay+ftsvnAM5SldBLU/+Bzzlkf0mxGWJcDrsEjEVKj+LEpUuVPNTeHU7VUgvVTAvglAO018RwlNjHNiwH7ZE/Jmpb/2KUJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168567; c=relaxed/simple;
	bh=6uk+2WxLHNjTTKlmhCHxepIhGMfJxTwWXI2LN7LqvuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KO1qQwAI2C2wqQNSz/+b1ENVPJ9UHaCQr1ZyuhA3HKyi3eCEdXRLjhrTRL2o/z+uEYNdgfVoGKZJGoOlKPFBJomq7OhPzZ2ziWzbFKFb1bd8Vs64zD2ceRkkf9APMv9JUW/CIrYSAFPXw3RgYzXdnQTK/EfsJRLQv+H4NYg/PdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=knKsGi4+; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1e2bbc2048eso23650225ad.3
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168565; x=1714773365; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3rGIpsEaqo3AXvtkX7lKcoPk4kfA1H5etWusTtsTmGE=;
        b=knKsGi4+kF9ZNiXwKsv4TrHwAl/zy3MaIhcCh4aMek9tQremyu5GgvwChLcpUNnBQu
         LIAu8TCdGvAdPKBxcS1AszZkA8j+Zom4/NIeJrO+yejgmRcCGjiS3Pd9j/+wYTTaZO8W
         8uRlazLY/fF+E7QSzY6A7EiZXR5nzVx2TGA+DrZCxdU6xVhgjNaSDTTJpdEh49/CpHUr
         kfAgtDyM0JtBkEHf1jzYV+nbiJvX1mGb1Hm/xHmpRnHw8kkMSOnASYlwLCYA3iAiq6rI
         4nXfBqKDpvt3zNd1TeoR3uoppYK8ob+vdFtlEOnm19ET0bq3sMk71SjXrv66RL9hz5TE
         i+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168565; x=1714773365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3rGIpsEaqo3AXvtkX7lKcoPk4kfA1H5etWusTtsTmGE=;
        b=t2WMLMhsBUB0Vpw6nNOOZHqyDOjy2IfKyw+PbecapugI2XI8uYPn8/ib27V11V9w1X
         tJ99DaWT34Zacm2/qHCWlexGC5Rve6uyLaFQrOekxrlbr9mKHKciBhdwDgs/T7EdN8Pm
         WUP2tCldqT2B4bz4cXNmnDwRX3i7B0ZBu7luk1e0Fj7tDfmSNVO2cVXb0YZEnq24+ONZ
         edAIyYPrpEb2FG55awlqyK3l4uvZZrtsXZ1J16BXCdL0Ch4U+Eox7FKNTapiPmwp7YLO
         nSX8SCH5l+/8UkoJickETw+tU+XdKHvaMiwcNI9fAF/fkssoAKD3WWy9C8PgAW/kMvd2
         Tlig==
X-Gm-Message-State: AOJu0YxcRc815C/40T0FFsipll7oKUkJL5fdA6aF3SmAw7nj3nhm7OSD
	o2lBuOgBV/HqGxSUY3mgYW3xAtY3jdcD1x7Se3AltJTGD7CUshyiZFSUc8AB
X-Google-Smtp-Source: AGHT+IEHAbxXZoDQf8n6+1LvHTrvfyOrYFcy7QDXm8CesqrXiNqdVIkkqtkrLUMOrPN8LrI8gIzjuw==
X-Received: by 2002:a17:902:e809:b0:1e1:6850:f823 with SMTP id u9-20020a170902e80900b001e16850f823mr4846319plg.13.1714168565496;
        Fri, 26 Apr 2024 14:56:05 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:56:05 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	Guo Xuenan <guoxuenan@huawei.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 16/24] xfs: wait iclog complete before tearing down AIL
Date: Fri, 26 Apr 2024 14:55:03 -0700
Message-ID: <20240426215512.2673806-17-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240426215512.2673806-1-leah.rumancik@gmail.com>
References: <20240426215512.2673806-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guo Xuenan <guoxuenan@huawei.com>

[ Upstream commit 1eb52a6a71981b80f9acbd915acd6a05a5037196 ]

Fix uaf in xfs_trans_ail_delete during xlog force shutdown.
In commit cd6f79d1fb32 ("xfs: run callbacks before waking waiters in
xlog_state_shutdown_callbacks") changed the order of running callbacks
and wait for iclog completion to avoid unmount path untimely destroy AIL.
But which seems not enough to ensue this, adding mdelay in
`xfs_buf_item_unpin` can prove that.

The reproduction is as follows. To ensure destroy AIL safely,
we should wait all xlog ioend workers done and sync the AIL.

==================================================================
BUG: KASAN: use-after-free in xfs_trans_ail_delete+0x240/0x2a0
Read of size 8 at addr ffff888023169400 by task kworker/1:1H/43

CPU: 1 PID: 43 Comm: kworker/1:1H Tainted: G        W
6.1.0-rc1-00002-gc28266863c4a #137
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: xfs-log/sda xlog_ioend_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x4d/0x66
 print_report+0x171/0x4a6
 kasan_report+0xb3/0x130
 xfs_trans_ail_delete+0x240/0x2a0
 xfs_buf_item_done+0x7b/0xa0
 xfs_buf_ioend+0x1e9/0x11f0
 xfs_buf_item_unpin+0x4c8/0x860
 xfs_trans_committed_bulk+0x4c2/0x7c0
 xlog_cil_committed+0xab6/0xfb0
 xlog_cil_process_committed+0x117/0x1e0
 xlog_state_shutdown_callbacks+0x208/0x440
 xlog_force_shutdown+0x1b3/0x3a0
 xlog_ioend_work+0xef/0x1d0
 process_one_work+0x6f9/0xf70
 worker_thread+0x578/0xf30
 kthread+0x28c/0x330
 ret_from_fork+0x1f/0x30
 </TASK>

Allocated by task 9606:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 __kasan_kmalloc+0x7a/0x90
 __kmalloc+0x59/0x140
 kmem_alloc+0xb2/0x2f0
 xfs_trans_ail_init+0x20/0x320
 xfs_log_mount+0x37e/0x690
 xfs_mountfs+0xe36/0x1b40
 xfs_fs_fill_super+0xc5c/0x1a70
 get_tree_bdev+0x3c5/0x6c0
 vfs_get_tree+0x85/0x250
 path_mount+0xec3/0x1830
 do_mount+0xef/0x110
 __x64_sys_mount+0x150/0x1f0
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Freed by task 9662:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 kasan_save_free_info+0x2a/0x40
 __kasan_slab_free+0x105/0x1a0
 __kmem_cache_free+0x99/0x2d0
 kvfree+0x3a/0x40
 xfs_log_unmount+0x60/0xf0
 xfs_unmountfs+0xf3/0x1d0
 xfs_fs_put_super+0x78/0x300
 generic_shutdown_super+0x151/0x400
 kill_block_super+0x9a/0xe0
 deactivate_locked_super+0x82/0xe0
 deactivate_super+0x91/0xb0
 cleanup_mnt+0x32a/0x4a0
 task_work_run+0x15f/0x240
 exit_to_user_mode_prepare+0x188/0x190
 syscall_exit_to_user_mode+0x12/0x30
 do_syscall_64+0x42/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The buggy address belongs to the object at ffff888023169400
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 0 bytes inside of
 128-byte region [ffff888023169400, ffff888023169480)

The buggy address belongs to the physical page:
page:ffffea00008c5a00 refcount:1 mapcount:0 mapping:0000000000000000
index:0xffff888023168f80 pfn:0x23168
head:ffffea00008c5a00 order:1 compound_mapcount:0 compound_pincount:0
flags: 0x1fffff80010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
raw: 001fffff80010200 ffffea00006b3988 ffffea0000577a88 ffff88800f842ac0
raw: ffff888023168f80 0000000000150007 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888023169300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888023169380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888023169400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888023169480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888023169500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================
Disabling lock debugging due to kernel taint

Fixes: cd6f79d1fb32 ("xfs: run callbacks before waking waiters in xlog_state_shutdown_callbacks")
Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_log.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f02a0dd522b3..60b19f6d7077 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -886,6 +886,23 @@ xlog_force_iclog(
 	return xlog_state_release_iclog(iclog->ic_log, iclog, NULL);
 }
 
+/*
+ * Cycle all the iclogbuf locks to make sure all log IO completion
+ * is done before we tear down these buffers.
+ */
+static void
+xlog_wait_iclog_completion(struct xlog *log)
+{
+	int		i;
+	struct xlog_in_core	*iclog = log->l_iclog;
+
+	for (i = 0; i < log->l_iclog_bufs; i++) {
+		down(&iclog->ic_sema);
+		up(&iclog->ic_sema);
+		iclog = iclog->ic_next;
+	}
+}
+
 /*
  * Wait for the iclog and all prior iclogs to be written disk as required by the
  * log force state machine. Waiting on ic_force_wait ensures iclog completions
@@ -1111,6 +1128,14 @@ xfs_log_unmount(
 {
 	xfs_log_clean(mp);
 
+	/*
+	 * If shutdown has come from iclog IO context, the log
+	 * cleaning will have been skipped and so we need to wait
+	 * for the iclog to complete shutdown processing before we
+	 * tear anything down.
+	 */
+	xlog_wait_iclog_completion(mp->m_log);
+
 	xfs_buftarg_drain(mp->m_ddev_targp);
 
 	xfs_trans_ail_destroy(mp);
@@ -2113,17 +2138,6 @@ xlog_dealloc_log(
 	xlog_in_core_t	*iclog, *next_iclog;
 	int		i;
 
-	/*
-	 * Cycle all the iclogbuf locks to make sure all log IO completion
-	 * is done before we tear down these buffers.
-	 */
-	iclog = log->l_iclog;
-	for (i = 0; i < log->l_iclog_bufs; i++) {
-		down(&iclog->ic_sema);
-		up(&iclog->ic_sema);
-		iclog = iclog->ic_next;
-	}
-
 	/*
 	 * Destroy the CIL after waiting for iclog IO completion because an
 	 * iclog EIO error will try to shut down the log, which accesses the
-- 
2.44.0.769.g3c40516874-goog


