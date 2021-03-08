Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACA233128F
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Mar 2021 16:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhCHPv7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Mar 2021 10:51:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhCHPvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 10:51:31 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB61C06174A;
        Mon,  8 Mar 2021 07:51:31 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id 30so497195ple.4;
        Mon, 08 Mar 2021 07:51:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4pNf/1KuFd//2XezWJ+O5ap4zDVy3ElxxRcnw29ck7g=;
        b=UliJyCaGc4wklhaIoX+n2+DFfolGShy35imimba5No7IZ0uQ7z2Zmf03pogQLMAQqH
         QL/4bRLU51kOD2EwZwYz0Ymi9HOWUmVg4+RYHSBM8u1h2eIUgB2QwEGrWZ8AxmkiNItU
         BD4I9rfTlOhSefjIeAKWfvY8he4bIRE2GdIS3EAydad/QZiDk9Y7j/p66uQOe/9gEO/9
         zRZIaxJ1i8JfX6Gw7C9P/E2l4LIZbGN0WpCVwryiW7U/i7IEYEaIYikgb1Z76o9+9ciT
         5rFI5nWsKRsVNv6fJ0il0wXoiXKxyPs+J0prZ2EN1MyvuWWSdTDN6BYn1l9AaHqM1FZB
         Wxpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4pNf/1KuFd//2XezWJ+O5ap4zDVy3ElxxRcnw29ck7g=;
        b=dATelBr26XGg0lGugy/lcYNtI2jvRP9YSLUjJBslC0sv/zMn3/sDUlY3BD8ZFVE6T8
         CmcCzNNRervVp9o2ljcxZyorMwDY132H3e3iMSzefVCLjUhAcZTWTZIiomOqu77mTnG0
         9OjS9DM1bIGFYP17EMa/XzgXVmeZg2uLlO+cDQWSOxXXpryAzXoLqauPysPrmQcc7hDO
         HfkK6GAQlsh+pRdOSy18mXSf90FwWwXTWQLBWGsyTG4bnlaagMsIwO7OAUuJ0fMiw/w0
         xt6Oicgxx17aZfpmaQ70oWp7d+JPuYFyEIFSb5ds+HvXW2PkbPrzuVYGq7EvwZ2I2wtc
         wpvg==
X-Gm-Message-State: AOAM530elskGTcc7FzRmucDv4aQd+7FaeUsLXHv3Fqo2jn16qRWLhufK
        K2JSqhLTM7EMUTkk3wQMakfBGLymPt4=
X-Google-Smtp-Source: ABdhPJx+lFSnZ3WtDEnE3nlRwea7B4zyffFfTZmsFZ+I4cQY3HC21QR1u/SB07BjXOnrXVvztKZfSw==
X-Received: by 2002:a17:902:c48d:b029:e6:f7d:a76d with SMTP id n13-20020a170902c48db02900e60f7da76dmr8859784plx.66.1615218690851;
        Mon, 08 Mar 2021 07:51:30 -0800 (PST)
Received: from localhost.localdomain ([122.182.238.13])
        by smtp.gmail.com with ESMTPSA id s4sm11086378pji.2.2021.03.08.07.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:51:30 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V5 04/13] xfs: Check for extent overflow when trivally adding a new extent
Date:   Mon,  8 Mar 2021 21:21:02 +0530
Message-Id: <20210308155111.53874-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308155111.53874-1-chandanrlinux@gmail.com>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when adding a single extent while there's no possibility of splitting
an existing mapping.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/528     | 171 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/528.out |  20 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 192 insertions(+)
 create mode 100755 tests/xfs/528
 create mode 100644 tests/xfs/528.out

