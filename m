Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F08523511F
	for <lists+linux-xfs@lfdr.de>; Sat,  1 Aug 2020 10:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgHAIO6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 1 Aug 2020 04:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgHAIO6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Aug 2020 04:14:58 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309B4C06174A
        for <linux-xfs@vger.kernel.org>; Sat,  1 Aug 2020 01:14:58 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id w2so17195951pgg.10
        for <linux-xfs@vger.kernel.org>; Sat, 01 Aug 2020 01:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BJDYuK1wUTL2xIWPuPBP+pMTbwNyCjjXu16LIGHXwjM=;
        b=Tg+PVn5hT4XIS9IYupn5vZdALxfgm9EU6HJz9/kPlEx+xNmAhFfcsd0JnhTzt+qaI1
         WH+lhYzk1Eroczw4cUzQXXd6JAN6W15p3TXL20bl0JrluodFItmsBMA4nG2K9ee+QSUu
         d6WHIwpcmQS9VzKUnVgiu4Y/03VY3+0ThdN5udf9V2AjfmY682AbjhKskTMiRmB/SSXI
         XksqeCNIqo/jOImit82wxERbrRnRfbsuYLdqJ4JaVO3GZbqvdTbNgmPREFYHuNm8VPRI
         COTF4WME/nU5HcjPghKw4pfvxRpQvHfrLpkpyF24cFUOZfovP9ytmyafFILFZHRr4zxa
         FN8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BJDYuK1wUTL2xIWPuPBP+pMTbwNyCjjXu16LIGHXwjM=;
        b=pKJ3y+BPjzdiek/+5YW4MUm4kuop4rEjrsPclFs+WI2WCQNNw3cKtL2ObG6g3C7Yie
         zLbreyS29okHsvCTXV6b4AzkCzqJMQ+GeStazRs6Ny8GN4FVx3+p0422qlWxHpSBjVUs
         85I0gRlcI0Blu0vMoGSCWwiqO+wOjVTP2sfZhAbFPAeML+b2M8VnNWU41jOv5hWkPVg0
         CPVjiQp4GpGbgKveCgyG5A7LgsEZ6E+Er7L2JV1IyQfH2C6X/WK7GcA2N4l6eQ0yOzBy
         tolr7bbjbBUITkORKBfKnRAVCu/WoM1w4fAXbNsCGmlEwRAA3PH3lshsKkHmSA3PgJ53
         VenA==
X-Gm-Message-State: AOAM532NVvywJ3mnOK52kL7VW/wENqKWny3/C3skNMQ7oKG39nqDssdi
        scIRuGipcZzQ6rAD9Mi8neW93/WI
X-Google-Smtp-Source: ABdhPJyQBeOv/54ML61osmLiv03zbzWsEihYbkhNFiatA4e8GS5UmhJhDenngTB7aBvTnMTkBHcpCg==
X-Received: by 2002:a62:31c7:: with SMTP id x190mr7385637pfx.100.1596269697366;
        Sat, 01 Aug 2020 01:14:57 -0700 (PDT)
Received: from localhost.localdomain ([122.182.254.175])
        by smtp.gmail.com with ESMTPSA id 202sm9481694pfy.6.2020.08.01.01.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 01:14:56 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH 0/2] Bail out if transaction can cause extent count to overflow
Date:   Sat,  1 Aug 2020 13:44:19 +0530
Message-Id: <20200801081421.10798-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS does not check for possible overflow of per-inode extent counter
fields when adding extents to either data or attr fork.

For e.g.
1. Insert 5 million xattrs (each having a value size of 255 bytes) and
   then delete 50% of them in an alternating manner.

2. On a 4k block sized XFS filesystem instance, the above causes 98511
   extents to be created in the attr fork of the inode.

   xfsaild/loop0  2035 [003]  9643.390490: probe:xfs_iflush_int: (ffffffffac6225c0) if_nextents=98511 inode=131

3. The incore inode fork extent counter is a signed 32-bit
   quantity. However the on-disk extent counter is an unsigned 16-bit
   quantity and hence cannot hold 98511 extents.

4. The following incorrect value is stored in the xattr extent counter,
   # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
   core.naextents = -32561

This patchset adds a new helper function
(i.e. xfs_trans_resv_ext_cnt()) to check for overflow of the per-inode
data and xattr extent counters and invokes it before starting an fs
operation (e.g. creating a new directory entry). With this patchset
applied, XFS detects counter overflows and returns with an error
rather than causing a silent corruption.

The patchset has been tested by executing xfstests with the following
mkfs.xfs options,
1. -m crc=0 -b size=1k
2. -m crc=0 -b size=4k
3. -m crc=0 -b size=512
4. -m rmapbt=1,reflink=1 -b size=1k
5. -m rmapbt=1,reflink=1 -b size=4k

The patches can also be obtained from
https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v0.

PS: I am planning to write the code which extends data/xattr extent
counters from 32-bit/16-bit to 64-bit/32-bit on top of these patches.

 fs/xfs/libxfs/xfs_attr.c       | 33 ++++++++++--
 fs/xfs/libxfs/xfs_bmap.c       |  7 +++
 fs/xfs/libxfs/xfs_trans_resv.c | 33 ++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.h |  1 +
 fs/xfs/xfs_bmap_item.c         | 12 +++++
 fs/xfs/xfs_bmap_util.c         | 40 ++++++++++++++
 fs/xfs/xfs_dquot.c             |  7 ++-
 fs/xfs/xfs_inode.c             | 96 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c             | 19 +++++++
 fs/xfs/xfs_reflink.c           | 35 +++++++++++++
 fs/xfs/xfs_rtalloc.c           |  4 ++
 fs/xfs/xfs_symlink.c           | 18 +++++++
 12 files changed, 301 insertions(+), 4 deletions(-)

-- 
2.27.0

