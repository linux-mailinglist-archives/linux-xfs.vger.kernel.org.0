Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4BC96E0B8C
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Apr 2023 12:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjDMKkp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Apr 2023 06:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjDMKkl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 06:40:41 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CAAE57
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 03:40:37 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id m21-20020a17090ab79500b002401201f1f9so6986750pjr.2
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 03:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681382437; x=1683974437;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5nwS1fyBbt8DCsnm68UGE4Io82ni7EltGX1ZDdiySc8=;
        b=HVVoobkiezjfp6Y+BOD4SNMlrogZ39TsH1UXpB46VIMDpuP6g8jnu4Z1tFvSefqpa7
         ibKeL8Y8v8nU89B6vMehbHdbQLqWet8dgNLfmXNet9Ipt1SE7lD//LOA5qZhJsd+TyzB
         0NR3cw+wpAzpZDYLnkhBnZTCqUKAdsLrw1zJNZoMYbE0K5EXRK9zgOHKc6hd+xdDV6Wh
         7oCtwbLRJC1FzkYCfIDMIgKZJ6uq6+eR3gCZXHpVFEFsNPt0I4yguZUs0ykjuPKeyKJv
         TkAYIgT/O+m7d5+TGbrU5WfhSrVp7RMxUmdPVOLZgW6fMwK/WQDxq23MCj/rtwo8ySJK
         trHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681382437; x=1683974437;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5nwS1fyBbt8DCsnm68UGE4Io82ni7EltGX1ZDdiySc8=;
        b=eZZzHgfUpoMTpQZQzSK6bg0ourzB0PUhvFP+YSElXW7VP145RIrVUJDyOhbb6/4R3G
         du2hQGMl7juJ5GRoDoMh92mH4/PnI1PEkSXtyI7lHZXZ3ByVYK/Ip70BSgwFrOy80mMg
         QFC8uNY0AzlLJuaT+Ocof7bkoUPiNKVFvsfyLPct0Qq0EBXVUjAiBSZO0MV7Sc5SQdIF
         WUg14jJ/fFD1hzliehVb4tXQ5J6WO4XtldmPhEdmCXGnigLt43J9+vY8e5XiMkc12adV
         qP5r9ksEwQVHLuFjLZVTFj9re4dkRCJECfW6ebns9XMmvSpswx7bcXbPi8y//4k/SAr/
         kzaw==
X-Gm-Message-State: AAQBX9f8R3XsVWEA9w+k8xkV5zx+oSTFonHOIGW1lSRYrQ9PGsgwSDDg
        nkr3Iizu4fvSb6cYvkJEEk7ko8Ahx1IwVT8K
X-Google-Smtp-Source: AKy350Zyd2UqUy2DbXNw2G9qTq8DvjwykWuM+fBRJ4yT4p2uyKCDPpMTL/SCWAMTdDtoYDEHTj4HrbLDBQxJccn5
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a65:5584:0:b0:51b:2e3f:9c41 with SMTP
 id j4-20020a655584000000b0051b2e3f9c41mr358746pgs.1.1681382437184; Thu, 13
 Apr 2023 03:40:37 -0700 (PDT)
Date:   Thu, 13 Apr 2023 10:40:31 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230413104034.1086717-1-yosryahmed@google.com>
Subject: [PATCH v6 0/3] Ignore non-LRU-based reclaim in memcg reclaim
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
        Dave Chinner <david@fromorbit.com>,
        Tim Chen <tim.c.chen@linux.intel.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Upon running some proactive reclaim tests using memory.reclaim, we
noticed some tests flaking where writing to memory.reclaim would be
successful even though we did not reclaim the requested amount fully
Looking further into it, I discovered that *sometimes* we overestimate
the number of reclaimed pages in memcg reclaim.

Reclaimed pages through other means than LRU-based reclaim are tracked
through reclaim_state in struct scan_control, which is stashed in
current task_struct. These pages are added to the number of reclaimed
pages through LRUs. For memcg reclaim, these pages generally cannot be
linked to the memcg under reclaim and can cause an overestimated count
of reclaimed pages. This short series tries to address that.

Patch 1 ignores pages reclaimed outside of LRU reclaim in memcg reclaim.
The pages are uncharged anyway, so even if we end up under-reporting
reclaimed pages we will still succeed in making progress during
charging.

Patches 2-3 are just refactoring. Patch 2 moves set_reclaim_state()
helper next to flush_reclaim_state(). Patch 3 adds a helper that wraps
updating current->reclaim_state, and renames
reclaim_state->reclaimed_slab to reclaim_state->reclaimed.

v5 -> v6:
- Re-arranged the patches:
  - Pulled flush_reclaim_state() helper with the clarifyng comment to
    the first patch so that the patch is clear on its own (David
    Hildenbrand).
  - Separated moving set_reclaim_state() to a separate patch so that we
    can easily drop it if deemed unnecessary (Questioned by Peter Xu).
- Added a fixes tag (David Hildenbrand).
- Reworded comment in flush_reclaim_state() (David Hildenbrand and Tim
  Chen).
- Dropped reclaim_state argument to flush_reclaim_state() and use
  current->reclaim_state directly instead (Peter Xu).

v5: https://lore.kernel.org/linux-mm/20230405185427.1246289-1-yosryahmed@google.com/

Yosry Ahmed (3):
  mm: vmscan: ignore non-LRU-based reclaim in memcg reclaim
  mm: vmscan: move set_task_reclaim_state() near flush_reclaim_state()
  mm: vmscan: refactor updating current->reclaim_state

 fs/inode.c           |  3 +-
 fs/xfs/xfs_buf.c     |  3 +-
 include/linux/swap.h | 17 ++++++++++-
 mm/slab.c            |  3 +-
 mm/slob.c            |  6 ++--
 mm/slub.c            |  5 ++-
 mm/vmscan.c          | 72 ++++++++++++++++++++++++++++++++------------
 7 files changed, 76 insertions(+), 33 deletions(-)

-- 
2.40.0.577.gac1e443424-goog

