Return-Path: <linux-xfs+bounces-16249-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D45689E7D55
	for <lists+linux-xfs@lfdr.de>; Sat,  7 Dec 2024 01:13:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98C561884413
	for <lists+linux-xfs@lfdr.de>; Sat,  7 Dec 2024 00:13:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 964B42581;
	Sat,  7 Dec 2024 00:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iaIX5FT7"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EC62563
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530430; cv=none; b=bNncMFYGff/KD2zt9GaS+1QC44JBS3NaYQF6fP/yox9iYSIfwzUjBmn/NmBoxfIivqa1vEnTVStbd22vEKEnDDZWbQPxVeMurNQc1rK9VzoYrJDH7/ROhlYeZF9tADFHHaFwCqGX3j4szrrnmnGs9W0rHk5Gi0TBeHjO5E8U4gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530430; c=relaxed/simple;
	bh=BUPPsOZQ79uidUdErDBvi1/CKuMVSlrt/iovDRD/sUE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bdO4LNwhPfQBd9ifWAz5D8jGOFs12KkPgJCQlLCK2iV1Hq68NIueAqhAw468WjLCfgC6tg9HBoaM/Ck8LGFODRq/xa3SPXL2Rdo2JqY2ALaBiTnr/mvgEGozLu8s8H6p7kUSg+UYa1kyFt/Y+x9AiaL3Su+USv6qHkweSDPC+4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iaIX5FT7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30239C4CED1;
	Sat,  7 Dec 2024 00:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530430;
	bh=BUPPsOZQ79uidUdErDBvi1/CKuMVSlrt/iovDRD/sUE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iaIX5FT7fANzYzyTYmaG2NjZ0MRcaKIOEhRcMuQmmDekg5tIY9D3MGVdO/sKJkC8Y
	 xw01xLLf4xdYpZGLZs2rOFJoCsMGtU0lh9VOoy6SI9kxu+sUXU7pqEK6aH/N5eb7Lp
	 sy+uWHjHm1gPWUwYJ2vKHJao2BSj1jLO6Dyd/SCfi0/PiZCiIMnZGe3SkCHVZIyUl8
	 EJ94gU7SxyllyUcoaYSbT6S+Zo7vJM6OfOAKLJ93fdHCVbCUcin49irZMot6MwQX+Z
	 YSoUNkaSijn27TqisdHUul037pBSQGetwAZaEbQLik+UJwXlM9WjTPIeeBm9oYL7a3
	 i7aoD86/dDlLg==
Date: Fri, 06 Dec 2024 16:13:49 -0800
Subject: [PATCH 34/50] xfs_db: dump rt summary blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752464.126362.14717338357511129149.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that rtsummary blocks have a header, make it so that xfs_db can
analyze the structure.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/field.c   |    4 ++++
 db/field.h   |    2 ++
 db/inode.c   |    2 ++
 db/rtgroup.c |   20 ++++++++++++++++++++
 db/rtgroup.h |    3 +++
 db/type.c    |    5 +++++
 db/type.h    |    1 +
 7 files changed, 37 insertions(+)


diff --git a/db/field.c b/db/field.c
index ad1ccb9877aca5..ca0fe1826f9a80 100644
--- a/db/field.c
+++ b/db/field.c
@@ -411,6 +411,10 @@ const ftattr_t	ftattrtab[] = {
 	  0, NULL, NULL },
 	{ FLDT_RGBITMAP, "rgbitmap", NULL, (char *)rgbitmap_flds, btblock_size,
 	  FTARG_SIZE, NULL, rgbitmap_flds },
+	{ FLDT_SUMINFO, "suminfo", fp_num, "%u", SI(bitsz(xfs_suminfo_t)),
+	  0, NULL, NULL },
+	{ FLDT_RGSUMMARY, "rgsummary", NULL, (char *)rgsummary_flds,
+	  btblock_size, FTARG_SIZE, NULL, rgsummary_flds },
 
 	{ FLDT_ZZZ, NULL }
 };
diff --git a/db/field.h b/db/field.h
index aace89c90d79eb..1d7465b4d3e562 100644
--- a/db/field.h
+++ b/db/field.h
@@ -198,6 +198,8 @@ typedef enum fldt	{
 
 	FLDT_RTWORD,
 	FLDT_RGBITMAP,
+	FLDT_SUMINFO,
+	FLDT_RGSUMMARY,
 
 	FLDT_ZZZ			/* mark last entry */
 } fldt_t;
