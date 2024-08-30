Return-Path: <linux-xfs+bounces-12516-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C56B965D4B
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2024 11:48:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F197F2826AE
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2024 09:48:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 141D916FF44;
	Fri, 30 Aug 2024 09:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gSdnmEZ5"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C35BEEB7;
	Fri, 30 Aug 2024 09:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725011309; cv=none; b=PNkqhQUeLJNx5v6atte2q+XZDGsKJ+5A4TkqxIcOLl4+7sYTLlnVvP730fbwX5pZy3IyrmeOzlHCVZOwQQ2ATo4L0pK8DXeKSlTnLXjHZqVt3t+fTiKQsJ0wX8B3HK5e05QyL5yZOt6Q/EjapgdRn8qzmK/OuT6aYyKAE6h6tsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725011309; c=relaxed/simple;
	bh=Q/rhZGGCFpZtbC5xbU/2iGU3qUy1MhfwvwGN3HHGEkY=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mbDtvVTW+/48INt5Py6b4z7krdxJoB+PPccV+btMHoKTaiSD282aYv06uQ3PgxmeV8rq+oHYcDQi41KCPyGd5Xnio7uEFBy6vv90+vlv98ToP+CkgHyzVSuoOJErv8hKiASxb1YDTL5u9TcxD1JTDg8GPoXqs0p2U7IjGjBTADo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gSdnmEZ5; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20202df1c2fso18519375ad.1;
        Fri, 30 Aug 2024 02:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725011307; x=1725616107; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rP4trEeuRs8rU3WJDDxHXc+6maOAdRJoijfPpM0VRLo=;
        b=gSdnmEZ5JYSusX6dT6hwGdse0+a+lwC/3nw/r1MVgF7vnBCg1DUU67Uzz2gHdMZGYC
         /NayrQeJWX1J9yXnVfdt7lxU+LjfdIB/JKl897Cmjnz7qBWcw2L/X/8S4dxz3hZL0qpd
         idhvXVGUWoxWKK2sOQT3YE6/W0PnZV1i4lxMtQSCLCPlctXoGUDyTFCyU/YJ57Vpxima
         bTycFn+tmrSky4lH0KVyKscNrEDTfRhztdmqcHFyV0ifLiVBieEtihMJIzTzLb7EYV2C
         AkfgVf24SRCgNyzGRHHiEGbRd/ycs60+8xbPz7jL0dhS5VDbJ/r2T3P1SCDLqctnAIaC
         kBwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725011307; x=1725616107;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rP4trEeuRs8rU3WJDDxHXc+6maOAdRJoijfPpM0VRLo=;
        b=jHMKXLfFpQKP/FBfIRApcul660U/87R870ncNS32gzzvuRxixVMSTouJhX+hBQhMJc
         az5ooBa3ini/mvutiKgNRIqhk2xXLJeN2pNlrG0iT61cjRJ/VCMyScP4ztiQJM6sHrNX
         bBEUTiXiyd18HzMZrencW+Dof4zZFpMPPSV9P9mi9zSA9qVwN+c1xYFy0lehwK9ZU2C5
         Pvwk/Xp/BJaBz4Y8OZJIubI/whm4XV93488RKQIAAw1uplSis/yQ5/IlVTxY1sq40nPr
         vJWFvqzRZZyOU1/toPUSp9bt5xoSyUtvChl8j5mWJh3ul713DeVmFxgDHI/UMnSeXbz2
         5qoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJk35tHaEbDPlAPJJmf3krt7mQuKbrNdGu6EBjZyL5tj4JpVs7wGyBPOAKd5du41C0PePg7U4AGRxwH9b0@vger.kernel.org, AJvYcCWOOVcuVjaQVrm7BopUnf1EaavDdjPxTBtKBneq0wAbdvT05FbEBHyEValRzcvXpTlKeT81MmhdMz/H3hhI@vger.kernel.org, AJvYcCXo7P7stByeJTDQSXHji8jN3a0ebqxY78X+Ud3+tm2qWH8ddcoKirg1qDOeZ7nflmmosFA5qRQoVvyl@vger.kernel.org
