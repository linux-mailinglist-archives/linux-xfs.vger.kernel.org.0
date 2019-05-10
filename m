Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 852FA1A1F8
	for <lists+linux-xfs@lfdr.de>; Fri, 10 May 2019 18:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbfEJQwZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 May 2019 12:52:25 -0400
Received: from sandeen.net ([63.231.237.45]:47680 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbfEJQwZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 May 2019 12:52:25 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 06C367B70;
        Fri, 10 May 2019 11:52:12 -0500 (CDT)
Subject: [PATCH V2] xfs: remove unused flags arg from getsb interfaces
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <d678aac9-c213-36ef-1149-4d510bf85008@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <e499ead7-4cbc-163e-02b3-0750f2508e51@sandeen.net>
Date:   Fri, 10 May 2019 11:52:22 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <d678aac9-c213-36ef-1149-4d510bf85008@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The flags value is always passed as 0 so remove the argument.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---

V2: Drop the trylock that's now pointless w/o the flag.

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index e76a3e5d28d7..f1c60aa5d312 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -939,7 +939,7 @@ xfs_log_sb(
 	struct xfs_trans	*tp)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp, 0);
+	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp);
 
 	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
 	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
@@ -1069,7 +1069,7 @@ xfs_sync_sb_buf(
 	if (error)
 		return error;
 
-	bp = xfs_trans_getsb(tp, mp, 0);
+	bp = xfs_trans_getsb(tp, mp);
 	xfs_log_sb(tp);
 	xfs_trans_bhold(tp, bp);
 	xfs_trans_set_sync(tp);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9329f5adbfbe..4cb7d4906c33 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5687,7 +5687,7 @@ xlog_do_recover(
 	 * Now that we've finished replaying all buffer and inode
 	 * updates, re-read in the superblock and reverify it.
 	 */
-	bp = xfs_getsb(mp, 0);
+	bp = xfs_getsb(mp);
 	bp->b_flags &= ~(XBF_DONE | XBF_ASYNC);
 	ASSERT(!(bp->b_flags & XBF_WRITE));
 	bp->b_flags |= XBF_READ;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6b2bfe81dc51..70a93f3b914e 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1385,24 +1385,14 @@ xfs_mod_frextents(
  * xfs_getsb() is called to obtain the buffer for the superblock.
  * The buffer is returned locked and read in from disk.
  * The buffer should be released with a call to xfs_brelse().
- *
- * If the flags parameter is BUF_TRYLOCK, then we'll only return
- * the superblock buffer if it can be locked without sleeping.
- * If it can't then we'll return NULL.
  */
 struct xfs_buf *
 xfs_getsb(
-	struct xfs_mount	*mp,
-	int			flags)
+	struct xfs_mount	*mp)
 {
 	struct xfs_buf		*bp = mp->m_sb_bp;
 
-	if (!xfs_buf_trylock(bp)) {
-		if (flags & XBF_TRYLOCK)
-			return NULL;
-		xfs_buf_lock(bp);
-	}
-
+	xfs_buf_lock(bp);
 	xfs_buf_hold(bp);
 	ASSERT(bp->b_flags & XBF_DONE);
 	return bp;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c81a5cd7c228..11073b470c41 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -465,7 +465,7 @@ extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 bool reserved);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
 
-extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
+extern struct xfs_buf *xfs_getsb(xfs_mount_t *);
 extern int	xfs_readsb(xfs_mount_t *, int);
 extern void	xfs_freesb(xfs_mount_t *);
 extern bool	xfs_fs_writable(struct xfs_mount *mp, int level);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 912b42f5fe4a..0746b329a937 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -452,7 +452,7 @@ xfs_trans_apply_sb_deltas(
 	xfs_buf_t	*bp;
 	int		whole = 0;
 
-	bp = xfs_trans_getsb(tp, tp->t_mountp, 0);
+	bp = xfs_trans_getsb(tp, tp->t_mountp);
 	sbp = XFS_BUF_TO_SBP(bp);
 
 	/*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index c6e1c5704a8c..fd35da161a2b 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -203,7 +203,7 @@ xfs_trans_read_buf(
 				      flags, bpp, ops);
 }
 
-struct xfs_buf	*xfs_trans_getsb(xfs_trans_t *, struct xfs_mount *, int);
+struct xfs_buf	*xfs_trans_getsb(xfs_trans_t *, struct xfs_mount *);
 
 void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_bjoin(xfs_trans_t *, struct xfs_buf *);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 7d65ebf1e847..a1764a1dbd99 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -174,8 +174,7 @@ xfs_trans_get_buf_map(
 xfs_buf_t *
 xfs_trans_getsb(
 	xfs_trans_t		*tp,
-	struct xfs_mount	*mp,
-	int			flags)
+	struct xfs_mount	*mp)
 {
 	xfs_buf_t		*bp;
 	struct xfs_buf_log_item	*bip;
@@ -185,7 +184,7 @@ xfs_trans_getsb(
 	 * if tp is NULL.
 	 */
 	if (tp == NULL)
-		return xfs_getsb(mp, flags);
+		return xfs_getsb(mp);
 
 	/*
 	 * If the superblock buffer already has this transaction
@@ -203,7 +202,7 @@ xfs_trans_getsb(
 		return bp;
 	}
 
-	bp = xfs_getsb(mp, flags);
+	bp = xfs_getsb(mp);
 	if (bp == NULL)
 		return NULL;
 

