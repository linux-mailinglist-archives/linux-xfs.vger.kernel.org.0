Return-Path: <linux-xfs+bounces-6191-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E932489602A
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Apr 2024 01:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1847E1C232B9
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Apr 2024 23:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2107247A7A;
	Tue,  2 Apr 2024 23:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="QrLI7YIT"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C381E531
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 23:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712100615; cv=none; b=oaSc9W8EbKq9u6HXdEhMSD6LMaTAAzMJQ95ALrVz13ogNshPhio+93uBMVyjzjx3PiqvxVF1zlTe6LsofUpKwc6+n+uZ8Tdmtc5/Xh+UKHl3qLdy/pSTR4kpqTw2XXWyfGSDAQrpdPfLwQcOKotIc433GTZxXKouDQuj9jTxiwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712100615; c=relaxed/simple;
	bh=8V/UNrq6anFxrcLsstoH28hj/LpgQW7e9LuklhLINRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqT/fc4NU/yFmDNAUteyVIQQZrzOAMGFNzmIOfsXeATVc/8DXirUQPdm9A6+1SI3021gZVUKYCVq1XxW/wIYiOcnhQAU4kgWrdeUd63//tYRhDZbC69i2DHjL4q27y9eUBti3bSVNUAba7xWE6WPQBuMKgqX7dqcF6aT4Dq7mZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=QrLI7YIT; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6ecbe6dc8c6so1697553b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 16:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712100613; x=1712705413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+qH3gbB+If+3pSpMLmVxmMDFt37zGR941038IrgIW/M=;
        b=QrLI7YIT6/2C7sSo96zLnFi/yQU9EaV9v4Uh01qcn2UiiLtR1ornborWijctHFnJwY
         XyMmRdlgpr9xZ8ucwQ7d0H3HQ88yYmqCqjWuYq7/AokCVG4+JGUFHdSxVye6LU3iSlwu
         8vAa6BsDqxIpHp3Tw/F0FSBNwqxLxTpHVY/4mjbDwK11rx/C8K7U2P3OlDl3C/KOnLFo
         /swiJ9h5ua8+GhmSTVx510vPxaGhx6mZShKldSMqmyhw9nSIYjEH1ciYGD7r/gE1ShBw
         U9tiyTcBT7F0hBZ0ardg+FRuDhxyB1etpTocchWfi8vAiaUix/qKwG36G7mi/S7PLpkj
         s9Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712100613; x=1712705413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+qH3gbB+If+3pSpMLmVxmMDFt37zGR941038IrgIW/M=;
        b=t0hPXNtvdrVQUDnfVh87YZDQTreVoK/u/eFsywLcsX+Wn2pDHKtjfIdrtZ8UhnI3t4
         1t5PEEchDrWmxqYEX/l09B1ctKGOYt4qD7OkrQO+vrPldEeWCLUKgvIhelbsZys1I4/R
         sWMeF+31w7Ls0dDBxxIdWTDn5qMnDnqgrPL/tFW3TZagoctvwSJArPrubp97YECIH51+
         ZFC4MF1mdMGCJDRMzAJDs6jcx0SwJk79ckbABW5kSGSIH1t6JHo1PyyAJ2TZ4HuxWlL1
         mN0Xr3zFSDEmNZus9SGY6E0D6PvV0p/1DSHUd2ECQB7oWibi6aDvdW3uKD0C2Gc/AZa1
         76xQ==
X-Gm-Message-State: AOJu0YytauWl0prFfFRVCS9dblBEu5Ej9EqLV/1Q8fwFlYBSDC551I2x
	IC54yeQ+LQSu5WkoxD/YhqdaCOBbMW8Rr+Edm3cbW43OijcXCbh9aovputDO7QkbWGU6SjiqRPY
	T
X-Google-Smtp-Source: AGHT+IHGBLqASrcHgjjXRFeY/L5pNm0Z5nvGraL/kufxgNkWO8pydXxztVtoo9UEYZVrQEu8XHd5LA==
X-Received: by 2002:a05:6a00:10c1:b0:6e7:8047:96f0 with SMTP id d1-20020a056a0010c100b006e7804796f0mr14650524pfu.28.1712100613033;
        Tue, 02 Apr 2024 16:30:13 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id fm2-20020a056a002f8200b006e7243bbd35sm10671667pfb.172.2024.04.02.16.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 16:30:12 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rrnZx-001syU-2H;
	Wed, 03 Apr 2024 10:30:09 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rrnZx-000000054rU-0tY4;
	Wed, 03 Apr 2024 10:30:09 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: john.g.garry@oracle.com
