Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47804154B96
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Feb 2020 20:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgBFTFR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 Feb 2020 14:05:17 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40888 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727887AbgBFTFR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 14:05:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581015914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e2tnLKuroUf0/jcdG/qadu5Siz6karl7eaUANgR86E4=;
        b=AlW4sFN7rhjIV13qgeGOXB6CXDrj4L1Jl0asiOONEoLDo+NxbrDh/l+iOkyI7m3/75AIP0
        E2zJ2WNYn7EJMYkcMylDf4YXSuWms8i/eTMiU2yn6kB59OnGSgQu663ZWccW/kAYRS/K9b
        W1F55QVOBiVfOh/VKimPg1G050uLfiY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-BkEKYR1YPWejuD3mYJrSaw-1; Thu, 06 Feb 2020 14:05:13 -0500
X-MC-Unique: BkEKYR1YPWejuD3mYJrSaw-1
Received: by mail-wr1-f72.google.com with SMTP id n23so3957795wra.20
        for <linux-xfs@vger.kernel.org>; Thu, 06 Feb 2020 11:05:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e2tnLKuroUf0/jcdG/qadu5Siz6karl7eaUANgR86E4=;
        b=Xa/+6EecG6wrMbBaOPbckF6htQ1AqGxwKtnsQ3srFE8bxUBfmz4Gg7+idUjy+uAnmt
         EZVUI9mS+LozBA3N5T2zq5yL1XgT+W/iEjWDcFAFDmnMkNloqLz+6FZp0jEypqX8pIwP
         KT03ezbWJgZiWO/s7n3CjCHpnMrQpc303ZQkBGruNTix3IaxsRv4H+qDiBSJgoXY63ok
         LTZhWfDqM9e/L516HPT70/RowWqXdNzm8UBnkwAIhY9h1ixs+ASv0aen0JrvavW1/hqd
         6LP0Z6XG4f6FDFSRJEBnBEwzKiWjfU+AV6YWVP9W4ChoqT4YLI5hlc5ZjjWPXmLInndl
         sGAg==
X-Gm-Message-State: APjAAAWZW9xq9fHCdblLmalHSiMrvlL4uok14SsYEymYIiY2gK9BKKsC
        2ns1D9Y3Y83CATO8E6nK9GpSLx91fK7MVpKkJibEjUCNDc96dKLPOaq58lwOXev5RbC4hjsDcIV
        imftDd9LeNr09kpbAWIpu
X-Received: by 2002:adf:e40f:: with SMTP id g15mr5139120wrm.223.1581015911537;
        Thu, 06 Feb 2020 11:05:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqw29EWbj8I3KZvM/f09WD/kV+lL+qFQQIWVWwXSAUs21EAuMKAMRcpy6lafoF9tP8ohTgzpxQ==
X-Received: by 2002:adf:e40f:: with SMTP id g15mr5139098wrm.223.1581015911213;
        Thu, 06 Feb 2020 11:05:11 -0800 (PST)
Received: from localhost.localdomain.com (243.206.broadband12.iol.cz. [90.179.206.243])
        by smtp.gmail.com with ESMTPSA id l29sm215448wrb.64.2020.02.06.11.05.10
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 11:05:10 -0800 (PST)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 4/4] xfs: Replace mrlock_t by rw_semaphore
Date:   Thu,  6 Feb 2020 20:05:02 +0100
Message-Id: <20200206190502.389139-5-preichl@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200206190502.389139-1-preichl@redhat.com>
References: <20200206190502.389139-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove mrlock_t as it does not provide any extra value over rw_semaphores.
Make i_lock and i_mmaplock native rw_semaphores and replace mr*() functions
with native rwsem calls.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
---
 fs/xfs/mrlock.h    | 78 ----------------------------------------------
 fs/xfs/xfs_inode.c | 37 +++++++++++-----------
 fs/xfs/xfs_inode.h |  6 ++--
 fs/xfs/xfs_iops.c  |  4 +--
 fs/xfs/xfs_linux.h |  1 -
 fs/xfs/xfs_super.c |  6 ++--
 6 files changed, 27 insertions(+), 105 deletions(-)
 delete mode 100644 fs/xfs/mrlock.h

