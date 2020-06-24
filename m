Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6262076DB
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jun 2020 17:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391192AbgFXPJZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jun 2020 11:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390970AbgFXPJY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 11:09:24 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35033C061573
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2020 08:09:24 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id j10so1912378qtq.11
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2020 08:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=351giKD/sxHJWnb6T0gRmZz+Iu3NOtn/Ai8rtP8lHm8=;
        b=AEXxBoVrS1u72aZBDZ4vcDzmGcxDw4KFRiqgEwmx6VUABvkGh/afo63uIIwswC6Qh+
         ctHKvPbu/IysukLeWRjy6LZ2JQ4E9fKMdJ690Xocb0g+ckSn3w1cimd3St2F2fFhPqVz
         Bj7VczE2VILaQs96vVy7wE2LaVVeAkZ1C7X3VuqTrRuVu925RTGjvNm0le4J9i7THnvW
         ZsCNydzn2uMPbR6plzA8DVNDwxeQIvny5Laqk17TfT+Ym0JTkj0os9UdMuMRLM4NtY7X
         HvzJS1cf2jfS2YWlmiFoENt4NNcoH5bhliicgfcmTwbJJakS1RErWzC03fd7exwCLfc8
         d/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=351giKD/sxHJWnb6T0gRmZz+Iu3NOtn/Ai8rtP8lHm8=;
        b=qGjOEXR5cAXoBTtBVUDqjrqhnJFuvxbZvKUt7kZ6kAT9S3N5u1DXRUD8evGN7Ow8Ii
         qeYwO2wPocSuwzt8Yy9z+g/vEU0TtbRMwfg1w9XP/mXXkcyY+qysUnTwHPAjbeFun89B
         mq0Wj8ib24Fao/fJKK98CWpBpZoBQ0uViLIFbqes8GuZVpR6EonRbLpRsfr73x8dWeHv
         NDnF90gxXbY8oQcy8+u9LscXdwT0wQNWpgSmaRFZSYgH/3ZuAsxG1UCbDcXZiB0waVQW
         3OsfoeV5fl0RWzs4KHb9ZFzVYQnX8DKHEk5QSdZyfwEdBSHM1BO+RLcqDdLesPRMGY13
         hQ8g==
X-Gm-Message-State: AOAM530aZ3aGBbOZ7+/0FLy+MRDujteBmlC33kKGUDFawXcS+EmNPUg4
        PO0uD2WhB+L7HNVbUHaZPuk=
X-Google-Smtp-Source: ABdhPJz4wgNMxPJUP30zvWu2vZHr59sFoe+UuVNnWdm/cX0+T7a16p8vQV5+TPNNZQrKwAilrSctWA==
X-Received: by 2002:aed:2569:: with SMTP id w38mr18638689qtc.3.1593011363516;
        Wed, 24 Jun 2020 08:09:23 -0700 (PDT)
Received: from dev.localdomain ([183.134.211.54])
        by smtp.gmail.com with ESMTPSA id l67sm3435801qkd.7.2020.06.24.08.09.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jun 2020 08:09:23 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org
Cc:     linux-xfs@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH] xfs: remove useless definitions in xfs_linux.h
Date:   Wed, 24 Jun 2020 11:08:48 -0400
Message-Id: <1593011328-10258-1-git-send-email-laoar.shao@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove current_pid(), current_test_flags() and
current_clear_flags_nested(), because they are useless.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 fs/xfs/xfs_linux.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 9f70d2f..ab737fe 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -102,12 +102,8 @@
 #define xfs_cowb_secs		xfs_params.cowb_timer.val
 
 #define current_cpu()		(raw_smp_processor_id())
-#define current_pid()		(current->pid)
-#define current_test_flags(f)	(current->flags & (f))
 #define current_set_flags_nested(sp, f)		\
 		(*(sp) = current->flags, current->flags |= (f))
-#define current_clear_flags_nested(sp, f)	\
-		(*(sp) = current->flags, current->flags &= ~(f))
 #define current_restore_flags_nested(sp, f)	\
 		(current->flags = ((current->flags & ~(f)) | (*(sp) & (f))))
 
-- 
1.8.3.1