Subject: [PATCH 5/5] xfs: introduce forced allocation alignment
Date: Wed,  3 Apr 2024 10:28:44 +1100
Message-ID: <20240402233006.1210262-6-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240402233006.1210262-1-david@fromorbit.com>
References: <20240402233006.1210262-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

When forced allocation alignment is specified, the extent will
be aligned to the extent size hint size rather than stripe
alignment. If aligned allocation cannot be done, then the allocation
is failed rather than attempting non-aligned fallbacks.

Note: none of the per-inode force align configuration is present
yet, so this just triggers off an "always false" wrapper function
for the moment.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.h |  1 +
 fs/xfs/libxfs/xfs_bmap.c  | 29 +++++++++++++++++++++++------
 fs/xfs/xfs_inode.h        |  5 +++++
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index aa2c103d98f0..7de2e6f64882 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -66,6 +66,7 @@ typedef struct xfs_alloc_arg {
 #define XFS_ALLOC_USERDATA		(1 << 0)/* allocation is for user data*/
 #define XFS_ALLOC_INITIAL_USER_DATA	(1 << 1)/* special case start of file */
 #define XFS_ALLOC_NOBUSY		(1 << 2)/* Busy extents not allowed */
+#define XFS_ALLOC_FORCEALIGN		(1 << 3)/* forced extent alignment */
 
 /* freespace limit calculations */
 unsigned int xfs_alloc_set_aside(struct xfs_mount *mp);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c2ddf1875e52..7a0ef0900097 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3411,9 +3411,10 @@ xfs_bmap_alloc_account(
  * Calculate the extent start alignment and the extent length adjustments that
  * constrain this allocation.
  *
- * Extent start alignment is currently determined by stripe configuration and is
- * carried in args->alignment, whilst extent length adjustment is determined by
- * extent size hints and is carried by args->prod and args->mod.
+ * Extent start alignment is currently determined by forced inode alignment or
+ * stripe configuration and is carried in args->alignment, whilst extent length
+ * adjustment is determined by extent size hints and is carried by args->prod
+ * and args->mod.
  *
  * Low level allocation code is free to either ignore or override these values
  * as required.
@@ -3426,11 +3427,18 @@ xfs_bmap_compute_alignments(
 	struct xfs_mount	*mp = args->mp;
 	xfs_extlen_t		align = 0; /* minimum allocation alignment */
 
-	/* stripe alignment for allocation is determined by mount parameters */
-	if (mp->m_swidth && xfs_has_swalloc(mp))
+	/*
+	 * Forced inode alignment takes preference over stripe alignment.
+	 * Stripe alignment for allocation is determined by mount parameters.
+	 */
+	if (xfs_inode_has_forcealign(ap->ip)) {
+		args->alignment = xfs_get_extsz_hint(ap->ip);
+		args->datatype |= XFS_ALLOC_FORCEALIGN;
+	} else if (mp->m_swidth && xfs_has_swalloc(mp)) {
 		args->alignment = mp->m_swidth;
-	else if (mp->m_dalign)
+	} else if (mp->m_dalign) {
 		args->alignment = mp->m_dalign;
+	}
 
 	if (ap->flags & XFS_BMAPI_COWFORK)
 		align = xfs_get_cowextsz_hint(ap->ip);
@@ -3617,6 +3625,11 @@ xfs_bmap_btalloc_low_space(
 {
 	int			error;
 
+	if (args->alignment > 1 && (args->datatype & XFS_ALLOC_FORCEALIGN)) {
+		args->fsbno = NULLFSBLOCK;
+		return 0;
+	}
+
 	args->alignment = 1;
 	if (args->minlen > ap->minlen) {
 		args->minlen = ap->minlen;
@@ -3668,6 +3681,8 @@ xfs_bmap_btalloc_filestreams(
 
 	/* Attempt non-aligned allocation if we haven't already. */
 	if (!error && args->fsbno == NULLFSBLOCK && args->alignment > 1)  {
+		if (args->datatype & XFS_ALLOC_FORCEALIGN)
+			return error;
 		args->alignment = 1;
 		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
 	}
@@ -3726,6 +3741,8 @@ xfs_bmap_btalloc_best_length(
 
 	/* Attempt non-aligned allocation if we haven't already. */
 	if (!error && args->fsbno == NULLFSBLOCK && args->alignment > 1)  {
+		if (args->datatype & XFS_ALLOC_FORCEALIGN)
+			return error;
 		args->alignment = 1;
 		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0f9d32cbae72..94fa79ae1591 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -312,6 +312,11 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
 }
 
+static inline bool xfs_inode_has_forcealign(struct xfs_inode *ip)
+{
+	return false;
+}
+
 /*
  * Return the buftarg used for data allocations on a given inode.
  */
-- 
2.43.0


