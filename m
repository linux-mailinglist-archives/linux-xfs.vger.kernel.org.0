Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC26655EFEE
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Jun 2022 22:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiF1UuV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 28 Jun 2022 16:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiF1UuU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993AC31217
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58F98B81F9B
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBBFC341C8;
        Tue, 28 Jun 2022 20:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449417;
        bh=BpNgYnemVpSVhxSFmNxo4gilw7P95eSWUPxzEYc37WU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SiRgc1ytmTJsQxXbQHWm66rl0vblJ7rgVZPFVtmY5jXA0OfZkGBE//d+Oaq/uLBX1
         hNV6CYmF1JsPhyyUWqd6FBcKlCIVHQ+OgtlcmPxNVMcqXp90sbgluWo1+kRvTFinQK
         x6T/lc2Lg61g4Q99g60WVqP8oM+RkLH9Q3Wl7Q0alNHRJhoknz8OyVPCfvwscuMxUS
         weW9N6Nv/guni7kAIETL3sv4+RAVPWEnmCxXWJBLKPcMHnr/SY95JHRGans6IsWrft
         78Hbtg8JAuAtsXMtYpVxPPH3rjr7l17ITqENiJ2DxHzqX1Ul03DlL+Y2LUjyIvbtOO
         7KgwZt4A5EdQw==
