Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 632B720E31
	for <lists+linux-xfs@lfdr.de>; Thu, 16 May 2019 19:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfEPRqz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 May 2019 13:46:55 -0400
Received: from sandeen.net ([63.231.237.45]:33024 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfEPRqz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 May 2019 13:46:55 -0400
Received: from Liberator-6.local (c-73-242-75-113.hsd1.mn.comcast.net [73.242.75.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id AEA351170D;
        Thu, 16 May 2019 12:46:35 -0500 (CDT)
Subject: [PATCH 3/3] xfsprogs: remove unused flags arg from getsb interfaces
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <9807c398-8bfe-367f-3f45-0ff3d5ad84f9@sandeen.net>
Date:   Thu, 16 May 2019 12:46:53 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The flags value is always* passed as 0 so remove the argument.

*mkfs.xfs is the sole exception; it passes a flag to fail on read
error, but we can easily detect the error and exit from main()
manually instead.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(This one might actually come in via a libxfs merge instead)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index d32acc9e..953da5d1 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -87,7 +87,7 @@ void	xfs_trans_cancel(struct xfs_trans *);
 /* cancel dfops associated with a transaction */
 void xfs_defer_cancel(struct xfs_trans *);
 
-struct xfs_buf *xfs_trans_getsb(struct xfs_trans *, struct xfs_mount *, int);
+struct xfs_buf *xfs_trans_getsb(struct xfs_trans *, struct xfs_mount *);
 
 void	xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
 void	xfs_trans_log_inode (struct xfs_trans *, struct xfs_inode *,
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 8fa2c2c5..4dc4d5f3 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -177,7 +177,7 @@ extern void	libxfs_putbuf (xfs_buf_t *);
 
 extern void	libxfs_readbuf_verify(struct xfs_buf *bp,
 			const struct xfs_buf_ops *ops);
-extern xfs_buf_t *xfs_getsb(struct xfs_mount *, int);
+extern xfs_buf_t *xfs_getsb(struct xfs_mount *);
 extern void	libxfs_bcache_purge(void);
 extern void	libxfs_bcache_free(void);
 extern void	libxfs_bcache_flush(void);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 8d6f958a..132ed0a9 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -476,10 +476,10 @@ libxfs_trace_putbuf(const char *func, const char *file, int line, xfs_buf_t *bp)
 
 
 xfs_buf_t *
-xfs_getsb(xfs_mount_t *mp, int flags)
+xfs_getsb(xfs_mount_t *mp)
 {
 	return libxfs_readbuf(mp->m_ddev_targp, XFS_SB_DADDR,
-				XFS_FSS_TO_BB(mp, 1), flags, &xfs_sb_buf_ops);
+				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
 }
 
 kmem_zone_t			*xfs_buf_zone;
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 5ef0c055..9e49def0 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -628,8 +628,7 @@ xfs_trans_get_buf_map(
 xfs_buf_t *
 xfs_trans_getsb(
 	xfs_trans_t		*tp,
-	xfs_mount_t		*mp,
-	int			flags)
+	xfs_mount_t		*mp)
 {
 	xfs_buf_t		*bp;
 	xfs_buf_log_item_t	*bip;
@@ -637,7 +636,7 @@ xfs_trans_getsb(
 	DEFINE_SINGLE_BUF_MAP(map, XFS_SB_DADDR, len);
 
 	if (tp == NULL)
-		return xfs_getsb(mp, flags);
+		return xfs_getsb(mp);
 
 	bp = xfs_trans_buf_item_match(tp, mp->m_dev, &map, 1);
 	if (bp != NULL) {
@@ -648,7 +647,7 @@ xfs_trans_getsb(
 		return bp;
 	}
 
-	bp = xfs_getsb(mp, flags);
+	bp = xfs_getsb(mp);
 #ifdef XACT_DEBUG
 	fprintf(stderr, "trans_get_sb buffer %p, transaction %p\n", bp, tp);
 #endif
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index f1e2ba57..a1857e10 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -915,7 +915,7 @@ xfs_log_sb(
 	struct xfs_trans	*tp)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp, 0);
+	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp);
 
 	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
 	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
@@ -1045,7 +1045,7 @@ xfs_sync_sb_buf(
 	if (error)
 		return error;
 
-	bp = xfs_trans_getsb(tp, mp, 0);
+	bp = xfs_trans_getsb(tp, mp);
 	xfs_log_sb(tp);
 	xfs_trans_bhold(tp, bp);
 	xfs_trans_set_sync(tp);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 09106648..647e2bc2 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4123,7 +4123,11 @@ main(
 	/*
 	 * Mark the filesystem ok.
 	 */
-	buf = libxfs_getsb(mp, LIBXFS_EXIT_ON_FAILURE);
+	buf = libxfs_getsb(mp);
+	if (!buf) {
+		fprintf(stderr, _("couldn't get superblock\n"));
+		exit(1);
+	}
 	(XFS_BUF_TO_SBP(buf))->sb_inprogress = 0;
 	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
diff --git a/repair/phase5.c b/repair/phase5.c
index 0f6a8395..8ad32365 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -2177,7 +2177,7 @@ sync_sb(xfs_mount_t *mp)
 {
 	xfs_buf_t	*bp;
 
-	bp = libxfs_getsb(mp, 0);
+	bp = libxfs_getsb(mp);
 	if (!bp)
 		do_error(_("couldn't get superblock\n"));
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9657503f..4000b3e6 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1044,7 +1044,7 @@ _("Warning:  project quota information would be cleared.\n"
 	/*
 	 * Clear the quota flags if they're on.
 	 */
-	sbp = libxfs_getsb(mp, 0);
+	sbp = libxfs_getsb(mp);
 	if (!sbp)
 		do_error(_("couldn't get superblock\n"));
 

