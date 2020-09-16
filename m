Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45A726CB3A
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Sep 2020 22:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgIPUYg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Sep 2020 16:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbgIPR2V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 13:28:21 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892BBC061D73
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:21 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id c3so3016241plz.5
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 04:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=25Qu3x5lzGSDyBIq5GIBobnE3XDXys+vqFJvr83nC/Y=;
        b=MJQfyHa8zFxPqcCd7MySKEsGwWl+FGbtiE/nemBk2wEyHgNChQRe/ujlfcH9p3dEty
         XKbfjgTgUgYN3mF549f9jV7ob5FoQ9tx06HroT0Wy7Htnxkf/GV/kb9j+g2KS9NV4o7h
         gUx038U7dHOl0zCLUlPgCS/Knoo/gJm6FTcK4s1SETO+NXiulA+lZshxaIDcUp56/Jkq
         fBhfVNetJg6NS89mCuzgjOoonEc/6S7yk5PzD0aql9FPPz8iQBIE0bFXl19PJdjyyY6R
         0t1KaJeMAfj4Z1doQgiWXAZRd1mtuQws2PRCr7nC6XLsmmGjXx0liQMempL0esa+H4Iy
         h5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=25Qu3x5lzGSDyBIq5GIBobnE3XDXys+vqFJvr83nC/Y=;
        b=Gz+GF+YcXpdzEMfV5VQ8vvVRq1REYeN4EKrARN8spGvl350kelM7ngB3DSEEIs3/Re
         tnhWZlD8lSaUewIphJgew2s3JcL64XKyZULBwOiVzj11NPN/zfDguZnfwjG6xdh21n1f
         8BP4H4G5eQGMChCEiad11TngjpxpcXNcZ+k6asxfAlSlWAhGUeScB1ERnRhkzOAZ3YHO
         mFSSdMvqCf2bw2rqstw7m3FvOGQ2efT1oNReBnQUi3I4P+CSm/K/q0at0k37JAr5omCu
         DHV1k96SOX7dmRTlXF+3gMIplrv9+W1T5UuZcp18kIn0glaxPsqBZyelDbKmdjTroUW2
         R6VQ==
X-Gm-Message-State: AOAM533CkcWfeZM3cVRkun2dawF2qGRP2F3l38q6pauC8c4UJ2aNo519
        Dm38EW1MKtSNYY2Yz+Z8oeCgDZ8wvg==
X-Google-Smtp-Source: ABdhPJzUnzSMnPkLCGhBE/2jWdkOE5JuPz4/3qLoV9r3FHXX6+FZE61F37npYGMvAd04wyEDlHvN0Q==
X-Received: by 2002:a17:902:758b:b029:d1:bb0f:25fc with SMTP id j11-20020a170902758bb02900d1bb0f25fcmr19632300pll.40.1600255160677;
        Wed, 16 Sep 2020 04:19:20 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id v204sm3492195pfc.10.2020.09.16.04.19.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Sep 2020 04:19:20 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: use the existing type definition for di_projid
Date:   Wed, 16 Sep 2020 19:19:05 +0800
Message-Id: <1600255152-16086-3-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

We have already defined the project ID type prid_t, so maybe should
use it here.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/libxfs/xfs_inode_buf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 536666143fe7..ef5eaf33d146 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -17,7 +17,7 @@ struct xfs_dinode;
  */
 struct xfs_icdinode {
 	uint16_t	di_flushiter;	/* incremented on flush */
-	uint32_t	di_projid;	/* owner's project id */
+	prid_t		di_projid;	/* owner's project id */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-- 
2.20.0

