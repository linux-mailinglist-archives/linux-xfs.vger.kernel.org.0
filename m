Return-Path: <linux-xfs+bounces-66-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BAE7D7F870F
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Nov 2023 00:55:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70BC01F20F1D
	for <lists+linux-xfs@lfdr.de>; Fri, 24 Nov 2023 23:55:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E59D3DB8E;
	Fri, 24 Nov 2023 23:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cc8EyrAl"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CB93DB88
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BE3C433C8;
	Fri, 24 Nov 2023 23:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700870100;
	bh=ukvOwplUCnKY5B9lx6lK3vKRMyVou/wGzviOXwmfy9I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cc8EyrAl3HoBy6Cyx29fpwTxACoe9L3sTtWLbC9hU8RMsYBjQqUz6lubEjDCbKNTq
	 qopPqkGmepSC5ELQr2AtJs4xZE+jjvJQQAy8EBCSzEdRV4r/K+ddPWo4vGfyMSMEV7
	 UVLD5HJH2iTCs5StYFz/ABwe0DDKc2sC7RzUl1o3nTiFjTNmE8jcvxp2t9Q+49hY64
	 VZy7yLziItAMxB7wwmoQ2H4YLukba9tuH7auJWzaXVb9YmLiJjgayIqx1YkKH6Eklb
	 RFRQ+8J8MQ+B84tipzps8u9m5R0qrd5Yf/LZORFdsXr9JJELX6a3RC6wch4/o/QZT3
	 Rdxx1kbvvhmTA==
Date: Fri, 24 Nov 2023 15:54:59 -0800
Subject: [PATCH 3/6] xfs: always check the rtbitmap and rtsummary files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086928392.2771542.12213973195389304948.stgit@frogsfrogsfrogs>
In-Reply-To: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
References: <170086928333.2771542.10506226721850199807.stgit@frogsfrogsfrogs>
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

XFS filesystems always have a realtime bitmap and summary file, even if
there has never been a realtime volume attached.  Always check them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/scrub.c |    2 --
 1 file changed, 2 deletions(-)


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index bc70a91f8b1bf..89ce6d2f9ad14 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -330,14 +330,12 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xchk_setup_rtbitmap,
 		.scrub	= xchk_rtbitmap,
-		.has	= xfs_has_realtime,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
 		.type	= ST_FS,
 		.setup	= xchk_setup_rtsummary,
 		.scrub	= xchk_rtsummary,
-		.has	= xfs_has_realtime,
 		.repair	= xrep_notsupported,
 	},
 	[XFS_SCRUB_TYPE_UQUOTA] = {	/* user quota */


