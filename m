Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1915EFD54
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Sep 2022 20:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbiI2Spq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Sep 2022 14:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235906AbiI2SpN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2022 14:45:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFAB46601;
        Thu, 29 Sep 2022 11:44:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C3FC6214E;
        Thu, 29 Sep 2022 18:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F5FC433D6;
        Thu, 29 Sep 2022 18:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664477089;
        bh=0KnwtA9Cwe2++avaO7tjcOi6jtjCLsv4zJ2fFcjZtHU=;
        h=Date:From:To:Subject:From;
        b=BjPRO7oYCJniGiw9QqKMWC3xrGskpJ2k5SGBTnzknC6G368AwS2NGTJIseeuyMmeF
         V4Die4J6SZEdIJy0GazRiuB1xhFtKLMDgUNuSSGTdmOe95YJPQNrdmNIcSbI1sC/0f
         dHVnoilAglgJ9ibFahrBSsgzoi6XX9b60jdA2fb7uMcr1VSx+hsRwkxOydWBvIAj/l
         1NIp/k6AcbDaIb0cWuFQof38esOWsxLcM20lDyRgBwu4PVLVjDkgD0zfS2lfDp25eD
         Wcu1hMfc/9UXHvwBNr3YfrHj5zkqbb1VCJrouAANCfqr0yC8VOn2lTS559+frBzso2
         p/hpz+iF6XSoA==
Date:   Thu, 29 Sep 2022 11:44:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] iomap: fix memory corruption when recording errors during
 writeback
Message-ID: <YzXnoR0UMBVfoaOf@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Every now and then I see this crash on arm64:

Unable to handle kernel NULL pointer dereference at virtual address 00000000000000f8
Buffer I/O error on dev dm-0, logical block 8733687, async page read
Mem abort info:
  ESR = 0x0000000096000006
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x06: level 2 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000006
  CM = 0, WnR = 0
