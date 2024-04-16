Return-Path: <linux-xfs+bounces-6847-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0770D8A6042
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Apr 2024 03:28:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 54BC8B22948
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Apr 2024 01:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6382E6AC0;
	Tue, 16 Apr 2024 01:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eGnZtaOY"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232C5539C
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230904; cv=none; b=KA7Tg7u3zkfFd3u7GiPZFUkb77bLiz/b1H0yCfyU7UyN+BetdNmnq5Fh7ioXjNTRU1asRtbbwAMZhK6uFuTpuIFBMqiSPX6AflO2JtyxXHUJihMXuCMqailtpM6DR16giV42f62m61GhHxFNiiCGpQfEFT6kURT0UJMioB64QPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230904; c=relaxed/simple;
	bh=vkpw+elBv6oE5eKmg2PEape9LvIOkDDn9bBU+9BhJH8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bne30ZZpnKk60ClT6NL30nI/IKckgikyIbSFJzFRG9IyII8LwruQVnlZvIQq2gXadz1rwEDjo+8Z89g5pJXP+O0KpB2UOKRKbfauktE3C5qOLa0Y75Bhyx20qXMV+0cleMrUDR6tQuJF/MPMc0cLsUQYQnlUexVoVYDvE2C7+S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eGnZtaOY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A4BC113CC;
	Tue, 16 Apr 2024 01:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230904;
	bh=vkpw+elBv6oE5eKmg2PEape9LvIOkDDn9bBU+9BhJH8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eGnZtaOYZOxhmHKOvckurBa2MP+L3kzBQXwtdSJ4XlJQmmeM0o41gzw0yprxqboWQ
	 mE/coGIh7KoWJRtc1DOHSyoxN292scA02/0gWMtsIH38MeH5yAt5c0OM5aoCpNVggp
	 8PV61RhLLjodczHLsbkWjfsy63qs/xUx7EdrEXFRaNWVgYxk+CGWnGHgEi5YZJ/6wi
	 yCWL8mS0LBJuf8mVvwY8E7o/hzRuADymaMKRkScE2SB+jXAmSIn62gvFcwXh/06CRu
	 EM+5E+M9VXvYdHsmRHD/U+O3IvjGIVyqyD3WbSxh4Z4STTxEt5bBMi7rL+HaDdrrqg
	 8uMorD5c5tU4Q==
Date: Mon, 15 Apr 2024 18:28:23 -0700
Subject: [PATCH 09/31] xfs: create attr log item opcodes and formats for
 parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, hch@infradead.org,
 linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Message-ID: <171323027932.251715.16939257031484099364.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
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

Make the necessary alterations to the extended attribute log intent item
ondisk format so that we can log parent pointer operations.  This
requires the creation of new opcodes specific to parent pointers, and a
new four-argument replace operation to handle renames.  At this point
this part of the patchset has changed so much from what Allison original
wrote that I no longer think her SoB applies.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |   19 +++
 fs/xfs/libxfs/xfs_attr.h       |    4 -
 fs/xfs/libxfs/xfs_da_btree.h   |    4 +
 fs/xfs/libxfs/xfs_log_format.h |   22 +++-
 fs/xfs/xfs_attr_item.c         |  245 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_attr_item.h         |    4 +
 6 files changed, 277 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8262c263be9d1..78c87c405e33c 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -439,6 +439,23 @@ xfs_attr_hashval(
 	return xfs_attr_hashname(name, namelen);
 }
 
