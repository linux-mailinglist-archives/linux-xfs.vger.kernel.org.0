Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DA0644105
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Dec 2022 11:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbiLFKL0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Dec 2022 05:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234529AbiLFKLD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2022 05:11:03 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A585C27CE7;
        Tue,  6 Dec 2022 02:05:42 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=ziyangzhang@linux.alibaba.com;NM=0;PH=DS;RN=6;SR=0;TI=SMTPD_---0VWfB1US_1670321134;
Received: from localhost.localdomain(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VWfB1US_1670321134)
          by smtp.aliyun-inc.com;
          Tue, 06 Dec 2022 18:05:40 +0800
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
To:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     djwong@kernel.org, hsiangkao@linux.alibaba.com,
        allison.henderson@oracle.com,
        Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Subject: [PATCH V3 0/2] cleanup and bugfix for xfs tests related to btree format
Date:   Tue,  6 Dec 2022 18:05:15 +0800
Message-Id: <20221206100517.1369625-1-ZiyangZhang@linux.alibaba.com>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The first patch add a helper in common/xfs to export the inode core size
which is needed by some xfs test cases.

The second patch ensure that S_IFDIR.FMT_BTREE is in btree format while
populating dir.

V3:
- refactor xfs tests cases using inode core size
V2:
- take Darrick's advice to cleanup code

Ziyang Zhang (2):
  common/xfs: Add a helper to export inode core size
  common/populate: Ensure that S_IFDIR.FMT_BTREE is in btree format

 common/populate | 28 +++++++++++++++++++++++++++-
 common/xfs      | 16 ++++++++++++++++
 tests/xfs/335   |  3 ++-
 tests/xfs/336   |  3 ++-
 tests/xfs/337   |  3 ++-
 tests/xfs/341   |  3 ++-
 tests/xfs/342   |  3 ++-
 7 files changed, 53 insertions(+), 6 deletions(-)

-- 
2.18.4

