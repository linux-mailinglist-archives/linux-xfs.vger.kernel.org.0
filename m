Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77232753DD7
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Jul 2023 16:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236126AbjGNOmj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Jul 2023 10:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236134AbjGNOmf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 10:42:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF19535AC
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 07:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BAD161D30
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 14:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A2FC433C8;
        Fri, 14 Jul 2023 14:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689345751;
        bh=yRbcM3rSaR6qgTH9sRf6k8ylcZ6KhBjAjWjJ4eiKBhU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fVn8LihyNV76z4p+jGVAVLPkgVjEUKOASksM2fIeYjWkdmB0WtUYLoVRnsc4g7YZy
         T/4A4uZKQMxGPS9Vrr84sI2msvjm+EUaM+hoK2hoOOMkrFzUpoaNjgw5+pMkBsOG43
         VwnCpHVGmXs9/kot9i43Jpqpk97cf5rVLmH1YsXvbDGA0p7jdrc3RzVlkpkJ7IK7FQ
         Vfppd9Q7FhC0zfkLffcYbaCmkIHBY2+zXxlIZyw/qrD+Te6sfJ9zln2qyhwQk+RgjS
         MAs5oOv/OXWHv/unHhrNk/L6TNo5DOHBVW06B6bZFu2MBpbKEA4Caq4HDQnvFKhjOv
         Z0btepPWF6KUA==
Subject: [PATCH 2/3] xfs: convert flex-array declarations in xfs attr leaf
 blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, keescook@chromium.org
Date:   Fri, 14 Jul 2023 07:42:30 -0700
Message-ID: <168934575091.3353217.2520087245956820631.stgit@frogsfrogsfrogs>
In-Reply-To: <168934573961.3353217.18139786322840965874.stgit@frogsfrogsfrogs>
References: <168934573961.3353217.18139786322840965874.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

As of 6.5-rc1, UBSAN trips over the ondisk extended attribute leaf block
definitions using an array length of 1 to pretend to be a flex array.
Kernel compilers have to support unbounded array declarations, so let's
correct this.

