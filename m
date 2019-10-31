Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA833EAAB2
	for <lists+linux-xfs@lfdr.de>; Thu, 31 Oct 2019 07:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbfJaGl6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 31 Oct 2019 02:41:58 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41477 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfJaGl6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Oct 2019 02:41:58 -0400
Received: by mail-pf1-f193.google.com with SMTP id p26so3585218pfq.8;
        Wed, 30 Oct 2019 23:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=P/NxyshvG11M1tdKOE1168l81cd4EUrPRNt2//edEWk=;
        b=iMrZAOwYCk7pr9YdO9aam4SkwFzG2g7IMh8koodoALU8VvsU7Sh+BgM1BVSRMZpfme
         euudCD9G8gGq6PmcN/8Pu3GtUKwnT+nLWjGh6w2LoYL7pIF0+pWMhx52ui3kcz0z4QUV
         JBuHq3RRypcZ767T9Z9y/0LAuojL7IZ2TiKk6qCzdRHW1vggwuI58eZ6UizupyPqtNcU
         0C/1cbwY1euKUvp/UTMfHCw3iEdpSKa6pR5f3FsGLud9k387YfkmOLEiiqDFvGqC+UOA
         2pnUvqhaEysJygu1XBg64I/idSIAESboQq2QE7ml8QmLlC5muWcW9Eir/kSy88y1Iyie
         fasw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=P/NxyshvG11M1tdKOE1168l81cd4EUrPRNt2//edEWk=;
        b=dmK68XcgH9tYmhToUMGoEWvKTtgvQA0uZzEjfhZycTak9KVXyaa5Kuyefp3fbsJx6+
         XAY5WIzlNKvzEUtuURo4aM7VUPKLE5UR/Y9EsdmYCkrSxxcCwqVyAEChflI03ATU/zre
         DZFnlIMfdsQHe7KGmYMswkRA5o5ftFmaFlu+DzAMnkSMgEu7P2jwTr4pOaRHZx1fPt6G
         ugctqNUSVmXvXITWYHY85RM55ZYVyCGeW3pN1hZkDsKMOkKFRs7rZdtZL4eP+Ej8ed9w
         BdpIe40ozx8MqwIb1eEBnaiejebLObpgGU2NrzN8HEJx4e3VOIT8V3IQ3omlOfgZIOf7
         EsTQ==
X-Gm-Message-State: APjAAAWgrvSy6SF/8xRuH79WOom3dcl7nfsnqCuvHvfWA03hRNWSLJ28
        5VJ3euA+wPK3aazvYL3TDpHv3L5K3Q==
X-Google-Smtp-Source: APXvYqyz2X3mq/415/J3hdAzSS+lDpYAhIoCRZpOq245SSvv67/mS6wNwSfafGiziLBE8R/DsTe1PQ==
X-Received: by 2002:aa7:9639:: with SMTP id r25mr4379796pfg.17.1572504117535;
        Wed, 30 Oct 2019 23:41:57 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id x7sm2218815pff.0.2019.10.30.23.41.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 23:41:57 -0700 (PDT)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, guaneryu@gmail.com, bfoster@redhat.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: [PATCH v3 3/4] fsstress: add EXCHANGE renameat2 support
Date:   Thu, 31 Oct 2019 14:41:48 +0800
Message-Id: <cd82570764e56234fbbf8dd20cc9d51aee07c4df.1572503039.git.kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1572503039.git.kaixuxia@tencent.com>
References: <cover.1572503039.git.kaixuxia@tencent.com>
In-Reply-To: <cover.1572503039.git.kaixuxia@tencent.com>
References: <cover.1572503039.git.kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Support the EXCHANGE renameat2 syscall in fsstress.

In order to maintain filelist/filename integrity, we restrict
rexchange to files of the same type.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
---
 ltp/fsstress.c | 117 ++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 96 insertions(+), 21 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index ecc1adc..0125571 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -69,6 +69,9 @@ static int renameat2(int dfd1, const char *path1,
 #ifndef RENAME_NOREPLACE
 #define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
 #endif
+#ifndef RENAME_EXCHANGE
+#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
+#endif
 #ifndef RENAME_WHITEOUT
 #define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
 #endif
@@ -115,6 +118,7 @@ typedef enum {
 	OP_REMOVEFATTR,
 	OP_RENAME,
 	OP_RNOREPLACE,
+	OP_REXCHANGE,
 	OP_RWHITEOUT,
 	OP_RESVSP,
 	OP_RMDIR,
@@ -235,6 +239,7 @@ void	readv_f(int, long);
 void	removefattr_f(int, long);
 void	rename_f(int, long);
 void	rnoreplace_f(int, long);
+void	rexchange_f(int, long);
 void	rwhiteout_f(int, long);
 void	resvsp_f(int, long);
 void	rmdir_f(int, long);
@@ -296,6 +301,7 @@ opdesc_t	ops[] = {
 	{ OP_REMOVEFATTR, "removefattr", removefattr_f, 1, 1 },
 	{ OP_RENAME, "rename", rename_f, 2, 1 },
 	{ OP_RNOREPLACE, "rnoreplace", rnoreplace_f, 2, 1 },
+	{ OP_REXCHANGE, "rexchange", rexchange_f, 2, 1 },
 	{ OP_RWHITEOUT, "rwhiteout", rwhiteout_f, 2, 1 },
 	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
 	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
@@ -371,7 +377,8 @@ void	del_from_flist(int, int);
 int	dirid_to_name(char *, int);
 void	doproc(void);
 int	fent_to_name(pathname_t *, flist_t *, fent_t *);
-void	fix_parent(int, int);
+bool	fents_ancestor_check(fent_t *, fent_t *);
+void	fix_parent(int, int, bool);
 void	free_pathname(pathname_t *);
 int	generate_fname(fent_t *, int, pathname_t *, int *, int *);
 int	generate_xattr_name(int, char *, int);
@@ -1117,8 +1124,22 @@ fent_to_name(pathname_t *name, flist_t *flp, fent_t *fep)
 	return 1;
 }
 
+bool
+fents_ancestor_check(fent_t *fep, fent_t *dfep)
+{
+	fent_t  *tmpfep;
+
+	for (tmpfep = fep; tmpfep->parent != -1;
+	     tmpfep = dirid_to_fent(tmpfep->parent)) {
+		if (tmpfep->parent == dfep->id)
+			return true;
+	}
+
+	return false;
+}
+
 void
-fix_parent(int oldid, int newid)
+fix_parent(int oldid, int newid, bool swap)
 {
 	fent_t	*fep;
 	flist_t	*flp;
@@ -1129,6 +1150,8 @@ fix_parent(int oldid, int newid)
 		for (j = 0, fep = flp->fents; j < flp->nfiles; j++, fep++) {
 			if (fep->parent == oldid)
 				fep->parent = newid;
+			else if (swap && fep->parent == newid)
+				fep->parent = oldid;
 		}
 	}
 }
@@ -4256,6 +4279,7 @@ out:
 
 struct print_flags renameat2_flags [] = {
 	{ RENAME_NOREPLACE, "NOREPLACE"},
+	{ RENAME_EXCHANGE, "EXCHANGE"},
 	{ RENAME_WHITEOUT, "WHITEOUT"},
 	{ -1, NULL}
 };
@@ -4291,41 +4315,86 @@ do_renameat2(int opno, long r, int mode)
 		return;
 	}
 