user pgtable: 64k pages, 42-bit VAs, pgdp=0000000139750000
[00000000000000f8] pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000, pmd=0000000000000000
Internal error: Oops: 96000006 [#1] PREEMPT SMP
Buffer I/O error on dev dm-0, logical block 8733688, async page read
Dumping ftrace buffer:
Buffer I/O error on dev dm-0, logical block 8733689, async page read
   (ftrace buffer empty)
XFS (dm-0): log I/O error -5
Modules linked in: dm_thin_pool dm_persistent_data
XFS (dm-0): Metadata I/O Error (0x1) detected at xfs_trans_read_buf_map+0x1ec/0x590 [xfs] (fs/xfs/xfs_trans_buf.c:296).
 dm_bio_prison
XFS (dm-0): Please unmount the filesystem and rectify the problem(s)
XFS (dm-0): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0
 dm_bufio dm_log_writes xfs nft_chain_nat xt_REDIRECT nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6t_REJECT
potentially unexpected fatal signal 6.
 nf_reject_ipv6
potentially unexpected fatal signal 6.
 ipt_REJECT nf_reject_ipv4
CPU: 1 PID: 122166 Comm: fsstress Tainted: G        W          6.0.0-rc5-djwa #rc5 3004c9f1de887ebae86015f2677638ce51ee7
 rpcsec_gss_krb5 auth_rpcgss xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set nft_compat ip_set_hash_mac ip_set nf_tables
Hardware name: QEMU KVM Virtual Machine, BIOS 1.5.1 06/16/2021
pstate: 60001000 (nZCv daif -PAN -UAO -TCO -DIT +SSBS BTYPE=--)
 ip_tables
pc : 000003fd6d7df200
 x_tables
lr : 000003fd6d7df1ec
 overlay nfsv4
CPU: 0 PID: 54031 Comm: u4:3 Tainted: G        W          6.0.0-rc5-djwa #rc5 3004c9f1de887ebae86015f2677638ce51ee7405
Hardware name: QEMU KVM Virtual Machine, BIOS 1.5.1 06/16/2021
Workqueue: writeback wb_workfn
sp : 000003ffd9522fd0
 (flush-253:0)
pstate: 60401005 (nZCv daif +PAN -UAO -TCO -DIT +SSBS BTYPE=--)
pc : errseq_set+0x1c/0x100
x29: 000003ffd9522fd0 x28: 0000000000000023 x27: 000002acefeb6780
x26: 0000000000000005 x25: 0000000000000001 x24: 0000000000000000
x23: 00000000ffffffff x22: 0000000000000005
lr : __filemap_set_wb_err+0x24/0xe0
 x21: 0000000000000006
sp : fffffe000f80f760
x29: fffffe000f80f760 x28: 0000000000000003 x27: fffffe000f80f9f8
x26: 0000000002523000 x25: 00000000fffffffb x24: fffffe000f80f868
x23: fffffe000f80fbb0 x22: fffffc0180c26a78 x21: 0000000002530000
x20: 0000000000000000 x19: 0000000000000000 x18: 0000000000000000

x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000001 x13: 0000000000470af3 x12: fffffc0058f70000
x11: 0000000000000040 x10: 0000000000001b20 x9 : fffffe000836b288
x8 : fffffc00eb9fd480 x7 : 0000000000f83659 x6 : 0000000000000000
x5 : 0000000000000869 x4 : 0000000000000005 x3 : 00000000000000f8
x20: 000003fd6d740020 x19: 000000000001dd36 x18: 0000000000000001
x17: 000003fd6d78704c x16: 0000000000000001 x15: 000002acfac87668
x2 : 0000000000000ffa x1 : 00000000fffffffb x0 : 00000000000000f8
Call trace:
 errseq_set+0x1c/0x100
 __filemap_set_wb_err+0x24/0xe0
 iomap_do_writepage+0x5e4/0xd5c
 write_cache_pages+0x208/0x674
 iomap_writepages+0x34/0x60
 xfs_vm_writepages+0x8c/0xcc [xfs 7a861f39c43631f15d3a5884246ba5035d4ca78b]
x14: 0000000000000000 x13: 2064656e72757465 x12: 0000000000002180
x11: 000003fd6d8a82d0 x10: 0000000000000000 x9 : 000003fd6d8ae288
x8 : 0000000000000083 x7 : 00000000ffffffff x6 : 00000000ffffffee
x5 : 00000000fbad2887 x4 : 000003fd6d9abb58 x3 : 000003fd6d740020
x2 : 0000000000000006 x1 : 000000000001dd36 x0 : 0000000000000000
CPU: 1 PID: 122167 Comm: fsstress Tainted: G        W          6.0.0-rc5-djwa #rc5 3004c9f1de887ebae86015f2677638ce51ee7
 do_writepages+0x90/0x1c4
 __writeback_single_inode+0x4c/0x4ac
Hardware name: QEMU KVM Virtual Machine, BIOS 1.5.1 06/16/2021
 writeback_sb_inodes+0x214/0x4ac
 wb_writeback+0xf4/0x3b0
pstate: 60001000 (nZCv daif -PAN -UAO -TCO -DIT +SSBS BTYPE=--)
 wb_workfn+0xfc/0x580
 process_one_work+0x1e8/0x480
pc : 000003fd6d7df200
 worker_thread+0x78/0x430

This crash is a result of iomap_writepage_map encountering some sort of
error during writeback and wanting to set that error code in the file
mapping so that fsync will report it.  Unfortunately, the code
dereferences folio->mapping after unlocking the folio, which means that
another thread could have removed the page from the page cache
(writeback doesn't hold the invalidation lock) and give it to somebody
else.

At best we crash the system like above; at worst, we corrupt memory or
set an error on some other unsuspecting file while failing to record the
problems with *this* file.  Regardless, fix the problem by reporting the
error to the inode mapping.

NOTE: Commit 598ecfbaa742 lifted the XFS writeback code to iomap, so
this fix should be backported to XFS in the 4.6-5.4 kernels in addition
to iomap in the 5.5-5.19 kernels.

Fixes: e735c0079465 ("iomap: Convert iomap_add_to_ioend() to take a folio")
Probably-Fixes: 598ecfbaa742 ("iomap: lift the xfs writeback code to iomap")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/iomap/buffered-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index ca5c62901541..77d59c159248 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1421,7 +1421,7 @@ iomap_writepage_map(struct iomap_writepage_ctx *wpc,
 	if (!count)
 		folio_end_writeback(folio);
 done:
-	mapping_set_error(folio->mapping, error);
+	mapping_set_error(inode->i_mapping, error);
 	return error;
 }
 
