Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73CE725A72
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Jun 2023 11:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235807AbjFGJbG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Jun 2023 05:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240140AbjFGJaz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jun 2023 05:30:55 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B223919BC
        for <linux-xfs@vger.kernel.org>; Wed,  7 Jun 2023 02:30:48 -0700 (PDT)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QbhsG0nt8zTkrY;
        Wed,  7 Jun 2023 17:30:26 +0800 (CST)
Received: from Y00251687ALE274.china.huawei.com (10.174.178.198) by
 canpemm500005.china.huawei.com (7.192.104.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 17:30:46 +0800
From:   Weifeng Su <suweifeng1@huawei.com>
To:     <linux-xfs@vger.kernel.org>, <djwong@kernel.org>, <hch@lst.de>,
        <sandeen@sandeen.net>
CC:     <linfeilong@huawei.com>, <liuzhiqiang26@huawei.com>,
        Weifeng Su <suweifeng1@huawei.com>
Subject: [PATCH] libxcmd: add return value check for dynamic memory function
Date:   Wed, 7 Jun 2023 17:30:18 +0800
Message-ID: <20230607093018.61752-1-suweifeng1@huawei.com>
X-Mailer: git-send-email 2.18.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.178.198]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The result check was missed and It cause the coredump like:
0x00005589f3e358dd in add_command (ci=0x5589f3e3f020 <health_cmd>) at command.c:37
0x00005589f3e337d8 in init_commands () at init.c:37
init (argc=<optimized out>, argv=0x7ffecfb0cd28) at init.c:102
0x00005589f3e33399 in main (argc=<optimized out>, argv=<optimized out>) at init.c:112

Add check for realloc function to ignore this coredump and exit with
error output

Signed-off-by: Weifeng Su <suweifeng1@huawei.com>
---
 libxcmd/command.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/libxcmd/command.c b/libxcmd/command.c
index a76d1515..47d050c3 100644
--- a/libxcmd/command.c
+++ b/libxcmd/command.c
@@ -34,6 +34,10 @@ add_command(
 	const cmdinfo_t	*ci)
 {
 	cmdtab = realloc((void *)cmdtab, ++ncmds * sizeof(*cmdtab));
+	if (!cmdtab) {
+		perror("realloc");
+		exit(1);
+	}
 	cmdtab[ncmds - 1] = *ci;
 	qsort(cmdtab, ncmds, sizeof(*cmdtab), compare);
 }
-- 
2.18.0.windows.1

