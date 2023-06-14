Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C536721097
	for <lists+linux-xfs@lfdr.de>; Sat,  3 Jun 2023 16:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjFCOu1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 3 Jun 2023 10:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjFCOu1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2023 10:50:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD76CE
        for <linux-xfs@vger.kernel.org>; Sat,  3 Jun 2023 07:50:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0098C60C36
        for <linux-xfs@vger.kernel.org>; Sat,  3 Jun 2023 14:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579C9C433D2;
        Sat,  3 Jun 2023 14:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685803823;
        bh=CbrkGbIbz8FrhFv82YZMoRFXi6+pcRHqN3ZFRlPu/3s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Brc36lqWM0oZocUKoZmC14p2NaKAfiop+Og9LYwj55uwlm3dFVzGifb6V5jz9fPNL
         /XujVkf4kI/3UoRqRvFGFCCJwE2xGWGFbk7n05A0VSdfskMN+8MPnlzVP/l3Zzw6EL
         V8JlYSaYuhKjvZaXkaOrKO11qKo7FC4c4VFO8z/POh6rRAI3HV0HSLxwrk6lC/zP7Y
         Ziwc+iUqTet7mi/gEdfRh1kut8gHS1oHgVd3RHzk78BwrhFKd99nVVbuvUj/VWLD6d
         VG1eLU79/PHNBUFbA9ZWKzrr/tlAYWZd7p2QYhvh15jlYgRadQswsn3k+DwJLrvixz
         x6bhLsKwSuERw==
