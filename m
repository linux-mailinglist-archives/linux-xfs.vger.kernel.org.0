Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CFE6BA464
	for <lists+linux-xfs@lfdr.de>; Wed, 15 Mar 2023 01:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjCOAxx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Mar 2023 20:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjCOAxv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 20:53:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F22D21965;
        Tue, 14 Mar 2023 17:53:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3BBC61A8D;
        Wed, 15 Mar 2023 00:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0807EC433EF;
        Wed, 15 Mar 2023 00:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678841630;
        bh=PFtlph1E4q/CEQjbKuStRk3Cq9HLNkxvt+LC4KuoBDE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K48q+ewv/vub02KBQUctnCs+91xP5AuKG//Ppyp7HujkKpet5i1NBCef+zmRqBYMR
         c/MAxWZAFBX4B2by9EhbDwfBxvspDvWZ4h7sslm3/LY8eFITxKv7V7WSRtVqzCkn7l
         k+OkJp3eY7q7Cl8QiJczdLDVRPrqCQmbAyJKOQa4oMH0rOZ+Y1ZzzKsRFf5ayG04DD
         FulE6V0lZRWAFRRYm6i7E/B385LFSZU593ibp2EmcIflVpP7vX/ZA7ie9Hsm+kn7jN
         +vxEyn0vu3SCUpNVOEsddcb39SJxpMYEPpVRvwzXZVsJdO7zY2l8m9KBrg4VpfSmDp
         0S5UqGbFhZQUA==
Subject: [PATCH 14/15] report: record ext*-specific information about a test
 run
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Mar 2023 17:53:49 -0700
Message-ID: <167884162954.2482843.191249534178669922.stgit@magnolia>
In-Reply-To: <167884155064.2482843.4310780034948240980.stgit@magnolia>
References: <167884155064.2482843.4310780034948240980.stgit@magnolia>
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

Report various ext* specific information about a test run.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/ext4   |    5 +++++
 common/report |    1 +
 2 files changed, 6 insertions(+)


diff --git a/common/ext4 b/common/ext4
index 8fd6dbc682..3dcbfe17c9 100644
--- a/common/ext4
+++ b/common/ext4
@@ -2,6 +2,11 @@
 # ext4 specific common functions
 #
 
+__generate_ext4_report_vars() {
+	__generate_blockdev_report_vars TEST_LOGDEV
+	__generate_blockdev_report_vars SCRATCH_LOGDEV
+}
+
 _setup_large_ext4_fs()
 {
 	local fs_size=$1
diff --git a/common/report b/common/report
index 86274af887..db15aec54f 100644
--- a/common/report
+++ b/common/report
@@ -66,6 +66,7 @@ __generate_report_vars() {
 
 	# Add per-filesystem variables to the report variable list
 	test "$FSTYP" = "xfs" && __generate_xfs_report_vars
+	[[ "$FSTYP" == ext[0-9]* ]] && __generate_ext4_report_vars
 
 	# Optional environmental variables
 	for varname in "${REPORT_ENV_LIST_OPT[@]}"; do

