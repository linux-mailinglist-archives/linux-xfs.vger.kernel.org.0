Return-Path: <linux-xfs+bounces-160-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0909F7FB14B
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 06:34:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8CE5FB20FA9
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 05:34:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31DF10793;
	Tue, 28 Nov 2023 05:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="MFB9k4mW"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B751DB
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 21:34:38 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1cf8b35a6dbso37203755ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 21:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1701149678; x=1701754478; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PRqsnYQ6nV0dzX6Vx06lKgWxOV6XUUCzggjpXFerXKM=;
        b=MFB9k4mWSQv3i3ltZ0GgzWfKQZHjbG9ZrBpeRijLSZKtffqDCMVd6PdK7C+H1xnYy+
         mnYSd+ZaOyp6QARthaZGS0BkKDx3o7r6Tfbeimc2eFcwfZuPHI6d0GrY+diF9bNpbpMU
         2/pGMPwuo939+BVPZmXf/hs9BjQTTxIPrdz+nQYcaahJNps7l2ZyjW3utV063M70zPlG
         J/1s5dUkecy9SzsvacUlkrHghiH+Mk7gO5NEqSISQYl5czkOfdtuHs3ln1n3GTm83ZlH
         QljufujAVvTWjlgoIa1njlTrdgi9XVT3Y65bvOqHKMWkXznfk452ZVzRozr3AOeBJR49
         MqAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701149678; x=1701754478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PRqsnYQ6nV0dzX6Vx06lKgWxOV6XUUCzggjpXFerXKM=;
        b=YBLmP8h9/epXcQgQoUIk0TsdSSuVgK0kl1aOFFD61lPcmuiXyomOJUu/vPlH7wltYJ
         A7bXL3I7rpme8RFQ2SqocvOnpyTlBjcvtOK8s6FoUAQvFn6lKF1JAqLdncJWnDOOrHpH
         O/jERvwfN0PnVko1608L9g2EkFG2Zs3TxnSOKRT8RsREIagEPVOfORt607MWWqVRMKaK
         UDK4er3EZ9LR8iHbdwQ1w5z+L3x8RnWDKa6jiU83WFlIsbZqH+Gg96ud4Ky86s80qeiI
         h6d9iPTLw17PHMSphf3Nrs5W9EPs5jz84hd38YvH09zKuJtGRjzmjC0KzE3RzC1WJ6Lq
         mTVg==
X-Gm-Message-State: AOJu0Yz98rBjis8V6h6PifWnVbctrH+lI/w2ymno86Pmd3TeWkwXCOeY
	LdSNS9ZEAgXZuySzLt70tKUHWA==
X-Google-Smtp-Source: AGHT+IH37Q4CIY9yDngnFDzZ+uMbMeUPiDKo4jJ4WzEz18Oqecw9exdZNMZEPAqlBiYZRr4RurxfqQ==
X-Received: by 2002:a17:903:183:b0:1ca:a290:4c0c with SMTP id z3-20020a170903018300b001caa2904c0cmr16142204plg.16.1701149678085;
        Mon, 27 Nov 2023 21:34:38 -0800 (PST)
Received: from localhost.localdomain ([61.213.176.14])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090341cc00b001cfb6bef8fesm5372899ple.186.2023.11.27.21.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 21:34:37 -0800 (PST)
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>,
	Ben Myers <bpm@sgi.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xieyongji@bytedance.com,
	me@jcix.top
Subject: [PATCH 2/2] xfs: update dir3 leaf block metadata after swap
Date: Tue, 28 Nov 2023 13:32:02 +0800
Message-Id: <20231128053202.29007-3-zhangjiachen.jaycee@bytedance.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20231128053202.29007-1-zhangjiachen.jaycee@bytedance.com>
References: <20231128053202.29007-1-zhangjiachen.jaycee@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

xfs_da3_swap_lastblock() copy the last block content to the dead block,
but do not update the metadata in it. We need update some metadata
for some kinds of type block, such as dir3 leafn block records its
blkno, we shall update it to the dead block blkno. Otherwise,
before write the xfs_buf to disk, the verify_write() will fail in
blk_hdr->blkno != xfs_buf->b_bn, then xfs will be shutdown.

We will get this warning:

  XFS (dm-0): Metadata corruption detected at xfs_dir3_leaf_verify+0xa8/0xe0 [xfs], xfs_dir3_leafn block 0x178
  XFS (dm-0): Unmount and run xfs_repair
  XFS (dm-0): First 128 bytes of corrupted metadata buffer:
  00000000e80f1917: 00 80 00 0b 00 80 00 07 3d ff 00 00 00 00 00 00  ........=.......
  000000009604c005: 00 00 00 00 00 00 01 a0 00 00 00 00 00 00 00 00  ................
  000000006b6fb2bf: e4 44 e3 97 b5 64 44 41 8b 84 60 0e 50 43 d9 bf  .D...dDA..`.PC..
  00000000678978a2: 00 00 00 00 00 00 00 83 01 73 00 93 00 00 00 00  .........s......
  00000000b28b247c: 99 29 1d 38 00 00 00 00 99 29 1d 40 00 00 00 00  .).8.....).@....
  000000002b2a662c: 99 29 1d 48 00 00 00 00 99 49 11 00 00 00 00 00  .).H.....I......
  00000000ea2ffbb8: 99 49 11 08 00 00 45 25 99 49 11 10 00 00 48 fe  .I....E%.I....H.
  0000000069e86440: 99 49 11 18 00 00 4c 6b 99 49 11 20 00 00 4d 97  .I....Lk.I. ..M.
  XFS (dm-0): xfs_do_force_shutdown(0x8) called from line 1423 of file fs/xfs/xfs_buf.c.  Return address = 00000000c0ff63c1
  XFS (dm-0): Corruption of in-memory data detected.  Shutting down filesystem
  XFS (dm-0): Please umount the filesystem and rectify the problem(s)

From the log above, we know xfs_buf->b_no is 0x178, but the block's hdr record
its blkno is 0x1a0.

Fixes: 24df33b45ecf ("xfs: add CRC checking to dir2 leaf blocks")
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e576560b46e9..35f70e4c6447 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2318,8 +2318,18 @@ xfs_da3_swap_lastblock(
 	 * Copy the last block into the dead buffer and log it.
 	 */
 	memcpy(dead_buf->b_addr, last_buf->b_addr, args->geo->blksize);
-	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
 	dead_info = dead_buf->b_addr;
+	/*
+	 * Update the moved block's blkno if it's a dir3 leaf block
+	 */
+	if (dead_info->magic == cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) ||
+	    dead_info->magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC) ||
+	    dead_info->magic == cpu_to_be16(XFS_ATTR3_LEAF_MAGIC)) {
+		struct xfs_da3_blkinfo *dap = (struct xfs_da3_blkinfo *)dead_info;
+
+		dap->blkno = cpu_to_be64(dead_buf->b_bn);
+	}
+	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
 	/*
 	 * Get values from the moved block.
 	 */
-- 
2.20.1


