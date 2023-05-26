Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A96711BA9
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 02:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232645AbjEZAuf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 20:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234276AbjEZAue (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:50:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66224194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:50:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01C41619B3
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652C9C433D2;
        Fri, 26 May 2023 00:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062232;
        bh=Sk+ejEFgsDvaJNjTMFzfFxnbsE4V49eDI+gvIIuuSuw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jwyZKk111ot67MeecRvaEyogzKLod+VDbyi8W9gbdFT3HWJ7IAIPL34KWJxImYon7
         YSO44TxonHKsfGfyGwW0bIIiZEf3UVEhexXU6uTfY8n8AZFImGCL5icUN/nrvz+zcV
         P0gPN/Fv31ICK3rJRQT3aiGEbJ9upQZWIrvhkjCSCgeC8h690uyi5vedIddixYwua8
         Uw1KiZr7q/4a5pXg7whb85/DkN03yuuSWW3z03HmP9ALzp4XFXUj7SqCGXC5Zb821y
         44MDYKjfA7BMo2COIkpldKY4yYGLxDnJgl2tC2JaaEGNgA/6Js0MRZNZlcsmXSnuN8
         JjWMkAT8VNJzw==
Date:   Thu, 25 May 2023 17:50:32 -0700
Subject: [PATCH 1/2] xfs: don't complain about unfixed metadata when repairs
 were injected
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506057586.3730125.4038312178702711237.stgit@frogsfrogsfrogs>
In-Reply-To: <168506057570.3730125.9735079571472245559.stgit@frogsfrogsfrogs>
References: <168506057570.3730125.9735079571472245559.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While debugging other parts of online repair, I noticed that if someone
injects FORCE_SCRUB_REPAIR, starts an IFLAG_REPAIR scrub on a piece of
metadata, and the metadata repair fails, we'll log a message about
uncorrected errors in the filesystem.

This isn't strictly true if the scrub function didn't set OFLAG_CORRUPT
and we're only doing the repair because the error injection knob is set.
Repair functions are allowed to abort the entire operation at any point
before committing new metadata, in which case the piece of metadata is
in the same state as it was before.  Therefore, the log message should
be gated on the results of the scrub.  Refactor the predicate and
rearrange the code flow to make this happen.

Note: If the repair function errors out after it commits the new
metadata, the transaction cancellation will shut down the filesystem,
which is an obvious sign of corrupt metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.h |   12 ++++++++++++
 fs/xfs/scrub/scrub.c  |    7 ++-----
 2 files changed, 14 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index d553871752e4..fdd286607f62 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -167,6 +167,18 @@ static inline bool xchk_skip_xref(struct xfs_scrub_metadata *sm)
 			       XFS_SCRUB_OFLAG_XCORRUPT);
 }
 
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+/* Decide if a repair is required. */
+static inline bool xchk_needs_repair(const struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+			       XFS_SCRUB_OFLAG_XCORRUPT |
+			       XFS_SCRUB_OFLAG_PREEN);
+}
+#else
+# define xchk_needs_repair(sc)		(false)
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
+
 int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 
 /*
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 1b2692d8061f..8960053b6ae5 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -532,15 +532,12 @@ xfs_scrub_metadata(
 
 	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
 	    !(sc->flags & XREP_ALREADY_FIXED)) {
-		bool needs_fix;
+		bool needs_fix = xchk_needs_repair(sc->sm);
 
 		/* Let debug users force us into the repair routines. */
 		if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
-			sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+			needs_fix = true;
 
-		needs_fix = (sc->sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
-						 XFS_SCRUB_OFLAG_XCORRUPT |
-						 XFS_SCRUB_OFLAG_PREEN));
 		/*
 		 * If userspace asked for a repair but it wasn't necessary,
 		 * report that back to userspace.

