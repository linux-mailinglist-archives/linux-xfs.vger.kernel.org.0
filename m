Return-Path: <linux-xfs+bounces-3686-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D03A851A75
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Feb 2024 18:01:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11B14286A50
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Feb 2024 17:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DE783FB0C;
	Mon, 12 Feb 2024 17:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M/R/ehJK"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D053D998
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 17:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707757218; cv=none; b=h2FkCRnywSEAGt0vXoAzEE+gqaSCgcKw6Q7enP/bSMVhF2NUuyysHXv0QTVhEfXZzhb2hUMXuSe4HbaeMa6wrJHS+6o6CMypcjLC0Y2UUN4G3VVTHfcPPKrJP4ghnGBSfMbleho8QeoCaLMQBbMXfkD7kiJAyUn6nuZNzEbSFyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707757218; c=relaxed/simple;
	bh=wNIW/W+YCPZOMVmYt21a2Fgepob4iaeWS1zUwwO+tX4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tqHN3Z1x30JOKePELSp+appDffSloaTgPjO86FIMsmbtTUpnesVwNe0EOTuw2XMdbgt4lVFpFgqEkMGnqbBlLtPin1kH69Q/O9xjWvlIDS1cZ0nOLnD/8Ihz+1u+9VD7drgVHvlUFL1QqgUaWCuLD/wYIqa9AoSi5uB3VHEwwNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M/R/ehJK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707757216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HjNaCcVPbGjsbiOXI+W7wF6VbX0l3c5qvi60YHzKwuo=;
	b=M/R/ehJK8nxtReQD9bRw5NRJ4PcNYgu9YEUk3ge6TVdiS809Chh7vbWdDmRaMVlr4qUXj2
	SBTCBVXj7vUbVsPue8+sk51Fx2n8X3Oqe+b1A9DbTa2NsXbR3mYIuY3UIXwIL8i4wMWVjN
	+xiAbyH09mMWQZWu+vSyaxbpqabCXws=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-mqALMtT2MaySJBEzkr1ZdQ-1; Mon, 12 Feb 2024 12:00:14 -0500
X-MC-Unique: mqALMtT2MaySJBEzkr1ZdQ-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5605a2937d4so2492550a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 09:00:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707757213; x=1708362013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HjNaCcVPbGjsbiOXI+W7wF6VbX0l3c5qvi60YHzKwuo=;
        b=giyIRCFpZ8TeGqfZ0uwFx9uguaob9jweJg9gux0aEtrdmGGVCs1oWebnFLR7eijvxY
         UIBIgjHJwvF3gwa4rDw8So6yKO9Zy+JR/57+WnNAnZlJy08RfG8BmjXb+fKTSCgx38Sp
         gsNoUQbcR+2Ql7IKRPxL7Hdt7pWStoOwif0tN7OhX44wjzfsnAelIynn7slHAcaMjA8S
         Bpr55m/xG9fCKPgXvv2Q2skoqZ4/NwB/LdBS/8io3qoEl36dMpWegJwEt8KVM8FQdmA6
         1pZrYsVNKmXBjD3/eTq5A6fNzVgCJLHPJBTEDLcWcuGlDNkIebhpFDGXuH5HOFkEkJXC
         itZg==
X-Gm-Message-State: AOJu0YyW2dflGf3a6RVpW3ykLkDyQGopjoVE2UAqpWCLUV03LihyQIXx
	Kfl6hd5skVAavHg3pKv2pKV9/U+hHlC6yJoF82IKHjVFstlhHSvRhEWGAE6Q6xFs2qe8i6FktRX
	OHyH4gFh31Q8rJbNFsyolccoO3RTBjYT/yZxGIYrx4j/YJBOepZnkUicA
X-Received: by 2002:a05:6402:340f:b0:560:c70f:9a0a with SMTP id k15-20020a056402340f00b00560c70f9a0amr5749017edc.1.1707757213607;
        Mon, 12 Feb 2024 09:00:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGaVyoDnUYHyjbhnfm0ylTX+NNCK45Hn8iWWe9/m395Kzs+0F05MXh/leILB7t1EK6GC5zbnw==
X-Received: by 2002:a05:6402:340f:b0:560:c70f:9a0a with SMTP id k15-20020a056402340f00b00560c70f9a0amr5748998edc.1.1707757213387;
        Mon, 12 Feb 2024 09:00:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVD8cj7TfTbKAJSOPfBbwNerkXbl4qtSTAJv587exJ1YNV30AX02UMtG7ezAhc0pcs6K0RJBtgByE/mknC7NxOtxFgDDxrlHdwvGmnwdtFpmutdySih3hgtJgKqHfd29qFzB3ut117WfLVCqLzImoBR+sXvwPO35RCReUKQfwL+nIsWpvz2UyFPLgBQ1A6Qz3nHw6tL3Hqqg9AN2rjL3RVO942AtvHYHzGP
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 14-20020a0564021f4e00b0056176e95a88sm2620261edz.32.2024.02.12.09.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 09:00:12 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v4 16/25] xfs: add XBF_DOUBLE_ALLOC to increase size of the buffer
Date: Mon, 12 Feb 2024 17:58:13 +0100
Message-Id: <20240212165821.1901300-17-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240212165821.1901300-1-aalbersh@redhat.com>
References: <20240212165821.1901300-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For fs-verity integration, XFS needs to supply kaddr'es of Merkle
tree blocks to fs-verity core and track which blocks are already
verified. One way to track verified status is to set xfs_buf flag
(previously added XBF_VERITY_SEEN). When xfs_buf is evicted from
memory we loose verified status. Otherwise, fs-verity hits the
xfs_buf which is still in cache and contains already verified blocks.

