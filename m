Return-Path: <linux-xfs+bounces-7141-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 66CF18A8E21
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 23:37:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D09C11F236BB
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 21:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF9E537E5;
	Wed, 17 Apr 2024 21:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WkbIAoIG"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8BE1E484
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389846; cv=none; b=KEAfonhMqv9OH1e2tLpOgDFe1frzBucQwmkYNCSVFm0jRQHhPy+4yLXZ9rLxozV0DV9kOKnjgdZK96tIFQmhNATH26z5yxEKUqrI+vAk4rt1/qqVVcn3LXxT82Hv0gO9xS+JFl0et0gX/qegmJGvyf747C9TA5muiWSqf/J3T80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389846; c=relaxed/simple;
	bh=ErOPqKhImXzkkrMOFXcc7CQIxg7XJoET5DNyA/DHwQs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a2udChqDD9fXQVvV/mpRYMXjw2TVMb1ZfKEg/Xyq9oPYipmqQCBEfuLaGkmTjPCB2hvO03LaK/ppvwLAdR4JIgWHM8qf9Grks8TJtboPZ8r+d4VZhz2j5JQUZ3vozd4+/XAu46c3Pky2DD8GJCq3GpzBWK7+VEg/ucD9bRMSOho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WkbIAoIG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74711C072AA;
	Wed, 17 Apr 2024 21:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389846;
	bh=ErOPqKhImXzkkrMOFXcc7CQIxg7XJoET5DNyA/DHwQs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WkbIAoIGAxy37FHUD53iwctIlG6nYjfAd+yCKx8i4ZsPTOW2hQ7HwSoWSHmOO1uzQ
	 91PVw17yIPpLpXPjy5moGZLvdV962e+R87EHACzmPy1/8ttgM0b6xgA9OzawKKeuM3
	 UdtQlBw2AAkCSt7c+QhKp3gwHIbvOJOTj3LAs9KrQcyBHNLZqOkvjB29hCKrl5go0f
	 SgNwwftoOaVedkU5cqn6zXicyQFvIwPPkNT5vo0dHjf6t95LIaE6URy0nAuWuSSHTd
	 bNXQmkNL+r6q2ek6b8HxnDwHIDZgwh90kWram5wq43Ayy1Zzwj851le2JVX6sUM3Ch
	 AazScCc6cPX8A==
Date: Wed, 17 Apr 2024 14:37:25 -0700
Subject: [PATCH 60/67] xfs: remove struct xfs_attr_shortform
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843241.1853449.9409672417803943825.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 414147225400a0c4562ebfb0fdd40f065099ede4

sparse complains about struct xfs_attr_shortform because it embeds a
structure with a variable sized array in a variable sized array.

Given that xfs_attr_shortform is not a very useful structure, and the
dir2 equivalent has been removed a long time ago, remove it as well.

Provide a xfs_attr_sf_firstentry helper that returns the first
xfs_attr_sf_entry behind a xfs_attr_sf_hdr to replace the structure
dereference.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 db/attrshort.c           |   33 ++++++++++++++++-----------------
 db/check.c               |    8 ++++----
 db/inode.c               |    6 +++---
 db/metadump.c            |   16 +++++++---------
 libxfs/libxfs_api_defs.h |    2 ++
 libxfs/xfs_attr.c        |    4 ++--
 libxfs/xfs_attr_leaf.c   |   37 ++++++++++++++++++-------------------
 libxfs/xfs_attr_leaf.h   |    2 +-
 libxfs/xfs_attr_sf.h     |   13 ++++++++++---
 libxfs/xfs_da_format.h   |   31 ++++++++++++++++++-------------
 libxfs/xfs_inode_fork.c  |    5 ++---
 libxfs/xfs_ondisk.h      |   14 +++++++-------
 repair/attr_repair.c     |   44 ++++++++++++++++++++------------------------
 repair/dinode.c          |   21 +++++++++++----------
 14 files changed, 121 insertions(+), 115 deletions(-)


