Return-Path: <linux-xfs+bounces-12922-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F3197973F
	for <lists+linux-xfs@lfdr.de>; Sun, 15 Sep 2024 16:39:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78E80282145
	for <lists+linux-xfs@lfdr.de>; Sun, 15 Sep 2024 14:39:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F31B91C7B7E;
	Sun, 15 Sep 2024 14:39:24 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAE41C68A8
	for <linux-xfs@vger.kernel.org>; Sun, 15 Sep 2024 14:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726411164; cv=none; b=nD65hf6Ha7A6pRzu10ifgsnMqGPhMjmKVpQSN/hC2QiuFqO1muUG/bPYaKSPZQ6OVZQ/KFWgV6txtvN7gltROoRUn6BeHqbWgDrL3e4RbE9T+G4k66GN9RgGL8RKXbRe6mPyFgzoLtg9tkk/sXoWKGDcCYrRNTxCrO+RcbUK7i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726411164; c=relaxed/simple;
	bh=ugIgT3P62YyJVUICzflGXO4+NPncChk5Efv/8bam+Lk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XVW7plBl6CLdzRFLLMmNQ8jHM0moG4zmNRs4XKoddTpy6tXudF0oogcTP2bjnVhkDQlVgyflc1vq181XTHzAHSNdF9lFGdVG1PJHgk3zVj3UHly6SG96IoNzy7kL+nw1muSM20mFTJ7t5yZq1qEJciHIiq+rq09TfNPtSwlCcMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-82ce3316d51so695520339f.1
        for <linux-xfs@vger.kernel.org>; Sun, 15 Sep 2024 07:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726411162; x=1727015962;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZCeSY0Tg+irvuLC3MHarMWgiDRbCnO96UywqFeUzQRo=;
        b=q+0DeEIM5Dpf8oXYT4mObpEq5EXd1cZ0C7FDNAf2pzRxrUyVRAtITf4hwhIEpyLyoL
         v1k+6jVdk2R1FOHRSWgxD4E/QuGiNnnih78RR2oqLYEDUq0x77X1QZvc3gRhGlw1dpDA
         2+wnfV1xNeyfWYYOL8hXxZ4oiiRaawpSPOeq4ta+vA6MFBV0yCs7NNVX4ISTR5wa93nY
         lhPX0q+48KidxKG2JDrE7SpRP6gdkq6ntcpp4MZHdg4YlYv+Fe7PXDiPg8QCR/A9CDfu
         XdV1kisB6klYbcJDy1ZAHDgHw6BDLcGxN/aFr+SPixooCSi8IN+KRrvF82rS7miknuA4
         xaIA==
X-Forwarded-Encrypted: i=1; AJvYcCUw2vLY2SzWTNHOfkWb+7/0gHpDkm4fFNSpdX0VFkBbFN7SYP6lXE2eWuM2BdypBxoO3sLJjVqSTYs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0auuer3hrTudeNWkKRBk22JpPTQNffZh0EJ70IRuZDDfdYOJI
	3eJ5p3bvmRNVS2FNuZ4LchC5zkCRuZTmShOA3dwny4uKaDB8PcYGaY7nPlj4Pm444GYlOH1vlLw
	buXlVwlVBoKoBIsX4UlWI7n2Lnwe0mYrPmQJbMpbdJQs9ijSzLf26hUY=
X-Google-Smtp-Source: AGHT+IFQCy/4x1+qIcUS78qlxaHEfbLJHaTgAyEWKHIOreX4S4vfwVxeiKiC7YC0stMLhACcVCG1HXNalqL/gA77UIQLT179hvEc
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:198b:b0:39e:68f8:43e5 with SMTP id
 e9e14a558f8ab-3a0848cb45cmr123293255ab.9.1726411162418; Sun, 15 Sep 2024
 07:39:22 -0700 (PDT)
Date: Sun, 15 Sep 2024 07:39:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000012905e0622296c1e@google.com>
Subject: [syzbot] Monthly xfs report (Sep 2024)
From: syzbot <syzbot+list09475edf415676cc6e2c@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 1 new issues were detected and 0 were fixed.
In total, 13 issues are still open and 23 have been fixed so far.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 602     Yes   possible deadlock in xfs_ilock_attr_map_shared
                  https://syzkaller.appspot.com/bug?extid=069cc167ecbee6e3e91a
<2> 137     Yes   possible deadlock in xfs_icwalk_ag (2)
                  https://syzkaller.appspot.com/bug?extid=4248e91deb3db78358a2
<3> 78      No    KASAN: slab-use-after-free Read in xfs_inode_item_push
                  https://syzkaller.appspot.com/bug?extid=1a28995e12fd13faa44e
<4> 74      Yes   INFO: task hung in xfs_buf_item_unpin (2)
                  https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
<5> 3       No    possible deadlock in xfs_fs_dirty_inode (2)
                  https://syzkaller.appspot.com/bug?extid=1116a7b7b96b9c426a1a

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