+/*
+ * PPTR_REPLACE operations require the caller to set the old and new names and
+ * values explicitly.  Update the canonical fields to the new name and value
+ * here now that the removal phase has finished.
+ */
+static void
+xfs_attr_update_pptr_replace_args(
+	struct xfs_da_args	*args)
+{
+	ASSERT(args->new_namelen > 0);
+	args->name = args->new_name;
+	args->namelen = args->new_namelen;
+	args->value = args->new_value;
+	args->valuelen = args->new_valuelen;
+	xfs_attr_sethash(args);
+}
+
 /*
  * Handle the state change on completion of a multi-state attr operation.
  *
@@ -459,6 +476,8 @@ xfs_attr_complete_op(
 
 	if (!(args->op_flags & XFS_DA_OP_REPLACE))
 		replace_state = XFS_DAS_DONE;
+	else if (xfs_attr_intent_op(attr) == XFS_ATTRI_OP_FLAGS_PPTR_REPLACE)
+		xfs_attr_update_pptr_replace_args(args);
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
 	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index c63b1d610e53b..d0ed7ea58ab0f 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -510,8 +510,8 @@ struct xfs_attr_intent {
 	struct xfs_da_args		*xattri_da_args;
 
 	/*
-	 * Shared buffer containing the attr name and value so that the logging
-	 * code can share large memory buffers between log items.
+	 * Shared buffer containing the attr name, new name, and value so that
+	 * the logging code can share large memory buffers between log items.
 	 */
 	struct xfs_attri_log_nameval	*xattri_nameval;
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 17cef594b5bbb..354d5d65043e4 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -55,7 +55,9 @@ enum xfs_dacmp {
 typedef struct xfs_da_args {
 	struct xfs_da_geometry *geo;	/* da block geometry */
 	const uint8_t	*name;		/* string (maybe not NULL terminated) */
+	const uint8_t	*new_name;	/* new attr name */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
+	void		*new_value;	/* new xattr value (may contain NULLs) */
 	struct xfs_inode *dp;		/* directory inode to manipulate */
 	struct xfs_trans *trans;	/* current trans (changes over time) */
 
@@ -63,10 +65,12 @@ typedef struct xfs_da_args {
 	xfs_ino_t	owner;		/* inode that owns the dir/attr data */
 
 	int		valuelen;	/* length of value */
+	int		new_valuelen;	/* length of new_value */
 	uint8_t		filetype;	/* filetype of inode for directories */
 	uint8_t		op_flags;	/* operation flags */
 	uint8_t		attr_filter;	/* XFS_ATTR_{ROOT,SECURE,INCOMPLETE} */
 	short		namelen;	/* length of string (maybe no NULL) */
+	short		new_namelen;	/* length of new attr name */
 	xfs_dahash_t	hashval;	/* hash value of name */
 	xfs_extlen_t	total;		/* total blocks needed, for 1st bmap */
 	int		whichfork;	/* data or attribute fork */
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 020aebd101432..632dd97324557 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -115,11 +115,13 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_BUD_FORMAT	26
 #define XLOG_REG_TYPE_ATTRI_FORMAT	27
 #define XLOG_REG_TYPE_ATTRD_FORMAT	28
-#define XLOG_REG_TYPE_ATTR_NAME	29
+#define XLOG_REG_TYPE_ATTR_NAME		29
 #define XLOG_REG_TYPE_ATTR_VALUE	30
 #define XLOG_REG_TYPE_XMI_FORMAT	31
 #define XLOG_REG_TYPE_XMD_FORMAT	32
-#define XLOG_REG_TYPE_MAX		32
+#define XLOG_REG_TYPE_ATTR_NEWNAME	33
+#define XLOG_REG_TYPE_ATTR_NEWVALUE	34
+#define XLOG_REG_TYPE_MAX		34
 
 /*
  * Flags to log operation header
@@ -1026,6 +1028,9 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_OP_FLAGS_SET		1	/* Set the attribute */
 #define XFS_ATTRI_OP_FLAGS_REMOVE	2	/* Remove the attribute */
 #define XFS_ATTRI_OP_FLAGS_REPLACE	3	/* Replace the attribute */
+#define XFS_ATTRI_OP_FLAGS_PPTR_SET	4	/* Set parent pointer */
+#define XFS_ATTRI_OP_FLAGS_PPTR_REMOVE	5	/* Remove parent pointer */
+#define XFS_ATTRI_OP_FLAGS_PPTR_REPLACE	6	/* Replace parent pointer */
 #define XFS_ATTRI_OP_FLAGS_TYPE_MASK	0xFF	/* Flags type mask */
 
 /*
@@ -1048,7 +1053,18 @@ struct xfs_attri_log_format {
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
-	uint32_t	alfi_name_len;	/* attr name length */
+	union {
+		uint32_t	alfi_name_len;	/* attr name length */
+		struct {
+			/*
+			 * For PPTR_REPLACE, these are the lengths of the old
+			 * and new attr names.  The new and old values must
+			 * have the same length.
+			 */
+			uint16_t	alfi_old_name_len;
+			uint16_t	alfi_new_name_len;
+		};
+	};
 	uint32_t	alfi_value_len;	/* attr value length */
 	uint32_t	alfi_attr_filter;/* attr filter flags */
 };
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 413e3d3959a5d..8fc03195d9751 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -73,8 +73,12 @@ static inline struct xfs_attri_log_nameval *
 xfs_attri_log_nameval_alloc(
 	const void			*name,
 	unsigned int			name_len,
+	const void			*new_name,
+	unsigned int			new_name_len,
 	const void			*value,
-	unsigned int			value_len)
+	unsigned int			value_len,
+	const void			*new_value,
+	unsigned int			new_value_len)
 {
 	struct xfs_attri_log_nameval	*nv;
 
@@ -83,15 +87,26 @@ xfs_attri_log_nameval_alloc(
 	 * this. But kvmalloc() utterly sucks, so we use our own version.
 	 */
 	nv = xlog_kvmalloc(sizeof(struct xfs_attri_log_nameval) +
-					name_len + value_len);
+					name_len + new_name_len + value_len +
+					new_value_len);
 
 	nv->name.i_addr = nv + 1;
 	nv->name.i_len = name_len;
 	nv->name.i_type = XLOG_REG_TYPE_ATTR_NAME;
 	memcpy(nv->name.i_addr, name, name_len);
 
+	if (new_name_len) {
+		nv->new_name.i_addr = nv->name.i_addr + name_len;
+		nv->new_name.i_len = new_name_len;
+		memcpy(nv->new_name.i_addr, new_name, new_name_len);
+	} else {
+		nv->new_name.i_addr = NULL;
+		nv->new_name.i_len = 0;
+	}
+	nv->new_name.i_type = XLOG_REG_TYPE_ATTR_NEWNAME;
+
 	if (value_len) {
-		nv->value.i_addr = nv->name.i_addr + name_len;
+		nv->value.i_addr = nv->name.i_addr + name_len + new_name_len;
 		nv->value.i_len = value_len;
 		memcpy(nv->value.i_addr, value, value_len);
 	} else {
@@ -100,6 +115,17 @@ xfs_attri_log_nameval_alloc(
 	}
 	nv->value.i_type = XLOG_REG_TYPE_ATTR_VALUE;
 
+	if (new_value_len) {
+		nv->new_value.i_addr = nv->name.i_addr + name_len +
+						new_name_len + value_len;
+		nv->new_value.i_len = new_value_len;
+		memcpy(nv->new_value.i_addr, new_value, new_value_len);
+	} else {
+		nv->new_value.i_addr = NULL;
+		nv->new_value.i_len = 0;
+	}
+	nv->new_value.i_type = XLOG_REG_TYPE_ATTR_NEWVALUE;
+
 	refcount_set(&nv->refcount, 1);
 	return nv;
 }
@@ -145,11 +171,20 @@ xfs_attri_item_size(
 	*nbytes += sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(nv->name.i_len);
 
-	if (!nv->value.i_len)
-		return;
+	if (nv->new_name.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->new_name.i_len);
+	}
 
-	*nvecs += 1;
-	*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	if (nv->value.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->value.i_len);
+	}
+
+	if (nv->new_value.i_len) {
+		*nvecs += 1;
+		*nbytes += xlog_calc_iovec_len(nv->new_value.i_len);
+	}
 }
 
 /*
@@ -179,15 +214,28 @@ xfs_attri_item_format(
 	ASSERT(nv->name.i_len > 0);
 	attrip->attri_format.alfi_size++;
 
+	if (nv->new_name.i_len > 0)
+		attrip->attri_format.alfi_size++;
+
 	if (nv->value.i_len > 0)
 		attrip->attri_format.alfi_size++;
 
+	if (nv->new_value.i_len > 0)
+		attrip->attri_format.alfi_size++;
+
 	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
 			&attrip->attri_format,
 			sizeof(struct xfs_attri_log_format));
 	xlog_copy_from_iovec(lv, &vecp, &nv->name);
+
+	if (nv->new_name.i_len > 0)
+		xlog_copy_from_iovec(lv, &vecp, &nv->new_name);
+
 	if (nv->value.i_len > 0)
 		xlog_copy_from_iovec(lv, &vecp, &nv->value);
+
+	if (nv->new_value.i_len > 0)
+		xlog_copy_from_iovec(lv, &vecp, &nv->new_value);
 }
 
 /*
@@ -322,6 +370,8 @@ xfs_attr_log_item(
 	const struct xfs_attr_intent	*attr)
 {
 	struct xfs_attri_log_format	*attrp;
+	struct xfs_attri_log_nameval	*nv = attr->xattri_nameval;
+	struct xfs_da_args		*args = attr->xattri_da_args;
 
 	/*
 	 * At this point the xfs_attr_intent has been constructed, and we've
@@ -329,13 +379,25 @@ xfs_attr_log_item(
 	 * structure with fields from this xfs_attr_intent
 	 */
 	attrp = &attrip->attri_format;
