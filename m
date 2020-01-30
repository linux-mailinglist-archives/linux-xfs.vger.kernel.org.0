Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 328E514DC06
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Jan 2020 14:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgA3Ndx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 30 Jan 2020 08:33:53 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33206 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgA3Ndx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 08:33:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=C1d8KuEbK2pxA22gKm229HUgliZ6OKog/UXmYn6Pwpg=; b=DMY+xj/utsHLvF2DHol0BT0iMd
        ocUx/Ts81vifDp7y60NSFCYgscpBDvEmVimRUpxtgMjjAjtGmjIElaZL//PkQK3Liis57iUj0OWNF
        +flnFQ3IyboB83EQ9/iUbshCt279FFFiy5dwYFv3kl9nd2WxIaqZ0PYcrZWknBeSO6CwQvxSPAPbk
        En3z4oqtTYHt0kCYjN7EhZ0YoWS6qZ6dSlKz7kV1092CZXL0QFQqlMDX1yeQASbmV8xG55Frkob2f
        84Bpue4m6LjLXk/67COdq5KckIusezWWcdvrmiKMcw8nLJ76HSeGqYW5GIv5ec4SlbLqm0AZDMwhD
        I2UDlGmg==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ix9xA-0003vc-3t; Thu, 30 Jan 2020 13:33:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/6] xfs: remove the xfs_agfl_t typedef
Date:   Thu, 30 Jan 2020 14:33:39 +0100
Message-Id: <20200130133343.225818-3-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200130133343.225818-1-hch@lst.de>
References: <20200130133343.225818-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is just a single user left, so remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