diff --git a/fs/xfs/mrlock.h b/fs/xfs/mrlock.h
deleted file mode 100644
index 79155eec341b..000000000000
--- a/fs/xfs/mrlock.h
+++ /dev/null
@@ -1,78 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
- * All Rights Reserved.
- */
-#ifndef __XFS_SUPPORT_MRLOCK_H__
-#define __XFS_SUPPORT_MRLOCK_H__
-
-#include <linux/rwsem.h>
-
-typedef struct {
-	struct rw_semaphore	mr_lock;
-#if defined(DEBUG) || defined(XFS_WARN)
-	int			mr_writer;
-#endif
-} mrlock_t;
-
-#if defined(DEBUG) || defined(XFS_WARN)
-#define mrinit(mrp, name)	\
-	do { (mrp)->mr_writer = 0; init_rwsem(&(mrp)->mr_lock); } while (0)
-#else
-#define mrinit(mrp, name)	\
-	do { init_rwsem(&(mrp)->mr_lock); } while (0)
-#endif
-
-#define mrlock_init(mrp, t,n,s)	mrinit(mrp, n)
-#define mrfree(mrp)		do { } while (0)
-
-static inline void mraccess_nested(mrlock_t *mrp, int subclass)
-{
-	down_read_nested(&mrp->mr_lock, subclass);
-}
-
-static inline void mrupdate_nested(mrlock_t *mrp, int subclass)
-{
-	down_write_nested(&mrp->mr_lock, subclass);
-#if defined(DEBUG) || defined(XFS_WARN)
-	mrp->mr_writer = 1;
-#endif
-}
-
-static inline int mrtryaccess(mrlock_t *mrp)
-{
-	return down_read_trylock(&mrp->mr_lock);
-}
-
-static inline int mrtryupdate(mrlock_t *mrp)
-{
-	if (!down_write_trylock(&mrp->mr_lock))
-		return 0;
-#if defined(DEBUG) || defined(XFS_WARN)
-	mrp->mr_writer = 1;
-#endif
-	return 1;
-}
-
-static inline void mrunlock_excl(mrlock_t *mrp)
-{
-#if defined(DEBUG) || defined(XFS_WARN)
-	mrp->mr_writer = 0;
-#endif
-	up_write(&mrp->mr_lock);
-}
-
-static inline void mrunlock_shared(mrlock_t *mrp)
-{
-	up_read(&mrp->mr_lock);
-}
-
-static inline void mrdemote(mrlock_t *mrp)
-{
-#if defined(DEBUG) || defined(XFS_WARN)
-	mrp->mr_writer = 0;
-#endif
-	downgrade_write(&mrp->mr_lock);
-}
-
-#endif /* __XFS_SUPPORT_MRLOCK_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7cc03dd45ff9..30c27eb69cf5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -191,14 +191,15 @@ xfs_ilock(
 	}
 
 	if (lock_flags & XFS_MMAPLOCK_EXCL)
-		mrupdate_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
+		down_write_nested(&ip->i_mmaplock,
+				XFS_MMAPLOCK_DEP(lock_flags));
 	else if (lock_flags & XFS_MMAPLOCK_SHARED)
-		mraccess_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
+		down_read_nested(&ip->i_mmaplock, XFS_MMAPLOCK_DEP(lock_flags));
 
 	if (lock_flags & XFS_ILOCK_EXCL)
-		mrupdate_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
+		down_write_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
 	else if (lock_flags & XFS_ILOCK_SHARED)
