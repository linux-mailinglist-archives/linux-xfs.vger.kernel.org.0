Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB7D2A913
	for <lists+linux-xfs@lfdr.de>; Sun, 26 May 2019 10:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727603AbfEZIpo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 May 2019 04:45:44 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38570 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727546AbfEZIpo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 May 2019 04:45:44 -0400
Received: by mail-wr1-f67.google.com with SMTP id d18so13844971wrs.5;
        Sun, 26 May 2019 01:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RhrtCCF0w7jP9PNQdjt58kTvmy30xsamtXJCWig4MHc=;
        b=vM12hTVC3hfTUDjpuYBejzrfLduWJwHeYP4S6lXqbGBMgyUGjSkZ5gYfjBclMlovXS
         nCcfN9MuTu3TFds5E+1lXdjo0Zg5GMQtV2ysaZYgztZQkaRgfx4rOKk9feEkxZ9LrrG9
         weLZVUe10RvBuWnL9MPm6Dy6xnm85BEVsupwMM4jDxh+6Tup5upaj8MoDHAwZriMzzrz
         Q7icCNFTyyyPq27BXP1Fo5NSyokrMR0riMkfGZ8ijscc2bxRlnP8nL4xEAgEcdJNxJcT
         5n/L221AyQKN3bMVcr45wJSrKt2F7v84UXsNo7lRRlrk4Gy1VafFgqMDBIcMa2Hm6YvR
         wBGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RhrtCCF0w7jP9PNQdjt58kTvmy30xsamtXJCWig4MHc=;
        b=ByvDPb8Z+57wxK4tFDmop/ZGnRag8UF06IrriVJXKMcUwNqQA/l/wpswRDBQ+D+8dt
         56227fVUYMDD7K7LNiYSe3fCAZenCWod23wqhk1InwC37+XPLj5Jq+cP8ZErLvwFjb5v
         VGCbcHZrVUyyfWN8qNc543KfVysA3Q6hxPyVn4B7OgugNQPeHcACafeff9bF53Nm1SYL
         pYy+ZIUCxxGRqTVDeYpSJrwEbwEdV23Tmln6NBgBIWzq2SKJ1n6FE4SqyRJ2hbQeI4mC
         NBP9Vad50agdg01YqHI11JZxXISPCFRagNSBc0vgqo252niG3zA/KBn68Z276/7HAeY9
         iFzg==
X-Gm-Message-State: APjAAAXj1v04aKygtXxU+2l4mYmt45Veu1DD+QfVkFcg9KDtHDO7mVkN
        3fZ+ItBwRPkbqAy2V66kyyY=
X-Google-Smtp-Source: APXvYqwHXRExn9v7d1t7m+zkKiXa7qKypk1CCo5tzM+w8NjdhxK0hW0Ltjq99D/xsYa1Y3PjYpp2Qw==
X-Received: by 2002:adf:ee08:: with SMTP id y8mr5525929wrn.3.1558860342572;
        Sun, 26 May 2019 01:45:42 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id q11sm7089717wmc.15.2019.05.26.01.45.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 01:45:41 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH v2 0/5] fstests: copy_file_range() tests
Date:   Sun, 26 May 2019 11:45:30 +0300
Message-Id: <20190526084535.999-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Eryu,

This is a re-work of Dave Chinner's copy_file_range() tests which
I used to verify the kernel fixes of the syscall [1].

I split out the single bounds test by Dave to 4 tests.
immutable and swap file copy have specific requiremenet which many
filesystems do not meet (e.g. cifs,nfs,ceph,overlayfs), so those
test cases were split to individual test to allow better bounds test
converage for all filesystems.

The 3 first tests fix bugs in the interface, so they are appropriate
for merge IMO. The last test (cross-device copy) tests a new
functionality, so you may want to wait with merge till after the work
is merged upstream.

NOTE that the bounds check test depend on changes that have been merged
to xfsprogs v4.20. Without those changes the test will hang!
I used an artificial requirement _require_xfs_io_command "chmod" to
skip the test with old xfs_io. I welcome suggestions for better way to
handle this issue.

Thanks,
Amir.

Changes from v1:
- Remove patch to test EINVAL behavior instead of short copy
- Remove 'chmod -r' permission drop test case
- Split out test for swap/immutable file copy
- Split of cross-device copy test

[1] https://lore.kernel.org/linux-fsdevel/20190526061100.21761-1-amir73il@gmail.com/

Amir Goldstein (5):
  generic: create copy_range group
  generic: copy_file_range immutable file test
  generic: copy_file_range swapfile test
  generic: copy_file_range bounds test
  generic: cross-device copy_file_range test

 tests/generic/434     |   2 +
 tests/generic/988     |  59 ++++++++++++++++++++
 tests/generic/988.out |   5 ++
 tests/generic/989     |  56 +++++++++++++++++++
 tests/generic/989.out |   4 ++
 tests/generic/990     | 123 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/990.out |  37 +++++++++++++
 tests/generic/991     |  56 +++++++++++++++++++
 tests/generic/991.out |   4 ++
 tests/generic/group   |  14 +++--
 10 files changed, 355 insertions(+), 5 deletions(-)
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

