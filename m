Return-Path: <linux-xfs+bounces-9990-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63CF391DCC7
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jul 2024 12:35:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E3D7283152
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jul 2024 10:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C83613E022;
	Mon,  1 Jul 2024 10:28:23 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E2C13212B
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jul 2024 10:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719829703; cv=none; b=f/I6XLKNepM64L29KWdpAFv3pg8sbkPS5mbapWq/Cy15cgAYT4GkadQJ2GPG8op5ybgXw95bILxkM85aaHL7UX2a3poNIVnZtFKjvb5urJfK0gdeGqPwttyJOS9kZRq79QJY8MmF8+A7IVQgL8s7qGi6uYKovguh+f1zhdRDCR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719829703; c=relaxed/simple;
	bh=97ox7ge8hmSa6Aeq71PmlkIBe5jGWS2sJRtMDt3CUEs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=DErA+s1VVVA60EtPncLzs+kZlp+uejAWG0SIsOrV2Vq8t2jOlwl+kfRySU3LavOk+YFOKah11kXBsCFg66CQjemGYVYLoiXJck4mvzqMofDi/DsCmRgldnvb3Pgy+7qX8jbMrQx9R4Qtyv5G3u20TN787ytSkZkSlARYvGczvbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7f59855336cso319786139f.0
        for <linux-xfs@vger.kernel.org>; Mon, 01 Jul 2024 03:28:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719829701; x=1720434501;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Re8DON4XHiHt6dKzpiAM/If0D5pMagFKauS5vNeg2Bw=;
        b=uqksEvdS2jYmTx3K3OiPkySnjigribnK32FgSEpiNIfLx3ZeBxNB97cRH/pg9eq3X4
         MzmfR+f/ffPcMyHVe2mCJ3c+p9UqSjscMl8vuCkowH7Pp/O0FucWqNQQ7rDL+LQO812x
         5sY73s7zY6J0kQjfP/T12EWuZ/AHpF9elwzVlreOvkBi7tg0el3nCCD+tu2ODFpaNJj2
         RhBC2hLaSLjZ+An0ZLPWrgE9Yr2ROXfQNstNTt/q0Ug0ry18qxr7n/4ujHuxjxc8KNi2
         FhpKq45LUE4XPdVbyeIT48IfMZI4C/y//GuvysMrVDIM+A6v3nAq7r+USj2iafFNWEk1
         KDJg==
X-Forwarded-Encrypted: i=1; AJvYcCXqGK6ZCoRdOF3wP1B231CJ5sQe05gl3JjLs+CyJ9FS1dZfGQacxqJoBXccNgQT9IRlAm/LVT4bdRGxpiHCqOUZG9ffLIZppdTJ
X-Gm-Message-State: AOJu0YzW6wJ2XFFakHOvmhG80plo/srgvDO9WmvgeO1Yrv2IbXSRUtw4
	Rr0N7P+2DN8sk6V5sGoLkDQndbO+e/byKsFfRl5qaVMuF2AE2O2BTL3shYA6Gapgxk99iGTDXLD
	R8XC9BeO5QmggRlxO9A+jQh1jZeIKHGJ55vxbr73jBcz9+LoZIRf1uAk=
X-Google-Smtp-Source: AGHT+IENHz27lqyF4XHNtAd7g84TRj1RoYmVTvoqSRrX6HyeUH0AjOxG50RjPZ6BG8rcHyjav8FAtfuDJddwTdB+XiEqMhhA5G1G
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3415:b0:7eb:8530:810 with SMTP id
 ca18e2360f4ac-7f62eea8cefmr26899439f.4.1719829701126; Mon, 01 Jul 2024
 03:28:21 -0700 (PDT)
Date: Mon, 01 Jul 2024 03:28:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000068fb29061c2d0e7c@google.com>
Subject: [syzbot] Monthly xfs report (Jul 2024)
From: syzbot <syzbot+listd8b7cc04330f5e8b3e92@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 0 new issues were detected and 0 were fixed.
In total, 14 issues are still open and 23 have been fixed so far.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 1422    No    possible deadlock in xfs_ilock (2)
                  https://syzkaller.appspot.com/bug?extid=c6d7bff58a2218f14632
<2> 853     Yes   KASAN: stack-out-of-bounds Read in xfs_buf_lock
                  https://syzkaller.appspot.com/bug?extid=0bc698a422b5e4ac988c
<3> 45      No    general protection fault in xfs_destroy_mount_workqueues
                  https://syzkaller.appspot.com/bug?extid=8905ded1b49ae88b96a6
<4> 45      No    KASAN: slab-use-after-free Read in xfs_inode_item_push
                  https://syzkaller.appspot.com/bug?extid=1a28995e12fd13faa44e
<5> 3       No    WARNING in mod_delayed_work_on
                  https://syzkaller.appspot.com/bug?extid=d9c37490b32d66c6bc78

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

