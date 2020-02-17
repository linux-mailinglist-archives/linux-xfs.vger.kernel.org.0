Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6ED161279
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 14:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgBQNAW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 08:00:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58826 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbgBQNAV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 08:00:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=1LTHh98ZJAKy1fc8Nhf/UZn9JkVlnR4nsJNerDnGWLY=; b=CkJpOqi9kqMaBF/N4dZBew7zjo
        AayxLmvNzV/LVAHoEJnURE4DiKxGFx5HkWmvqIUjSM0ApCH/4+io4P+L6J+3sP9BwBkhpY0ST3nJo
        jzK40NmxOfTNsqM17vWlreiCrqrZL/po142q2zSjdY7cB5CSVDSTe5cNUJvSUswJ/aTLi/PKeMsaA
        Zkz9DRQgHbdMwgvMK9RrEq98p3yCSuuo1htTDCous+VBFqNz18Xn8ZAsXEdSC0sSPqdFyYAPgzg5U
        wmCPePQL1DTno6n9JFEwlrXjB28D3dJxwr00gs7agFFKs3ZtgHCbOZYQUA1BRXoFPQPDMhh/o+ZK5
        p9yLu7WA==;
Received: from [88.128.92.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3g0b-0001Ai-8F; Mon, 17 Feb 2020 13:00:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: [PATCH 07/31] xfs: remove the name == NULL check from xfs_attr_args_init
Date:   Mon, 17 Feb 2020 13:59:33 +0100
Message-Id: <20200217125957.263434-8-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217125957.263434-1-hch@lst.de>
References: <20200217125957.263434-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

All callers provide a valid name pointer, remove the redundant check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index bb391b96cd78..a968158b9bb1 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -65,10 +65,6 @@ xfs_attr_args_init(
 	size_t			namelen,
 	int			flags)
 {
-
-	if (!name)
-		return -EINVAL;
-
 	memset(args, 0, sizeof(*args));
 	args->geo = dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
-- 
2.24.1

