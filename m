Return-Path: <linux-xfs+bounces-11698-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40C15952CCE
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Aug 2024 12:49:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49D3A282B3C
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Aug 2024 10:49:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0654B1AC881;
	Thu, 15 Aug 2024 10:40:28 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D031AC886
	for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 10:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723718427; cv=none; b=sHZB4FW0VV52sPbimj0QENDtBwXFueSUC961N1g+EdBCiSoY5F54iKPUYMOsjuTRX/BK9VrsccD0W2d0WcGlKMOeWaF+2+489i6Y39MOL6gQctYTUbQRtpqqDWheIXXvIHVJ+mfFbnlgaPWQ1Fw3NGE2pY2iFDO7dXlCqupbuRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723718427; c=relaxed/simple;
	bh=z1ba+5EJVDOkslQ+E/z3CgpEv67HZzOhoQigUq+k5cQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OYAQRZ+KYD6PUUBRiXHTHEUBHhIbY0w/ZNRO7FAgog2DEuXWOKy7CyVW9zZ3g26GZMbSPJ0vk/HDPd/bev0EqIqGaxH/5LYAt8SsNvqjQmGMgWRA/25EUo4CgnMnlsneftl1XtNaVkKVH+zXaB0eyKivsB87kdZSw8VilYjKAmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-81f93601444so82740839f.2
        for <linux-xfs@vger.kernel.org>; Thu, 15 Aug 2024 03:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723718425; x=1724323225;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=opiCOyLB/xPeMdw+vyiT2OWRVsp382tiiE0i299tivY=;
        b=n7+11EKwH2VYWuiJ8nPfEXKlAhwKMS7OjjnTZQOpFQR26rtvgAmtyJ18SfQqhudcR9
         BUZB1xMr/kmLgAFGyd9sYiYIwHtEBVh9+LvKqbdfB12QSoK+FUIj5ZbDmjhvlwouhPqP
         z0UQdUlT/Xm3yNjSd828oXR7QEc5eMq1R4xVBHepDpaoTm7cDXtmybwOYKE74XeCtt74
         Q7dGIACCssdDu+BKdrf3Aif0rMGxKKI1ht79+w9oxQrbUswsoy9TuJRbmDkckaUB1pOM
         v1Wueb3qtR9T6yefsdshe/FqnsBqLRQKb/o3Uz9dIQNBCTxbA+pDpPQ8RprlgLTSH5P1
         974g==
X-Forwarded-Encrypted: i=1; AJvYcCU8K/MzXcKl2H/Ca2ZVqna5oVgwpRIOfM6DP1FU0iYR+h2qD5WAUQrO9ul7VdlrvkGnqWuu6vj+vewVZ+YP1J+4qSZ0fYo74NFT
X-Gm-Message-State: AOJu0Yx2voLLKeCrQ6ilhkkYAm0KxQNqP/ruX2Y+ybBC0aPp+THUyAgt
	JqxbS3HPKfoP9Tma1iZQvZue7Qy8vwbf/kAS1JQFkuRpoBu1A/8sPc426wN6125w0LDV07ebrdE
	S5n/5gE4lR8iOD6OCPpQOfkjMKQBbpo5K9aauUpeI4l7WfLtM4syEC8k=
X-Google-Smtp-Source: AGHT+IHwFK/7Fi1D4ndezxiB63QY2Su/S65+td2Lvy/Y8aP12/SaksBUdM8x7drT5SN13mffR4o50rRGTKkU4SCvPTX7wNuZem2M
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12c1:b0:396:ec3b:df63 with SMTP id
 e9e14a558f8ab-39d124f3e2cmr3864035ab.4.1723718425574; Thu, 15 Aug 2024
 03:40:25 -0700 (PDT)
Date: Thu, 15 Aug 2024 03:40:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000731785061fb678d5@google.com>
Subject: [syzbot] Monthly xfs report (Aug 2024)
From: syzbot <syzbot+list4f8957ccf166d2563804@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 1 new issues were detected and 0 were fixed.
In total, 12 issues are still open and 23 have been fixed so far.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 74      Yes   possible deadlock in xfs_icwalk_ag (2)
                  https://syzkaller.appspot.com/bug?extid=4248e91deb3db78358a2
<2> 69      No    KASAN: slab-use-after-free Read in xfs_inode_item_push
                  https://syzkaller.appspot.com/bug?extid=1a28995e12fd13faa44e
<3> 22      No    possible deadlock in xfs_ilock_attr_map_shared
                  https://syzkaller.appspot.com/bug?extid=069cc167ecbee6e3e91a

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

