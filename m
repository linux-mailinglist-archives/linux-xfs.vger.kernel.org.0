Return-Path: <linux-xfs+bounces-25012-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EC62B37D56
	for <lists+linux-xfs@lfdr.de>; Wed, 27 Aug 2025 10:15:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B93C21BA3247
	for <lists+linux-xfs@lfdr.de>; Wed, 27 Aug 2025 08:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1774D334379;
	Wed, 27 Aug 2025 08:15:37 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B53127EFFE
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 08:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756282536; cv=none; b=dHLPOb45dmuEBiwimmk0M6QDGdb5JL0Wb9qt4aX0Do+g28raoYE+jOuWFoqSGVvNnHG5ca79vm2qkkbsnY3YYOxnhRE8lWJaBcaL+/ONribTxkKXK5Hc1WfAZJGRr9qmiknttUv2mc9P/5TmUqjQyFOhrYq2VrUDWXNVQXv28KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756282536; c=relaxed/simple;
	bh=m4FL+YwjjxPHuiR7uqDuYt9gdrCleurGT7eiu4YHhms=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=MtN3DBmWUc5k8c2hGDdHvr0nvvhSGSvd++5zEJhX3+7+QMvmJB7uKX1rgYnB3+i+b3k8kC+Xj+ciLCZC7hY2DaaonRy0TT1sxPR1p7Nh9k03bcTJVfJ7h+m2I/+BWxgcQzPqu7Hv1ihTk7Sg7epqa09xv/SbthUS7H79WS2sjmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-886febbe196so11873639f.3
        for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 01:15:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756282534; x=1756887334;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gTgJdBfA0oZMPicavM9FELt37YbVpVxthJ0GDI4sbTQ=;
        b=rt+vF85UpAZQ8tK6U64EF6fl4LwIV1bTvJgtB6C6x/tzwb6uQ/hiZNJI9d7K004zgk
         tRrTmwZkEqnhdv0PQOiEPoAZ3DjZyd71TkYt/6sco5KIucIDmy7LsnpLwI7zQ8H2HB1L
         7tusPmZwPXkH1kLaKPPom3eshW136UDBHD4UVENErT9kS/Dh88yD9mbMCXJxldiDVdmP
         f9LeQvHPbPLS5iidONhnwpiVZbwSBcvdpw4Xu/Ef7u3azx61FYTYUJGeJ0f2G8Tmx84F
         Ajs/kWSbkSrGsC6cVmNLaNcplVX/IvfIC+rhPo1qtUJOKx9WCwNWuWGQVlpUIPG99KYX
         HUWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzseBINyv5LsGFezSyL1i+7dE9PVR+Yn1GCZzfGc25JjlNLF6lqQKkabutDimKgPDqPfDKH46Er68=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJuWDSdLz2hoM15hcJuhVdrtZmUNbdaGBqFcJi4InnqKHr1Pof
	CAZQbUhNGHLwZWBcL/uK5TGZfKvQ4YCFDsBHLrfzAgWliV2O5xj6apJe9GPccm76NB/yZs6mdch
	KqWx3u13GDwq8k/QC0J+cixxysOwUrqZGFWUzYpxb8052Y0wuhWRqoRGUw/Y=
X-Google-Smtp-Source: AGHT+IETxI0GYk51S/ALlsOosxU/0xdROpMYDujoZT7ejlUZ3SuB9LC1DjO4nVdbY9MZ0gcKayq8kPOXOlHau29fuQqFpMLwZBz7
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:216b:b0:3ed:a4b6:55eb with SMTP id
 e9e14a558f8ab-3eda4b65723mr105044525ab.10.1756282534577; Wed, 27 Aug 2025
 01:15:34 -0700 (PDT)
Date: Wed, 27 Aug 2025 01:15:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68aebea6.a70a0220.3cafd4.0015.GAE@google.com>
Subject: [syzbot] Monthly xfs report (Aug 2025)
From: syzbot <syzbot+listf1f846890378c60ccd2e@syzkaller.appspotmail.com>
To: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 4 new issues were detected and 0 were fixed.
In total, 14 issues are still open and 27 have already been fixed.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 2624    Yes   INFO: task hung in sync_inodes_sb (5)
                  https://syzkaller.appspot.com/bug?extid=30476ec1b6dc84471133
<2> 271     Yes   BUG: Bad page state in iomap_write_begin
                  https://syzkaller.appspot.com/bug?extid=c317c107c68f8bc257d9
<3> 215     Yes   KASAN: slab-use-after-free Read in xfs_inode_item_push
                  https://syzkaller.appspot.com/bug?extid=1a28995e12fd13faa44e
<4> 29      Yes   INFO: task hung in vfs_setxattr (7)
                  https://syzkaller.appspot.com/bug?extid=3d0a18cd22695979a7c6
<5> 2       Yes   KASAN: slab-use-after-free Read in xlog_cil_push_work
                  https://syzkaller.appspot.com/bug?extid=95170b2e7d9e80b8a7d7

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

