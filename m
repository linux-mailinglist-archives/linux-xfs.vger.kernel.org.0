Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D09365A25D
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 04:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbiLaDRU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 22:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236308AbiLaDRT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:17:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6508E2733;
        Fri, 30 Dec 2022 19:17:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D195FCE1AC8;
        Sat, 31 Dec 2022 03:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF83C433EF;
        Sat, 31 Dec 2022 03:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456635;
        bh=G7xPOeOtTzhKoF+UDYQl9xG9HGoTZdfSmnEYnS9i+Ro=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K7VGQfgX7k4flx9kERFzp0ZRijZQZ7/cDaBVFCg/rTdsmIO9vZlWn1BKEjs4qjkhs
         B3m+xarnNqyFCqVRtMCYsLmc7WSDtGgW/sNETsPI2ACPAETDAVempOSwnM+TMDgKew
         IRLbvYzT7vSmnYoTaRPugUI1/ze7OoZSeEIZxfEQISjFpTKmWZj7JT+VkN+6UrjF6U
         GKqVFNwLM0GPXB0gaAhVHKdjcyHXh+exvt3Es8HxH2DQJEYSlN5056fLnrS4SyXKCp
         W2boOe4qxS8HuyZI1Q65BWkGb6nsrTMIoJmdWzAN2BSXBBPmcRts1KweHVALpmPjVy
         MC2PfGLU0YBMw==
Subject: [PATCH 05/10] xfs/243: don't run when realtime storage is the default
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:49 -0800
Message-ID: <167243884919.740253.6143401019263412671.stgit@magnolia>
In-Reply-To: <167243884850.740253.18400210873595872110.stgit@magnolia>
References: <167243884850.740253.18400210873595872110.stgit@magnolia>
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

Realtime volumes don't support delayed allocation, so don't run this
test when the mkfs configuration specifies realtime creation by default.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/243 |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/tests/xfs/243 b/tests/xfs/243
index 514fa35667..dda4a0c223 100755
--- a/tests/xfs/243
+++ b/tests/xfs/243
@@ -38,6 +38,11 @@ echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
+# XFS does not support delayed allocation on realtime volumes (even for COW)
+# so skip this test on those platforms.
+$XFS_IO_PROG -c 'stat -v' $SCRATCH_MNT | grep -q "xflags.*rt-inherit" &&
+	_notrun "delalloc not used for CoW on realtime device"
+
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 

