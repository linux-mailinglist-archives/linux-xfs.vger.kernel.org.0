Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E655D4A8A87
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Feb 2022 18:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353042AbiBCRps (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 3 Feb 2022 12:45:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59228 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353097AbiBCRpn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Feb 2022 12:45:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FDFBB83498
        for <linux-xfs@vger.kernel.org>; Thu,  3 Feb 2022 17:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06276C340E8;
        Thu,  3 Feb 2022 17:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643910341;
        bh=t95x927JcID+g+zm3ICIkm9yFYfSKpztTgMydo1ZfsY=;
        h=Date:From:To:Cc:Subject:From;
        b=Ll8kRUGnKEspqrUnTX+jTTCGhKVlgoMHj30pJOJ3cTWWcQ+Pj78YX5Tw86SSXSaPK
         WGMkL+H39Yfc/wi24xXF2sySw9ARx99FDxB/cJARdi/a8VuP8k+8clQhTUhfAKEkZk
         Zo6aOQbmYxjXLJfw7G3/u4VG6GdDw6M2pEfE3avVVoxhlJAdFCrK+pfEOSsJCk81j0
         4Z4QxT1w6GWI0yf+w+GVDmRzAF16743t6YoY/SDta9NpdnE8fN30hOsBc8LAdw/LJb
         WMql5oHXfaJTIoJ0YngM8k1vsRUVk/vftZsRxqHe+Jz0UAW/m57aE4SA/sKnfTQV6x
         83k6stXB/e1ew==
Date:   Thu, 3 Feb 2022 09:45:40 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_restore: remove DMAPI support
Message-ID: <20220203174540.GT8313@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The last of the DMAPI stubs were removed from Linux 5.17, so drop this
functionality altogether.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 doc/xfsdump.html  |    1 -
 po/de.po          |    5 ---
 po/pl.po          |    5 ---
 restore/content.c |   99 +++--------------------------------------------------
 restore/tree.c    |   33 ------------------
 restore/tree.h    |    1 -
 6 files changed, 6 insertions(+), 138 deletions(-)

diff --git a/doc/xfsdump.html b/doc/xfsdump.html
index d4d157f..2c9324b 100644
--- a/doc/xfsdump.html
+++ b/doc/xfsdump.html
@@ -1092,7 +1092,6 @@ the size of the hash table.
         bool_t p_ownerpr - whether to restore directory owner/group attributes
         bool_t p_fullpr - whether restoring a full level 0 non-resumed dump
         bool_t p_ignoreorphpr - set if positive subtree or interactive
-        bool_t p_restoredmpr - restore DMI event settings
 </pre>
 <p>
 The hash table maps the inode number to the tree node. It is a
diff --git a/po/de.po b/po/de.po
index 62face8..bdf47d1 100644
--- a/po/de.po
+++ b/po/de.po
@@ -3972,11 +3972,6 @@ msgstr ""
 msgid "no additional media objects needed\n"
 msgstr "keine zusätzlichen Mediendateien benötigt\n"
 
-#: .././restore/content.c:9547
-#, c-format
-msgid "fssetdm_by_handle of %s failed %s\n"
-msgstr "fssetdm_by_handle von %s fehlgeschlagen %s\n"
-
 #: .././restore/content.c:9566
 #, c-format
 msgid "%s quota information written to '%s'\n"
diff --git a/po/pl.po b/po/pl.po
index 3cba8d6..ba25420 100644
--- a/po/pl.po
+++ b/po/pl.po
@@ -3455,11 +3455,6 @@ msgstr "nie są potrzebne dodatkowe obiekty nośnika\n"
 msgid "path_to_handle of %s failed:%s\n"
 msgstr "path_to_handle na %s nie powiodło się: %s\n"
 
-#: .././restore/content.c:9723
-#, c-format
-msgid "fssetdm_by_handle of %s failed %s\n"
-msgstr "fssetdm_by_handle na %s nie powiodło się: %s\n"
-
 #: .././restore/content.c:9742
 #, c-format
 msgid "%s quota information written to '%s'\n"
diff --git a/restore/content.c b/restore/content.c
index 6b22965..e9b0a07 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -477,9 +477,6 @@ struct pers {
 			/* how many pages following the header page are reserved
 			 * for the subtree descriptors
 			 */
-		bool_t restoredmpr;
-			/* restore DMAPI event settings
-			 */
 		bool_t restoreextattrpr;
 			/* restore extended attributes
 			 */
@@ -858,7 +855,6 @@ static void partial_reg(ix_t d_index, xfs_ino_t ino, off64_t fsize,
                         off64_t offset, off64_t sz);
 static bool_t partial_check (xfs_ino_t ino, off64_t fsize);
 static bool_t partial_check2 (partial_rest_t *isptr, off64_t fsize);
-static int do_fssetdm_by_handle(char *path, fsdmidata_t *fdmp);
 static int quotafilecheck(char *type, char *dstdir, char *quotafile);
 
 /* definition of locally defined global variables ****************************/
@@ -894,7 +890,6 @@ content_init(int argc, char *argv[], size64_t vmsz)
 	bool_t changepr;/* cmd line overwrite inhibit specification */
 	bool_t interpr;	/* cmd line interactive mode requested */
 	bool_t ownerpr;	/* cmd line chown/chmod requested */
-	bool_t restoredmpr; /* cmd line restore dm api attrs specification */
 	bool_t restoreextattrpr; /* cmd line restore extended attr spec */
 	bool_t sesscpltpr; /* force completion of prev interrupted session */
 	ix_t stcnt;	/* cmd line number of subtrees requested */
@@ -956,7 +951,6 @@ content_init(int argc, char *argv[], size64_t vmsz)
 	newerpr = BOOL_FALSE;
 	changepr = BOOL_FALSE;
 	ownerpr = BOOL_FALSE;
-	restoredmpr = BOOL_FALSE;
 	restoreextattrpr = BOOL_TRUE;
 	sesscpltpr = BOOL_FALSE;
 	stcnt = 0;
@@ -1162,8 +1156,11 @@ content_init(int argc, char *argv[], size64_t vmsz)
 			tranp->t_noinvupdatepr = BOOL_TRUE;
 			break;
 		case GETOPT_SETDM:
-			restoredmpr = BOOL_TRUE;
-			break;
+			mlog(MLOG_NORMAL | MLOG_ERROR, _(
+			      "-%c option no longer supported\n"),
+			      GETOPT_SETDM);
+			usage();
+			return BOOL_FALSE;
 		case GETOPT_ALERTPROG:
 			if (!optarg || optarg[0] == '-') {
 				mlog(MLOG_NORMAL | MLOG_ERROR, _(
@@ -1574,12 +1571,6 @@ content_init(int argc, char *argv[], size64_t vmsz)
 	}
 
 	if (persp->a.valpr) {
-		if (restoredmpr && persp->a.restoredmpr != restoredmpr) {
-			mlog(MLOG_NORMAL | MLOG_ERROR, _(
-			     "-%c cannot reset flag from previous restore\n"),
-			      GETOPT_SETDM);
-			return BOOL_FALSE;
-		}
 		if (!restoreextattrpr &&
 		       persp->a.restoreextattrpr != restoreextattrpr) {
 			mlog(MLOG_NORMAL | MLOG_ERROR, _(
@@ -1734,7 +1725,6 @@ content_init(int argc, char *argv[], size64_t vmsz)
 			persp->a.newerpr = newerpr;
 			persp->a.newertime = newertime;
 		}
-		persp->a.restoredmpr = restoredmpr;
 		if (!persp->a.dstdirisxfspr) {
 			restoreextattrpr = BOOL_FALSE;
 		}
@@ -2365,7 +2355,6 @@ content_stream_restore(ix_t thrdix)
 					scrhdrp->cih_inomap_nondircnt,
 					tranp->t_vmsz,
 					fullpr,
-					persp->a.restoredmpr,
 					persp->a.dstdirisxfspr,
 					grhdrp->gh_version,
 					tranp->t_truncategenpr);
@@ -7549,12 +7538,6 @@ restore_reg(drive_t *drivep,
 		}
 	}
 
-	if (persp->a.dstdirisxfspr && persp->a.restoredmpr) {
-		HsmBeginRestoreFile(bstatp,
-				     *fdp,
-				     &strctxp->sc_hsmflags);
-	}
-
 	return BOOL_TRUE;
 }
 
@@ -7726,26 +7709,6 @@ restore_complete_reg(stream_context_t *strcxtp)
 		      strerror(errno));
 	}
 
-	if (persp->a.dstdirisxfspr && persp->a.restoredmpr) {
-		fsdmidata_t fssetdm;
-
-		/* Set the DMAPI Fields. */
-		fssetdm.fsd_dmevmask = bstatp->bs_dmevmask;
-		fssetdm.fsd_padding = 0;
-		fssetdm.fsd_dmstate = bstatp->bs_dmstate;
-
-		rval = ioctl(fd, XFS_IOC_FSSETDM, (void *)&fssetdm);
-		if (rval) {
-			mlog(MLOG_NORMAL | MLOG_WARNING,
-			      _("attempt to set DMI attributes of %s "
-			      "failed: %s\n"),
-			      path,
-			      strerror(errno));
-		}
-
-		HsmEndRestoreFile(path, fd, &strcxtp->sc_hsmflags);
-	}
-
 	/* set any extended inode flags that couldn't be set
 	 * prior to restoring the data.
 	 */
@@ -8064,17 +8027,6 @@ restore_symlink(drive_t *drivep,
 				      strerror(errno));
 			}
 		}
