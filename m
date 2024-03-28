Return-Path: <linux-xfs+bounces-4845-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22A1487A11A
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Mar 2024 02:56:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46FEE1C22343
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Mar 2024 01:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17C1BA2D;
	Wed, 13 Mar 2024 01:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l+rvIx9s"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83330BA27
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294955; cv=none; b=K5+k6vXveZAQInSLiz5//dmhpf6kwo+eJrQ9kSscoi1vVRNdkpc8FqMGIQSjcBMj0TScnPDxjG2C9v3n012xv3llV5l/qDqtsAkEQAn9dZmYYCb9opliqOp2ar5x2st2rJMziH82RSqYgWGBx8E1E1DgmIezif/oUh5cP1EqZKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294955; c=relaxed/simple;
	bh=d6rTUXZ7kYypfJwsm08JPTYHdJ+3X27YwWjSsS0Iz2g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OdOnDPnwwNVWfCV911y7rJf3Rhm0StqRvKBKbH4MbjtcvEpYWFfr3C9i3lkCAXkdc8SjyvPbIxWVK58J9PfIsxSe4GT0JQyAuI7nIEc8ApMSf328kr0kFjJfVT2TqSb6yD3uCcXOpGniPUMNErU0F08e3YKsIJYA6ZMmfRMMFzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l+rvIx9s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB93C433C7;
	Wed, 13 Mar 2024 01:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294955;
	bh=d6rTUXZ7kYypfJwsm08JPTYHdJ+3X27YwWjSsS0Iz2g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l+rvIx9sfpjDoKr+0V9bcl7VOMSMvc3S9RY4Dd2xDC0vM0mLawAcPe8jnDSwB/zpT
	 Op9Io6hpPP19+rvBoiK1DxBsbRcyASO/Ulvly7lGDiOdwiaKj/mK5CBnslMAgT+jMG
	 fKKb4N3foXpv5X+5Dq6RiHWpJEUSyYCBBpHeNsDUZvvKrfZSOGIRLqgol6+ITyKEzR
	 ln253HB2NOarVM8ZzpZYvGmjB5PQLDGHk53Vp1QWELOKenp9uOihPrSyjulXrjAq7Z
	 AoxQkWRJLl67XVWfobkbGIhJriGVlNVZTUEUW+8nwSBT91WwIFv97e4lAHpEIxQ3bG
	 MUgKqw8MW8L/A==
Date: Tue, 12 Mar 2024 18:55:54 -0700
Subject: [PATCH 11/67] xfs: make rextslog computation consistent with mkfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431352.2061787.5103765620056600374.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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

Source kernel commit: a6a38f309afc4a7ede01242b603f36c433997780

There's a weird discrepancy in xfsprogs dating back to the creation of
the Linux port -- if there are zero rt extents, mkfs will set
sb_rextents and sb_rextslog both to zero:

sbp->sb_rextslog =
(uint8_t)(rtextents ?
libxfs_highbit32((unsigned int)rtextents) : 0);

However, that's not the check that xfs_repair uses for nonzero rtblocks:

if (sb->sb_rextslog !=
libxfs_highbit32((unsigned int)sb->sb_rextents))

The difference here is that xfs_highbit32 returns -1 if its argument is
zero.  Unfortunately, this means that in the weird corner case of a
realtime volume shorter than 1 rt extent, xfs_repair will immediately
flag a freshly formatted filesystem as corrupt.  Because mkfs has been
writing ondisk artifacts like this for decades, we have to accept that
as "correct".  TBH, zero rextslog for zero rtextents makes more sense to
me anyway.

Regrettably, the superblock verifier checks created in commit copied
xfs_repair even though mkfs has been writing out such filesystems for
ages.  Fix the superblock verifier to accept what mkfs spits out; the
userspace version of this patch will have to fix xfs_repair as well.

Note that the new helper leaves the zeroday bug where the upper 32 bits
of sb_rextents is ripped off and fed to highbit32.  This leads to a
seriously undersized rt summary file, which immediately breaks mkfs:

$ hugedisk.sh foo /dev/sdc $(( 0x100000080 * 4096))B
$ /sbin/mkfs.xfs -f /dev/sda -m rmapbt=0,reflink=0 -r rtdev=/dev/mapper/foo
meta-data=/dev/sda               isize=512    agcount=4, agsize=1298176 blks
=                       sectsz=512   attr=2, projid32bit=1
=                       crc=1        finobt=1, sparse=1, rmapbt=0
=                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
data     =                       bsize=4096   blocks=5192704, imaxpct=25
=                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
=                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =/dev/mapper/foo        extsz=4096   blocks=4294967424, rtextents=4294967424
Discarding blocks...Done.
mkfs.xfs: Error initializing the realtime space [117 - Structure needs cleaning]

