Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4AD84E3765
	for <lists+linux-xfs@lfdr.de>; Tue, 22 Mar 2022 04:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbiCVD21 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 21 Mar 2022 23:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235946AbiCVD2Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 23:28:25 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 820C99D0EE
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 20:26:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0340010E4D48;
        Tue, 22 Mar 2022 14:26:51 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nWVAX-008MdH-J8; Tue, 22 Mar 2022 14:26:49 +1100
Date:   Tue, 22 Mar 2022 14:26:49 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] xfs: more shutdown/recovery fixes
Message-ID: <20220322032649.GM1544202@dread.disaster.area>
References: <20220321012329.376307-1-david@fromorbit.com>
 <20220322023528.GM8224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322023528.GM8224@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=623941fc
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=wb7p_SvHpRXns-bbYSEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 21, 2022 at 07:35:28PM -0700, Darrick J. Wong wrote:
> On Mon, Mar 21, 2022 at 12:23:27PM +1100, Dave Chinner wrote:
> > Hi folks,
> > 
> > These two patches are followups to my recent series of
> > shutdown/recovery fixes. The cluster buffer lock patch addresses a
> > race condition that started to show up regularly once the fixes in
> > the previous series were done - it is a regression from the async
> > inode reclaim work that was done almost 2 years ago now.
> > 
> > The second patch is something I'm really surprised has taken this
> > long to uncover. There is a check in intent recovery/cancellation
> > that checks that there are no intent items in the AIL after the
> > first non-intent item is found. This behaviour was correct back when
> > we only had standalone intent items (i.e. EFI/EFD), but when we
> > started to chain complex operations by intents, the recovery of an
> > incomplete intent can log and commit new intents and they can end up
> > in the AIL before log recovery is complete and finished processing
> > the deferred items. Hence the ASSERT() check that no intents
> > exist in the AIL after the first non-intent item is simply invalid.
> > 
> > With these two patches, I'm back to being able to run hundreds of
> > cycles of g/388 or -g recoveryloop without seeing any failures.
> 
> Hmm, with this series applied to current for-next
> + your other log patches
> + my xfs_reserve_blocks infinite loop fix and cleanup series
> 
> I see this while running fstests on an all-defaults v5 filesystem.
> I /think/ it's crashing in the "xfs_buf_ispinned(bp)" right below the
> "ASSERT(iip->ili_item.li_buf);" in xfs_inode_item_push.

Oh, because you have CONFIG_XFS_ASSERT_FATAL=n, or whatever the
config thingy is to keep going even when asserts fail...

> [ 1294.636121] run fstests generic/251 at 2022-03-21 16:06:27
> [ 1295.168287] XFS (sda): Mounting V5 Filesystem
> [ 1295.180601] XFS (sda): Ending clean mount
> [ 1295.471352] XFS (sdf): Mounting V5 Filesystem
> [ 1295.482082] XFS (sdf): Ending clean mount
> [ 1295.483612] XFS (sdf): Quotacheck needed: Please wait.
> [ 1295.487265] XFS (sdf): Quotacheck: Done.
> [ 1376.010962] XFS (sdf): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
> [ 1386.006736] XFS: Assertion failed: iip->ili_item.li_buf, file: fs/xfs/xfs_inode_item.c, line: 547
> [ 1386.007571] ------------[ cut here ]------------
> [ 1386.007991] WARNING: CPU: 0 PID: 419577 at fs/xfs/xfs_message.c:112 assfail+0x3c/0x40 [xfs]
> [ 1386.008837] Modules linked in: btrfs blake2b_generic xor lzo_compress lzo_decompress zlib_deflate raid6_pq zstd_compress ext4 mbcache jbd2 dm_flakey dm_snapshot dm_bufio dm_zero xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_ip xt_REDIRECT xt_set ip_set_hash_net ip_set_hash_mac ip_set iptable_nat nf_nat nf_conntrack nfnetlink nf_defrag_ipv6 nf_defrag_ipv4 ip6table_filter ip6_tables iptable_filter bfq pvpanic_mmio pvpanic sch_fq_codel ip_tables x_tables overlay nfsv4 af_packet
> [ 1386.012759] CPU: 0 PID: 419577 Comm: xfsaild/sdf Not tainted 5.17.0-rc6-djwx #rc6 38f9b0b98565b531708bd3bd34525d3eec280440
> [ 1386.013718] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> [ 1386.014493] RIP: 0010:assfail+0x3c/0x40 [xfs]
> [ 1386.015098] Code: 90 9c 45 a0 e8 81 f9 ff ff 8a 1d d3 28 0c 00 80 fb 01 76 0f 0f b6 f3 48 c7 c7 60 81 4f a0 e8 b3 4d fd e0 80 e3 01 74 02 0f 0b <0f> 0b 5b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24
> [ 1386.016706] RSP: 0018:ffffc9000530be18 EFLAGS: 00010246
> [ 1386.017172] RAX: 0000000000000000 RBX: ffff888063ace300 RCX: 0000000000000000
> [ 1386.017801] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffa0449eb0
> [ 1386.018435] RBP: ffff88805fa897c0 R08: 0000000000000000 R09: 000000000000000a
> [ 1386.019059] R10: 000000000000000a R11: f000000000000000 R12: ffff88800ad06f40
> [ 1386.019685] R13: ffff88800ad06f68 R14: 00000016000191e9 R15: 0000000000000000
> [ 1386.020395] FS:  0000000000000000(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
> [ 1386.021172] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1386.021680] CR2: 0000564ba4fc9968 CR3: 000000002852c002 CR4: 00000000001706b0
> [ 1386.022313] Call Trace:
> [ 1386.022555]  <TASK>
> [ 1386.022763]  xfs_inode_item_push+0xf4/0x140 [xfs 9a019b85afd13531ec29ae154df8383f289b73eb]
> [ 1386.023579]  xfsaild+0x402/0xc30 [xfs 9a019b85afd13531ec29ae154df8383f289b73eb]
> [ 1386.024367]  ? __set_cpus_allowed_ptr_locked+0xe0/0x1a0
> [ 1386.024841]  ? preempt_count_add+0x73/0xa0
> [ 1386.025255]  ? xfs_trans_ail_cursor_first+0x80/0x80 [xfs 9a019b85afd13531ec29ae154df8383f289b73eb]
> [ 1386.026163]  kthread+0xea/0x110
> [ 1386.026487]  ? kthread_complete_and_exit+0x20/0x20
> [ 1386.026924]  ret_from_fork+0x1f/0x30
> [ 1386.027261]  </TASK>

I haven't seen that particular failure - that's likely an
interaction with stale indoes and buffers on inode cluster buffer
freeing. On the surface it doesn't seem to be related to the
shutdown changes, but it could be related to the fact that we
are accessing the inode log item without holding either the buffer
locked or the item locked.

Hence this could be racing with an journal IO completion for a freed
inode cluster buffer that runs inode IO compeltion directly, which
then calls xfs_iflush_abort() because XFS_ISTALE is set on all the
inodes.

Yeah.

I changed xfs_iflush_abort() to clean up the inode log item state
before I removed it from the AIL, thinking that this was safe to
do because anything that uses the iip->ili_item.li_buf should be
checking it before using it.....

.... and that is exactly what xfs_inode_item_push() is _not_ doing.

OK, I know how this is happening, I'll have to rework the first
patch in this series to address this.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
