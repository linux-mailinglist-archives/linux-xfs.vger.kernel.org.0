Return-Path: <linux-xfs+bounces-4606-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CE479870A54
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Mar 2024 20:14:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F100B22AC8
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Mar 2024 19:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44A1F7D08D;
	Mon,  4 Mar 2024 19:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RCQigQNm"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAF37CF21
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 19:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579550; cv=none; b=Hxb4AGV0oJ2WhChFemBQt772N7ONCGdsGaDXTpkZ1Xusyf+Fz2qPaJID9AX1Sj5VDry5umq8Q3Wy8QZtqzy3Yh+Hw4lwMyprrURkGrKeYfSusnL7r2baDeudnOy+zutZIxyp99EZQPqZGsvbIOAwv8AScTAYEHn89/c6MUtoRMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579550; c=relaxed/simple;
	bh=o9W4znw5NysKxZeHeBecA5SEITer/EW1DME955Sy8Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shbHv9aQ/cOFC02xdQXOhOH6ukyK4glh7ShUWGKVaYB0z+D23b0pp7gFFvQu2HZUOQkz7DPOXaK7iOX1By9vL1ij5GnKoPYKpxCi1JKO1AvHKWSwlVyVzrrMZxO+vyyXP5bqAj28XWd78S4wj+KYEkYQl7fAZOcNEKdcNTo+p6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RCQigQNm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709579548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tg5FMjI6Vh1hHz8JgRcKgKGDcYt6qlitx1KNeKNRQZY=;
	b=RCQigQNmfNEV02Z2xV6b7hc+LtSdIp+JLQez1koIP+GHBBZukfeEI9GsO6Q9vAp7tU90Fq
	t3Q7n2X0KoLF+fHoFbFVoxo1U/NHsPrtlrbjKPhsGA1NFe/dzvOCRfXVfdb2U6ed8IzdJo
	9bv8BaTMBOfJIxNzj1FRA5cBNMUJQEc=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-V75xSgZANceiiXL-Qwf0NA-1; Mon, 04 Mar 2024 14:12:26 -0500
X-MC-Unique: V75xSgZANceiiXL-Qwf0NA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5134251ef6eso2259979e87.2
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 11:12:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579545; x=1710184345;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tg5FMjI6Vh1hHz8JgRcKgKGDcYt6qlitx1KNeKNRQZY=;
        b=saHoJZYgTGbhlS9lfeiUnGOb+94SQImDt0RYPHxSOeXbfQrhNsTZU9FhHLwB9wlRbv
         rQWRLLmdll1VJiO25f5/VyY9cfS9cOt0eCtBoOteHign/9l3oc/wfWYnisA6bkN0HL9X
         MoCuzMGcWoFSp2Kg+DpPa3xWXRNLPiu1P95axoWE8Nios324QQzGenR93tqzuMpZGuo0
         3L+DBpDDa4l1l0/F4lXYEMdnjnHBBplEFMhOPhNCPrR0agRn8pKtF+fOy8gN25ETWDrQ
         5qZ+NLadpW5YIRuAZGbRdglzr7r5MTbNGEs7i2VR5NkdL6jNwNtNHP1aWLFcF6I+xkBk
         Lbxg==
X-Forwarded-Encrypted: i=1; AJvYcCXWHRv6YkMXNtUHzROv4hQm501Bu4V0k2toqNrqxXz83IvWtSJZc4nTnylRVZ4j9kf68hiS3OlF2XEzfQkLBDGv0877crAreKRV
X-Gm-Message-State: AOJu0YxCI/thOIzEr3cOAITx8v9ApeoXI8nIo87txoW3foML0UZwcy7Z
	hboh/PkTrEiM5WbMBNEUi5Tzg7RYMvmULysTzxLOecrOsO6DyIm92BBO6L9LLNIfdKs0G41UWi+
	wEwftruoFpkXbYDWLgrA6kCNcTW4NUaQS3EeW/A8f9RunV6q3FWiVzOlv
X-Received: by 2002:ac2:5593:0:b0:513:23da:9766 with SMTP id v19-20020ac25593000000b0051323da9766mr6540039lfg.55.1709579545472;
        Mon, 04 Mar 2024 11:12:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGhcwdoaV6bOY0QfPY8E83kkcNTDRmjuWUE3Tlj+pjRh88ZfaSKm1Si1pEnq8D5WakLwp7t0g==
X-Received: by 2002:ac2:5593:0:b0:513:23da:9766 with SMTP id v19-20020ac25593000000b0051323da9766mr6540028lfg.55.1709579545252;
        Mon, 04 Mar 2024 11:12:25 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709064a4b00b00a44a04aa3cfsm3783319ejv.225.2024.03.04.11.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 11:12:24 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v5 16/24] xfs: add fs-verity ro-compat flag
Date: Mon,  4 Mar 2024 20:10:39 +0100
Message-ID: <20240304191046.157464-18-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240304191046.157464-2-aalbersh@redhat.com>
References: <20240304191046.157464-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To mark inodes with fs-verity enabled the new XFS_DIFLAG2_VERITY flag
will be added in further patch. This requires ro-compat flag to let
older kernels know that fs with fs-verity can not be modified.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h | 1 +
 fs/xfs/libxfs/xfs_sb.c     | 2 ++
 fs/xfs/xfs_mount.h         | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 2b2f9050fbfb..93d280eb8451 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -353,6 +353,7 @@ xfs_sb_has_compat_feature(
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
+#define XFS_SB_FEAT_RO_COMPAT_VERITY   (1 << 4)		/* fs-verity */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a25949843d8d..1c68785e60cc 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -163,6 +163,8 @@ xfs_sb_version_to_features(
 		features |= XFS_FEAT_REFLINK;
 	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
 		features |= XFS_FEAT_INOBTCNT;
+	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_VERITY)
+		features |= XFS_FEAT_VERITY;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_FTYPE)
 		features |= XFS_FEAT_FTYPE;
 	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_SPINODES)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e880aa48de68..f198d7c82552 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -292,6 +292,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
 #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
+#define XFS_FEAT_VERITY		(1ULL << 27)	/* fs-verity */
 
 /* Mount features */
 #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
@@ -355,6 +356,7 @@ __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
+__XFS_HAS_FEAT(verity, VERITY)
 
 /*
  * Mount features
-- 
2.42.0


