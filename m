Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8545F2500
	for <lists+linux-xfs@lfdr.de>; Sun,  2 Oct 2022 20:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiJBSg7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 2 Oct 2022 14:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiJBSg6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:36:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADBE3B977
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:36:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAC5960F07
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AF7C433C1;
        Sun,  2 Oct 2022 18:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735816;
        bh=xghrJ+Ce7VhZwiGFftbzL/0rsfDwIUT22jJSJrrJ5ek=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aG6TADMxx2FopLcnjD3wjRkLEHiIiUjPi5JYNul7Ncr2jSSyfNiFF9TZgpJYe4yI8
         baJk9H1is3Xg8wviT1i7Ih3LanaZzXsx+lBsgOdso1Yqya9/BmxO/G+Q/0RfhXbEPC
         OcL7TMOKDOKgt9N/P+oqufnA9qa4nHcVGaceIKzq1pELGU7eNG6by1LR4XHRMxHWD0
         ajtw6jAffz3J+viVYrQt100PkxCMp1ih1kga+b2FXVXhW0wssRIzNuw1yjRWeY2hYG
         dQ3/cRJ5rPKIjGfS/BrjcUqvpv54ZEFaWWHh290rUBocMEMEJeHmpVmdjzIt1YnleW
         nwGRScIcwFkDw==
Subject: [PATCH 3/9] xfs: split usedmap from xchk_xattr_buf.buf
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:40 -0700
Message-ID: <166473484039.1085108.17940910529777391591.stgit@magnolia>
In-Reply-To: <166473483982.1085108.101544412199880535.stgit@magnolia>
References: <166473483982.1085108.101544412199880535.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the used space bitmap from somewhere in xchk_xattr_buf.buf[] to an
explicit pointer.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |   39 +++++++++++++++++++++------------------
 fs/xfs/scrub/attr.h |   22 +++++-----------------
 2 files changed, 26 insertions(+), 35 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index a813e914d966..6f3051728da0 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -29,6 +29,8 @@ xchk_xattr_buf_cleanup(
 
 	kvfree(ab->freemap);
 	ab->freemap = NULL;
+	kvfree(ab->usedmap);
+	ab->usedmap = NULL;
 }
 
 /*
@@ -42,20 +44,14 @@ xchk_setup_xattr_buf(
 	size_t			value_size,
 	gfp_t			flags)
 {
-	size_t			sz;
+	size_t			sz = value_size;
 	size_t			bmp_sz;
 	struct xchk_xattr_buf	*ab = sc->buf;
+	unsigned long		*old_usedmap = NULL;
 	unsigned long		*old_freemap = NULL;
 
 	bmp_sz = sizeof(long) * BITS_TO_LONGS(sc->mp->m_attr_geo->blksize);
 
-	/*
-	 * We need enough space to read an xattr value from the file or enough
-	 * space to hold one copy of the xattr free space bitmap.  We don't
-	 * need the buffer space for both purposes at the same time.
-	 */
-	sz = max_t(size_t, bmp_sz, value_size);
-
 	/*
 	 * If there's already a buffer, figure out if we need to reallocate it
 	 * to accommodate a larger size.
@@ -64,6 +60,7 @@ xchk_setup_xattr_buf(
 		if (sz <= ab->sz)
 			return 0;
 		old_freemap = ab->freemap;
+		old_usedmap = ab->usedmap;
 		kvfree(ab);
 		sc->buf = NULL;
 	}
@@ -79,6 +76,14 @@ xchk_setup_xattr_buf(
 	sc->buf = ab;
 	sc->buf_cleanup = xchk_xattr_buf_cleanup;
 
+	if (old_usedmap) {
+		ab->usedmap = old_usedmap;
+	} else {
+		ab->usedmap = kvmalloc(bmp_sz, flags);
+		if (!ab->usedmap)
+			return -ENOMEM;
+	}
+
 	if (old_freemap) {
 		ab->freemap = old_freemap;
 	} else {
@@ -237,7 +242,6 @@ xchk_xattr_set_map(
 STATIC bool
 xchk_xattr_check_freemap(
 	struct xfs_scrub		*sc,
-	unsigned long			*map,
 	struct xfs_attr3_icleaf_hdr	*leafhdr)
 {
 	struct xchk_xattr_buf		*ab = sc->buf;
@@ -254,7 +258,7 @@ xchk_xattr_check_freemap(
 	}
 
 	/* Look for bits that are set in freemap and are marked in use. */
