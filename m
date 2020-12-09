Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424062D4122
	for <lists+linux-xfs@lfdr.de>; Wed,  9 Dec 2020 12:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730766AbgLILbD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 9 Dec 2020 06:31:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20060 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729260AbgLILbD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Dec 2020 06:31:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607513374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+RsZ/MAJLT+7nYLqFrps7ZzthxWr7P9CynxskgXopO8=;
        b=b9vGtN4RaXlGfo2aYPLAdepHM0FAkIBU8uLnjQjb87KX1yK5OcHjWIZFZzZiBnEnCHRLS1
        uX6jVUSCKc1TSt3OLdhuB2Z+6dSqoa2Rn9qhQE9bEkEiRmpJLRNFN0/nSr+hsQBk+DJtX3
        Z+OOL/7R2XyPwLmd11IfsmkEqP4H0qE=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-Ny4xyFgLMOm1RnCxfnlp4A-1; Wed, 09 Dec 2020 06:29:33 -0500
X-MC-Unique: Ny4xyFgLMOm1RnCxfnlp4A-1
Received: by mail-pf1-f197.google.com with SMTP id r15so902894pfg.5
        for <linux-xfs@vger.kernel.org>; Wed, 09 Dec 2020 03:29:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+RsZ/MAJLT+7nYLqFrps7ZzthxWr7P9CynxskgXopO8=;
        b=SlErhq7uYq/tFe6GlSg6EJeyRQXp3aISrC3eo+tf5hrGriiXJfLX27SEmNltGXwGcC
         YrMPpMN82YVQ+QixY68LA1K3/oC/XTC1SJp9Ogj9j2Luh0uwM5kqHdpJIzsycpCPlVAi
         W0gTFZTGEUWqfhibdpaL30cNWlB+ntDnAur89h0NLRBAHZxOJuK/rQnGXD442G3nuGhn
         /264qFacTZ1k0PUqwklL1e3hcALIYGl13OHYhb+o2LELQ0FWRztKFeouuwwPZTHron1F
         /P3UyJqOJfM/bjG49Sx4I0+oXt6MeJgTOp92NfcMgZ8JEEWj0JDWdseFDjfLcHoh0tpr
         QU3Q==
X-Gm-Message-State: AOAM531p03JmtkU5wnn5VMfK7ppZtccwmAckHMa7cDB9PU23C6oQelPS
        ggczEzicOvKTwMYgMPIOTFPSazVLdFyZp1cxhrfANuCMkeAJ0mxz9La8+J1GS5T2zOGYt/cQURO
        QOHY/Xsn1+cCmWyxwzCdLvq+MWLT6bx3HcfY+Zs8bL8dJdu1GCQ58oGNkjsY0qrNd4D7joQQ2JQ
        ==
X-Received: by 2002:a62:cec1:0:b029:19e:5605:36a0 with SMTP id y184-20020a62cec10000b029019e560536a0mr1847538pfg.27.1607513371661;
        Wed, 09 Dec 2020 03:29:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQKqfHsji4c1bV1WMQXGMc/j+EdhnbtZ2XOYWLOdbRyY4JyO2LyJnCZ5JhzO1mGwaTCbmLjA==
X-Received: by 2002:a62:cec1:0:b029:19e:5605:36a0 with SMTP id y184-20020a62cec10000b029019e560536a0mr1847492pfg.27.1607513371057;
        Wed, 09 Dec 2020 03:29:31 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y5sm2231280pfp.45.2020.12.09.03.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 03:29:30 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <dchinner@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v5 3/6] xfs: move on-disk inode allocation out of xfs_ialloc()