-	attrp->alfi_ino = attr->xattri_da_args->dp->i_ino;
+	attrp->alfi_ino = args->dp->i_ino;
 	ASSERT(!(attr->xattri_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK));
 	attrp->alfi_op_flags = attr->xattri_op_flags;
-	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
-	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
-	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
-	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
+	attrp->alfi_value_len = nv->value.i_len;
+
+	switch (xfs_attr_log_item_op(attrp)) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+		ASSERT(nv->value.i_len == nv->new_value.i_len);
+
+		attrp->alfi_old_name_len = nv->name.i_len;
+		attrp->alfi_new_name_len = nv->new_name.i_len;
+		break;
+	default:
+		attrp->alfi_name_len = nv->name.i_len;
+		break;
+	}
+
+	ASSERT(!(args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
+	attrp->alfi_attr_filter = args->attr_filter;
 }
 
 /* Get an ATTRI. */
@@ -374,8 +436,11 @@ xfs_attr_create_intent(
 		 * Transfer our reference to the name/value buffer to the
 		 * deferred work state structure.
 		 */
-		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
-				args->namelen, args->value, args->valuelen);
+		attr->xattri_nameval = xfs_attri_log_nameval_alloc(
+				args->name, args->namelen,
+				args->new_name, args->new_namelen,
+				args->value, args->valuelen,
+				args->new_value, args->new_valuelen);
 	}
 
 	attrip = xfs_attri_init(mp, attr->xattri_nameval);
