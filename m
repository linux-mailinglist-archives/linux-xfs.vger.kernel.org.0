Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C38C20221F
	for <lists+linux-xfs@lfdr.de>; Sat, 20 Jun 2020 09:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgFTHLi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 20 Jun 2020 03:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgFTHLi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 20 Jun 2020 03:11:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3302FC06174E
        for <linux-xfs@vger.kernel.org>; Sat, 20 Jun 2020 00:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=aLxestoJxWCYoF/UuAhVUXQxnVY9XT0QlH/9JOr+58c=; b=sBLJDeQy6EwYSxwp3eMkKufLUh
        O9UekuuqAN6ZMiNzu7d1qrBNNcoP692N6MRJIwH67zj2RU3q1DTSZm98yqOXcgxvG21FJYipb4Fwd
        aVCnoHwv1RyVrc44Lgh1Byy85KZYfGspUfPJuODsAylQfg65M0Yr/92wcrqnSaIG0o8RXjXwVyHlr
        NtZZwXqhOYf8dODacmbo5HkFSKXuZoSC15fUCYydwohu6T4OGv18VthWZMygb4kg/8hFV/SUBB5P+
        YwFncLHBJfSAE6dGyYV5O64JmSYEvfHMWbr0UULVn9kZPxAyTuGUGvrJKNGVGyv088sGdZ1mmTzMG
        FVUxYOfw==;
Received: from 195-192-102-148.dyn.cablelink.at ([195.192.102.148] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmXf7-00011R-LQ
        for linux-xfs@vger.kernel.org; Sat, 20 Jun 2020 07:11:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/15] xfs: move the di_flags field to struct xfs_inode