Date:   Wed,  9 Dec 2020 19:28:17 +0800
Message-Id: <20201209112820.114863-4-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201209112820.114863-1-hsiangkao@redhat.com>
References: <20201209112820.114863-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So xfs_ialloc() will only address in-core inode allocation then,
Also, rename xfs_ialloc() to xfs_dir_ialloc_init() in order to
keep everything in xfs_inode.c under the same namespace.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_inode.c   | 219 +++++++++++++++----------------------------
 fs/xfs/xfs_inode.h   |   6 +-
 fs/xfs/xfs_qm.c      |  27 +++---
 fs/xfs/xfs_symlink.c |   8 +-
 4 files changed, 97 insertions(+), 163 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 76282da7a05c..07d692020da3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -761,68 +761,25 @@ xfs_inode_inherit_flags2(
 }
 
 /*
- * Allocate an inode on disk and return a copy of its in-core version.
- * The in-core inode is locked exclusively.  Set mode, nlink, and rdev
- * appropriately within the inode.  The uid and gid for the inode are
- * set according to the contents of the given cred structure.
- *
- * Use xfs_dialloc() to allocate the on-disk inode. If xfs_dialloc()
- * has a free inode available, call xfs_iget() to obtain the in-core
- * version of the allocated inode.  Finally, fill in the inode and
- * log its initial contents.  In this case, ialloc_context would be
- * set to NULL.
- *
- * If xfs_dialloc() does not have an available inode, it will replenish
- * its supply by doing an allocation. Since we can only do one
- * allocation within a transaction without deadlocks, we must commit
- * the current transaction before returning the inode itself.
- * In this case, therefore, we will set ialloc_context and return.
- * The caller should then commit the current transaction, start a new
- * transaction, and call xfs_ialloc() again to actually get the inode.
- *
- * To ensure that some other process does not grab the inode that
- * was allocated during the first call to xfs_ialloc(), this routine
- * also returns the [locked] bp pointing to the head of the freelist
- * as ialloc_context.  The caller should hold this buffer across
- * the commit and pass it back into this routine on the second call.
- *
- * If we are allocating quota inodes, we do not have a parent inode
- * to attach to or associate with (i.e. pip == NULL) because they
- * are not linked into the directory structure - they are attached
- * directly to the superblock - and so have no parent.
+ * Initialise a newly allocated inode and return the in-core inode to the
+ * caller locked exclusively.
  */
-static int
-xfs_ialloc(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*pip,
-	umode_t		mode,
-	xfs_nlink_t	nlink,
-	dev_t		rdev,
-	prid_t		prid,
-	xfs_buf_t	**ialloc_context,
-	xfs_inode_t	**ipp)
+static struct xfs_inode *
+xfs_init_new_inode(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*pip,
+	xfs_ino_t		ino,
+	umode_t			mode,
+	xfs_nlink_t		nlink,
+	dev_t			rdev,
+	prid_t			prid)
 {
-	struct xfs_mount *mp = tp->t_mountp;
-	xfs_ino_t	ino;
-	xfs_inode_t	*ip;
-	uint		flags;
-	int		error;
-	struct timespec64 tv;
-	struct inode	*inode;
-
-	/*
-	 * Call the space management code to pick
-	 * the on-disk inode to be allocated.
-	 */
-	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, mode,
-			    ialloc_context, &ino);
-	if (error)
-		return error;
-	if (*ialloc_context || ino == NULLFSINO) {
-		*ipp = NULL;
-		return 0;
-	}
-	ASSERT(*ialloc_context == NULL);
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*ip;
+	unsigned int		flags;
+	int			error;
+	struct timespec64	tv;
+	struct inode		*inode;
 
 	/*
 	 * Protect against obviously corrupt allocation btree records. Later
@@ -833,18 +790,16 @@ xfs_ialloc(
 	 */
 	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
 		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
-		return -EFSCORRUPTED;
+		return ERR_PTR(-EFSCORRUPTED);
 	}
 
 	/*
-	 * Get the in-core inode with the lock held exclusively.
-	 * This is because we're setting fields here we need
-	 * to prevent others from looking at until we're done.
+	 * Get the in-core inode with the lock held exclusively to prevent
+	 * others from looking at until we're done.
 	 */
-	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE,
-			 XFS_ILOCK_EXCL, &ip);
+	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE, XFS_ILOCK_EXCL, &ip);
 	if (error)
-		return error;
+		return ERR_PTR(error);
 	ASSERT(ip != NULL);
 	inode = VFS_I(ip);
 	inode->i_mode = mode;
@@ -926,22 +881,21 @@ xfs_ialloc(
 
 	/* now that we have an i_mode we can setup the inode structure */
 	xfs_setup_inode(ip);
-
-	*ipp = ip;
-	return 0;
+	return ip;
 }
 
 /*
- * Allocates a new inode from disk and return a pointer to the
- * incore copy. This routine will internally commit the current
- * transaction and allocate a new one if the Space Manager needed
- * to do an allocation to replenish the inode free-list.
- *
- * This routine is designed to be called from xfs_create and
- * xfs_create_dir.
+ * Allocates a new inode from disk and return a pointer to the incore copy. This
+ * routine will internally commit the current transaction and allocate a new one
+ * if we needed to allocate more on-disk free inodes to perform the requested
+ * operation.
  *
+ * If we are allocating quota inodes, we do not have a parent inode to attach to
+ * or associate with (i.e. dp == NULL) because they are not linked into the
+ * directory structure - they are attached directly to the superblock - and so
+ * have no parent.
  */