X-Gm-Message-State: AOJu0Yy272REuK3OxWCVSWrDoMOPdHmQS4LvWpe5BMgxVVtS7NIJx+9X
	/5BVTcPOnoc0ZguP4GrjonTkx80ZQq3ZZzqfJtU9UM4UT0z5vpOz
X-Google-Smtp-Source: AGHT+IFUHv4NlP67moIb7PvFaWCUYc0jv/H9kTpts63Iexcd2yb65SkNnIiRrd3AIyJNx0QsqYZEsg==
X-Received: by 2002:a17:902:ce85:b0:201:f2a4:cf74 with SMTP id d9443c01a7336-2050ea1658amr82777765ad.22.1725011307214;
        Fri, 30 Aug 2024 02:48:27 -0700 (PDT)
Received: from [127.0.0.1] ([103.85.75.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20515545d75sm23650115ad.237.2024.08.30.02.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 02:48:26 -0700 (PDT)
Message-ID: <df7fc9c1863f353091cfcb84f04e365aa4609bab.camel@gmail.com>
Subject: Re: [syzbot] [iomap?] [xfs?] WARNING in iomap_write_begin
From: Julian Sun <sunjunchao2870@gmail.com>
To: syzbot <syzbot+296b1c84b9cbf306e5a0@syzkaller.appspotmail.com>, 
	brauner@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Date: Fri, 30 Aug 2024 17:48:22 +0800
In-Reply-To: <0000000000008964f1061f8c32b6@google.com>
References: <0000000000008964f1061f8c32b6@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-08-13 at 01:14 -0700, syzbot wrote:
Test the following patch.

#syz test: upstream ee9a43b7cfe2


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 72c981e3dc92..6216c31aa3cc 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1162,6 +1162,9 @@ xfs_buffered_write_iomap_begin(
        if (error)
                goto out_unlock;
=20
+       /* Get extent info that may updated by
xfs_bmapi_reserve_delalloc() */
+       xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &icur,
&imap);
+
        /*
         * Flag newly allocated delalloc blocks with IOMAP_F_NEW so we
punch
         * them out if the write happens to fail.


> > Hello,
> >=20
> > syzbot found the following issue on:
> >=20
> > HEAD commit:=C2=A0=C2=A0=C2=A0 ee9a43b7cfe2 Merge tag 'net-6.11-rc3' of
> > git://git.kernel...
> > git tree:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 upstream
> > console+strace:
> > https://syzkaller.appspot.com/x/log.txt?x=3D10b70c5d980000
> > kernel config:=C2=A0
> > https://syzkaller.appspot.com/x/.config?x=3D9358cc4a2e37fd30
> > dashboard link:
> > https://syzkaller.appspot.com/bug?extid=3D296b1c84b9cbf306e5a0
> > compiler:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Debian clang version 15.0=
.6, GNU ld (GNU Binutils
> > for
> > Debian) 2.40
> > syz repro:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> > https://syzkaller.appspot.com/x/repro.syz?x=3D139519d9980000
> > C reproducer:=C2=A0=C2=A0
> > https://syzkaller.appspot.com/x/repro.c?x=3D13deb97d980000
> >=20
> > Downloadable assets:
> > disk image:
> > https://storage.googleapis.com/syzbot-assets/e6062f24de48/disk-ee9a43b7=
.raw.xz
> > vmlinux:
> > https://storage.googleapis.com/syzbot-assets/5d3ec6153dbd/vmlinux-ee9a4=
3b7.xz
> > kernel image:
> > https://storage.googleapis.com/syzbot-assets/98dbabb91d02/bzImage-ee9a4=
3b7.xz
> > mounted in repro:
> > https://storage.googleapis.com/syzbot-assets/4d05d229907e/mount_0.gz
> >=20
> > IMPORTANT: if you fix the issue, please add the following tag to
> > the
> > commit:
> > Reported-by: syzbot+296b1c84b9cbf306e5a0@syzkaller.appspotmail.com
> >=20
> > ------------[ cut here ]------------
> > WARNING: CPU: 1 PID: 5222 at fs/iomap/buffered-io.c:727
> > __iomap_write_begin fs/iomap/buffered-io.c:727 [inline]
> > WARNING: CPU: 1 PID: 5222 at fs/iomap/buffered-io.c:727
> > iomap_write_begin+0x13f0/0x16f0 fs/iomap/buffered-io.c:830
> > Modules linked in:
> > CPU: 1 UID: 0 PID: 5222 Comm: syz-executor247 Not tainted
> > 6.11.0-rc2-syzkaller-00111-gee9a43b7cfe2 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine,
> > BIOS Google 06/27/2024
> > RIP: 0010:__iomap_write_begin fs/iomap/buffered-io.c:727 [inline]
> > RIP: 0010:iomap_write_begin+0x13f0/0x16f0 fs/iomap/buffered-
> > io.c:830
> > Code: b5 0d 01 90 48 c7 c7 a0 54 fa 8b e8 da 19 2b ff 90 0f 0b 90
> > 90
> > e9 74 ef ff ff e8 5b f1 68 ff e9 4b f6 ff ff e8 51 f1 68 ff 90 <0f>
> > 0b 90 bb fb ff ff ff e9 e9 fe ff ff e8 3e f1 68 ff 90 0f 0b 90
> > RSP: 0018:ffffc90003a577c0 EFLAGS: 00010293
> > RAX: ffffffff822a858f RBX: 0000000000000080 RCX: ffff888023080000
> > RDX: 0000000000000000 RSI: 0000000000000080 RDI: 0000000000000000
> > RBP: ffffc90003a57a50 R08: ffffffff822a8294 R09: 1ffff11029263f69
> > R10: dffffc0000000000 R11: ffffed1029263f6a R12: ffffc90003a579b0
> > R13: ffffc90003a57bf0 R14: ffffc90003a57990 R15: 0000000000000800
> > FS:=C2=A0 000055555f8fc480(0000) GS:ffff8880b9300000(0000)
> > knlGS:0000000000000000
> > CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000020001000 CR3: 0000000079b06000 CR4: 00000000003506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> > =C2=A0<TASK>
> > =C2=A0iomap_unshare_iter fs/iomap/buffered-io.c:1351 [inline]
> > =C2=A0iomap_file_unshare+0x460/0x780 fs/iomap/buffered-io.c:1391
> > =C2=A0xfs_reflink_unshare+0x173/0x5f0 fs/xfs/xfs_reflink.c:1681
> > =C2=A0xfs_file_fallocate+0x6be/0xa50 fs/xfs/xfs_file.c:997
> > =C2=A0vfs_fallocate+0x553/0x6c0 fs/open.c:334
> > =C2=A0ksys_fallocate fs/open.c:357 [inline]
> > =C2=A0__do_sys_fallocate fs/open.c:365 [inline]
> > =C2=A0__se_sys_fallocate fs/open.c:363 [inline]
> > =C2=A0__x64_sys_fallocate+0xbd/0x110 fs/open.c:363
> > =C2=A0do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> > =C2=A0do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> > =C2=A0entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7f2d716a6899
> > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8
> > 48
> > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48>
> > 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007ffd620c3d18 EFLAGS: 00000246 ORIG_RAX:
> > 000000000000011d
> > RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2d716a6899
> > RDX: 0000000000000000 RSI: 0000000000000040 RDI: 0000000000000006
> > RBP: 0000000000000000 R08: 0700000000000000 R09: 0700000000000000
> > R10: 0000000000002000 R11: 0000000000000246 R12: 00007ffd620c3d60
> > R13: 00007ffd620c3fe8 R14: 431bde82d7b634db R15: 00007f2d716ef03b
> > =C2=A0</TASK>
> >=20
> >=20
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ=C2=A0for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >=20
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status=C2=A0for how to communicate with syzbot.
> >=20
> > If the report is already addressed, let syzbot know by replying
> > with:
> > #syz fix: exact-commit-title
> >=20
> > If you want syzbot to run the reproducer, reply with:
> > #syz test: git://repo/address.git branch-or-commit-hash
> > If you attach or paste a git patch, syzbot will apply it before
> > testing.
> >=20
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> >=20
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> >=20
> > If you want to undo deduplication, reply with:
> > #syz undup

--=20
Julian Sun <sunjunchao2870@gmail.com>

--=20
Julian Sun <sunjunchao2870@gmail.com>

