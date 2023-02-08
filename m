Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5AF68F61B
	for <lists+linux-xfs@lfdr.de>; Wed,  8 Feb 2023 18:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjBHRwp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 8 Feb 2023 12:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjBHRwo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 12:52:44 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9383B59E2
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 09:52:43 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id bx22so16241818pjb.3
        for <linux-xfs@vger.kernel.org>; Wed, 08 Feb 2023 09:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q8Kt5e9eFuHaUHQVJUsJnYzgwinUdun/p02DUjewDYY=;
        b=PvUN/+43lsNdWDWHu8Mh8CEEmvKra7e8Kj0aMxHpHwev3HHOW4b7eOinGzbMCrwtp0
         7mcVJU3Aw7TgfnrVq8v5bTTF8ZoxsIk0GnsnPkbpoL+Rr/ca9879P/TcfPKvb9ZeAWNJ
         QuJMpgRI0THznTfcJVyrana/Gd058xawJqd9cxIDQzbqnCPeAR/7H3pDmjyZBklvfjh9
         TD+7G+bNphkgGxuiVQo7bFviRNVf+flcw4+w9TxZg8QgpHRbCnhzxcGZOVLOshbqsWzF
         XCFTCi+j1v+fFanytaAzg9KFXyQ65xCCY0Drz8OQJKI7a9LRXAF8YZkCzr+j0r+o5Iti
         0dAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q8Kt5e9eFuHaUHQVJUsJnYzgwinUdun/p02DUjewDYY=;
        b=WWu4i5Wkbg/Df335Ct1BBnUZ/oNSyK0CktzAeF3JZLMDX+WFE6vRUXKYioc3/IHeow
         y59JbAhZExPzyNeOFbMDYWaiyuX6daFHldGdgMso1U1ls4CDTMJt8wUPYZ8g/nWL4+v5
         GxiL4gK5iexG1NGW98mOaXRg/E2uPnHbr++KazzXuhgZwv9uOZhfu55tBuWzNI+eY6XA
         0CKCIkZb8NEXkY17OQBFqItwDBgW/KwRzXY037KoTDqJwohUWKuGleikHvQFqkD4zUay
         QDoYLVNbvLrOmEsNpMjZ/BIz60ozU/mvkwWLp/ZmjZiAb2DA10YGT6bkX+/7eSWx8fBU
         vc7A==
X-Gm-Message-State: AO0yUKWn3RYa/jg7aK+IysBo0WkwsninZrRYYVUVVRwlR4EXugUEOQ5G
        OREJIjEuJ+nC9JMaoPQtqN42Sm2HXk/VNA==
X-Google-Smtp-Source: AK7set8f7A+ZlPJdf/3aC2O9dXmbfty0gPqN5pBfSoFRmsXSfZk4bKvBIyxv1bVrqUb6NDCKu7HeLQ==
X-Received: by 2002:a17:902:ca0b:b0:194:d4e5:5e5c with SMTP id w11-20020a170902ca0b00b00194d4e55e5cmr1985590pld.37.1675878762843;
        Wed, 08 Feb 2023 09:52:42 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:726:5e6d:fcde:4245])
        by smtp.gmail.com with ESMTPSA id y17-20020a170902d65100b00198e397994bsm10911452plh.136.2023.02.08.09.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 09:52:42 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 03/10] xfs: detect self referencing btree sibling pointers
Date:   Wed,  8 Feb 2023 09:52:21 -0800
Message-Id: <20230208175228.2226263-4-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230208175228.2226263-1-leah.rumancik@gmail.com>
References: <20230208175228.2226263-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit dc04db2aa7c9307e740d6d0e173085301c173b1a ]

To catch the obvious graph cycle problem and hence potential endless
looping.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_btree.c | 140 ++++++++++++++++++++++++++++----------
 1 file changed, 105 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 298395481713..5bec048343b0 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -51,6 +51,52 @@ xfs_btree_magic(
 	return magic;
 }
 
