Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8BA3436BF
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Mar 2021 03:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhCVCqx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 21 Mar 2021 22:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhCVCqe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Mar 2021 22:46:34 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3D0C061574;
        Sun, 21 Mar 2021 19:46:34 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id j17so7956792qvo.13;
        Sun, 21 Mar 2021 19:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=spy64lz/qEfRpLlios/Ez5VtddaZYk0M6Y/CQzCcQgM=;
        b=RvKEMPQtqeNPsx1sRZAjjxq8wptO/YsAaqtEcapxQxqdOX141bNKdCap9jNkPU8uWA
         wC4qiBvhqcF1bb+aypc6c+waOBODldSH91eb3FByef48tatnhSBSdKVCFUQldfRUdR93
         73vXH6zWWygQP5yeBB69EDKQnIy7/rxD0HEe4R+iuKt0tvsxedi0FkY7zOQMSRPM8WN0
         2E434pDKSoUFkFE9zik/JuJckJMVHB1Ay0HIIShkdkRB49kS7+NjyMQ81H2z2Iw2aITY
         OGcjnkBgOQ6dW0JVJu0ls3iYqxiuWHdOrvMOd15R+eGSr7jDHKi4ndYWzOO/c/sLg4dV
         PKpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=spy64lz/qEfRpLlios/Ez5VtddaZYk0M6Y/CQzCcQgM=;
        b=f0rJI12L0hI3l9nQ8V6Zxec/aITYR+4EZfI6dWdrWtXWDYE5j2KqIX1WH64WdxKgQS
         0OFg+/NLYyWlaEqPcqxUFONGeypmfSlWnYsVXaPqXA1YinIaPSFMkFqrYCg2f8v5Rbtw
         zEdvL+s0tcyNLofx+WMsikfnItGeScBp8VZ2g/HlzBDqlOtYm3D3EVnmqhMEwBaPXtWt
         mGckNp90RwPJ1fA4M/zvaMbfpSGuldm4wA0SNbTnzQMCKv4mCZas8K6Uzjrj9m0Xf2EZ
         cM2PmS04DawsouSnm/1OZc6TxLniZQBFP6a4ZJtmyVvEDVcguISLasHbcfd0yRb0KcXG
         /pXw==
X-Gm-Message-State: AOAM530P27ahCViHfLQQ7wUeuyOOUCvG7nQLr1iLKtAQtTQgzG4kg+zS
        rc7bKrmu1Y0/eCtfEygThw0=
X-Google-Smtp-Source: ABdhPJztULizWvtH0x3aQWuzHYHzMRjyBlxGVD+AJG4N1BI8zg4PHZLzskhMP3U9uK1SfXUZeKqhOw==
X-Received: by 2002:a0c:b522:: with SMTP id d34mr249327qve.3.1616381193217;
        Sun, 21 Mar 2021 19:46:33 -0700 (PDT)
Received: from localhost.localdomain ([156.146.54.190])
        by smtp.gmail.com with ESMTPSA id m16sm9886234qkm.100.2021.03.21.19.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 19:46:32 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] xfs: Rudimentary spelling fix
Date:   Mon, 22 Mar 2021 08:16:19 +0530
Message-Id: <20210322024619.714927-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


s/sytemcall/systemcall/


Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 fs/xfs/xfs_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f93370bd7b1e..b5eef9f09c00 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2870,7 +2870,7 @@ xfs_finish_rename(
 /*
  * xfs_cross_rename()
  *
- * responsible for handling RENAME_EXCHANGE flag in renameat2() sytemcall
+ * responsible for handling RENAME_EXCHANGE flag in renameat2() systemcall
  */
 STATIC int
 xfs_cross_rename(
--
2.31.0

