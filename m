Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0354571A21A
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Jun 2023 17:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbjFAPMK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Jun 2023 11:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbjFAPMH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 11:12:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9CA189
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 08:11:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8939564678
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 15:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7ACFC433EF;
        Thu,  1 Jun 2023 15:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685632306;
        bh=Rv2iJhrxCe8ZwxRPXWEbMYCd7epdoJ37Aj+x5luw36Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G4nY28WeHCR49Aig+E164K4yfPJhp/uZDZyZ6WfxcZgE2pQ6vogbO1HgG3kj8rX56
         gT30ayxO7eJDhAFXyp8enKsHF4crjVFrQOcIIFTlyAt9fmSVS+GzyB2IQfVV0Lbhpj
         HrBAdP/Gj0cN6reuEeLKHGcYJAys7cQ5gIcI1Svw/quatOU3k4+XhPAIRUyPomFrvZ
         wtWGzPCAK0/18ySgNT/bEBYUVs60YmHsyc+MvNL/MUtbAAQ2weivqnC06hVL/wcV4S
         QJuR3OBXx8lAdfZUEPCXfpbVFwPIEx5be/uvq2/cUjPivP53j1MEIHAHh6Omvkoizr
         PT2Pyrq1OyqnQ==
Date:   Thu, 1 Jun 2023 08:11:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Lee Jones <lee@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: verify buffer contents when we skip log replay
Message-ID: <20230601151146.GH16865@frogsfrogsfrogs>
References: <20230411233159.GH360895@frogsfrogsfrogs>
 <20230601130351.GA1787684@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230601130351.GA1787684@google.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 01, 2023 at 02:03:51PM +0100, Lee Jones wrote:
