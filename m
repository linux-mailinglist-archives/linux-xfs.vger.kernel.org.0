Return-Path: <linux-xfs+bounces-453-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39DCA80499D
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Dec 2023 06:59:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8F5F2815FB
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Dec 2023 05:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06207D51D;
	Tue,  5 Dec 2023 05:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="k1Kgw8/Q"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8601C111
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 21:59:31 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1d0c94397c0so322285ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 04 Dec 2023 21:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1701755971; x=1702360771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nyBGwSV+iJralP4K3/kIwnYMScArE6+I+gopISjyQyw=;
        b=k1Kgw8/QWCUAslUlV7mcNpAZr7OUCSZFq7SoHbXtdnLEWCK5OKFcNE09qlygP6FQfl
         UXnF2zOo/eubNgQZZcmMSj86yCiSop7ly/J4z+0OgT+T4ItvDTmx9pYCxo3mCu0fUair
         xfQcYRuMlwVo9YrT8rXxIQDT4pNpEG/x7GNQjww+hUvruJpkmw1SJJIeOE25WtdaiN3I
         m3SopzffE5a3cyknxyeW96lLYIyS9AUpbfZ6dELlF1ruUAv1+O0sHeR3OBIeLbR8koVU
         DVVMC0JDeoQteG0XBptSIo132Ig2rEAZ70Es3LqvBiNP3nkrIRddOmW4Dud+jyS8InMg
         BIYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701755971; x=1702360771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nyBGwSV+iJralP4K3/kIwnYMScArE6+I+gopISjyQyw=;
        b=XN3na3g82xo1OfbO3gTP4x1nzfWRi6IixkFIjCISOnq9AoEW/MbserJAbM+d2n+yBs
         dyzvqrIbSOkSzo8Z2pwEZlh31l97jS04/fRl1bawDW/j/j4l8OCyf5NNiswSrhZjUa0Y
         YPKWtzezYnpxRZs2j1S45YNP9tI/O2yIvMlarBy0oWBhYsIHMFhaEJRl7Fp/+dWJECHT
         T+OK2sXACpjWcbyhAWqGBHhjVKl7WtVFzeW9F0t2PEWIoLNlTLk3cQbhuu7dU9RLj4fF
         97kL8A9l4suDakWeNcWFg/3AbcWddwGiWyDzT3qG6kMVHBznQjwCXb178LCwrL1fgnh1
         mkwQ==
X-Gm-Message-State: AOJu0Yy3KEhjYTkjykdAQGwsXpsTdRcVu5MjoTdZNuj/yUXvnSpdENSI
	gkZtQW7pvEL/TURCD0ONRK7pfQ==
X-Google-Smtp-Source: AGHT+IE35oBHBjUxHb/fsvXUD7EoK8AoO8qb0p8T7qrANTR8Tdfrb7T2eq08xEU/xupFItC8DTcn3Q==
X-Received: by 2002:a17:903:1207:b0:1ce:5f67:cfd3 with SMTP id l7-20020a170903120700b001ce5f67cfd3mr2605429plh.18.1701755970999;
        Mon, 04 Dec 2023 21:59:30 -0800 (PST)
Received: from localhost.localdomain ([61.213.176.5])
        by smtp.gmail.com with ESMTPSA id jb7-20020a170903258700b001d05bb77b43sm7111605plb.19.2023.12.04.21.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 21:59:30 -0800 (PST)
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xieyongji@bytedance.com,
	me@jcix.top,
	Dave Chinner <david@fromorbit.com>
Subject: [PATCH v4 2/3] xfs: update dir3 leaf block metadata after swap
Date: Tue,  5 Dec 2023 13:58:59 +0800
Message-Id: <20231205055900.62855-3-zhangjiachen.jaycee@bytedance.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20231205055900.62855-1-zhangjiachen.jaycee@bytedance.com>
References: <20231205055900.62855-1-zhangjiachen.jaycee@bytedance.com>
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
Suggested-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e576560b46e9..282c7cf032f4 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2316,10 +2316,17 @@ xfs_da3_swap_lastblock(
 		return error;
 	/*
 	 * Copy the last block into the dead buffer and log it.
+	 * On CRC-enabled file systems, also update the stamped in blkno.
 	 */
 	memcpy(dead_buf->b_addr, last_buf->b_addr, args->geo->blksize);
+	if (xfs_has_crc(mp)) {
+		struct xfs_da3_blkinfo *da3 = dead_buf->b_addr;
+
+		da3->blkno = cpu_to_be64(xfs_buf_daddr(dead_buf));
+	}
 	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
 	dead_info = dead_buf->b_addr;
+
 	/*
 	 * Get values from the moved block.
 	 */
-- 
2.20.1


