Return-Path: <linux-xfs+bounces-2884-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 786C7835B8E
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Jan 2024 08:24:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB2691C2162F
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Jan 2024 07:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05DB6101C5;
	Mon, 22 Jan 2024 07:24:18 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C32AF505
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 07:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705908257; cv=none; b=pGX6B7KQhXvyCY7kTP0yu4VPptOY4YUiaK1Mf7P6UVzwugWSFaZkUPoXmOaeaVDOJ1DuRK24KRFWFLhZ5BTiW/ii523pN4r2rLwFShvUaaqZWoRulbGRO/rNtb8+58nMSieWnrVa4ANivEjZZmwJrtvDR65mfA6HQGYpmFzsQlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705908257; c=relaxed/simple;
	bh=m3//0ZVhhFlnMyoSD6iigImPSIzze0od3a8bzouQG/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/Mt6mg1kMiZORtivDCjYNS1wXaRpgLAXZta5+iBLCvQKiRi3F+ElIRtNoXK3YdVAUXmWFnQM6/Vj5p1USc0C37NxP/NFhnchLkJL+PWpeK7BpibeHunPAiCfP+na5ovzGKaJ7AK1qCEDaqczz5dB/XxjI6KK764KDx0cDIMX5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Sam James <sam@gentoo.org>
To: linux-xfs@vger.kernel.org
Cc: Sam James <sam@gentoo.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v4 2/3] build: Request 64-bit time_t where possible
Date: Mon, 22 Jan 2024 07:23:27 +0000
Message-ID: <20240122072351.3036242-2-sam@gentoo.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122072351.3036242-1-sam@gentoo.org>
References: <20240122072351.3036242-1-sam@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Suggested by Darrick during LFS review. We take the same approach as in
5c0599b721d1d232d2e400f357abdf2736f24a97 ('Fix building xfsprogs on 32-bit platforms')
to avoid autoconf hell - just take the tried & tested approach which is working
fine for us with LFS already.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sam James <sam@gentoo.org>
---
 include/builddefs.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/builddefs.in b/include/builddefs.in
index 147c9b98..969254f3 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -13,8 +13,8 @@ OPTIMIZER = @opt_build@
 MALLOCLIB = @malloc_lib@
 LOADERFLAGS = @LDFLAGS@
 LTLDFLAGS = @LDFLAGS@
-CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64 -Wno-address-of-packed-member
-BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64
+CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64 -Wno-address-of-packed-member
+BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64 -D_TIME_BITS=64
 
 # make sure we don't pick up whacky LDFLAGS from the make environment and
 # only use what we calculate from the configured options above.
-- 
2.43.0


