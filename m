Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4E117C0EB
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Mar 2020 15:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgCFOwV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 6 Mar 2020 09:52:21 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52840 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgCFOwV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 09:52:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=T/1kLcsUG+qe6YVjdR34X81DFo7ZIPPBEiyqjCfh/bE=; b=jtstrtKZV5Qe7rLiedWqsqR8Uz
        +dQIE1yYakDFeG53P8m5U7aL84RcWbM+5d/My8/yrq40RNVkkv/KYA2bjowQnaezTy/c4kvC1Jrh8
        xCruWpv7uyIl8PyoIizDp1uIFp+ZAn6d9NcCUj3RGLgvPD21trN5TpmLV4Z0pDQ2r4iuq/fyFI08L
        2EMjZCdJEKBwPMHLWtipmBZXbSs9WrX4U45GFkOcl0nrI/I59Z/XARK50IJdwH/kAIQ1rRfnakKpC
        agVFSSXXhd4+IrcHvup+1jwF/wVdljqglR4XW6T7PqsMMdnbtXQxH1L9Ifuier8ZrWvMXEOUkBN8m
        ExF3RzIg==;
Received: from [162.248.129.185] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jAEKq-0008BC-Oo; Fri, 06 Mar 2020 14:52:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/6] xfs: remove the xfs_agfl_t typedef
Date:   Fri,  6 Mar 2020 07:52:16 -0700
Message-Id: <20200306145220.242562-3-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306145220.242562-1-hch@lst.de>
References: <20200306145220.242562-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is just a single user left, so remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 8c7aea7795da..11a450e00231 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -783,15 +783,15 @@ typedef struct xfs_agi {
  */
 #define XFS_AGFL_DADDR(mp)	((xfs_daddr_t)(3 << (mp)->m_sectbb_log))
 #define	XFS_AGFL_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGFL_DADDR(mp))
-#define	XFS_BUF_TO_AGFL(bp)	((xfs_agfl_t *)((bp)->b_addr))
+#define	XFS_BUF_TO_AGFL(bp)	((struct xfs_agfl *)((bp)->b_addr))
 
-typedef struct xfs_agfl {
+struct xfs_agfl {
 	__be32		agfl_magicnum;
 	__be32		agfl_seqno;
 	uuid_t		agfl_uuid;
 	__be64		agfl_lsn;
 	__be32		agfl_crc;
-} __attribute__((packed)) xfs_agfl_t;
+} __attribute__((packed));
 
 #define XFS_AGFL_CRC_OFF	offsetof(struct xfs_agfl, agfl_crc)
 
-- 
2.24.1