-	return !bitmap_intersects(ab->freemap, map, mapsize);
+	return !bitmap_intersects(ab->freemap, ab->usedmap, mapsize);
 }
 
 /*
@@ -274,7 +278,7 @@ xchk_xattr_entry(
 	__u32				*last_hashval)
 {
 	struct xfs_mount		*mp = ds->state->mp;
-	unsigned long			*usedmap = xchk_xattr_usedmap(ds->sc);
+	struct xchk_xattr_buf		*ab = ds->sc->buf;
 	char				*name_end;
 	struct xfs_attr_leaf_name_local	*lentry;
 	struct xfs_attr_leaf_name_remote *rentry;
@@ -314,7 +318,7 @@ xchk_xattr_entry(
 	if (name_end > buf_end)
 		xchk_da_set_corrupt(ds, level);
 
-	if (!xchk_xattr_set_map(ds->sc, usedmap, nameidx, namesize))
+	if (!xchk_xattr_set_map(ds->sc, ab->usedmap, nameidx, namesize))
 		xchk_da_set_corrupt(ds, level);
 	if (!(ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		*usedbytes += namesize;
@@ -334,7 +338,7 @@ xchk_xattr_block(
 	struct xfs_attr_leafblock	*leaf = bp->b_addr;
 	struct xfs_attr_leaf_entry	*ent;
 	struct xfs_attr_leaf_entry	*entries;
-	unsigned long			*usedmap;
+	struct xchk_xattr_buf		*ab = ds->sc->buf;
 	char				*buf_end;
 	size_t				off;
 	__u32				last_hashval = 0;
@@ -352,10 +356,9 @@ xchk_xattr_block(
 		return -EDEADLOCK;
 	if (error)
 		return error;
-	usedmap = xchk_xattr_usedmap(ds->sc);
 
 	*last_checked = blk->blkno;
-	bitmap_zero(usedmap, mp->m_attr_geo->blksize);
+	bitmap_zero(ab->usedmap, mp->m_attr_geo->blksize);
 
 	/* Check all the padding. */
 	if (xfs_has_crc(ds->sc->mp)) {
@@ -379,7 +382,7 @@ xchk_xattr_block(
 		xchk_da_set_corrupt(ds, level);
 	if (leafhdr.firstused < hdrsize)
 		xchk_da_set_corrupt(ds, level);
-	if (!xchk_xattr_set_map(ds->sc, usedmap, 0, hdrsize))
+	if (!xchk_xattr_set_map(ds->sc, ab->usedmap, 0, hdrsize))
 		xchk_da_set_corrupt(ds, level);
 
 	if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
@@ -393,7 +396,7 @@ xchk_xattr_block(
 	for (i = 0, ent = entries; i < leafhdr.count; ent++, i++) {
 		/* Mark the leaf entry itself. */
 		off = (char *)ent - (char *)leaf;
-		if (!xchk_xattr_set_map(ds->sc, usedmap, off,
+		if (!xchk_xattr_set_map(ds->sc, ab->usedmap, off,
 				sizeof(xfs_attr_leaf_entry_t))) {
 			xchk_da_set_corrupt(ds, level);
 			goto out;
@@ -407,7 +410,7 @@ xchk_xattr_block(
 			goto out;
 	}
 
-	if (!xchk_xattr_check_freemap(ds->sc, usedmap, &leafhdr))
+	if (!xchk_xattr_check_freemap(ds->sc, &leafhdr))
 		xchk_da_set_corrupt(ds, level);
 
 	if (leafhdr.usedbytes != usedbytes)
diff --git a/fs/xfs/scrub/attr.h b/fs/xfs/scrub/attr.h
index e6f11d44e84d..f6f033c19118 100644
--- a/fs/xfs/scrub/attr.h
+++ b/fs/xfs/scrub/attr.h
@@ -10,6 +10,9 @@
  * Temporary storage for online scrub and repair of extended attributes.
  */
 struct xchk_xattr_buf {
+	/* Bitmap of used space in xattr leaf blocks. */
+	unsigned long		*usedmap;
+
 	/* Bitmap of free space in xattr leaf blocks. */
 	unsigned long		*freemap;
 
@@ -17,13 +20,8 @@ struct xchk_xattr_buf {
 	size_t			sz;
 
 	/*
-	 * Memory buffer -- either used for extracting attr values while
-	 * walking the attributes; or for computing attr block bitmaps when
-	 * checking the attribute tree.
-	 *
-	 * Each bitmap contains enough bits to track every byte in an attr
-	 * block (rounded up to the size of an unsigned long).  The attr block
-	 * used space bitmap starts at the beginning of the buffer.
+	 * Memory buffer -- used for extracting attr values while walking the
+	 * attributes.
 	 */
 	uint8_t			buf[];
 };
@@ -38,14 +36,4 @@ xchk_xattr_valuebuf(
 	return ab->buf;
 }
 
-/* A bitmap of space usage computed by walking an attr leaf block. */
-static inline unsigned long *
-xchk_xattr_usedmap(
-	struct xfs_scrub	*sc)
-{
-	struct xchk_xattr_buf	*ab = sc->buf;
-
-	return (unsigned long *)ab->buf;
-}
-
 #endif	/* __XFS_SCRUB_ATTR_H__ */

