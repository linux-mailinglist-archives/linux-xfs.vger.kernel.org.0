Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF9D783A0
	for <lists+linux-xfs@lfdr.de>; Mon, 29 Jul 2019 05:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfG2DYJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 28 Jul 2019 23:24:09 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36846 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfG2DYI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Jul 2019 23:24:08 -0400
Received: by mail-pl1-f193.google.com with SMTP id k8so26937168plt.3;
        Sun, 28 Jul 2019 20:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=W41jAG4KiNjmizZVJeUZJe2SLzpaILG6fB/l012JzHM=;
        b=jhGpf7aqJSRK5XqIo9OP8vYKCI/tp9FJFj8hOiATqvKLsEFAdLHpqA4uf1H84yOHpM
         EKD/FcLj6fmnjKhXmmtKhygpizhBq2OBSDhMUBAXVoa4VTm+iLd0CvhZ6DPfok6K28V2
         XP4CvBkOtyR8PQoNr1gmtPW1Wqt6nLeSyBsMIEg8L6nZPzP17c/4zB1s3EolaQNh2bNz
         XFSWDVY/x68YPUbAHsPOOJ4ALL9d0qpE2Us4eEUaBwRXVahHv374ZD1AI338FQzoMkEK
         VEKs8wt4RpnC4MW+wHHTow04LDf3JgbMwobyYF+T96vZgJHihhX77RdWNglT4s6CORFH
         G9zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=W41jAG4KiNjmizZVJeUZJe2SLzpaILG6fB/l012JzHM=;
        b=kyhqo0nszuvoFXPNFif4eRB6TibRPX78STipnHQ6Pe7Iu5EN80gDtyMIOkBpc87sC6
         3MzxQA6hsPqT9H79TqW6P5f/0ZgbaVFCh5rlWGj224FwIh1AeGNZjTU6jzEijyPbGz0J
         4534XpkxleJ7mIWb6Znp5ptk2w0yXoZBKkjR79JJ6VzTECFczClLP35IE3EAJFqflbyg
         TzkqVuhPRZiBUe5fwBbxtmH6C6OO7+ueDNQiZ3N6J+K7o68DF/4mCyW8UA1UVCiBAh/j
         UnMmJ5EQjtP9zJzELMi69Sni5KdVVVluNyYTvVmwZWQFg0OCB5WSOIEtNyWYAB5113Fr
         pgUA==
X-Gm-Message-State: APjAAAWeQHSR4JiPSvyZH1qd6ko9Rtdp1m7iGA4NSDQRIf23h34YLvhT
        ysqxOPCjLY6IE0shifstum4=
X-Google-Smtp-Source: APXvYqyaD0/0WnHCMBEZbRL+veolIi46STfZZHwyJavWKFMbVB/zSJRZODMjhU1G+qfsjdclXwo/2Q==
X-Received: by 2002:a17:902:6a85:: with SMTP id n5mr100688378plk.73.1564370648141;
        Sun, 28 Jul 2019 20:24:08 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id t11sm67386761pgb.33.2019.07.28.20.24.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jul 2019 20:24:07 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     darrick.wong@oracle.com, bfoster@redhat.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] fs: xfs: Fix possible null-pointer dereferences in xchk_da_btree_block_check_sibling()
Date:   Mon, 29 Jul 2019 11:24:01 +0800
Message-Id: <20190729032401.28081-1-baijiaju1990@gmail.com>
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
        struct xfs_buf_log_item	*bip = bp->b_log_item;
        ASSERT(bp->b_transp == tp);

Thus, possible null-pointer dereferences may occur.

To fix these bugs, ds->state->altpath.blk[level].bp is checked before
being used.

These bugs are found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 fs/xfs/scrub/dabtree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 94c4f1de1922..33ff90c0dd70 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -278,7 +278,9 @@ xchk_da_btree_block_check_sibling(
 	/* Compare upper level pointer to sibling pointer. */
 	if (ds->state->altpath.blk[level].blkno != sibling)
 		xchk_da_set_corrupt(ds, level);
-	xfs_trans_brelse(ds->dargs.trans, ds->state->altpath.blk[level].bp);
+	if (ds->state->altpath.blk[level].bp)
+		xfs_trans_brelse(ds->dargs.trans, 
+						ds->state->altpath.blk[level].bp);
 out:
 	return error;
 }
-- 
2.17.0

