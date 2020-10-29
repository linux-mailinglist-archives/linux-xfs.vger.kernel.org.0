Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86F429E8C2
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Oct 2020 11:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgJ2KPB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Oct 2020 06:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbgJ2KPB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 06:15:01 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764CEC0613D2
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:15:01 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g12so1937525pgm.8
        for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2020 03:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dp3hdulPzXKrSK5utLesaXEuCAjp9dKNCSXc9TyPfZ8=;
        b=CGANBuzG68ixJ2mIgQCZPN71phgC1TSoz4s/ojW23LVqioFZkuSqmX5CUO5I31I+pA
         sPHxY6Iq2SHRHWNxI/rZ+jOLdH2/gi8UxeQAmSW0dVr/PCS0m4i59WPseKPQcAJvIL9R
         ks+cHa0aFNxf0iiHLJdhAodndi5ZDF/s0KlJo/9qfCt297oWjDMzLdfXPuMVP+g3WoLT
         DmcEhvrMFZ167SxALnRdGDN3quQhrztejg0o+kMJFmxvZ+zHm1G141tKP34vNntAEgXI
         LrSrUlONRwYQ17AQWmkkidEB7jhb2mko2d560ElUQ4Tnt9M+/Gf3hUMEpMo8zn0ciIW8
         +Y6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dp3hdulPzXKrSK5utLesaXEuCAjp9dKNCSXc9TyPfZ8=;
        b=AXtKQdbvtH4ZJhyLZk8LqY9GCyonJ/8gdgxnBgSyBZ3NTfwFAM571zVjg2+cXY0ntC
         EmCiWJWbRDBXd4YCs6QssHWAXnCpQjZ9OhQKahRydPq/tnLMjOmj8mIHYOtrjY6cbzft
         WEhmPWCrSOj+arEFdrwJHbzofQIiE/iz74nwYhfiSkb793CKKqtY17gmYVTVqMoOeckR
         NmLFa8qUHdR0PuRpwi3VBRaJdyh/yC6f7j91YY4sCh+mFfvjp6rODSNz80rZTXfStPAK
         Ve551tPBPRiNPlhaSOFFG8cB8mOd5olkVU2EbJeynZyYpymYn9AcpWo1NzHb/QiwQFu5
         22Cg==
X-Gm-Message-State: AOAM531DcErS0FQeGoLSODlzkkjq26Ag3M7cxX09s7hNcAQeQ9oDGJ/P
        Tz3XgL38Wn5gVeQYSyZqCypMB4aMlfc=
X-Google-Smtp-Source: ABdhPJyCyDkQeLq0x4P8haK8SesBCoYAUj1TJb9fCbxM/2bS1pKRnCaHqSxlfjf3xiGHkhtaP3vShA==
X-Received: by 2002:a63:da57:: with SMTP id l23mr3292004pgj.390.1603966500680;
        Thu, 29 Oct 2020 03:15:00 -0700 (PDT)
Received: from localhost.localdomain ([122.179.67.57])
        by smtp.gmail.com with ESMTPSA id s9sm2488073pfh.67.2020.10.29.03.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:15:00 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: [PATCH V8 12/14] xfs: Compute bmap extent alignments in a separate function
Date:   Thu, 29 Oct 2020 15:43:46 +0530
Message-Id: <20201029101348.4442-13-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029101348.4442-1-chandanrlinux@gmail.com>
References: <20201029101348.4442-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves over the code which computes stripe alignment and
extent size hint alignment into a separate function. Apart from
xfs_bmap_btalloc(), the new function will be used by another function
introduced in a future commit.

Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 88 +++++++++++++++++++++++-----------------
 1 file changed, 51 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 64c4d0e384a5..935f2d506748 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3463,13 +3463,58 @@ xfs_bmap_btalloc_accounting(
 		args->len);
 }
 
+static void
+xfs_bmap_compute_alignments(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	int			*stripe_align)
+{
+	struct xfs_mount	*mp = args->mp;
+	xfs_extlen_t		align = 0; /* minimum allocation alignment */
+	int			error;
+
+	/* stripe alignment for allocation is determined by mount parameters */
+	*stripe_align = 0;
+	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
+		*stripe_align = mp->m_swidth;
+	else if (mp->m_dalign)
+		*stripe_align = mp->m_dalign;
+
+	if (ap->flags & XFS_BMAPI_COWFORK)
+		align = xfs_get_cowextsz_hint(ap->ip);
+	else if (ap->datatype & XFS_ALLOC_USERDATA)
+		align = xfs_get_extsz_hint(ap->ip);
+	if (align) {
+		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
+						align, 0, ap->eof, 0, ap->conv,
+						&ap->offset, &ap->length);
+		ASSERT(!error);
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
@@ -3489,25 +3534,11 @@ xfs_bmap_btalloc(
 
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
 
+	xfs_bmap_compute_alignments(ap, &args, &stripe_align);
 
 	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
 	fb_agno = nullfb ? NULLAGNUMBER : XFS_FSB_TO_AGNO(mp,
@@ -3538,9 +3569,6 @@ xfs_bmap_btalloc(
 	 * Normal allocation, done through xfs_alloc_vextent.
 	 */
 	tryagain = isaligned = 0;
-	memset(&args, 0, sizeof(args));
-	args.tp = ap->tp;
-	args.mp = mp;
 	args.fsbno = ap->blkno;
 	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
 
@@ -3571,21 +3599,7 @@ xfs_bmap_btalloc(
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
2.28.0

