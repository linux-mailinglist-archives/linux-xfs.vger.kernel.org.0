Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 251CA1E5FB
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 02:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfEOARq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 May 2019 20:17:46 -0400
Received: from sandeen.net ([63.231.237.45]:40680 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbfEOARp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 14 May 2019 20:17:45 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B55DF1725B;
        Tue, 14 May 2019 19:17:28 -0500 (CDT)
Subject: [PATCH 03/11 V2] libxfs: remove unused cruft
To:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-4-git-send-email-sandeen@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <7b7e0bb3-3fac-6602-cff0-c868d6d0540c@sandeen.net>
Date:   Tue, 14 May 2019 19:17:44 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1557519510-10602-4-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove many unused #defines and functions.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Remove libxfs_trans_ijoin_ref as well

diff --git a/include/libxfs.h b/include/libxfs.h
index 2bdef70..230bc3e 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -154,9 +154,6 @@ extern int	libxfs_log_header(char *, uuid_t *, int, int, int, xfs_lsn_t,
 extern int	libxfs_alloc_file_space (struct xfs_inode *, xfs_off_t,
 				xfs_off_t, int, int);
 
-extern void	libxfs_fs_repair_cmn_err(int, struct xfs_mount *, char *, ...);
-extern void	libxfs_fs_cmn_err(int, struct xfs_mount *, char *, ...);
-
 /* XXX: this is messy and needs fixing */
 #ifndef __LIBXFS_INTERNAL_XFS_H__
 extern void cmn_err(int, char *, ...);
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 832bde1..10b7453 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -47,13 +47,6 @@ typedef struct xfs_buf_log_item {
 #define XFS_BLI_STALE			(1<<2)
 #define XFS_BLI_INODE_ALLOC_BUF		(1<<3)
 
-typedef struct xfs_dq_logitem {
-	xfs_log_item_t		qli_item;	/* common portion */
-	struct xfs_dquot	*qli_dquot;	/* dquot ptr */
-	xfs_lsn_t		qli_flush_lsn;	/* lsn at last flush */
-	xfs_dq_logformat_t	qli_format;	/* logged structure */
-} xfs_dq_logitem_t;
-
 typedef struct xfs_qoff_logitem {
 	xfs_log_item_t		qql_item;	/* common portion */
 	struct xfs_qoff_logitem	*qql_start_lip;	/* qoff-start logitem, if any */
@@ -64,7 +57,6 @@ typedef struct xfs_qoff_logitem {
 #define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
 
 typedef struct xfs_trans {
-	unsigned int	t_type;			/* transaction type */
 	unsigned int	t_log_res;		/* amt of log space resvd */
 	unsigned int	t_log_count;		/* count for perm log res */
 	unsigned int	t_blk_res;		/* # of blocks resvd */
@@ -98,7 +90,6 @@ void xfs_defer_cancel(struct xfs_trans *);
 struct xfs_buf *libxfs_trans_getsb(struct xfs_trans *, struct xfs_mount *, int);
 
 void	libxfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
-void	libxfs_trans_ijoin_ref(struct xfs_trans *, struct xfs_inode *, int);
 void	libxfs_trans_log_inode (struct xfs_trans *, struct xfs_inode *,
 				uint);
 int	libxfs_trans_roll_inode (struct xfs_trans **, struct xfs_inode *);
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index bb0f07b..1150ec9 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -16,9 +16,6 @@
 #define xfs_highbit32			libxfs_highbit32
 #define xfs_highbit64			libxfs_highbit64
 
-#define xfs_fs_repair_cmn_err		libxfs_fs_repair_cmn_err
-#define xfs_fs_cmn_err			libxfs_fs_cmn_err
-
 #define xfs_trans_alloc			libxfs_trans_alloc
 #define xfs_trans_alloc_empty		libxfs_trans_alloc_empty
 #define xfs_trans_add_item		libxfs_trans_add_item
@@ -61,7 +58,6 @@
 #define xfs_bmapi_write			libxfs_bmapi_write
 #define xfs_bmapi_read			libxfs_bmapi_read
 #define xfs_bunmapi			libxfs_bunmapi
-#define xfs_bmbt_get_all		libxfs_bmbt_get_all
 #define xfs_rtfree_extent		libxfs_rtfree_extent
 #define xfs_verify_rtbno		libxfs_verify_rtbno
 #define xfs_verify_ino			libxfs_verify_ino
@@ -70,7 +66,6 @@
 #define xfs_defer_finish		libxfs_defer_finish
 #define xfs_defer_cancel		libxfs_defer_cancel
 
-#define xfs_da_brelse			libxfs_da_brelse
 #define xfs_da_hashname			libxfs_da_hashname
 #define xfs_da_shrink_inode		libxfs_da_shrink_inode
 #define xfs_da_read_buf			libxfs_da_read_buf
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index a2a8388..d668a15 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -122,7 +122,6 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #define xfs_warn(mp,fmt,args...)		cmn_err(CE_WARN,fmt, ## args)
 #define xfs_err(mp,fmt,args...)			cmn_err(CE_ALERT,fmt, ## args)
 #define xfs_alert(mp,fmt,args...)		cmn_err(CE_ALERT,fmt, ## args)
-#define xfs_alert_tag(mp,tag,fmt,args...)	cmn_err(CE_ALERT,fmt, ## args)
 
 #define xfs_hex_dump(d,n)		((void) 0)
 #define xfs_stack_trace()		((void) 0)
@@ -195,8 +194,6 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #endif
 
 /* miscellaneous kernel routines not in user space */
-#define down_read(a)		((void) 0)
-#define up_read(a)		((void) 0)
 #define spin_lock_init(a)	((void) 0)
 #define spin_lock(a)		((void) 0)
 #define spin_unlock(a)		((void) 0)
@@ -400,7 +397,6 @@ roundup_64(uint64_t x, uint32_t y)
 
 #define XBRW_READ			LIBXFS_BREAD
 #define XBRW_WRITE			LIBXFS_BWRITE
-#define xfs_buf_iomove(bp,off,len,data,f)	libxfs_iomove(bp,off,len,data,f)
 #define xfs_buf_zero(bp,off,len)     libxfs_iomove(bp,off,len,NULL,LIBXFS_BZERO)
 
 /* mount stuff */
@@ -436,8 +432,6 @@ roundup_64(uint64_t x, uint32_t y)
 #define xfs_sort					qsort
 
 #define xfs_ilock(ip,mode)				((void) 0)
-#define xfs_ilock_nowait(ip,mode)			((void) 0)
-#define xfs_ilock_demote(ip,mode)			((void) 0)
 #define xfs_ilock_data_map_shared(ip)			(0)
 #define xfs_ilock_attr_map_shared(ip)			(0)
 #define xfs_iunlock(ip,mode)				({	\
@@ -470,9 +464,6 @@ roundup_64(uint64_t x, uint32_t y)
 #define xfs_filestream_lookup_ag(ip)		(0)
 #define xfs_filestream_new_ag(ip,ag)		(0)
 
-#define xfs_log_force(mp,flags)			((void) 0)
-#define XFS_LOG_SYNC				1
-
 /* quota bits */
 #define xfs_trans_mod_dquot_byino(t,i,f,d)		((void) 0)
 #define xfs_trans_reserve_quota_nblks(t,i,b,n,f)	(0)
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 64131b2..ee79047 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -360,21 +360,6 @@ libxfs_trans_ijoin(
 }
 
 void
-libxfs_trans_ijoin_ref(
-	xfs_trans_t		*tp,
-	xfs_inode_t		*ip,
-	int			lock_flags)
-{
-	ASSERT(ip->i_itemp != NULL);
-
-	xfs_trans_ijoin(tp, ip, lock_flags);
-
-#ifdef XACT_DEBUG
-	fprintf(stderr, "ijoin_ref'd inode %llu, transaction %p\n", ip->i_ino, tp);
-#endif
-}
-
-void
 libxfs_trans_inode_alloc_buf(
 	xfs_trans_t		*tp,
 	xfs_buf_t		*bp)
diff --git a/libxfs/util.c b/libxfs/util.c
index 9fe9a36..8c9954f 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -603,35 +603,6 @@ libxfs_inode_alloc(
 	return error;
 }
 
-/*
- * Userspace versions of common diagnostic routines (varargs fun).
- */
-void
-libxfs_fs_repair_cmn_err(int level, xfs_mount_t *mp, char *fmt, ...)
-{
-	va_list	ap;
-
-	va_start(ap, fmt);
-	vfprintf(stderr, fmt, ap);
-	fprintf(stderr, "  This is a bug.\n");
-	fprintf(stderr, "%s version %s\n", progname, VERSION);
-	fprintf(stderr,
-		"Please capture the filesystem metadata with xfs_metadump and\n"
-		"report it to linux-xfs@vger.kernel.org\n");
-	va_end(ap);
-}
-
-void
-libxfs_fs_cmn_err(int level, xfs_mount_t *mp, char *fmt, ...)
-{
-	va_list	ap;
-
-	va_start(ap, fmt);
-	vfprintf(stderr, fmt, ap);
-	fputs("\n", stderr);
-	va_end(ap);
-}
-
 void
 cmn_err(int level, char *fmt, ...)
 {