-int
+struct xfs_inode *
 xfs_dir_ialloc(
 	xfs_trans_t	**tpp,		/* input: current transaction;
 					   output: may be a new transaction. */
@@ -950,90 +904,59 @@ xfs_dir_ialloc(
 	umode_t		mode,
 	xfs_nlink_t	nlink,
 	dev_t		rdev,
-	prid_t		prid,		/* project id */
-	xfs_inode_t	**ipp)		/* pointer to inode; it will be
-					   locked. */
+	prid_t		prid)		/* project id */
 {
-	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
 	xfs_buf_t	*ialloc_context = NULL;
-	int		code;
-
-	tp = *tpp;
-	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+	xfs_ino_t	parent_ino = dp ? dp->i_ino : 0;
+	xfs_ino_t	ino;
+	int		error;
 
-	/*
-	 * xfs_ialloc will return a pointer to an incore inode if
-	 * the Space Manager has an available inode on the free
-	 * list. Otherwise, it will do an allocation and replenish
-	 * the freelist.  Since we can only do one allocation per
-	 * transaction without deadlocks, we will need to commit the
-	 * current transaction and start a new one.  We will then
-	 * need to call xfs_ialloc again to get the inode.
-	 *
-	 * If xfs_ialloc did an allocation to replenish the freelist,
-	 * it returns the bp containing the head of the freelist as
-	 * ialloc_context. We will hold a lock on it across the
-	 * transaction commit so that no other process can steal
-	 * the inode(s) that we've just allocated.
-	 */
-	code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid, &ialloc_context,
-			&ip);
+	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
 	/*
-	 * Return an error if we were unable to allocate a new inode.
-	 * This should only happen if we run out of space on disk or
-	 * encounter a disk error.
+	 * Call the space management code to pick the on-disk inode to be
+	 * allocated and replenish the freelist.  Since we can only do one
+	 * allocation per transaction without deadlocks, we will need to
+	 * commit the current transaction and start a new one.
+	 * If xfs_dialloc did an allocation to replenish the freelist, it
+	 * returns the bp containing the head of the freelist as
+	 * ialloc_context. We will hold a lock on it across the transaction
+	 * commit so that no other process can steal the inode(s) that we've
+	 * just allocated.
 	 */
-	if (code) {
-		*ipp = NULL;
-		return code;
-	}
-	if (!ialloc_context && !ip) {
-		*ipp = NULL;
-		return -ENOSPC;
-	}
+	error = xfs_dialloc(*tpp, parent_ino, mode, &ialloc_context, &ino);
+	if (error)
+		return ERR_PTR(error);
 
 	/*
 	 * If the AGI buffer is non-NULL, then we were unable to get an
 	 * inode in one operation.  We need to commit the current
-	 * transaction and call xfs_ialloc() again.  It is guaranteed
+	 * transaction and call xfs_dialloc() again.  It is guaranteed
 	 * to succeed the second time.
 	 */
 	if (ialloc_context) {
-		code = xfs_dialloc_roll(&tp, ialloc_context);
-		if (code) {
+		error = xfs_dialloc_roll(tpp, ialloc_context);
+		if (error) {
 			xfs_buf_relse(ialloc_context);
-			*tpp = tp;
-			*ipp = NULL;
-			return code;
+			return ERR_PTR(error);
 		}
-
 		/*
-		 * Call ialloc again. Since we've locked out all
-		 * other allocations in this allocation group,
-		 * this call should always succeed.
+		 * Call dialloc again. Since we've locked out all other
+		 * allocations in this allocation group, this call should
+		 * always succeed.
 		 */
-		code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid,
-				  &ialloc_context, &ip);
-
-		/*
-		 * If we get an error at this point, return to the caller
-		 * so that the current transaction can be aborted.
-		 */
-		if (code) {
-			*tpp = tp;
-			*ipp = NULL;
-			return code;
-		}
-		ASSERT(!ialloc_context && ip);
-
+		error = xfs_dialloc(*tpp, parent_ino, mode,
+				    &ialloc_context, &ino);
+		if (error)
+			return ERR_PTR(error);
+		ASSERT(!ialloc_context);
 	}
 
-	*ipp = ip;
-	*tpp = tp;
+	if (ino == NULLFSINO)
+		return ERR_PTR(-ENOSPC);
 
