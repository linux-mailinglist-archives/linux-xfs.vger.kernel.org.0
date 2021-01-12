Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492172F290E
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Jan 2021 08:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731889AbhALHl3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 Jan 2021 02:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730190AbhALHl2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 02:41:28 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF8BC061786;
        Mon, 11 Jan 2021 23:40:48 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id b8so974133plx.0;
        Mon, 11 Jan 2021 23:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FziieGX35lUGsDSIa+9jDQm1LpdgmV6iOVPeNYo1+wU=;
        b=cGraoOV7+cmytk/MYRVVQPvIL6NkuniXpxFQbSdDmoag3E/SoYKqimkYDeAlyBubHI
         qi7mpV64unFLfkNQeDSOeCDnsUh2fbw5A7V2QWAWGAYUqD1sWaJSUHbhl/n/yNiaQ6JK
         txlis2A8B4UDkzQAXkVDQuUsEF5dBNfffRq4e8h4W+otWZdBsRbOfZGHJ7EKaL9jnMpb
         YhpdcB4+1vuYyTKs+7NaOk2l29a40Mg05yrwQI87pJkOfLx1DRgOPHYyl81IqzhcEmit
         mT0JlE7sl6Monm3NexwSlyg4666DRhybEJHhDi2p+PnfWpZsCKjRDOW6MGPAa6qOaTje
         TLPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FziieGX35lUGsDSIa+9jDQm1LpdgmV6iOVPeNYo1+wU=;
        b=PosvuNTTNW70xnlS/VZJn3MODdSKotYkFsAMcWzYmvt0Dwqn6/gCBpdClDa56s7l2r
         wp/rW+fjDpj49oeBtvcumrc6jfi0QfrsdmjRP+oKlxRJaVh1oNdiBuKijcBZHK7kLwGP
         AjsxeSczj3ZO/QELKAyUg0jUzin3G83JvAuzjAmbNljLPBXxPh+odX2pxa5FxFJNcJGY
         u2hgKIzYjpgaWeFJb57xpt7QueOjlKHySQZ7k5WDHbH+u1AtGyzelX0ygcTbsBIi2U43
         08pi9eMOc0CtiZrh+hAIyAm2gvDA7uu8yiIZ+DzEuib85SWU6vhgty2rXVL1a5HCN7Yu
         sADQ==
X-Gm-Message-State: AOAM533R17GvHs3rI3wkFo5/WlMNFVyagNy/mSW5DZeBglmp++NRzZ8M
        E+D4zY80tGh6Xz7Gx/bhz6TVnrBm9+Q=
X-Google-Smtp-Source: ABdhPJwT6k63t2Y7HkHq/o78E8irrcQl2UX4oufewXX2k7sSEAR9DoeZrL7rrRy0kC/8isyWOxSXTQ==
X-Received: by 2002:a17:90b:4ad2:: with SMTP id mh18mr3190106pjb.137.1610437247987;
        Mon, 11 Jan 2021 23:40:47 -0800 (PST)
Received: from localhost.localdomain ([122.171.39.105])
        by smtp.gmail.com with ESMTPSA id mj5sm1962340pjb.20.2021.01.11.23.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 23:40:47 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        djwong@kernel.org
Subject: [PATCH V3 00/11] xfs: Tests to verify inode fork extent count overflow detection
Date:   Tue, 12 Jan 2021 13:10:16 +0530
Message-Id: <20210112074027.10311-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The patchset at
https://lore.kernel.org/linux-xfs/20210110160720.3922965-1-chandanrlinux@gmail.com/T/
added support for XFS to detect inode extent count overflow when
performing various filesystem operations. The patchset also added
new error injection tags for,
1. Reducing maximum extent count to 10.
2. Allocating only single block sized extents.

The corresponding code for xfsprogs can be obtained from
https://lore.kernel.org/linux-xfs/20201104114900.172147-1-chandanrlinux@gmail.com/.

The patches posted along with this cover letter add tests to verify
the correctness of in-kernel inode extent count overflow detection
mechanism.

These patches can also be obtained from
https://github.com/chandanr/xfstests.git at branch
extent-overflow-tests.

Changelog:
V2 -> V3:
  1. Kernel's max pseudo extent count is once again set to 10. Hence
     change the tests back to using 10 as the maximum extent count.
  2. The following tests associated with directories have been removed
     since directory remove and rename operations are not expected to
     fail (with -EFBIG error code) in low inode extent count
     scenarios:
     - Populate source directory and mv one entry to destination
       directory.
     - Populate a directory and remove one entry.

