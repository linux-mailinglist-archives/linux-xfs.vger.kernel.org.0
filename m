Return-Path: <linux-xfs+bounces-12283-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96A5C960A9D
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Aug 2024 14:38:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C36D71C20492
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Aug 2024 12:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F7F31BAED5;
	Tue, 27 Aug 2024 12:38:04 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE60E1B9B4A
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 12:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724762284; cv=none; b=gV2ignjSH1oqGAmP95E4mGikysWeRtSQwScvS1yil3Fqy7k0BQulzUnDmbGrgI+oCW8odQxEDkT31HUilFvJv7msfHQtZ/0b3BIQqoALJkwp+0kwpq52/3MjWDMOIFUTUN+dXYgF/wDMGC9CiZjwbRwIFL9dg03r4dASJA7gd9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724762284; c=relaxed/simple;
	bh=PneBBWaY0SjtyPv/fNcyaurRkY5sx0Vclmfxtzmjlvg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=PvZdt3Nf/X+Cb3kLdBGMsgsFEbiN5OrVIw+kzwFRhvqBhQI+DaUF9J5j95U8QzitLza11fAFOr2628XUnd++MQFUZP+olVdjc+bg5jVZuKlygDEmzz0p9hq63fvOFWC5+n0+BHbBNnAN+t9cVF1BM495VJoIxcuvpXKzyxG+YZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-81f901cd3b5so580451039f.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 05:38:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724762282; x=1725367082;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CfQ2CgWV47HDV4GkEW+OxKq3IqX2dW3HcTDz2QDznTM=;
        b=MfCvIOgskeGSxiw4fCczFguvJdSahiS/6Ril0ryUrZm1BEqU8MUok1OnDkSv8YkzRS
         DySpKWPXcHj8yZ0JXCtz0j7RTEvVT1yU+CTD8wioDSAA2Lt75yWPAULFPnVNogUDeYlV
         vKmYlzB2R10kYUgHwYD3VkTNx568X+Ulf1x2u1jnWjN1YkslW/9vvvqHP6XalqV9OiHS
         Aw+N9+4jsCeH4IlcWYezS4p8+KlNPEwvNoKe85XCPve03P7BzD6M01v4qkk4vIDrCHeb
         7WVHDYTCC0EX5M72Tr1Q/nfsqCMSnyBohImNEsIyUAscTazoKKpVieKJaBtVD3PXNeBT
         hUXw==
X-Forwarded-Encrypted: i=1; AJvYcCVPP5IfB35blKDSlVLV0LbAbux3+r2guA6RmGL7mqltido3z3WcYe+1L6NlceWXszCGOTqXMiGs07E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7OTyGz2JuJe11FN4t5YNnJamM1DvnyGWIeMl+YhrEn+HAHKL+
	qpKtPHzuxpYJSuHiojvzWl7gLdPaKZLWtwdrfEL8P0SH+V4C1fTr8ifeMiuMKGUqJ2zzgFOFY5E
	FBwy8pxbAirdCHETp2DiEtC6/gfygrf+/oihw+1+CANRcT2+zbeOWcIA=
X-Google-Smtp-Source: AGHT+IG+xxzMobc+xtKYrfH8fdxyx/EEiozghUn4UEmJywnZpi7IEKNYeU34TiR52ffvh5hl0mxpdeWRMCFgpwzAKzAMRMWvM38e
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:13c3:b0:4ce:8f9d:2c31 with SMTP id
 8926c6da1cb9f-4ceb4d43fa1mr160147173.0.1724762281987; Tue, 27 Aug 2024
 05:38:01 -0700 (PDT)
Date: Tue, 27 Aug 2024 05:38:01 -0700
In-Reply-To: <CANp29Y4JzKFbDiCoYykH1zO1xxeG8MNCtNZO8aXV47JdLF6UXw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000023e3760620a98329@google.com>
Subject: Re: [syzbot] [iomap?] [xfs?] WARNING in iomap_write_begin
From: syzbot <syzbot+296b1c84b9cbf306e5a0@syzkaller.appspotmail.com>
To: brauner@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, 
	hch@infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, nogikh@google.com, 
	sunjunchao2870@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in iomap_write_begin

XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
XFS (loop0): Ending clean mount
XFS (loop0): Quotacheck needed: Please wait.
XFS (loop0): Quotacheck: Done.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 6042 at fs/iomap/buffered-io.c:727 __iomap_write_begin fs/iomap/buffered-io.c:727 [inline]
WARNING: CPU: 0 PID: 6042 at fs/iomap/buffered-io.c:727 iomap_write_begin+0x13f0/0x16f0 fs/iomap/buffered-io.c:830
Modules linked in:
CPU: 0 UID: 0 PID: 6042 Comm: syz.0.15 Not tainted 6.11.0-rc5-syzkaller-00015-g3e9bff3bbe13 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
RIP: 0010:__iomap_write_begin fs/iomap/buffered-io.c:727 [inline]
RIP: 0010:iomap_write_begin+0x13f0/0x16f0 fs/iomap/buffered-io.c:830
Code: b6 0d 01 90 48 c7 c7 e0 53 fa 8b e8 da 10 2b ff 90 0f 0b 90 90 e9 74 ef ff ff e8 eb ec 68 ff e9 4b f6 ff ff e8 e1 ec 68 ff 90 <0f> 0b 90 bb fb ff ff ff e9 e9 fe ff ff e8 ce ec 68 ff 90 0f 0b 90
RSP: 0018:ffffc9000315f7c0 EFLAGS: 00010293
RAX: ffffffff822a9ebf RBX: 0000000000000080 RCX: ffff88801ff39e00
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 0000000000000000
RBP: ffffc9000315fa50 R08: ffffffff822a9bc4 R09: 1ffff1100c1a82f9
R10: dffffc0000000000 R11: ffffed100c1a82fa R12: ffffc9000315f9b0
R13: ffffc9000315fbf0 R14: ffffc9000315f990 R15: 0000000000000800
FS:  00007f572bb8f6c0(0000) GS:ffff8880b9200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020001000 CR3: 0000000020098000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 iomap_unshare_iter fs/iomap/buffered-io.c:1351 [inline]
 iomap_file_unshare+0x460/0x780 fs/iomap/buffered-io.c:1391
 xfs_reflink_unshare+0x173/0x5f0 fs/xfs/xfs_reflink.c:1681
 xfs_file_fallocate+0x6be/0xa50 fs/xfs/xfs_file.c:997
 vfs_fallocate+0x553/0x6c0 fs/open.c:334
 ksys_fallocate fs/open.c:357 [inline]
 __do_sys_fallocate fs/open.c:365 [inline]
 __se_sys_fallocate fs/open.c:363 [inline]
 __x64_sys_fallocate+0xbd/0x110 fs/open.c:363
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f572ad779f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f572bb8f038 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
RAX: ffffffffffffffda RBX: 00007f572af05f80 RCX: 00007f572ad779f9
RDX: 0000000000000000 RSI: 0000000000000040 RDI: 0000000000000006
RBP: 00007f572ade58ee R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000002000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f572af05f80 R15: 00007fff39de1648
 </TASK>


Tested on:

commit:         3e9bff3b Merge tag 'vfs-6.11-rc6.fixes' of gitolite.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13ca847b980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a0455552d0b27491
dashboard link: https://syzkaller.appspot.com/bug?extid=296b1c84b9cbf306e5a0
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.

