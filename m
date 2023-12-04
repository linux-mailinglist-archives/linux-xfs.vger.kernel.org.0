Return-Path: <linux-xfs+bounces-384-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA325802C0D
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 08:30:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F9B51F20FB9
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 07:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C30A9449;
	Mon,  4 Dec 2023 07:30:07 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
X-Greylist: delayed 182 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 03 Dec 2023 23:30:00 PST
Received: from mx10.didiglobal.com (mx10.didiglobal.com [111.202.70.125])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id 3CB87F2;
	Sun,  3 Dec 2023 23:30:00 -0800 (PST)
Received: from mail.didiglobal.com (unknown [10.79.71.32])
	by mx10.didiglobal.com (MailData Gateway V2.8.8) with ESMTPS id 37F07184D80420;
	Mon,  4 Dec 2023 15:26:56 +0800 (CST)
Received: from localhost.localdomain (10.79.64.101) by
 ZJY03-ACTMBX-03.didichuxing.com (10.79.71.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 4 Dec 2023 15:26:55 +0800
X-MD-Sfrom: daikunhai@didiglobal.com
X-MD-SrcIP: 10.79.71.32
From: Kunhai Dai <daikunhai@didiglobal.com>
To: <chandan.babu@oracle.com>, <djwong@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Kunhai Dai
	<daikunhai@didiglobal.com>
Subject: [PATCH] xfs: adjust the offset of the log statistics line
Date: Mon, 4 Dec 2023 02:26:44 -0500
Message-ID: <20231204072644.1012309-1-daikunhai@didiglobal.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZJY03-PUBMBX-01.didichuxing.com (10.79.71.12) To
 ZJY03-ACTMBX-03.didichuxing.com (10.79.71.32)

It would be more preferable to present xs_try_logspace and
xs_sleep_logspace on the log line.

Signed-off-by: Kunhai Dai <daikunhai@didiglobal.com>
---
 fs/xfs/xfs_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 90a77cd3ebad..92ff3a22cbc9 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -36,7 +36,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		{ "dir",		xfsstats_offset(xs_trans_sync)	},
 		{ "trans",		xfsstats_offset(xs_ig_attempts)	},
 		{ "ig",			xfsstats_offset(xs_log_writes)	},
-		{ "log",		xfsstats_offset(xs_try_logspace)},
+		{ "log",		xfsstats_offset(xs_push_ail)},
 		{ "push_ail",		xfsstats_offset(xs_xstrat_quick)},
 		{ "xstrat",		xfsstats_offset(xs_write_calls)	},
 		{ "rw",			xfsstats_offset(xs_attr_get)	},
-- 
2.27.0


