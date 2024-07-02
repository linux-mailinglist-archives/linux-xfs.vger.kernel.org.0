Return-Path: <linux-xfs+bounces-10108-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 795AC91EC7A
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 03:14:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 066641F220B4
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 01:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A446AC133;
	Tue,  2 Jul 2024 01:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="INqTXsHu"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D79C129
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882892; cv=none; b=Ibx0FfZBGxZdupMv259/Y+hsBlv+sFcApf9MRR95HM3G+a1u3XZj23uGLesLJbsLkh0xzRTWI7n/kroLAcpMvEYRE9v4XxTQZBi6xgB7YFFeLywq4vBeijODyqjHpFxUsqLMdHczrSkpqRCK8UYhe3zeLB5T3IN4xcrHTJfxt/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882892; c=relaxed/simple;
	bh=pl5B5fcHgWV7epWapYJoHWGdbJenh+0yT7vyIk4A1qE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sqFMqJrcQutL45ccjhW5J9FL7UTVVE/IbA7j7JMS0+dbiFnzwNH78s0w+SACUb7aCVZieP+jaI4R9lOXgEsRD3IIY5b6wSrY3jEusY0uZFeDC6C2YjQCKrs2QaJkmD2ARANAxENCLmMD5rhj4akrYOFhDHzNuL18PLRLtq2o548=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=INqTXsHu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40749C116B1;
	Tue,  2 Jul 2024 01:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882892;
	bh=pl5B5fcHgWV7epWapYJoHWGdbJenh+0yT7vyIk4A1qE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=INqTXsHuh709M8HLxQd/D0nLsXXJTgIIZYopZLCx3H4dBBxMXW75BidxKM2Dxf+md
	 5s/gbzAqCzuI5auiarY+FI1oPDH1zKjv6KMsciz5EdPvZmzI2Q8mcdZCC/hsAhecDM
	 ekAQBMvH961s7Oi8ssEAQ3kTTJW8sar3N/RPNzvnRuiMGraBXEE/G1L6bMUdiuvFog
	 LNCCWhPeknMvhU0+y8w/vKA7FWOhl7c/CrzHB5DnbLNtQODMmEFRnZ1fGexig3LZYe
	 G0Y/5HyE6moG59mGXrMutHM+7DKRd6aJ/ABRu5UhJUa7egA9Ie/GROnsfdO2W01XYm
	 vRzX2leLHXcuA==
Date: Mon, 01 Jul 2024 18:14:51 -0700
Subject: [PATCH 16/24] xfs_db: obfuscate dirent and parent pointer names
 consistently
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121310.2009260.13863957257257204611.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
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

When someone wants to perform an obfuscated metadump of a filesystem
where parent pointers are enabled, we have to use the *exact* same
obfuscated name for both the directory entry and the parent pointer.

Create a name remapping table so that when we obfuscate a dirent name or
a parent pointer name, we can apply the same obfuscation when we find
the corresponding parent pointer or dirent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c            |  310 ++++++++++++++++++++++++++++++++++++++++++++--
 libxfs/libxfs_api_defs.h |    1 
 2 files changed, 299 insertions(+), 12 deletions(-)


diff --git a/db/metadump.c b/db/metadump.c
index c1bf5d002751..e95238fb0471 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -21,6 +21,14 @@
 #include "dir2.h"
 #include "obfuscate.h"
 
+#undef REMAP_DEBUG
+
+#ifdef REMAP_DEBUG
+# define remap_debug		printf
+#else
+# define remap_debug(...)	((void)0)
+#endif
+
 #define DEFAULT_MAX_EXT_SIZE	XFS_MAX_BMBT_EXTLEN
 
 /* copy all metadata structures to/from a file */
@@ -719,6 +727,111 @@ nametable_add(xfs_dahash_t hash, int namelen, unsigned char *name)
 	return ent;
 }
 
