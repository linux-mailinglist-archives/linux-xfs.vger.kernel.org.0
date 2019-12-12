Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE3D11CB63
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Dec 2019 11:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbfLLKzG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Dec 2019 05:55:06 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53232 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbfLLKzG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 05:55:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=X1AWuuJvR+fGIWLm4WtaJi/43mzoC+WUsduQBweJj50=; b=V784SVvtWedAJXlEC4tFLfIoKN
        D1egcyJOc3W1S2dzWL0GkUe3wYHgcs78wbuuqTw+awDSudOZ4hs7Q9+8n0Rvhi6bjOmqTiWXIgib0
        XO2N7NpuwWa4dOztu+JiSVYavF+/H1zyRch4bjjBdvJhrqfuRjo6l8l6+VcUHKtCCd25iXqPjXMMa
        3se1IwTM0h5DBMe8g1tH/ah6MdG71W+br1bBZcreG1qLCA6XnXkmueiUrD3X18SXWatSw2RG2rb2T
        vBEOKaMtBFS8AeuarP1vxfhrE1k4sEC4dwdyQxoZ+6TeQ/ryAJM3DF7ngFOgtn43DhAW/up21DPWx
        hz43QBVw==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifM7d-0001UG-Jt; Thu, 12 Dec 2019 10:55:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 11/33] xfs: remove the MAXNAMELEN check from xfs_attr_args_init
Date:   Thu, 12 Dec 2019 11:54:11 +0100
Message-Id: <20191212105433.1692-12-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212105433.1692-1-hch@lst.de>
References: <20191212105433.1692-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

All the callers already check the length when allocating the
in-kernel xattrs buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 4a120a6483ee..31cc42c46437 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -71,9 +71,6 @@ xfs_attr_args_init(
 	args->flags = flags;
 	args->name = name;
 	args->namelen = strlen((const char *)name);
-	if (args->namelen >= MAXNAMELEN)
-		return -EFAULT;		/* match IRIX behaviour */
-
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	return 0;
 }
-- 
2.20.1

