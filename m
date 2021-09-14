Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63B740A3AB
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Sep 2021 04:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbhINCmd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 Sep 2021 22:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234374AbhINCmd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:42:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0A7B610F9;
        Tue, 14 Sep 2021 02:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587276;
        bh=V9KED14WUY/JT8WgSJwuQfvFxK/DgkFv/Kstl4Y4NW4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mPoeWS+cy/OEzeiwh6tejktOo9teLmcUaiVoqc4zdGlX3D8QOEv8HGSnuCbmhp4AK
         8mFZhpyag9mZKesIuh5p0TVXT0LmCLDVDaCSXhMFHxl6EKN4Sf2JKEu6STCYKCc/Bt
         bEKvhXglAEph4jtM9dqeB62kNXwVoYHgOeH9/OJ6X4Cz/sQI9X/jZDvpNvXkYe+4dH
         a4BSkUrd3XNqKOJS1GjDg1mGbr9Y5fMVQnPYITwv9V1f3RQQQQaH4PHjbDr3OsFGf5
         u+jr5KOvLPWdBI7Qfnft/mOywDko28LHp1buS24YgCC8dgD1RFEMmWJhjx0TZq/73t
         WZAPZwStzNiWQ==
Subject: [PATCH 14/43] xfs: mark the record passed into xchk_btree functions
 as const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:41:16 -0700
Message-ID: <163158727652.1604118.5594733928761021916.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 22ece4e836beff1df528ee09cf21ca5fab7235f5

xchk_btree calls a user-supplied function to validate each btree record
that it finds.  Those functions are not supposed to change the record
data, so mark the parameter const.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_arch.h      |   10 +++++-----
 libxfs/xfs_bmap_btree.c |    2 +-
 libxfs/xfs_bmap_btree.h |    3 ++-
 3 files changed, 8 insertions(+), 7 deletions(-)


diff --git a/include/xfs_arch.h b/include/xfs_arch.h
index 7f973249..d46ae470 100644
--- a/include/xfs_arch.h
+++ b/include/xfs_arch.h
@@ -232,19 +232,19 @@ static inline void be64_add_cpu(__be64 *a, __s64 b)
 	*a = cpu_to_be64(be64_to_cpu(*a) + b);
 }
 
-static inline uint16_t get_unaligned_be16(void *p)
+static inline uint16_t get_unaligned_be16(const void *p)
 {
-	uint8_t *__p = p;
+	const uint8_t *__p = p;
 	return __p[0] << 8 | __p[1];
 }
 
-static inline uint32_t get_unaligned_be32(void *p)
+static inline uint32_t get_unaligned_be32(const void *p)
 {
-	uint8_t *__p = p;
+	const uint8_t *__p = p;
         return (uint32_t)__p[0] << 24 | __p[1] << 16 | __p[2] << 8 | __p[3];
 }
 
-static inline uint64_t get_unaligned_be64(void *p)
+static inline uint64_t get_unaligned_be64(const void *p)
 {
 	return (uint64_t)get_unaligned_be32(p) << 32 |
 			   get_unaligned_be32(p + 4);
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index acaf2941..9e2e9926 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -56,7 +56,7 @@ xfs_bmdr_to_bmbt(
 
 void
 xfs_bmbt_disk_get_all(
-	struct xfs_bmbt_rec	*rec,
+	const struct xfs_bmbt_rec *rec,
 	struct xfs_bmbt_irec	*irec)
 {
 	uint64_t		l0 = get_unaligned_be64(&rec->l0);
diff --git a/libxfs/xfs_bmap_btree.h b/libxfs/xfs_bmap_btree.h
index 209ded1e..eda85512 100644
--- a/libxfs/xfs_bmap_btree.h
+++ b/libxfs/xfs_bmap_btree.h
@@ -90,7 +90,8 @@ extern void xfs_bmdr_to_bmbt(struct xfs_inode *, xfs_bmdr_block_t *, int,
 void xfs_bmbt_disk_set_all(struct xfs_bmbt_rec *r, struct xfs_bmbt_irec *s);
 extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(const struct xfs_bmbt_rec *r);
 extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(const struct xfs_bmbt_rec *r);
-extern void xfs_bmbt_disk_get_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
+void xfs_bmbt_disk_get_all(const struct xfs_bmbt_rec *r,
+		struct xfs_bmbt_irec *s);
 
 extern void xfs_bmbt_to_bmdr(struct xfs_mount *, struct xfs_btree_block *, int,
 			xfs_bmdr_block_t *, int);

