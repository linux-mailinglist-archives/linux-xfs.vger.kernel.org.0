Return-Path: <linux-xfs+bounces-590-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E12D80B424
	for <lists+linux-xfs@lfdr.de>; Sat,  9 Dec 2023 13:17:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C910C28108B
	for <lists+linux-xfs@lfdr.de>; Sat,  9 Dec 2023 12:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70D414286;
	Sat,  9 Dec 2023 12:17:47 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146B410DF
	for <linux-xfs@vger.kernel.org>; Sat,  9 Dec 2023 04:17:44 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4SnRpq6XypzYd1b;
	Sat,  9 Dec 2023 20:17:39 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 2A2DA180071;
	Sat,  9 Dec 2023 20:17:42 +0800 (CST)
Received: from localhost.localdomain (10.175.127.227) by
 kwepemi500009.china.huawei.com (7.221.188.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 9 Dec 2023 20:17:41 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <chandanbabu@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<leo.lilong@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH v2 2/3] xfs: don't assert perag when free perag
Date: Sat, 9 Dec 2023 20:21:06 +0800
Message-ID: <20231209122107.2422441-2-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20231209122107.2422441-1-leo.lilong@huawei.com>
References: <20231209122107.2422441-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500009.china.huawei.com (7.221.188.199)

When releasing the perag in xfs_free_perag(), the assertion that the
perag in readix tree is correct in most cases. However, there is one
corner case where the assertion is not true. During log recovery, the
AGs become visible(that is included in mp->m_sb.sb_agcount) first, and
then the perag is initialized. If the initialization of the perag fails,
the assertion will be triggered. Worse yet, null pointer dereferencing
can occur.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/libxfs/xfs_ag.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index cc10a3ca052f..11ed048c350c 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -258,7 +258,8 @@ xfs_free_perag(
 		spin_lock(&mp->m_perag_lock);
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
 		spin_unlock(&mp->m_perag_lock);
-		ASSERT(pag);
+		if (!pag)
+			break;
 		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
 		xfs_defer_drain_free(&pag->pag_intents_drain);
 
-- 
2.31.1