The next patch will drop support for rt volumes with fewer than 1 or
more than 2^32-1 rt extents, since they've clearly been broken forever.

Fixes: f8e566c0f5e1f ("xfs: validate the realtime geometry in xfs_validate_sb_common")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/xfs_rtbitmap.c    |   12 ++++++++++++
 libxfs/xfs_rtbitmap.h    |    3 +++
 libxfs/xfs_sb.c          |    3 ++-
 mkfs/xfs_mkfs.c          |    3 +--
 repair/sb.c              |    3 +--
 6 files changed, 20 insertions(+), 5 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index cee0df2479c5..1828e4773555 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -64,6 +64,7 @@
 #define xfs_bunmapi			libxfs_bunmapi
 #define xfs_bwrite			libxfs_bwrite
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
+#define xfs_compute_rextslog		libxfs_compute_rextslog
 #define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
 #define xfs_da_get_buf			libxfs_da_get_buf
 #define xfs_da_hashname			libxfs_da_hashname
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index fb083499070c..90fe9028887a 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1128,6 +1128,18 @@ xfs_rtbitmap_blockcount(
 	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
 }
 
+/*
+ * Compute the maximum level number of the realtime summary file, as defined by
+ * mkfs.  The use of highbit32 on a 64-bit quantity is a historic artifact that
+ * prohibits correct use of rt volumes with more than 2^32 extents.
+ */
+uint8_t
+xfs_compute_rextslog(
+	xfs_rtbxlen_t		rtextents)
+{
+	return rtextents ? xfs_highbit32(rtextents) : 0;
+}
+
 /*
  * Compute the number of rtbitmap words needed to populate every block of a
  * bitmap that is large enough to track the given number of rt extents.
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index c0637057d69c..6e5bae324cc3 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -351,6 +351,8 @@ xfs_rtfree_extent(
 int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 		xfs_filblks_t rtlen);
 
+uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
+
 xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
 		rtextents);
 unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
@@ -369,6 +371,7 @@ unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
 # define xfs_rtsummary_read_buf(a,b)			(-ENOSYS)
 # define xfs_rtbuf_cache_relse(a)			(0)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
+# define xfs_compute_rextslog(rtx)			(0)
 static inline xfs_filblks_t
 xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 {
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 1ebdb7ec41f4..95a29bf1ffcf 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -23,6 +23,7 @@
 #include "xfs_da_format.h"
 #include "xfs_health.h"
 #include "xfs_ag.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -507,7 +508,7 @@ xfs_validate_sb_common(
 				       NBBY * sbp->sb_blocksize);
 
 		if (sbp->sb_rextents != rexts ||
-		    sbp->sb_rextslog != xfs_highbit32(sbp->sb_rextents) ||
+		    sbp->sb_rextslog != xfs_compute_rextslog(rexts) ||
 		    sbp->sb_rbmblocks != rbmblocks) {
 			xfs_notice(mp,
 				"realtime geometry sanity check failed");
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b8e2c0da60c4..abea61943652 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3699,8 +3699,7 @@ finish_superblock_setup(
 	sbp->sb_agcount = (xfs_agnumber_t)cfg->agcount;
 	sbp->sb_rbmblocks = cfg->rtbmblocks;
 	sbp->sb_logblocks = (xfs_extlen_t)cfg->logblocks;
-	sbp->sb_rextslog = (uint8_t)(cfg->rtextents ?
-			libxfs_highbit32((unsigned int)cfg->rtextents) : 0);
+	sbp->sb_rextslog = libxfs_compute_rextslog(cfg->rtextents);
 	sbp->sb_inprogress = 1;	/* mkfs is in progress */
 	sbp->sb_imax_pct = cfg->imaxpct;
 	sbp->sb_icount = 0;
diff --git a/repair/sb.c b/repair/sb.c
index dedac53afe7d..384840db1cec 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -475,8 +475,7 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
 		if (sb->sb_rblocks / sb->sb_rextsize != sb->sb_rextents)
 			return(XR_BAD_RT_GEO_DATA);
 
-		if (sb->sb_rextslog !=
-				libxfs_highbit32((unsigned int)sb->sb_rextents))
+		if (sb->sb_rextslog != libxfs_compute_rextslog(sb->sb_rextents))
 			return(XR_BAD_RT_GEO_DATA);
 
 		if (sb->sb_rbmblocks != (xfs_extlen_t) howmany(sb->sb_rextents,