-	return 0;
+	return xfs_init_new_inode(*tpp, dp, ino, mode, nlink, rdev, prid);
 }
 
 /*
@@ -1147,9 +1070,12 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
-	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid, &ip);
-	if (error)
+	ip = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, prid);
+	if (IS_ERR(ip)) {
+		error = PTR_ERR(ip);
+		ip = NULL;
 		goto out_trans_cancel;
+	}
 
 	/*
 	 * Now we join the directory inode to the transaction.  We do not do it
@@ -1269,9 +1195,12 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid, &ip);
-	if (error)
+	ip = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid);
+	if (IS_ERR(ip)) {
+		error = PTR_ERR(ip);
+		ip = NULL;
 		goto out_trans_cancel;
+	}
 
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(tp);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 751a3d1d7d84..95b4ae35e6df 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -407,9 +407,9 @@ void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
 xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
 xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
 
-int		xfs_dir_ialloc(struct xfs_trans **, struct xfs_inode *, umode_t,
-			       xfs_nlink_t, dev_t, prid_t,
-			       struct xfs_inode **);
+struct xfs_inode *
+xfs_dir_ialloc(struct xfs_trans **, struct xfs_inode *, umode_t, xfs_nlink_t,
+	       dev_t, prid_t);
 
 static inline int
 xfs_itruncate_extents(
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b2a9abee8b2b..bfdf71d87777 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -737,15 +737,15 @@ xfs_qm_destroy_quotainfo(
  */
 STATIC int
 xfs_qm_qino_alloc(
-	xfs_mount_t	*mp,
-	xfs_inode_t	**ip,
-	uint		flags)
+	struct xfs_mount	*mp,
+	struct xfs_inode	**ipp,
+	unsigned int		flags)
 {
 	xfs_trans_t	*tp;
 	int		error;
 	bool		need_alloc = true;
 
-	*ip = NULL;
+	*ipp = NULL;
 	/*
 	 * With superblock that doesn't have separate pquotino, we
 	 * share an inode between gquota and pquota. If the on-disk
@@ -771,7 +771,7 @@ xfs_qm_qino_alloc(
 				return -EFSCORRUPTED;
 		}
 		if (ino != NULLFSINO) {
-			error = xfs_iget(mp, NULL, ino, 0, 0, ip);
+			error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
 			if (error)
 				return error;
 			mp->m_sb.sb_gquotino = NULLFSINO;
@@ -787,11 +787,14 @@ xfs_qm_qino_alloc(
 		return error;
 
 	if (need_alloc) {
-		error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, ip);
-		if (error) {
+		struct xfs_inode *ip;
+
+		ip = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0);
+		if (IS_ERR(ip)) {
 			xfs_trans_cancel(tp);
-			return error;
+			return PTR_ERR(ip);
 		}
+		*ipp = ip;
 	}
 
 	/*
@@ -812,11 +815,11 @@ xfs_qm_qino_alloc(
 		mp->m_sb.sb_qflags = mp->m_qflags & XFS_ALL_QUOTA_ACCT;
 	}
 	if (flags & XFS_QMOPT_UQUOTA)
-		mp->m_sb.sb_uquotino = (*ip)->i_ino;
+		mp->m_sb.sb_uquotino = (*ipp)->i_ino;
 	else if (flags & XFS_QMOPT_GQUOTA)
-		mp->m_sb.sb_gquotino = (*ip)->i_ino;
+		mp->m_sb.sb_gquotino = (*ipp)->i_ino;
 	else
-		mp->m_sb.sb_pquotino = (*ip)->i_ino;
+		mp->m_sb.sb_pquotino = (*ipp)->i_ino;
 	spin_unlock(&mp->m_sb_lock);
 	xfs_log_sb(tp);
 
@@ -826,7 +829,7 @@ xfs_qm_qino_alloc(
 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
 	}
 	if (need_alloc)
-		xfs_finish_inode_setup(*ip);
+		xfs_finish_inode_setup(*ipp);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8e88a7ca387e..988fc771f089 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -223,10 +223,12 @@ xfs_symlink(
 	/*
 	 * Allocate an inode for the symlink.
 	 */
-	error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0,
-			       prid, &ip);
-	if (error)
+	ip = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0, prid);
+	if (IS_ERR(ip)) {
+		error = PTR_ERR(ip);
+		ip = NULL;
 		goto out_trans_cancel;
+	}
 
 	/*
 	 * Now we join the directory inode to the transaction.  We do not do it
-- 
2.27.0