Date:   Sat, 3 Jun 2023 07:50:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 217522] New: xfs_attr3_leaf_add_work produces a warning
Message-ID: <20230603145022.GQ16865@frogsfrogsfrogs>
References: <bug-217522-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-217522-201763@https.bugzilla.kernel.org/>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 03, 2023 at 03:58:25AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=217522
> 
>             Bug ID: 217522
>            Summary: xfs_attr3_leaf_add_work produces a warning
>            Product: File System
>            Version: 2.5
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: lomov.vl@bkoty.ru
>         Regression: No
> 
> Hi.
> 
> While running linux-next
> (6.4.0-rc4-next-20230602-1-next-git-06849-gbc708bbd8260) on one of my hosts, I
> see the following message in the kernel log (`dmesg`):
> ```
> Jun 02 20:01:19 smoon.bkoty.ru kernel: ------------[ cut here ]------------
> Jun 02 20:01:19 smoon.bkoty.ru kernel: memcpy: detected field-spanning write
> (size 12) of single field "(char *)name_loc->nameval" at

Yes, this bug is a collision between the bad old ways of doing flex
arrays:

typedef struct xfs_attr_leaf_name_local {
	__be16	valuelen;		/* number of bytes in value */
	__u8	namelen;		/* length of name bytes */
	__u8	nameval[1];		/* name/value bytes */
} xfs_attr_leaf_name_local_t;

And the static checking that gcc/llvm purport to be able to do properly.
This is encoded into the ondisk structures, which means that someone
needs to do perform a deep audit to change each array[1] into an
array[] and then ensure that every sizeof() performed on those structure
definitions has been adjusted.  Then they would need to run the full QA
test suite to ensure that no regressions have been introduced.  Then
someone will need to track down any code using
/usr/include/xfs/xfs_da_format.h to let them know about the silent
compiler bomb heading their way.

I prefer we leave it as-is since this code has been running for years
with no problems.

--D

> fs/xfs/libxfs/xfs_attr_leaf.c:1559 (size 1)
> Jun 02 20:01:19 smoon.bkoty.ru kernel: WARNING: CPU: 2 PID: 1161 at
> fs/xfs/libxfs/xfs_attr_leaf.c:1559 xfs_attr3_leaf_add_work+0x4f5/0x540 [xfs]
> Jun 02 20:01:19 smoon.bkoty.ru kernel: Modules linked in: nft_fib_ipv6 nft_nat
> overlay rpcrdma rdma_cm iw_cm ib_cm ib_core wireguard curve25519_x86_64
> libchacha20poly1305 chacha_x86_64 poly1305_x86_64 libcurve25519_generic
> libchacha ip6_udp_tunnel udp_tunnel nft_fib_ipv4 n>
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  crct10dif_pclmul snd_pcm_dmaengine
> crc32_pclmul snd_hda_intel polyval_clmulni polyval_generic gf128mul
> snd_intel_dspcfg ghash_clmulni_intel snd_intel_sdw_acpi sha512_ssse3
> snd_hda_codec aesni_intel ppdev snd_hda_core crypto_simd cryp>
> Jun 02 20:01:19 smoon.bkoty.ru kernel: CPU: 2 PID: 1161 Comm: systemd-coredum
> Tainted: G     U            
> 6.4.0-rc4-next-20230602-1-next-git-06849-gbc708bbd8260 #1
> e2bc2c7c17ec9449d00023ecb23f332188dc6bfc
> Jun 02 20:01:19 smoon.bkoty.ru kernel: Hardware name: Gigabyte Technology Co.,
> Ltd. B460HD3/B460 HD3, BIOS F1 04/15/2020
> Jun 02 20:01:19 smoon.bkoty.ru kernel: RIP:
> 0010:xfs_attr3_leaf_add_work+0x4f5/0x540 [xfs]
> Jun 02 20:01:19 smoon.bkoty.ru kernel: Code: fe ff ff b9 01 00 00 00 4c 89 fe
> 48 c7 c2 f8 95 87 c0 48 c7 c7 40 96 87 c0 48 89 44 24 08 c6 05 e5 35 11 00 01
> e8 5b cf 91 c7 <0f> 0b 48 8b 44 24 08 e9 88 fe ff ff 80 3d cc 35 11 00 00 0f 85
> bd
> Jun 02 20:01:19 smoon.bkoty.ru kernel: RSP: 0018:ffffb6050254b7f8 EFLAGS:
> 00010282
> Jun 02 20:01:19 smoon.bkoty.ru kernel: RAX: 0000000000000000 RBX:
> ffffb6050254b8c8 RCX: 0000000000000027
> Jun 02 20:01:19 smoon.bkoty.ru kernel: RDX: ffff9ce0ff2a1688 RSI:
> 0000000000000001 RDI: ffff9ce0ff2a1680
> Jun 02 20:01:19 smoon.bkoty.ru kernel: RBP: ffffb6050254b85c R08:
> 0000000000000000 R09: ffffb6050254b688
> Jun 02 20:01:19 smoon.bkoty.ru kernel: R10: 0000000000000003 R11:
> ffffffff89aca028 R12: ffff9cd9f2fb6050
> Jun 02 20:01:19 smoon.bkoty.ru kernel: R13: ffff9cd9f2fb6000 R14:
> ffff9cd9f2fb6fb0 R15: 000000000000000c
> Jun 02 20:01:19 smoon.bkoty.ru kernel: FS:  00007f75cad39200(0000)
> GS:ffff9ce0ff280000(0000) knlGS:0000000000000000
> Jun 02 20:01:19 smoon.bkoty.ru kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> Jun 02 20:01:19 smoon.bkoty.ru kernel: CR2: 00007f75cb7a1000 CR3:
> 0000000155a3a002 CR4: 00000000003706e0
> Jun 02 20:01:19 smoon.bkoty.ru kernel: Call Trace:
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  <TASK>
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  ? xfs_attr3_leaf_add_work+0x4f5/0x540
> [xfs ecac3a792ff4924c3e2601105ba002d1f7178133]
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  ? __warn+0x81/0x130
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  ? xfs_attr3_leaf_add_work+0x4f5/0x540
> [xfs ecac3a792ff4924c3e2601105ba002d1f7178133]
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  ? report_bug+0x171/0x1a0
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  ? prb_read_valid+0x1b/0x30
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  ? handle_bug+0x3c/0x80
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  ? exc_invalid_op+0x17/0x70
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  ? asm_exc_invalid_op+0x1a/0x20
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  ? xfs_attr3_leaf_add_work+0x4f5/0x540
> [xfs ecac3a792ff4924c3e2601105ba002d1f7178133]
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  ? xfs_attr3_leaf_add_work+0x4f5/0x540
> [xfs ecac3a792ff4924c3e2601105ba002d1f7178133]
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  xfs_attr3_leaf_add+0x1a3/0x210 [xfs
> ecac3a792ff4924c3e2601105ba002d1f7178133]
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  xfs_attr_shortform_to_leaf+0x23f/0x250
> [xfs ecac3a792ff4924c3e2601105ba002d1f7178133]
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  xfs_attr_set_iter+0x772/0x910 [xfs
> ecac3a792ff4924c3e2601105ba002d1f7178133]
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  xfs_xattri_finish_update+0x18/0x50 [xfs
> ecac3a792ff4924c3e2601105ba002d1f7178133]
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  xfs_attr_finish_item+0x1e/0xb0 [xfs
> ecac3a792ff4924c3e2601105ba002d1f7178133]
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  xfs_defer_finish_noroll+0x193/0x6e0
> [xfs ecac3a792ff4924c3e2601105ba002d1f7178133]
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  __xfs_trans_commit+0x2d8/0x3e0 [xfs
> ecac3a792ff4924c3e2601105ba002d1f7178133]
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  xfs_attr_set+0x48a/0x6a0 [xfs
> ecac3a792ff4924c3e2601105ba002d1f7178133]
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  xfs_xattr_set+0x8d/0xe0 [xfs
> ecac3a792ff4924c3e2601105ba002d1f7178133]
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  __vfs_setxattr+0x96/0xd0
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  __vfs_setxattr_noperm+0x77/0x1d0
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  vfs_setxattr+0x9f/0x180
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  setxattr+0x9e/0xc0
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  __x64_sys_fsetxattr+0xbf/0xf0
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  do_syscall_64+0x5d/0x90
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  ? syscall_exit_to_user_mode+0x1b/0x40
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  ? do_syscall_64+0x6c/0x90
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  ? syscall_exit_to_user_mode+0x1b/0x40
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  ? do_syscall_64+0x6c/0x90
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  ? syscall_exit_to_user_mode+0x1b/0x40
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  ? do_syscall_64+0x6c/0x90
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  ? exc_page_fault+0x7f/0x180
> Jun 02 20:01:19 smoon.bkoty.ru kernel: 
> entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> Jun 02 20:01:19 smoon.bkoty.ru kernel: RIP: 0033:0x7f75cb2023be
> Jun 02 20:01:19 smoon.bkoty.ru kernel: Code: 48 8b 0d 9d 49 0d 00 f7 d8 64 89
> 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 be
> 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 6a 49 0d 00 f7 d8 64 89 01
> 48
> Jun 02 20:01:19 smoon.bkoty.ru kernel: RSP: 002b:00007ffd172d1a68 EFLAGS:
> 00000202 ORIG_RAX: 00000000000000be
> Jun 02 20:01:19 smoon.bkoty.ru kernel: RAX: ffffffffffffffda RBX:
> 00007ffd172d2188 RCX: 00007f75cb2023be
> Jun 02 20:01:19 smoon.bkoty.ru kernel: RDX: 000055d5735653ae RSI:
> 000055d571d48a5f RDI: 0000000000000007
> Jun 02 20:01:19 smoon.bkoty.ru kernel: RBP: 000055d571d4b618 R08:
> 0000000000000001 R09: 0000000000000001
> Jun 02 20:01:19 smoon.bkoty.ru kernel: R10: 000000000000000f R11:
> 0000000000000202 R12: 000055d5735653ae
> Jun 02 20:01:19 smoon.bkoty.ru kernel: R13: 0000000000000007 R14:
> 000055d571d48a5f R15: 000055d571d4b638
> Jun 02 20:01:19 smoon.bkoty.ru kernel:  </TASK>
> Jun 02 20:01:19 smoon.bkoty.ru kernel: ---[ end trace 0000000000000000 ]---
> ```
> 
> On another host running the same kernel with almost identical environment (CPU
> and FS on hard disks), I don't see this message.
> 
> The flags used to mount the FS:
> ```
> $ grep 'xfs' /etc/fstab
> PARTUUID=7c9a5053-216d-2b4e-8c73-22d16a87ae6b   /                        xfs  
> rw,relatime,attr2,inode64,noquota  0 1
> PARTUUID=88b4e2db-862b-8b41-a331-66c483237a23   /var                     xfs  
> rw,relatime,attr2,inode64,noquota  0 2
> PARTUUID=d0099f96-70d9-3846-835c-e7d7da363048   /usr/local               xfs  
> rw,relatime,attr2,inode64,noquota  0 2
> PARTUUID=ffde9d45-2275-c446-b54c-fcf96bd93a5f   /home                    xfs  
> rw,relatime,attr2,inode64,noquota  0 2
> PARTUUID=8cec7c90-441a-1d49-94af-a5176a9fd973   /srv/nfs/cache           xfs  
> rw,relatime,attr2,inode64,noquota  0 2
> PARTUUID=39dd3664-0a48-d144-8e65-414d5d549c2f   /mnt/aux                 xfs  
> rw,relatime,attr2,inode64,noquota  0 2
> PARTUUID=a5480aca-273b-4d4c-8520-f782293ed878   /mnt/storage             xfs  
> rw,relatime,attr2,inode64,noquota  0 2
> PARTUUID=231b1235-c9a1-e249-8332-fd9141c89ae7   /mnt/data                xfs  
> rw,relatime,attr2,inode64,noquota  0 2
> PARTUUID=bab3d4b7-2b1e-492d-9298-de6170d2098f   /mnt/archive             xfs  
> rw,relatime,attr2,inode64,noquota  0 2
> PARTUUID=55fd9e2f-605e-4a01-b0c2-f6a9df302301   /media/storage           xfs  
> auto,x-systemd.automount,x-systemd.device-timeout=20,nofail  0 2
> ```
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.
