Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDA178CFD9
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Aug 2023 01:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241074AbjH2XFL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 29 Aug 2023 19:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240795AbjH2XEi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:04:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1B4CC4;
        Tue, 29 Aug 2023 16:04:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 524C6611BD;
        Tue, 29 Aug 2023 23:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B09C433C7;
        Tue, 29 Aug 2023 23:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350273;
        bh=FoGr1iyZsPUf3+MPWQUd0ygGFyK+hSaK6/lOMQsLmkY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=L5Gt91TF0QDsBsVOJkrNs2BarEjTxgRUecT/I4+fxuFOBD0Jxb5KPGwf9S2rtfMk1
         erstNvEpXLR/GVdbFa5PMo5g46lCmnWKbNnvtLXkJpmeOsvKY44948Tz+r0g2UNJhF
         A0+hUzYKdIsTgHjd/EFbj6Bg7WlsciHIO0pDuh6CRhsr0fOACNVJ/MldJqahjF5acz
         YrkdvsoY0xcT8ZmEBKxUEGA52xt0mC2SUciRa1q6qoY6/GdjJRLAsSZor5KlW+BjMS
         CASPEc1q5SJAl6sPomKWO/tLHVemNfQ6xeMZufArXzbmIWHSGc2jjf9fCMaOCqFzG4
         zD4bsd19s6d0w==
Subject: [PATCH 1/1] xfs: test fix for an agbno overflow in
 __xfs_getfsmap_datadev
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, david@fromorbit.com
Date:   Tue, 29 Aug 2023 16:04:33 -0700
Message-ID: <169335027327.3520701.12907220694035829174.stgit@frogsfrogsfrogs>
In-Reply-To: <169335026762.3520701.5816499712408940016.stgit@frogsfrogsfrogs>
References: <169335026762.3520701.5816499712408940016.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Dave Chinner reported that xfs/273 fails if the AG size happens to be an
exact power of two.  I traced this to an agbno integer overflow when the
current GETFSMAP call is a continuation of a previous GETFSMAP call, and
the last record returned was non-shareable space at the end of an AG.

This is the regression test for that bug.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/935     |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/935.out |    2 ++
 2 files changed, 57 insertions(+)
 create mode 100755 tests/xfs/935
 create mode 100644 tests/xfs/935.out


diff --git a/tests/xfs/935 b/tests/xfs/935
new file mode 100755
index 0000000000..ddd0051848
--- /dev/null
+++ b/tests/xfs/935
@@ -0,0 +1,55 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Oracle.  All Rights Reserved.
+#
+# FS QA Test 935
+#
+# Regression test for an agbno overflow bug in XFS GETFSMAP involving an
+# fsmap_advance call.  Userspace can indicate that a GETFSMAP call is actually
+# a continuation of a previous call by setting the "low" key to the last record
+# returned by the previous call.
+#
+# If the last record returned by GETFSMAP is a non-shareable extent at the end
+# of an AG and the AG size is exactly a power of two, the startblock in the low
+# key of the rmapbt query can be set to a value larger than EOAG.  When this
+# happens, GETFSMAP will return EINVAL instead of returning records for the
+# next AG.
+#
+. ./common/preamble
+_begin_fstest auto quick fsmap
+
+. ./common/filter
+
+_fixed_by_git_commit kernel XXXXXXXXXXXXX \
+	"xfs: fix an agbno overflow in __xfs_getfsmap_datadev"
+
+# Modify as appropriate.
+_supported_fs generic
+_require_xfs_io_command fsmap
+_require_xfs_scratch_rmapbt
+
+_scratch_mkfs | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
+source $tmp.mkfs
+
+# Find the next power of two agsize smaller than whatever the default is.
+for ((p = 31; p > 0; p--)); do
+	desired_agsize=$((2 ** p))
+	test "$desired_agsize" -lt "$agsize" && break
+done
+
+echo "desired agsize=$desired_agsize" >> $seqres.full
+_scratch_mkfs -d "agsize=${desired_agsize}b" | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
+source $tmp.mkfs
+
+test "$desired_agsize" -eq "$agsize" || _notrun "wanted agsize=$desired_agsize, got $agsize"
+
+_scratch_mount
+$XFS_IO_PROG -c 'fsmap -n 1024 -v' $SCRATCH_MNT >> $tmp.big
+$XFS_IO_PROG -c 'fsmap -n 1 -v' $SCRATCH_MNT >> $tmp.small
+
+diff -Naurpw $tmp.big $tmp.small
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/935.out b/tests/xfs/935.out
new file mode 100644
index 0000000000..1b5422d1e3
--- /dev/null
+++ b/tests/xfs/935.out
@@ -0,0 +1,2 @@
+QA output created by 935
+Silence is golden