-
-		if (persp->a.restoredmpr) {
-		fsdmidata_t fssetdm;
-
-		/*	Restore DMAPI fields. */
-
-		fssetdm.fsd_dmevmask = bstatp->bs_dmevmask;
-		fssetdm.fsd_padding = 0;
-		fssetdm.fsd_dmstate = bstatp->bs_dmstate;
-		rval = do_fssetdm_by_handle(path, &fssetdm);
-		}
 	}
 
 	return BOOL_TRUE;
@@ -8777,7 +8729,7 @@ restore_extattr(drive_t *drivep,
 		}
 		assert(nread == (int)(recsz - EXTATTRHDR_SZ));
 
-		if (!persp->a.restoreextattrpr && !persp->a.restoredmpr) {
+		if (!persp->a.restoreextattrpr) {
 			continue;
 		}
 
@@ -8796,19 +8748,6 @@ restore_extattr(drive_t *drivep,
 			}
 		} else if (isfilerestored && path[0] != '\0') {
 			setextattr(path, ahdrp);
-
-			if (persp->a.dstdirisxfspr && persp->a.restoredmpr) {
-				int flag = 0;
-				char *attrname = (char *)&ahdrp[1];
-				if (ahdrp->ah_flags & EXTATTRHDR_FLAGS_ROOT)
-					flag = ATTR_ROOT;
-				else if (ahdrp->ah_flags & EXTATTRHDR_FLAGS_SECURE)
-					flag = ATTR_SECURE;
-
-				HsmRestoreAttribute(flag,
-						     attrname,
-						     &strctxp->sc_hsmflags);
-			}
 		}
 	}
 	/* NOTREACHED */
