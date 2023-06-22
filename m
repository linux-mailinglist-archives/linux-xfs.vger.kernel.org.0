Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289A1739B94
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jun 2023 11:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbjFVJBI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 22 Jun 2023 05:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbjFVJAU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2023 05:00:20 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2109F3AA0
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 01:56:35 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-54fd4a7ce25so1096313a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 01:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1687424180; x=1690016180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DX6SUDFVJBECNsblFEChPYzpO8xY8cES72+0dMzxuzQ=;
        b=J0xdX/HVFp5YYG4TfcvtFJvRxLyQLKtNeoVYCgaC2J+nRoYDa/BzwrOrCj094o0cZq
         1xReHr0GJ1hygdSXflfCN7O6Wd3k5bnTYjzGehkNWElkKcnI57FpdEY2zo1QIhRivIfW
         Vn3A6HH2yEtIwY+bYcUHLIMQK61OnnzFACK07hJ1eCTN8lHwm9h5Rchf6mt0xuf3bmH2
         YrMt/i+taGwUAGQfmqtCpero+/nADk45X1pPDnlfELgRkE2o8P26K8ugc6xZW6o9l2x2
         0OyQF06tkzpnptZeoSrMW5oczymeBmy807qxrTJz07x7dVgWrGVUEsLlXTXBF7IGucek
         WQiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687424180; x=1690016180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DX6SUDFVJBECNsblFEChPYzpO8xY8cES72+0dMzxuzQ=;
        b=c6ZcnNg7aWk9VUAmdGh9vH8N/ETD8OkEYTKVNjS2x1Y6xu9ALOHdoezOyTLXoRySh9
         mGY3qcOEEogZ78UwbgTQm7xVLiKMYgi8ol2GtcGLKVYemU3M6T5b4r8yR1bNvkBq4Vsp
         YfsXyr27eeOVggT6bR111gzrERxJxEXpDGXSsx+OQKKJX8zfWYNMpGoydN1g0TNTjrAd
         HwFTZIjpjPOIEjnvLXpS7742ZTEpYiDzjgNF0COz/loYhGoNCF2u4U5G9uy55Rdos+Fx
         vnGCT+GGU4ZpMWhQiriRNihqK6wPMK4vtKIHbuzpQ9jeHp9HZrd//WtDIoT/rW+X0Rny
         ibXg==
X-Gm-Message-State: AC+VfDxRs9uDxEtlSRUzmvSIBnWE0S5RimZBTpqfr+9p8kegh5WNa54Q
        f8RAOptz1cfTTx2O0FpslKPWMw==
X-Google-Smtp-Source: ACHHUZ6cRwGFUE7wdLf8WreSOUecoWuLPpHsSO23aKngJIhhKsUdOoFlGAyrZhuJGN3RD5MvXrHaNg==
X-Received: by 2002:a17:903:2452:b0:1a9:581b:fbaa with SMTP id l18-20020a170903245200b001a9581bfbaamr20887740pls.2.1687424179969;
        Thu, 22 Jun 2023 01:56:19 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902f7c200b001b549fce345sm4806971plw.230.2023.06.22.01.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 01:56:19 -0700 (PDT)
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
Subject: [PATCH 17/29] xfs: dynamically allocate the xfs-buf shrinker
Date:   Thu, 22 Jun 2023 16:53:23 +0800
Message-Id: <20230622085335.77010-18-zhengqi.arch@bytedance.com>
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
we need to dynamically allocate the xfs-buf shrinker,
so that it can be freed asynchronously using kfree_rcu().
Then it doesn't need to wait for RCU read-side critical
section when releasing the struct xfs_buftarg.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 fs/xfs/xfs_buf.c | 25 ++++++++++++++-----------
 fs/xfs/xfs_buf.h |  2 +-
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 15d1e5a7c2d3..6657d285d26f 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1906,8 +1906,7 @@ xfs_buftarg_shrink_scan(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
-	struct xfs_buftarg	*btp = container_of(shrink,
-					struct xfs_buftarg, bt_shrinker);
+	struct xfs_buftarg	*btp = shrink->private_data;
 	LIST_HEAD(dispose);
 	unsigned long		freed;
 
@@ -1929,8 +1928,7 @@ xfs_buftarg_shrink_count(
 	struct shrinker		*shrink,
 	struct shrink_control	*sc)
 {
-	struct xfs_buftarg	*btp = container_of(shrink,
-					struct xfs_buftarg, bt_shrinker);
+	struct xfs_buftarg	*btp = shrink->private_data;
 	return list_lru_shrink_count(&btp->bt_lru, sc);
 }
 
@@ -1938,7 +1936,7 @@ void
 xfs_free_buftarg(
 	struct xfs_buftarg	*btp)
 {
-	unregister_shrinker(&btp->bt_shrinker);
+	unregister_and_free_shrinker(btp->bt_shrinker);
 	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
 	percpu_counter_destroy(&btp->bt_io_count);
 	list_lru_destroy(&btp->bt_lru);
@@ -2021,15 +2019,20 @@ xfs_alloc_buftarg(
 	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
 		goto error_lru;
 
-	btp->bt_shrinker.count_objects = xfs_buftarg_shrink_count;
-	btp->bt_shrinker.scan_objects = xfs_buftarg_shrink_scan;
-	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
-	btp->bt_shrinker.flags = SHRINKER_NUMA_AWARE;
-	if (register_shrinker(&btp->bt_shrinker, "xfs-buf:%s",
-			      mp->m_super->s_id))
+	btp->bt_shrinker = shrinker_alloc_and_init(xfs_buftarg_shrink_count,
+						   xfs_buftarg_shrink_scan,
+						   0, DEFAULT_SEEKS,
+						   SHRINKER_NUMA_AWARE, btp);
+	if (!btp->bt_shrinker)
 		goto error_pcpu;
+
+	if (register_shrinker(btp->bt_shrinker, "xfs-buf:%s",
+			      mp->m_super->s_id))
+		goto error_shrinker;
 	return btp;
 
+error_shrinker:
+	shrinker_free(btp->bt_shrinker);
 error_pcpu:
 	percpu_counter_destroy(&btp->bt_io_count);
 error_lru:
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 549c60942208..4e6969a675f7 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -102,7 +102,7 @@ typedef struct xfs_buftarg {
 	size_t			bt_logical_sectormask;
 
 	/* LRU control structures */
-	struct shrinker		bt_shrinker;
+	struct shrinker		*bt_shrinker;
 	struct list_lru		bt_lru;
 
 	struct percpu_counter	bt_io_count;
-- 
2.30.2

