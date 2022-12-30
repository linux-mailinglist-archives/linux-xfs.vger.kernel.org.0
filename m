Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84F965A15C
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 03:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbiLaCQz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 21:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236208AbiLaCQx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:16:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC7E13F62
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:16:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DFE3B81E52
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68451C433EF;
        Sat, 31 Dec 2022 02:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453009;
        bh=vMLZ+LkznQWz9EJZ/wEbgjkVPEuFX0uUH5rKt9wLLcE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dP14No+wUnjp8VZsq8FGFFI2d2DEJ9V/nuKk4Xq1DX4G933TeN2ryPLFQPU/ZhXJb
         hP7BD2YFgz08yRo0TMKUNLWkagw9VqXhWBH1YfhCJdbhE+m8qImuJ/Qq1p2mmthnTl
         NvBZ98LIWWMhfQUVLdhSWFC6b4GMpMPyRZIU+LKz5DgbTP13OgEwu+k8DBSQSzjk5O
         JRuMJk0a6J7Mh2PVh8th1evFWf/nlx1VboM2TnyhFsCINQx72BTxKW5rnWBqI7GCgC
         sh5/MKa+ofb0ueO9JyN6YQiAFxXXVj6gfiHiOxQl2l1VCoPdwb3Eobip0Kt+gozqPj
         ligfOfqrECybw==
Subject: [PATCH 27/46] xfs_repair: don't zero the incore secondary super when
 zeroing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:22 -0800
Message-ID: <167243876290.725900.6119990293600549448.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
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

If secondary_sb_whack detects nonzero bytes beyond the end of the ondisk
superblock, it will try to zero the end of the ondisk buffer as well as
the incore superblock prior to scan_ag using that incore super to
rewrite the ondisk super.

However, the metadata directory feature adds a sb_metadirino field to
the incore super.  On disk, this is stored in the same slot as
sb_rbmino, but we wanted to cache both inumbers incore to minimize the
churn.  Therefore, it is now only safe to zero the "end" of an xfs_dsb
buffer, and never an xfs_sb object.

Most of the XFS codebase moved off that second behavior long ago, with
the exception of this one part of repair.  The zeroing probably ought to
be turned into explicit logic to zero fields that weren't defined with
the featureset encoded in the primary superblock, but for now we'll
resort to always resetting the values from the xfs_mount's xfs_sb.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/agheader.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/repair/agheader.c b/repair/agheader.c
index 3930a0ac091..af88802ffdf 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -405,6 +405,13 @@ secondary_sb_whack(
 				mp->m_sb.sb_sectsize - size);
 			/* Preserve meta_uuid so we don't fail uuid checks */
 			memcpy(&sb->sb_meta_uuid, &tmpuuid, sizeof(uuid_t));
+
+			/*
+			 * Preserve the parts of the incore super that extend
+			 * beyond the part that's supposed to match the ondisk
+			 * super byte for byte.
+			 */
+			sb->sb_metadirino = mp->m_sb.sb_metadirino;
 		} else
 			do_warn(
 	_("would zero unused portion of %s superblock (AG #%u)\n"),

