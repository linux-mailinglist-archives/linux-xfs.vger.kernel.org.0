Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D072131AA30
	for <lists+linux-xfs@lfdr.de>; Sat, 13 Feb 2021 06:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbhBMFem (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 13 Feb 2021 00:34:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230416AbhBMFek (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:34:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CDF664E9A;
        Sat, 13 Feb 2021 05:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613194423;
        bh=yUB8d38HfpbDCRPHNKnnorSrkrAJTVvygBH4h4lHOZY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=U5bt1+b4GTycQu8hbnE+CJ1tAdjU7Cm3YCNQokrpwFoND+3Im+82nZ0N88WoN11kt
         8q6yVYra52LagsQstNHj/E6KxGGMoPffyZSCBl/WRUku+beMJaM+6qcvWnvIqNOda3
         H0LIQwsnuj+l4o06FoWOR0YM+dRgfNjPPeXr6sZlKAbq6dOz6N6RCKtVLEnI6X1OBB
         TEdP+W3WOC13c1O5vse1ofTnbM6IMCJB0SpZk1g2hZIit/40kEjQwGJxtrY8Aj/z7V
         oxwVre5o0PZgPaNDo0R9EIIOnnI8eszxOYSS3Mwp+jMVnTrmObO02LYmOYvGXWfPvK
         sHh+NGYxLtGCA==
Subject: [PATCH 2/3] xfs/122: embiggen struct xfs_agi size for inobtcount
 feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Fri, 12 Feb 2021 21:33:42 -0800
Message-ID: <161319442288.403510.14136573891346236052.stgit@magnolia>
In-Reply-To: <161319441183.403510.7352964287278809555.stgit@magnolia>
References: <161319441183.403510.7352964287278809555.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make the expected AGI size larger for the inobtcount feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/122.out |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index cfe09c6d..b0773756 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -113,7 +113,7 @@ sizeof(struct xfs_scrub_metadata) = 64
 sizeof(struct xfs_unmount_log_format) = 8
 sizeof(xfs_agf_t) = 224
 sizeof(xfs_agfl_t) = 36
-sizeof(xfs_agi_t) = 336
+sizeof(xfs_agi_t) = 344
 sizeof(xfs_alloc_key_t) = 8
 sizeof(xfs_alloc_rec_incore_t) = 8
 sizeof(xfs_alloc_rec_t) = 8

