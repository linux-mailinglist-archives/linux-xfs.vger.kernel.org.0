Return-Path: <linux-xfs+bounces-9812-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66B0F9137E8
	for <lists+linux-xfs@lfdr.de>; Sun, 23 Jun 2024 07:39:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02EDE283B96
	for <lists+linux-xfs@lfdr.de>; Sun, 23 Jun 2024 05:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 616E9249FF;
	Sun, 23 Jun 2024 05:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L6xFw9q1"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FBF20E3;
	Sun, 23 Jun 2024 05:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719121149; cv=none; b=bUXAFfsm1BRsurIo1RybQv56N9F16GNh0LmbfULXwMQmo2q5OGR4GtwURgwhmDiqs7sj+EsPQ07mJuBZ+ubXPtJHkWMY8cusaqS/k1P+xwWmucDQVlFbz0CUf1f1I4QeaEnGpy+GLA+JuWGLDbNvg7V+SPOr3zhv/0ftJEqQisg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719121149; c=relaxed/simple;
	bh=9VtSFjWKdWDuIkwMUMwxx5GX/n/8+80WlFe2ofIexHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzE+0eXDgX8j6IVE78ngZSD9pjWS6uJDMDYz1ym1IaNdbweU3qOgC5H/EzjwhKdQjWuHguD7PRnDaBHN45e/mGB4vfXwfwfyGqaTialgz20WTdpcC6Og4gIiwwNmnE/wPSvlI1zTVRn6mUo2LFb/lkOeAbkqkHmxczXNd2IVI+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L6xFw9q1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ADu9fDTErw4km3isUSI6w32BNdlOZbeA4xzHDBLm+Es=; b=L6xFw9q1ZrglEHsyIvTFs1erEQ
	CRJWT2IhL3Df0PPvooGGM4kio25lKasZgJkvnmd0fsbTMXzSuezh7ss07aRG8PyeUI/EWCMyp1Yma
	rusrOExodkQ5M0JtfUso0V3e0S4G0zdZfd6g72zayqkOBddZ2qirJ/Sj3Gw0Onptjg71o3S/IRrfx
	87sp3hBI7dInZd40pUYVofCKFZO5RTYFRWfT8ciXwMSzrPMIu127DfbozWGHcQJ6AVqiHmy08aSF0
	VKeq9gNgJk9pfuemIUTcZHrimDX7Qx5ngjI/R5hGtjXUY4OQe5Okg8ZmQ48iLzoV99cNBwAxAoO8i
	eZM4jloA==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLFwQ-0000000DOWe-2EwY;
	Sun, 23 Jun 2024 05:39:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: [PATCH] xfs: new EOF fragmentation tests
Date: Sun, 23 Jun 2024 07:38:53 +0200
Message-ID: <20240623053900.857695-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240623053900.857695-1-hch@lst.de>
References: <20240623053900.857695-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Dave Chinner <dchinner@redhat.com>

These tests create substantial file fragmentation as a result of
application actions that defeat post-EOF preallocation
optimisations. They are intended to replicate known vectors for
these problems, and provide a check that the fragmentation levels
have been controlled. The mitigations we make may not completely
remove fragmentation (e.g. they may demonstrate speculative delalloc
related extent size growth) so the checks don't assume we'll end up
with perfect layouts and hence check for an exceptable level of
fragmentation rather than none.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[move to different test number, update to current xfstest APIs]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/1500     | 59 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/1500.out |  9 ++++++
 tests/xfs/1501     | 61 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1501.out |  9 ++++++
 tests/xfs/1502     | 61 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1502.out |  9 ++++++
 tests/xfs/1503     | 70 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1503.out | 33 ++++++++++++++++++++++
 8 files changed, 311 insertions(+)
 create mode 100755 tests/xfs/1500
 create mode 100644 tests/xfs/1500.out
 create mode 100755 tests/xfs/1501
 create mode 100644 tests/xfs/1501.out
 create mode 100755 tests/xfs/1502
 create mode 100644 tests/xfs/1502.out
 create mode 100755 tests/xfs/1503
 create mode 100644 tests/xfs/1503.out

