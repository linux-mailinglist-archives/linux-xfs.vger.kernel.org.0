Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5CA57696C1
	for <lists+linux-xfs@lfdr.de>; Mon, 31 Jul 2023 14:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjGaMuR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 31 Jul 2023 08:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjGaMuO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jul 2023 08:50:14 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10E0B8
        for <linux-xfs@vger.kernel.org>; Mon, 31 Jul 2023 05:50:13 -0700 (PDT)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RDyhs0418zVjlV;
        Mon, 31 Jul 2023 20:48:28 +0800 (CST)
Received: from localhost.localdomain (10.175.127.227) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 20:50:09 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     <djwong@kernel.org>, <david@fromorbit.com>
CC:     <linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <leo.lilong@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH v3 0/3] xfs: fix two problem when recovery intents fails
Date:   Mon, 31 Jul 2023 20:46:16 +0800
Message-ID: <20230731124619.3925403-1-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

v3:
 - Modified as suggested by Dave, solves the UAF problem by correctly
 handling the reference counting of intents in patch 3

v2:
 - change xfs_defer_pending_abort to static in patch 1
 - rewrite commit message in patch 2-3
 - rename xfs_defer_ops_capture_free to xfs_defer_ops_capture_abort, and
 add xfs_defer_pending_abort to the start of xfs_defer_ops_capture_abort


Long Li (3):
  xfs: factor out xfs_defer_pending_abort
  xfs: abort intent items when recovery intents fail
  xfs: fix intent item uaf when recover intents fail

 fs/xfs/libxfs/xfs_defer.c  | 28 ++++++++++++++++++----------
 fs/xfs/libxfs/xfs_defer.h  |  2 +-
 fs/xfs/xfs_attr_item.c     |  1 +
 fs/xfs/xfs_bmap_item.c     |  1 +
 fs/xfs/xfs_extfree_item.c  |  1 +
 fs/xfs/xfs_log_recover.c   |  2 +-
 fs/xfs/xfs_refcount_item.c |  1 +
 fs/xfs/xfs_rmap_item.c     |  1 +
 8 files changed, 25 insertions(+), 12 deletions(-)

-- 
2.31.1

