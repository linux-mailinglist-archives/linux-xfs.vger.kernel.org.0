Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182584EE288
	for <lists+linux-xfs@lfdr.de>; Thu, 31 Mar 2022 22:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiCaUVw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 31 Mar 2022 16:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241369AbiCaUVw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Mar 2022 16:21:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C491C1EEF
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 13:20:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71793CE2259
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 20:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF20DC34113
        for <linux-xfs@vger.kernel.org>; Thu, 31 Mar 2022 20:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648758000;
        bh=mxoiXbP/150yZnWmwrxSn3rHeAfwaogczaVEQ1j0yM4=;
        h=From:To:Subject:Date:From;
        b=jGM/zohWhsQC9fai5gMJRYLcMIrLVv8mXmbJT5itHAnBF7GQSEeiaQ6h8tD5IaSVF
         iKtarrtPoQOJBGXTf5hbCLOFQKVPu4w4qtGXYM4g0/JGWJ9krh6Cu8Bnsg5KX1MRty
         nEuXUvt8iW/wznhTJzs6IkNkq61hUERvSG2bGtrncOuiaCGHtbenbjMlag6hQaJKtG
         d44yH9N3RBugZLzw737Mk0hxE7HHSPRMe6X3xyy67cxYjiy0MUcwV1pU91+4GT8K9w
         patXMtGhtu3CGrBvmDFVU7/CP0rK7uic3B3WBNT48Yi6rBOOR4Qn1woMtFtGYdtu4a
         6lUt3Kh/XCBfw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 98F73C05FD6; Thu, 31 Mar 2022 20:20:00 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215784] New: kernel NULL pointer dereference in
 fs/xfs/xfs_buf_item_recover.c: xlog_recover_do_inode_buffer() when mount a
 corrupted image
Date:   Thu, 31 Mar 2022 20:19:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: wenqingliu0120@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-215784-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215784

            Bug ID: 215784
           Summary: kernel NULL pointer dereference in
                    fs/xfs/xfs_buf_item_recover.c:
                    xlog_recover_do_inode_buffer() when mount a corrupted
                    image
           Product: File System
           Version: 2.5
    Kernel Version: 5.17.1, 5.15.32
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: wenqingliu0120@gmail.com
        Regression: No

Created attachment 300672
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D300672&action=3Dedit
corrupted image and .config

- Overview=20
kernel NULL pointer dereference in fs/xfs/xfs_buf_item_recover.c:
xlog_recover_do_inode_buffer() when mount a corrupted image

- Reproduce=20
tested on kernel 5.17.1, 5.15.32

$ mkdir mnt
$ unzip tmp18.zip
$ sudo mount -t xfs tmp18.img mnt

