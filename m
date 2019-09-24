Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 294FCBC44D
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Sep 2019 10:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbfIXIx4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Sep 2019 04:53:56 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43526 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbfIXIx4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Sep 2019 04:53:56 -0400
Received: by mail-pg1-f194.google.com with SMTP id v27so914978pgk.10;
        Tue, 24 Sep 2019 01:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=8QseQM1/5ejYhsu2Z/vNqJTsf/Jb9J9eyeHKUUC9R4M=;
        b=RzA4TLX4XcJjTbsdH1KF9KtECBqULYBSjXVqO5Kt3kUKlWbC/QrdPGdsjh2y9kM47F
         wTjuzHslvmvtS58v0yajkueydUfdDmDMcbirgG3PksVFIybmL0fpboLqqhaxVOJw2SCG
         fB17lfK1T77m38xnmyjrg2NjWPPcaY9kmD6BxESWcYuMfyK9IhvHsmiHGcbWOgBJIJKq
         oeGtwbmhV90JKvo0g8p97QN9RkVoRsGv901azvEIQQPjU69/c7/+stY1FNt6V+GCFLXE
         cSQW2pL+qgz7vzLa5Lr1m7rlCkBNTC7vjzQwcL7UmOeNgL3rg6XvxzQTwWMB8Ch0NzkS
         X4ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=8QseQM1/5ejYhsu2Z/vNqJTsf/Jb9J9eyeHKUUC9R4M=;
        b=XiSYm4SwC/NHxLSpxunve+OJR9v83G6b+nJ/suuyy/eQnLdQIOgNjbHF+zWG7oQ5oY
         6OfYOMghP5/ssLu7Ew6D+13MhP9igXvje22O7CenYdRejbH0U1Z0vnZNGgSdVZBHnKBE
         jgw/NO1hE3mY/0mPOrALb/Op7OOnNYM1HBHUs11VZo73Cmoo9bIUcuDPPa4mn1H9R/hr
         e9tQAN2gbE0Vhj22HI0gQp5zEv2m1I1lEczTFHbLB/+tOvCzmdCTmzzK67ozCts143fq
         kEKMB+UPWrAKTkPYOvL4ydl/EW67MeKcOkiQQYgdzRtHVBMXV4O4lLbRLr/opelVt/fo
         nj+A==
X-Gm-Message-State: APjAAAXWCFUIh7Wij4F/peQjufteo0JGTccwYUlz7lQ3650Zowm0NPaA
        3We1GUQE5ZOZNzHEiommFQY=
X-Google-Smtp-Source: APXvYqwd16dXArxLzdh+qJn+YuR+XPm4J9Kmb3chMaxSbjMokhXK1AUBPSBzhafrYz4ZSVadRuRl1w==
X-Received: by 2002:a63:4616:: with SMTP id t22mr2076498pga.123.1569315235151;
        Tue, 24 Sep 2019 01:53:55 -0700 (PDT)
Received: from LGEARND20B15 ([27.122.242.75])
        by smtp.gmail.com with ESMTPSA id c125sm1562095pfa.107.2019.09.24.01.53.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Sep 2019 01:53:54 -0700 (PDT)
Date:   Tue, 24 Sep 2019 17:53:50 +0900
From:   Austin Kim <austindh.kim@gmail.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        austindh.kim@gmail.com
Subject: [PATCH] xfs: avoid unused to_mp() function warning
Message-ID: <20190924085350.GA75425@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

to_mp() was first introduced with the following commit:
'commit 801cc4e17a34c ("xfs: debug mode forced buffered write failure")'

But the user of to_mp() was removed by below commit:
'commit f8c47250ba46e ("xfs: convert drop_writes to use the errortag
mechanism")'

So kernel build with clang throws below warning message:

   fs/xfs/xfs_sysfs.c:72:1: warning: unused function 'to_mp' [-Wunused-function]
   to_mp(struct kobject *kobject)

Hence to_mp() might be removed safely to get rid of warning message.

Signed-off-by: Austin Kim <austindh.kim@gmail.com>
---
 fs/xfs/xfs_sysfs.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index ddd0bf7..f1bc88f 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -63,19 +63,6 @@ static const struct sysfs_ops xfs_sysfs_ops = {
 	.store = xfs_sysfs_object_store,
 };
 
-/*
- * xfs_mount kobject. The mp kobject also serves as the per-mount parent object
- * that is identified by the fsname under sysfs.
- */
-
-static inline struct xfs_mount *
-to_mp(struct kobject *kobject)
-{
-	struct xfs_kobj *kobj = to_kobj(kobject);
-
-	return container_of(kobj, struct xfs_mount, m_kobj);
-}
-
 static struct attribute *xfs_mp_attrs[] = {
 	NULL,
 };
-- 
2.6.2

