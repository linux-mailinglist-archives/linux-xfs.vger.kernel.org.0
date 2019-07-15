Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2088868A08
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Jul 2019 14:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730052AbfGOMzZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 15 Jul 2019 08:55:25 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33271 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728933AbfGOMzZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 08:55:25 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so17043900wru.0;
        Mon, 15 Jul 2019 05:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ChK2prE6w6EV267uhOJk2bZMDXQeRPtDQ5J6GH89F0g=;
        b=nzB63CxqK1LAHoXAjLcEqCL3HbwU/+DUJbldlYAhzi7ZCJb45k3UNvITdXiYi5cocV
         B2202o126uqTPmEtKqxRqIXT6U9BHNvy6JnP5M7S7O49VeiobK7XmiVcygMBET6jZrLQ
         4+qpy8FVNl21fy0BQxTJIcdRyKnz0qlXa0DxfCCysYGPkPAG76jGR3Xv+8ECoUxep5C9
         lAJVku0x2OAYTe1RZpcQ4ceLcKWPm3kux8uyBvol1TEr91Nr5bIhcOSRi/1i6CmE3F5J
         gonQTJJnyXl+vpCYhZinhp11zPdTNf3ufxMsvc4w2AT4MKIagk797X+aF7BkPEVFS1v2
         Fd7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ChK2prE6w6EV267uhOJk2bZMDXQeRPtDQ5J6GH89F0g=;
        b=XgTrovGMFvRMQi6wsO9KO2v616mJOIS41MfDojr3FUAyHcGtjUF7FfePgJt5oRsFAA
         QYe8nGuYx1lrGk/Wi+TNs2cqHCzN5B7Mw6LcUJAtVogzgR22i1dwfPwDJ/Lq+8t/nH4P
         JBfHSi0BRslCarLoDYSCrThIerNywgrk7orM6ZVEI2NkhHPAw29j7hJgPvQrma8VFJQJ
         jBOhU6njtNvMF+6iYMP3qu5IOt8mJ9XxBZGJ//RZ4PRz8yElrjHAbzvKJIFXq1uJ7pXp
         U4xbL4CoSvDueRyTKsUJhf3RzzB5Tr+VEND36uvwPvYRoEO8GtNFqiZlJLzP9Njd4fkN
         C+fg==
X-Gm-Message-State: APjAAAVDrg9SapAUN0vRYMH7+Aw3j7K5SHPS3df5ozLFIYAwUnwJ13PN
        RqJEfYC7XLr2yOAcm8hQOVc=
X-Google-Smtp-Source: APXvYqw9/sts3vZ3a3t2FHeeDh8Bd/UgAbIxB81aSEnrGnMc7/0DZzd499xb2HotjegEkkv8yFZXfQ==
X-Received: by 2002:adf:ea88:: with SMTP id s8mr24785275wrm.68.1563195322587;
        Mon, 15 Jul 2019 05:55:22 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id u6sm20747920wml.9.2019.07.15.05.55.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 05:55:22 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH v4 0/3] fstests: copy_file_range() tests
Date:   Mon, 15 Jul 2019 15:55:13 +0300
Message-Id: <20190715125516.7367-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Eryu,

These are the two remaining copy_file_range() tests which
I used to verify the kernel fixes that are now in master [1].

The bounds check test depends on an xfs_io change that was merged to
xfsprogs v5.1.0-rc1 (copy_range -f).

The cross-device copy test checks a new functionality, so it does
_notrun if copy_range return EXDEV instead of failing.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/20190709163947.GE5164@magnolia/

Changes from v3:
- swapfile and immutable file tests already merged (generic/55[34])
- Use an actual loopdev owned by this test
- Use /dev/null and /dev/zero and char devices for test
- _notrun if cross-device copy_range return EXDEV

Changes from v2:
- Change blockdev in test to loop and _require_loop (Olga)
- Implement and use _require_xfs_io_command copy_range -f

Changes from v1:
- Remove patch to test EINVAL behavior instead of short copy
- Remove 'chmod -r' permission drop test case
- Split out test for swap/immutable file copy
- Split of cross-device copy test

Amir Goldstein (3):
  common/rc: check support for xfs_io copy_range -f N
  generic: copy_file_range bounds test
  generic: cross-device copy_file_range test

 common/rc             |   9 ++-
 tests/generic/990     | 134 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/990.out |  37 ++++++++++++
 tests/generic/991     |  64 ++++++++++++++++++++
 tests/generic/991.out |   4 ++
 tests/generic/group   |   2 +
 6 files changed, 249 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/990
 create mode 100644 tests/generic/990.out
 create mode 100755 tests/generic/991
 create mode 100644 tests/generic/991.out

-- 
2.17.1

