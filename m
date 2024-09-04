Return-Path: <linux-xfs+bounces-12638-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E956969A13
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Sep 2024 12:25:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72FF91C22D04
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Sep 2024 10:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E5171AD26D;
	Tue,  3 Sep 2024 10:25:15 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611C345003
	for <linux-xfs@vger.kernel.org>; Tue,  3 Sep 2024 10:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725359115; cv=none; b=V8HU3UmTJKyKyWpoyN3vw0xuugjoTA+c29oY6NoC7sfuMS2lOGhyu7QDgtdCDLBglBHK/hiS12uFbRQEfhRrFHnt+R79roEWW0TH3QC0cwMe01KMb0tRuiDyL1PabU8Lu8Lz/gQJb7rkmsTd69M3U0W5QI0EH1ELBcUkmBOSl3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725359115; c=relaxed/simple;
	bh=8Yz07rpXso3xAZzingi7zmKQASNI4hY8Sys/I6P8RqQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ezV9dyUDTiPnMyzeQPd7Agx/hgmgPKgnDIeXNU8vwtC0co/7uQID254QTpXCziJP3x7tGZBAMB35/220vA+Q6Z284T3t2l5QFDuRvONMHVhS2KzzO47uKJ+KATZ9I5Z7yz3HpVDZ/Q5Sq2lWLAquhTx80C8ewwaIn0ELhq4+V18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: c351bcea69de11efa216b1d71e6e1362-20240903
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI
	AMN_C_BU, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:a2cd2a2f-ebcb-4539-bab0-dc8a76335a3f,IP:10,
	URL:0,TC:0,Content:-5,EDM:-25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,AC
	TION:release,TS:-25
X-CID-INFO: VERSION:1.1.38,REQID:a2cd2a2f-ebcb-4539-bab0-dc8a76335a3f,IP:10,UR
	L:0,TC:0,Content:-5,EDM:-25,RT:0,SF:-5,FILE:0,BULK:0,RULE:EDM_GE969F26,ACT
	ION:release,TS:-25
X-CID-META: VersionHash:82c5f88,CLOUDID:a0a12df3f4596bf489de12d15150d899,BulkI
	D:240903182036LKO2L66X,BulkQuantity:1,Recheck:0,SF:66|25|17|19|43|74|102,T
	C:nil,Content:0,EDM:1,IP:-2,URL:11|1,File:nil,RT:nil,Bulk:40,QS:nil,BEC:ni
	l,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_FSI,TF_CID_SPAM_ULN,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,
	TF_CID_SPAM_FSD
X-UUID: c351bcea69de11efa216b1d71e6e1362-20240903
X-User: liuhuan01@kylinos.cn
Received: from localhost.localdomain [(123.53.36.118)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 309782053; Tue, 03 Sep 2024 18:24:55 +0800
From: liuhuan01@kylinos.cn
To: david@fromorbit.com
Cc: cmaiolino@redhat.com,
	djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	liuh <liuhuan01@kylinos.cn>
Subject: [PATCH v3] xfs_db: make sure agblocks is valid to prevent corruption
Date: Tue,  3 Sep 2024 18:24:02 +0800
Message-Id: <20240903102401.14085-1-liuhuan01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ZtZ0Z58+XHoFt84Q@dread.disaster.area>
References: <ZtZ0Z58+XHoFt84Q@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: liuh <liuhuan01@kylinos.cn>

Recently, I was testing xfstests. When I run xfs/350 case, it always generate coredump during the process.
	xfs_db -c "sb 0" -c "p agblocks" /dev/loop1

System will generate signal SIGFPE corrupt the process. And the stack as follow:
corrupt at: (*bpp)->b_pag = xfs_perag_get(btp->bt_mount, xfs_daddr_to_agno(btp->bt_mount, blkno)); in function libxfs_getbuf_flags
	#0  libxfs_getbuf_flags
	#1  libxfs_getbuf_flags
	#2  libxfs_buf_read_map
	#3  libxfs_buf_read
	#4  libxfs_mount
	#5  init
	#6  main

The coredump was caused by the corrupt superblock metadata: (mp)->m_sb.sb_agblocks, it was 0.
In this case, user cannot run in expert mode also.

So, try to get agblocks from agf/agi 0, if agf/agi 0 length match, use it as agblocks.
If failed use the default geometry to calc agblocks.

Signed-off-by: liuh <liuhuan01@kylinos.cn>
---
 db/Makefile |   2 +-
 db/init.c   | 142 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+), 1 deletion(-)