> Hi Darrick,
> 
> On Tue, 11 Apr 2023, Darrick J. Wong wrote:
> 
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > syzbot detected a crash during log recovery:
> > 
> > XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
> > XFS (loop0): Torn write (CRC failure) detected at log block 0x180. Truncating head block from 0x200.
> > XFS (loop0): Starting recovery (logdev: internal)
> > ==================================================================
> > BUG: KASAN: slab-out-of-bounds in xfs_btree_lookup_get_block+0x15c/0x6d0 fs/xfs/libxfs/xfs_btree.c:1813
> > Read of size 8 at addr ffff88807e89f258 by task syz-executor132/5074
> > 
> > CPU: 0 PID: 5074 Comm: syz-executor132 Not tainted 6.2.0-rc1-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0x1b1/0x290 lib/dump_stack.c:106
> >  print_address_description+0x74/0x340 mm/kasan/report.c:306
> >  print_report+0x107/0x1f0 mm/kasan/report.c:417
> >  kasan_report+0xcd/0x100 mm/kasan/report.c:517
> >  xfs_btree_lookup_get_block+0x15c/0x6d0 fs/xfs/libxfs/xfs_btree.c:1813
> >  xfs_btree_lookup+0x346/0x12c0 fs/xfs/libxfs/xfs_btree.c:1913
> >  xfs_btree_simple_query_range+0xde/0x6a0 fs/xfs/libxfs/xfs_btree.c:4713
> >  xfs_btree_query_range+0x2db/0x380 fs/xfs/libxfs/xfs_btree.c:4953
> >  xfs_refcount_recover_cow_leftovers+0x2d1/0xa60 fs/xfs/libxfs/xfs_refcount.c:1946
> >  xfs_reflink_recover_cow+0xab/0x1b0 fs/xfs/xfs_reflink.c:930
> >  xlog_recover_finish+0x824/0x920 fs/xfs/xfs_log_recover.c:3493
> >  xfs_log_mount_finish+0x1ec/0x3d0 fs/xfs/xfs_log.c:829
> >  xfs_mountfs+0x146a/0x1ef0 fs/xfs/xfs_mount.c:933
> >  xfs_fs_fill_super+0xf95/0x11f0 fs/xfs/xfs_super.c:1666
> >  get_tree_bdev+0x400/0x620 fs/super.c:1282
> >  vfs_get_tree+0x88/0x270 fs/super.c:1489
> >  do_new_mount+0x289/0xad0 fs/namespace.c:3145
> >  do_mount fs/namespace.c:3488 [inline]
> >  __do_sys_mount fs/namespace.c:3697 [inline]
> >  __se_sys_mount+0x2d3/0x3c0 fs/namespace.c:3674
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > RIP: 0033:0x7f89fa3f4aca
> > Code: 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007fffd5fb5ef8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
> > RAX: ffffffffffffffda RBX: 00646975756f6e2c RCX: 00007f89fa3f4aca
> > RDX: 0000000020000100 RSI: 0000000020009640 RDI: 00007fffd5fb5f10
> > RBP: 00007fffd5fb5f10 R08: 00007fffd5fb5f50 R09: 000000000000970d
> > R10: 0000000000200800 R11: 0000000000000206 R12: 0000000000000004
> > R13: 0000555556c6b2c0 R14: 0000000000200800 R15: 00007fffd5fb5f50
> >  </TASK>
> > 
> > The fuzzed image contains an AGF with an obviously garbage
> > agf_refcount_level value of 32, and a dirty log with a buffer log item
> > for that AGF.  The ondisk AGF has a higher LSN than the recovered log
> > item.  xlog_recover_buf_commit_pass2 reads the buffer, compares the
> > LSNs, and decides to skip replay because the ondisk buffer appears to be
> > newer.
> > 
> > Unfortunately, the ondisk buffer is corrupt, but recovery just read the
> > buffer with no buffer ops specified:
> > 
> > 	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno,
> > 			buf_f->blf_len, buf_flags, &bp, NULL);
> > 
> > Skipping the buffer leaves its contents in memory unverified.  This sets
> > us up for a kernel crash because xfs_refcount_recover_cow_leftovers
> > reads the buffer (which is still around in XBF_DONE state, so no read
> > verification) and creates a refcountbt cursor of height 32.  This is
> > impossible so we run off the end of the cursor object and crash.
> > 
> > Fix this by invoking the verifier on all skipped buffers and aborting
> > log recovery if the ondisk buffer is corrupt.  It might be smarter to
> > force replay the log item atop the buffer and then see if it'll pass the
> > write verifier (like ext4 does) but for now let's go with the
> > conservative option where we stop immediately.
> > 
> > Link: https://syzkaller.appspot.com/bug?extid=7e9494b8b399902e994e
> > Fixes: 67dc288c2106 ("xfs: ensure verifiers are attached to recovered buffers")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_buf_item_recover.c |   10 ++++++++++
> >  1 file changed, 10 insertions(+)
> 
> Rightly or wrongly, CVE-2023-212 has been raised against this issue.
> 
> It looks as though the Fixes: tag above was stripped when applied.
> 
> Should this still be submitted to Stable?

Yes, but we have not been successful in persuading any company to pick
up stable backporting and QA for any kernel newer than 5.15.

--D

> > diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> > index 5368a0d34452..ebe7f2c3cf63 100644
> > --- a/fs/xfs/xfs_buf_item_recover.c
> > +++ b/fs/xfs/xfs_buf_item_recover.c
> > @@ -971,6 +971,16 @@ xlog_recover_buf_commit_pass2(
> >  	if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
> >  		trace_xfs_log_recover_buf_skip(log, buf_f);
> >  		xlog_recover_validate_buf_type(mp, bp, buf_f, NULLCOMMITLSN);
> > +
> > +		/*
> > +		 * We're skipping replay of this buffer log item due to the log
> > +		 * item LSN being behind the ondisk buffer.  Verify the buffer
> > +		 * contents since we aren't going to run the write verifier.
> > +		 */
> > +		if (bp->b_ops) {
> > +			bp->b_ops->verify_read(bp);
> > +			error = bp->b_error;
> > +		}
> >  		goto out_release;
> >  	}
> >  
> 
> -- 
> Lee Jones [李琼斯]
