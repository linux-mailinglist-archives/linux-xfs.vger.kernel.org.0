Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9A96D181E
	for <lists+linux-xfs@lfdr.de>; Fri, 31 Mar 2023 09:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbjCaHI0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 31 Mar 2023 03:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbjCaHIZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Mar 2023 03:08:25 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09819CA19
        for <linux-xfs@vger.kernel.org>; Fri, 31 Mar 2023 00:08:24 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d4-20020a056a00198400b00628000145bcso9907424pfl.0
        for <linux-xfs@vger.kernel.org>; Fri, 31 Mar 2023 00:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680246503;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B2pWBeS3GCf3oNfr31dlSqb/2UGMYxzBqyAxEtHKHDE=;
        b=k4NyjagiGkCklbJVsqIMtonbdCMcTupGTS8hoHaC0gv8FOGuM+Bs5S57llv7e0EaSv
         Cdr8aYY+xrBbCtFlM6wcVGLHr43sIVgLRjo6N9VGVd6RPJWbRRFixWbs+ilYQFqKNFaX
         XmIjhQjyQd9NZkc3tv9rRK0BApt1ddgQG5Hmi7auJiptlkO709XlGaRHtR6d3pQ9Avj3
         N34PvmS9EWNDok32raE4oK5g8hggDeU3zDAViHIjtdEdByWnmMFFSaEjcfkCBkO01CnD
         9fsOaBbQNmSszl6BuqVSwa5jOVOxj6sT1Ok05l7fpvj5jCSBxdjsIIURvPSg0lRWYZMb
         t+xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680246503;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B2pWBeS3GCf3oNfr31dlSqb/2UGMYxzBqyAxEtHKHDE=;
        b=3br3BLOsuOtXXYc1mpZv8rt+X6YM20IOcoiY8+PiCHP0iOVxrp0B+fscB/7GlSqTiv
         dvRiNjLfYRRc8PIjKnlKNf0OwWFP8N2P1nH8mBL+ioy32gJe3796iyOKY1B/F4YEIvEB
         Ya1dOgH/+DOxdG2u25Smo3FxMNSge8iI6E1+tAcJk+jKcSU4s6szSxUwHsuJMWsVK0Y8
         bbNhoRvk9uf/YmwkZm36cpsr1jyrrEYjhO9wYS+MzycPzHCqtjIGSZADnj+0LJyc2T52
         ujXSNhsnurd1NsPN4PV81GxgzEWXC/C5u+IfDld+HFLsdr0GQs5NDIdCnn13kC4yv3Uu
         g70A==
X-Gm-Message-State: AAQBX9flcCFiVxebnI9ZG71osQAskj4tw4ZBzhzvSqV8knQTbRoKg+zA
        XsjcWBmAGL7CkISj3bDMfs7n8gIermKMIIiZ
X-Google-Smtp-Source: AKy350bRvjgd15ALJuao0xdVFVls0BdarK49AoD9W3kOxaJ3kd852in4QhALpf6ZkL2aYK5+VCe3mI8yGkJLtLkv
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:902:9b87:b0:1a2:1c7:1c1b with SMTP
 id y7-20020a1709029b8700b001a201c71c1bmr8812952plp.5.1680246503444; Fri, 31
 Mar 2023 00:08:23 -0700 (PDT)
Date:   Fri, 31 Mar 2023 07:08:16 +0000
In-Reply-To: <20230331070818.2792558-1-yosryahmed@google.com>
Mime-Version: 1.0
References: <20230331070818.2792558-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230331070818.2792558-2-yosryahmed@google.com>
Subject: [PATCH v3 1/3] mm: vmscan: move set_task_reclaim_state() after cgroup_reclaim()
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Xu <peterx@redhat.com>, NeilBrown <neilb@suse.de>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

set_task_reclaim_state() is currently defined in mm/vmscan.c above
an #ifdef CONFIG_MEMCG block where cgroup_reclaim() is defined. We are
about to add some more helpers that operate on reclaim_state, and will
need to use cgroup_reclaim(). Move set_task_reclaim_state() after
the #ifdef CONFIG_MEMCG block containing the definition of
cgroup_reclaim() to keep helpers operating on reclaim_state together.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 mm/vmscan.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9c1c5e8b24b8f..fef7d1c0f82b2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -188,18 +188,6 @@ struct scan_control {
  */
 int vm_swappiness = 60;
 
-static void set_task_reclaim_state(struct task_struct *task,
-				   struct reclaim_state *rs)
-{
-	/* Check for an overwrite */
-	WARN_ON_ONCE(rs && task->reclaim_state);
-
-	/* Check for the nulling of an already-nulled member */
-	WARN_ON_ONCE(!rs && !task->reclaim_state);
-
-	task->reclaim_state = rs;
-}
-
 LIST_HEAD(shrinker_list);
 DECLARE_RWSEM(shrinker_rwsem);
 
@@ -511,6 +499,18 @@ static bool writeback_throttling_sane(struct scan_control *sc)
 }
 #endif
 
+static void set_task_reclaim_state(struct task_struct *task,
+				   struct reclaim_state *rs)
+{
+	/* Check for an overwrite */
+	WARN_ON_ONCE(rs && task->reclaim_state);
+
+	/* Check for the nulling of an already-nulled member */
+	WARN_ON_ONCE(!rs && !task->reclaim_state);
+
+	task->reclaim_state = rs;
+}
+
 static long xchg_nr_deferred(struct shrinker *shrinker,
 			     struct shrink_control *sc)
 {
-- 
2.40.0.348.gf938b09366-goog

