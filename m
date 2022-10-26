Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C888E60E9E5
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Oct 2022 22:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbiJZUIA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Oct 2022 16:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234650AbiJZUHs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 16:07:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FDE1382FF
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 13:07:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01DB2B82441
        for <linux-xfs@vger.kernel.org>; Wed, 26 Oct 2022 20:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2F9C433C1;
        Wed, 26 Oct 2022 20:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666814864;
        bh=PUH2/i1M4HktmjbTJ1yTzVSEL8HOCOiQK47bcLR8ZXI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Hy7+1FHoJHeE9INuWWcK0l7R6FKKavXSDPgyz7ucb79ICTa+6esWA2p5nYqJswnSA
         vo3ABnY3bBjMLobrNWEoLrLGP3sdpKNpCB+1EWMi8lb36tGTH3DMBFJck3V6guGI0h
         9m3KZKhUL4rYkYw8TVaVm19v/AzeYt2wViRd2wOZ3WDtXhiTLuRWkxgtVpA4zy9DpY
         36ebWfbUeIN/j36c2bQ+eHsE+LTMu+L08h6XTnv3GUSfJW2R4lDWby1I4IMhugZtdi
         gVBTA+9BZr9t41NTuX/eXHTPRiKKxV63n8W1DoBFZbLGhfimIph1Lih5HXYzQH8/Wv
         pZ8nabPH1gUEA==
Subject: [PATCH 2/8] xfs: fix memcpy fortify errors in BUI log format copying
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, allison.henderson@oracle.com
Date:   Wed, 26 Oct 2022 13:07:44 -0700
Message-ID: <166681486418.3447519.16567587633857559412.stgit@magnolia>
In-Reply-To: <166681485271.3447519.6520343630713202644.stgit@magnolia>
References: <166681485271.3447519.6520343630713202644.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Starting in 6.1, CONFIG_FORTIFY_SOURCE checks the length parameter of
memcpy.  Unfortunately, it doesn't handle flex arrays correctly:

------------[ cut here ]------------
memcpy: detected field-spanning write (size 48) of single field "dst_bui_fmt" at fs/xfs/xfs_bmap_item.c:628 (size 16)

Fix this by refactoring the xfs_bui_copy_format function to handle the
copying of the head and the flex array members separately.  While we're
at it, fix a minor validation deficiency in the recovery function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_item.c |   46 ++++++++++++++++++++++------------------------
 fs/xfs/xfs_ondisk.h    |    5 +++++
 2 files changed, 27 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 51f66e982484..a1da6205252b 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -608,28 +608,18 @@ static const struct xfs_item_ops xfs_bui_item_ops = {
 	.iop_relog	= xfs_bui_item_relog,
 };
 
-/*
- * Copy an BUI format buffer from the given buf, and into the destination
- * BUI format structure.  The BUI/BUD items were designed not to need any
- * special alignment handling.
- */
-static int
+static inline void
 xfs_bui_copy_format(
-	struct xfs_log_iovec		*buf,
-	struct xfs_bui_log_format	*dst_bui_fmt)
+	struct xfs_bui_log_format	*dst,
+	const struct xfs_bui_log_format	*src)
 {
-	struct xfs_bui_log_format	*src_bui_fmt;
-	uint				len;
+	unsigned int			i;
 
-	src_bui_fmt = buf->i_addr;
-	len = xfs_bui_log_format_sizeof(src_bui_fmt->bui_nextents);
+	memcpy(dst, src, offsetof(struct xfs_bui_log_format, bui_extents));
 
-	if (buf->i_len == len) {
-		memcpy(dst_bui_fmt, src_bui_fmt, len);
-		return 0;
-	}
-	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
-	return -EFSCORRUPTED;
+	for (i = 0; i < src->bui_nextents; i++)
+		memcpy(&dst->bui_extents[i], &src->bui_extents[i],
+				sizeof(struct xfs_map_extent));
 }
 
 /*
@@ -646,23 +636,31 @@ xlog_recover_bui_commit_pass2(
 	struct xlog_recover_item	*item,
 	xfs_lsn_t			lsn)
 {
-	int				error;
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_bui_log_item		*buip;
 	struct xfs_bui_log_format	*bui_formatp;
+	size_t				len;
 
 	bui_formatp = item->ri_buf[0].i_addr;
 
+	if (item->ri_buf[0].i_len < xfs_bui_log_format_sizeof(0)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+
 	if (bui_formatp->bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 		return -EFSCORRUPTED;
 	}
+
+	len = xfs_bui_log_format_sizeof(bui_formatp->bui_nextents);
+	if (item->ri_buf[0].i_len != len) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+
 	buip = xfs_bui_init(mp);
-	error = xfs_bui_copy_format(&item->ri_buf[0], &buip->bui_format);
-	if (error) {
-		xfs_bui_item_free(buip);
-		return error;
-	}
+	xfs_bui_copy_format(&buip->bui_format, bui_formatp);
 	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
 	/*
 	 * Insert the intent into the AIL directly and drop one reference so
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 758702b9495f..56917e236370 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -134,6 +134,11 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bui_log_format,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bud_log_format,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_map_extent,		32);
+
+	XFS_CHECK_OFFSET(struct xfs_bui_log_format, bui_extents,	16);
 
 	/*
 	 * The v5 superblock format extended several v4 header structures with