diff --git a/tests/xfs/528 b/tests/xfs/528
new file mode 100755
index 00000000..5eb1021a
--- /dev/null
+++ b/tests/xfs/528
@@ -0,0 +1,171 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 528
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# adding a single extent while there's no possibility of splitting an existing
+# mapping.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/quota
+. ./common/inject
+. ./common/populate
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_scratch
+_require_xfs_quota
+_require_xfs_debug
+_require_test_program "punch-alternating"
+_require_xfs_io_command "falloc"
+_require_xfs_io_error_injection "reduce_max_iextents"
+_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
+
+echo "Format and mount fs"
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
+_scratch_mount -o uquota >> $seqres.full
+
+bsize=$(_get_file_block_size $SCRATCH_MNT)
+
+echo "* Delalloc to written extent conversion"
+
+testfile=$SCRATCH_MNT/testfile
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+nr_blks=$((15 * 2))
+
+echo "Create fragmented file"
+for i in $(seq 0 2 $((nr_blks - 1))); do
+	$XFS_IO_PROG -f -s -c "pwrite $((i * bsize)) $bsize" $testfile \
+	       >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+echo "Verify \$testfile's extent count"
+
+nextents=$(xfs_get_fsxattr nextents $testfile)
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+rm $testfile
+
+echo "* Fallocate unwritten extents"
+
+echo "Fallocate fragmented file"
+for i in $(seq 0 2 $((nr_blks - 1))); do
+	$XFS_IO_PROG -f -c "falloc $((i * bsize)) $bsize" $testfile \
+	       >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+echo "Verify \$testfile's extent count"
+
+nextents=$(xfs_get_fsxattr nextents $testfile)
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+rm $testfile
+
+echo "* Directio write"
+
+echo "Create fragmented file via directio writes"
+for i in $(seq 0 2 $((nr_blks - 1))); do
+	$XFS_IO_PROG -d -s -f -c "pwrite $((i * bsize)) $bsize" $testfile \
+	       >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+echo "Verify \$testfile's extent count"
+
+nextents=$(xfs_get_fsxattr nextents $testfile)
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+rm $testfile
+
+# Check if XFS gracefully returns with an error code when we try to increase
+# extent count of user quota inode beyond the pseudo max extent count limit.
+echo "* Extend quota inodes"
+
+echo "Disable reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 0
+
+echo "Consume free space"
+fillerdir=$SCRATCH_MNT/fillerdir
+nr_free_blks=$(stat -f -c '%f' $SCRATCH_MNT)
+nr_free_blks=$((nr_free_blks * 90 / 100))
+
+_fill_fs $((bsize * nr_free_blks)) $fillerdir $bsize 0 >> $seqres.full 2>&1
+
+echo "Create fragmented filesystem"
+for dentry in $(ls -1 $fillerdir/); do
+	$here/src/punch-alternating $fillerdir/$dentry >> $seqres.full
+done
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Inject bmap_alloc_minlen_extent error tag"
+_scratch_inject_error bmap_alloc_minlen_extent 1
+
+nr_blks=20
+
+# This is a rough calculation; It doesn't take block headers into
+# consideration.
+# gdb -batch vmlinux -ex 'print sizeof(struct xfs_dqblk)'
+# $1 = 136
+nr_quotas_per_block=$((bsize / 136))
+nr_quotas=$((nr_quotas_per_block * nr_blks))
+
+echo "Extend uquota file"
+for i in $(seq 0 $nr_quotas_per_block $nr_quotas); do
+	chown $i $testfile >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+_scratch_unmount >> $seqres.full
+
+echo "Verify uquota inode's extent count"
+uquotino=$(_scratch_xfs_get_metadata_field 'uquotino' 'sb 0')
+
+nextents=$(_scratch_get_iext_count $uquotino data || \
+		   _fail "Unable to obtain inode fork's extent count")
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/528.out b/tests/xfs/528.out
new file mode 100644
index 00000000..3973cc15
--- /dev/null
+++ b/tests/xfs/528.out
@@ -0,0 +1,20 @@
+QA output created by 528
+Format and mount fs
+* Delalloc to written extent conversion
+Inject reduce_max_iextents error tag
+Create fragmented file
+Verify $testfile's extent count
+* Fallocate unwritten extents
+Fallocate fragmented file
+Verify $testfile's extent count
+* Directio write
+Create fragmented file via directio writes
+Verify $testfile's extent count
+* Extend quota inodes
+Disable reduce_max_iextents error tag
+Consume free space
+Create fragmented filesystem
+Inject reduce_max_iextents error tag
+Inject bmap_alloc_minlen_extent error tag
+Extend uquota file
+Verify uquota inode's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index e861cec9..2356c4a9 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -525,3 +525,4 @@
 525 auto quick mkfs
 526 auto quick mkfs
 527 auto quick quota
+528 auto quick quota
-- 
2.29.2

