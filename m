Return-Path: <linux-xfs+bounces-1361-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 635AE820DD7
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 21:38:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 840D41C218CD
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 20:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED7B2BA34;
	Sun, 31 Dec 2023 20:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NESIC/8S"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99EABA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C39CC433C8;
	Sun, 31 Dec 2023 20:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055131;
	bh=2K8Y1tTQxpmVYfCcCP7LH7MwHAzg6S4z3AAJL993mdg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NESIC/8SBJ3uAIMTVA0+bd4DdTTq1a8oRFs2NU4eYfwoHLT4C8ramp5QL8uft6Z18
	 uUjCUYwkLpMJCFRp/gI0p5+IhYjIjiSJKA8mE2hFzuSHrmbSEnpFYd64VAAXAL7OqW
	 ba+vTKlPMg1wOdkNfT0lCjqZJc/+6ZBor8A9GaEPrKhfH1J5fDCkGjIrWOvOLrTJKt
	 Bon+YcfBmcmn1CoBFDBCkKFUafmp5SMQL1FkbrO4XuD+B32Pemeqyz96Y0KvlXtVZ5
	 KsrXQWAvsbeatS2OtGQMjUG7zTYxhwparVy40b2y09DKGH6M6Zv1M1Wi/HK3nd1FSL
	 EaW6F07akjztQ==
Date: Sun, 31 Dec 2023 12:38:50 -0800
Subject: [PATCH 3/3] xfs: ensure dentry consistency when the orphanage adopts
 a file
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404836491.1753770.8880491971122860886.stgit@frogsfrogsfrogs>
In-Reply-To: <170404836433.1753770.18094386562668840224.stgit@frogsfrogsfrogs>
References: <170404836433.1753770.18094386562668840224.stgit@frogsfrogsfrogs>
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

When the orphanage adopts a file, that file becomes a child of the
orphanage.  The dentry cache may have entries for the orphanage
directory and the name we've chosen, so (1) make sure we abort if the
dcache has a positive entry because something's not right; and (2)
invalidate and purge negative dentries if the adoption goes through.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/orphanage.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h     |   42 ++++++++++++++++++++++
 2 files changed, 130 insertions(+)


diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 0aedc5c70b632..e1024a7bc9e96 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -418,6 +418,87 @@ xrep_adoption_compute_name(
 	return 0;
 }
 
+/*
+ * Make sure the dcache does not have a positive dentry for the name we've
+ * chosen.  The caller should have checked with the ondisk directory, so any
+ * discrepancy is a sign that something is seriously wrong.
+ */
+static int
+xrep_adoption_check_dcache(
+	struct xrep_adoption	*adopt)
+{
+	struct qstr		qname = QSTR_INIT(adopt->xname.name,
+						  adopt->xname.len);
+	struct dentry		*d_orphanage, *d_child;
+	int			error = 0;
+
+	d_orphanage = d_find_alias(VFS_I(adopt->sc->orphanage));
+	if (!d_orphanage)
+		return 0;
+
+	d_child = d_hash_and_lookup(d_orphanage, &qname);
+	if (d_child) {
+		trace_xrep_adoption_check_child(adopt->sc->mp, d_child);
+
+		if (d_is_positive(d_child)) {
+			ASSERT(d_is_negative(d_child));
+			error = -EFSCORRUPTED;
+		}
+
+		dput(d_child);
+	}
+
+	dput(d_orphanage);
+	if (error)
+		return error;
+
+	/*
+	 * Do we need to update d_parent of the dentry for the file being
+	 * repaired?  In theory there shouldn't be one since the file had
+	 * nonzero nlink but wasn't connected to any parent dir.
+	 */
+	d_child = d_find_alias(VFS_I(adopt->sc->ip));
+	if (d_child) {
+		trace_xrep_adoption_check_alias(adopt->sc->mp, d_child);
+		ASSERT(d_child->d_parent == NULL);
+
+		dput(d_child);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+/*
+ * Remove all negative dentries from the dcache.  There should not be any
+ * positive entries, since we've maintained our lock on the orphanage
+ * directory.
+ */
+static void
+xrep_adoption_zap_dcache(
+	struct xrep_adoption	*adopt)
+{
+	struct qstr		qname = QSTR_INIT(adopt->xname.name,
+						  adopt->xname.len);
+	struct dentry		*d_orphanage, *d_child;
+
+	d_orphanage = d_find_alias(VFS_I(adopt->sc->orphanage));
+	if (!d_orphanage)
+		return;
+
+	d_child = d_hash_and_lookup(d_orphanage, &qname);
+	while (d_child != NULL) {
+		trace_xrep_adoption_invalidate_child(adopt->sc->mp, d_child);
+
+		ASSERT(d_is_negative(d_child));
+		d_invalidate(d_child);
+		dput(d_child);
+		d_child = d_lookup(d_orphanage, &qname);
+	}
+
+	dput(d_orphanage);
+}
+
 /*
  * Move the current file to the orphanage under the computed name.
  *
@@ -436,6 +517,10 @@ xrep_adoption_move(
 	trace_xrep_adoption_reparent(sc->orphanage, &adopt->xname,
 			sc->ip->i_ino);
 
+	error = xrep_adoption_check_dcache(adopt);
+	if (error)
+		return error;
+
 	/* Create the new name in the orphanage. */
 	error = xfs_dir_createname(sc->tp, sc->orphanage, xname, sc->ip->i_ino,
 			adopt->orphanage_blkres);
@@ -466,6 +551,9 @@ xrep_adoption_move(
 	 * recorded in the log.
 	 */
 	xfs_dir_update_hook(sc->orphanage, sc->ip, 1, xname);
+
+	/* Remove negative dentries from the lost+found's dcache */
+	xrep_adoption_zap_dcache(adopt);
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 9c90b078d021a..3766fffd7eb08 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2750,6 +2750,48 @@ TRACE_EVENT(xrep_nlinks_set_record,
 		  __entry->children)
 );
 
+DECLARE_EVENT_CLASS(xrep_dentry_class,
+	TP_PROTO(struct xfs_mount *mp, const struct dentry *dentry),
+	TP_ARGS(mp, dentry),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, flags)
+		__field(unsigned long, ino)
+		__field(bool, positive)
+		__field(unsigned long, parent_ino)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, dentry->d_name.len)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->flags = dentry->d_flags;
+		__entry->positive = d_is_positive(dentry);
+		if (dentry->d_parent && d_inode(dentry->d_parent))
+			__entry->parent_ino = d_inode(dentry->d_parent)->i_ino;
+		else
+			__entry->parent_ino = -1UL;
+		__entry->ino = d_inode(dentry) ? d_inode(dentry)->i_ino : 0;
+		__entry->namelen = dentry->d_name.len;
+		memcpy(__get_str(name), dentry->d_name.name, dentry->d_name.len);
+	),
+	TP_printk("dev %d:%d flags 0x%x positive? %d parent_ino 0x%lx ino 0x%lx name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->flags,
+		  __entry->positive,
+		  __entry->parent_ino,
+		  __entry->ino,
+		  __entry->namelen,
+		  __get_str(name))
+);
+#define DEFINE_REPAIR_DENTRY_EVENT(name) \
+DEFINE_EVENT(xrep_dentry_class, name, \
+	TP_PROTO(struct xfs_mount *mp, const struct dentry *dentry), \
+	TP_ARGS(mp, dentry))
+DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_check_child);
+DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_check_alias);
+DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_check_dentry);
+DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_invalidate_child);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 


