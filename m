Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674842ED767
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Jan 2021 20:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbhAGTWU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 Jan 2021 14:22:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46753 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727753AbhAGTWU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 14:22:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610047253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wa+R2QIlMGsf0OyobfVwyBA3LKtKa5wnDLuhCPwfGcQ=;
        b=dOzIeONeNQHukuebh4quO12jVwlzI9bBgSAH13wWNstNA0vsPQWc2yCnbGuARjJXEhzicQ
        LP1nB4K1ggzLZxrs671Rn3tH8urlpDWTcPrYJlwQJreKzEf+LapugYxy6yA7CWjB2rUr2p
        xzCihW9UBh37FRzZhWgxavskoEyRIbk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-BEj8kcLQNkubqNL4_7hyUA-1; Thu, 07 Jan 2021 14:20:51 -0500
X-MC-Unique: BEj8kcLQNkubqNL4_7hyUA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D63C180A093
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jan 2021 19:20:50 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C69D5D9DD;
        Thu,  7 Jan 2021 19:20:50 +0000 (UTC)
From:   Eric Sandeen <sandeen@redhat.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH V2] xfsprogs: cosmetic changes to libxfs_inode_alloc
Message-ID: <3fa15760-2e68-2c64-3914-fafbdd0e41fd@redhat.com>
Date:   Thu, 7 Jan 2021 13:20:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This pre-patch helps make the next libxfs-sync for 5.11 a bit
more clear.

In reality, the libxfs_inode_alloc function matches the kernel's
xfs_dir_ialloc so rename it for clarity before the rest of the
sync, and change several variable names for the same reason.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Fix up local transaction pointer problems pointed out by Brian.

Essentially, use tp locally, and reassign tpp on return.

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 742aebc8..01a62daa 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -156,7 +156,7 @@ typedef struct cred {
 	gid_t	cr_gid;
 } cred_t;
 
