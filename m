Return-Path: <linux-xfs+bounces-6692-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB06F8A5E79
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Apr 2024 01:38:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B8E61F21626
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Apr 2024 23:38:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 200D815885D;
	Mon, 15 Apr 2024 23:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bAl/SKMq"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D1D156974
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224323; cv=none; b=ZUHdQ5/fCSag2KlZ/kVP4Wm8jvWp5jnMywnKu1RO+PDsfT0NLFFvlqAfcGEmS4zebQFGrDFDwIo1Hb3vPc69oIQ2D9/d0nUmOWx/T9pjC96UnyN7NRd33j77Q73ch7jJRLgviLg/rbLqsYm1YDsAQpr3g7REFf9G9USD0aOoSYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224323; c=relaxed/simple;
	bh=kKRSmFweGmhEZLLvojVvy7bH5GkIG8iz9iNpQFdLcV4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Burf36sc/dnqnywgNMrZWQv23sB8pHbLO+y5NEWk81LcURZe/XwrMZUJGz48SiDw94E8qoP/ucgI4YgbU6d17B+TLEQtOQ+GHUOkle0jI9dYkTzy+mnJxvSY3hsN5taXozTcsj5NfcJm0agyGXBy/jYbEy0NC2Qaz2jzDGx2GaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bAl/SKMq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BECC113CC;
	Mon, 15 Apr 2024 23:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224323;
	bh=kKRSmFweGmhEZLLvojVvy7bH5GkIG8iz9iNpQFdLcV4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bAl/SKMqZaZXUia3811or8kAEULgZpB+h1KYNWFCMOggQ0oSOF+mnT4sO+Hu/AR3d
	 pio1ONILAwkh4t9pCvdoSFerai6Z+qfOX+N1KR6tmbqSpC0RUCHhSwuf92paQQZDdk
	 Bn5SRc5wRz/Gzs3P9IJ5IECcFPC8O/gBkIwN6lOwBkv95wuAzRDAOPZ9nhEg/OSW91
	 ZCZbNkZyptVT78A24+Y6UmmqI3jPwfXTL+viG3l1F0pCiGF7Medp1oKq7ISa2Jnsnh
	 b4yFZzptWmhXJLm8OcqyPBN8F5vXng6EMhau9W1rmbB4yEawZydpJlpl1i4e1tXipp
	 B7vFeemumcZIA==
Date: Mon, 15 Apr 2024 16:38:43 -0700
Subject: [PATCH 4/5] xfs: fix error bailout in xrep_abt_build_new_trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Dan Carpenter <dan.carpenter@linaro.org>, Christoph Hellwig <hch@lst.de>,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322380370.86847.9287127255915765643.stgit@frogsfrogsfrogs>
In-Reply-To: <171322380288.86847.5430338887776337667.stgit@frogsfrogsfrogs>
References: <171322380288.86847.5430338887776337667.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Dan Carpenter reports:

"Commit 4bdfd7d15747 ("xfs: repair free space btrees") from Dec 15,
2023 (linux-next), leads to the following Smatch static checker
warning:

        fs/xfs/scrub/alloc_repair.c:781 xrep_abt_build_new_trees()
        warn: missing unwind goto?"

That's a bug, so let's fix it.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 4bdfd7d15747 ("xfs: repair free space btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/alloc_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index d421b253923e..30295898cc8a 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -778,7 +778,7 @@ xrep_abt_build_new_trees(
 
 	error = xrep_bnobt_sort_records(ra);
 	if (error)
-		return error;
+		goto err_levels;
 
 	/* Load the free space by block number tree. */
 	ra->array_cur = XFARRAY_CURSOR_INIT;