- Kernel dump
[   26.379286] loop0: detected capacity change from 0 to 32768
[   26.399630] XFS (loop0): Deprecated V4 format (crc=3D0) will not be supp=
orted
after September 2030.
[   26.399771] XFS (loop0): Mounting V10 Filesystem
[   26.399889] XFS (loop0): Log size 87 blocks too small, minimum size is 8=
45
blocks
[   26.399892] XFS (loop0): Log size out of supported range.
[   26.399916] XFS (loop0): Continuing onwards, but if log hangs are
experienced then please report this message in the bug report.
[   26.404903] XFS (loop0): Starting recovery (logdev: internal)
[   26.406206] BUG: kernel NULL pointer dereference, address: 0000000000000=
060
[   26.406251] #PF: supervisor read access in kernel mode
[   26.406273] #PF: error_code(0x0000) - not-present page
[   26.406294] PGD 0 P4D 0=20
[   26.406304] Oops: 0000 [#1] PREEMPT SMP NOPTI
[   26.406319] CPU: 0 PID: 895 Comm: mount Not tainted 5.17.1 #1
[   26.406340] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.13.0-1ubuntu1.1 04/01/2014
[   26.406371] RIP: 0010:xlog_recover_do_inode_buffer+0x10f/0x230 [xfs]
[   26.406681] Code: 5d 41 5e 41 5f 5d c3 44 39 d3 7c 6b 48 8b 4d b8 49 63 =
c4
48 63 f3 48 c1 e0 04 49 63 fa 48 89 f3 48 29 fb 48 03 41 18 48 03 18 <8b> 0=
b 85
c9 0f 84 ac 00 00 00 48 8b 7d c0 44 89 45 ac 44 89 55 b0
[   26.406744] RSP: 0018:ffffa72b009ab988 EFLAGS: 00010206
[   26.406764] RAX: ffff98f38f553ef0 RBX: 0000000000000060 RCX:
ffff98f38f640900
[   26.406789] RDX: 0000000000000003 RSI: 0000000000000060 RDI:
0000000000000000
[   26.406814] RBP: ffffa72b009ab9e0 R08: 0000000000000180 R09:
8080808080808080
[   26.406840] R10: 0000000000000000 R11: fefefefefefefeff R12:
0000000000000001
[   26.406867] R13: ffff98f38e456000 R14: 0000000000000000 R15:
ffff98f391418600
[   26.406894] FS:  00007f649dd76080(0000) GS:ffff98f575c00000(0000)
knlGS:0000000000000000
[   26.406923] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   26.406943] CR2: 0000000000000060 CR3: 00000001068fe006 CR4:
0000000000370ef0
[   26.406972] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   26.406998] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[   26.407025] Call Trace:
[   26.407050]  <TASK>
[   26.407061]  ? __xfs_buf_submit+0x9b/0x1d0 [xfs]
[   26.407175]  xlog_recover_buf_commit_pass2+0x48c/0x650 [xfs]
[   26.407300]  xlog_recover_items_pass2+0x4e/0xc0 [xfs]
[   26.407429]  xlog_recover_commit_trans+0x2de/0x300 [xfs]
[   26.407552]  xlog_recovery_process_trans+0x8e/0xc0 [xfs]
[   26.407672]  xlog_recover_process_data+0xab/0x130 [xfs]
[   26.407795]  xlog_do_recovery_pass+0x2d5/0x5c0 [xfs]
[   26.407917]  xlog_do_log_recovery+0x7f/0xb0 [xfs]
[   26.408036]  xlog_do_recover+0x34/0x190 [xfs]
[   26.408161]  xlog_recover+0xbc/0x170 [xfs]
[   26.408291]  xfs_log_mount+0x125/0x2d0 [xfs]
[   26.408402]  xfs_mountfs+0x4e0/0xa50 [xfs]
[   26.408517]  ? kmem_alloc+0x88/0x140 [xfs]
[   26.408627]  ? xfs_filestream_get_parent+0x70/0x70 [xfs]
[   26.408737]  xfs_fs_fill_super+0x69f/0x880 [xfs]
[   26.408848]  ? sget_fc+0x1be/0x230
[   26.408865]  ? xfs_fs_inode_init_once+0x70/0x70 [xfs]
[   26.408977]  get_tree_bdev+0x16a/0x280
[   26.408995]  vfs_get_tree+0x22/0xc0
[   26.409696]  path_mount+0x59b/0x9a0
[   26.410319]  do_mount+0x75/0x90
[   26.410919]  __x64_sys_mount+0x86/0xd0
[   26.411514]  do_syscall_64+0x37/0xb0
[   26.412135]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   26.412817] RIP: 0033:0x7f649d63715a
[   26.413372] Code: 48 8b 0d 31 8d 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 =
2e
0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3=
d 01
f0 ff ff 73 01 c3 48 8b 0d fe 8c 2c 00 f7 d8 64 89 01 48
[   26.414587] RSP: 002b:00007ffd3e3729d8 EFLAGS: 00000206 ORIG_RAX:
00000000000000a5
[   26.415210] RAX: ffffffffffffffda RBX: 000055b763052420 RCX:
00007f649d63715a
[   26.415832] RDX: 000055b763052600 RSI: 000055b763054320 RDI:
000055b76305bc40
[   26.416472] RBP: 0000000000000000 R08: 0000000000000000 R09:
000055b763052620
[   26.417099] R10: 00000000c0ed0000 R11: 0000000000000206 R12:
000055b76305bc40
[   26.417710] R13: 000055b763052600 R14: 0000000000000000 R15:
00007f649db588a4
[   26.418317]  </TASK>
[   26.418860] Modules linked in: joydev iscsi_tcp libiscsi_tcp libiscsi
input_leds serio_raw scsi_transport_iscsi qemu_fw_cfg xfs autofs4 raid10
raid456 hid_generic usbhid async_raid6_recov async_memcpy async_pq async_xor
hid async_tx raid1 raid0 multipath linear qxl drm_ttm_helper ttm drm_kms_he=
lper
syscopyarea sysfillrect sysimgblt fb_sys_fops drm crct10dif_pclmul crc32_pc=
lmul
ghash_clmulni_intel aesni_intel crypto_simd psmouse cryptd
[   26.421641] CR2: 0000000000000060
[   26.422322] ---[ end trace 0000000000000000 ]---
[   26.422928] RIP: 0010:xlog_recover_do_inode_buffer+0x10f/0x230 [xfs]
[   26.423656] Code: 5d 41 5e 41 5f 5d c3 44 39 d3 7c 6b 48 8b 4d b8 49 63 =
c4
48 63 f3 48 c1 e0 04 49 63 fa 48 89 f3 48 29 fb 48 03 41 18 48 03 18 <8b> 0=
b 85
c9 0f 84 ac 00 00 00 48 8b 7d c0 44 89 45 ac 44 89 55 b0
[   26.425066] RSP: 0018:ffffa72b009ab988 EFLAGS: 00010206
[   26.425819] RAX: ffff98f38f553ef0 RBX: 0000000000000060 RCX:
ffff98f38f640900
[   26.426511] RDX: 0000000000000003 RSI: 0000000000000060 RDI:
0000000000000000
[   26.427232] RBP: ffffa72b009ab9e0 R08: 0000000000000180 R09:
8080808080808080
[   26.427962] R10: 0000000000000000 R11: fefefefefefefeff R12:
0000000000000001
[   26.428690] R13: ffff98f38e456000 R14: 0000000000000000 R15:
ffff98f391418600
[   26.429405] FS:  00007f649dd76080(0000) GS:ffff98f575c00000(0000)
knlGS:0000000000000000
[   26.430096] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   26.430797] CR2: 0000000000000060 CR3: 00000001068fe006 CR4:
0000000000370ef0
[   26.431506] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   26.432226] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