+/*
+ * Obfuscated name remapping table for parent pointer-enabled filesystems.
+ * When this feature is enabled, we have to maintain consistency between the
+ * names that appears in the dirent and the corresponding parent pointer.
+ */
+
+struct remap_ent {
+	struct remap_ent	*next;
+	xfs_ino_t		dir_ino;
+	xfs_dahash_t		namehash;
+	uint8_t			namelen;
+
+	uint8_t			names[];
+};
+
+static inline uint8_t *remap_ent_before(struct remap_ent *ent)
+{
+	return &ent->names[0];
+}
+
+static inline uint8_t *remap_ent_after(struct remap_ent *ent)
+{
+	return &ent->names[ent->namelen];
+}
+
+#define REMAP_TABLE_SIZE		4096
+
+static struct remap_ent		*remaptable[REMAP_TABLE_SIZE];
+
+static void
+remaptable_clear(void)
+{
+	int			i;
+	struct remap_ent	*ent, *next;
+
+	for (i = 0; i < REMAP_TABLE_SIZE; i++) {
+		ent = remaptable[i];
+
+		while (ent) {
+			next = ent->next;
+			free(ent);
+			ent = next;
+		}
+	}
+}
+
+/* Try to find a remapping table entry. */
+static struct remap_ent *
+remaptable_find(
+	xfs_ino_t		dir_ino,
+	xfs_dahash_t		namehash,
+	const unsigned char	*name,
+	unsigned int		namelen)
+{
+	struct remap_ent	*ent = remaptable[namehash % REMAP_TABLE_SIZE];
+
+	remap_debug("REMAP FIND: 0x%lx hash 0x%x '%.*s'\n",
+			dir_ino, namehash, namelen, name);
+
+	while (ent) {
+		remap_debug("REMAP ENT: 0x%lx hash 0x%x '%.*s'\n",
+				ent->dir_ino, ent->namehash, ent->namelen,
+				remap_ent_before(ent));
+
+		if (ent->dir_ino == dir_ino &&
+		    ent->namehash == namehash &&
+		    ent->namelen == namelen &&
+		    !memcmp(remap_ent_before(ent), name, namelen))
+			return ent;
+		ent = ent->next;
+	}
+
+	return NULL;
+}
+
+/* Remember the remapping for a particular dirent that we obfuscated. */
+static struct remap_ent *
+remaptable_add(
+	xfs_ino_t		dir_ino,
+	xfs_dahash_t		namehash,
+	const unsigned char	*old_name,
+	unsigned int		namelen,
+	const unsigned char	*new_name)
+{
+	struct remap_ent	*ent;
+
+	ent = malloc(sizeof(struct remap_ent) + (namelen * 2));
+	if (!ent)
+		return NULL;
+
+	ent->dir_ino = dir_ino;
+	ent->namehash = namehash;
+	ent->namelen = namelen;
+	memcpy(remap_ent_before(ent), old_name, namelen);
+	memcpy(remap_ent_after(ent), new_name, namelen);
+	ent->next = remaptable[namehash % REMAP_TABLE_SIZE];
+
+	remaptable[namehash % REMAP_TABLE_SIZE] = ent;
+
+	remap_debug("REMAP ADD: 0x%lx hash 0x%x '%.*s' -> '%.*s'\n",
+			dir_ino, namehash, namelen, old_name, namelen,
+			new_name);
+	return ent;
+}
+
 #define	ORPHANAGE	"lost+found"
 #define	ORPHANAGE_LEN	(sizeof (ORPHANAGE) - 1)
 
@@ -844,6 +957,7 @@ generate_obfuscated_name(
 	int			namelen,
 	unsigned char		*name)
 {
+	unsigned char		*orig_name = NULL;
 	xfs_dahash_t		hash;
 
 	/*
@@ -865,8 +979,37 @@ generate_obfuscated_name(
 		name++;
 
 	/* Obfuscate the name (if possible) */
-
 	hash = dirattr_hashname(ino != 0, name, namelen);
+
+	/*
+	 * If we're obfuscating a dirent name on a pptrs filesystem, see if we
+	 * already processed the parent pointer and use the same name.
+	 */
+	if (xfs_has_parent(mp) && ino) {
+		struct remap_ent	*remap;
+
+		remap = remaptable_find(metadump.cur_ino, hash, name, namelen);
+		if (remap) {
+			remap_debug("found obfuscated dir 0x%lx '%.*s' -> 0x%lx -> '%.*s' \n",
+					cur_ino, namelen,
+					remap_ent_before(remap), ino, namelen,
+					remap_ent_after(remap));
+			memcpy(name, remap_ent_after(remap), namelen);
+			return;
+		}
+
+		/*
+		 * If we haven't procesed this dirent name before, save the
+		 * old name for a remap table entry.  Obfuscate the name.
+		 */
+		orig_name = malloc(namelen);
+		if (!orig_name) {
+			orig_name = name;
+			goto add_remap;
+		}
+		memcpy(orig_name, name, namelen);
+	}
+
 	obfuscate_name(hash, namelen, name, ino != 0);
 	ASSERT(hash == dirattr_hashname(ino != 0, name, namelen));
 
@@ -891,6 +1034,26 @@ generate_obfuscated_name(
 				"in dir inode %llu\n",
 			(unsigned long long) ino,
 			(unsigned long long) metadump.cur_ino);
+
+	/*
+	 * We've obfuscated a name in the directory entry.  Remember this
+	 * remapping for when we come across the parent pointer later.
+	 */
+	if (!orig_name)
+		return;
+
+add_remap:
+	remap_debug("obfuscating dir 0x%lx '%.*s' -> 0x%lx -> '%.*s' \n",
+			metadump.cur_ino, namelen, orig_name, ino, namelen,
+			name);
+
+	if (!remaptable_add(metadump.cur_ino, hash, orig_name, namelen, name))
+		print_warning("unable to record remapped dirent name for inode %llu "
+				"in dir inode %llu\n",
+			(unsigned long long) ino,
+			(unsigned long long) metadump.cur_ino);
+	if (orig_name && orig_name != name)
+		free(orig_name);
 }
 
 static void
