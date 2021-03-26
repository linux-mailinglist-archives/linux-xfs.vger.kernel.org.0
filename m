Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58FE349DB3
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Mar 2021 01:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhCZAWP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Mar 2021 20:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230180AbhCZAWL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:22:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8526B619D3;
        Fri, 26 Mar 2021 00:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718131;
        bh=41FbphGw9grZzaFY3nyPpAWytXQLKbHPtdmBQ5/66Ug=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KIEsQ1BKskO7iPOE2aheqB1F9iEohb8567ArL8N4AwrSvxQsd8yLbxc/iqxjdIB1/
         k0WgfN9zXrUYmdCy5yM/KfrBNu8F8wAsFdq3siMNL+qVKNSa3vVtkFwpJDNq+nJtP0
         WEE8yMFHGZck7wlCBGTuvDPPzVAH4Il46Dzc2ftxKMxAKSo0VzfEohFqkDGt9F9cly
         T++nBiNWXffBskv6NcFOQsAvr716vk4cIX+wblSOtrU+weehVMsu5wC32wBlMecN1L
         TnzHUIaWn+3bjXiFRU4pIOQEpzIT0nQOo10jwpmw3mZIzvOn8+IVB7PZWXGaQ+yahB
         oKi83mfkZMCTg==
Subject: [PATCH 4/9] xfs: force inode inactivation and retry fs writes when
 there isn't space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 25 Mar 2021 17:22:11 -0700
Message-ID: <161671813115.622901.6609359614387194771.stgit@magnolia>
In-Reply-To: <161671810866.622901.16520335819131743716.stgit@magnolia>
References: <161671810866.622901.16520335819131743716.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Any time we try to modify a file's contents and it fails due to ENOSPC
or EDQUOT, force inode inactivation work to try to free space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 803f1241f867..b0293ab55385 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1690,9 +1690,15 @@ xfs_blockgc_free_space(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
+	int			error;
+
 	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
 
-	return xfs_inode_walk(mp, XFS_ICI_BLOCKGC_TAG, eofb);
+	error = xfs_inode_walk(mp, XFS_ICI_BLOCKGC_TAG, eofb);
+	if (error)
+		return error;
+
+	return xfs_inodegc_free_space(mp, eofb);
 }
 
 /*

