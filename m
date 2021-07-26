Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13733D5357
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Jul 2021 08:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhGZGC7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 26 Jul 2021 02:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhGZGC7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 02:02:59 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D81DC061757;
        Sun, 25 Jul 2021 23:43:28 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j1so11560826pjv.3;
        Sun, 25 Jul 2021 23:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1tNhx2SaG2Be9BHEDHoAZ4YhEYgYqL/nZm6wug6AjRs=;
        b=eDqsI9uf0uSiwD792+GzFge2gmCfuK/ORNp9M3O2YgieakzVHjga3Sm5upIaTqm2ny
         OTrHNHqIY5/5mMGcGfGjwc+5pQW5ND1X2AIkY+ayl/X5VrByMu+3KHFkrU47m45jokGG
         Pm7kF3dG8Nfoae45k8ONjmHtXaq9NDv9LJoq9nBmuhEyEJHKCevMMn4d6xBDHIEDo6MS
         uZtj57NyEafqdfsJiyyIehd/BVKSdYaq6217uHu62GZsb8Sar6ll0q02qIOe86XI8QoG
         9h2r8L3zkTBFcN/xyS0GIkAiOExKzh2rB/qAFOzvXuOcnuhKuHkAzVSycPARpMSchDK0
         pmmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1tNhx2SaG2Be9BHEDHoAZ4YhEYgYqL/nZm6wug6AjRs=;
        b=rr7taBkc2u4esth2cC1Y8WY/i3UcJMw1kld7ZTyuRTE2pk8dwXGg04AdCxJE6j2N7D
         lQdQRzX6KNv1RL79cIpQeLGd+anfYmiat0sYbv9Ii8LQHdqE0oXlaBg1CeHUts9mu+WO
         XuOryWbzDAuIoEQCSMEHTPPjPkS4c/e1GvI2vIYA43HIYUotqdCGw+xCyPiC/U8iHw2P
         ZW1qVSYYeLsHrem0c9DTcYD17ccur8g51nNx9sSYQqRJIXTypZldT85YuWdF9v3JWQlO
         4TMXgwcIo1POwgPVe7P0X9ET16Q3EhyOdwCCHDg6Zu19zLrLRQn4ARCwVsbZyQIZEccF
         C6QA==
X-Gm-Message-State: AOAM5311Go+GkSLMPilIM6z8QfjW1W87QyBbSS7u0mOZhedpR7six2SK
        ugETQUt8wda3c3spGtm6obpKO1c/lyY=
X-Google-Smtp-Source: ABdhPJzkfDM1cduQxZEIC267ICNnrpBvC6Ra9C4Gqewy5xHieLPyiIEPCkbZCl1+kR6kPIJG+XYKKg==
X-Received: by 2002:a65:6110:: with SMTP id z16mr13237883pgu.152.1627281807762;
        Sun, 25 Jul 2021 23:43:27 -0700 (PDT)
Received: from localhost.localdomain ([122.167.58.51])
        by smtp.gmail.com with ESMTPSA id c11sm44411172pfp.0.2021.07.25.23.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 23:43:27 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs/530: Do not pass block size argument to _scratch_mkfs
Date:   Mon, 26 Jul 2021 12:13:11 +0530
Message-Id: <20210726064313.19153-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

_scratch_do_mkfs constructs a mkfs command line by concatenating the values of
1. $mkfs_cmd
2. $MKFS_OPTIONS
3. $extra_mkfs_options

The block size argument passed by xfs/530 to _scratch_mkfs() will cause
mkfs.xfs to fail if $MKFS_OPTIONS also has a block size specified. In such a
case, _scratch_do_mkfs() will construct and invoke an mkfs command line
without including the value of $MKFS_OPTIONS.

To prevent such silent failures, this commit removes the block size option
that was being explicitly passed to _scratch_mkfs().

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/530 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/530 b/tests/xfs/530
index 4d168ac5..16dc426c 100755
--- a/tests/xfs/530
+++ b/tests/xfs/530
@@ -60,7 +60,7 @@ echo "Format and mount rt volume"
 
 export USE_EXTERNAL=yes
 export SCRATCH_RTDEV=$rtdev
-_scratch_mkfs -d size=$((1024 * 1024 * 1024)) -b size=${dbsize} \
+_scratch_mkfs -d size=$((1024 * 1024 * 1024)) \
 	      -r size=${rtextsz},extsize=${rtextsz} >> $seqres.full
 _try_scratch_mount || _notrun "Couldn't mount fs with synthetic rt volume"
 
-- 
2.30.2