@@ -1026,6 +1189,106 @@ process_sf_symlink(
 		memset(&buf[len], 0, XFS_DFORK_DSIZE(dip, mp) - len);
 }
 
+/*
+ * Decide if we want to obfuscate this parent pointer.  If we do, either find
+ * the obfuscated name that we created when we scanned the corresponding dirent
+ * and replace the name with that; or create a new obfuscated name for later
+ * use.
+ */
+static void
+maybe_obfuscate_pptr(
+	unsigned int			attr_flags,
+	uint8_t				*name,
+	int				namelen,
+	const void			*value,
+	int				valuelen)
+{
+	unsigned char			old_name[MAXNAMELEN];
+	struct remap_ent		*remap;
+	xfs_dahash_t			hash;
+	xfs_ino_t			child_ino = metadump.cur_ino;
+	xfs_ino_t			parent_ino;
+	int				error;
+
+	if (!metadump.obfuscate)
+		return;
+
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return;
+
+	/* Do not obfuscate this parent pointer if it fails basic checks. */
+	error = -libxfs_parent_from_attr(mp, attr_flags, name, namelen, value,
+			valuelen, &parent_ino, NULL);
+	if (error)
+		return;
+	memcpy(old_name, name, namelen);
+
+	/*
+	 * We don't obfuscate "lost+found" or any orphan files therein.  When
+	 * the name table is used for extended attributes, the inode number
+	 * provided is 0, in which case we don't need to make this check.
+	 */
+	metadump.cur_ino = parent_ino;
+	if (in_lost_found(child_ino, namelen, name)) {
+		metadump.cur_ino = child_ino;
+		return;
+	}
+	metadump.cur_ino = child_ino;
+
+	hash = dirattr_hashname(true, name, namelen);
+
+	/*
+	 * If we already processed the dirent, use the same name for the parent
+	 * pointer.
+	 */
+	remap = remaptable_find(parent_ino, hash, name, namelen);
+	if (remap) {
+		remap_debug(
+ "found obfuscated pptr 0x%lx '%.*s' -> 0x%lx -> '%.*s' \n",
+				parent_ino, namelen, remap_ent_before(remap),
+				metadump.cur_ino, namelen,
+				remap_ent_after(remap));
+		memcpy(name, remap_ent_after(remap), namelen);
+		return;
+	}
+
+	/*
+	 * Obfuscate the parent pointer name and remember this for later
+	 * in case we encounter the dirent and need to reuse the name there.
+	 */
+	obfuscate_name(hash, namelen, name, true);
+
+	remap_debug("obfuscated pptr 0x%lx '%.*s' -> 0x%lx -> '%.*s'\n",
+			parent_ino, namelen, old_name, metadump.cur_ino,
+			namelen, name);
+	if (!remaptable_add(parent_ino, hash, old_name, namelen, name))
+		print_warning(
+ "unable to record remapped pptr name for inode %llu in dir inode %llu\n",
+			(unsigned long long) metadump.cur_ino,
+			(unsigned long long) parent_ino);
+}
+
+static inline bool
+want_obfuscate_attr(
+	unsigned int	nsp_flags,
+	const void	*name,
+	unsigned int	namelen,
+	const void	*value,
+	unsigned int	valuelen)
+{
+	if (!metadump.obfuscate)
+		return false;
+
+	/*
+	 * If we didn't already obfuscate the parent pointer, it's probably
+	 * corrupt.  Leave it intact for analysis.
+	 */
+	if (nsp_flags & XFS_ATTR_PARENT)
+		return false;
+
+	return true;
+}
+
 static void
 process_sf_attr(
 	struct xfs_dinode		*dip)