diff --git a/db/inode.c b/db/inode.c
index d3207510c28265..0a80b8d063603f 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -715,6 +715,8 @@ inode_next_type(void)
 				return TYP_DQBLK;
 			case XFS_METAFILE_RTBITMAP:
 				return TYP_RGBITMAP;
+			case XFS_METAFILE_RTSUMMARY:
+				return TYP_RGSUMMARY;
 			default:
 				return TYP_DATA;
 			}
diff --git a/db/rtgroup.c b/db/rtgroup.c
index 3ef2dc8fe7f031..c6b96c9dc79daa 100644
--- a/db/rtgroup.c
+++ b/db/rtgroup.c
@@ -132,3 +132,23 @@ const field_t	rgbitmap_hfld[] = {
 	{ "", FLDT_RGBITMAP, OI(0), C1, 0, TYP_NONE },
 	{ NULL }
 };
+
+#define	OFF(f)	bitize(offsetof(struct xfs_rtbuf_blkinfo, rt_ ## f))
+const field_t	rgsummary_flds[] = {
+	{ "magicnum", FLDT_UINT32X, OI(OFF(magic)), C1, 0, TYP_NONE },
+	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
+	{ "owner", FLDT_INO, OI(OFF(owner)), C1, 0, TYP_NONE },
+	{ "bno", FLDT_DFSBNO, OI(OFF(blkno)), C1, 0, TYP_BMAPBTD },
+	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
+	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
+	/* the suminfo array is after the actual structure */
+	{ "suminfo", FLDT_SUMINFO, OI(bitize(sizeof(struct xfs_rtbuf_blkinfo))),
+	  rtwords_count, FLD_ARRAY | FLD_COUNT, TYP_DATA },
+	{ NULL }
+};
+#undef OFF
+
+const field_t	rgsummary_hfld[] = {
+	{ "", FLDT_RGSUMMARY, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
diff --git a/db/rtgroup.h b/db/rtgroup.h
index 06f554e1862851..5b120f2c9a29f3 100644
--- a/db/rtgroup.h
+++ b/db/rtgroup.h
@@ -12,6 +12,9 @@ extern const struct field	rtsb_hfld[];
 extern const struct field	rgbitmap_flds[];
 extern const struct field	rgbitmap_hfld[];
 
+extern const struct field	rgsummary_flds[];
+extern const struct field	rgsummary_hfld[];
+
 extern void	rtsb_init(void);
 extern int	rtsb_size(void *obj, int startoff, int idx);
 
diff --git a/db/type.c b/db/type.c
index 65e7b24146f170..2091b4ac8b139b 100644
--- a/db/type.c
+++ b/db/type.c
@@ -68,6 +68,7 @@ static const typ_t	__typtab[] = {
 	{ TYP_FINOBT, "finobt", handle_struct, finobt_hfld, NULL,
 		TYP_F_NO_CRC_OFF },
 	{ TYP_RGBITMAP, NULL },
+	{ TYP_RGSUMMARY, NULL },
 	{ TYP_NONE, NULL }
 };
 
@@ -116,6 +117,8 @@ static const typ_t	__typtab_crc[] = {
 		&xfs_finobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_RGBITMAP, "rgbitmap", handle_struct, rgbitmap_hfld,
 		&xfs_rtbitmap_buf_ops, XFS_RTBUF_CRC_OFF },
+	{ TYP_RGSUMMARY, "rgsummary", handle_struct, rgsummary_hfld,
+		&xfs_rtsummary_buf_ops, XFS_RTBUF_CRC_OFF },
 	{ TYP_NONE, NULL }
 };
 
@@ -164,6 +167,8 @@ static const typ_t	__typtab_spcrc[] = {
 		&xfs_finobt_buf_ops, XFS_BTREE_SBLOCK_CRC_OFF },
 	{ TYP_RGBITMAP, "rgbitmap", handle_struct, rgbitmap_hfld,
 		&xfs_rtbitmap_buf_ops, XFS_RTBUF_CRC_OFF },
+	{ TYP_RGSUMMARY, "rgsummary", handle_struct, rgsummary_hfld,
+		&xfs_rtsummary_buf_ops, XFS_RTBUF_CRC_OFF },
 	{ TYP_NONE, NULL }
 };
 
diff --git a/db/type.h b/db/type.h
index e2148c6351d141..e7f0ecc17680bf 100644
--- a/db/type.h
+++ b/db/type.h
@@ -36,6 +36,7 @@ typedef enum typnm
 	TYP_TEXT,
 	TYP_FINOBT,
 	TYP_RGBITMAP,
+	TYP_RGSUMMARY,
 	TYP_NONE
 } typnm_t;
 


