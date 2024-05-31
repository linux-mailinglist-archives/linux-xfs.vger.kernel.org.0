Return-Path: <linux-xfs+bounces-8800-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D4798D6A39
	for <lists+linux-xfs@lfdr.de>; Fri, 31 May 2024 21:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE55D1C26A1E
	for <lists+linux-xfs@lfdr.de>; Fri, 31 May 2024 19:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F60C17DE1D;
	Fri, 31 May 2024 19:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="By/w9vWT"
X-Original-To: linux-xfs@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69CAB17D371
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 19:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717185485; cv=none; b=SYV4AcrReRWiih+9YpDwOCJGUwtCc2uSycAitoMpgmn1IZpYbWLlCEbybli9EgbbC6l9SaS++FSjquGmaDnBf6Z475zGFdMOQ4lUvXr3G2n3ZtgnT68yTpWKCrpX+tr5H4sLl2PVWL2LeNnQbVAPguH37pF1f39AALN9MYy5ZVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717185485; c=relaxed/simple;
	bh=JWOl6ItaQl2aVe9lhja4LVVvJH+yS+S0SoH5GzzbhtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDr5t0WtL4zTLVBHwu09Hs6Oi5N8XKBUMVkPYsgtyvCzr9B0YDwcOJeU5Gl4lpTPkZPPErG/RxVMp8l6E/JsJ0WvYrVsbliitN3meceocEAD53BzHfSBIP3iLURD5vySsTMPNz5efx/dh2hAJNUvmZXLaVegGLV9GKe5CuULL1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=By/w9vWT; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
	:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=IJ0X/K7JEY81jB2AQq85pz1o1jTNSCOdH6cPfW/0MpE=; b=By/w9vWT+bp+82hECX7SEgi+Z2
	Hoa98ZgxmI0YzTOXGWiGWjthn78CC/x7+Zl1J9STZxQ/nvDWKH2Xl9bpTLQ89hwp5mTyc2sJM7hvd
	YjwGAdOOzLCYGfKbw4RGNQVfGl1DPdOBStmmLpBKZtBZif/Tu10gd58iMppDB4gLR3iCaltQlqak6
	4+TSfOepFZdVD0YgwpsxLA3FJiO+qsDRiM4eMRGiJMYFFPe5ZKVvoXOe1JdGEaB9Z6dv5dCSPS2TC
	OkoGhw0S806VwaNFv3p38y727uWvaY6KqV5Jr6r3e0H5Di1jn8psU9lySfpPBRr3K2YRxWrx1dTJp
	z+VjxTlA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <bage@debian.org>)
	id 1sD8Nw-004FIk-OC; Fri, 31 May 2024 19:57:56 +0000
From: Bastian Germann <bage@debian.org>
To: linux-xfs@vger.kernel.org
Cc: Bastian Germann <bage@debian.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v3 1/1] xfs_io: make MADV_SOFT_OFFLINE conditional
Date: Fri, 31 May 2024 21:57:51 +0200
Message-ID: <20240531195751.15302-2-bage@debian.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240531195751.15302-1-bage@debian.org>
References: <20240531195751.15302-1-bage@debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage

mips64el does not have the symbol MADV_SOFT_OFFLINE, so wrap it in an
ifdef.

Signed-off-by: Bastian Germann <bage@debian.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 io/madvise.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/io/madvise.c b/io/madvise.c
index ede23395..f26c03f1 100644
--- a/io/madvise.c
+++ b/io/madvise.c
@@ -40,7 +40,9 @@ madvise_help(void)
 " -H -- enable transparent hugepages (MADV_HUGEPAGE)\n"
 " -m -- mark the range mergeable (MADV_MERGEABLE)\n"
 " -M -- mark the range unmergeable (MADV_UNMERGEABLE)\n"
+#ifdef MADV_SOFT_OFFLINE
 " -o -- mark the range offline (MADV_SOFT_OFFLINE)\n"
+#endif
 " -p -- punch a hole in the file (MADV_REMOVE)\n"
 " -P -- poison the page cache (MADV_HWPOISON)\n"
 #ifdef MADV_POPULATE_READ
@@ -101,9 +103,12 @@ madvise_f(
 		case 'M':	/* disable merging */
 			advise = MADV_UNMERGEABLE;
 			break;
+#ifdef MADV_SOFT_OFFLINE
+/* MADV_SOFT_OFFLINE is undefined on mips */
 		case 'o':	/* offline */
 			advise = MADV_SOFT_OFFLINE;
 			break;
+#endif
 		case 'p':	/* punch hole */
 			advise = MADV_REMOVE;
 			break;
-- 
2.45.1


