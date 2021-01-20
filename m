Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937C32FCA02
	for <lists+linux-xfs@lfdr.de>; Wed, 20 Jan 2021 05:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbhATEcj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 Jan 2021 23:32:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbhATEcj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jan 2021 23:32:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B3812313B;
        Wed, 20 Jan 2021 04:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611117118;
        bh=1JkfNgNojJ0fH15KykzrlvJb/eoTJNEeA6wilH+UlK8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sw3GSGQWfkLue4dTcH+V1YkCSZOcdZvmu7vutXfcciix+U6qA6VHweICVAuDQNVUn
         xmJpOpKEyMAsWfi8n7UjTxnIMp424P7RhLD9u2xB4qskekzwkVVqm7R01SA66Z1TZB
         Hp6hu5TaUnGE8/dJwGA79mqPbq1rYhdYeLAQRfj3M7spnFW2MBpRF1oA/L43Ust2wO
         is2ZnJ9S1c6r2ME0uSWDXQl8RkZQpoWgyV4yCsNnFOWCdfaanauld2RulpiegK4MPR
         7wfoDDiqafHRZEdmXOnvCHi1w/aXeNKXfcEQRyWoqqLejWiKT4apRjkGt0ukZuhscr
         NNHHYmdlnlHFQ==
Date:   Tue, 19 Jan 2021 20:31:57 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/2] xfs_repair: fix unmount error message to have a newline
Message-ID: <20210120043157.GY3134581@magnolia>
References: <161076028124.3386490.8050189989277321393.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161076028124.3386490.8050189989277321393.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a newline so that this is consistent with the other error messages.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/xfs_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 724661d8..9409f0d8 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1136,7 +1136,7 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	error = -libxfs_umount(mp);
 	if (error)
 		do_error(
-	_("File system metadata writeout failed, err=%d.  Re-run xfs_repair."),
+	_("File system metadata writeout failed, err=%d.  Re-run xfs_repair.\n"),
 				error);
 
 	libxfs_destroy(&x);
