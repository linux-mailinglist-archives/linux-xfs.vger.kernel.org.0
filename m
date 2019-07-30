Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4B6479EBF
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2019 04:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730996AbfG3CcT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 29 Jul 2019 22:32:19 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45393 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729370AbfG3CcS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jul 2019 22:32:18 -0400
Received: by mail-pg1-f195.google.com with SMTP id o13so29196935pgp.12;
        Mon, 29 Jul 2019 19:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YV/+iCS4EeSNAMRIOjIIW+INsj2i8EpPe81QUMDSEVs=;
        b=m0a1l+F+LVO7Qb/hH9dKdcZfBbYrqyWJpSE3O4a6VhZERbnGovGqSJ+PI1OaqLuga/
         6gHT2yYrjsfdiVWXtBE8tb+cNJPUgZi3j8wFDvkO/Y/AfG/NUxSppeEEFzUDrrs8O3yd
         uhrIaAgThHdBTWpTWxkfebhsjhaM9HSzdPqTPlY1eFuQUz7/GMusGTao000YYocoAV4n
         63zrD5eV8H4DI2HGx5yTUwBZw5bxsmKqJYYGju3nx4KPVV2TmhhVu3HnUNLVLqVfe2zv
         JCOMMttOjkv+zV4eXJF70uvcSohEb9ouQZ3o1IksE4HnCmO4/iYPTAI+vPpmMwIvYaLu
         2HBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YV/+iCS4EeSNAMRIOjIIW+INsj2i8EpPe81QUMDSEVs=;
        b=f+yV3VYT9MXpXddoSjc60lq9VG56IlcWq8zBbQotgHIzmgtNW0OuI+g38q63F494w7
         AnGHYRbYDE76O4jjmVcyFtAxiTlerCsQisJYglt4yBmT2vhAGfzDn8gRcctEsjMh9tl2
         FrwO8KelWCWt2Gfb46/wxSpVsc/DfMqzdl6GGQrEHoYVpUlnlq1MQ7KHLt3ANM7SXH4U
         GPbwg0NTzCOTbjfeuzi39y6BYseQx4P8zJGFtfQFEm2N1mnySjB66gvqEv9xGAoXUivA
         XYWh7rlaFu5lBxyezicjLIZ4qBns77GX18/RY9nNK64gePHWxW46JfeNs4QRLgOdVU5y
         BkBw==
X-Gm-Message-State: APjAAAX+dLyXeVHyChbojEFjM+dCVq2l7Ct9GfaFn9q33GXwR0D42mAL
        FqXpVBIPAGwtHDg8licISLS9wx2OVGA=
X-Google-Smtp-Source: APXvYqxrRdSbPTKzt4ly+c7dnzUq640ClO3tO2ssYDjVziJsbu2BmD86x8kgJ96v+75QQxPN6EIqig==
X-Received: by 2002:a62:ac1a:: with SMTP id v26mr40341590pfe.184.1564453938159;
        Mon, 29 Jul 2019 19:32:18 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id q24sm56689312pjp.14.2019.07.29.19.32.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 19:32:17 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     darrick.wong@oracle.com, bfoster@redhat.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2] fs: xfs: Fix possible null-pointer dereferences in xchk_da_btree_block_check_sibling()
Date:   Tue, 30 Jul 2019 10:32:06 +0800
Message-Id: <20190730023206.14587-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In xchk_da_btree_block_check_sibling(), there is an if statement on
line 274 to check whether ds->state->altpath.blk[level].bp is NULL:
    if (ds->state->altpath.blk[level].bp)

When ds->state->altpath.blk[level].bp is NULL, it is used on line 281:
    xfs_trans_brelse(..., ds->state->altpath.blk[level].bp);
        struct xfs_buf_log_item *bip = bp->b_log_item;
        ASSERT(bp->b_transp == tp);

Thus, possible null-pointer dereferences may occur.

To fix these bugs, ds->state->altpath.blk[level].bp is checked before
being used.

These bugs are found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
v2:
* Adjust the code and add an assignment. 
  Thank Darrick J. Wong for helpful advice. 

---
 fs/xfs/scrub/dabtree.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 94c4f1de1922..77ff9f97bcda 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -278,7 +278,11 @@ xchk_da_btree_block_check_sibling(
 	/* Compare upper level pointer to sibling pointer. */
 	if (ds->state->altpath.blk[level].blkno != sibling)
 		xchk_da_set_corrupt(ds, level);
-	xfs_trans_brelse(ds->dargs.trans, ds->state->altpath.blk[level].bp);
+	if (ds->state->altpath.blk[level].bp) {
+		xfs_trans_brelse(ds->dargs.trans,
+				ds->state->altpath.blk[level].bp);
+		ds->state->altpath.blk[level].bp = NULL;
+	}
 out:
 	return error;
 }
-- 
2.17.0

