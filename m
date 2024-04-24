Return-Path: <linux-xfs+bounces-7474-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C28B8AFF83
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Apr 2024 05:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EECDF28401C
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Apr 2024 03:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD2E713A269;
	Wed, 24 Apr 2024 03:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ea1w4V+i"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7B0139574
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928982; cv=none; b=VP/6JAXfUVcF7ucV1gjsE6QgdDztOFjSrYku7aVmaFR31PlyCx/JUtDSBV/02khgEr+6VMhXg0mOdxACqFzJsmvcX9PTfCtTzu483SnZmQCsO0muM5A6HjUxZuFQ7UzP3GUMVw5FK3X63PW2igQUGW3k7r4dAAgZDJLj0MfZA98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928982; c=relaxed/simple;
	bh=zmlWCt78W12LkfIT3Eu9sfjeYZg2vZEZk/hRoXFJ7N4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SoZLZGrRifPx89Lb596iMmd7p8lLHP7W2S601Yg+pRBC3eK5ziIs5vW0pRkntvG/BtEDkVJ7cfFC71Pqpoe3rgnb0WvrCMdaugCFsNgu6aj2XC7k863fhknOzoN/ZDM1qQEFr7F06p4AVj4TtP17L+JwHOd9xUSXC9ik4b/wOsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ea1w4V+i; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018F0C116B1;
	Wed, 24 Apr 2024 03:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928982;
	bh=zmlWCt78W12LkfIT3Eu9sfjeYZg2vZEZk/hRoXFJ7N4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ea1w4V+iPPboHTXEd9mxExJOFNSfsaybkhbaidxUp9cy6WNMBjNo8Gcc0NxbtNyx8
	 tGWChELs9wi+zJKMR1ekft4ap139xZ/1A8RvaViM8jT0p5Skdq1Xek9kRWAxDyXaQb
	 GOvSHdqRLqC7BLKpv3yuOMwY5hKQNsnX9KBEuVRY8onlFFizDMJy8iQuIls5Tg83Rn
	 6oHePXuGyfO2WYFXOTsWt1uvPhQ71rDeBUEgLmaHBOxNTywRDq3JdXJ0tAgTd6sCKH
	 ebBCfq29dU/fiEcXYg3YWCHy29XlGw7QwGB+BM72b9AT3nyXq2vDdQK8X/Y61SIA7b
	 QiN4LQpBZF3Bg==
Date: Tue, 23 Apr 2024 20:23:01 -0700
Subject: [PATCH 03/16] xfs: salvage parent pointers when rebuilding xattr
 structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392784701.1906420.17331344968780474405.stgit@frogsfrogsfrogs>
In-Reply-To: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
References: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
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

When we're salvaging extended attributes, make sure we validate the ones
that claim to be parent pointers before adding them to the salvage pile.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr_repair.c |   36 +++++++++++++++++++++++++++---------
 fs/xfs/scrub/trace.h       |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index cbcc446d5119..48443e88e298 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -28,6 +28,7 @@
 #include "xfs_exchmaps.h"
 #include "xfs_exchrange.h"
 #include "xfs_acl.h"
+#include "xfs_parent.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -127,6 +128,9 @@ xrep_xattr_want_salvage(
 		return false;
 	if (valuelen > XATTR_SIZE_MAX || valuelen < 0)
 		return false;
+	if (attr_flags & XFS_ATTR_PARENT)
+		return xfs_parent_valuecheck(rx->sc->mp, value, valuelen);
+
 	return true;
 }
 
@@ -154,14 +158,21 @@ xrep_xattr_salvage_key(
 	 * Truncate the name to the first character that would trip namecheck.
 	 * If we no longer have a name after that, ignore this attribute.
 	 */
-	while (i < namelen && name[i] != 0)
-		i++;
-	if (i == 0)
-		return 0;
-	key.namelen = i;
+	if (flags & XFS_ATTR_PARENT) {
+		key.namelen = namelen;
 
-	trace_xrep_xattr_salvage_rec(rx->sc->ip, flags, name, key.namelen,
-			valuelen);
+		trace_xrep_xattr_salvage_pptr(rx->sc->ip, flags, name,
+				key.namelen, value, valuelen);
+	} else {
+		while (i < namelen && name[i] != 0)
+			i++;
+		if (i == 0)
+			return 0;
+		key.namelen = i;
+
+		trace_xrep_xattr_salvage_rec(rx->sc->ip, flags, name,
+				key.namelen, valuelen);
+	}
 
 	error = xfblob_store(rx->xattr_blobs, &key.name_cookie, name,
 			key.namelen);
@@ -598,8 +609,15 @@ xrep_xattr_insert_rec(
 
 	ab->name[key->namelen] = 0;
 
-	trace_xrep_xattr_insert_rec(rx->sc->tempip, key->flags, ab->name,
-			key->namelen, key->valuelen);
+	if (key->flags & XFS_ATTR_PARENT) {
+		trace_xrep_xattr_insert_pptr(rx->sc->tempip, key->flags,
+				ab->name, key->namelen, ab->value,
+				key->valuelen);
+		args.op_flags |= XFS_DA_OP_LOGGED;
+	} else {
+		trace_xrep_xattr_insert_rec(rx->sc->tempip, key->flags,
+				ab->name, key->namelen, key->valuelen);
+	}
 
 	/*
 	 * xfs_attr_set creates and commits its own transaction.  If the attr
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 3e726610b9e3..4b968df3d840 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2540,6 +2540,44 @@ DEFINE_EVENT(xrep_xattr_salvage_class, name, \
 DEFINE_XREP_XATTR_SALVAGE_EVENT(xrep_xattr_salvage_rec);
 DEFINE_XREP_XATTR_SALVAGE_EVENT(xrep_xattr_insert_rec);
 
+DECLARE_EVENT_CLASS(xrep_pptr_salvage_class,
+	TP_PROTO(struct xfs_inode *ip, unsigned int flags, const void *name,
+		 unsigned int namelen, const void *value, unsigned int valuelen),
+	TP_ARGS(ip, flags, name, namelen, value, valuelen),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_ino_t, parent_ino)
+		__field(unsigned int, parent_gen)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, namelen)
+	),
+	TP_fast_assign(
+		const struct xfs_parent_rec	*rec = value;
+
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->parent_ino = be64_to_cpu(rec->p_ino);
+		__entry->parent_gen = be32_to_cpu(rec->p_gen);
+		__entry->namelen = namelen;
+		memcpy(__get_str(name), name, namelen);
+	),
+	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->parent_ino,
+		  __entry->parent_gen,
+		  __entry->namelen,
+		  __get_str(name))
+)
+#define DEFINE_XREP_PPTR_SALVAGE_EVENT(name) \
+DEFINE_EVENT(xrep_pptr_salvage_class, name, \
+	TP_PROTO(struct xfs_inode *ip, unsigned int flags, const void *name, \
+		 unsigned int namelen, const void *value, unsigned int valuelen), \
+	TP_ARGS(ip, flags, name, namelen, value, valuelen))
+DEFINE_XREP_PPTR_SALVAGE_EVENT(xrep_xattr_salvage_pptr);
+DEFINE_XREP_PPTR_SALVAGE_EVENT(xrep_xattr_insert_pptr);
+
 TRACE_EVENT(xrep_xattr_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_inode *arg_ip),
 	TP_ARGS(ip, arg_ip),


