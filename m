Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4673532284
	for <lists+linux-xfs@lfdr.de>; Tue, 24 May 2022 07:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbiEXFgS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 May 2022 01:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbiEXFgP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 01:36:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170C3186EC
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 22:36:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5761B8175F
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 05:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FEEC385AA;
        Tue, 24 May 2022 05:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653370571;
        bh=LjnK7JR5IvuG0aLGZ/EzA8Nq95ERGAVdKvvcLvZoCAQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=V+znpWGE+52YGwn0zVIDqR1OwviT5O8tgSoqlhPXustYNdRJbJ/NRncekqNzLzGL1
         vJ4dwa0zaVg6xe/5DF2/wOXduvub/dWiY0mYygy4Jk16DiSFgE372Pi25oSLE0lz9s
         aVybBhzdcHjBSxA+xX0hCG6VKDwj1SGADpqOrShsf6MIOHjB91Ag9KfhZTDcmMB7K6
         2bc/G2yRbh0kkA9gCz0mxz0xAgKEnvLGUw0/ztlsVf/54s5+RdcBWZfnpTnt0h83TC
         Rn1mF3nKJSzSuHhh8t32rTXFbACk06biYi/WsWIdvPwx3PoFmdsylSWWkFBngPXCl5
         hGMSszlRHSR6w==
Subject: [PATCH 1/2] xfs: purge dquots after inode walk fails during
 quotacheck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Mon, 23 May 2022 22:36:10 -0700
Message-ID: <165337057096.993079.8431457282038063934.stgit@magnolia>
In-Reply-To: <165337056527.993079.1232300816023906959.stgit@magnolia>
References: <165337056527.993079.1232300816023906959.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xfs/434 and xfs/436 have been reporting occasional memory leaks of
xfs_dquot objects.  These tests themselves were the messenger, not the
culprit, since they unload the xfs module, which trips the slub
debugging code while tearing down all the xfs slab caches:

=============================================================================
BUG xfs_dquot (Tainted: G        W        ): Objects remaining in xfs_dquot on __kmem_cache_shutdown()
-----------------------------------------------------------------------------

Slab 0xffffea000606de00 objects=30 used=5 fp=0xffff888181b78a78 flags=0x17ff80000010200(slab|head|node=0|zone=2|lastcpupid=0xfff)
CPU: 0 PID: 3953166 Comm: modprobe Tainted: G        W         5.18.0-rc6-djwx #rc6 d5824be9e46a2393677bda868f9b154d917ca6a7
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20171121_152543-x86-ol7-builder-01.us.oracle.com-4.el7.1 04/01/2014

Since we don't generally rmmod the xfs module between fstests, this
means that xfs/434 is really just the canary in the coal mine --
something leaked a dquot, but we don't know who.  After days of pounding
on fstests with kmemleak enabled, I finally got it to spit this out:

