Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E246D6648
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Apr 2023 16:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbjDDO46 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Apr 2023 10:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbjDDO4a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 10:56:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F5F49FD
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 07:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680620127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g1NG2DlOPhECSBoFyURsYJB7f5VQnxxV8rEkg1d1tQc=;
        b=XZFSNVQrhFBnmhJq1cNOsc+Z68bwK5V78W+Vx6LOiAyIrfXhyLBPSA62mIqwvQBUXfQ8sv
        y80yQRDCEW8zSg4kXc+M2ArIBxuNIEY39sc2XlVzLOcqdt3zSRyt4wp8f5DCaeH7Vsa76Z
        NuIJNDpKX2WqY8NPPupTJc7NPV2j3oY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-8UYG9NwyNkCjla8GOtsKIg-1; Tue, 04 Apr 2023 10:55:26 -0400
X-MC-Unique: 8UYG9NwyNkCjla8GOtsKIg-1
Received: by mail-qv1-f72.google.com with SMTP id m3-20020a0cbf03000000b005de7233ca79so12464299qvi.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Apr 2023 07:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680620126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g1NG2DlOPhECSBoFyURsYJB7f5VQnxxV8rEkg1d1tQc=;
        b=RbjguDdLJNyvm1eniVVt3t2agXHk/F5Tk7wCtQWNJPMb1IDyIHmNcDm5R1P/GRxYwH
         dAqjctQnb0EznWU4UQVkoH03TzQldF7QmoinOsmf2S2QXerAuLoTlpU3qZuEUlwGqI2C
         s5rf0UYJDb4g2AUc+uQYirZj7d0w7/AoBmqQxKz6wxJO97t8ZMkqAjodehnSHW2kDSsg
         xRzHFNFzD/23WM5KVw784hL9Ufp9TcIrF13xuaJHDH6vnMiJLKEXn2kZvxbnencv6JXE
         wDnbiAkTYVEm1uz+sAJh8q/HoxowyIkWKHYlDvfWMLUy6q1FbKHiaZ1SAvNr+n1m6ayo
         KYZg==
X-Gm-Message-State: AAQBX9fQN5HyxkM0t1YC3FgZGadp24FwjcNWLxW61U2mmIoQKn+fAkt9
        jIUeeT089PgdIKYol3rvNxIPHdZ7oLcXdP1AH9syaSROVL20v7A1iSwCjDepl4y1vF7LpNBoDGc
        ilipMTgDODHrT9OSU4+0=
X-Received: by 2002:ac8:5754:0:b0:3d7:960e:5387 with SMTP id 20-20020ac85754000000b003d7960e5387mr3872558qtx.35.1680620126003;
        Tue, 04 Apr 2023 07:55:26 -0700 (PDT)
X-Google-Smtp-Source: AKy350bjyktKoJdi6D9KFFirgwb83MTSe30Fparym5df9UxsVGpZNZWXy1G6A3UC/2iyEvUKlSZpbw==
X-Received: by 2002:ac8:5754:0:b0:3d7:960e:5387 with SMTP id 20-20020ac85754000000b003d7960e5387mr3871997qtx.35.1680620120899;
        Tue, 04 Apr 2023 07:55:20 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j4-20020ac86644000000b003e6387431dcsm3296539qtp.7.2023.04.04.07.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:55:20 -0700 (PDT)
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     djwong@kernel.org, dchinner@redhat.com, ebiggers@kernel.org,
        hch@infradead.org, linux-xfs@vger.kernel.org,
        fsverity@lists.linux.dev
Cc:     rpeterso@redhat.com, agruenba@redhat.com, xiang@kernel.org,
        chao@kernel.org, damien.lemoal@opensource.wdc.com, jth@kernel.org,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v2 12/23] xfs: introduce workqueue for post read IO work
Date:   Tue,  4 Apr 2023 16:53:08 +0200
Message-Id: <20230404145319.2057051-13-aalbersh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230404145319.2057051-1-aalbersh@redhat.com>
References: <20230404145319.2057051-1-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As noted by Dave there are two problems with using fs-verity's
workqueue in XFS:

1. High priority workqueues are used within XFS to ensure that data
   IO completion cannot stall processing of journal IO completions.
   Hence using a WQ_HIGHPRI workqueue directly in the user data IO
   path is a potential filesystem livelock/deadlock vector.

2. The fsverity workqueue is global - it creates a cross-filesystem
   contention point.

This patch adds per-filesystem, per-cpu workqueue for fsverity
work.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/xfs_mount.h | 1 +
 fs/xfs/xfs_super.c | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f3269c0626f0..53a4a9304937 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -107,6 +107,7 @@ typedef struct xfs_mount {
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct workqueue_struct *m_buf_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
+	struct workqueue_struct	*m_postread_workqueue;
 	struct workqueue_struct	*m_reclaim_workqueue;
 	struct workqueue_struct	*m_sync_workqueue;
 	struct workqueue_struct *m_blockgc_wq;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4f814f9e12ab..d6f22cb94ee2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -548,6 +548,12 @@ xfs_init_mount_workqueues(
 	if (!mp->m_unwritten_workqueue)
 		goto out_destroy_buf;
 
+	mp->m_postread_workqueue = alloc_workqueue("xfs-pread/%s",
+			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM),
+			0, mp->m_super->s_id);
+	if (!mp->m_postread_workqueue)
+		goto out_destroy_postread;
+
 	mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
 			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM),
 			0, mp->m_super->s_id);
@@ -581,6 +587,8 @@ xfs_init_mount_workqueues(
 	destroy_workqueue(mp->m_reclaim_workqueue);
 out_destroy_unwritten:
 	destroy_workqueue(mp->m_unwritten_workqueue);
+out_destroy_postread:
+	destroy_workqueue(mp->m_postread_workqueue);
 out_destroy_buf:
 	destroy_workqueue(mp->m_buf_workqueue);
 out:
@@ -596,6 +604,7 @@ xfs_destroy_mount_workqueues(
 	destroy_workqueue(mp->m_inodegc_wq);
 	destroy_workqueue(mp->m_reclaim_workqueue);
 	destroy_workqueue(mp->m_unwritten_workqueue);
+	destroy_workqueue(mp->m_postread_workqueue);
 	destroy_workqueue(mp->m_buf_workqueue);
 }
 
-- 
2.38.4

