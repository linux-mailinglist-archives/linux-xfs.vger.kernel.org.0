Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310C8285237
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Oct 2020 21:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgJFTPt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Oct 2020 15:15:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726924AbgJFTPt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 15:15:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602011747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GfK2zbo2Eh9tb8QxND5IJB9jyJozGY1yOWTG6Y7Q5MA=;
        b=eskTFbbKdVqbbd9lAi8zDKK4vFaE1zBYEL2/k4/16yl0R62WK9fT7w0LVsYl9RmLxo4kZQ
        KGUlZ3O9YoTicndo2uXo3ARnp+4DBd7PuvBLC9ZiAX2ajxkSHFTYWlsm9EBRSeRA5jpMPI
        PgnnPZUHpm4kqdkDUZGMG6VWf4778N0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-npUmSguKOXmhwFTqWgsncA-1; Tue, 06 Oct 2020 15:15:46 -0400
X-MC-Unique: npUmSguKOXmhwFTqWgsncA-1
Received: by mail-wm1-f71.google.com with SMTP id z7so1478994wmi.3
        for <linux-xfs@vger.kernel.org>; Tue, 06 Oct 2020 12:15:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GfK2zbo2Eh9tb8QxND5IJB9jyJozGY1yOWTG6Y7Q5MA=;
        b=tPIiW87SGhIx+jiFoO4mUwLzCdrEvrWMDmgl8q3jJm1g6sNuRq84HMI1+3b2xvXF8t
         XyNe9iYlfdgo6XAF2VCJ/xzh0HVwxPBkgifjSa3opmQIZ9PiGMp9pjriUWpo5CgkBWL2
         dpLBxkRDg+cPmraSjaxgcRwifsHrDe4F4NzUR20n8cwYKOnzqQOo7VVg0CBIs75Ril98
         PJHqaEpj2rN8uhkBL0HLjjoGcVjwiVclAxJPk973sq/eYLYeu9m5QLFw3/rR/cs25j7F
         K1h1wd3atyB57mDztIS4qgjLNTwG1EPUORcxkx+k0d7pNxzVJgEtuDqITisS+iOYrObr
         wV+A==
X-Gm-Message-State: AOAM533BfbYUqpx+LJFUJiMnujv6JdEodz3VtWXkMHJJbI/4Sbk6+1BL
        xHMsDCjaLM4DL4r14Ku/AzUYYfZdqBR6p0M/hDvOFOoZJOBSC2V/13T43TZm9tABEnGy3dnEhVc
        WbLX7uMFqVrv6lvuNKofV
X-Received: by 2002:adf:f707:: with SMTP id r7mr6645407wrp.413.1602011744635;
        Tue, 06 Oct 2020 12:15:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrSF45DUmq9jVMp52RtnPMJYoMBt0Aglz9eBbK/VDZb+MYNR2km7HaCM7nBceczT5Aw0LCWw==
X-Received: by 2002:adf:f707:: with SMTP id r7mr6645391wrp.413.1602011744406;
        Tue, 06 Oct 2020 12:15:44 -0700 (PDT)
Received: from localhost.localdomain.com ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id v17sm5317074wrc.23.2020.10.06.12.15.43
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 12:15:43 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 1/4] xfs: Refactor xfs_isilocked()
Date:   Tue,  6 Oct 2020 21:15:38 +0200
Message-Id: <20201006191541.115364-2-preichl@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201006191541.115364-1-preichl@redhat.com>
References: <20201006191541.115364-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Refactor xfs_isilocked() to use newly introduced __xfs_rwsem_islocked().
__xfs_rwsem_islocked() is a helper function which encapsulates checking
state of rw_semaphores hold by inode.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Suggested-by: Dave Chinner <dchinner@redhat.com>
Suggested-by: Eric Sandeen <sandeen@redhat.com>
Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c | 62 ++++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_inode.h | 21 ++++++++++------
 2 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c06129cffba9..f3b3821e3c35 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -345,32 +345,62 @@ xfs_ilock_demote(
 }
 
 #if defined(DEBUG) || defined(XFS_WARN)
