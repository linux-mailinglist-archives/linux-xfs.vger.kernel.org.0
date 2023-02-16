Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6320C699EDF
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Feb 2023 22:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjBPVQS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Feb 2023 16:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjBPVQP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:16:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4231521FD;
        Thu, 16 Feb 2023 13:16:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1DF17CE2D0F;
        Thu, 16 Feb 2023 21:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B54EC433EF;
        Thu, 16 Feb 2023 21:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582171;
        bh=sUnxusCjM7KbBV1sOapwU/pO0WMHXTiwdOMaQy9glDE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=mMceWdr8Xz8So1imJJBvc1ZJw4R9vZEJNX+grlyhonle6QHgYCQ6HJ6KJcJznw/ms
         rvhbR2L+n3DLV8wFiUpA6hx8Cs+KRaPPfdMoC6vOn3bYAHgCiBsSmYm2h37tuqlh9t
         qFeLMb+ZlyyS8uNv9+Sfmtx0PFpPw5phwA1XMOqIdLhcH3UDFr/RYswiS0NCkssBnH
         1TahTTw5B1I/qO2Y2MTo3tY6rfpXzl4RFL4ya3OC3LE/7SRm6QFQ6Dwri0haAMWDBh
         uMBG0MjPiOxNmL9lsBQON8MAN76skE2aSGhrLDJWXGEXzKpbKgPTp+BSUFprdifQ0e
         eBbJ7dP5mIauQ==
Date:   Thu, 16 Feb 2023 13:16:10 -0800
Subject: [PATCH 10/14] xfs: add parent pointer inject test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657884621.3481377.1347483898180056251.stgit@magnolia>
In-Reply-To: <167657884480.3481377.14824439551809919632.stgit@magnolia>
References: <167657884480.3481377.14824439551809919632.stgit@magnolia>
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

From: Allison Henderson <allison.henderson@oracle.com>

Add a test to verify parent pointers after an error injection and log
replay.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/853     |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/853.out |   14 +++++++++
 2 files changed, 99 insertions(+)
 create mode 100755 tests/xfs/853
 create mode 100644 tests/xfs/853.out


diff --git a/tests/xfs/853 b/tests/xfs/853
new file mode 100755
index 0000000000..f17f4b7e9e
--- /dev/null
+++ b/tests/xfs/853
@@ -0,0 +1,85 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test 853
+#
+# parent pointer inject test
+#
+. ./common/preamble
+_begin_fstest auto quick parent
+
+# get standard environment, filters and checks
+. ./common/filter
+. ./common/inject
+. ./common/parent
+
+# Modify as appropriate
+_supported_fs xfs
+_require_scratch
+_require_xfs_sysfs debug/larp
+_require_xfs_io_error_injection "larp"
+_require_xfs_parent
+_require_xfs_io_command "parent"
+
+# real QA test starts here
+
+# Create a directory tree using a protofile and
+# make sure all inodes created have parent pointers
+
+protofile=$tmp.proto
+
+cat >$protofile <<EOF
+DUMMY1
+0 0
+: root directory
+d--777 3 1
+: a directory
+testfolder1 d--755 3 1
+$
+: back in the root
+testfolder2 d--755 3 1
+: done
+$
+EOF
+
+_scratch_mkfs -f -n parent=1 -p $protofile >>$seqres.full 2>&1 \
+	|| _fail "mkfs failed"
+_check_scratch_fs
+
+_scratch_mount >>$seqres.full 2>&1 \
+	|| _fail "mount failed"
+
+testfolder1="testfolder1"
+testfolder2="testfolder2"
+file4="file4"
+file5="file5"
+
+echo ""
+
+# Create files
+touch $SCRATCH_MNT/$testfolder1/$file4
+_verify_parent "$testfolder1" "$file4" "$testfolder1/$file4"
+
+# Inject error
+_scratch_inject_error "larp"
+
+# Move files
+mv $SCRATCH_MNT/$testfolder1/$file4 $SCRATCH_MNT/$testfolder2/$file5 2>&1 \
+	| _filter_scratch
+
+# FS should be shut down, touch will fail
+touch $SCRATCH_MNT/$testfolder2/$file5 2>&1 | _filter_scratch
+
+# Remount to replay log
+_scratch_remount_dump_log >> $seqres.full
+
+# FS should be online, touch should succeed
+touch $SCRATCH_MNT/$testfolder2/$file5
+
+# Check files again
+_verify_parent "$testfolder2" "$file5" "$testfolder2/$file5"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/853.out b/tests/xfs/853.out
new file mode 100644
index 0000000000..56247c1434
--- /dev/null
+++ b/tests/xfs/853.out
@@ -0,0 +1,14 @@
+QA output created by 853
+
+*** testfolder1 OK
+*** testfolder1/file4 OK
+*** testfolder1/file4 OK
+*** Verified parent pointer: name:file4, namelen:5
+*** Parent pointer OK for child testfolder1/file4
+mv: cannot stat 'SCRATCH_MNT/testfolder1/file4': Input/output error
+touch: cannot touch 'SCRATCH_MNT/testfolder2/file5': Input/output error
+*** testfolder2 OK
+*** testfolder2/file5 OK
+*** testfolder2/file5 OK
+*** Verified parent pointer: name:file5, namelen:5
+*** Parent pointer OK for child testfolder2/file5

