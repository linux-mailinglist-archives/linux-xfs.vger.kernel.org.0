Return-Path: <linux-xfs+bounces-5397-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FB24885B6F
	for <lists+linux-xfs@lfdr.de>; Thu, 21 Mar 2024 16:10:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4E2A286CE8
	for <lists+linux-xfs@lfdr.de>; Thu, 21 Mar 2024 15:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03F2E8615A;
	Thu, 21 Mar 2024 15:10:32 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A41955792
	for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 15:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711033831; cv=none; b=afx7/MpSl2wySH/c0Mm9BZ8LS5SqTX7bM0V/Xc48CTXTKUlpzugrzucrp4KcfH4Je0JsGFuTyCUo6bI5q1ewk7VtxR0pGnvXvfo2UjlMThMfOf7cM+AvF5wrfiwV4ESgHr6akfDyIrryw3X5Mn+Qh7R4QgPaFnhuPsyu/1Ilpwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711033831; c=relaxed/simple;
	bh=lkwGELEVRrIIvXlvXJsBZZkp2IgOovTNvk11SNLj5tk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=DNMI7C6VZYqJVqtnknznRMomRtnyPj5PjF5WbNum7sQr31JUT6/dFHjSDUAZvrDU9dUkkyFPT/MH+cYlppnqG5A8ioUYARBjBpJ9PAkcfkn3cJiaUXzDi6axihHhjwgbKIEVN9muA7FDaAA6+q0rWP9qFmzdrmykZAa440EgBw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7c8742bedd4so144415239f.1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 08:10:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711033829; x=1711638629;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mt2HNZyZoapYjaOUsclhOl7e3kA64Zv5KEZzZn4Zy4o=;
        b=t3FKj2cqTxVD9JnoDSC3bzDgyIZBklq5CBR3j5nQL/mrYNm4APqHdGNtjKyJOYsc/4
         Lk/OZr4CkOQBxoMhk00bnAMhKvAIg9fIboMUpaM03tg/Bt+/hNziv/52q4Cf06SdCNdk
         R+eI00rs0B1HMMsu0vFO+IcKASJNgsjcGrSHxjlIx2ZJ6DTp0JKkxyiaQXwxzozS+Mwf
         RkW2y5NL6XSP7sDgTXWL/Trq5w5GhJ3GoVXvsd01UreWD1od3rXrnr+3tVPI7rA0b662
         02+uGF/mQAZFzen7skGnmumTtATxm9s64ltHRJ4RsPCIfKikfO3oAslvwTf7QCSEUo0+
         Yjpg==
X-Forwarded-Encrypted: i=1; AJvYcCUPt1she9sUoEpTgAtlHBo97vEdhbAiWxdCEBg8qtnGRsn1PJbtg3jfS7N24/MJMplwjuwriFCYQjpJ1e/o6CGejI7NXi3ZE0pU
X-Gm-Message-State: AOJu0YxizlSn1Hk1fgujj1hJznl2jKn8TSxtV3tIh7NGeAESxKuDl7Pc
	KDsM1ectLzAIjm4/0TGPWZ5ljWqt6Mj35xjTlkWbkkE5bE6Dxf6bevHn224ulLygxKqJL77S0Nu
	edbhXBkjTaM3n90IagkkZ7ItT518vvDXbXguuxB7vUC9B2/rLBTtVjVk=
X-Google-Smtp-Source: AGHT+IEKMhB9ZG2lXARfsTj9O9X+nYpyS5T7vlLFwtRWGNc7OzuulrlNwf0KpGrcMFM+ugXTAm+ECMn7rUGaHfpRvo4Nai1LtKz5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:13c3:b0:477:307d:abd9 with SMTP id
 i3-20020a05663813c300b00477307dabd9mr163534jaj.0.1711033829646; Thu, 21 Mar
 2024 08:10:29 -0700 (PDT)
Date: Thu, 21 Mar 2024 08:10:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009d6f3a06142d1b9c@google.com>
Subject: [syzbot] Monthly xfs report (Mar 2024)
From: syzbot <syzbot+lista1e41fd3fe8612aa32c2@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello xfs maintainers/developers,

This is a 31-day syzbot report for the xfs subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/xfs

During the period, 2 new issues were detected and 0 were fixed.
In total, 7 issues are still open and 20 have been fixed so far.

Some of the still happening issues:

Ref Crashes Repro Title
<1> 604     Yes   KASAN: stack-out-of-bounds Read in xfs_buf_lock
                  https://syzkaller.appspot.com/bug?extid=0bc698a422b5e4ac988c
<2> 14      No    possible deadlock in xfs_ilock
                  https://syzkaller.appspot.com/bug?extid=d247769793ec169e4bf9
<3> 8       No    possible deadlock in xfs_qm_dqget_cache_insert
                  https://syzkaller.appspot.com/bug?extid=8fdff861a781522bda4d

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