-int
+static inline bool
+__xfs_rwsem_islocked(
+	struct rw_semaphore	*rwsem,
+	int			lock_flags)
+{
+	int			arg;
+
+	if (!debug_locks)
+		return rwsem_is_locked(rwsem);
+
+	if (lock_flags & (1 << XFS_SHARED_LOCK_SHIFT)) {
+		/*
+		 * The caller could be asking if we have (shared | excl)
+		 * access to the lock. Ask lockdep if the rwsem is
+		 * locked either for read or write access.
+		 *
+		 * The caller could also be asking if we have only
+		 * shared access to the lock. Holding a rwsem
+		 * write-locked implies read access as well, so the
+		 * request to lockdep is the same for this case.
+		 */
+		arg = -1;
+	} else {
+		/*
+		 * The caller is asking if we have only exclusive access
+		 * to the lock. Ask lockdep if the rwsem is locked for
+		 * write access.
+		 */
+		arg = 0;
+	}
+
+	return lockdep_is_held_type(rwsem, arg);
+}
+
+bool
 xfs_isilocked(
-	xfs_inode_t		*ip,
+	struct xfs_inode	*ip,
 	uint			lock_flags)
 {
-	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
-		if (!(lock_flags & XFS_ILOCK_SHARED))
-			return !!ip->i_lock.mr_writer;
-		return rwsem_is_locked(&ip->i_lock.mr_lock);
+	if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)) {
+		return __xfs_rwsem_islocked(&ip->i_lock,
+				(lock_flags >> XFS_ILOCK_FLAG_SHIFT));
 	}
 
-	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
-		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
-			return !!ip->i_mmaplock.mr_writer;
-		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
+	if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
+		return __xfs_rwsem_islocked(&ip->i_mmaplock,
+				(lock_flags >> XFS_MMAPLOCK_FLAG_SHIFT));
 	}
 
-	if (lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) {
-		if (!(lock_flags & XFS_IOLOCK_SHARED))
-			return !debug_locks ||
-				lockdep_is_held_type(&VFS_I(ip)->i_rwsem, 0);
-		return rwsem_is_locked(&VFS_I(ip)->i_rwsem);
+	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
+		return __xfs_rwsem_islocked(&VFS_I(ip)->i_rwsem,
+				(lock_flags >> XFS_IOLOCK_FLAG_SHIFT));
 	}
 
 	ASSERT(0);
-	return 0;
+	return false;
 }
 #endif
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index e9a8bb184d1f..77d5655191ab 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -268,12 +268,19 @@ static inline void xfs_ifunlock(struct xfs_inode *ip)
  * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes (bitfield)
  *		1<<16 - 1<<32-1 -- lockdep annotation (integers)
  */
-#define	XFS_IOLOCK_EXCL		(1<<0)
-#define	XFS_IOLOCK_SHARED	(1<<1)
-#define	XFS_ILOCK_EXCL		(1<<2)
-#define	XFS_ILOCK_SHARED	(1<<3)
-#define	XFS_MMAPLOCK_EXCL	(1<<4)
-#define	XFS_MMAPLOCK_SHARED	(1<<5)
+
+#define XFS_IOLOCK_FLAG_SHIFT	0
+#define XFS_ILOCK_FLAG_SHIFT	2
+#define XFS_MMAPLOCK_FLAG_SHIFT	4
+
+#define XFS_SHARED_LOCK_SHIFT	1
+
+#define XFS_IOLOCK_EXCL		(1 << (XFS_IOLOCK_FLAG_SHIFT))
+#define XFS_IOLOCK_SHARED	(XFS_IOLOCK_EXCL << (XFS_SHARED_LOCK_SHIFT))
+#define XFS_ILOCK_EXCL		(1 << (XFS_ILOCK_FLAG_SHIFT))
+#define XFS_ILOCK_SHARED	(XFS_ILOCK_EXCL << (XFS_SHARED_LOCK_SHIFT))
+#define XFS_MMAPLOCK_EXCL	(1 << (XFS_MMAPLOCK_FLAG_SHIFT))
+#define XFS_MMAPLOCK_SHARED	(XFS_MMAPLOCK_EXCL << (XFS_SHARED_LOCK_SHIFT))
 
 #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
 				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED \
@@ -412,7 +419,7 @@ void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
 void		xfs_iunlock(xfs_inode_t *, uint);
 void		xfs_ilock_demote(xfs_inode_t *, uint);
-int		xfs_isilocked(xfs_inode_t *, uint);
+bool		xfs_isilocked(xfs_inode_t *, uint);
 uint		xfs_ilock_data_map_shared(struct xfs_inode *);
 uint		xfs_ilock_attr_map_shared(struct xfs_inode *);
 
-- 
2.26.2

