Return-Path: <linux-xfs+bounces-257-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72FFA7FD03B
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 08:59:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4AEE1C20A19
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Nov 2023 07:59:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FC79111B9;
	Wed, 29 Nov 2023 07:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="U4fxZJjr"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5781735
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 23:59:46 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-53fa455cd94so4272763a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 23:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1701244786; x=1701849586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZGwa/klWYWx3gVbFO7UV3sjDmi0cMp8GGfC8jWdaqOs=;
        b=U4fxZJjrLknoM74F9M5SQZuwCbht/oZCeNcVFO/UDjyCFXMQKykI6sSpbuXLh8qpzS
         17GlZkRmkQguChrXSjd3Bs+dPa/n3ZZTsFlykxwXvMxQ9F/nu7QAsWbDLIdA1KiVV0TO
         KXKxM5xQ0uXs+2UGmvFvFP7ywILl9QWIRH1J4TVOXM4Z2Jbn9qMayUhlQIJ26B58yNeP
         JmAQTz8P4eTyEDtxOWrZd27YKWYjMqJkZhmtBcGBRwJo5faoBKYwJ0Sizh13q177vE+L
         W/72gQsZwBRSGbg0mmN5VRUp48zW/V+ZRhypeBeo9QrxDQvskk4xxBFXuAaBFD9lD/3R
         0y1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701244786; x=1701849586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZGwa/klWYWx3gVbFO7UV3sjDmi0cMp8GGfC8jWdaqOs=;
        b=PdrVJMnqx6UC2ptSVA2J7uxnJOLsWutOqgbfgPqIInsBbPBn5e35YGtxu5D2LsNopL
         VGEUVNdcZ/KpsxaafEs/uPFDpf+gkxXeJJ7375KlEy1t2ZX4iwIhY4wMlSkcWczgZBaU
         5OBLF/UaHVRpET+1eNNNa9NxJivDV4iUxqdx3qpIfSburH0kY/Yf2Sckk994TykjJRdc
         WMeA0RizWWTsF+aSyS+1af0+gWG43yhL/Yb+Y9tUOdFRpgajaO1M9troC+5mfBaD+/3t
         79m3hXopuURXOAfprWtQ1a/ideFERq+juyg3yzwcj6If2eWxZlkTR5+1j8qW08S4P8vV
         RTNQ==
X-Gm-Message-State: AOJu0YzGHbCawNcaUIg8Ucg9XfaPlQe0c66B4Z+WnbgkYVFxEYibSN8j
	MESQAx7qmDydxOshBoa0TgxOEA==
X-Google-Smtp-Source: AGHT+IEW7RY6rW1xN0SZYk2KmfKRhGALSQC7dhZKn7nt9rZPJDObYoCq4CCKaltza5Ttsehw10eh9Q==
X-Received: by 2002:a05:6a20:6a0e:b0:18b:8158:b115 with SMTP id p14-20020a056a206a0e00b0018b8158b115mr20395186pzk.56.1701244786219;
        Tue, 28 Nov 2023 23:59:46 -0800 (PST)
Received: from localhost.localdomain ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id s17-20020a170902989100b001cfd0ddc5d3sm4979419plp.277.2023.11.28.23.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 23:59:45 -0800 (PST)
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
	me@jcix.top,
	Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2 2/2] xfs: update dir3 leaf block metadata after swap
Date: Wed, 29 Nov 2023 15:58:32 +0800
Message-Id: <20231129075832.73600-3-zhangjiachen.jaycee@bytedance.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20231129075832.73600-1-zhangjiachen.jaycee@bytedance.com>
References: <20231129075832.73600-1-zhangjiachen.jaycee@bytedance.com>
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
 fs/xfs/libxfs/xfs_da_btree.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e576560b46e9..d11e6286e466 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2318,8 +2318,17 @@ xfs_da3_swap_lastblock(
 	 * Copy the last block into the dead buffer and log it.
 	 */
 	memcpy(dead_buf->b_addr, last_buf->b_addr, args->geo->blksize);
-	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
 	dead_info = dead_buf->b_addr;
+	/*
+	 * If xfs enable crc, the node/leaf block records its blkno, we
+	 * must update it.
+	 */
+	if (xfs_has_crc(mp)) {
+		struct xfs_da3_blkinfo *da3 = container_of(dead_info, struct xfs_da3_blkinfo, hdr);
+
+		da3->blkno = cpu_to_be64(xfs_buf_daddr(dead_buf));
+	}
+	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
 	/*
 	 * Get values from the moved block.
 	 */
-- 
2.20.1


