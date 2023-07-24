Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9B875EFAA
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jul 2023 11:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232373AbjGXJq5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jul 2023 05:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjGXJq3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2023 05:46:29 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889461998
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 02:45:55 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1b8c364ad3bso8855625ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2023 02:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1690191955; x=1690796755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jmPwAlPL0TnDBmalzCzATtOPmfxfqu3Q+7XaFZclAtg=;
        b=IZCH5tV1VdvhB0RXcuG+SL+gg1mEbPZMQJz8qUY1fWCpYBfjAR72/AnWbcPpstjQLI
         aFpv+l8Q67Kc3iJwSzziW/zZbsYehvkdZbQbXx8X8jR6oJCUrIFV8Qzo50G/FYmT9t2/
         w6ZN7N+ZviCRVJxyy+bucuBxrS6SRhon2EIiX0i15H4OrDXIvK+dChrAy0pj6MjsuwdC
         6yiqEWuw0/0mdj0SNL2xTjIsK+WXPpE1gw9KgQ4WCUpGSoFe6rXH0GXBficEqbQlrShV
         wc7SdQklmSH69kiwU3dxFC6F0qOnJE6NuoEe6VBjJkE5shAIs2KVw9Ha+vCxjUcFWX2y
         lSHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690191955; x=1690796755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jmPwAlPL0TnDBmalzCzATtOPmfxfqu3Q+7XaFZclAtg=;
        b=lR2CahgW0zTp1Cm0pmt1zF4n6MMuRrN/6f+NSKKZWVk/E0x2qUWrLPuk+PUKG1HjED
         DpUxBjJl9t/H/CZvbiUEqO/oJXK+1b66dH/nYA0FGe/MF/IvyT1PdH7PPtnwohagroYE
         ucYahNSZo0txex2eBGkVumgEZ2UAbKON2XP7SfFZzVfEalsP4wIN3Y/hW9vxKx5hC2Gi
         Km7T2slRGRKGQVQz303lbT8hSp4RjkSw7gOg2/71sfGco5GHNwSW1wQGXCzQaojUV0ch
         L4oduUUZSG3rfPST36qj4zMypemcojz4pau+Pyd64n0dzllaoYXiOa7kdZMZFUddAt1W
         cvlA==
X-Gm-Message-State: ABy/qLYgpV3Kk4NJacgz0tWrXw2wjD7ztMdaT9VXwXVqaO8W4godeAFF
        xSEolR2XWkO8d8Rlz+rSMOnD3Q==
X-Google-Smtp-Source: APBJJlHDY1qhgSa+H4mr70oj6h44PLP3QUTUzXb3MsGg4I77oDNLLFWrtOaIhBAmIAnOXFQDdEVBFw==
X-Received: by 2002:a17:902:d4cb:b0:1b1:9272:55e2 with SMTP id o11-20020a170902d4cb00b001b1927255e2mr12365119plg.3.1690191954835;
        Mon, 24 Jul 2023 02:45:54 -0700 (PDT)
Received: from C02DW0BEMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001bb20380bf2sm8467233pld.13.2023.07.24.02.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 02:45:54 -0700 (PDT)
From:   Qi Zheng <zhengqi.arch@bytedance.com>
To:     akpm@linux-foundation.org, david@fromorbit.com, tkhai@ya.ru,
        vbabka@suse.cz, roman.gushchin@linux.dev, djwong@kernel.org,
        brauner@kernel.org, paulmck@kernel.org, tytso@mit.edu,
        steven.price@arm.com, cel@kernel.org, senozhatsky@chromium.org,
        yujie.liu@intel.com, gregkh@linuxfoundation.org,
        muchun.song@linux.dev
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-erofs@lists.ozlabs.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-nfs@vger.kernel.org, linux-mtd@lists.infradead.org,
        rcu@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 04/47] kvm: mmu: dynamically allocate the x86-mmu shrinker
Date:   Mon, 24 Jul 2023 17:43:11 +0800
Message-Id: <20230724094354.90817-5-zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use new APIs to dynamically allocate the x86-mmu shrinker.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 arch/x86/kvm/mmu/mmu.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ec169f5c7dce..ab405e0a8954 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6847,11 +6847,7 @@ static unsigned long mmu_shrink_count(struct shrinker *shrink,
 	return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
 }
 
-static struct shrinker mmu_shrinker = {
-	.count_objects = mmu_shrink_count,
-	.scan_objects = mmu_shrink_scan,
-	.seeks = DEFAULT_SEEKS * 10,
-};
+static struct shrinker *mmu_shrinker;
 
 static void mmu_destroy_caches(void)
 {
@@ -6984,10 +6980,16 @@ int kvm_mmu_vendor_module_init(void)
 	if (percpu_counter_init(&kvm_total_used_mmu_pages, 0, GFP_KERNEL))
 		goto out;
 
-	ret = register_shrinker(&mmu_shrinker, "x86-mmu");
-	if (ret)
+	mmu_shrinker = shrinker_alloc(0, "x86-mmu");
+	if (!mmu_shrinker)
 		goto out_shrinker;
 
+	mmu_shrinker->count_objects = mmu_shrink_count;
+	mmu_shrinker->scan_objects = mmu_shrink_scan;
+	mmu_shrinker->seeks = DEFAULT_SEEKS * 10;
+
+	shrinker_register(mmu_shrinker);
+
 	return 0;
 
 out_shrinker:
@@ -7009,7 +7011,7 @@ void kvm_mmu_vendor_module_exit(void)
 {
 	mmu_destroy_caches();
 	percpu_counter_destroy(&kvm_total_used_mmu_pages);
-	unregister_shrinker(&mmu_shrinker);
+	shrinker_unregister(mmu_shrinker);
 }
 
 /*
-- 
2.30.2

