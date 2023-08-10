Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75B37777C5
	for <lists+linux-xfs@lfdr.de>; Thu, 10 Aug 2023 14:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbjHJMEU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 10 Aug 2023 08:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjHJMET (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2023 08:04:19 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A7F1BD
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2023 05:04:18 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RM5996s9pzCrQX;
        Thu, 10 Aug 2023 20:00:45 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 10 Aug
 2023 20:04:14 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <djwong@kernel.org>
CC:     <linux-xfs@vger.kernel.org>
Subject: [PATCH -next] xfs: Remove duplicated include
Date:   Thu, 10 Aug 2023 20:03:48 +0800
Message-ID: <20230810120348.26732-1-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove duplicated includes of xfs_mount.h and xfs_trans_resv.h. Resolves
checkincludes message.

Signed-off-by: GUO Zihua <guozihua@huawei.com>
---
 fs/xfs/scrub/health.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index d2b2a1cb6533..d6109a20feef 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -10,8 +10,6 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
 #include "xfs_ag.h"
 #include "xfs_health.h"
 #include "scrub/scrub.h"
-- 
2.17.1