Subject: [PATCH 2/3] xfs_repair: check the rt bitmap against observations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:50:16 -0700
Message-ID: <165644941673.1091513.8109286212253240028.stgit@magnolia>
In-Reply-To: <165644940561.1091513.10430076522811115702.stgit@magnolia>
References: <165644940561.1091513.10430076522811115702.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach xfs_repair to check the ondisk realtime bitmap against its own
observations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 repair/phase5.c |    1 
 repair/rt.c     |  168 ++++++++++++++++++++++++++-----------------------------
 repair/rt.h     |   11 ++--
 3 files changed, 86 insertions(+), 94 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 273f51a8..d1ddd224 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -608,6 +608,7 @@ check_rtmetadata(
 {
 	rtinit(mp);
 	generate_rtinfo(mp, btmcompute, sumcompute);
+	check_rtbitmap(mp);
 }
 
 void
diff --git a/repair/rt.c b/repair/rt.c
index 3a065f4b..b964d168 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -119,6 +119,85 @@ generate_rtinfo(xfs_mount_t	*mp,
 	return(0);
 }
 
+static void
+check_rtfile_contents(
+	struct xfs_mount	*mp,
+	const char		*filename,
+	xfs_ino_t		ino,
+	void			*buf,
+	xfs_fileoff_t		filelen)
+{
+	struct xfs_bmbt_irec	map;
+	struct xfs_buf		*bp;
+	struct xfs_inode	*ip;
+	xfs_fileoff_t		bno = 0;
+	int			error;
+
+	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
+	if (error) {
+		do_warn(_("unable to open %s file, err %d\n"), filename, error);
+		return;
+	}
+
+	if (ip->i_disk_size != XFS_FSB_TO_B(mp, filelen)) {
+		do_warn(_("expected %s file size %llu, found %llu\n"),
+				filename,
+				(unsigned long long)XFS_FSB_TO_B(mp, filelen),
+				(unsigned long long)ip->i_disk_size);
+	}
+
+	while (bno < filelen)  {
+		xfs_filblks_t	maplen;
+		int		nmap = 1;
+
+		/* Read up to 1MB at a time. */
+		maplen = min(filelen - bno, XFS_B_TO_FSBT(mp, 1048576));
+		error = -libxfs_bmapi_read(ip, bno, maplen, &map, &nmap, 0);
+		if (error) {
+			do_warn(_("unable to read %s mapping, err %d\n"),
+					filename, error);
+			break;
+		}
+
+		if (map.br_startblock == HOLESTARTBLOCK) {
+			do_warn(_("hole in %s file at dblock 0x%llx\n"),
+					filename, (unsigned long long)bno);
+			break;
+		}
+
+		error = -libxfs_buf_read_uncached(mp->m_dev,
+				XFS_FSB_TO_DADDR(mp, map.br_startblock),
+				XFS_FSB_TO_BB(mp, map.br_blockcount),
+				0, &bp, NULL);
+		if (error) {
+			do_warn(_("unable to read %s at dblock 0x%llx, err %d\n"),
+					filename, (unsigned long long)bno, error);
+			break;
+		}
+
+		if (memcmp(bp->b_addr, buf, mp->m_sb.sb_blocksize))
+			do_warn(_("discrepancy in %s at dblock 0x%llx\n"),
+					filename, (unsigned long long)bno);
+
+		buf += XFS_FSB_TO_B(mp, map.br_blockcount);
+		bno += map.br_blockcount;
+		libxfs_buf_relse(bp);
+	}
+
+	libxfs_irele(ip);
+}
+
+void
+check_rtbitmap(
+	struct xfs_mount	*mp)
+{
+	if (need_rbmino)
+		return;
+
+	check_rtfile_contents(mp, "rtbitmap", mp->m_sb.sb_rbmino, btmcompute,
+			mp->m_sb.sb_rbmblocks);
+}
+
 #if 0
 /*
  * returns 1 if bad, 0 if good
@@ -151,95 +230,6 @@ check_summary(xfs_mount_t *mp)
 	return(error);
 }
 
-/*
- * examine the real-time bitmap file and compute summary
- * info off it.  Should probably be changed to compute
- * the summary information off the incore computed bitmap
- * instead of the realtime bitmap file
- */
-void
-process_rtbitmap(
-	struct xfs_mount	*mp,
-	struct xfs_dinode	*dino,
-	blkmap_t		*blkmap)
-{
-	int			error;
-	int			bit;
-	int			bitsperblock;
-	int			bmbno;
-	int			end_bmbno;
-	xfs_fsblock_t		bno;
-	struct xfs_buf		*bp;
-	xfs_rtblock_t		extno;
-	int			i;
-	int			len;
-	int			log;
-	int			offs;
-	int			prevbit;
-	int			start_bmbno;
-	int			start_bit;
-	xfs_rtword_t		*words;
-
-	ASSERT(mp->m_rbmip == NULL);
-
-	bitsperblock = mp->m_sb.sb_blocksize * NBBY;
-	prevbit = 0;
-	extno = 0;
-	error = 0;
-
-	end_bmbno = howmany(be64_to_cpu(dino->di_size),
-						mp->m_sb.sb_blocksize);
-
-	for (bmbno = 0; bmbno < end_bmbno; bmbno++) {
-		bno = blkmap_get(blkmap, bmbno);
-
-		if (bno == NULLFSBLOCK) {
-			do_warn(_("can't find block %d for rtbitmap inode\n"),
-					bmbno);
-			error = 1;
-			continue;
-		}
-		error = -libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
-				XFS_FSB_TO_BB(mp, 1), 0, NULL, &bp);
-		if (error) {
-			do_warn(_("can't read block %d for rtbitmap inode\n"),
-					bmbno);
-			error = 1;
-			continue;
-		}
-		words = (xfs_rtword_t *)bp->b_un.b_addr;
-		for (bit = 0;
-		     bit < bitsperblock && extno < mp->m_sb.sb_rextents;
-		     bit++, extno++) {
-			if (xfs_isset(words, bit)) {
-				set_rtbmap(extno, XR_E_FREE);
-				sb_frextents++;
-				if (prevbit == 0) {
-					start_bmbno = bmbno;
-					start_bit = bit;
-					prevbit = 1;
-				}
-			} else if (prevbit == 1) {
-				len = (bmbno - start_bmbno) * bitsperblock +
-					(bit - start_bit);
-				log = XFS_RTBLOCKLOG(len);
-				offs = XFS_SUMOFFS(mp, log, start_bmbno);
-				sumcompute[offs]++;
-				prevbit = 0;
-			}
-		}
-		libxfs_buf_relse(bp);
-		if (extno == mp->m_sb.sb_rextents)
-			break;
-	}
-	if (prevbit == 1) {
-		len = (bmbno - start_bmbno) * bitsperblock + (bit - start_bit);
-		log = XFS_RTBLOCKLOG(len);
-		offs = XFS_SUMOFFS(mp, log, start_bmbno);
-		sumcompute[offs]++;
-	}
-}
-
 /*
  * copy the real-time summary file data into memory
  */
diff --git a/repair/rt.h b/repair/rt.h
index f5d8f80c..2023153f 100644
--- a/repair/rt.h
+++ b/repair/rt.h
@@ -3,6 +3,8 @@
  * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
+#ifndef _XFS_REPAIR_RT_H_
+#define _XFS_REPAIR_RT_H_
 
 struct blkmap;
 
@@ -14,17 +16,16 @@ generate_rtinfo(xfs_mount_t	*mp,
 		xfs_rtword_t	*words,
 		xfs_suminfo_t	*sumcompute);
 
+void check_rtbitmap(struct xfs_mount *mp);
+
 #if 0
 
 int
 check_summary(xfs_mount_t	*mp);
 
-void
-process_rtbitmap(xfs_mount_t		*mp,
-		struct xfs_dinode	*dino,
-		struct blkmap		*blkmap);
-
 void
 process_rtsummary(xfs_mount_t	*mp,
 		struct blkmap	*blkmap);
 #endif
+
+#endif /* _XFS_REPAIR_RT_H_ */

