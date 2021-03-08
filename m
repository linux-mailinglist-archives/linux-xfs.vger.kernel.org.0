Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3BC331298
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Mar 2021 16:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhCHPwB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Mar 2021 10:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbhCHPvn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 10:51:43 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF335C06174A;
        Mon,  8 Mar 2021 07:51:43 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id j12so7304884pfj.12;
        Mon, 08 Mar 2021 07:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KMFFCYyGzP7zARjeZvJnfjwGPoSsOwwHruKWWLUt1h8=;
        b=ZFnXW4fKLiN7K1qT9LSmWn9ZQQstu76n271P9MAfOVMIfzfCqi8NqVGZJ4CgcCaB0D
         u88nZSjeI+zu/MQTQx/qEfLprIuLyRW1C+ZB+jdeyOKgIjmbdulxBjcOzVrGIEPOlNFY
         G0G3RIgp6Uo87Bf0jmT7xoI+H8v/NVdM3MDXCI8X9dqyuKBB39rsSsbkM8i4zFoPDAaP
         rs1nPgcIK+n/meiQb1Oqi0b0VC0SErpo87iJpZ/h82z+bhVBxCTw9xCYUBVMAxyZR85c
         daGMGX1B4j2zF0pVtDi8cgKkBYTddo3OcYCLxCAqa2abThEE8CdHlc1EOthOvWsSDjjd
         jeaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KMFFCYyGzP7zARjeZvJnfjwGPoSsOwwHruKWWLUt1h8=;
        b=VoIcHL1UbASH/uD6y0+GA8deoa58C8Z03sxgl6rVoJkb3aIH6LNdtT/pIYSooAj7aW
         s2wAvHnLjj+onr14XUzxw6VBcJ8TvTd9CMSJM8RU5euVP4pDPsBl4NBbMyFTbBGQjPRt
         ZWMsLVlbdpAcr5RUDL7mYL5/DfuJot7WG0SoxYYmfRU5rraOdveM8kVcpRobdkE3uJLc
         J63VQEfY2V6yTkGWyvufgl8JKEzqFFoCJhYDwgxKhKGOxK01qjnm+86QIPL2tB8JCtGM
         3mo9KAQviIyQY+DCwIqv9Pc5deUrJngy9gCqxgewIVpWt/GyGuEU2dX+q/Up/SGIqbKm
         nBcw==
X-Gm-Message-State: AOAM533HVssXPFRwWbk+sVmYYRW3rE2xx66Q4ijcQEat4CJjO4q4OWrq
        w8g5a52OsT6I6jZAvn1irFd1WJUyfEU=
X-Google-Smtp-Source: ABdhPJyEsNaE0pwv8mYd9Wd3BKRiemhmwKWic8ZXClkAdn+63odz8yvF+hgjLc9vuIq/BICFk65cDg==
X-Received: by 2002:a63:c601:: with SMTP id w1mr20289129pgg.11.1615218703103;
        Mon, 08 Mar 2021 07:51:43 -0800 (PST)
Received: from localhost.localdomain ([122.182.238.13])
        by smtp.gmail.com with ESMTPSA id s4sm11086378pji.2.2021.03.08.07.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 07:51:42 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     fstests@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: [PATCH V5 10/13] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Mon,  8 Mar 2021 21:21:08 +0530
Message-Id: <20210308155111.53874-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308155111.53874-1-chandanrlinux@gmail.com>
References: <20210308155111.53874-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test verifies that XFS does not cause inode fork's extent count to
overflow when writing to/funshare-ing a shared extent.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 tests/xfs/534     | 104 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/534.out |  12 ++++++
 tests/xfs/group   |   1 +
 3 files changed, 117 insertions(+)
 create mode 100755 tests/xfs/534
 create mode 100644 tests/xfs/534.out

diff --git a/tests/xfs/534 b/tests/xfs/534
new file mode 100755
index 00000000..c2fa6cb6
--- /dev/null
+++ b/tests/xfs/534
@@ -0,0 +1,104 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Chandan Babu R.  All Rights Reserved.
+#
+# FS QA Test 534
+#
+# Verify that XFS does not cause inode fork's extent count to overflow when
+# writing to a shared extent.
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
+. ./common/reflink
+. ./common/inject
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_scratch
+_require_scratch_reflink
+_require_xfs_debug
+_require_xfs_io_command "reflink"
+_require_xfs_io_command "funshare"
+_require_xfs_io_error_injection "reduce_max_iextents"
+
+echo "Format and mount fs"
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
+_scratch_mount >> $seqres.full
+
+bsize=$(_get_block_size $SCRATCH_MNT)
+
+nr_blks=15
+
+srcfile=${SCRATCH_MNT}/srcfile
+dstfile=${SCRATCH_MNT}/dstfile
+
+echo "Inject reduce_max_iextents error tag"
+_scratch_inject_error reduce_max_iextents 1
+
+echo "Create a \$srcfile having an extent of length $nr_blks blocks"
+$XFS_IO_PROG -f -c "pwrite -b $((nr_blks * bsize))  0 $((nr_blks * bsize))" \
+       -c fsync $srcfile  >> $seqres.full
+
+echo "* Write to shared extent"
+
+echo "Share the extent with \$dstfile"
+_reflink $srcfile $dstfile >> $seqres.full
+
+echo "Buffered write to every other block of \$dstfile's shared extent"
+for i in $(seq 1 2 $((nr_blks - 1))); do
+	$XFS_IO_PROG -f -s -c "pwrite $((i * bsize)) $bsize" $dstfile \
+	       >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+echo "Verify \$dstfile's extent count"
+nextents=$(xfs_get_fsxattr nextents $dstfile)
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+rm $dstfile
+
+echo "* Funshare shared extent"
+
+echo "Share the extent with \$dstfile"
+_reflink $srcfile $dstfile >> $seqres.full
+
+echo "Funshare every other block of \$dstfile's shared extent"
+for i in $(seq 1 2 $((nr_blks - 1))); do
+	$XFS_IO_PROG -f -s -c "funshare $((i * bsize)) $bsize" $dstfile \
+	       >> $seqres.full 2>&1
+	[[ $? != 0 ]] && break
+done
+
+echo "Verify \$dstfile's extent count"
+nextents=$(xfs_get_fsxattr nextents $dstfile)
+if (( $nextents > 10 )); then
+	echo "Extent count overflow check failed: nextents = $nextents"
+	exit 1
+fi
+
+# success, all done
+status=0
+exit
+ 
diff --git a/tests/xfs/534.out b/tests/xfs/534.out
new file mode 100644
index 00000000..53288d12
--- /dev/null
+++ b/tests/xfs/534.out
@@ -0,0 +1,12 @@
+QA output created by 534
+Format and mount fs
+Inject reduce_max_iextents error tag
+Create a $srcfile having an extent of length 15 blocks
+* Write to shared extent
+Share the extent with $dstfile
+Buffered write to every other block of $dstfile's shared extent
+Verify $dstfile's extent count
+* Funshare shared extent
+Share the extent with $dstfile
+Funshare every other block of $dstfile's shared extent
+Verify $dstfile's extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index 3ad47d07..b4f0c777 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -531,3 +531,4 @@
 531 auto quick attr
 532 auto quick dir hardlink symlink
 533 auto quick
+534 auto quick reflink
-- 
2.29.2

