Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE9665A0DA
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 02:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbiLaBoL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 20:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbiLaBoK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:44:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D420E13DEA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:44:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FC1261C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9E8C433D2;
        Sat, 31 Dec 2022 01:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451048;
        bh=xyAT8fRrcvBW//Zb3kpyyOz5rDYwvjEkvApzxSzjygM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vAimfpzmZWC3YlU4uxyL393TO6Cjk5Lu12GzIKLlbUqRwQL9YWlxP3CLOSsbJSWKJ
         GxFOP/KKteHGVvTivckHK1Frz+cCdicZXwF6ZA8+1oliqK5Af/Q7LXpAKXUmfBQGGB
         8SfaPkp/6u58VxO/rHjuY2rNQ/wqfMY658XXdYI4lrytQra3VHQXL2KuwpsQAfTGm1
         F2G2/Ab5+45k90o+G3AThG6ik/M301lsPgFrOl7Iom/6Qbfsj9f6iT42ogmmBLKNVE
         qDd8KbaopmC9QPjPSU25zUohfPCPMCIgsAitaqfrLz5OCT4jaHl7/Z0xfSeFvTDzWu
         u2AD/Bth8JS7g==
Subject: [PATCH 28/38] xfs: cross-reference realtime bitmap to realtime rmapbt
 scrubber
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:20 -0800
Message-ID: <167243870001.715303.15509002147839052353.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're checking the realtime rmap btree entries, cross-reference
those entries with the realtime bitmap too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rtrmap.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)


diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index e60b454b39f3..72fc47cc25f0 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -150,6 +150,23 @@ xchk_rtrmapbt_check_mergeable(
 	memcpy(&cr->prev_rec, irec, sizeof(struct xfs_rmap_irec));
 }
 
+/* Cross-reference with other metadata. */
+STATIC void
+xchk_rtrmapbt_xref(
+	struct xfs_scrub	*sc,
+	struct xfs_rmap_irec	*irec)
+{
+	xfs_rtblock_t		rtbno;
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	rtbno = xfs_rgbno_to_rtb(sc->mp, sc->sr.rtg->rtg_rgno,
+			irec->rm_startblock);
+
+	xchk_xref_is_used_rt_space(sc, rtbno, irec->rm_blockcount);
+}
+
 /* Scrub a realtime rmapbt record. */
 STATIC int
 xchk_rtrmapbt_rec(
@@ -170,6 +187,7 @@ xchk_rtrmapbt_rec(
 
 	xchk_rtrmapbt_check_mergeable(bs, cr, &irec);
 	xchk_rtrmapbt_check_overlapping(bs, cr, &irec);
+	xchk_rtrmapbt_xref(bs->sc, &irec);
 	return 0;
 }
 

