Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059DF304657
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Jan 2021 19:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbhAZRYz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 26 Jan 2021 12:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729255AbhAZGfh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 01:35:37 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFA7C0617A9
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:25 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id f63so9897238pfa.13
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N50Dw28jSVUtNoN3upNHRoE7AIJFWG6saqQ6nezqhvQ=;
        b=P1tDlDOUw73nXKU1pF/RTCF2UdLSEea+xHFe2jFpidZYT3S1lIB2/4R1NjUDmu7syx
         3b61mri8m3y2IkHA6QOdAHAhwA0YGIZvLUBdNLx9ch5BYIDqBYxQfXSpUtmk0dRtE46p
         UHO9OtwZClaFA+aLDfJxVDPUas871G9FLZAniKV21MRDNEfk7tGVKMA7tdU/JNJ/mOWc
         +tlyUPATHLXyfv1iB2+9fX0GImoZ7+oBzx/Clz2cXS5MtouRzC9kJrWRQeLofQJuyhfG
         4421ElvIJ+8wrmRbAJ/Te1JcfDRTDeGq31R8qEKuG78fZKWlAqQ6S81drsGT1io7Gsuz
         x+BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N50Dw28jSVUtNoN3upNHRoE7AIJFWG6saqQ6nezqhvQ=;
        b=l6Xjv5lb62fUk7gPH62Rqxztz9hDU6ShR1n2shyR/1aIFU2QSEMeEpzdFzXt3o5/3Y
         ACg7j1SUwnYdxjt+VcKw7dZo//DtagYNCgP65bFc5C0FbXoUl99UvhnAqD4+qkeYU2Lt
         A3fEfmP3tAeoREuJlRhQDmA0CuttDZgFOHjyfiL8VBGv4P0FwxE4MyiTHYljWmgxLbqf
         uJ3PN0WjWHh63p4yolmx54H9mQU+Kp1vLHzY1iu+mQRanv32AEZPUbzRc+1owdbq563T
         vrQYeRfLurWteoN6L3tuE1difIrkt322Tl+wC2cCVgdceMLIBqfb+C5g5SE8A+HBtSU5
         pchA==
X-Gm-Message-State: AOAM532OGHRT+M03bPUeXEtA5BObjPt2vksgRj3PhytOcnNdp1+NMUuB
        0wZrRTSyy0ikN+fjSj04y8MR4KGR4Xg=
X-Google-Smtp-Source: ABdhPJy9wghMv6EbPhAIY+2hNNwyc8v9NNrbhe3SufoLhF6gbdS6v6O4ypLFeYSrwgDOyCqreSxA2w==
X-Received: by 2002:a05:6a00:2296:b029:1b6:6972:2f2a with SMTP id f22-20020a056a002296b02901b669722f2amr3922394pfe.69.1611642805211;
        Mon, 25 Jan 2021 22:33:25 -0800 (PST)
Received: from localhost.localdomain ([122.167.33.191])
        by smtp.gmail.com with ESMTPSA id w21sm17296578pff.220.2021.01.25.22.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 22:33:24 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org,
        hch@lst.de, allison.henderson@oracle.com,
        kernel test robot <lkp@intel.com>
Subject: [PATCH V15 14/16] xfs: Compute bmap extent alignments in a separate function
Date:   Tue, 26 Jan 2021 12:02:30 +0530
Message-Id: <20210126063232.3648053-15-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126063232.3648053-1-chandanrlinux@gmail.com>
References: <20210126063232.3648053-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves over the code which computes stripe alignment and
extent size hint alignment into a separate function. Apart from
xfs_bmap_btalloc(), the new function will be used by another function
introduced in a future commit.

Reported-by: kernel test robot <lkp@intel.com> # Unused variable warning
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 89 +++++++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0b15b1ff4bdd..a0e8968e473d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3463,13 +3463,59 @@ xfs_bmap_btalloc_accounting(
 		args->len);
 }
 
