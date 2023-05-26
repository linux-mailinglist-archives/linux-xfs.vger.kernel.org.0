Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE714711BB7
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 02:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbjEZAwY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 20:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbjEZAwY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:52:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0515195
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:52:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63FBD61A5C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D2DC433D2;
        Fri, 26 May 2023 00:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062341;
        bh=Y3Ic77UXT/+yFmYjM0771XeCdqPlqbKyzxpM12c/99c=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=WFKCR2gUiwrSDmezTqYLovKt3a8eHEubjqnK0gXQ1z3KCDGS66NeBAAM08yECm+fd
         HCx40OdYz+vhi9JqdnRRf3MAKwQO5c7vM0GMwVET4uA1m8S4AKihOU5k405iqoZQDf
         jL0/4fLRCcyJ38kICjBrFToEMeF+0fFU31FrVyHgy8irkgt1BvS8t3ujCqmk1/HsU2
         GVy7lvVR4u497l4zX+PWT3WcLioHpmkhxlf97SzMq9vVH3qkSvnomWftYsL+twRMeb
         5D8oELu8UyPzqASM65WHQ0O8z+EBq4r54E+fXqJWPVxtxC+hTWcTP2c37T7HW87qby
         r/0Ig2C0DIlrw==
Date:   Thu, 25 May 2023 17:52:21 -0700
Subject: [PATCH 1/6] xfs: disable online repair quota helpers when quota not
 enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506058323.3730405.11122490227553603688.stgit@frogsfrogsfrogs>
In-Reply-To: <168506058301.3730405.12262241466147528228.stgit@frogsfrogsfrogs>
References: <168506058301.3730405.12262241466147528228.stgit@frogsfrogsfrogs>
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

Don't compile the quota helper functions if quota isn't being built into
the XFS module.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c |    2 ++
 fs/xfs/scrub/repair.h |    9 +++++++++
 2 files changed, 11 insertions(+)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 4c95ad35a992..1d614dafb729 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -674,6 +674,7 @@ xrep_find_ag_btree_roots(
 	return error;
 }
 
+#ifdef CONFIG_XFS_QUOTA
 /* Force a quotacheck the next time we mount. */
 void
 xrep_force_quotacheck(
@@ -735,6 +736,7 @@ xrep_ino_dqattach(
 
 	return error;
 }
+#endif /* CONFIG_XFS_QUOTA */
 
 /* Initialize all the btree cursors for an AG repair. */
 void
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index bb8afee297cb..a4b6b2a3846b 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -48,8 +48,15 @@ struct xrep_find_ag_btree {
 
 int xrep_find_ag_btree_roots(struct xfs_scrub *sc, struct xfs_buf *agf_bp,
 		struct xrep_find_ag_btree *btree_info, struct xfs_buf *agfl_bp);
+
+#ifdef CONFIG_XFS_QUOTA
 void xrep_force_quotacheck(struct xfs_scrub *sc, xfs_dqtype_t type);
 int xrep_ino_dqattach(struct xfs_scrub *sc);
+#else
+# define xrep_force_quotacheck(sc, type)	((void)0)
+# define xrep_ino_dqattach(sc)			(0)
+#endif /* CONFIG_XFS_QUOTA */
+
 int xrep_reset_perag_resv(struct xfs_scrub *sc);
 
 /* Repair setup functions */
@@ -78,6 +85,8 @@ int xrep_reinit_pagi(struct xfs_scrub *sc);
 
 #else
 
+#define xrep_ino_dqattach(sc)	(0)
+
 static inline int
 xrep_attempt(
 	struct xfs_scrub	*sc)