diff --git a/db/Makefile b/db/Makefile
index 83389376..322d5617 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -68,7 +68,7 @@ CFILES = $(HFILES:.h=.c) \
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBURCU) \
-	  $(LIBPTHREAD)
+	  $(LIBPTHREAD) $(LIBBLKID)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS += -static-libtool-libs
 
diff --git a/db/init.c b/db/init.c
index cea25ae5..167bc777 100644
--- a/db/init.c
+++ b/db/init.c
@@ -38,6 +38,138 @@ usage(void)
 	exit(1);
 }
 
+static void
+xfs_guess_default_ag_geometry(uint64_t *agsize, uint64_t *agcount, struct libxfs_init *x)
+{
+	struct fs_topology	ft;
+	int			blocklog;
+	uint64_t		dblocks;
+	int			multidisk;
+
+	fprintf(stderr, "Attempting to guess AG length from device geometry. This may not work.\n");
+
+	memset(&ft, 0, sizeof(ft));
+	get_topology(x, &ft, 1);
+
+	/*
+	 * get geometry from get_topology result.
+	 * Use default block size (2^12)
+	 */
+	blocklog = 12;
+	multidisk = ft.data.swidth | ft.data.sunit;
+	dblocks = x->data.size >> (blocklog - BBSHIFT);
+	calc_default_ag_geometry(blocklog, dblocks, multidisk,
+				 agsize, agcount);
+
+	if (*agsize >= XFS_MIN_AG_BLOCKS && *agsize <= XFS_MAX_AG_BLOCKS)
+		fprintf(stderr, "Guessed AG length is %lu blocks.\n", *agsize);
+}
+
+static xfs_agblock_t
+xfs_get_agblock_from_agf(struct xfs_mount *mp)
+{
+	xfs_agblock_t agblocks = NULLAGBLOCK;
+	int error;
+	struct xfs_buf *bp;
+	struct xfs_agf *agf;
+
+	error = -libxfs_buf_read_uncached(mp->m_ddev_targp,
+			XFS_AGF_DADDR(mp), 1, 0, &bp, NULL);
+	if (error) {
+		fprintf(stderr, "AGF 0 length recovery failed\n");
+		return NULLAGBLOCK;
+	}
+
+	agf = bp->b_addr;
+	if (be32_to_cpu(agf->agf_magicnum) == XFS_AGF_MAGIC)
+		agblocks = be32_to_cpu(agf->agf_length);
+
+	libxfs_buf_relse(bp);
+
+	if (agblocks != NULLAGBLOCK)
+		fprintf(stderr, "AGF 0 length %u blocks found.\n", agblocks);
+	else
+		fprintf(stderr, "AGF 0 length recovery failed.\n");
+
+	return agblocks;
+}
+
+static xfs_agblock_t
+xfs_get_agblock_from_agi(struct xfs_mount *mp)
+{
+	xfs_agblock_t agblocks = NULLAGBLOCK;
+	int error;
+	struct xfs_buf *bp;
+	struct xfs_agi *agi;
+
+	error = -libxfs_buf_read_uncached(mp->m_ddev_targp,
+			XFS_AGI_DADDR(mp), 1, 0, &bp, NULL);
+	if (error) {
+		fprintf(stderr, "AGI 0 length recovery failed\n");
+		return NULLAGBLOCK;
+	}
+
+
+	agi = bp->b_addr;
+	if (be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC)
+		agblocks = be32_to_cpu(agi->agi_length);
+
+	libxfs_buf_relse(bp);
+
+	if (agblocks != NULLAGBLOCK)
+		fprintf(stderr, "AGI 0 length %u blocks found.\n", agblocks);
+	else
+		fprintf(stderr, "AGI 0 length recovery failed.\n");
+
+	return agblocks;
+}
+
+/*
+ * Try to get it from agf/agi length when primary superblock agblocks damaged.
+ * If agf matchs agi length, use it as agblocks, otherwise use the default geometry
+ * to calc agblocks
+ */
+static xfs_agblock_t
+xfs_try_get_agblocks(struct xfs_mount *mp, struct libxfs_init *x)
+{
+	xfs_agblock_t agblocks = NULLAGBLOCK;
+	xfs_agblock_t agblocks_agf, agblocks_agi;
+	uint64_t agsize, agcount;
+
+	fprintf(stderr, "Attempting recovery from AGF/AGI 0 metadata...\n");
+
+	agblocks_agf = xfs_get_agblock_from_agf(mp);
+	agblocks_agi = xfs_get_agblock_from_agi(mp);
+
+	if (agblocks_agf == agblocks_agi && agblocks_agf >= XFS_MIN_AG_BLOCKS && agblocks_agf <= XFS_MAX_AG_BLOCKS) {
+		fprintf(stderr, "AGF/AGI 0 length matches.\n");
+		fprintf(stderr, "Using %u blocks for superblock agblocks\n", agblocks_agf);
+		return agblocks_agf;
+	}
+
+	/* use default geometry to calc agblocks/agcount */
+	xfs_guess_default_ag_geometry(&agsize, &agcount, x);
+
+	/* choose the agblocks among agf/agi length and agsize */
+	if (agblocks_agf == agsize && agsize >= XFS_MIN_AG_BLOCKS && agsize <= XFS_MAX_AG_BLOCKS) {
+		fprintf(stderr, "Guessed AG matchs AGF length\n");
+		agblocks = agsize;
+	} else if (agblocks_agi == agsize && agsize >= XFS_MIN_AG_BLOCKS && agsize <= XFS_MAX_AG_BLOCKS) {
+		fprintf(stderr, "Guessed AG matchs AGI length\n");
+		agblocks = agsize;
+	} else if (agsize >= XFS_MIN_AG_BLOCKS && agsize <= XFS_MAX_AG_BLOCKS) {
+		fprintf(stderr, "Guessed AG does not match AGF/AGI 0 length.\n");
+		agblocks =  agsize;
+	} else {
+		fprintf(stderr, "_(%s: device too small to hold a valid XFS filesystem)", progname);
+		exit(1);
+	}
+
+	fprintf(stderr, "Using %u blocks for superblock agblocks.\n", agblocks);
+
+	return agblocks;
+}
+
 static void
 init(
 	int		argc,
@@ -129,6 +261,16 @@ init(
 		}
 	}
 
+	/* If sb_agblocks was damaged, try to get agblocks */
+	if (sbp->sb_agblocks < XFS_MIN_AG_BLOCKS || sbp->sb_agblocks > XFS_MAX_AG_BLOCKS) {
+		xfs_agblock_t agblocks;
+
+		fprintf(stderr, "Out of bounds superblock agblocks (%u) found.\n", sbp->sb_agblocks);
+
+		agblocks = xfs_try_get_agblocks(&xmount, &x);
+		sbp->sb_agblocks = agblocks;
+	}
+
 	agcount = sbp->sb_agcount;
 	mp = libxfs_mount(&xmount, sbp, &x, LIBXFS_MOUNT_DEBUGGER);
 	if (!mp) {
-- 
2.43.0


