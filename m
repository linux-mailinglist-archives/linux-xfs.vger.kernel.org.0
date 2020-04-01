Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F28E19A400
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Apr 2020 05:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731608AbgDADdS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 31 Mar 2020 23:33:18 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41647 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731589AbgDADdS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Mar 2020 23:33:18 -0400
Received: by mail-pl1-f193.google.com with SMTP id d24so5214148pll.8
        for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2020 20:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GLcPTVcaDafEteTaTQQAJmVyAgfwzABN/CTa+35bGcg=;
        b=f5VQLT/1C89XBCtUk0R6/SlPdj2I/Ti47D5rOimH8nvXZEfQ3jBcwwRcF7ipPxFxRz
         fvxekb+P9maaENhRlFtaPrR/5LEZ36jZd/iKjZlA1u4UzUbV1PGQpA5SzJDKNUZ9sQ64
         ru8G05A50M5ZdjwKR8+IS2SNMpch+FZ0+qtfSiK48AxmXvcGTzs0xf9O7hF5AMuwgutO
         zCMM/WBpNAxbaqDABWj2HmXqdAwOfWHANxZkuzpsLpDyvKAOzarjfwpEmNjKJswauKXT
         88P3gRDlUdk0N8SOwuslq2Jw4yC888qlv+fas/nxQcWC05gETMRNFXanfF7S1wtunv/6
         hDVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GLcPTVcaDafEteTaTQQAJmVyAgfwzABN/CTa+35bGcg=;
        b=UW5hxnhWgrxiS3Wz7MPLOxxUpV01t+792V6+bPDBX0PXcqubznKV0cq0dh2KJLCyiF
         SZXUwvTeLGLa3jIZW5DK0vgZwhew/gByf1iD1sBSCSqNGmjqQS8uw6ZARlJHwwy0COKP
         OLhlPXU0xOaIdvlh3ougMdB5WRm4cpe4H+o2I4KN2XPSu/GceHfB06vbms4L6MIByaVq
         7RbpZMoPGK98lVe7n5S58ydLMr6jV8qxrJ/YuONzeKRuQUIvyRZVt0hapw+fd4eHFDUi
         sGJlIUKbAheWrDmj17JSsgGB24zMUc4RYjof/VeOqcEYmq8Q0Gf7T87HyAr9SuIL+/8V
         IEqA==
X-Gm-Message-State: AGi0PubTIUp3lkkx6KwL5hlB5T54wpyWrpVLHSdOd72xCfjt8NkIbj9T
        mYG3E1jtRRIOL+Kxww95svGBgkUMww==
X-Google-Smtp-Source: APiQypKkDfN5eTNCYV8pJSNtdR3US9KA8L6kPXN+ctv4DMjnM2wzhljUxCxQN0BZTXeVVZmjCoh6gQ==
X-Received: by 2002:a17:90a:db4a:: with SMTP id u10mr2294521pjx.101.1585711996920;
        Tue, 31 Mar 2020 20:33:16 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id y7sm454352pfq.159.2020.03.31.20.33.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2020 20:33:16 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2] xfs: trace quota allocations for all quota types
Date:   Wed,  1 Apr 2020 11:33:11 +0800
Message-Id: <1585711991-26411-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The trace event xfs_dquot_dqalloc does not depend on the
value uq, so remove the condition, and trace quota allocations
for all quota types.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
v2:
 - don't move the tracepoint higher in the function.

 fs/xfs/xfs_qm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 0b09096..43df596 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1714,8 +1714,7 @@ struct xfs_qm_isolate {
 			pq = xfs_qm_dqhold(ip->i_pdquot);
 		}
 	}
-	if (uq)
-		trace_xfs_dquot_dqalloc(ip);
+	trace_xfs_dquot_dqalloc(ip);
 
 	xfs_iunlock(ip, lockflags);
 	if (O_udqpp)
-- 
1.8.3.1