diff --git a/db/attrshort.c b/db/attrshort.c
index e234fbd83..c98b90be3 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -18,9 +18,8 @@ static int	attr_sf_entry_value_offset(void *obj, int startoff, int idx);
 static int	attr_shortform_list_count(void *obj, int startoff);
 static int	attr_shortform_list_offset(void *obj, int startoff, int idx);
 
-#define	OFF(f)	bitize(offsetof(struct xfs_attr_shortform, f))
 const field_t	attr_shortform_flds[] = {
-	{ "hdr", FLDT_ATTR_SF_HDR, OI(OFF(hdr)), C1, 0, TYP_NONE },
+	{ "hdr", FLDT_ATTR_SF_HDR, OI(0), C1, 0, TYP_NONE },
 	{ "list", FLDT_ATTR_SF_ENTRY, attr_shortform_list_offset,
 	  attr_shortform_list_count, FLD_ARRAY|FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ NULL }
@@ -71,11 +70,11 @@ attr_sf_entry_size(
 {
 	struct xfs_attr_sf_entry	*e;
 	int				i;
-	struct xfs_attr_shortform	*sf;
+	struct xfs_attr_sf_hdr		*hdr;
 
 	ASSERT(bitoffs(startoff) == 0);
-	sf = (struct xfs_attr_shortform *)((char *)obj + byteize(startoff));
-	e = &sf->list[0];
+	hdr = (struct xfs_attr_sf_hdr *)((char *)obj + byteize(startoff));
+	e = libxfs_attr_sf_firstentry(hdr);
 	for (i = 0; i < idx; i++)
 		e = xfs_attr_sf_nextentry(e);
 	return bitize((int)xfs_attr_sf_entsize(e));
@@ -113,11 +112,11 @@ attr_shortform_list_count(
 	void				*obj,
 	int				startoff)
 {
-	struct xfs_attr_shortform	*sf;
+	struct xfs_attr_sf_hdr		*hdr;
 
 	ASSERT(bitoffs(startoff) == 0);
-	sf = (struct xfs_attr_shortform *)((char *)obj + byteize(startoff));
-	return sf->hdr.count;
+	hdr = (struct xfs_attr_sf_hdr *)((char *)obj + byteize(startoff));
+	return hdr->count;
 }
 
 static int
@@ -128,14 +127,14 @@ attr_shortform_list_offset(
 {
 	struct xfs_attr_sf_entry	*e;
 	int				i;
-	struct xfs_attr_shortform	*sf;
+	struct xfs_attr_sf_hdr		*hdr;
 
 	ASSERT(bitoffs(startoff) == 0);
-	sf = (struct xfs_attr_shortform *)((char *)obj + byteize(startoff));
-	e = &sf->list[0];
+	hdr = (struct xfs_attr_sf_hdr *)((char *)obj + byteize(startoff));
+	e = libxfs_attr_sf_firstentry(hdr);
 	for (i = 0; i < idx; i++)
 		e = xfs_attr_sf_nextentry(e);
-	return bitize((int)((char *)e - (char *)sf));
+	return bitize((int)((char *)e - (char *)hdr));
 }
 
 /*ARGSUSED*/
@@ -147,13 +146,13 @@ attrshort_size(
 {
 	struct xfs_attr_sf_entry	*e;
 	int				i;
-	struct xfs_attr_shortform	*sf;
+	struct xfs_attr_sf_hdr		*hdr;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(idx == 0);
-	sf = (struct xfs_attr_shortform *)((char *)obj + byteize(startoff));
-	e = &sf->list[0];
-	for (i = 0; i < sf->hdr.count; i++)
+	hdr = (struct xfs_attr_sf_hdr *)((char *)obj + byteize(startoff));
+	e = libxfs_attr_sf_firstentry(hdr);
+	for (i = 0; i < hdr->count; i++)
 		e = xfs_attr_sf_nextentry(e);
-	return bitize((int)((char *)e - (char *)sf));
+	return bitize((int)((char *)e - (char *)hdr));
 }
diff --git a/db/check.c b/db/check.c
index 91d0c0940..0a53ab7df 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3069,7 +3069,7 @@ process_lclinode(
 	blkmap_t			**blkmapp,
 	int				whichfork)
 {
-	struct xfs_attr_shortform	*asf;
+	struct xfs_attr_sf_hdr		*hdr;
 	xfs_fsblock_t			bno;
 
 	bno = XFS_INO_TO_FSB(mp, id->ino);
@@ -3082,12 +3082,12 @@ process_lclinode(
 		error++;
 	}
 	else if (whichfork == XFS_ATTR_FORK) {
-		asf = (struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
-		if (be16_to_cpu(asf->hdr.totsize) > XFS_DFORK_ASIZE(dip, mp)) {
+		hdr = XFS_DFORK_APTR(dip);
+		if (be16_to_cpu(hdr->totsize) > XFS_DFORK_ASIZE(dip, mp)) {
 			if (!sflag || id->ilist || CHECK_BLIST(bno))
 				dbprintf(_("local inode %lld attr is too large "
 					 "(size %d)\n"),
-					id->ino, be16_to_cpu(asf->hdr.totsize));
+					id->ino, be16_to_cpu(hdr->totsize));
 			error++;
 		}
 	}
diff --git a/db/inode.c b/db/inode.c
index c9b506b90..7a5f5a0cb 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -356,7 +356,7 @@ inode_a_size(
 	int				startoff,
 	int				idx)
 {
-	struct xfs_attr_shortform	*asf;
+	struct xfs_attr_sf_hdr		*hdr;
 	struct xfs_dinode		*dip;
 
 	ASSERT(startoff == 0);
@@ -364,8 +364,8 @@ inode_a_size(
 	dip = obj;
 	switch (dip->di_aformat) {
 	case XFS_DINODE_FMT_LOCAL:
-		asf = (struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
-		return bitize(be16_to_cpu(asf->hdr.totsize));
+		hdr = XFS_DFORK_APTR(dip);
+		return bitize(be16_to_cpu(hdr->totsize));
 	case XFS_DINODE_FMT_EXTENTS:
 		return (int)xfs_dfork_attr_extents(dip) * bitsz(xfs_bmbt_rec_t);
 	case XFS_DINODE_FMT_BTREE:
diff --git a/db/metadump.c b/db/metadump.c
index bac35b9cc..536d089fb 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1035,16 +1035,15 @@ process_sf_attr(
 	 * values with 'v' (to see a valid string length, as opposed to NULLs)
 	 */
 
-	struct xfs_attr_shortform	*asfp;
-	struct xfs_attr_sf_entry	*asfep;
+	struct xfs_attr_sf_hdr		*hdr = XFS_DFORK_APTR(dip);
+	struct xfs_attr_sf_entry	*asfep = libxfs_attr_sf_firstentry(hdr);
 	int				ino_attr_size;
 	int				i;
 
-	asfp = (struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
-	if (asfp->hdr.count == 0)
+	if (hdr->count == 0)
 		return;
 
-	ino_attr_size = be16_to_cpu(asfp->hdr.totsize);
+	ino_attr_size = be16_to_cpu(hdr->totsize);
 	if (ino_attr_size > XFS_DFORK_ASIZE(dip, mp)) {
 		ino_attr_size = XFS_DFORK_ASIZE(dip, mp);
 		if (metadump.show_warnings)
@@ -1052,9 +1051,8 @@ process_sf_attr(
 					(long long)metadump.cur_ino);
 	}
 
-	asfep = &asfp->list[0];
-	for (i = 0; (i < asfp->hdr.count) &&
-			((char *)asfep - (char *)asfp < ino_attr_size); i++) {
+	for (i = 0; (i < hdr->count) &&
+			((char *)asfep - (char *)hdr < ino_attr_size); i++) {
 
 		int	namelen = asfep->namelen;
 
@@ -1063,7 +1061,7 @@ process_sf_attr(
 				print_warning("zero length attr entry in inode "
 					"%llu", (long long)metadump.cur_ino);
 			break;
-		} else if ((char *)asfep - (char *)asfp +
+		} else if ((char *)asfep - (char *)hdr +
 				xfs_attr_sf_entsize(asfep) > ino_attr_size) {
 			if (metadump.show_warnings)
 				print_warning("attr entry length in inode %llu "
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 7c055e8aa..36afc5d02 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -40,6 +40,8 @@
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 #define xfs_attr_namecheck		libxfs_attr_namecheck
 #define xfs_attr_set			libxfs_attr_set
+#define xfs_attr_sf_firstentry		libxfs_attr_sf_firstentry
+#define xfs_attr_shortform_verify	libxfs_attr_shortform_verify
 
 #define __xfs_bmap_add_free		__libxfs_bmap_add_free
 #define xfs_bmapi_read			libxfs_bmapi_read
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index a383024db..055d20410 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1050,9 +1050,9 @@ xfs_attr_set(
 
 static inline int xfs_attr_sf_totsize(struct xfs_inode *dp)
 {
-	struct xfs_attr_shortform *sf = dp->i_af.if_data;
+	struct xfs_attr_sf_hdr *sf = dp->i_af.if_data;
 
-	return be16_to_cpu(sf->hdr.totsize);
+	return be16_to_cpu(sf->totsize);
 }
 
 /*
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 9b6dcff34..cf172b6ea 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -701,10 +701,10 @@ struct xfs_attr_sf_entry *
 xfs_attr_sf_findname(
 	struct xfs_da_args		*args)
 {
-	struct xfs_attr_shortform	*sf = args->dp->i_af.if_data;
+	struct xfs_attr_sf_hdr		*sf = args->dp->i_af.if_data;
 	struct xfs_attr_sf_entry	*sfe;
 
-	for (sfe = &sf->list[0];
+	for (sfe = xfs_attr_sf_firstentry(sf);
 	     sfe < xfs_attr_sf_endptr(sf);
 	     sfe = xfs_attr_sf_nextentry(sfe)) {
 		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
@@ -727,7 +727,7 @@ xfs_attr_shortform_add(
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_mount		*mp = dp->i_mount;
 	struct xfs_ifork		*ifp = &dp->i_af;
-	struct xfs_attr_shortform	*sf = ifp->if_data;
+	struct xfs_attr_sf_hdr		*sf = ifp->if_data;
 	struct xfs_attr_sf_entry	*sfe;
 	int				size;
 
@@ -747,8 +747,8 @@ xfs_attr_shortform_add(
 	sfe->flags = args->attr_filter;
 	memcpy(sfe->nameval, args->name, args->namelen);
 	memcpy(&sfe->nameval[args->namelen], args->value, args->valuelen);
-	sf->hdr.count++;
-	be16_add_cpu(&sf->hdr.totsize, size);
+	sf->count++;
+	be16_add_cpu(&sf->totsize, size);
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_ADATA);
 
 	xfs_sbversion_add_attr2(mp, args->trans);
@@ -779,9 +779,9 @@ xfs_attr_sf_removename(
 {
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_mount		*mp = dp->i_mount;
-	struct xfs_attr_shortform	*sf = dp->i_af.if_data;
+	struct xfs_attr_sf_hdr		*sf = dp->i_af.if_data;
 	struct xfs_attr_sf_entry	*sfe;
-	uint16_t			totsize = be16_to_cpu(sf->hdr.totsize);
+	uint16_t			totsize = be16_to_cpu(sf->totsize);
 	void				*next, *end;
 	int				size = 0;
 
@@ -806,9 +806,9 @@ xfs_attr_sf_removename(
 	end = xfs_attr_sf_endptr(sf);
 	if (next < end)
 		memmove(sfe, next, end - next);
-	sf->hdr.count--;
+	sf->count--;
 	totsize -= size;
-	sf->hdr.totsize = cpu_to_be16(totsize);
+	sf->totsize = cpu_to_be16(totsize);
 
 	/*
 	 * Fix up the start offset of the attribute fork
@@ -865,21 +865,21 @@ xfs_attr_shortform_to_leaf(
 {
 	struct xfs_inode		*dp = args->dp;
 	struct xfs_ifork		*ifp = &dp->i_af;
-	struct xfs_attr_shortform	*sf = ifp->if_data;
+	struct xfs_attr_sf_hdr		*sf = ifp->if_data;
 	struct xfs_attr_sf_entry	*sfe;
+	int				size = be16_to_cpu(sf->totsize);
 	struct xfs_da_args		nargs;
 	char				*tmpbuffer;
-	int				error, i, size;
+	int				error, i;
 	xfs_dablk_t			blkno;
 	struct xfs_buf			*bp;
 
 	trace_xfs_attr_sf_to_leaf(args);
 
-	size = be16_to_cpu(sf->hdr.totsize);
 	tmpbuffer = kmem_alloc(size, 0);
 	ASSERT(tmpbuffer != NULL);
 	memcpy(tmpbuffer, ifp->if_data, size);
-	sf = (struct xfs_attr_shortform *)tmpbuffer;
+	sf = (struct xfs_attr_sf_hdr *)tmpbuffer;
 
 	xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
 	xfs_bmap_local_to_extents_empty(args->trans, dp, XFS_ATTR_FORK);
@@ -902,8 +902,8 @@ xfs_attr_shortform_to_leaf(
 	nargs.trans = args->trans;
 	nargs.op_flags = XFS_DA_OP_OKNOENT;
 
-	sfe = &sf->list[0];
-	for (i = 0; i < sf->hdr.count; i++) {
+	sfe = xfs_attr_sf_firstentry(sf);
+	for (i = 0; i < sf->count; i++) {
 		nargs.name = sfe->nameval;
 		nargs.namelen = sfe->namelen;
 		nargs.value = &sfe->nameval[nargs.namelen];
@@ -970,10 +970,10 @@ xfs_attr_shortform_allfit(
 /* Verify the consistency of a raw inline attribute fork. */
 xfs_failaddr_t
 xfs_attr_shortform_verify(
-	struct xfs_attr_shortform	*sfp,
+	struct xfs_attr_sf_hdr		*sfp,
 	size_t				size)
 {
-	struct xfs_attr_sf_entry	*sfep;
+	struct xfs_attr_sf_entry	*sfep = xfs_attr_sf_firstentry(sfp);
 	struct xfs_attr_sf_entry	*next_sfep;
 	char				*endp;
 	int				i;
@@ -987,8 +987,7 @@ xfs_attr_shortform_verify(
 	endp = (char *)sfp + size;
 
 	/* Check all reported entries */
-	sfep = &sfp->list[0];
-	for (i = 0; i < sfp->hdr.count; i++) {
+	for (i = 0; i < sfp->count; i++) {
 		/*
 		 * struct xfs_attr_sf_entry has a variable length.
 		 * Check the fixed-offset parts of the structure are
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index 35e668ae7..9b9948639 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -53,7 +53,7 @@ int	xfs_attr_sf_removename(struct xfs_da_args *args);
 struct xfs_attr_sf_entry *xfs_attr_sf_findname(struct xfs_da_args *args);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
-xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_attr_shortform *sfp,
+xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_attr_sf_hdr *sfp,
 		size_t size);
 void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
 
diff --git a/libxfs/xfs_attr_sf.h b/libxfs/xfs_attr_sf.h
index a774d4d87..9abf7de95 100644
--- a/libxfs/xfs_attr_sf.h
+++ b/libxfs/xfs_attr_sf.h
@@ -41,7 +41,14 @@ static inline int xfs_attr_sf_entsize(struct xfs_attr_sf_entry *sfep)
 	return struct_size(sfep, nameval, sfep->namelen + sfep->valuelen);
 }
 
-/* next entry in struct */
+/* first entry in the SF attr fork */
+static inline struct xfs_attr_sf_entry *
+xfs_attr_sf_firstentry(struct xfs_attr_sf_hdr *hdr)
+{
+	return (struct xfs_attr_sf_entry *)(hdr + 1);
+}
+
+/* next entry after sfep */
 static inline struct xfs_attr_sf_entry *
 xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep)
 {
@@ -50,9 +57,9 @@ xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep)
 
 /* pointer to the space after the last entry, e.g. for adding a new one */
 static inline struct xfs_attr_sf_entry *
-xfs_attr_sf_endptr(struct xfs_attr_shortform *sf)
+xfs_attr_sf_endptr(struct xfs_attr_sf_hdr *sf)
 {
-	return (void *)sf + be16_to_cpu(sf->hdr.totsize);
+	return (void *)sf + be16_to_cpu(sf->totsize);
 }
 
 #endif	/* __XFS_ATTR_SF_H__ */
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index f9015f88e..24f9d1461 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -578,20 +578,25 @@ xfs_dir2_block_leaf_p(struct xfs_dir2_block_tail *btp)
 #define XFS_ATTR_LEAF_MAPSIZE	3	/* how many freespace slots */
 
 /*
- * Entries are packed toward the top as tight as possible.
+ * Attribute storage when stored inside the inode.
+ *
+ * Small attribute lists are packed as tightly as possible so as to fit into the
+ * literal area of the inode.
+ *
+ * These "shortform" attribute forks consist of a single xfs_attr_sf_hdr header
+ * followed by zero or more xfs_attr_sf_entry structures.
  */
-struct xfs_attr_shortform {
-	struct xfs_attr_sf_hdr {	/* constant-structure header block */
-		__be16	totsize;	/* total bytes in shortform list */
-		__u8	count;	/* count of active entries */
-		__u8	padding;
-	} hdr;
-	struct xfs_attr_sf_entry {
-		uint8_t namelen;	/* actual length of name (no NULL) */
-		uint8_t valuelen;	/* actual length of value (no NULL) */
-		uint8_t flags;	/* flags bits (see xfs_attr_leaf.h) */
-		uint8_t nameval[];	/* name & value bytes concatenated */
-	} list[];			/* variable sized array */
+struct xfs_attr_sf_hdr {	/* constant-structure header block */
+	__be16	totsize;	/* total bytes in shortform list */
+	__u8	count;		/* count of active entries */
+	__u8	padding;
+};
+
+struct xfs_attr_sf_entry {
+	__u8	namelen;	/* actual length of name (no NULL) */
+	__u8	valuelen;	/* actual length of value (no NULL) */
+	__u8	flags;		/* flags bits (XFS_ATTR_*) */
+	__u8	nameval[];	/* name & value bytes concatenated */
 };
 
 typedef struct xfs_attr_leaf_map {	/* RLE map of free bytes */
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index c95abd43a..208b283ba 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -277,10 +277,9 @@ static uint16_t
 xfs_dfork_attr_shortform_size(
 	struct xfs_dinode		*dip)
 {
-	struct xfs_attr_shortform	*atp =
-		(struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
+	struct xfs_attr_sf_hdr		*sf = XFS_DFORK_APTR(dip);
 
-	return be16_to_cpu(atp->hdr.totsize);
+	return be16_to_cpu(sf->totsize);
 }
 
 void
diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index d9c988c5a..81885a6a0 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -93,13 +93,13 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, namelen,	8);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, name,	9);
 	XFS_CHECK_STRUCT_SIZE(xfs_attr_leafblock_t,		32);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_shortform,	4);
-	XFS_CHECK_OFFSET(struct xfs_attr_shortform, hdr.totsize, 0);
-	XFS_CHECK_OFFSET(struct xfs_attr_shortform, hdr.count,	 2);
-	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].namelen,	4);
-	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].valuelen,	5);
-	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].flags,	6);
-	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].nameval,	7);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_sf_hdr,		4);
+	XFS_CHECK_OFFSET(struct xfs_attr_sf_hdr, totsize,	0);
+	XFS_CHECK_OFFSET(struct xfs_attr_sf_hdr, count,		2);
+	XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, namelen,	0);
+	XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, valuelen,	1);
+	XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, flags,	2);
+	XFS_CHECK_OFFSET(struct xfs_attr_sf_entry, nameval,	3);
 	XFS_CHECK_STRUCT_SIZE(xfs_da_blkinfo_t,			12);
 	XFS_CHECK_STRUCT_SIZE(xfs_da_intnode_t,			16);
 	XFS_CHECK_STRUCT_SIZE(xfs_da_node_entry_t,		8);
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index c3a6d5026..31c50c127 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -210,27 +210,25 @@ process_shortform_attr(
 	struct xfs_dinode		*dip,
 	int				*repair)
 {
-	struct xfs_attr_shortform	*asf;
+	struct xfs_attr_sf_hdr		*hdr = XFS_DFORK_APTR(dip);
 	struct xfs_attr_sf_entry	*currententry, *nextentry, *tempentry;
 	int				i, junkit;
 	int				currentsize, remainingspace;
 
 	*repair = 0;
 
-	asf = (struct xfs_attr_shortform *) XFS_DFORK_APTR(dip);
-
 	/* Assumption: hdr.totsize is less than a leaf block and was checked
 	 * by lclinode for valid sizes. Check the count though.
 	*/
-	if (asf->hdr.count == 0)
+	if (hdr->count == 0)
 		/* then the total size should just be the header length */
-		if (be16_to_cpu(asf->hdr.totsize) != sizeof(xfs_attr_sf_hdr_t)) {
+		if (be16_to_cpu(hdr->totsize) != sizeof(xfs_attr_sf_hdr_t)) {
 			/* whoops there's a discrepancy. Clear the hdr */
 			if (!no_modify) {
 				do_warn(
 	_("there are no attributes in the fork for inode %" PRIu64 "\n"),
 					ino);
-				asf->hdr.totsize =
+				hdr->totsize =
 					cpu_to_be16(sizeof(xfs_attr_sf_hdr_t));
 				*repair = 1;
 				return(1);
@@ -243,15 +241,15 @@ process_shortform_attr(
 		}
 
 	currentsize = sizeof(xfs_attr_sf_hdr_t);
-	remainingspace = be16_to_cpu(asf->hdr.totsize) - currentsize;
-	nextentry = &asf->list[0];
-	for (i = 0; i < asf->hdr.count; i++)  {
+	remainingspace = be16_to_cpu(hdr->totsize) - currentsize;
+	nextentry = libxfs_attr_sf_firstentry(hdr);
+	for (i = 0; i < hdr->count; i++)  {
 		currententry = nextentry;
 		junkit = 0;
 
 		/* don't go off the end if the hdr.count was off */
 		if ((currentsize + (sizeof(struct xfs_attr_sf_entry) - 1)) >
-						be16_to_cpu(asf->hdr.totsize))
+						be16_to_cpu(hdr->totsize))
 			break; /* get out and reset count and totSize */
 
 		/* if the namelen is 0, can't get to the rest of the entries */
@@ -326,7 +324,7 @@ process_shortform_attr(
 					((intptr_t) currententry +
 					 xfs_attr_sf_entsize(currententry));
 				memmove(currententry,tempentry,remainingspace);
-				asf->hdr.count -= 1;
+				hdr->count -= 1;
 				i--; /* no worries, it will wrap back to 0 */
 				*repair = 1;
 				continue; /* go back up now */
@@ -344,33 +342,33 @@ process_shortform_attr(
 
 	} /* end the loop */
 
-	if (asf->hdr.count != i)  {
+	if (hdr->count != i)  {
 		if (no_modify)  {
 			do_warn(
 	_("would have corrected attribute entry count in inode %" PRIu64 " from %d to %d\n"),
-				ino, asf->hdr.count, i);
+				ino, hdr->count, i);
 		} else  {
 			do_warn(
 	_("corrected attribute entry count in inode %" PRIu64 ", was %d, now %d\n"),
-				ino, asf->hdr.count, i);
-			asf->hdr.count = i;
+				ino, hdr->count, i);
+			hdr->count = i;
 			*repair = 1;
 		}
 	}
 
 	/* ASSUMPTION: currentsize <= totsize */
-	if (be16_to_cpu(asf->hdr.totsize) != currentsize)  {
+	if (be16_to_cpu(hdr->totsize) != currentsize)  {
 		if (no_modify)  {
 			do_warn(
 	_("would have corrected attribute totsize in inode %" PRIu64 " from %d to %d\n"),
-				ino, be16_to_cpu(asf->hdr.totsize),
+				ino, be16_to_cpu(hdr->totsize),
 				currentsize);
 		} else  {
 			do_warn(
 	_("corrected attribute entry totsize in inode %" PRIu64 ", was %d, now %d\n"),
-				ino, be16_to_cpu(asf->hdr.totsize),
+				ino, be16_to_cpu(hdr->totsize),
 				currentsize);
-			asf->hdr.totsize = cpu_to_be16(currentsize);
+			hdr->totsize = cpu_to_be16(currentsize);
 			*repair = 1;
 		}
 	}
@@ -1232,14 +1230,12 @@ process_attributes(
 	int			err;
 	__u8			aformat = dip->di_aformat;
 #ifdef DEBUG
-	struct xfs_attr_shortform *asf;
-
-	asf = (struct xfs_attr_shortform *) XFS_DFORK_APTR(dip);
+	struct xfs_attr_sf_hdr	*hdr = XFS_DFORK_APTR(dip);
 #endif
 
 	if (aformat == XFS_DINODE_FMT_LOCAL) {
-		ASSERT(be16_to_cpu(asf->hdr.totsize) <=
-			XFS_DFORK_ASIZE(dip, mp));
+		ASSERT(be16_to_cpu(hdr->totsize) <= XFS_DFORK_ASIZE(dip, mp));
+
 		err = process_shortform_attr(mp, ino, dip, repair);
 	} else if (aformat == XFS_DINODE_FMT_EXTENTS ||
 					aformat == XFS_DINODE_FMT_BTREE)  {
diff --git a/repair/dinode.c b/repair/dinode.c
index c1cfadc88..636e753fc 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -99,10 +99,10 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 	 */
 
 	if (!no_modify) {
-		struct xfs_attr_shortform *asf = (struct xfs_attr_shortform *)
-				XFS_DFORK_APTR(dino);
-		asf->hdr.totsize = cpu_to_be16(sizeof(xfs_attr_sf_hdr_t));
-		asf->hdr.count = 0;
+		struct xfs_attr_sf_hdr	*hdr = XFS_DFORK_APTR(dino);
+
+		hdr->totsize = cpu_to_be16(sizeof(struct xfs_attr_sf_hdr));
+		hdr->count = 0;
 		dino->di_forkoff = 0;  /* got to do this after asf is set */
 	}
 
@@ -993,7 +993,7 @@ process_lclinode(
 	struct xfs_dinode		*dip,
 	int				whichfork)
 {
-	struct xfs_attr_shortform	*asf;
+	struct xfs_attr_sf_hdr		*hdr;
 	xfs_ino_t			lino;
 
 	lino = XFS_AGINO_TO_INO(mp, agno, ino);
@@ -1005,18 +1005,19 @@ process_lclinode(
 			XFS_DFORK_DSIZE(dip, mp));
 		return(1);
 	} else if (whichfork == XFS_ATTR_FORK) {
-		asf = (struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
-		if (be16_to_cpu(asf->hdr.totsize) > XFS_DFORK_ASIZE(dip, mp)) {
+		hdr = XFS_DFORK_APTR(dip);
+
+		if (be16_to_cpu(hdr->totsize) > XFS_DFORK_ASIZE(dip, mp)) {
 			do_warn(
 	_("local inode %" PRIu64 " attr fork too large (size %d, max = %zu)\n"),
-				lino, be16_to_cpu(asf->hdr.totsize),
+				lino, be16_to_cpu(hdr->totsize),
 				XFS_DFORK_ASIZE(dip, mp));
 			return(1);
 		}
-		if (be16_to_cpu(asf->hdr.totsize) < sizeof(xfs_attr_sf_hdr_t)) {
+		if (be16_to_cpu(hdr->totsize) < sizeof(xfs_attr_sf_hdr_t)) {
 			do_warn(
 	_("local inode %" PRIu64 " attr too small (size = %d, min size = %zd)\n"),
-				lino, be16_to_cpu(asf->hdr.totsize),
+				lino, be16_to_cpu(hdr->totsize),
 				sizeof(xfs_attr_sf_hdr_t));
 			return(1);
 		}


