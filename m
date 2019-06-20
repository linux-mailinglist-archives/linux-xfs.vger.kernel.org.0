Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 680E84CE50
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 15:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731805AbfFTNIl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 09:08:41 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:33111 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731801AbfFTNIl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 09:08:41 -0400
Received: by mail-lj1-f175.google.com with SMTP id h10so2679614ljg.0
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 06:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudlinux-com.20150623.gappssmtp.com; s=20150623;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=OuSD6ZwRdAaJaqphx5CJSVEbqzR8YCgzUKD8ur36WxY=;
        b=boIobfQe83Dy6Oqi/l3dHU5WhhtL46qbSq6sn9Zqcn3j3IhE+xGm3dT3Djq2V7HU/p
         YS2B+p+sE+ECSGhiVXUsK+Pu0Y/mG3jvI++77T64t1YCLoFv3gk/RGSNxMVSxx+FYXbW
         meeRxtE9ATpnwvmp3iX2SZxqdim5OgsbtHsxTSb7XUbfS7YzGhBpM4vCl5qVmYieLhkE
         6c6xUWMpgCjfz/6dHQJuMTygAgtDvYPRL0AgsqdxDaY9l3c0WllcsiMmUXX1JD/xWVG5
         zhi0ktcwRU2y7XA/sH+zFDaKSNUaSKznLzz/8Ng3uBng9k6QAMNaycOGCbOzLCXUB6Zp
         zmDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=OuSD6ZwRdAaJaqphx5CJSVEbqzR8YCgzUKD8ur36WxY=;
        b=K6QE0y6cUrS61ddoQnAEzxpg43U8JtNwwSkZ72f74u6TYoVk/7cPIxkAzqI5ed+y9S
         qio555Be3lhrhfkqtWviysGWivevxY+AddiYfufgRxtX6+loO180f5YgFNiO3hMJPFq7
         Y5c4AC2Nr6ELvm5YVxkLb0Y6XCVVdoHQKA9w8OJle8WptI4nEU7xwtNDujQ/RcaF8NKf
         g8GYjTXrRtD1jAWVHTtu+F1wNnKog1OKNONT49N+JhmBdK+3qzb00r7/5F/ey/v1un5B
         lqad5Qwlddzccge1VWCRmZ+A3tjJS5X29xK8/DAQXmMdy8W/CkyM9FEQaZka7uwjgrwA
         ct4Q==
X-Gm-Message-State: APjAAAVspKHPqYyAmjHWktJff9NQBDGzlquWJ5S+nEEqCQTYMhY7iolS
        plT/eVLMsk1BzuOYjDjcuA7v4g==
X-Google-Smtp-Source: APXvYqyIAtND8gOVowhsZqJG+syskkA1J8Jq/Z4jHCPqNm+wGVvX7edK8UhtwGue16/LYAk/WgPCJA==
X-Received: by 2002:a2e:9b57:: with SMTP id o23mr21402097ljj.67.1561036119002;
        Thu, 20 Jun 2019 06:08:39 -0700 (PDT)
Received: from [192.168.55.52] ([185.236.216.11])
        by smtp.gmail.com with ESMTPSA id n24sm3553712ljc.25.2019.06.20.06.08.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 06:08:38 -0700 (PDT)
From:   Alexey Lyashkov <umka@cloudlinux.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Memory reclaim and XFS objects
Message-Id: <EF1A27FA-4DEA-41A7-8C47-FA8A947E4C19@cloudlinux.com>
Date:   Thu, 20 Jun 2019 16:06:36 +0300
Cc:     linux-xfs@vger.kernel.org
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
X-Mailer: Apple Mail (2.3273)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

own customers hit a system hung after several OOM conditionals.
Looking into crash dump, i found a large number threads (334) stick in =
xfs_reclaim_inodes_ag in waiting a mutex.
example of it.
PID: 2      TASK: ffff88de5b7c1160  CPU: 6   COMMAND: "kthreadd"
 #0 [ffff88de5b7cf488] __schedule at ffffffff81b2d932
 #1 [ffff88de5b7cf518] schedule_preempt_disabled at ffffffff81b2ed79
 #2 [ffff88de5b7cf528] __mutex_lock_slowpath at ffffffff81b2cc77
 #3 [ffff88de5b7cf580] mutex_lock at ffffffff81b2c05f
 #4 [ffff88de5b7cf598] xfs_reclaim_inodes_ag at ffffffffc0366f1c [xfs]
 #5 [ffff88de5b7cf730] xfs_reclaim_inodes_nr at ffffffffc03680c3 [xfs]
 #6 [ffff88de5b7cf750] xfs_fs_free_cached_objects at ffffffffc037a169 =
[xfs]
 #7 [ffff88de5b7cf760] super_cache_scan at ffffffff81640e4e
 #8 [ffff88de5b7cf7a0] shrink_slab at ffffffff815bd3f3
 #9 [ffff88de5b7cf868] shrink_zone at ffffffff815c0cb0
#10 [ffff88de5b7cf8e0] do_try_to_free_pages at ffffffff815c1230
#11 [ffff88de5b7cf988] try_to_free_pages at ffffffff815c1775
#12 [ffff88de5b7cfa18] __alloc_pages_slowpath at ffffffff81b250fd
#13 [ffff88de5b7cfb08] __alloc_pages_nodemask at ffffffff815b4d35
#14 [ffff88de5b7cfbc0] new_slab at ffffffff81611c46
#15 [ffff88de5b7cfc00] ___slab_alloc at ffffffff8161210c
#16 [ffff88de5b7cfcd0] __slab_alloc at ffffffff81b26903
#17 [ffff88de5b7cfd10] kmem_cache_alloc_node at ffffffff81612ac9
#18 [ffff88de5b7cfd60] copy_process at ffffffff81491be9
#19 [ffff88de5b7cfde8] do_fork at ffffffff81493751
#20 [ffff88de5b7cfe60] kernel_thread at ffffffff81493a06
#21 [ffff88de5b7cfe70] create_kthread at ffffffff814bf664
#22 [ffff88de5b7cfe88] kthreadd at ffffffff814c0315=20
# grep -c xfs_reclaim_inodes_nr bt.log
334

Looking in code, it looks result of race between different threads who =
want to do reclaim in same time,=20
but each thread don=E2=80=99t able to flush own nr objects limit.
I think xfs_reclaim_inodes_nr don=E2=80=99t need to have SYNC_WAIT as =
shrink_slab have own loop to flush additional objects in case first loop =
ins=E2=80=99t flush all.
What you think about this change?



Thanks for response,
Alex=
