Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2566775B0B7
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jul 2023 16:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjGTOFD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jul 2023 10:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbjGTOFC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2023 10:05:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2364E123;
        Thu, 20 Jul 2023 07:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=MU6yo3/JkEwDpfVtYsrPOrA7WaINTrJRX/tZStkXyyg=; b=u5fs6hBazs5UDdEUCHFufcXQuV
        M8Mhc6YEu2dgb1zeZYAHYeiE99a04zapRuwjalF5XCByuAKRSTJrigMBq0DCJiRLCkuxtk6B9dmK8
        T+nYF4UnUOjqOlAU9gI9CePE6IRoAKps8uMUxaYIL7cGIYDhwvqoeOdghhLfirCoeCNMzidjoIK1n
        6d7+K1Ts6LvaBv35Xv6GNw1zpaFFZDUhBFclPHtdwSwC0UborwfvNvgrQncy3kUge2+lKSgE1xuPt
        AGEjbPHNDq+DnlTCx7zX0fJmLdVJRhHTWZCOS8F6s9d6/19YFb6+XRYMdpnoH00ELwTsZMGJwnQtn
        eUCBTUCA==;
Received: from [2001:4bb8:19a:298e:a587:c3ea:b692:5b8d] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qMUH3-00BKoB-1Q;
        Thu, 20 Jul 2023 14:04:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <christian@brauner.io>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] fs: remove emergency_thaw_bdev
Date:   Thu, 20 Jul 2023 16:04:47 +0200
Message-Id: <20230720140452.63817-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230720140452.63817-1-hch@lst.de>
References: <20230720140452.63817-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fold emergency_thaw_bdev into it's only caller, to prepare for buffer.c
to be built only when buffer_head support is enabled.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/buffer.c   | 6 ------
 fs/internal.h | 6 ------
 fs/super.c    | 4 +++-
 3 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index bd091329026c0f..376f468e16662d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -562,12 +562,6 @@ static int osync_buffers_list(spinlock_t *lock, struct list_head *list)
 	return err;
 }
 
-void emergency_thaw_bdev(struct super_block *sb)
-{
-	while (sb->s_bdev && !thaw_bdev(sb->s_bdev))
-		printk(KERN_WARNING "Emergency Thaw on %pg\n", sb->s_bdev);
-}
-
 /**
  * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
  * @mapping: the mapping which wants those buffers written
diff --git a/fs/internal.h b/fs/internal.h
index f7a3dc11102647..d538d832fd608b 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -23,16 +23,10 @@ struct mnt_idmap;
  */
 #ifdef CONFIG_BLOCK
 extern void __init bdev_cache_init(void);
-
-void emergency_thaw_bdev(struct super_block *sb);
 #else
 static inline void bdev_cache_init(void)
 {
 }
-static inline int emergency_thaw_bdev(struct super_block *sb)
-{
-	return 0;
-}
 #endif /* CONFIG_BLOCK */
 
 /*
diff --git a/fs/super.c b/fs/super.c
index e781226e28800c..bc666e7ee1a984 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1029,7 +1029,9 @@ static void do_thaw_all_callback(struct super_block *sb)
 {
 	down_write(&sb->s_umount);
 	if (sb->s_root && sb->s_flags & SB_BORN) {
-		emergency_thaw_bdev(sb);
+		if (IS_ENABLED(CONFIG_BLOCK))
+			while (sb->s_bdev && !thaw_bdev(sb->s_bdev))
+				pr_warn("Emergency Thaw on %pg\n", sb->s_bdev);
 		thaw_super_locked(sb);
 	} else {
 		up_write(&sb->s_umount);
-- 
2.39.2

