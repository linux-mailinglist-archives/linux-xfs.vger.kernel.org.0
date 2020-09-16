Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F032D26C5FD
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Sep 2020 19:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgIPR2m (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Sep 2020 13:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgIPR2i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 13:28:38 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C99C0698C1
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:28 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w7so3794791pfi.4
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=e6zzA9XFxzYlVVxGx9Ti25fw4M1XCAzFK3ndwI1eYwE=;
        b=VMYvdX+4uSyMZxhSWLLzWNwzketOLdVx6+kKgCdsmycy8x70Tzdt2CnXYw9NbxnTge
         JMFpOYRF4DaQKgSgtCDkpqrDaaL4J371MD3jfZvfwoNpj48V3s7ovfq0wpN2ZLrPsn9s
         XSDo9yTLkqjCvlXR86XgwpKh5pkvytTCKg8Aww+3tlmhCOjw4uU5sT1hpEuv7lwzbKNx
         YNaRP7V2r/ZH/PbMLG9F67NLwT2HS24NcAL7EOkgi4P5MkZJjK/m+LySDMRqRbxI8ERN
         cnGD+Al6irUoU4oFCbdmcjIoXqgpmzUjHALOmOGpS+NDXemFYzWC7MzZK2HQktMDhPr+
         SmcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e6zzA9XFxzYlVVxGx9Ti25fw4M1XCAzFK3ndwI1eYwE=;
        b=QE+tq8lHLT2mOuKOMkAOveLEC/oBWFSOCxCe7vqG03mCwGC+RxlTeuIm4UhOeqPHGk
         +gSuTqO49aCqaam4qpKwhRyUNWFGXY5JtIYX0Lw2EmuZYlPrxoZYfXj+CdoUaWQv2Byx
         VJ23mNqyCREEK2IY7TQ8GtbUtgTRCwfUudYtucVhid0Fj/P+leDg/71n0h9GEIeK4lyJ
         LPR56V0AWjJCqZ/6YT8BK0016us23enfrAfFEW3BsFgLV5Blvh/vTPg9IwESCEHg9WAE
         ZldbBeK6Uym4ovjp55NHnlKCpagKzEl4zgpWmVVoCu3SMZX/M4pEDAxQ7w2gLbYlsPaw
         z6gA==
X-Gm-Message-State: AOAM531YTTUDNqvMuvY9RL8tXeZfoQ4pFcO1odN72UrBUYX9ws9FKbDL
        6pPX8KVNFfavBSSofQPv2vvYPNPrbE0Q
X-Google-Smtp-Source: ABdhPJwpKi8m8WHi0RdOBepNDN1X4MkYtOeiZOZyfCsGC/5ClZs2tjg0nl6IE4x412ZyiNKwy+G1uw==
X-Received: by 2002:a63:4f17:: with SMTP id d23mr88755pgb.319.1600255167573;
        Wed, 16 Sep 2020 04:19:27 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id v204sm3492195pfc.10.2020.09.16.04.19.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 04:19:26 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: cleanup the useless backslash in xfs_attr_leaf_entsize_remote
Date:   Wed, 16 Sep 2020 19:19:11 +0800
Message-Id: <1600255152-16086-9-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The backslash is useless and remove it.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/libxfs/xfs_da_format.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index b40a4e80f5ee..4fe974773d85 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -746,7 +746,7 @@ xfs_attr3_leaf_name_local(xfs_attr_leafblock_t *leafp, int idx)
  */
 static inline int xfs_attr_leaf_entsize_remote(int nlen)
 {
-	return ((uint)sizeof(xfs_attr_leaf_name_remote_t) - 1 + (nlen) + \
+	return ((uint)sizeof(xfs_attr_leaf_name_remote_t) - 1 + (nlen) +
 		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
 }
 
-- 
2.20.0

