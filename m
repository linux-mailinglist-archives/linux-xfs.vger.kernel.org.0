Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDCD2A48F0
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Nov 2020 16:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgKCPHf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 3 Nov 2020 10:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728217AbgKCPHd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 10:07:33 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6E6C0613D1
        for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2020 07:07:32 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 72so7735982pfv.7
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2020 07:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mzo4XKFqwetL4wgqWPphqhx1Obl5kc6g2AJMDkW2Wts=;
        b=smn2nRI4aLt6vLXvPFIP57Lau6v/MzGK96efkq2CZxlcPiFpQpHVuGxqqBPIZUi7zm
         h+hOY5GCOORwgr27WqVww1gdvOjCQqx1yyeUUurQW4FKQ5g8hxSyLmxQfdbVdl+4uDST
         /B+HxGM/+EIDnhX9r+T/TOZULbsl0nTJ/lVZCvxuR+jWUuJ+LqGaOlRJKN+nDdFI0uco
         ap7Z8szJFUQQIu+Jzi3cvs5HD+fXJflo+ucarFXy+lMQM0cvztinqohPdZ33z5a7oNSr
         7JXfTZnce4EC4M7YwCkOWiKs8JwxeYDf/DzpO4dzI+/FgBKjsqh7wSJFnKtYQuP/uMFF
         eUqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mzo4XKFqwetL4wgqWPphqhx1Obl5kc6g2AJMDkW2Wts=;
        b=oAzpJUzh+oh8zCGKAKRZerVHrzVpZ/xGdAXpeahvrmkbCCz55VDH742U8lmnOJ4ydc
         /gDhUUpY+Ni3BWcAIZgsGBvj2NzWF67CdeBg9bnYdO9njvi3ibf06AwRXEn3z38pa4vx
         gmhEjTgPDDjOb3TZw0Yy6oBYpNGAWny145g0ue4qnkNFfr24u8CzrtIqRat+5LGSvLuQ
         MmxXPflTeSKm31bChLpZerc6vYkTuxwqJjx/C9D+0TgHeRknJU8oeOBz/ZtKow1QRe3j
         QmzO71gU7S2Am8KlxnUlFNRIb3zZsTFDpZr3UCq6EiIETpxwL7lPKwVY037726oX/MF0
         WaRg==
X-Gm-Message-State: AOAM532YJ9G3kuVjnmhtOAr9ctzf6ISDPhMzvyzBsUS4jhd9F7Aivopm
        BNVB1vcSt/jzeAOAs4fcAGPVtbeMLGim+w==
X-Google-Smtp-Source: ABdhPJzc1HcyHkCs4OIwwUOz9EN5A0x9QFWY5LEio+FGiflTsqMBsMK7YmPeh3Tg+18GU9TpLmciHA==
X-Received: by 2002:a17:90a:4684:: with SMTP id z4mr190654pjf.97.1604416052182;
        Tue, 03 Nov 2020 07:07:32 -0800 (PST)
Received: from localhost.localdomain ([122.179.48.228])
        by smtp.gmail.com with ESMTPSA id 15sm15936955pgs.52.2020.11.03.07.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 07:07:31 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: [PATCH V10 13/14] xfs: Process allocated extent in a separate function
Date:   Tue,  3 Nov 2020 20:36:41 +0530
Message-Id: <20201103150642.2032284-14-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103150642.2032284-1-chandanrlinux@gmail.com>
References: <20201103150642.2032284-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves over the code in xfs_bmap_btalloc() which is
responsible for processing an allocated extent to a new function. Apart
from xfs_bmap_btalloc(), the new function will be invoked by another
function introduced in a future commit.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 74 ++++++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5032539d5e85..f6cd33684571 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3510,6 +3510,48 @@ xfs_bmap_compute_alignments(
 	return stripe_align;
 }
 
+static void
+xfs_bmap_process_allocated_extent(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_fileoff_t		orig_offset,
+	xfs_extlen_t		orig_length)
+{
+	int			nullfb;
+
+	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
+
+	/*
+	 * check the allocation happened at the same or higher AG than
+	 * the first block that was allocated.
+	 */
+	ASSERT(nullfb ||
+		XFS_FSB_TO_AGNO(args->mp, ap->tp->t_firstblock) <=
+		XFS_FSB_TO_AGNO(args->mp, args->fsbno));
+
+	ap->blkno = args->fsbno;
+	if (nullfb)
+		ap->tp->t_firstblock = args->fsbno;
+	ap->length = args->len;
+	/*
+	 * If the extent size hint is active, we tried to round the
+	 * caller's allocation request offset down to extsz and the
+	 * length up to another extsz boundary.  If we found a free
+	 * extent we mapped it in starting at this new offset.  If the
+	 * newly mapped space isn't long enough to cover any of the
+	 * range of offsets that was originally requested, move the
+	 * mapping up so that we can fill as much of the caller's
+	 * original request as possible.  Free space is apparently
+	 * very fragmented so we're unlikely to be able to satisfy the
+	 * hints anyway.
+	 */
+	if (ap->length <= orig_length)
+		ap->offset = orig_offset;
+	else if (ap->offset + ap->length < orig_offset + orig_length)
+		ap->offset = orig_offset + orig_length - ap->length;
+	xfs_bmap_btalloc_accounting(ap, args);
+}
+
 STATIC int
 xfs_bmap_btalloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
@@ -3702,36 +3744,10 @@ xfs_bmap_btalloc(
 			return error;
 		ap->tp->t_flags |= XFS_TRANS_LOWMODE;
 	}
+
 	if (args.fsbno != NULLFSBLOCK) {
-		/*
-		 * check the allocation happened at the same or higher AG than
-		 * the first block that was allocated.
-		 */
-		ASSERT(ap->tp->t_firstblock == NULLFSBLOCK ||
-		       XFS_FSB_TO_AGNO(mp, ap->tp->t_firstblock) <=
-		       XFS_FSB_TO_AGNO(mp, args.fsbno));
-
-		ap->blkno = args.fsbno;
-		if (ap->tp->t_firstblock == NULLFSBLOCK)
-			ap->tp->t_firstblock = args.fsbno;
-		ap->length = args.len;
-		/*
-		 * If the extent size hint is active, we tried to round the
-		 * caller's allocation request offset down to extsz and the
-		 * length up to another extsz boundary.  If we found a free
-		 * extent we mapped it in starting at this new offset.  If the
-		 * newly mapped space isn't long enough to cover any of the
-		 * range of offsets that was originally requested, move the
-		 * mapping up so that we can fill as much of the caller's
-		 * original request as possible.  Free space is apparently
-		 * very fragmented so we're unlikely to be able to satisfy the
-		 * hints anyway.
-		 */
-		if (ap->length <= orig_length)
-			ap->offset = orig_offset;
-		else if (ap->offset + ap->length < orig_offset + orig_length)
-			ap->offset = orig_offset + orig_length - ap->length;
-		xfs_bmap_btalloc_accounting(ap, &args);
+		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
+			orig_length);
 	} else {
 		ap->blkno = NULLFSBLOCK;
 		ap->length = 0;
-- 
2.28.0

