Return-Path: <linux-xfs+bounces-493-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A182807E74
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 03:27:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FC82282647
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 02:27:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DDCF1847;
	Thu,  7 Dec 2023 02:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vFl/mQlJ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6A31845
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF6AC433C7;
	Thu,  7 Dec 2023 02:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916066;
	bh=K7fukwV1TrZtcvOVjyztET0SLqNWVgmsxhIBSrbWnMw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vFl/mQlJQL2ld6MkMjqfttgNslqtxJlxtaoWAu9/hoRmK1f6eSfiMDVHI7a2dXVf1
	 VeP7VVHsfJBpUw0nrpCtb/oWrH6AwPLKw12R7Zqi17yTDVcxvp/63d/ZF6fYKqN8In
	 movrrHTic4EOsoMI6JopiVx36meScv/Bqjlt9HMSkH0l8D7xqTgHiZPV9GA5onCq5B
	 4+DJyQ2Iy9UKcKuTXvwFIALj9Suvdvp8K2LWKewhqn/pYrlgggZow1YMaRdvaSmysg
	 S067dM8AsCY+65WtbQb/v2kcYkWjdhHZ81ZHX/L3yjLoK3ayLRrbRJ4L3JekHnnqkE
	 VR7m8MzCTsR6A==
Date: Wed, 06 Dec 2023 18:27:46 -0800
Subject: [PATCH 1/3] xfs: make rextslog computation consistent with mkfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191562892.1133665.6195938058227769172.stgit@frogsfrogsfrogs>
In-Reply-To: <170191562871.1133665.6520990725805302209.stgit@frogsfrogsfrogs>
References: <170191562871.1133665.6520990725805302209.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_rtbitmap.c |   12 ++++++++++++
 fs/xfs/libxfs/xfs_rtbitmap.h |    3 +++
 fs/xfs/libxfs/xfs_sb.c       |    3 ++-
 fs/xfs/xfs_rtalloc.c         |    4 ++--
 4 files changed, 19 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index c269d704314d..1c9fed76a356 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1130,6 +1130,18 @@ xfs_rtbitmap_blockcount(
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
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index c0637057d69c..6e5bae324cc3 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
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
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 1f74d0cd1618..df12bf82ed18 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -25,6 +25,7 @@
 #include "xfs_da_format.h"
 #include "xfs_health.h"
 #include "xfs_ag.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -509,7 +510,7 @@ xfs_validate_sb_common(
 				       NBBY * sbp->sb_blocksize);
 
 		if (sbp->sb_rextents != rexts ||
-		    sbp->sb_rextslog != xfs_highbit32(sbp->sb_rextents) ||
+		    sbp->sb_rextslog != xfs_compute_rextslog(rexts) ||
 		    sbp->sb_rbmblocks != rbmblocks) {
 			xfs_notice(mp,
 				"realtime geometry sanity check failed");
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 88c48de5c9c8..7c5a50163d2d 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -964,7 +964,7 @@ xfs_growfs_rt(
 	nrextents = nrblocks;
 	do_div(nrextents, in->extsize);
 	nrbmblocks = xfs_rtbitmap_blockcount(mp, nrextents);
-	nrextslog = xfs_highbit32(nrextents);
+	nrextslog = xfs_compute_rextslog(nrextents);
 	nrsumlevels = nrextslog + 1;
 	nrsumblocks = xfs_rtsummary_blockcount(mp, nrsumlevels, nrbmblocks);
 	nrsumsize = XFS_FSB_TO_B(mp, nrsumblocks);
@@ -1031,7 +1031,7 @@ xfs_growfs_rt(
 		nsbp->sb_rblocks = min(nrblocks, nrblocks_step);
 		nsbp->sb_rextents = xfs_rtb_to_rtx(nmp, nsbp->sb_rblocks);
 		ASSERT(nsbp->sb_rextents != 0);
-		nsbp->sb_rextslog = xfs_highbit32(nsbp->sb_rextents);
+		nsbp->sb_rextslog = xfs_compute_rextslog(nsbp->sb_rextents);
 		nrsumlevels = nmp->m_rsumlevels = nsbp->sb_rextslog + 1;
 		nrsumblocks = xfs_rtsummary_blockcount(mp, nrsumlevels,
 				nsbp->sb_rbmblocks);