V1 -> V2:
  1. Obtain extent count for inodes accessible through filesystem path
     names via "xfs_io -c 'stat' ..." command line. This gets rid of
     unmount/mount cycles from most of the tests.
  2. Use _fill_fs() to consume free space of a filesystem.
  3. Use _scratch_inject_error() helper to enable/disable error tags.
  4. Use sizeof(struct xfs_dqblk) to calculate number of quotas inside
     one filesystem block.
  5. Write once to every block of the quota inode instead of
     sequentially filling up each block.
  6. Use _get_file_block_size() for tests involving regular files.
  7. Modify tests to suit the new pseudo max extent count of 35.
  8. Replace xfs_io with $XFS_IO_PROG.
  9. Remove code that extended a realtime file since this takes the
     same path as direct I/O to a regular file.
  10. For xattr, do not execute test script when block size is < 4k.
  11. Add code to test if removing an xattr from a full attribute fork
      succeeds.
  12. Add code to test if removing a file whose attribute fork is full
      succeeds.
  13. Add code to test if removing a entry from a full directory
      succeeds.
  14. Add code to test if removing a full directory succeeds.
  15. Writing to unwritten extents: Integrate buffered and direct I/O
      tests into a for loop.
  16. Writing to a shared extent test: Add test to check funshare
      operation.
  17. Use _scale_fsstress_args() to scale values for "-p" and "-n"
      arguments for fsstress.

Chandan Babu R (11):
  common/xfs: Add a helper to get an inode fork's extent count
  xfs: Check for extent overflow when trivally adding a new extent
  xfs: Check for extent overflow when growing realtime bitmap/summary
    inodes
  xfs: Check for extent overflow when punching a hole
  xfs: Check for extent overflow when adding/removing xattrs
  xfs: Check for extent overflow when adding/removing dir entries
  xfs: Check for extent overflow when writing to unwritten extent
  xfs: Check for extent overflow when moving extent from cow to data
    fork
  xfs: Check for extent overflow when remapping an extent
  xfs: Check for extent overflow when swapping extents
  xfs: Stress test with bmap_alloc_minlen_extent error tag enabled

 common/xfs        |  22 ++++++
 tests/xfs/522     | 173 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/522.out |  20 +++++
 tests/xfs/523     | 119 +++++++++++++++++++++++++++++
 tests/xfs/523.out |  11 +++
 tests/xfs/524     |  84 +++++++++++++++++++++
 tests/xfs/524.out |  19 +++++
 tests/xfs/525     | 141 +++++++++++++++++++++++++++++++++++
 tests/xfs/525.out |  18 +++++
 tests/xfs/526     | 186 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/526.out |  17 +++++
 tests/xfs/527     |  89 ++++++++++++++++++++++
 tests/xfs/527.out |  11 +++
 tests/xfs/528     | 110 +++++++++++++++++++++++++++
 tests/xfs/528.out |  12 +++
 tests/xfs/529     |  82 ++++++++++++++++++++
 tests/xfs/529.out |   8 ++
 tests/xfs/530     | 109 +++++++++++++++++++++++++++
 tests/xfs/530.out |  13 ++++
 tests/xfs/531     |  84 +++++++++++++++++++++
 tests/xfs/531.out |   7 ++
 tests/xfs/group   |  10 +++
 22 files changed, 1345 insertions(+)
 create mode 100755 tests/xfs/522
 create mode 100644 tests/xfs/522.out
 create mode 100755 tests/xfs/523
 create mode 100644 tests/xfs/523.out
 create mode 100755 tests/xfs/524
 create mode 100644 tests/xfs/524.out
 create mode 100755 tests/xfs/525
 create mode 100644 tests/xfs/525.out
 create mode 100755 tests/xfs/526
 create mode 100644 tests/xfs/526.out
 create mode 100755 tests/xfs/527
 create mode 100644 tests/xfs/527.out
 create mode 100755 tests/xfs/528
 create mode 100644 tests/xfs/528.out
 create mode 100755 tests/xfs/529
 create mode 100644 tests/xfs/529.out
 create mode 100755 tests/xfs/530
 create mode 100644 tests/xfs/530.out
 create mode 100755 tests/xfs/531
 create mode 100644 tests/xfs/531.out

-- 
2.29.2