However, the leaf blocks which are read to the xfs_buf contains leaf
headers. xfs_attr_get() allocates new pages and copies out the data
without header. Those newly allocated pages with extended attribute
data are not attached to the buffer anymore.

Add new XBF_DOUBLE_ALLOC which makes xfs_buf allocates x2 memory for
the buffer. Additional memory will be used for a copy of the
attribute data but without any headers. Also, make
xfs_attr_rmtval_get() to copy data to the buffer itself if XFS asked
for fs-verity block.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 26 ++++++++++++++++++++++++--
 fs/xfs/xfs_buf.c                |  6 +++++-
 fs/xfs/xfs_buf.h                |  2 ++
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 5762135dc2a6..1d32041412cc 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -392,12 +392,22 @@ xfs_attr_rmtval_get(
 	int			blkcnt = args->rmtblkcnt;
 	int			i;
 	int			offset = 0;
+	int			flags = 0;
+	void			*addr;
 
 	trace_xfs_attr_rmtval_get(args);
 
 	ASSERT(args->valuelen != 0);
 	ASSERT(args->rmtvaluelen == args->valuelen);
 
+	/*
+	 * We also check for _OP_BUFFER as we want to trigger on
+	 * verity blocks only, not on verity_descriptor
+	 */
+	if (args->attr_filter & XFS_ATTR_VERITY &&
+			args->op_flags & XFS_DA_OP_BUFFER)
+		flags = XBF_DOUBLE_ALLOC;
+
 	valuelen = args->rmtvaluelen;
 	while (valuelen > 0) {
 		nmap = ATTR_RMTVALUE_MAPSIZE;
@@ -417,10 +427,21 @@ xfs_attr_rmtval_get(
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
-					0, &bp, &xfs_attr3_rmt_buf_ops);
+					flags, &bp, &xfs_attr3_rmt_buf_ops);
 			if (error)
 				return error;
 
+			/*
+			 * For fs-verity we allocated more space. That space is
+			 * filled with the same xattr data but without leaf
+			 * headers. Point args->value to that data
+			 */
+			if (flags & XBF_DOUBLE_ALLOC) {
+				addr = xfs_buf_offset(bp, BBTOB(bp->b_length));
+				args->value = addr;
+				dst = addr;
+			}
+
 			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
 							&offset, &valuelen,
 							&dst);
@@ -521,7 +542,8 @@ xfs_attr_rmtval_set_value(
 		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
 		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
 
-		error = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt, 0, &bp);
+		error = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt,
+				XBF_DOUBLE_ALLOC, &bp);
 		if (error)
 			return error;
 		bp->b_ops = &xfs_attr3_rmt_buf_ops;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8e5bd50d29fe..2645e64f2439 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -328,6 +328,9 @@ xfs_buf_alloc_kmem(
 	xfs_km_flags_t	kmflag_mask = KM_NOFS;
 	size_t		size = BBTOB(bp->b_length);
 
+	if (flags & XBF_DOUBLE_ALLOC)
+		size *= 2;
+
 	/* Assure zeroed buffer for non-read cases. */
 	if (!(flags & XBF_READ))
 		kmflag_mask |= KM_ZERO;
@@ -358,6 +361,7 @@ xfs_buf_alloc_pages(
 {
 	gfp_t		gfp_mask = __GFP_NOWARN;
 	long		filled = 0;
+	int		mul = (bp->b_flags & XBF_DOUBLE_ALLOC) ? 2 : 1;
 
 	if (flags & XBF_READ_AHEAD)
 		gfp_mask |= __GFP_NORETRY;
@@ -365,7 +369,7 @@ xfs_buf_alloc_pages(
 		gfp_mask |= GFP_NOFS;
 
 	/* Make sure that we have a page list */
-	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
+	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length*mul), PAGE_SIZE);
 	if (bp->b_page_count <= XB_PAGES) {
 		bp->b_pages = bp->b_page_array;
 	} else {
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 80566ee444f8..8ca8760c401e 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -33,6 +33,7 @@ struct xfs_buf;
 #define XBF_STALE		(1u << 6) /* buffer has been staled, do not find it */
 #define XBF_WRITE_FAIL		(1u << 7) /* async writes have failed on this buffer */
 #define XBF_VERITY_SEEN		(1u << 8) /* buffer was processed by fs-verity */
+#define XBF_DOUBLE_ALLOC	(1u << 9) /* double allocated space */
 
 /* buffer type flags for write callbacks */
 #define _XBF_INODES	 (1u << 16)/* inode buffer */
@@ -67,6 +68,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_STALE,		"STALE" }, \
 	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
 	{ XBF_VERITY_SEEN,	"VERITY_SEEN" }, \
+	{ XBF_DOUBLE_ALLOC,	"DOUBLE_ALLOC" }, \
 	{ _XBF_INODES,		"INODES" }, \
 	{ _XBF_DQUOTS,		"DQUOTS" }, \
 	{ _XBF_LOGRECOVERY,	"LOG_RECOVERY" }, \
-- 
2.42.0