diff --git a/tests/xfs/1500 b/tests/xfs/1500
new file mode 100755
index 000000000..222e90d6c
--- /dev/null
+++ b/tests/xfs/1500
@@ -0,0 +1,59 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test xfs/500
+#
+# Post-EOF preallocation defeat test for O_SYNC buffered I/O.
+#
+
+. ./common/preamble
+_begin_fstest auto quick prealloc rw
+
+. ./common/rc
+. ./common/filter
+
+_supported_fs xfs
+_require_scratch
+
+_scratch_mkfs 2>&1 >> $seqres.full
+_scratch_mount
+
+# Write multiple files in parallel using synchronous buffered writes. Aim is to
+# interleave allocations to fragment the files. Synchronous writes defeat the
+# open/write/close heuristics in xfs_file_release() that prevent EOF block
+# removal, so this should fragment badly. Typical problematic behaviour shows
+# per-file extent counts of >900 (almost worse case) whilst fixed behaviour
+# typically shows extent counts in the low 20s.
+#
+# Failure is determined by golden output mismatch from _within_tolerance().
+
+workfile=$SCRATCH_MNT/file
+nfiles=8
+wsize=4096
+wcnt=1000
+
+write_sync_file()
+{
+	idx=$1
+
+	for ((cnt=0; cnt<$wcnt; cnt++)); do
+		$XFS_IO_PROG -f -s -c "pwrite $((cnt * wsize)) $wsize" $workfile.$idx
+	done
+}
+
+rm -f $workfile*
+for ((n=0; n<$nfiles; n++)); do
+	write_sync_file $n > /dev/null 2>&1 &
+done
+wait
+sync
+
+for ((n=0; n<$nfiles; n++)); do
+	count=$(_count_extents $workfile.$n)
+	# Acceptible extent count range is 1-40
+	_within_tolerance "file.$n extent count" $count 21 19 -v
+done
+
+status=0
+exit
diff --git a/tests/xfs/1500.out b/tests/xfs/1500.out
new file mode 100644
index 000000000..414df87ed
--- /dev/null
+++ b/tests/xfs/1500.out
@@ -0,0 +1,9 @@
+QA output created by 1500
+file.0 extent count is in range
+file.1 extent count is in range
+file.2 extent count is in range
+file.3 extent count is in range
+file.4 extent count is in range
+file.5 extent count is in range
+file.6 extent count is in range
+file.7 extent count is in range
diff --git a/tests/xfs/1501 b/tests/xfs/1501
new file mode 100755
index 000000000..beae49bff
--- /dev/null
+++ b/tests/xfs/1501
@@ -0,0 +1,61 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test xfs/501
+#
+# Post-EOF preallocation defeat test for buffered I/O with extent size hints.
+#
+
+. ./common/preamble
+_begin_fstest auto quick prealloc rw
+
+. ./common/rc
+. ./common/filter
+
+_supported_fs xfs
+_require_scratch
+
+_scratch_mkfs 2>&1 >> $seqres.full
+_scratch_mount
+
+# Write multiple files in parallel using buffered writes with extent size hints.
+# Aim is to interleave allocations to fragment the files. Writes w/ extent size
+# hints set defeat the open/write/close heuristics in xfs_file_release() that
+# prevent EOF block removal, so this should fragment badly. Typical problematic
+# behaviour shows per-file extent counts of 1000 (worst case!) whilst
+# fixed behaviour should show very few extents (almost best case).
+#
+# Failure is determined by golden output mismatch from _within_tolerance().
+
+workfile=$SCRATCH_MNT/file
+nfiles=8
+wsize=4096
+wcnt=1000
+extent_size=16m
+
+write_extsz_file()
+{
+	idx=$1
+
+	$XFS_IO_PROG -f -c "extsize $extent_size" $workfile.$idx
+	for ((cnt=0; cnt<$wcnt; cnt++)); do
+		$XFS_IO_PROG -f -c "pwrite $((cnt * wsize)) $wsize" $workfile.$idx
+	done
+}
+
+rm -f $workfile*
+for ((n=0; n<$nfiles; n++)); do
+	write_extsz_file $n > /dev/null 2>&1 &
+done
+wait
+sync
+
+for ((n=0; n<$nfiles; n++)); do
+	count=$(_count_extents $workfile.$n)
+	# Acceptible extent count range is 1-10
+	_within_tolerance "file.$n extent count" $count 2 1 8 -v
+done
+
+status=0
+exit
diff --git a/tests/xfs/1501.out b/tests/xfs/1501.out
new file mode 100644
index 000000000..a266ef74b
--- /dev/null
+++ b/tests/xfs/1501.out
@@ -0,0 +1,9 @@
+QA output created by 1501
+file.0 extent count is in range
+file.1 extent count is in range
+file.2 extent count is in range
+file.3 extent count is in range
+file.4 extent count is in range
+file.5 extent count is in range
+file.6 extent count is in range
+file.7 extent count is in range
diff --git a/tests/xfs/1502 b/tests/xfs/1502
new file mode 100755
index 000000000..9d303ced7
--- /dev/null
+++ b/tests/xfs/1502
@@ -0,0 +1,61 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test xfs/502
+#
+# Post-EOF preallocation defeat test for direct I/O with extent size hints.
+#
+
+. ./common/preamble
+_begin_fstest auto quick prealloc rw
+
+. ./common/rc
+. ./common/filter
+
+_supported_fs xfs
+_require_scratch
+
+_scratch_mkfs 2>&1 >> $seqres.full
+_scratch_mount
+
+# Write multiple files in parallel using O_DIRECT writes w/ extent size hints.
+# Aim is to interleave allocations to fragment the files. O_DIRECT writes defeat
+# the open/write/close heuristics in xfs_file_release() that prevent EOF block
+# removal, so this should fragment badly. Typical problematic behaviour shows
+# per-file extent counts of ~1000 (worst case) whilst fixed behaviour typically
+# shows extent counts in the low single digits (almost best case)
+#
+# Failure is determined by golden output mismatch from _within_tolerance().
+
+workfile=$SCRATCH_MNT/file
+nfiles=8
+wsize=4096
+wcnt=1000
+extent_size=16m
+
+write_direct_file()
+{
+	idx=$1
+
+	$XFS_IO_PROG -f -c "extsize $extent_size" $workfile.$idx
+	for ((cnt=0; cnt<$wcnt; cnt++)); do
+		$XFS_IO_PROG -f -d -c "pwrite $((cnt * wsize)) $wsize" $workfile.$idx
+	done
+}
+
+rm -f $workfile*
+for ((n=0; n<$nfiles; n++)); do
+	write_direct_file $n > /dev/null 2>&1 &
+done
+wait
+sync
+
+for ((n=0; n<$nfiles; n++)); do
+	count=$(_count_extents $workfile.$n)
+	# Acceptible extent count range is 1-10
+	_within_tolerance "file.$n extent count" $count 2 1 8 -v
+done
+
+status=0
+exit
diff --git a/tests/xfs/1502.out b/tests/xfs/1502.out
new file mode 100644
index 000000000..82c8760a3
--- /dev/null
+++ b/tests/xfs/1502.out
@@ -0,0 +1,9 @@
+QA output created by 1502
+file.0 extent count is in range
+file.1 extent count is in range
+file.2 extent count is in range
+file.3 extent count is in range
+file.4 extent count is in range
+file.5 extent count is in range
+file.6 extent count is in range
+file.7 extent count is in range
diff --git a/tests/xfs/1503 b/tests/xfs/1503
new file mode 100755
index 000000000..41f4035ad
--- /dev/null
+++ b/tests/xfs/1503
@@ -0,0 +1,70 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test xfs/503
+#
+# Post-EOF preallocation defeat test with O_SYNC buffered I/O that repeatedly
+# closes and reopens the files.
+#
+
+. ./common/preamble
+_begin_fstest auto prealloc rw
+
+. ./common/rc
+. ./common/filter
+
+_supported_fs xfs
+_require_scratch
+
+_scratch_mkfs 2>&1 >> $seqres.full
+_scratch_mount
+
+# Write multiple files in parallel using synchronous buffered writes that
+# repeatedly close and reopen the fails. Aim is to interleave allocations to
+# fragment the files. Assuming we've fixed the synchronous write defeat, we can
+# still trigger the same issue with a open/read/close on O_RDONLY files. We
+# should not be triggering EOF preallocation removal on files we don't have
+# permission to write, so until this is fixed it should fragment badly.  Typical
+# problematic behaviour shows per-file extent counts of 50-350 whilst fixed
+# behaviour typically demonstrates post-eof speculative delalloc growth in
+# extent size (~6 extents for 50MB file).
+#
+# Failure is determined by golden output mismatch from _within_tolerance().
+
+workfile=$SCRATCH_MNT/file
+nfiles=32
+wsize=4096
+wcnt=1000
+
+write_file()
+{
+	idx=$1
+
+	$XFS_IO_PROG -f -s -c "pwrite -b 64k 0 50m" $workfile.$idx
+}
+
+read_file()
+{
+	idx=$1
+
+	for ((cnt=0; cnt<$wcnt; cnt++)); do
+		$XFS_IO_PROG -f -r -c "pread 0 28" $workfile.$idx
+	done
+}
+
+rm -f $workdir/file*
+for ((n=0; n<$((nfiles)); n++)); do
+	write_file $n > /dev/null 2>&1 &
+	read_file $n > /dev/null 2>&1 &
+done
+wait
+
+for ((n=0; n<$nfiles; n++)); do
+	count=$(_count_extents $workfile.$n)
+	# Acceptible extent count range is 1-40
+	_within_tolerance "file.$n extent count" $count 6 5 10 -v
+done
+
+status=0
+exit
diff --git a/tests/xfs/1503.out b/tests/xfs/1503.out
new file mode 100644
index 000000000..1780b16df
--- /dev/null
+++ b/tests/xfs/1503.out
@@ -0,0 +1,33 @@
+QA output created by 1503
+file.0 extent count is in range
+file.1 extent count is in range
+file.2 extent count is in range
+file.3 extent count is in range
+file.4 extent count is in range
+file.5 extent count is in range
+file.6 extent count is in range
+file.7 extent count is in range
+file.8 extent count is in range
+file.9 extent count is in range
+file.10 extent count is in range
+file.11 extent count is in range
+file.12 extent count is in range
+file.13 extent count is in range
+file.14 extent count is in range
+file.15 extent count is in range
+file.16 extent count is in range
+file.17 extent count is in range
+file.18 extent count is in range
+file.19 extent count is in range
+file.20 extent count is in range
+file.21 extent count is in range
+file.22 extent count is in range
+file.23 extent count is in range
+file.24 extent count is in range
+file.25 extent count is in range
+file.26 extent count is in range
+file.27 extent count is in range
+file.28 extent count is in range
+file.29 extent count is in range
+file.30 extent count is in range
+file.31 extent count is in range
-- 
2.43.0