@@ -9709,32 +9648,6 @@ display_needed_objects(purp_t purp,
 	}
 }
 
-static int
-do_fssetdm_by_handle(
-	char		*path,
-	fsdmidata_t	*fdmp)
-{
-	void		*hanp;
-	size_t		hlen=0;
-	int		rc;
-
-	if (path_to_handle(path, &hanp, &hlen)) {
-		mlog(MLOG_NORMAL | MLOG_WARNING, _(
-			"path_to_handle of %s failed:%s\n"),
-			path, strerror(errno));
-		return -1;
-	}
-
-	rc = fssetdm_by_handle(hanp, hlen, fdmp);
-	free_handle(hanp, hlen);
-	if (rc) {
-		mlog(MLOG_NORMAL | MLOG_WARNING, _(
-			"fssetdm_by_handle of %s failed %s\n"),
-			path, strerror(errno));
-	}
-	return rc;
-}
-
 static int
 quotafilecheck(char *type, char *dstdir, char *quotafile)
 {
diff --git a/restore/tree.c b/restore/tree.c
index 0670318..5429b74 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -108,9 +108,6 @@ struct treePersStorage {
 	bool_t p_ignoreorphpr;
 		/* set if positive subtree or interactive
 		 */
-	bool_t p_restoredmpr;
-		/* restore DMI event settings
-		 */
 	bool_t p_truncategenpr;
 		/* truncate inode generation number (for compatibility
 		 * with xfsdump format 2 and earlier)
@@ -348,7 +345,6 @@ tree_init(char *hkdir,
 	   size64_t nondircnt,
 	   size64_t vmsz,
 	   bool_t fullpr,
-	   bool_t restoredmpr,
 	   bool_t dstdirisxfspr,
 	   uint32_t dumpformat,
 	   bool_t truncategenpr)
@@ -508,10 +504,6 @@ tree_init(char *hkdir,
 	 */
 	persp->p_fullpr = fullpr;
 
-	/* record if DMI event settings should be restored
-	 */
-	persp->p_restoredmpr = restoredmpr;
-
 	/* record if truncated generation numbers are required
 	 */
 	if (dumpformat < GLOBAL_HDR_VERSION_3) {
@@ -2550,31 +2542,6 @@ setdirattr(dah_t dah, char *path)
 		}
 	}
 
-	if (tranp->t_dstdirisxfspr && persp->p_restoredmpr) {
-		fsdmidata_t fssetdm;
-
-		fssetdm.fsd_dmevmask = dirattr_get_dmevmask(dah);
-		fssetdm.fsd_padding = 0;	/* not used */
-		fssetdm.fsd_dmstate = (uint16_t)dirattr_get_dmstate(dah);
-
-		/* restore DMAPI event settings etc.
-		 */
-		rval = ioctl(fd,
-			      XFS_IOC_FSSETDM,
-			      (void *)&fssetdm);
-		if (rval) {
-			mlog(errno == EINVAL
-			      ?
-			      (MLOG_NITTY + 1) | MLOG_TREE
-			      :
-			      MLOG_NITTY | MLOG_TREE,
-			      "set DMI attributes"
-			      " of %s failed: %s\n",
-			      path,
-			      strerror(errno));
-		}
-	}
-
 	utimbuf.actime = dirattr_get_atime(dah);
 	utimbuf.modtime = dirattr_get_mtime(dah);
 	rval = utime(path, &utimbuf);
diff --git a/restore/tree.h b/restore/tree.h
index 4f9ffe8..bf66e3d 100644
--- a/restore/tree.h
+++ b/restore/tree.h
@@ -31,7 +31,6 @@ extern bool_t tree_init(char *hkdir,
 			 size64_t nondircnt,
 			 size64_t vmsz,
 			 bool_t fullpr,
-			 bool_t restoredmpr,
 			 bool_t dstdirisxfspr,
 			 uint32_t dumpformat,
 			 bool_t truncategenpr);
