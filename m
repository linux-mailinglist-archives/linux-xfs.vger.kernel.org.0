Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 031BD32349
	for <lists+linux-xfs@lfdr.de>; Sun,  2 Jun 2019 14:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfFBMlY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 2 Jun 2019 08:41:24 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38934 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfFBMlX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Jun 2019 08:41:23 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so8614887wma.4;
        Sun, 02 Jun 2019 05:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6eOWmuxl6HjDRu+BizWY9l5qss719/MLNI94PMF3kjs=;
        b=PK552lPpgp2vYk3SNqNujIJ21cuqLiA6eMsXdKLAGrtWcPlnXhGhVK+MmQSOdNC4qG
         dDLTLAtbH26kbp4JQAW7nG6cYNej02WGQwxf9sRkJiSv0NNtPRies23MbKPAn/+8IfL4
         e3PQIZeIXtAuJCppq38lcN1JBgbUuOoQRXOnrADaF8heGnzA4gpzLSIEeJREGRZDuEk9
         zdXTPhfUMqrAppGbpG3fQeAtwt5mMNs0tQkSnyXfiQnIeqswutjJlykYQt3ffzqTg74y
         94eTZ4mBDwhwvCVwnqVnDKX91sTdcCyxAkJQMA4dGzFw8S+w95ePR6K95HkOHtfCLl7l
         al/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6eOWmuxl6HjDRu+BizWY9l5qss719/MLNI94PMF3kjs=;
        b=IQ+bd3gMNDZzIhlo+7LCleBcxzsPlVmjhn8E5eoNC6gN5oq9+YhxM92mvf0iPmbk3k
         MU+K79f3UubwpogxgoWUS5uz7NWCjI2iN1okzJ3qMMxNO3zoavVnDCE5BVFEFqNOwrmg
         kQ+l2NRygM3FJXCC/BkfIas7QM/g+3LYAkd1XuVhsroFkfjj5CQf5XLX7RoXI5e/HfaH
         EISaugdf7Pq7F6aX6ta9qZZtQiQYmVYWrBuuSMh6UPM6sRlNBNRPWw7F5WQj4rmkRnv/
         W4hHiz0QQgj6xQJKL25pzpH9IPfmZpBOHs5nA4wAeIQ4zXKBTujTsMNhWtqgxk6Pw1H0
         eYzQ==
X-Gm-Message-State: APjAAAUzAB/e1gRskwBNhOZ98aWYGuPpoFGhxOBczMjDhszFGmYznfZQ
        EPkkJ7QoyfhBDkQWPiKAZUI=
X-Google-Smtp-Source: APXvYqyne700Omb9jqSwUoLtwz/6NfphJw/uozGZh/+ujN49GWrdtlnap0C0xqiebSceprkTwLJ2DQ==
X-Received: by 2002:a1c:7408:: with SMTP id p8mr10895681wmc.161.1559479281366;
        Sun, 02 Jun 2019 05:41:21 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id g185sm11214827wmf.30.2019.06.02.05.41.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 05:41:20 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH v3 0/6] fstests: copy_file_range() tests
Date:   Sun,  2 Jun 2019 15:41:08 +0300
Message-Id: <20190602124114.26810-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Eryu,

This is a re-work of Dave Chinner's copy_file_range() tests which
I used to verify the kernel fixes of the syscall [1].

The 2 first tests fix bugs in the interface, so they are appropriate
for merge IMO.

The cross-device copy test checks a new functionality, so you may
want to wait with merging it till after the work is merged upstream.

The bounds check test depend on a change that was only posted to
xfsprogs [2]. Without two changes that were merge to xfsprogs v4.20,
the original test (v1, v2) would hang. Requiring the new copy_range
flag (copy_range -f) mitigates this problem.

You may want to wait until the xfs_io change is merged before merging
the check for the new flag.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-fsdevel/20190531164701.15112-1-amir73il@gmail.com/
[2] https://marc.info/?l=linux-xfs&m=155912482124038&w=2

Changes from v2:
- Change blockdev in test to loop and _require_loop (Olga)
- Implement and use _require_xfs_io_command copy_range -f

Changes from v1:
- Remove patch to test EINVAL behavior instead of short copy
- Remove 'chmod -r' permission drop test case
- Split out test for swap/immutable file copy
- Split of cross-device copy test


Amir Goldstein (6):
  generic: create copy_range group
  generic: copy_file_range immutable file test
  generic: copy_file_range swapfile test
  common/rc: check support for xfs_io copy_range -f N
  generic: copy_file_range bounds test
  generic: cross-device copy_file_range test

 common/rc             |   9 ++-
 tests/generic/434     |   2 +
 tests/generic/988     |  59 +++++++++++++++++++
 tests/generic/988.out |   5 ++
 tests/generic/989     |  56 ++++++++++++++++++
 tests/generic/989.out |   4 ++
 tests/generic/990     | 132 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/990.out |  37 ++++++++++++
 tests/generic/991     |  56 ++++++++++++++++++
 tests/generic/991.out |   4 ++
 tests/generic/group   |  14 +++--
 11 files changed, 372 insertions(+), 6 deletions(-)
 create mode 100755 tests/generic/988
 create mode 100644 tests/generic/988.out
 create mode 100755 tests/generic/989
 create mode 100644 tests/generic/989.out
 create mode 100755 tests/generic/990
 create mode 100644 tests/generic/990.out
 create mode 100755 tests/generic/991
 create mode 100644 tests/generic/991.out

-- 
2.17.1

