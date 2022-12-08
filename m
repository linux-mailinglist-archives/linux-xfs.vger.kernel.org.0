Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4383F6469B7
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Dec 2022 08:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiLHH3P (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 8 Dec 2022 02:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiLHH3N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Dec 2022 02:29:13 -0500
Received: from out30-1.freemail.mail.aliyun.com (out30-1.freemail.mail.aliyun.com [115.124.30.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A2046666;
        Wed,  7 Dec 2022 23:29:08 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=ziyangzhang@linux.alibaba.com;NM=0;PH=DS;RN=8;SR=0;TI=SMTPD_---0VWpNSYT_1670484541;
Received: from localhost.localdomain(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VWpNSYT_1670484541)
          by smtp.aliyun-inc.com;
          Thu, 08 Dec 2022 15:29:06 +0800
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
To:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     zlang@redhat.com, david@fromorbit.com, djwong@kernel.org,
        hsiangkao@linux.alibaba.com, allison.henderson@oracle.com,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Subject: [PATCH V5 0/2] cleanup and bugfix for xfs tests related to btree format
Date:   Thu,  8 Dec 2022 15:28:41 +0800
Message-Id: <20221208072843.1866615-1-ZiyangZhang@linux.alibaba.com>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The first patch add a helper in common/xfs to export the inode core size
which is needed by some xfs test cases.

The second patch ensure that S_IFDIR.FMT_BTREE is in btree format while
populating dir.

V5:
- rename _xfs_inode_core_bytes() to _xfs_get_inode_core_bytes()
- rename _xfs_inode_size() to _xfs_get_inode_size()
- use one pipe in _xfs_get_inode_size()
- use local variables in __populate_xfs_create_btree_dir()

V4:
- let the new helper function accept the "missing" parameter
- make _xfs_inode_core_bytes echo 176 or 96 so tests can work correctly on
  both v4 and v5

V3:
- refactor xfs tests cases using inode core size

V2:
- take Darrick's advice to cleanup code

Ziyang Zhang (2):
  common/xfs: Add a helper to export inode core size
  common/populate: Ensure that S_IFDIR.FMT_BTREE is in btree format

 common/populate | 34 +++++++++++++++++++++++++++++++++-
 common/xfs      | 24 ++++++++++++++++++++++++
 tests/xfs/335   |  3 ++-
 tests/xfs/336   |  3 ++-
 tests/xfs/337   |  3 ++-
 tests/xfs/341   |  3 ++-
 tests/xfs/342   |  3 ++-
 7 files changed, 67 insertions(+), 6 deletions(-)

-- 
2.18.4

