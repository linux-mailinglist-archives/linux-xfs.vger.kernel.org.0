Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D1F7231F2
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Jun 2023 23:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjFEVLi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 5 Jun 2023 17:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjFEVLi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 17:11:38 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2CC94ED;
        Mon,  5 Jun 2023 14:11:36 -0700 (PDT)
Received: by sandeen.net (Postfix, from userid 500)
        id 930C448C71A; Mon,  5 Jun 2023 16:11:35 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH V2] mkfs.xfs: test that shipped config files work properly
Date:   Mon,  5 Jun 2023 16:11:35 -0500
Message-Id: <1685999495-7998-1-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Sanity check the shipped mkfs.xfs config files by using
them to format the scratch device.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 tests/xfs/569     | 32 ++++++++++++++++++++++++++++++++
 tests/xfs/569.out |  2 ++
 2 files changed, 34 insertions(+)
 create mode 100755 tests/xfs/569
 create mode 100644 tests/xfs/569.out

diff --git a/tests/xfs/569 b/tests/xfs/569
new file mode 100755
index 0000000..ebcaaab
--- /dev/null
+++ b/tests/xfs/569
@@ -0,0 +1,32 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test 569
+#
+# Check for any installed example mkfs config files and validate that
+# mkfs.xfs can properly use them.
+#
+. ./common/preamble
+_begin_fstest mkfs
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_require_scratch
+
+ls /usr/share/xfsprogs/mkfs/*.conf &>/dev/null || \
+	_notrun "No mkfs.xfs config files installed"
+
+# We only fail if mkfs.xfs fails outright, ignoring warnings etc
+echo "Silence is golden"
+
+for CONFIG in /usr/share/xfsprogs/mkfs/*.conf; do
+	$MKFS_XFS_PROG -c options=$CONFIG -f $SCRATCH_DEV &>>$seqres.full || \
+		_fail "mkfs.xfs config file $CONFIG failed"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/569.out b/tests/xfs/569.out
new file mode 100644
index 0000000..c7aaf10
--- /dev/null
+++ b/tests/xfs/569.out
@@ -0,0 +1,2 @@
+QA output created by 569
+Silence is golden
-- 
1.8.3.1

