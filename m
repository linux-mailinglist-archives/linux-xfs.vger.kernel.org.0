Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9F126DA70
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 13:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgIQLjH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 07:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgIQLi6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 07:38:58 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B5BC06174A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 04:38:58 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f18so1030599pfa.10
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 04:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z9Z6ZLCA0t50O/FUHRry5+oFSnlJ3mf6I4oqL/odMzs=;
        b=aiGi27LABfn8zl995QHdquf3jPGudFKyOoRZvHglYCrgC4nf4oar7g7FfRRBSL4kfS
         bVRzICcoqxQHcVEtDA+Yy+ENyEZoZpo4cTc5EjWDwW6JYHCjTsKlhpr5RZb3kb20tlGC
         hqg7HtBI8eVprHJ9q9Rmp/pqFo4w/ad4LVk+8gv0FgP2czhLtiovLyKnC/vk5yUBi4TV
         A+sAU2pIpR9dyo6OdgMnA8Nx9ShkVx3o7F896mWGm2Y69gM+pi8PBIpRU07sAxSIR2iF
         6zcf613xLE6pjkXiec1tUqIb+QUcwD48hb/TyjFm8c+hsd8cNdsum5RnAKEYz5VxUjjb
         NBGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z9Z6ZLCA0t50O/FUHRry5+oFSnlJ3mf6I4oqL/odMzs=;
        b=UV4IjwdlC/vurBlxlptbB380G80uvU0RUgrLonBtSftvyNtr6fw5P84rMQrLOeKXD8
         OVuiX1BeFkoeOFgUxqwMhARyHRN4Tj7y6GxD1a6hNSqFIA/ltr12WFdG6sjqMm3UPNBI
         piMu2ATQj/fUhfJywSRU+WVGmU0SRS0p5esntZj46RkLMWq+6ZT5jTWGmvDUeEr9zEei
         mRN8E2w6ThoyqosaCMGbRbwvH6Kwffw+dTeDVJhqKobqP3wvdc5gRfw+39z97ckuDwZy
         Oywq3scQEc6ig555nyTJyxK1ZOKeeH+3tq66T6eNaVVkg1tw7wr2FLSl3DagPwjgJ/fV
         uWuA==
X-Gm-Message-State: AOAM530f8aajQOsyZ/0eaQT3kHBeGgeOVETTcnCWKku1ARUpu4Z1HsE4
        x4v+8gl9qddswEj2N6dQCvWqgyFcmQ==
X-Google-Smtp-Source: ABdhPJxqeV85ElwToRBtEa5h6fF2eBES6iasfypQLR+wqzCPQvogEYJZvS2d4ogKB9hOanad9fROJA==
X-Received: by 2002:a63:1a66:: with SMTP id a38mr21779415pgm.253.1600342737422;
        Thu, 17 Sep 2020 04:38:57 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id 64sm18761147pgi.90.2020.09.17.04.38.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 04:38:56 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v2 3/7] xfs: remove the unnecessary xfs_dqid_t type cast
Date:   Thu, 17 Sep 2020 19:38:44 +0800
Message-Id: <1600342728-21149-4-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
References: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Since the type prid_t and xfs_dqid_t both are uint32_t, seems the
type cast is unnecessary, so remove it.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 3f82e0c92c2d..41a459ffd1f2 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1715,7 +1715,7 @@ xfs_qm_vop_dqalloc(
 	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
 		if (ip->i_d.di_projid != prid) {
 			xfs_iunlock(ip, lockflags);
-			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid,
+			error = xfs_qm_dqget(mp, prid,
 					XFS_DQTYPE_PROJ, true, &pq);
 			if (error) {
 				ASSERT(error != -ENOENT);
-- 
2.20.0