@@ -1053,7 +1316,7 @@ process_sf_attr(
 
 	for (i = 0; (i < hdr->count) &&
 			((char *)asfep - (char *)hdr < ino_attr_size); i++) {
-
+		void	*name, *value;
 		int	namelen = asfep->namelen;
 
 		if (namelen == 0) {
@@ -1070,11 +1333,16 @@ process_sf_attr(
 			break;
 		}
 
-		if (metadump.obfuscate) {
-			generate_obfuscated_name(0, asfep->namelen,
-						 &asfep->nameval[0]);
-			memset(&asfep->nameval[asfep->namelen], 'v',
-			       asfep->valuelen);
+		name = &asfep->nameval[0];
+		value = &asfep->nameval[asfep->namelen];
+
+		if (asfep->flags & XFS_ATTR_PARENT) {
+			maybe_obfuscate_pptr(asfep->flags, name, namelen,
+					value, asfep->valuelen);
+		} else if (want_obfuscate_attr(asfep->flags, name, namelen,
+					value, asfep->valuelen)) {
+			generate_obfuscated_name(0, asfep->namelen, name);
+			memset(value, 'v', asfep->valuelen);
 		}
 
 		asfep = (struct xfs_attr_sf_entry *)((char *)asfep +
@@ -1443,6 +1711,9 @@ process_attr_block(
 			break;
 		}
 		if (entry->flags & XFS_ATTR_LOCAL) {
+			void *name, *value;
+			unsigned int valuelen;
+
 			local = xfs_attr3_leaf_name_local(leaf, i);
 			if (local->namelen == 0) {
 				if (metadump.show_warnings)
@@ -1451,11 +1722,21 @@ process_attr_block(
 						(long long)metadump.cur_ino);
 				break;
 			}
-			if (metadump.obfuscate) {
+
+			name = &local->nameval[0];
+			value = &local->nameval[local->namelen];
+			valuelen = be16_to_cpu(local->valuelen);
+
+			if (entry->flags & XFS_ATTR_PARENT) {
+				maybe_obfuscate_pptr(entry->flags, name,
+						local->namelen, value,
+						valuelen);
+			} else if (want_obfuscate_attr(entry->flags, name,
+						local->namelen, value,
+						valuelen)) {
 				generate_obfuscated_name(0, local->namelen,
-					&local->nameval[0]);
-				memset(&local->nameval[local->namelen], 'v',
-					be16_to_cpu(local->valuelen));
+						name);
+				memset(value, 'v', valuelen);
 			}
 			/* zero from end of nameval[] to next name start */
 			nlen = local->namelen;
@@ -1474,7 +1755,11 @@ process_attr_block(
 						(long long)metadump.cur_ino);
 				break;
 			}
-			if (metadump.obfuscate) {
+			if (entry->flags & XFS_ATTR_PARENT) {
+				/* do not obfuscate obviously busted pptr */
+				add_remote_vals(be32_to_cpu(remote->valueblk),
+						be32_to_cpu(remote->valuelen));
+			} else if (metadump.obfuscate) {
 				generate_obfuscated_name(0, remote->namelen,
 							 &remote->name[0]);
 				add_remote_vals(be32_to_cpu(remote->valueblk),
@@ -3044,5 +3329,6 @@ metadump_f(
 		metadump.mdops->release();
 
 out:
+	remaptable_clear();
 	return 0;
 }
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index b7947591d2db..c3dde15116c4 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -193,6 +193,7 @@
 #define xfs_parent_add			libxfs_parent_add
 #define xfs_parent_finish		libxfs_parent_finish
 #define xfs_parent_start		libxfs_parent_start
+#define xfs_parent_from_attr		libxfs_parent_from_attr
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_hold			libxfs_perag_hold
 #define xfs_perag_put			libxfs_perag_put