+static xfs_failaddr_t
+xfs_btree_check_lblock_siblings(
+	struct xfs_mount	*mp,
+	struct xfs_btree_cur	*cur,
+	int			level,
+	xfs_fsblock_t		fsb,
+	xfs_fsblock_t		sibling)
+{
+	if (sibling == NULLFSBLOCK)
+		return NULL;
+	if (sibling == fsb)
+		return __this_address;
+	if (level >= 0) {
+		if (!xfs_btree_check_lptr(cur, sibling, level + 1))
+			return __this_address;
+	} else {
+		if (!xfs_verify_fsbno(mp, sibling))
+			return __this_address;
+	}
+
+	return NULL;
+}
+
+static xfs_failaddr_t
+xfs_btree_check_sblock_siblings(
+	struct xfs_mount	*mp,
+	struct xfs_btree_cur	*cur,
+	int			level,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_agblock_t		sibling)
+{
+	if (sibling == NULLAGBLOCK)
+		return NULL;
+	if (sibling == agbno)
+		return __this_address;
+	if (level >= 0) {
+		if (!xfs_btree_check_sptr(cur, sibling, level + 1))
+			return __this_address;
+	} else {
+		if (!xfs_verify_agbno(mp, agno, sibling))
+			return __this_address;
+	}
+	return NULL;
+}
+
 /*
  * Check a long btree block header.  Return the address of the failing check,
  * or NULL if everything is ok.
@@ -65,6 +111,8 @@ __xfs_btree_check_lblock(
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_btnum_t		btnum = cur->bc_btnum;
 	int			crc = xfs_has_crc(mp);
+	xfs_failaddr_t		fa;
+	xfs_fsblock_t		fsb = NULLFSBLOCK;
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -83,16 +131,16 @@ __xfs_btree_check_lblock(
 	if (be16_to_cpu(block->bb_numrecs) >
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
-	if (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
-	    !xfs_btree_check_lptr(cur, be64_to_cpu(block->bb_u.l.bb_leftsib),
-			level + 1))
-		return __this_address;
-	if (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
-	    !xfs_btree_check_lptr(cur, be64_to_cpu(block->bb_u.l.bb_rightsib),
-			level + 1))
-		return __this_address;
 
-	return NULL;
+	if (bp)
+		fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
+
+	fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
+			be64_to_cpu(block->bb_u.l.bb_leftsib));
+	if (!fa)
+		fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
+				be64_to_cpu(block->bb_u.l.bb_rightsib));
+	return fa;
 }
 
 /* Check a long btree block header. */
@@ -130,6 +178,9 @@ __xfs_btree_check_sblock(
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_btnum_t		btnum = cur->bc_btnum;
 	int			crc = xfs_has_crc(mp);
+	xfs_failaddr_t		fa;
+	xfs_agblock_t		agbno = NULLAGBLOCK;
+	xfs_agnumber_t		agno = NULLAGNUMBER;
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -146,16 +197,18 @@ __xfs_btree_check_sblock(
 	if (be16_to_cpu(block->bb_numrecs) >
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
-	if (block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_btree_check_sptr(cur, be32_to_cpu(block->bb_u.s.bb_leftsib),
-			level + 1))
-		return __this_address;
-	if (block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_btree_check_sptr(cur, be32_to_cpu(block->bb_u.s.bb_rightsib),
-			level + 1))
-		return __this_address;
 
-	return NULL;
+	if (bp) {
+		agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
+		agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
+	}
+
+	fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno, agbno,
+			be32_to_cpu(block->bb_u.s.bb_leftsib));
+	if (!fa)
+		fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno,
+				 agbno, be32_to_cpu(block->bb_u.s.bb_rightsib));
+	return fa;
 }
 
 /* Check a short btree block header. */
@@ -4265,6 +4318,21 @@ xfs_btree_visit_block(
 	if (xfs_btree_ptr_is_null(cur, &rptr))
 		return -ENOENT;
 
+	/*
+	 * We only visit blocks once in this walk, so we have to avoid the
+	 * internal xfs_btree_lookup_get_block() optimisation where it will
+	 * return the same block without checking if the right sibling points
+	 * back to us and creates a cyclic reference in the btree.
+	 */
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		if (be64_to_cpu(rptr.l) == XFS_DADDR_TO_FSB(cur->bc_mp,
+							xfs_buf_daddr(bp)))
+			return -EFSCORRUPTED;
+	} else {
+		if (be32_to_cpu(rptr.s) == xfs_daddr_to_agbno(cur->bc_mp,
+							xfs_buf_daddr(bp)))
+			return -EFSCORRUPTED;
+	}
 	return xfs_btree_lookup_get_block(cur, level, &rptr, &block);
 }
 
@@ -4439,20 +4507,21 @@ xfs_btree_lblock_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	xfs_fsblock_t		fsb;
+	xfs_failaddr_t		fa;
 
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
 		return __this_address;
 
 	/* sibling pointer verification */
-	if (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
-	    !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_leftsib)))
-		return __this_address;
-	if (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
-	    !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_rightsib)))
-		return __this_address;
-
-	return NULL;
+	fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
+	fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
+			be64_to_cpu(block->bb_u.l.bb_leftsib));
+	if (!fa)
+		fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
+				be64_to_cpu(block->bb_u.l.bb_rightsib));
+	return fa;
 }
 
 /**
@@ -4493,7 +4562,9 @@ xfs_btree_sblock_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-	xfs_agblock_t		agno;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	xfs_failaddr_t		fa;
 
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
@@ -4501,14 +4572,13 @@ xfs_btree_sblock_verify(
 
 	/* sibling pointer verification */
 	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
-	if (block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_verify_agbno(mp, agno, be32_to_cpu(block->bb_u.s.bb_leftsib)))
-		return __this_address;
-	if (block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_verify_agbno(mp, agno, be32_to_cpu(block->bb_u.s.bb_rightsib)))
-		return __this_address;
-
-	return NULL;
+	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
+	fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
+			be32_to_cpu(block->bb_u.s.bb_leftsib));
+	if (!fa)
+		fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
+				be32_to_cpu(block->bb_u.s.bb_rightsib));
+	return fa;
 }
 
 /*
-- 
2.39.1.519.gcb327c4b5f-goog

