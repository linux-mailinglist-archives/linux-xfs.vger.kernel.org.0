Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B7A739B71
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jun 2023 11:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjFVJA1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 22 Jun 2023 05:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbjFVJAF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2023 05:00:05 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C82330D3
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 01:56:05 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1b5466bc5f8so9654975ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 01:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1687424164; x=1690016164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FWRSgLiVxGu7by+bRdZCMSZgL2CmyzCgjcAmFywfg3g=;
        b=W9Q0mEFJ4YX/Kxo42ZpDHLFmjt3CYHNqumMzPD6lCEJ/AclBj6ki+9nXx+XP2OFoT9
         biokZFjtTO4s6n85EeiNgXVRb8aHb7r2IMBB+HnwNOlBqet/0l5xfJVO+DolK/U7XTWU
         M277NuxA39AWH+q/lhKoP2vIlehvWLhpgJj/4uGWoGxCITX36OL+YHFtfzDKSSw2iPaX
         MbP+C5V24hBPOg4LWw9eV/ZehzOW8RyY8zV5pnDOyFwQ720HnrExvRoWQvOw0JMgQMOU
         XwvMcYncbAVdeNBjwwgU6wHkMwvamAyfgHl3RPNu98UxqyF0R9Sxc8Wx/1hGBgxkRDYX
         Kkuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687424164; x=1690016164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FWRSgLiVxGu7by+bRdZCMSZgL2CmyzCgjcAmFywfg3g=;
        b=cEGPnVzLBpuYIlbHVpr8I7+HDe8JwwfK6S5LIj2TBBja2cv9Kj4ZOUE9cx45LRxz1Q
         6Q5nDqyIWCgfuSL3Ua8b5CKHqxQ8qQOecTh333FOFZtH3TM5DpDrsr4mcvQ4cRuk2C4s
         WTP3J2WFPyP8zNY1s2LbDeD7CUAAr77U6SE7n59tjFEg+YGdagiQ8TL6v/9uTXfHWisy
         a3IC7zuwhLmAOYUz2THTNTOfOa4wbMGZ9lnuUuF/BjjefwxoFLXQB0ZAWzMgJxMkufQI
         3+npyG4lmA4gsCK5p+TwgX9X3QzY00ugj21+N6tLOMOn5s4p8J+nDiHX3OYIKnwxrm98
         kehQ==
X-Gm-Message-State: AC+VfDy7zoOfeGDWrfGNDN6lLiH/XnFzBcBQZP6IlENbt//dalI+YzQR
        GwmQ6IYDsWKGHWx0PMm3P0q38A==
X-Google-Smtp-Source: ACHHUZ4nYFfrGKqZLYUWSywLes9hZrkxqoQAJfwtv5FmoHmc5MLCqSR93ZcAMHhMn41B6ov+vpDAfw==
X-Received: by 2002:a17:902:ea01:b0:1b0:4680:60 with SMTP id s1-20020a170902ea0100b001b046800060mr21968987plg.1.1687424164102;
        Thu, 22 Jun 2023 01:56:04 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902f7c200b001b549fce345sm4806971plw.230.2023.06.22.01.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 01:56:03 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-arm-msm@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 15/29] NFSD: dynamically allocate the nfsd-client shrinker
Date:   Thu, 22 Jun 2023 16:53:21 +0800
Message-Id: <20230622085335.77010-16-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation for implementing lockless slab shrink,
we need to dynamically allocate the nfsd-client shrinker,
so that it can be freed asynchronously using kfree_rcu().
Then it doesn't need to wait for RCU read-side critical
section when releasing the struct nfsd_net.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 fs/nfsd/netns.h     |  2 +-
 fs/nfsd/nfs4state.c | 20 ++++++++++++--------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index ec49b200b797..f669444d5336 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -195,7 +195,7 @@ struct nfsd_net {
 	int			nfs4_max_clients;
 
 	atomic_t		nfsd_courtesy_clients;
-	struct shrinker		nfsd_client_shrinker;
+	struct shrinker		*nfsd_client_shrinker;
 	struct work_struct	nfsd_shrinker_work;
 };
 
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 6e61fa3acaf1..a06184270548 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4388,8 +4388,7 @@ static unsigned long
 nfsd4_state_shrinker_count(struct shrinker *shrink, struct shrink_control *sc)
 {
 	int count;
-	struct nfsd_net *nn = container_of(shrink,
-			struct nfsd_net, nfsd_client_shrinker);
+	struct nfsd_net *nn = shrink->private_data;
 
 	count = atomic_read(&nn->nfsd_courtesy_clients);
 	if (!count)
@@ -8094,14 +8093,19 @@ static int nfs4_state_create_net(struct net *net)
 	INIT_WORK(&nn->nfsd_shrinker_work, nfsd4_state_shrinker_worker);
 	get_net(net);
 
-	nn->nfsd_client_shrinker.scan_objects = nfsd4_state_shrinker_scan;
-	nn->nfsd_client_shrinker.count_objects = nfsd4_state_shrinker_count;
-	nn->nfsd_client_shrinker.seeks = DEFAULT_SEEKS;
-
-	if (register_shrinker(&nn->nfsd_client_shrinker, "nfsd-client"))
+	nn->nfsd_client_shrinker = shrinker_alloc_and_init(nfsd4_state_shrinker_count,
+							   nfsd4_state_shrinker_scan,
+							   0, DEFAULT_SEEKS, 0,
+							   nn);
+	if (!nn->nfsd_client_shrinker)
 		goto err_shrinker;
+
+	if (register_shrinker(nn->nfsd_client_shrinker, "nfsd-client"))
+		goto err_register;
 	return 0;
 
+err_register:
+	shrinker_free(nn->nfsd_client_shrinker);
 err_shrinker:
 	put_net(net);
 	kfree(nn->sessionid_hashtbl);
@@ -8197,7 +8201,7 @@ nfs4_state_shutdown_net(struct net *net)
 	struct list_head *pos, *next, reaplist;
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
-	unregister_shrinker(&nn->nfsd_client_shrinker);
+	unregister_and_free_shrinker(nn->nfsd_client_shrinker);
 	cancel_work(&nn->nfsd_shrinker_work);
 	cancel_delayed_work_sync(&nn->laundromat_work);
 	locks_end_grace(&nn->nfsd4_manager);
-- 
2.30.2