================================================================================
UBSAN: array-index-out-of-bounds in fs/xfs/libxfs/xfs_attr_leaf.c:2535:24
index 2 is out of range for type '__u8 [1]'
Call Trace:
 <TASK>
 dump_stack_lvl+0x33/0x50
 __ubsan_handle_out_of_bounds+0x9c/0xd0
 xfs_attr3_leaf_getvalue+0x2ce/0x2e0 [xfs 4a986a89a77bb77402ab8a87a37da369ef6a3f09]
 xfs_attr_leaf_get+0x148/0x1c0 [xfs 4a986a89a77bb77402ab8a87a37da369ef6a3f09]
 xfs_attr_get_ilocked+0xae/0x110 [xfs 4a986a89a77bb77402ab8a87a37da369ef6a3f09]
 xfs_attr_get+0xee/0x150 [xfs 4a986a89a77bb77402ab8a87a37da369ef6a3f09]
 xfs_xattr_get+0x7d/0xc0 [xfs 4a986a89a77bb77402ab8a87a37da369ef6a3f09]
 __vfs_getxattr+0xa3/0x100
 vfs_getxattr+0x87/0x1d0
 do_getxattr+0x17a/0x220
 getxattr+0x89/0xf0

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h |   73 +++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_ondisk.h           |    4 +-
 2 files changed, 67 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 25e2841084e1..b2362717c42e 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -620,19 +620,29 @@ typedef struct xfs_attr_leaf_entry {	/* sorted on key, not name */
 typedef struct xfs_attr_leaf_name_local {
 	__be16	valuelen;		/* number of bytes in value */
 	__u8	namelen;		/* length of name bytes */
-	__u8	nameval[1];		/* name/value bytes */
+	/*
+	 * In Linux 6.5 this flex array was converted from nameval[1] to
+	 * nameval[].  Be very careful here about extra padding at the end;
+	 * see xfs_attr_leaf_entsize_local() for details.
+	 */
+	__u8	nameval[];		/* name/value bytes */
 } xfs_attr_leaf_name_local_t;
 
 typedef struct xfs_attr_leaf_name_remote {
 	__be32	valueblk;		/* block number of value bytes */
 	__be32	valuelen;		/* number of bytes in value */
 	__u8	namelen;		/* length of name bytes */
-	__u8	name[1];		/* name bytes */
+	/*
+	 * In Linux 6.5 this flex array was converted from name[1] to name[].
+	 * Be very careful here about extra padding at the end; see
+	 * xfs_attr_leaf_entsize_remote() for details.
+	 */
+	__u8	name[];			/* name bytes */
 } xfs_attr_leaf_name_remote_t;
 
 typedef struct xfs_attr_leafblock {
 	xfs_attr_leaf_hdr_t	hdr;	/* constant-structure header block */
-	xfs_attr_leaf_entry_t	entries[1];	/* sorted on key, not name */
+	xfs_attr_leaf_entry_t	entries[];	/* sorted on key, not name */
 	/*
 	 * The rest of the block contains the following structures after the
 	 * leaf entries, growing from the bottom up. The variables are never
@@ -664,7 +674,7 @@ struct xfs_attr3_leaf_hdr {
 
 struct xfs_attr3_leafblock {
 	struct xfs_attr3_leaf_hdr	hdr;
-	struct xfs_attr_leaf_entry	entries[1];
+	struct xfs_attr_leaf_entry	entries[];
 
 	/*
 	 * The rest of the block contains the following structures after the
@@ -747,14 +757,61 @@ xfs_attr3_leaf_name_local(xfs_attr_leafblock_t *leafp, int idx)
  */
 static inline int xfs_attr_leaf_entsize_remote(int nlen)
 {
-	return round_up(sizeof(struct xfs_attr_leaf_name_remote) - 1 +
-			nlen, XFS_ATTR_LEAF_NAME_ALIGN);
+	/*
+	 * Prior to Linux 6.5, struct xfs_attr_leaf_name_remote ended with
+	 * name[1], which was used as a flexarray.  The layout of this struct
+	 * is 9 bytes of fixed-length fields followed by a __u8 flex array at
+	 * offset 9.
+	 *
+	 * On most architectures, struct xfs_attr_leaf_name_remote had two
+	 * bytes of implicit padding at the end of the struct to make the
+	 * struct length 12.  After converting name[1] to name[], there are
+	 * three implicit padding bytes and the struct size remains 12.
+	 * However, there are compiler configurations that do not add implicit
+	 * padding at all (m68k) and have been broken for years.
+	 *
+	 * This entsize computation historically added (the xattr name length)
+	 * to (the padded struct length - 1) and rounded that sum up to the
+	 * nearest multiple of 4 (NAME_ALIGN).  IOWs, round_up(11 + nlen, 4).
+	 * This is encoded in the ondisk format, so we cannot change this.
+	 *
+	 * Compute the entsize from offsetof of the flexarray and manually
+	 * adding bytes for the implicit padding.
+	 */
+	const size_t remotesize =
+			offsetof(struct xfs_attr_leaf_name_remote, name) + 2;
+
+	return round_up(remotesize + nlen, XFS_ATTR_LEAF_NAME_ALIGN);
 }
 
 static inline int xfs_attr_leaf_entsize_local(int nlen, int vlen)
 {
-	return round_up(sizeof(struct xfs_attr_leaf_name_local) - 1 +
-			nlen + vlen, XFS_ATTR_LEAF_NAME_ALIGN);
+	/*
+	 * Prior to Linux 6.5, struct xfs_attr_leaf_name_local ended with
+	 * nameval[1], which was used as a flexarray.  The layout of this
+	 * struct is 3 bytes of fixed-length fields followed by a __u8 flex
+	 * array at offset 3.
+	 *
+	 * struct xfs_attr_leaf_name_local had zero bytes of implicit padding
+	 * at the end of the struct to make the struct length 4.  On most
+	 * architectures, after converting nameval[1] to nameval[], there is
+	 * one implicit padding byte and the struct size remains 4.  However,
+	 * there are compiler configurations that do not add implicit padding
+	 * at all (m68k) and would break.
+	 *
+	 * This entsize computation historically added (the xattr name and
+	 * value length) to (the padded struct length - 1) and rounded that sum
+	 * up to the nearest multiple of 4 (NAME_ALIGN).  IOWs, the formula is
+	 * round_up(3 + nlen + vlen, 4).  This is encoded in the ondisk format,
+	 * so we cannot change this.
+	 *
+	 * Compute the entsize from offsetof of the flexarray and manually
+	 * adding bytes for the implicit padding.
+	 */
+	const size_t localsize =
+			offsetof(struct xfs_attr_leaf_name_local, nameval);
+
+	return round_up(localsize + nlen + vlen, XFS_ATTR_LEAF_NAME_ALIGN);
 }
 
 static inline int xfs_attr_leaf_entsize_local_max(int bsize)
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 9737b5a9f405..37be297f2532 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -56,7 +56,7 @@ xfs_check_ondisk_structs(void)
 
 	/* dir/attr trees */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leaf_hdr,	80);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leafblock,	88);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leafblock,	80);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_rmt_hdr,		56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_da3_blkinfo,		56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_da3_intnode,		64);
@@ -88,7 +88,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, valuelen,	4);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, namelen,	8);
 	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, name,	9);
-	XFS_CHECK_STRUCT_SIZE(xfs_attr_leafblock_t,		40);
+	XFS_CHECK_STRUCT_SIZE(xfs_attr_leafblock_t,		32);
 	XFS_CHECK_OFFSET(struct xfs_attr_shortform, hdr.totsize, 0);
 	XFS_CHECK_OFFSET(struct xfs_attr_shortform, hdr.count,	 2);
 	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].namelen,	4);