+static int
+xfs_bmap_compute_alignments(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args)
+{
+	struct xfs_mount	*mp = args->mp;
+	xfs_extlen_t		align = 0; /* minimum allocation alignment */
+	int			stripe_align = 0;
+
+	/* stripe alignment for allocation is determined by mount parameters */
+	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
+		stripe_align = mp->m_swidth;
+	else if (mp->m_dalign)
+		stripe_align = mp->m_dalign;
+
+	if (ap->flags & XFS_BMAPI_COWFORK)
+		align = xfs_get_cowextsz_hint(ap->ip);
+	else if (ap->datatype & XFS_ALLOC_USERDATA)
+		align = xfs_get_extsz_hint(ap->ip);
+	if (align) {
+		if (xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
+			align, 0, ap->eof, 0, ap->conv, &ap->offset,
+			&ap->length))
+			ASSERT(0);
+
+		ASSERT(ap->length);
+	}
+
+	/* apply extent size hints if obtained earlier */
+	if (align) {
+		args->prod = align;
+		div_u64_rem(ap->offset, args->prod, &args->mod);
+		if (args->mod)
+			args->mod = args->prod - args->mod;
+	} else if (mp->m_sb.sb_blocksize >= PAGE_SIZE) {
+		args->prod = 1;
+		args->mod = 0;
+	} else {
+		args->prod = PAGE_SIZE >> mp->m_sb.sb_blocklog;
+		div_u64_rem(ap->offset, args->prod, &args->mod);
+		if (args->mod)
+			args->mod = args->prod - args->mod;
+	}
+
+	return stripe_align;
+}
+
 STATIC int
 xfs_bmap_btalloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
 	xfs_mount_t	*mp;		/* mount point structure */
 	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
-	xfs_extlen_t	align = 0;	/* minimum allocation alignment */
 	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
 	xfs_agnumber_t	ag;
 	xfs_alloc_arg_t	args;
@@ -3489,25 +3535,11 @@ xfs_bmap_btalloc(
 
 	mp = ap->ip->i_mount;
 
-	/* stripe alignment for allocation is determined by mount parameters */
-	stripe_align = 0;
-	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
-		stripe_align = mp->m_swidth;
-	else if (mp->m_dalign)
-		stripe_align = mp->m_dalign;
-
-	if (ap->flags & XFS_BMAPI_COWFORK)
-		align = xfs_get_cowextsz_hint(ap->ip);
-	else if (ap->datatype & XFS_ALLOC_USERDATA)
-		align = xfs_get_extsz_hint(ap->ip);
-	if (align) {
-		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
-						align, 0, ap->eof, 0, ap->conv,
-						&ap->offset, &ap->length);
-		ASSERT(!error);
-		ASSERT(ap->length);
-	}
+	memset(&args, 0, sizeof(args));
+	args.tp = ap->tp;
+	args.mp = mp;
 
+	stripe_align = xfs_bmap_compute_alignments(ap, &args);
 
 	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
 	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
@@ -3538,9 +3570,6 @@ xfs_bmap_btalloc(
 	 * Normal allocation, done through xfs_alloc_vextent.
 	 */
 	tryagain = isaligned = 0;
-	memset(&args, 0, sizeof(args));
-	args.tp = ap->tp;
-	args.mp = mp;
 	args.fsbno = ap->blkno;
 	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
 
@@ -3571,21 +3600,7 @@ xfs_bmap_btalloc(
 		args.total = ap->total;
 		args.minlen = ap->minlen;
 	}
-	/* apply extent size hints if obtained earlier */
-	if (align) {
-		args.prod = align;
-		div_u64_rem(ap->offset, args.prod, &args.mod);
-		if (args.mod)
-			args.mod = args.prod - args.mod;
-	} else if (mp->m_sb.sb_blocksize >= PAGE_SIZE) {
-		args.prod = 1;
-		args.mod = 0;
-	} else {
-		args.prod = PAGE_SIZE >> mp->m_sb.sb_blocklog;
-		div_u64_rem(ap->offset, args.prod, &args.mod);
-		if (args.mod)
-			args.mod = args.prod - args.mod;
-	}
+
 	/*
 	 * If we are not low on available data blocks, and the underlying
 	 * logical volume manager is a stripe, and the file offset is zero then
-- 
2.29.2

