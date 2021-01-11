Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317232F147B
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Jan 2021 14:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbhAKNZX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 11 Jan 2021 08:25:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59849 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731175AbhAKNZT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 08:25:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610371432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ojFT1PhIb+FaXuvRr1SxUCplyTRyIPBcMEzZQECx4RA=;
        b=gPM11U2O4d6Yy0fCeNgCJODTM9v1mUjH4rY32cxPglj34GeEXl9fcKCBCgLTQWw5Rvbsd+
        0rP32dmHFM/Ex64Ld6UuZSONgZCPHDJgDB+Jx+TwMGTImSSL6knWkpwfFgLhfk2o7hLhl0
        RHt+K7vypjG1f3EtJYEKgffPPFjtxe8=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-DKuOiozQNgGUeVYlDAHCBQ-1; Mon, 11 Jan 2021 08:23:50 -0500
X-MC-Unique: DKuOiozQNgGUeVYlDAHCBQ-1
Received: by mail-pl1-f200.google.com with SMTP id d6so9256117plr.17
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jan 2021 05:23:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ojFT1PhIb+FaXuvRr1SxUCplyTRyIPBcMEzZQECx4RA=;
        b=B94dj6KJ486UkALRmukamh1hhR/zDRvnW0ZuquWB1jW3psgCWhsPvXE/3ufis54w0j
         z7JNRusDIxW1/D+xj3DQQvlYdlQbCPqTI4Bq1Hey/+pZolvNq1RdNGagXURIVJtbETuo
         BND5natjqd8bHC57ZWuBj0nbnVrUObiGxz26XjKxRvaPDtow4TgQQx9z6u3DnVsunHk6
         3PBlndERvr0weDSWEA4T7wjd50/jI0P98tUhgEo6ATv5raoJh5D729mE6AX7fkqQsigg
         bf+o2QEQ1WDYO+N1y4wmV+NAH9e8tpRQDwOgMRtkig2Ruh2jpI/S/oM8T0rx2f9KNnk8
         iqEA==
X-Gm-Message-State: AOAM533wfLEt4mfxTxW0W3J45J3/V/vxj4QhobrGFYOVwX2PPBQQOXet
        /ixU90sZE7xrKp5nTITjgHboRQA+64Q09Ke/UlDAuKjTXMnBZiVDBVzWjTOPUGKHnPBRWyY3lOK
        H2zARCx5QuHfsifQmFwYao0d2k6PkeXTRLEV+wCZGTVrfT+Q6EB+dlDlo36cf3euOgUrKrQLv+A
        ==
X-Received: by 2002:a63:c04b:: with SMTP id z11mr19643848pgi.74.1610371429579;
        Mon, 11 Jan 2021 05:23:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy7XpcWgCBKOxnyzGsat5U6mLCasKLTpKO+XORTstuMeYo7+ylDSMQ58R5NTStPRjmhvBH+jQ==
X-Received: by 2002:a63:c04b:: with SMTP id z11mr19643822pgi.74.1610371429267;
        Mon, 11 Jan 2021 05:23:49 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id cu4sm16179355pjb.18.2021.01.11.05.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 05:23:48 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 3/4] xfs: hoist out xfs_resizefs_init_new_ags()
Date:   Mon, 11 Jan 2021 21:22:42 +0800
Message-Id: <20210111132243.1180013-4-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210111132243.1180013-1-hsiangkao@redhat.com>
References: <20210111132243.1180013-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move out related logic for initializing new added AGs to a new helper
in preparation for shrinking. No logic changes.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_fsops.c | 74 +++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 0bc9c5ebd199..8fde7a2989ce 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -20,6 +20,49 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 
+static int
+xfs_resizefs_init_new_ags(
+	xfs_mount_t		*mp,
+	struct aghdr_init_data	*id,
+	xfs_agnumber_t		oagcount,
+	xfs_agnumber_t		nagcount,
+	xfs_rfsblock_t		*delta)
+{
+	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + *delta;
+	int			error;
+
+	/*
+	 * Write new AG headers to disk. Non-transactional, but need to be
+	 * written and completed prior to the growfs transaction being logged.
+	 * To do this, we use a delayed write buffer list and wait for
+	 * submission and IO completion of the list as a whole. This allows the
+	 * IO subsystem to merge all the AG headers in a single AG into a single
+	 * IO and hide most of the latency of the IO from us.
+	 *
+	 * This also means that if we get an error whilst building the buffer
+	 * list to write, we can cancel the entire list without having written
+	 * anything.
+	 */
+	INIT_LIST_HEAD(&id->buffer_list);
+	for (id->agno = nagcount - 1;
+	     id->agno >= oagcount;
+	     id->agno--, *delta -= id->agsize) {
+
+		if (id->agno == nagcount - 1)
+			id->agsize = nb - (id->agno *
+					(xfs_rfsblock_t)mp->m_sb.sb_agblocks);
+		else
+			id->agsize = mp->m_sb.sb_agblocks;
+
+		error = xfs_ag_init_headers(mp, id);
+		if (error) {
+			xfs_buf_delwri_cancel(&id->buffer_list);
+			return error;
+		}
+	}
+	return xfs_buf_delwri_submit(&id->buffer_list);
+}
+
 /*
  * growfs operations
  */
@@ -74,36 +117,7 @@ xfs_growfs_data_private(
 	if (error)
 		return error;
 
-	/*
-	 * Write new AG headers to disk. Non-transactional, but need to be
-	 * written and completed prior to the growfs transaction being logged.
-	 * To do this, we use a delayed write buffer list and wait for
-	 * submission and IO completion of the list as a whole. This allows the
-	 * IO subsystem to merge all the AG headers in a single AG into a single
-	 * IO and hide most of the latency of the IO from us.
-	 *
-	 * This also means that if we get an error whilst building the buffer
-	 * list to write, we can cancel the entire list without having written
-	 * anything.
-	 */
-	INIT_LIST_HEAD(&id.buffer_list);
-	for (id.agno = nagcount - 1;
-	     id.agno >= oagcount;
-	     id.agno--, delta -= id.agsize) {
-
-		if (id.agno == nagcount - 1)
-			id.agsize = nb -
-				(id.agno * (xfs_rfsblock_t)mp->m_sb.sb_agblocks);
-		else
-			id.agsize = mp->m_sb.sb_agblocks;
-
-		error = xfs_ag_init_headers(mp, &id);
-		if (error) {
-			xfs_buf_delwri_cancel(&id.buffer_list);
-			goto out_trans_cancel;
-		}
-	}
-	error = xfs_buf_delwri_submit(&id.buffer_list);
+	error = xfs_resizefs_init_new_ags(mp, &id, oagcount, nagcount, &delta);
 	if (error)
 		goto out_trans_cancel;
 
-- 
2.27.0

