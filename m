Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90BA5659FDE
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 01:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbiLaAnl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 19:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235863AbiLaAnk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:43:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F03F1DDE2;
        Fri, 30 Dec 2022 16:43:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10160B81E64;
        Sat, 31 Dec 2022 00:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0818C433D2;
        Sat, 31 Dec 2022 00:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447416;
        bh=dy/KuTYnPHg68gvnNcfCdYdlzMOoGb8xpPsjnMBtGig=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jXP8weDwSmiLiUI4eIbz9p6/Q8dVBj98TCWltjMUMiNRH3HZn+lp1wrf9RpT2TCkh
         dkxJ2t/T81u+bZitf1lDuUH2cxFVoJeHWlHuzvmBPYvbWeeydcHE8McTwzkwJRg3ar
         FhnsX++XizCJn2X9cfqvITJVJKBzIaGKGhn4Y4uA6GW6BqxJP1xKzecnpdLleLyS5+
         Egi3pgeHcYEDQNFF3CPYPtEbhvhZaCrTN3NolbrO6a3T0a04uEet9+Fbqfn52G+ReW
         dN5GdRGqXTWMNwIt7DG+EeqSgUl8RBCpArYxTuOQrm0nL7eKkWAe/sjwunS6IBqtUo
         mDVWg9NeKXVPg==
Subject: [PATCH 1/1] xfs/422: don't freeze while racing rmap repair and
 fsstress
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:33 -0800
Message-ID: <167243877357.728215.3478300804915017773.stgit@magnolia>
In-Reply-To: <167243877345.728215.12907289289488316002.stgit@magnolia>
References: <167243877345.728215.12907289289488316002.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Since we're moving away from freezing the filesystem for rmap repair,
remove the freeze/thaw race from this test to make it more interesting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/422 |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)


diff --git a/tests/xfs/422 b/tests/xfs/422
index 995f612166..339f12976a 100755
--- a/tests/xfs/422
+++ b/tests/xfs/422
@@ -5,8 +5,6 @@
 # FS QA Test No. 422
 #
 # Race fsstress and rmapbt repair for a while to see if we crash or livelock.
-# rmapbt repair requires us to freeze the filesystem to stop all filesystem
-# activity, so we can't have userspace wandering in and thawing it.
 #
 . ./common/preamble
 _begin_fstest online_repair dangerous_fsstress_repair freeze
@@ -31,7 +29,7 @@ _require_xfs_stress_online_repair
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 _require_xfs_has_feature "$SCRATCH_MNT" rmapbt
-_scratch_xfs_stress_online_repair -f -s "repair rmapbt %agno%"
+_scratch_xfs_stress_online_repair -s "repair rmapbt %agno%"
 
 # success, all done
 echo Silence is golden

