Return-Path: <linux-xfs+bounces-2372-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A6968212A7
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 02:01:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC7021F22635
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 01:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB61803;
	Mon,  1 Jan 2024 01:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TkYG3HND"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54EC7F9;
	Mon,  1 Jan 2024 01:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4A7C433C8;
	Mon,  1 Jan 2024 01:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070899;
	bh=P1eEzr0BokPFcfCFa/BXeWCAtFOYWxo7JQ0feEnXhY8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TkYG3HND9iWUJFpN4iytta16UrTrA6Dr2UCt8U7yl3F0hDzevShP3C5KrzBoZdrX2
	 LnjAtCN8hp83ojDQBZNZs6pMQGxnCFxIYRVLQHmahB6HirKfhmgHSzc2LxH3u89wH7
	 carvhScT+oUtGstGi+ROF44XirzUcoPei2jqmyvK1fynsGKhP9wfMbGPCTrxIRbj+w
	 AV2fVzbqCxhd2ouCTrMqdiFsYQ0G7mxh6rqziV3Q60p4VBmlwKjFwqZ0aBEOAX26BF
	 jRL4becGKD4W4Pi9O720bWzoO1nqoUs4G9wMnXDYef3sleA/0wgMEmB/D147GYIopd
	 A1LJs0cV5FZKA==
Date: Sun, 31 Dec 2023 17:01:38 +9900
Subject: [PATCH 1/9] xfs/122: update fields for realtime reflink
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <170405032029.1827358.6809381410014348048.stgit@frogsfrogsfrogs>
In-Reply-To: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
References: <170405032011.1827358.11723561661069109569.stgit@frogsfrogsfrogs>
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

Add a few more ondisk structures for realtime reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index f5621cac12..9c2d2fffb4 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -120,6 +120,9 @@ sizeof(struct xfs_rmap_key) = 20
 sizeof(struct xfs_rmap_rec) = 24
 sizeof(struct xfs_rtbuf_blkinfo) = 48
 sizeof(struct xfs_rtgroup_geometry) = 128
+sizeof(struct xfs_rtrefcount_key) = 4
+sizeof(struct xfs_rtrefcount_rec) = 12
+sizeof(struct xfs_rtrefcount_root) = 4
 sizeof(struct xfs_rtrmap_key) = 20
 sizeof(struct xfs_rtrmap_rec) = 24
 sizeof(struct xfs_rtrmap_root) = 4


