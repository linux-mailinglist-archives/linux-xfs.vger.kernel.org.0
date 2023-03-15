Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC216BA463
	for <lists+linux-xfs@lfdr.de>; Wed, 15 Mar 2023 01:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjCOAxq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Mar 2023 20:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCOAxq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 20:53:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B1521965;
        Tue, 14 Mar 2023 17:53:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F119B61A8A;
        Wed, 15 Mar 2023 00:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E2AC433D2;
        Wed, 15 Mar 2023 00:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678841624;
        bh=Fp0knP7QNKI+B0t53gTOPPfHszUwTpIapZtTyIFU/yw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SatWer3XH4Q843ndVWlxz5oQBJxuSShsyMUDKhg15vEfk1abBAlidF7vi8PWgmAPb
         vzIyzJ+LCX/emFu0RZGUKHTt2ziffTYNqfSzDtLIb6yw9sjfy3Jp6cGOPh2RLtE3Da
         EOlo4e69DMw0nEzdwStIQGv3cHE0BW6U/wTdzJMUPd3ab8w1XyYA4tOZQwG+SyhEGO
         OZqAoBL+hjnbvnJ+PNOE/+I7Zyu1HhJIpSaSsSr2rDeBoHnOS4Zssb61LBRkMAUEK8
         bw0WYMtZr/2BIvWowyvllIZyuymtPeJWscBmv7XXMjC0Y1bGvA347EF0T3ANfoHGmg
         aju++36eCogPA==
Subject: [PATCH 13/15] report: record xfs-specific information about a test
 run
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Mar 2023 17:53:43 -0700
Message-ID: <167884162396.2482843.6834126356123933920.stgit@magnolia>
In-Reply-To: <167884155064.2482843.4310780034948240980.stgit@magnolia>
References: <167884155064.2482843.4310780034948240980.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Report various XFS-specific information about a test run.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/report |    3 +++
 common/xfs    |   11 +++++++++++
 2 files changed, 14 insertions(+)


diff --git a/common/report b/common/report
index af3c04db56..86274af887 100644
--- a/common/report
+++ b/common/report
@@ -64,6 +64,9 @@ __generate_report_vars() {
 	__generate_blockdev_report_vars "TEST_DEV"
 	__generate_blockdev_report_vars "SCRATCH_DEV"
 
+	# Add per-filesystem variables to the report variable list
+	test "$FSTYP" = "xfs" && __generate_xfs_report_vars
+
 	# Optional environmental variables
 	for varname in "${REPORT_ENV_LIST_OPT[@]}"; do
 		test -n "${!varname}" && REPORT_VARS["${varname}"]="${!varname}"
diff --git a/common/xfs b/common/xfs
index e679af824f..e8e4832cea 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2,6 +2,17 @@
 # XFS specific common functions.
 #
 
+__generate_xfs_report_vars() {
+	__generate_blockdev_report_vars TEST_RTDEV
+	__generate_blockdev_report_vars TEST_LOGDEV
+	__generate_blockdev_report_vars SCRATCH_RTDEV
+	__generate_blockdev_report_vars SCRATCH_LOGDEV
+
+	REPORT_VARS["XFS_ALWAYS_COW"]="$(cat /sys/fs/xfs/debug/always_cow 2>/dev/null)"
+	REPORT_VARS["XFS_LARP"]="$(cat /sys/fs/xfs/debug/larp 2>/dev/null)"
+	REPORT_ENV_LIST_OPT+=("TEST_XFS_REPAIR_REBUILD" "TEST_XFS_SCRUB_REBUILD")
+}
+
 _setup_large_xfs_fs()
 {
 	fs_size=$1

