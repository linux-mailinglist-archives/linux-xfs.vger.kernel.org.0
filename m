Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA59742728
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Jun 2023 15:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjF2NUC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Jun 2023 09:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjF2NUB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jun 2023 09:20:01 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE7D213D
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jun 2023 06:19:59 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QsJtv09WDzTlNh;
        Thu, 29 Jun 2023 21:19:03 +0800 (CST)
Received: from localhost.localdomain (10.175.127.227) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 29 Jun 2023 21:19:56 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <djwong@kernel.org>, <david@fromorbit.com>
CC:     <linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <leo.lilong@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH 0/3] xfs: fix two problem when recovery intents fails
Date:   Thu, 29 Jun 2023 21:17:22 +0800
Message-ID: <20230629131725.945004-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch set fix two problem when recovery intents fails.

Patches 1-2 fix the possible problem that intent items not released.
When recovery intents, new intents items may be created during recovery
intents. if recovery fails, new intents items may be left in AIL or
leaks.

Patch 3 fix a uaf problem, when recovery intents fails, intent items
may be freed before done item commited.

Long Li (3):
  xfs: factor out xfs_defer_pending_abort
  xfs: abort intent items when recovery intents fail
  xfs: make sure done item committed before cancel intents

 fs/xfs/libxfs/xfs_defer.c | 26 +++++++++++++++++---------
 fs/xfs/libxfs/xfs_defer.h |  1 +
 fs/xfs/xfs_log_recover.c  | 15 ++++++++-------
 3 files changed, 26 insertions(+), 16 deletions(-)

-- 
2.31.1