Date:   Sat, 20 Jun 2020 09:10:58 +0200
Message-Id: <20200620071102.462554-12-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200620071102.462554-1-hch@lst.de>
References: <20200620071102.462554-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation of removing the historic icinode struct, move the flags
field into the containing xfs_inode structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap_btree.c |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c  |  4 ++--
 fs/xfs/libxfs/xfs_inode_buf.h  |  1 -
 fs/xfs/libxfs/xfs_rtbitmap.c   |  4 ++--
 fs/xfs/scrub/common.c          |  2 +-
 fs/xfs/xfs_bmap_util.c         |  4 ++--
 fs/xfs/xfs_file.c              |  4 ++--
 fs/xfs/xfs_filestream.h        |  2 +-
 fs/xfs/xfs_inode.c             | 38 +++++++++++++++++-----------------
 fs/xfs/xfs_inode.h             |  3 ++-
 fs/xfs/xfs_inode_item.c        |  2 +-
 fs/xfs/xfs_ioctl.c             |  9 ++++----
 fs/xfs/xfs_iops.c              |  6 +++---
 fs/xfs/xfs_linux.h             |  2 +-
 fs/xfs/xfs_rtalloc.c           |  4 ++--
 fs/xfs/xfs_super.c             |  4 ++--
 fs/xfs/xfs_symlink.c           |  2 +-
 17 files changed, 46 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 9ad4c6a1eec518..d32f3a94c936e6 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -183,7 +183,7 @@ xfs_bmbt_update_cursor(
 	struct xfs_btree_cur	*dst)
 {
 	ASSERT((dst->bc_tp->t_firstblock != NULLFSBLOCK) ||
-	       (dst->bc_ino.ip->i_d.di_flags & XFS_DIFLAG_REALTIME));
+	       (dst->bc_ino.ip->i_diflags & XFS_DIFLAG_REALTIME));
 
 	dst->bc_ino.allocated += src->bc_ino.allocated;
 	dst->bc_tp->t_firstblock = src->bc_tp->t_firstblock;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 69a6844b1698d0..bb9c4775ecaa5c 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -248,7 +248,7 @@ xfs_inode_from_disk(
 	ip->i_forkoff = from->di_forkoff;
 	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
 	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
-	to->di_flags	= be16_to_cpu(from->di_flags);
+	ip->i_diflags	= be16_to_cpu(from->di_flags);
 
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		inode_set_iversion_queried(inode,
@@ -314,7 +314,7 @@ xfs_inode_to_disk(
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
 	to->di_dmstate = cpu_to_be16(from->di_dmstate);
-	to->di_flags = cpu_to_be16(from->di_flags);
+	to->di_flags = cpu_to_be16(ip->i_diflags);
 
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 032486dbf82757..5c6a6ac521b11d 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -18,7 +18,6 @@ struct xfs_dinode;
 struct xfs_icdinode {
 	uint32_t	di_dmevmask;	/* DMIG event mask */
 	uint16_t	di_dmstate;	/* DMIG state info */
-	uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
 
 	uint64_t	di_flags2;	/* more random flags */
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 9498ced947be9e..57381b9aca00ac 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -997,8 +997,8 @@ xfs_rtfree_extent(
 	 */
 	if (tp->t_frextents_delta + mp->m_sb.sb_frextents ==
 	    mp->m_sb.sb_rextents) {
-		if (!(mp->m_rbmip->i_d.di_flags & XFS_DIFLAG_NEWRTBM))
-			mp->m_rbmip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
+		if (!(mp->m_rbmip->i_diflags & XFS_DIFLAG_NEWRTBM))
+			mp->m_rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
 		*(uint64_t *)&VFS_I(mp->m_rbmip)->i_atime = 0;
 		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
 	}
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 18876056e5e02a..254dc813696de4 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -835,7 +835,7 @@ xchk_metadata_inode_forks(
 		return 0;
 
 	/* Metadata inodes don't live on the rt device. */
-	if (sc->ip->i_d.di_flags & XFS_DIFLAG_REALTIME) {
+	if (sc->ip->i_diflags & XFS_DIFLAG_REALTIME) {
 		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 		return 0;
 	}
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 5eba039d72fb83..0b944aad75e618 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -439,7 +439,7 @@ xfs_getbmap(
 		}
 
 		if (xfs_get_extsz_hint(ip) ||
-		    (ip->i_d.di_flags &
+		    (ip->i_diflags &
 		     (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))
 			max_len = mp->m_super->s_maxbytes;
 		else
@@ -620,7 +620,7 @@ xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
 	 * Do not free real preallocated or append-only files unless the file
 	 * has delalloc blocks and we are forced to remove them.
 	 */
-	if (ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
+	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
 		if (!force || ip->i_delayed_blks == 0)
 			return false;
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b0384306d6622f..4f08793f3d6db4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -56,9 +56,9 @@ xfs_update_prealloc_flags(
 	}
 
 	if (flags & XFS_PREALLOC_SET)
-		ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
+		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
 	if (flags & XFS_PREALLOC_CLEAR)
-		ip->i_d.di_flags &= ~XFS_DIFLAG_PREALLOC;
+		ip->i_diflags &= ~XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	if (flags & XFS_PREALLOC_SYNC)
diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index 5cc7665e93c92b..3af963743e4d0b 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -22,7 +22,7 @@ xfs_inode_is_filestream(
 	struct xfs_inode	*ip)
 {
 	return (ip->i_mount->m_flags & XFS_MOUNT_FILESTREAMS) ||
-		(ip->i_d.di_flags & XFS_DIFLAG_FILESTREAM);
+		(ip->i_diflags & XFS_DIFLAG_FILESTREAM);
 }
 
 #endif /* __XFS_FILESTREAM_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 764f91610d1496..479342ac8851f4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -61,7 +61,7 @@ xfs_get_extsz_hint(
 	 */
 	if (xfs_is_always_cow_inode(ip))
 		return 0;
-	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
+	if ((ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
 		return ip->i_extsize;
 	if (XFS_IS_REALTIME_INODE(ip))
 		return ip->i_mount->m_sb.sb_rextsize;
@@ -673,7 +673,7 @@ xfs_ip2xflags(
 {
 	struct xfs_icdinode	*dic = &ip->i_d;
 
-	return _xfs_dic2xflags(dic->di_flags, dic->di_flags2, XFS_IFORK_Q(ip));
+	return _xfs_dic2xflags(ip->i_diflags, dic->di_flags2, XFS_IFORK_Q(ip));
 }
 
 /*
@@ -837,7 +837,7 @@ xfs_ialloc(
 	ip->i_extsize = 0;
 	ip->i_d.di_dmevmask = 0;
 	ip->i_d.di_dmstate = 0;
-	ip->i_d.di_flags = 0;
+	ip->i_diflags = 0;
 
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		inode_set_iversion(inode, 1);
@@ -858,45 +858,45 @@ xfs_ialloc(
 		break;
 	case S_IFREG:
 	case S_IFDIR:
-		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
+		if (pip && (pip->i_diflags & XFS_DIFLAG_ANY)) {
 			uint		di_flags = 0;
 
 			if (S_ISDIR(mode)) {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+				if (pip->i_diflags & XFS_DIFLAG_RTINHERIT)
 					di_flags |= XFS_DIFLAG_RTINHERIT;
-				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+				if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
 					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
 					ip->i_extsize = pip->i_extsize;
 				}
-				if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+				if (pip->i_diflags & XFS_DIFLAG_PROJINHERIT)
 					di_flags |= XFS_DIFLAG_PROJINHERIT;
 			} else if (S_ISREG(mode)) {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+				if (pip->i_diflags & XFS_DIFLAG_RTINHERIT)
 					di_flags |= XFS_DIFLAG_REALTIME;
-				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+				if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
 					di_flags |= XFS_DIFLAG_EXTSIZE;
 					ip->i_extsize = pip->i_extsize;
 				}
 			}
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NOATIME) &&
+			if ((pip->i_diflags & XFS_DIFLAG_NOATIME) &&
 			    xfs_inherit_noatime)
 				di_flags |= XFS_DIFLAG_NOATIME;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NODUMP) &&
+			if ((pip->i_diflags & XFS_DIFLAG_NODUMP) &&
 			    xfs_inherit_nodump)
 				di_flags |= XFS_DIFLAG_NODUMP;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_SYNC) &&
+			if ((pip->i_diflags & XFS_DIFLAG_SYNC) &&
 			    xfs_inherit_sync)
 				di_flags |= XFS_DIFLAG_SYNC;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) &&
+			if ((pip->i_diflags & XFS_DIFLAG_NOSYMLINKS) &&
 			    xfs_inherit_nosymlinks)
 				di_flags |= XFS_DIFLAG_NOSYMLINKS;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NODEFRAG) &&
+			if ((pip->i_diflags & XFS_DIFLAG_NODEFRAG) &&
 			    xfs_inherit_nodefrag)
 				di_flags |= XFS_DIFLAG_NODEFRAG;
-			if (pip->i_d.di_flags & XFS_DIFLAG_FILESTREAM)
+			if (pip->i_diflags & XFS_DIFLAG_FILESTREAM)
 				di_flags |= XFS_DIFLAG_FILESTREAM;
 
-			ip->i_d.di_flags |= di_flags;
+			ip->i_diflags |= di_flags;
 		}
 		if (pip && (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY)) {
 			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
@@ -1397,7 +1397,7 @@ xfs_link(
 	 * creation in our tree when the project IDs are the same; else
 	 * the tree quota mechanism could be circumvented.
 	 */
-	if (unlikely((tdp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
+	if (unlikely((tdp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
 		     tdp->i_projid != sip->i_projid)) {
 		error = -EXDEV;
 		goto error_return;
@@ -2755,7 +2755,7 @@ xfs_ifree(
 	}
 
 	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
-	ip->i_d.di_flags = 0;
+	ip->i_diflags = 0;
 	ip->i_d.di_flags2 = 0;
 	ip->i_d.di_dmevmask = 0;
 	ip->i_forkoff = 0;		/* mark the attr fork not in use */
@@ -3263,7 +3263,7 @@ xfs_rename(
 	 * into our tree when the project IDs are the same; else the
 	 * tree quota mechanism would be circumvented.
 	 */
-	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
+	if (unlikely((target_dp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
 		     target_dp->i_projid != src_ip->i_projid)) {
 		error = -EXDEV;
 		goto out_trans_cancel;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 31440ab88cf141..7673c841d89154 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -64,6 +64,7 @@ typedef struct xfs_inode {
 		uint16_t	i_flushiter;	/* incremented on flush */
 	};
 	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
+	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
@@ -184,7 +185,7 @@ xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
 static inline prid_t
 xfs_get_initial_prid(struct xfs_inode *dp)
 {
-	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+	if (dp->i_diflags & XFS_DIFLAG_PROJINHERIT)
 		return dp->i_projid;
 
 	return XFS_PROJID_DEFAULT;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index a83ddc4e029f0f..6af8e829dd0172 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -332,7 +332,7 @@ xfs_inode_to_log_dinode(
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_dmevmask = from->di_dmevmask;
 	to->di_dmstate = from->di_dmstate;
-	to->di_flags = from->di_flags;
+	to->di_flags = ip->i_diflags;
 
 	/* log a dummy value to ensure log structure is fully initialised */
 	to->di_next_unlinked = NULLAGINO;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index cabc86ed6756bc..326991f4d98096 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1143,7 +1143,7 @@ xfs_flags2diflags(
 {
 	/* can't set PREALLOC this way, just preserve it */
 	uint16_t		di_flags =
-		(ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
+		(ip->i_diflags & XFS_DIFLAG_PREALLOC);
 
 	if (xflags & FS_XFLAG_IMMUTABLE)
 		di_flags |= XFS_DIFLAG_IMMUTABLE;
@@ -1228,7 +1228,7 @@ xfs_ioctl_setattr_xflags(
 	if (di_flags2 && !xfs_sb_version_has_v3inode(&mp->m_sb))
 		return -EINVAL;
 
-	ip->i_d.di_flags = xfs_flags2diflags(ip, fa->fsx_xflags);
+	ip->i_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
 	ip->i_d.di_flags2 = di_flags2;
 
 	xfs_diflags_to_iflags(ip, false);
@@ -1570,7 +1570,7 @@ xfs_ioctl_setattr(
 	 * extent size hint should be set on the inode. If no extent size flags
 	 * are set on the inode then unconditionally clear the extent size hint.
 	 */
-	if (ip->i_d.di_flags & (XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT))
+	if (ip->i_diflags & (XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT))
 		ip->i_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
 	else
 		ip->i_extsize = 0;
@@ -1622,9 +1622,8 @@ xfs_ioc_getxflags(
 	xfs_inode_t		*ip,
 	void			__user *arg)
 {
-	unsigned int		flags;
+	unsigned int		flags = xfs_di2lxflags(ip->i_diflags);
 
-	flags = xfs_di2lxflags(ip->i_d.di_flags);
 	if (copy_to_user(arg, &flags, sizeof(flags)))
 		return -EFAULT;
 	return 0;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 78159c57d82828..f37154fc9828fd 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -567,11 +567,11 @@ xfs_vn_getattr(
 	 * Note: If you add another clause to set an attribute flag, please
 	 * update attributes_mask below.
 	 */
-	if (ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE)
+	if (ip->i_diflags & XFS_DIFLAG_IMMUTABLE)
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
-	if (ip->i_d.di_flags & XFS_DIFLAG_APPEND)
+	if (ip->i_diflags & XFS_DIFLAG_APPEND)
 		stat->attributes |= STATX_ATTR_APPEND;
-	if (ip->i_d.di_flags & XFS_DIFLAG_NODUMP)
+	if (ip->i_diflags & XFS_DIFLAG_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
 
 	stat->attributes_mask |= (STATX_ATTR_IMMUTABLE |
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 9f70d2f68e059b..95cc3386ac3b4f 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -233,7 +233,7 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
  * configured realtime device.
  */
 #define XFS_IS_REALTIME_INODE(ip)			\
-	(((ip)->i_d.di_flags & XFS_DIFLAG_REALTIME) &&	\
+	(((ip)->i_diflags & XFS_DIFLAG_REALTIME) &&	\
 	 (ip)->i_mount->m_rtdev_targp)
 #define XFS_IS_REALTIME_MOUNT(mp) ((mp)->m_rtdev_targp ? 1 : 0)
 #else
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index cc07d7d27dd7e0..592a1160200f5e 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1281,8 +1281,8 @@ xfs_rtpick_extent(
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
 	seqp = (uint64_t *)&VFS_I(mp->m_rbmip)->i_atime;
-	if (!(mp->m_rbmip->i_d.di_flags & XFS_DIFLAG_NEWRTBM)) {
-		mp->m_rbmip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
+	if (!(mp->m_rbmip->i_diflags & XFS_DIFLAG_NEWRTBM)) {
+		mp->m_rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
 		*seqp = 0;
 	}
 	seq = *seqp;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fa58cb07c8fdfe..06a01528543aef 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -828,13 +828,13 @@ xfs_fs_statfs(
 	statp->f_ffree = max_t(int64_t, ffree, 0);
 
 
-	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
+	if ((ip->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
 	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
 			      (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
 		xfs_qm_statvfs(ip, statp);
 
 	if (XFS_IS_REALTIME_MOUNT(mp) &&
-	    (ip->i_d.di_flags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME))) {
+	    (ip->i_diflags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME))) {
 		statp->f_blocks = sbp->sb_rblocks;
 		statp->f_bavail = statp->f_bfree =
 			sbp->sb_frextents * sbp->sb_rextsize;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 6b8980b1497c9a..dc86e3117f73f0 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -207,7 +207,7 @@ xfs_symlink(
 	/*
 	 * Check whether the directory allows new symlinks or not.
 	 */
-	if (dp->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) {
+	if (dp->i_diflags & XFS_DIFLAG_NOSYMLINKS) {
 		error = -EPERM;
 		goto out_trans_cancel;
 	}
-- 
2.26.2