-		mraccess_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
+		down_read_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
 }
 
 /*
@@ -242,27 +243,27 @@ xfs_ilock_nowait(
 	}
 
 	if (lock_flags & XFS_MMAPLOCK_EXCL) {
-		if (!mrtryupdate(&ip->i_mmaplock))
+		if (!down_write_trylock(&ip->i_mmaplock))
 			goto out_undo_iolock;
 	} else if (lock_flags & XFS_MMAPLOCK_SHARED) {
-		if (!mrtryaccess(&ip->i_mmaplock))
+		if (!down_read_trylock(&ip->i_mmaplock))
 			goto out_undo_iolock;
 	}
 
 	if (lock_flags & XFS_ILOCK_EXCL) {
-		if (!mrtryupdate(&ip->i_lock))
+		if (!down_write_trylock(&ip->i_lock))
 			goto out_undo_mmaplock;
 	} else if (lock_flags & XFS_ILOCK_SHARED) {
-		if (!mrtryaccess(&ip->i_lock))
+		if (!down_read_trylock(&ip->i_lock))
 			goto out_undo_mmaplock;
 	}
 	return 1;
 
 out_undo_mmaplock:
 	if (lock_flags & XFS_MMAPLOCK_EXCL)
-		mrunlock_excl(&ip->i_mmaplock);
+		up_write(&ip->i_mmaplock);
 	else if (lock_flags & XFS_MMAPLOCK_SHARED)
-		mrunlock_shared(&ip->i_mmaplock);
+		up_read(&ip->i_mmaplock);
 out_undo_iolock:
 	if (lock_flags & XFS_IOLOCK_EXCL)
 		up_write(&VFS_I(ip)->i_rwsem);
@@ -309,14 +310,14 @@ xfs_iunlock(
 		up_read(&VFS_I(ip)->i_rwsem);
 
 	if (lock_flags & XFS_MMAPLOCK_EXCL)
-		mrunlock_excl(&ip->i_mmaplock);
+		up_write(&ip->i_mmaplock);
 	else if (lock_flags & XFS_MMAPLOCK_SHARED)
-		mrunlock_shared(&ip->i_mmaplock);
+		up_read(&ip->i_mmaplock);
 
 	if (lock_flags & XFS_ILOCK_EXCL)
-		mrunlock_excl(&ip->i_lock);
+		up_write(&ip->i_lock);
 	else if (lock_flags & XFS_ILOCK_SHARED)
-		mrunlock_shared(&ip->i_lock);
+		up_read(&ip->i_lock);
 
 	trace_xfs_iunlock(ip, lock_flags, _RET_IP_);
 }
@@ -335,9 +336,9 @@ xfs_ilock_demote(
 		~(XFS_IOLOCK_EXCL|XFS_MMAPLOCK_EXCL|XFS_ILOCK_EXCL)) == 0);
 
 	if (lock_flags & XFS_ILOCK_EXCL)
-		mrdemote(&ip->i_lock);
+		downgrade_write(&ip->i_lock);
 	if (lock_flags & XFS_MMAPLOCK_EXCL)
-		mrdemote(&ip->i_mmaplock);
+		downgrade_write(&ip->i_mmaplock);
 	if (lock_flags & XFS_IOLOCK_EXCL)
 		downgrade_write(&VFS_I(ip)->i_rwsem);
 
@@ -374,13 +375,13 @@ xfs_isilocked(
 	uint			lock_flags)
 {
 	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
-		return __xfs_rwsem_islocked(&ip->i_lock.mr_lock,
+		return __xfs_rwsem_islocked(&ip->i_lock,
 				(lock_flags & XFS_ILOCK_SHARED),
 				(lock_flags & XFS_ILOCK_EXCL));
 	}
 
 	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
-		return __xfs_rwsem_islocked(&ip->i_mmaplock.mr_lock,
+		return __xfs_rwsem_islocked(&ip->i_mmaplock,
 				(lock_flags & XFS_MMAPLOCK_SHARED),
 				(lock_flags & XFS_MMAPLOCK_EXCL));
 	}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3d7ce355407d..8b30f82b9dc0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -9,6 +9,8 @@
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
 
+#include <linux/rwsem.h>
+
 /*
  * Kernel only inode definitions
  */
@@ -39,8 +41,8 @@ typedef struct xfs_inode {
 
 	/* Transaction and locking information. */
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
-	mrlock_t		i_lock;		/* inode lock */
-	mrlock_t		i_mmaplock;	/* inode mmap IO lock */
+	struct rw_semaphore	i_lock;		/* inode lock */
+	struct rw_semaphore	i_mmaplock;	/* inode mmap IO lock */
 	atomic_t		i_pincount;	/* inode pin count */
 
 	/*
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 81f2f93caec0..7c3df574cf4c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1319,9 +1319,9 @@ xfs_setup_inode(
 		 */
 		lockdep_set_class(&inode->i_rwsem,
 				  &inode->i_sb->s_type->i_mutex_dir_key);
-		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_dir_ilock_class);
+		lockdep_set_class(&ip->i_lock, &xfs_dir_ilock_class);
 	} else {
-		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_nondir_ilock_class);
+		lockdep_set_class(&ip->i_lock, &xfs_nondir_ilock_class);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 8738bb03f253..921a3eb093ed 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -22,7 +22,6 @@ typedef __u32			xfs_nlink_t;
 #include "xfs_types.h"
 
 #include "kmem.h"
-#include "mrlock.h"
 
 #include <linux/semaphore.h>
 #include <linux/mm.h>
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 760901783944..1289ce1f4e9e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -661,10 +661,8 @@ xfs_fs_inode_init_once(
 	atomic_set(&ip->i_pincount, 0);
 	spin_lock_init(&ip->i_flags_lock);
 
-	mrlock_init(&ip->i_mmaplock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
-		     "xfsino", ip->i_ino);
-	mrlock_init(&ip->i_lock, MRLOCK_ALLOW_EQUAL_PRI|MRLOCK_BARRIER,
-		     "xfsino", ip->i_ino);
+	init_rwsem(&ip->i_mmaplock);
+	init_rwsem(&ip->i_lock);
 }
 
 /*
-- 
2.24.1

