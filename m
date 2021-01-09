Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1CA2EFE7E
	for <lists+linux-xfs@lfdr.de>; Sat,  9 Jan 2021 09:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbhAIIBG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 9 Jan 2021 03:01:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726745AbhAIIBG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 9 Jan 2021 03:01:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEF0923A75;
        Sat,  9 Jan 2021 07:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610179186;
        bh=f1IRzjNhqEyjuW1h5W+eMv7y7CvKJNHHEP0p7XPwbsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uo/6gdoDMggzj6Fc6Jq6RuNZvTc6ZXoyueSBp6hIBATRV5BZCKOQ+IuTezLoA0r/9
         8Puye+GnhKa8dVphMklQFYbjGq5a6WgBwkFXeRA35B/Xh7wKSmfeAqiLV6H9oa6PXw
         H3Mb3X55rrhnI5XRM179thaocF2KHgRVpqWo6GjV+EMDsupqE2u4QLv6AYHiVcy5he
         3u0SR66vXtRSGCIUDYLq2478Oq9ioXVv2ko3ELDBIm/nP5zCf986jobvQO6yWOMJ5g
         eYikzMpeWlKocfbpVKHMrw2NotkC3BsjO+UiuOKslb2jsostmIB+ps+vtqNEZfRgTt
         Sxa79yr1KZXTg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 07/12] fs: clean up __mark_inode_dirty() a bit
Date:   Fri,  8 Jan 2021 23:58:58 -0800
Message-Id: <20210109075903.208222-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210109075903.208222-1-ebiggers@kernel.org>
References: <20210109075903.208222-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Improve some comments, and don't bother checking for the I_DIRTY_TIME
flag in the case where we just cleared it.

Also, warn if I_DIRTY_TIME and I_DIRTY_PAGES are passed to
__mark_inode_dirty() at the same time, as this case isn't handled.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/fs-writeback.c | 49 +++++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 2e6064012f7d3..80ee9816d9df5 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2219,23 +2219,24 @@ static noinline void block_dump___mark_inode_dirty(struct inode *inode)
 }
 
 /**
- * __mark_inode_dirty -	internal function
+ * __mark_inode_dirty -	internal function to mark an inode dirty
  *
  * @inode: inode to mark
- * @flags: what kind of dirty (i.e. I_DIRTY_SYNC)
+ * @flags: what kind of dirty, e.g. I_DIRTY_SYNC.  This can be a combination of
+ *	   multiple I_DIRTY_* flags, except that I_DIRTY_TIME can't be combined
+ *	   with I_DIRTY_PAGES.
  *
- * Mark an inode as dirty. Callers should use mark_inode_dirty or
- * mark_inode_dirty_sync.
+ * Mark an inode as dirty.  We notify the filesystem, then update the inode's
+ * dirty flags.  Then, if needed we add the inode to the appropriate dirty list.
  *
- * Put the inode on the super block's dirty list.
+ * Most callers should use mark_inode_dirty() or mark_inode_dirty_sync()
+ * instead of calling this directly.
  *
- * CAREFUL! We mark it dirty unconditionally, but move it onto the
- * dirty list only if it is hashed or if it refers to a blockdev.
- * If it was not hashed, it will never be added to the dirty list
- * even if it is later hashed, as it will have been marked dirty already.
+ * CAREFUL!  We only add the inode to the dirty list if it is hashed or if it
+ * refers to a blockdev.  Unhashed inodes will never be added to the dirty list
+ * even if they are later hashed, as they will have been marked dirty already.
  *
- * In short, make sure you hash any inodes _before_ you start marking
- * them dirty.
+ * In short, ensure you hash any inodes _before_ you start marking them dirty.
  *
  * Note that for blockdevs, inode->dirtied_when represents the dirtying time of
  * the block-special inode (/dev/hda1) itself.  And the ->dirtied_when field of
@@ -2247,25 +2248,34 @@ static noinline void block_dump___mark_inode_dirty(struct inode *inode)
 void __mark_inode_dirty(struct inode *inode, int flags)
 {
 	struct super_block *sb = inode->i_sb;
-	int dirtytime;
+	int dirtytime = 0;
 
 	trace_writeback_mark_inode_dirty(inode, flags);
 
-	/*
-	 * Don't do this for I_DIRTY_PAGES - that doesn't actually
-	 * dirty the inode itself
-	 */
 	if (flags & I_DIRTY_INODE) {
+		/*
+		 * Notify the filesystem about the inode being dirtied, so that
+		 * (if needed) it can update on-disk fields and journal the
+		 * inode.  This is only needed when the inode itself is being
+		 * dirtied now.  I.e. it's only needed for I_DIRTY_INODE, not
+		 * for just I_DIRTY_PAGES or I_DIRTY_TIME.
+		 */
 		trace_writeback_dirty_inode_start(inode, flags);
-
 		if (sb->s_op->dirty_inode)
 			sb->s_op->dirty_inode(inode, flags & I_DIRTY_INODE);
-
 		trace_writeback_dirty_inode(inode, flags);
 
+		/* I_DIRTY_INODE supersedes I_DIRTY_TIME. */
 		flags &= ~I_DIRTY_TIME;
+	} else {
+		/*
+		 * Else it's either I_DIRTY_PAGES, I_DIRTY_TIME, or nothing.
+		 * (We don't support setting both I_DIRTY_PAGES and I_DIRTY_TIME
+		 * in one call to __mark_inode_dirty().)
+		 */
+		dirtytime = flags & I_DIRTY_TIME;
+		WARN_ON_ONCE(dirtytime && flags != I_DIRTY_TIME);
 	}
-	dirtytime = flags & I_DIRTY_TIME;
 
 	/*
 	 * Paired with smp_mb() in __writeback_single_inode() for the
@@ -2288,6 +2298,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 
 		inode_attach_wb(inode, NULL);
 
+		/* I_DIRTY_INODE supersedes I_DIRTY_TIME. */
 		if (flags & I_DIRTY_INODE)
 			inode->i_state &= ~I_DIRTY_TIME;
 		inode->i_state |= flags;
-- 
2.30.0

