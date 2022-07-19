Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509AF57A918
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Jul 2022 23:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240081AbiGSVhm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 Jul 2022 17:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235209AbiGSVhl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 17:37:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B11860515;
        Tue, 19 Jul 2022 14:37:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 327E261A77;
        Tue, 19 Jul 2022 21:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71086C341C6;
        Tue, 19 Jul 2022 21:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658266659;
        bh=B3klj5s2G38OP3A28fEXSIL/9iqBE6ukOP7T7dYS+AI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kwAQUXoz2RZx4hsIqEi+l0BBOfyGqTyaVwsxi34+Wl92nBFUPUvhDmzU2i5X/efKQ
         AsOKntvLLbRcJ4YO/1EDhb/g8Dpfv6KEt+x0Oit9eHqW+sFzk57COMCcK/st4OUF/k
         Vs04x4BZcZfahGVaNDcpsOw35itWTmDSgHrLLHj9OTQB/fCs2n5nIj+ax+jmwy1CMc
         NypsrT1tgYS+m1FOLiabEkT3pjdhCe23rWbokcYHDqnQY2VcMi3MyLl7S1EWpQhFYu
         XHd50aslC3MgJKTun8Xo5O16flk4jASayRkpEP/DfT6bo/RGDDSbtJHO3asOv/FEsf
         WWx5iNGM+KpDg==
Subject: [PATCH 4/8] misc: avoid tests encoding FIEMAP/BMAP golden output with
 weird file blocksizes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 19 Jul 2022 14:37:39 -0700
Message-ID: <165826665901.3249494.4628833114266813778.stgit@magnolia>
In-Reply-To: <165826663647.3249494.13640199673218669145.stgit@magnolia>
References: <165826663647.3249494.13640199673218669145.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Some tests encode FIEMAP/XFS_IOC_BMAP results in the golden output.
Typically these tests cannot handle a filesystem that chooses to
allocate extents that are much larger than the filesystem block size
(aka XFS rt extents and ext4 bigalloc).  Since these tests are /never/
going to pass, disable them when these configurations are detected.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/483 |    4 ++++
 tests/generic/677 |    4 ++++
 tests/xfs/166     |    4 ++++
 tests/xfs/203     |    4 ++++
 4 files changed, 16 insertions(+)


diff --git a/tests/generic/483 b/tests/generic/483
index e7120362..39129542 100755
--- a/tests/generic/483
+++ b/tests/generic/483
@@ -35,6 +35,10 @@ _require_metadata_journaling $SCRATCH_DEV
 _init_flakey
 _mount_flakey
 
+# The fiemap results in the golden output requires file allocations to align to
+# 256K boundaries.
+_require_congruent_file_oplen $SCRATCH_MNT 262144
+
 # Create our test files.
 $XFS_IO_PROG -f -c "pwrite -S 0xea 0 256K" $SCRATCH_MNT/foo >/dev/null
 
diff --git a/tests/generic/677 b/tests/generic/677
index 39af90a9..4dbfed7d 100755
--- a/tests/generic/677
+++ b/tests/generic/677
@@ -38,6 +38,10 @@ _require_metadata_journaling $SCRATCH_DEV
 _init_flakey
 _mount_flakey
 
+# The fiemap results in the golden output requires file allocations to align to
+# 1MB boundaries.
+_require_congruent_file_oplen $SCRATCH_MNT 1048576
+
 # Create our test file with many extents.
 # On btrfs this results in having multiple leaves of metadata full of file
 # extent items, a condition necessary to trigger the original bug.
diff --git a/tests/xfs/166 b/tests/xfs/166
index d45dc5e8..9e082152 100755
--- a/tests/xfs/166
+++ b/tests/xfs/166
@@ -71,6 +71,10 @@ TEST_PROG=$here/src/unwritten_mmap
 # we need to set the file size to (6 * 2MB == 12MB) to cover all cases.
 FILE_SIZE=$((12 * 1048576))
 
+# The xfs_bmap results in the golden output requires file allocations to align
+# to 1M boundaries.
+_require_congruent_file_oplen $SCRATCH_MNT $FILE_SIZE
+
 rm -f $TEST_FILE
 $TEST_PROG $FILE_SIZE $TEST_FILE
 
diff --git a/tests/xfs/203 b/tests/xfs/203
index a12ae7c3..9a4a4564 100755
--- a/tests/xfs/203
+++ b/tests/xfs/203
@@ -51,6 +51,10 @@ _require_scratch
 _scratch_mkfs > /dev/null 2>&1
 _scratch_mount > /dev/null 2>&1
 
+# The xfs_bmap results in the golden output requires file allocations to align
+# to 64k boundaries.
+_require_congruent_file_oplen $SCRATCH_MNT 65536
+
 for i in 10 14 15 16 17 28 29 30 31; do
         rm -f $SCRATCH_MNT/hole_file
 	_write_holes $SCRATCH_MNT/hole_file${i} ${i}