@@ -494,6 +559,17 @@ xfs_attri_validate(
 		return false;
 
 	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+		if (!xfs_has_parent(mp))
+			return false;
+		if (attrp->alfi_value_len != sizeof(struct xfs_parent_rec))
+			return false;
+		if (!xfs_attri_validate_namelen(attrp->alfi_name_len))
+			return false;
+		if (!(attrp->alfi_attr_filter & XFS_ATTR_PARENT))
+			return false;
+		break;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		if (!xfs_is_using_logged_xattrs(mp))
@@ -511,6 +587,18 @@ xfs_attri_validate(
 		if (!xfs_attri_validate_namelen(attrp->alfi_name_len))
 			return false;
 		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+		if (!xfs_has_parent(mp))
+			return false;
+		if (!xfs_attri_validate_namelen(attrp->alfi_old_name_len))
+			return false;
+		if (!xfs_attri_validate_namelen(attrp->alfi_new_name_len))
+			return false;
+		if (attrp->alfi_value_len != sizeof(struct xfs_parent_rec))
+			return false;
+		if (!(attrp->alfi_attr_filter & XFS_ATTR_PARENT))
+			return false;
+		break;
 	default:
 		return false;
 	}
@@ -583,8 +671,12 @@ xfs_attri_recover_work(
 	args->whichfork = XFS_ATTR_FORK;
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
+	args->new_name = nv->new_name.i_addr;
+	args->new_namelen = nv->new_name.i_len;
 	args->value = nv->value.i_addr;
 	args->valuelen = nv->value.i_len;
+	args->new_value = nv->new_value.i_addr;
+	args->new_valuelen = nv->new_value.i_len;
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
@@ -592,6 +684,8 @@ xfs_attri_recover_work(
 	xfs_attr_sethash(args);
 
 	switch (xfs_attr_intent_op(attr)) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		args->total = xfs_attr_calc_size(args, &local);
@@ -600,6 +694,7 @@ xfs_attri_recover_work(
 		else
 			attr->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		attr->xattri_dela_state = xfs_attr_init_remove_state(args);
 		break;
@@ -700,7 +795,17 @@ xfs_attr_relog_intent(
 	new_attrp->alfi_ino = old_attrp->alfi_ino;
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
-	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+
+	switch (xfs_attr_log_item_op(old_attrp)) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+		new_attrp->alfi_new_name_len = old_attrp->alfi_new_name_len;
+		new_attrp->alfi_old_name_len = old_attrp->alfi_old_name_len;
+		break;
+	default:
+		new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+		break;
+	}
+
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	return &new_attrip->attri_item;
@@ -758,6 +863,41 @@ xfs_attr_defer_add(
 	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
 }
 
+void
+xfs_attr_defer_parent(
+	struct xfs_da_args	*args,
+	enum xfs_attr_defer_op	op)
+{
+	struct xfs_attr_intent	*new;
+
+	ASSERT(xfs_has_parent(args->dp->i_mount));
+	ASSERT(args->attr_filter & XFS_ATTR_PARENT);
+	ASSERT(args->op_flags & XFS_DA_OP_LOGGED);
+
+	new = kmem_cache_zalloc(xfs_attr_intent_cache, GFP_NOFS | __GFP_NOFAIL);
+	new->xattri_da_args = args;
+
+	switch (op) {
+	case XFS_ATTR_DEFER_SET:
+		new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_PPTR_SET;
+		new->xattri_dela_state = xfs_attr_init_add_state(args);
+		break;
+	case XFS_ATTR_DEFER_REPLACE:
+		ASSERT(args->new_valuelen == args->valuelen);
+
+		new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_PPTR_REPLACE;
+		new->xattri_dela_state = xfs_attr_init_replace_state(args);
+		break;
+	case XFS_ATTR_DEFER_REMOVE:
+		new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_PPTR_REMOVE;
+		new->xattri_dela_state = xfs_attr_init_remove_state(args);
+		break;
+	}
+
+	xfs_defer_add(args->trans, &new->xattri_list, &xfs_attr_defer_type);
+	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
+}
+
 const struct xfs_defer_op_type xfs_attr_defer_type = {
 	.name		= "attr",
 	.max_items	= 1,
@@ -824,9 +964,13 @@ xlog_recover_attri_commit_pass2(
 	struct xfs_attri_log_nameval	*nv;
 	const void			*attr_name;
 	const void			*attr_value = NULL;
+	const void			*attr_new_name = NULL;
+	const void			*attr_new_value = NULL;
 	size_t				len;
 	unsigned int			name_len = 0;
 	unsigned int			value_len = 0;
+	unsigned int			new_name_len = 0;
+	unsigned int			new_value_len = 0;
 	unsigned int			op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
@@ -847,6 +991,17 @@ xlog_recover_attri_commit_pass2(
 	/* Check the number of log iovecs makes sense for the op code. */
 	op = xfs_attr_log_item_op(attri_formatp);
 	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+		/* Log item, attr name, attr value */
+		if (item->ri_total != 3) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		name_len = attri_formatp->alfi_name_len;
+		value_len = attri_formatp->alfi_value_len;
+		break;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		/* Log item, attr name, attr value */
@@ -867,6 +1022,20 @@ xlog_recover_attri_commit_pass2(
 		}
 		name_len = attri_formatp->alfi_name_len;
 		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+		/*
+		 * Log item, attr name, new attr name, attr value, new attr
+		 * value
+		 */
+		if (item->ri_total != 5) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		name_len = attri_formatp->alfi_old_name_len;
+		new_name_len = attri_formatp->alfi_new_name_len;
+		new_value_len = value_len = attri_formatp->alfi_value_len;
+		break;
 	default:
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				     attri_formatp, len);
@@ -881,6 +1050,16 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	i++;
 
+	/* Validate the new attr name */
+	if (new_name_len > 0) {
+		attr_new_name = xfs_attri_validate_name_iovec(mp,
+					attri_formatp, &item->ri_buf[i],
+					new_name_len);
+		if (!attr_new_name)
+			return -EFSCORRUPTED;
+		i++;
+	}
+
 	/* Validate the attr value, if present */
 	if (value_len != 0) {
 		attr_value = xfs_attri_validate_value_iovec(mp, attri_formatp,
@@ -890,6 +1069,16 @@ xlog_recover_attri_commit_pass2(
 		i++;
 	}
 
+	/* Validate the new attr value, if present */
+	if (new_value_len != 0) {
+		attr_new_value = xfs_attri_validate_value_iovec(mp,
+					attri_formatp, &item->ri_buf[i],
+					new_value_len);
+		if (!attr_new_value)
+			return -EFSCORRUPTED;
+		i++;
+	}
+
 	/*
 	 * Make sure we got the correct number of buffers for the operation
 	 * that we just loaded.
@@ -909,12 +1098,17 @@ xlog_recover_attri_commit_pass2(
 			return -EFSCORRUPTED;
 		}
 		fallthrough;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 		/*
 		 * Regular xattr set/remove/replace operations require a name
 		 * and do not take a newname.  Values are optional for set and
 		 * replace.
+		 *
+		 * Name-value set/remove operations must have a name, do not
+		 * take a newname, and can take a value.
 		 */
 		if (attr_name == NULL || name_len == 0) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
@@ -922,6 +1116,23 @@ xlog_recover_attri_commit_pass2(
 			return -EFSCORRUPTED;
 		}
 		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+		/*
+		 * Name-value replace operations require the caller to
+		 * specify the old and new names and values explicitly.
+		 * Values are optional.
+		 */
+		if (attr_name == NULL || name_len == 0) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		if (attr_new_name == NULL || new_name_len == 0) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
 	}
 
 	/*
@@ -930,7 +1141,9 @@ xlog_recover_attri_commit_pass2(
 	 * reference.
 	 */
 	nv = xfs_attri_log_nameval_alloc(attr_name, name_len,
-			attr_value, value_len);
+			attr_new_name, new_name_len,
+			attr_value, value_len,
+			attr_new_value, new_value_len);
 
 	attrip = xfs_attri_init(mp, nv);
 	memcpy(&attrip->attri_format, attri_formatp, len);
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index c32b669b0e16a..d5e4658f711d1 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -13,7 +13,9 @@ struct kmem_zone;
 
 struct xfs_attri_log_nameval {
 	struct xfs_log_iovec	name;
+	struct xfs_log_iovec	new_name;	/* PPTR_REPLACE only */
 	struct xfs_log_iovec	value;
+	struct xfs_log_iovec	new_value;	/* PPTR_REPLACE only */
 	refcount_t		refcount;
 
 	/* name and value follow the end of this struct */
@@ -58,5 +60,7 @@ enum xfs_attr_defer_op {
 };
 
 void xfs_attr_defer_add(struct xfs_da_args *args, enum xfs_attr_defer_op op);
+void xfs_attr_defer_parent(struct xfs_da_args *args,
+		enum xfs_attr_defer_op op);
 
 #endif	/* __XFS_ATTR_ITEM_H__ */