-	/* get an existing directory for the destination parent directory name */
-	if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
-		parid = -1;
-	else
-		parid = dfep->id;
-	v |= v1;
+	/*
+	 * Both pathnames must exist for the RENAME_EXCHANGE, and in
+	 * order to maintain filelist/filename integrity, we should
+	 * restrict exchange operation to files of the same type.
+	 */
+	if (mode == RENAME_EXCHANGE) {
+		which = 1 << (flp - flist);
+		init_pathname(&newf);
+		if (!get_fname(which, random(), &newf, NULL, &dfep, &v)) {
+			if (v)
+				printf("%d/%d: rename - no target filename\n",
+					procid, opno);
+			free_pathname(&newf);
+			free_pathname(&f);
+			return;
+		}
+		if (which == FT_DIRm && (fents_ancestor_check(fep, dfep) ||
+		    fents_ancestor_check(dfep, fep))) {
+			if (v)
+				printf("%d/%d: rename(REXCHANGE) %s and %s "
+					"have ancestor-descendant relationship\n",
+					procid, opno, f.path, newf.path);
+			free_pathname(&newf);
+			free_pathname(&f);
+			return;
+		}
+		v |= v1;
+		id = dfep->id;
+		parid = dfep->parent;
+	} else {
+		/*
+		 * Get an existing directory for the destination parent
+		 * directory name.
+		 */
+		if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
+			parid = -1;
+		else
+			parid = dfep->id;
+		v |= v1;
 
-	/* generate a new path using an existing parent directory in name */
-	init_pathname(&newf);
-	e = generate_fname(dfep, flp - flist, &newf, &id, &v1);
-	v |= v1;
-	if (!e) {
-		if (v) {
-			(void)fent_to_name(&f, &flist[FT_DIR], dfep);
-			printf("%d/%d: rename - no filename from %s\n",
-				procid, opno, f.path);
+		/*
+		 * Generate a new path using an existing parent directory
+		 * in name.
+		 */
+		init_pathname(&newf);
+		e = generate_fname(dfep, flp - flist, &newf, &id, &v1);
+		v |= v1;
+		if (!e) {
+			if (v) {
+				(void)fent_to_name(&f, &flist[FT_DIR], dfep);
+				printf("%d/%d: rename - no filename from %s\n",
+					procid, opno, f.path);
+			}
+			free_pathname(&newf);
+			free_pathname(&f);
+			return;
 		}
-		free_pathname(&newf);
-		free_pathname(&f);
-		return;
 	}
 	e = rename_path(&f, &newf, mode) < 0 ? errno : 0;
 	check_cwd();
 	if (e == 0) {
 		int xattr_counter = fep->xattr_counter;
+		bool swap = (mode == RENAME_EXCHANGE) ? true : false;
 
 		oldid = fep->id;
 		oldparid = fep->parent;
 
+		/*
+		 * Swap the parent ids for RENAME_EXCHANGE, and replace the
+		 * old parent id for the others.
+		 */
 		if (flp - flist == FT_DIR)
-			fix_parent(oldid, id);
+			fix_parent(oldid, id, swap);
 
 		if (mode == RENAME_WHITEOUT) {
 			fep->xattr_counter = 0;
 			add_to_flist(flp - flist, id, parid, xattr_counter);
+		} else if (mode == RENAME_EXCHANGE) {
+			fep->xattr_counter = dfep->xattr_counter;
+			dfep->xattr_counter = xattr_counter;
 		} else {
 			del_from_flist(flp - flist, fep - flp->fents);
 			add_to_flist(flp - flist, id, parid, xattr_counter);
@@ -4359,6 +4428,12 @@ rnoreplace_f(int opno, long r)
 }
 
 void
+rexchange_f(int opno, long r)
+{
+	do_renameat2(opno, r, RENAME_EXCHANGE);
+}
+
+void
 rwhiteout_f(int opno, long r)
 {
 	do_renameat2(opno, r, RENAME_WHITEOUT);
-- 
1.8.3.1

