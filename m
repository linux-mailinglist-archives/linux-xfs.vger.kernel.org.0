Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CDF560E31
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Jun 2022 02:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiF3AsT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Jun 2022 20:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiF3AsS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 20:48:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03555A1B5;
        Wed, 29 Jun 2022 17:48:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF5A9B82615;
        Thu, 30 Jun 2022 00:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6317AC34114;
        Thu, 30 Jun 2022 00:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656550095;
        bh=xhlbqO49sbtza162zMADZAdb4iYaAx5RVZyj3uNU+Dw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MBETxWdff2n91eqqmVSDn6LjNSbJLqS1rBZ0reUJ4KOOyBnBIOiTc0OFYxdl8/BAi
         8iXIBS569DQ6ALO3YyM1VXo3FVJ/s+lVtytISlJtyxYvxr31am1ctCh+xBgpJ9BNed
         sNdkcdsQ7Xm+mOSUn2GcwjVcdV0p0jH3EoiUPVf0XeLuwWFeVjet4LDxkBTkIhEyqD
         XrRy8alQGyOF1HeQWP/hOHN5zn8AUmjaoCbTUd01EfUMb2KEtpMrG0/yeQ34tE6h4K
         WrD58a/Y3q6iDOHpZAFYKB5U/eF3DwXZaIG/ucpJ2cW503XuvFEkrpuTu4wlfh83Tb
         IEO+HCqBoeVAQ==
Date:   Wed, 29 Jun 2022 17:48:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH v2.1 4/9] xfs: test xfs_copy doesn't do cached read before
 libxfs_mount
Message-ID: <YrzyzsYZDx9AI4fy@magnolia>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <165644770013.1045534.5572366430392518217.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644770013.1045534.5572366430392518217.stgit@magnolia>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This is a regression test for an xfs_copy fix that ensures that it
doesn't perform a cached read of an XFS filesystem prior to initializing
libxfs, since the xfs_mount (and hence the buffer cache) isn't set up
yet.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/844     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/844.out |    3 +++
 2 files changed, 41 insertions(+)
 create mode 100755 tests/xfs/844
 create mode 100644 tests/xfs/844.out

diff --git a/tests/xfs/844 b/tests/xfs/844
new file mode 100755
index 00000000..32349c85
--- /dev/null
+++ b/tests/xfs/844
@@ -0,0 +1,38 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test 844
+#
+# Regression test for xfsprogs commit:
+#
+# XXXXXXXX ("xfs_copy: don't use cached buffer reads until after libxfs_mount")
+#
+# It was discovered that passing xfs_copy a source device containing an ext4
+# filesystem would cause xfs_copy to crash.  Further investigation revealed
+# that any readable path that didn't have a plausible XFS superblock in block
+# zero would produce the same crash, so this regression test exploits that.
+#
+. ./common/preamble
+_begin_fstest auto copy quick
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_require_xfs_copy
+_require_test
+
+rm -f $TEST_DIR/$seq.*
+$XFS_IO_PROG -f -c 'truncate 100m' $TEST_DIR/$seq.a
+$XFS_IO_PROG -f -c 'truncate 100m' $TEST_DIR/$seq.b
+
+filter_copy() {
+	sed -e 's/Superblock has bad magic number.*/bad magic number/'
+}
+
+$XFS_COPY_PROG $TEST_DIR/$seq.a $TEST_DIR/$seq.b 2>&1 | filter_copy
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/844.out b/tests/xfs/844.out
new file mode 100644
index 00000000..dbefde1c
--- /dev/null
+++ b/tests/xfs/844.out
@@ -0,0 +1,3 @@
+QA output created by 844
+bad magic number
+xfs_copy: couldn't read superblock, error=22