-extern int	libxfs_inode_alloc (struct xfs_trans **, struct xfs_inode *,
+extern int	libxfs_dir_ialloc (struct xfs_trans **, struct xfs_inode *,
 				mode_t, nlink_t, xfs_dev_t, struct cred *,
 				struct fsxattr *, struct xfs_inode **);
 extern void	libxfs_trans_inode_alloc_buf (struct xfs_trans *,
diff --git a/libxfs/util.c b/libxfs/util.c
index 252cf91e..376c5dac 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -531,9 +531,9 @@ error0:	/* Cancel bmap, cancel trans */
  * other in repair - now there is just the one.
  */
 int
-libxfs_inode_alloc(
-	xfs_trans_t	**tp,
-	xfs_inode_t	*pip,
+libxfs_dir_ialloc(
+	xfs_trans_t	**tpp,
+	xfs_inode_t	*dp,
 	mode_t		mode,
 	nlink_t		nlink,
 	xfs_dev_t	rdev,
@@ -541,16 +541,18 @@ libxfs_inode_alloc(
 	struct fsxattr	*fsx,
 	xfs_inode_t	**ipp)
 {
-	xfs_buf_t	*ialloc_context;
+	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
-	int		error;
+	xfs_buf_t	*ialloc_context = NULL;
+	int		code;
 
-	ialloc_context = (xfs_buf_t *)0;
-	error = libxfs_ialloc(*tp, pip, mode, nlink, rdev, cr, fsx,
+	tp = *tpp;
+
+	code = libxfs_ialloc(tp, dp, mode, nlink, rdev, cr, fsx,
 			   &ialloc_context, &ip);
-	if (error) {
+	if (code) {
 		*ipp = NULL;
-		return error;
+		return code;
 	}
 	if (!ialloc_context && !ip) {
 		*ipp = NULL;
@@ -559,25 +561,29 @@ libxfs_inode_alloc(
 
 	if (ialloc_context) {
 
-		xfs_trans_bhold(*tp, ialloc_context);
+		xfs_trans_bhold(tp, ialloc_context);
 
-		error = xfs_trans_roll(tp);
-		if (error) {
+		code = xfs_trans_roll(&tp);
+		if (code) {
 			fprintf(stderr, _("%s: cannot duplicate transaction: %s\n"),
-				progname, strerror(error));
+				progname, strerror(code));
 			exit(1);
 		}
-		xfs_trans_bjoin(*tp, ialloc_context);
-		error = libxfs_ialloc(*tp, pip, mode, nlink, rdev, cr,
+		xfs_trans_bjoin(tp, ialloc_context);
+		code = libxfs_ialloc(tp, dp, mode, nlink, rdev, cr,
 				   fsx, &ialloc_context, &ip);
 		if (!ip)
-			error = -ENOSPC;
-		if (error)
-			return error;
+			code = -ENOSPC;
+		if (code) {
+			*tpp = tp;
+			*ipp = NULL;
+			return code;
+		}
 	}
 
 	*ipp = ip;
-	return error;
+	*tpp = tp;
+	return code;
 }
 
 void
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 0fa6ffb0..8439efc4 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -453,7 +453,7 @@ parseproto(
 	case IF_REGULAR:
 		buf = newregfile(pp, &len);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
-		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFREG, 1, 0,
+		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
 					   &creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
@@ -477,7 +477,7 @@ parseproto(
 		}
 		tp = getres(mp, XFS_B_TO_FSB(mp, llen));
 
-		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFREG, 1, 0,
+		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
 					  &creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode pre-allocation failed"), error);
@@ -498,7 +498,7 @@ parseproto(
 		tp = getres(mp, 0);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
-		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFBLK, 1,
+		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFBLK, 1,
 				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
 		if (error) {
 			fail(_("Inode allocation failed"), error);
@@ -513,7 +513,7 @@ parseproto(
 		tp = getres(mp, 0);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
-		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFCHR, 1,
+		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFCHR, 1,
 				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
@@ -525,7 +525,7 @@ parseproto(
 
 	case IF_FIFO:
 		tp = getres(mp, 0);
-		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFIFO, 1, 0,
+		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFIFO, 1, 0,
 				&creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
@@ -537,7 +537,7 @@ parseproto(
 		buf = getstr(pp);
 		len = (int)strlen(buf);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
-		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFLNK, 1, 0,
+		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFLNK, 1, 0,
 				&creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
@@ -548,7 +548,7 @@ parseproto(
 		break;
 	case IF_DIRECTORY:
 		tp = getres(mp, 0);
-		error = -libxfs_inode_alloc(&tp, pip, mode|S_IFDIR, 1, 0,
+		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFDIR, 1, 0,
 				&creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
@@ -640,7 +640,7 @@ rtinit(
 
 	memset(&creds, 0, sizeof(creds));
 	memset(&fsxattrs, 0, sizeof(fsxattrs));
-	error = -libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
+	error = -libxfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
 					&creds, &fsxattrs, &rbmip);
 	if (error) {
 		fail(_("Realtime bitmap inode allocation failed"), error);
@@ -657,7 +657,7 @@ rtinit(
 	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
 	libxfs_log_sb(tp);
 	mp->m_rbmip = rbmip;
-	error = -libxfs_inode_alloc(&tp, NULL, S_IFREG, 1, 0,
+	error = -libxfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
 					&creds, &fsxattrs, &rsumip);
 	if (error) {
 		fail(_("Realtime summary inode allocation failed"), error);
diff --git a/repair/phase6.c b/repair/phase6.c
index 682356f0..f69afac9 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -919,7 +919,7 @@ mk_orphanage(xfs_mount_t *mp)
 		do_error(_("%d - couldn't iget root inode to make %s\n"),
 			i, ORPHANAGE);*/
 
-	error = -libxfs_inode_alloc(&tp, pip, mode|S_IFDIR,
+	error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFDIR,
 					1, 0, &zerocr, &zerofsx, &ip);
 	if (error) {
 		do_error(_("%s inode allocation failed %d\n"),

