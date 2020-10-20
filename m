Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8A428FCF5
	for <lists+linux-xfs@lfdr.de>; Fri, 16 Oct 2020 05:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394242AbgJPDih (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 23:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394231AbgJPDih (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 23:38:37 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B80C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 20:38:37 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a1so667706pjd.1
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 20:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ldjkKG1ze1tFvfs/m9SjKWky0rdNAEa4EkGCpDfMVbs=;
        b=T7tV4VCuYTImcNd3JI8aqFx1jErLp6m0PC8lqxumhtr300piMAAyKY1qtDHKGikEgR
         eLmwxuJRaVfKeSYW0EJUqypZaNjaAuKVuYZegNYXSJVORE40ceQD+tbri0WCXGFz5b5s
         +pUH9kZbhA7RQ26sIFlBKFp9gUa9g8cdKMn3HyqaBjVJ1R+C0qn3qBFDD96oCsa9QtOd
         WFptyGqbeTqF0q83SgNOdXf4T5E4EULNuNTHDFfapFBejcQF6KbP8dGBn1HyIs9DblHS
         qH/975hLqNDRFsS6KnapomICUC7GjqOCBgsoZjiHTkrtZjH+U2B3QcSenvjkBVgmQlWk
         eVGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ldjkKG1ze1tFvfs/m9SjKWky0rdNAEa4EkGCpDfMVbs=;
        b=Lb3yI8VzGjs/WtQrIopIXtLniJh0NwK0tgXrzuEblUE6I11PPv6/PoIMdRpOVz6ff0
         SsL3kiTNFu9zJ8/14enqlJaegVe8eGL2rhZ0xFmbmQcz0D6qtByI8VszAklGnIiqo5Sl
         R5J+k8Mtj644j9nODHGdVch8QM2ss7uFSxFzNg2m5bpsep9AFU+fHtl/3m+y20kg+8u1
         SKvAj2CeTVsrjaM4AE1FxwxUSXD1sdQj433NSQTt5ypvePphvy2OO7A9UwHdoxLt9kk+
         yjCg+Hj4w2kPvqI6RpnFYNrSip7zjM9NHSf8/zAdHLtC6GRNMVJmUkQFxJPHboC1nEQH
         Tnlg==
X-Gm-Message-State: AOAM530IgmCvDBD0MA72+mUZRZJNHoHc3Iqcbjo7qIGwr0E39hp+iBGg
        XxGZsedo3dyNI2C/J06rxQ3xOS83mw==
X-Google-Smtp-Source: ABdhPJw3XL6tcHvtV7E4kABWVLiIKk3eACF/yVlkSdaQNCunVcgw+bTr4zNcx14dBQO5zd/57Q6AxA==
X-Received: by 2002:a17:90b:1496:: with SMTP id js22mr1991756pjb.20.1602819516874;
        Thu, 15 Oct 2020 20:38:36 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id o15sm890238pfp.91.2020.10.15.20.38.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2020 20:38:36 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH v6 2/3] xfs: check tp->t_dqinfo value instead of the XFS_TRANS_DQ_DIRTY flag
Date:   Fri, 16 Oct 2020 11:38:27 +0800
Message-Id: <1602819508-29033-3-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1602819508-29033-1-git-send-email-kaixuxia@tencent.com>
References: <1602819508-29033-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Nowadays the only things that the XFS_TRANS_DQ_DIRTY flag seems to do
are indicates the tp->t_dqinfo->dqs[XFS_QM_TRANS_{USR,GRP,PRJ}] values
changed and check in xfs_trans_apply_dquot_deltas() and the unreserve
variant xfs_trans_unreserve_and_mod_dquots(). Actually, we also can
use the tp->t_dqinfo value instead of the XFS_TRANS_DQ_DIRTY flag, that
is to say, we allocate the new tp->t_dqinfo only when the qtrx values
changed, so the tp->t_dqinfo value isn't NULL equals the XFS_TRANS_DQ_DIRTY
flag is set, we only need to check if tp->t_dqinfo == NULL in
xfs_trans_apply_dquot_deltas() and its unreserve variant to determine
whether lock all of the dquots and join them to the transaction.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_shared.h |  1 -
 fs/xfs/xfs_inode.c         |  8 +-------
 fs/xfs/xfs_trans_dquot.c   | 13 ++-----------
 3 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c795ae47b3c9..8c61a461bf7b 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -62,7 +62,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
 #define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
 #define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
-#define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
 #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
 #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
 #define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 20bb5fae0d00..16885624015e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -959,7 +959,6 @@ xfs_dir_ialloc(
 	xfs_buf_t	*ialloc_context = NULL;
 	int		code;
 	void		*dqinfo;
-	uint		tflags;
 
 	tp = *tpp;
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -1018,12 +1017,9 @@ xfs_dir_ialloc(
 		 * and attach it to the next transaction.
 		 */
 		dqinfo = NULL;
-		tflags = 0;
 		if (tp->t_dqinfo) {
 			dqinfo = (void *)tp->t_dqinfo;
 			tp->t_dqinfo = NULL;
-			tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
-			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
 		}
 
 		code = xfs_trans_roll(&tp);
@@ -1031,10 +1027,8 @@ xfs_dir_ialloc(
 		/*
 		 * Re-attach the quota info that we detached from prev trx.
 		 */
-		if (dqinfo) {
+		if (dqinfo)
 			tp->t_dqinfo = dqinfo;
-			tp->t_flags |= tflags;
-		}
 
 		if (code) {
 			xfs_buf_relse(ialloc_context);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 67f1e275b34d..0ebfd7930382 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -84,13 +84,6 @@ xfs_trans_dup_dqinfo(
 
 	xfs_trans_alloc_dqinfo(ntp);
 
-	/*
-	 * Because the quota blk reservation is carried forward,
-	 * it is also necessary to carry forward the DQ_DIRTY flag.
-	 */
-	if (otp->t_flags & XFS_TRANS_DQ_DIRTY)
-		ntp->t_flags |= XFS_TRANS_DQ_DIRTY;
-
 	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
 		oqa = otp->t_dqinfo->dqs[j];
 		nqa = ntp->t_dqinfo->dqs[j];
@@ -270,8 +263,6 @@ xfs_trans_mod_dquot(
 
 	if (delta)
 		trace_xfs_trans_mod_dquot_after(qtrx);
-
-	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
 }
 
 
@@ -348,7 +339,7 @@ xfs_trans_apply_dquot_deltas(
 	int64_t			totalbdelta;
 	int64_t			totalrtbdelta;
 
-	if (!(tp->t_flags & XFS_TRANS_DQ_DIRTY))
+	if (!tp->t_dqinfo)
 		return;
 
 	ASSERT(tp->t_dqinfo);
@@ -490,7 +481,7 @@ xfs_trans_unreserve_and_mod_dquots(
 	struct xfs_dqtrx	*qtrx, *qa;
 	bool			locked;
 
-	if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
+	if (!tp->t_dqinfo)
 		return;
 
 	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
-- 
2.20.0