unreferenced object 0xffff8880465654c0 (size 536):
  comm "u10:4", pid 88, jiffies 4294935810 (age 29.512s)
  hex dump (first 32 bytes):
    60 4a 56 46 80 88 ff ff 58 ea e4 5c 80 88 ff ff  `JVF....X..\....
    00 e0 52 49 80 88 ff ff 01 00 01 00 00 00 00 00  ..RI............
  backtrace:
    [<ffffffffa0740f6c>] xfs_dquot_alloc+0x2c/0x530 [xfs]
    [<ffffffffa07443df>] xfs_qm_dqread+0x6f/0x330 [xfs]
    [<ffffffffa07462a2>] xfs_qm_dqget+0x132/0x4e0 [xfs]
    [<ffffffffa0756bb0>] xfs_qm_quotacheck_dqadjust+0xa0/0x3e0 [xfs]
    [<ffffffffa075724d>] xfs_qm_dqusage_adjust+0x35d/0x4f0 [xfs]
    [<ffffffffa06c9068>] xfs_iwalk_ag_recs+0x348/0x5d0 [xfs]
    [<ffffffffa06c95d3>] xfs_iwalk_run_callbacks+0x273/0x540 [xfs]
    [<ffffffffa06c9e8d>] xfs_iwalk_ag+0x5ed/0x890 [xfs]
    [<ffffffffa06ca22f>] xfs_iwalk_ag_work+0xff/0x170 [xfs]
    [<ffffffffa06d22c9>] xfs_pwork_work+0x79/0x130 [xfs]
    [<ffffffff81170bb2>] process_one_work+0x672/0x1040
    [<ffffffff81171b1b>] worker_thread+0x59b/0xec0
    [<ffffffff8118711e>] kthread+0x29e/0x340
    [<ffffffff810032bf>] ret_from_fork+0x1f/0x30

Now we know that quotacheck is at fault, but even this report was
canaryish -- it was triggered by xfs/494, which doesn't actually mount
any filesystems.  (kmemleak can be a little slow to notice leaks, even
with fstests repeatedly whacking it to look for them.)  Looking at the
*previous* fstest, however, showed that the test run before xfs/494 was
xfs/117.  The tipoff to the problem is in this excerpt from dmesg:

XFS (sda4): Quotacheck needed: Please wait.
XFS (sda4): Metadata corruption detected at xfs_dinode_verify.part.0+0xdb/0x7b0 [xfs], inode 0x119 dinode
XFS (sda4): Unmount and run xfs_repair
XFS (sda4): First 128 bytes of corrupted metadata buffer:
00000000: 49 4e 81 a4 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
00000010: 00 00 00 01 00 00 00 00 00 90 57 54 54 1a 4c 68  ..........WTT.Lh
00000020: 81 f9 7d e1 6d ee 16 00 34 bd 7d e1 6d ee 16 00  ..}.m...4.}.m...
00000030: 34 bd 7d e1 6d ee 16 00 00 00 00 00 00 00 00 00  4.}.m...........
00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000050: 00 00 00 02 00 00 00 00 00 00 00 00 96 80 f3 ab  ................
00000060: ff ff ff ff da 57 7b 11 00 00 00 00 00 00 00 03  .....W{.........
00000070: 00 00 00 01 00 00 00 10 00 00 00 00 00 00 00 08  ................
XFS (sda4): Quotacheck: Unsuccessful (Error -117): Disabling quotas.

The dinode verifier decided that the inode was corrupt, which causes
iget to return with EFSCORRUPTED.  Since this happened during
quotacheck, it is obvious that the kernel aborted the inode walk on
account of the corruption error and disabled quotas.  Unfortunately, we
neglect to purge the dquot cache before doing that, which is how the
dquots leaked.

The problems started 10 years ago in commit b84a3a, when the dquot lists
were converted to a radix tree, but the error handling behavior was not
correctly preserved -- in that commit, if the bulkstat failed and
usrquota was enabled, the bulkstat failure code would be overwritten by
the result of flushing all the dquots to disk.  As long as that
succeeds, we'd continue the quota mount as if everything were ok, but
instead we're now operating with a corrupt inode and incorrect quota
usage counts.  I didn't notice this bug in 2019 when I wrote commit
ebd126a, which changed quotacheck to skip the dqflush when the scan
doesn't complete due to inode walk failures.

Introduced-by: b84a3a96751f ("xfs: remove the per-filesystem list of dquots")
Fixes: ebd126a651f8 ("xfs: convert quotacheck to use the new iwalk functions")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 8fc813cb6011..abf08bbf34a9 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1308,8 +1308,15 @@ xfs_qm_quotacheck(
 
 	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0, true,
 			NULL);
-	if (error)
+	if (error) {
+		/*
+		 * The inode walk may have partially populated the dquot
+		 * caches.  We must purge them before disabling quota and
+		 * tearing down the quotainfo, or else the dquots will leak.
+		 */
+		xfs_qm_dqpurge_all(mp);
 		goto error_return;
+	}
 
 	/*
 	 * We've made all the changes that we need to make incore.  Flush them

