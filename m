Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F152275208
	for <lists+linux-xfs@lfdr.de>; Wed, 23 Sep 2020 08:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgIWG7b (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 23 Sep 2020 02:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgIWG7b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 02:59:31 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E789C061755
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 23:59:31 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id l126so14464019pfd.5
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 23:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z9Z6ZLCA0t50O/FUHRry5+oFSnlJ3mf6I4oqL/odMzs=;
        b=W33noDxb6HybnUoiuk9h+OFmpKAkYnYKAFb5+XY/eD4WvH2GNja5Ib0GLsnwhgqq1M
         pjmr6FN9Wpv1/VZhi4OLuf++7fzjfnjErcDw3YPuxBx3GJmgjusywWefk8zIDqSydqiZ
         1QY9V3K0j+/uRW+XwIfHid7SzS6XreWLCcmqYfdwkPAfhByQHHRxK90PnCX6ffYq23GH
         TVceynkr9sCcnfaKGjP3l66HZWtSGoPhLhVutCH3cxMZzcE2tf89QprLs/FfPm1YLfs1
         ynABT7zl4qaaxBJArUHcEdBdfn/kYuJ4DsAyyAms6E450hM2w2uZJzhZqu4m/Z7vm2LZ
         Te/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z9Z6ZLCA0t50O/FUHRry5+oFSnlJ3mf6I4oqL/odMzs=;
        b=YXSbo0abwvBOmpJo+ZXccaELEsSeCY21s/5bmfxqV4+HVB7NnS62Kp1EbZ75z5M6/U
         gZaCwlsJeZ8+OVkUT3W9OPCY2lduWJJkz5mb849/TE01PIYdKWIoQCP17Ebi7mB1zXHr
         bbY/+51nBMYqgQnj/mFjnVcnqFXnMbq7bUrPf521cyBjiKCTgjwGvdLTZJb8oidHjW5v
         hBnISqmH2wypauoHN6Wcc4/f5xWZEqvM7/LcvXYf0XAEB1MiuC6s8ATXk5CENZlKgHdV
         Yp7xuHRsSGbROtHV3CcKuemihISLFdqz/pcq9BL2DX0TWVGfwjNDB9ptnaGeAP9EkBlD
         KV4A==
X-Gm-Message-State: AOAM533TtKz0KSYQ3/PT5eP5yorYQ4Zq/IuvS8J9SKSjFWqZJnV8JMbC
        UNqo4ITZM+g/sRjzeXm3OsE7ltIT80Bd
X-Google-Smtp-Source: ABdhPJyXddE75jXQeD9kBOFrB/Dr3XXeNryy8cncxEUEZIpBZLHxyh7piYD5ZdJLvwiQoD5cn7OCjg==
X-Received: by 2002:a63:4a0e:: with SMTP id x14mr2132659pga.222.1600844369343;
        Tue, 22 Sep 2020 23:59:29 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id c68sm10685745pfc.31.2020.09.22.23.59.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Sep 2020 23:59:28 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v3 3/7] xfs: remove the unnecessary xfs_dqid_t type cast
Date:   Wed, 23 Sep 2020 14:59:14 +0800
Message-Id: <1600844358-16601-4-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
References: <1600844358-16601-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Since the type prid_t and xfs_dqid_t both are uint32_t, seems the
type cast is unnecessary, so remove it.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 3f82e0c92c2d..41a459ffd1f2 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1715,7 +1715,7 @@ xfs_qm_vop_dqalloc(
 	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
 		if (ip->i_d.di_projid != prid) {
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid,
+			error = xfs_qm_dqget(mp, prid,
 					XFS_DQTYPE_PROJ, true, &pq);
 			if (error) {
 				ASSERT(error != -ENOENT);
-- 
2.20.0

