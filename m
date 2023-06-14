Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADD3711D0C
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 03:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbjEZBsX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 21:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjEZBsU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:48:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FBC18D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8256760B6C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EA8C433EF;
        Fri, 26 May 2023 01:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065698;
        bh=SE+I4fqkekP63F+dYA/ltK8wmLGm7Ge3c8Ranpf/U98=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=CReKMIQo4sAPGaRsoAw8r8q2huEjI5BMA8mZ4Cgdg0Qq1XJOPwu2rz1W2KMyLbH5i
         v3zCv2iOj8RIKroExlbG649fvEwhR2HKAEROLI3nfcjL//OFBH/VrHLMQ4QwPQtquh
         OAeYx/8hiQhjjHKnSTwtYCkuJNkpBkdHGSEEbFPSCb67L0GNleaJI5ngq/vhbeK4HR
         si168cIvH7Y+x8e+xG81hvJCBJ3WVKgMsDwmmhGGa1VDGD/awSpZ3i5yacd+lhDyVu
         /AU7bHlmUC+7V0qrSFFe/BZWxUUj/CJaEBTG2RRfcA48Oblr6b5/SIv6sz8ZrRP2aA
         tJ+F77Kx9SeCQ==
Date:   Thu, 25 May 2023 18:48:17 -0700
Subject: [PATCH 3/4] xfs_scrub: recheck entire metadata objects after
 corruption repairs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506072792.3744428.13295410202659476156.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072752.3744428.6237393655315422413.stgit@frogsfrogsfrogs>
References: <168506072752.3744428.6237393655315422413.stgit@frogsfrogsfrogs>
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

When we've finished making repairs to some domain of filesystem metadata
(file, AG, etc.) to correct an inconsistency, we should recheck all the
other metadata types within that domain to make sure that we neither
made things worse nor introduced more cross-referencing problems.  If we
did, requeue the item to make the repairs.  If the only changes we made
were optimizations, don't bother.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c        |   37 +++++++++++++++++++++++++++++++++++++
 scrub/scrub.c         |    5 +++--
 scrub/scrub.h         |   10 ++++++++++
 scrub/scrub_private.h |    2 ++
 4 files changed, 52 insertions(+), 2 deletions(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index b1395275160..079a9edf77e 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -485,8 +485,10 @@ action_item_try_repair(
 {
 	struct scrub_item	*sri = &aitem->sri;
 	unsigned int		before, after;
+	unsigned int		scrub_type;
 	int			ret;
 
+	BUILD_BUG_ON(sizeof(sri->sri_selected) * NBBY < XFS_SCRUB_TYPE_NR);
 	before = repair_item_count_needsrepair(sri);
 
 	ret = repair_item(ctx, sri, 0);
@@ -507,6 +509,41 @@ action_item_try_repair(
 		return 0;
 	}
 
+	/*
+	 * Nothing in this fs object was marked inconsistent.  This means we
+	 * were merely optimizing metadata and there is no revalidation work to
+	 * be done.
+	 */
+	if (!sri->sri_inconsistent) {
+		*outcome = TR_REPAIRED;
+		return 0;
+	}
+
+	/*
+	 * We fixed inconsistent metadata, so reschedule the entire object for
+	 * immediate revalidation to see if anything else went wrong.
+	 */
+	foreach_scrub_type(scrub_type)
+		if (sri->sri_selected & (1U << scrub_type))
+			sri->sri_state[scrub_type] = SCRUB_ITEM_NEEDSCHECK;
+	sri->sri_inconsistent = false;
+	sri->sri_revalidate = true;
+
+	ret = scrub_item_check(ctx, sri);
+	if (ret)
+		return ret;
+
+	after = repair_item_count_needsrepair(sri);
+	if (after > 0) {
+		/*
+		 * Uhoh, we found something else broken.  Tell the caller that
+		 * this item needs to be queued for more repairs.
+		 */
+		sri->sri_revalidate = false;
+		*outcome = TR_REQUEUE;
+		return 0;
+	}
+
 	/* Repairs complete. */
 	*outcome = TR_REPAIRED;
 	return 0;
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 8ceafc36af7..0227da5a926 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -117,11 +117,12 @@ xfs_check_metadata(
 	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta.sm_flags);
 
 	error = -xfrog_scrub_metadata(xfdp, &meta);
-	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
-		meta.sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 	switch (error) {
 	case 0:
 		/* No operational errors encountered. */
+		if (!sri->sri_revalidate &&
+		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
+			meta.sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 		break;
 	case ENOENT:
 		/* Metadata not present, just skip it. */
diff --git a/scrub/scrub.h b/scrub/scrub.h
index b3d2f824bd1..0da45fb5dc6 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -59,11 +59,20 @@ struct scrub_item {
 	__u32			sri_gen;
 	__u32			sri_agno;
 
+	/* Bitmask of scrub types that were scheduled here. */
+	__u32			sri_selected;
+
 	/* Scrub item state flags, one for each XFS_SCRUB_TYPE. */
 	__u8			sri_state[XFS_SCRUB_TYPE_NR];
 
 	/* Track scrub and repair call retries for each scrub type. */
 	__u8			sri_tries[XFS_SCRUB_TYPE_NR];
+
+	/* Were there any corruption repairs needed? */
+	bool			sri_inconsistent:1;
+
+	/* Are we revalidating after repairs? */
+	bool			sri_revalidate:1;
 };
 
 #define foreach_scrub_type(loopvar) \
@@ -103,6 +112,7 @@ static inline void
 scrub_item_schedule(struct scrub_item *sri, unsigned int scrub_type)
 {
 	sri->sri_state[scrub_type] = SCRUB_ITEM_NEEDSCHECK;
+	sri->sri_selected |= (1U << scrub_type);
 }
 
 void scrub_item_schedule_group(struct scrub_item *sri,
diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
index 1baded653f7..92bc0afc4f1 100644
--- a/scrub/scrub_private.h
+++ b/scrub/scrub_private.h
@@ -71,6 +71,8 @@ scrub_item_save_state(
 	unsigned  int			scrub_flags)
 {
 	sri->sri_state[scrub_type] = scrub_flags & SCRUB_ITEM_REPAIR_ANY;
+	if (scrub_flags & SCRUB_ITEM_NEEDSREPAIR)
+		sri->sri_inconsistent = true;
 }
 
 static inline void

