Return-Path: <linux-xfs+bounces-19775-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B80E1A3AE49
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2025 02:02:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26CEA16B018
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2025 01:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB481B423B;
	Wed, 19 Feb 2025 00:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TKgLKchj"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75B9170A2C;
	Wed, 19 Feb 2025 00:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926517; cv=none; b=RN+slrRRITQBodlfaQjZtl3NNBNz5atl0zzmHLEFcEK1lm+eK2qa+kmK9F9GhQSswM0/XbhYMsdYnc+I9EBfsqe7EMQ35SS2XJeCCEnLSKP5Qfd9NpDA8ibTR47wkEe0botwGIhvMe7NIr0w3VN/t1xoFmRW+uUEgPRFIJsTMPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926517; c=relaxed/simple;
	bh=HhsEnFo5yEt0Q+ySMVgu4AD+C9O2PFp30OdJuh9Io2I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OjDnYbnBvZWOx6EmwKJyxeGz7uX1y9tFfm1OkKMJGfM983h4gi4Pz3kmp8jlNG0OtRM0XnByJwUK110E7k/+vIGDoB7YZRLsMxe3HhZKnsp/a20ItoazY4DOBtEukfutgkvAUhm90gF6UaFSn0+eSToBeGOZH7qqkcCuuLgsle8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TKgLKchj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C738C4CEE2;
	Wed, 19 Feb 2025 00:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926517;
	bh=HhsEnFo5yEt0Q+ySMVgu4AD+C9O2PFp30OdJuh9Io2I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TKgLKchj0M2J0iuQmqXSqUWCoYQm6TPNBN0iXLoiZBKXNpre4Sj53MnbvUWXZ3r2t
	 iVCWfIYzImclgQKYVK8lB8sno1fsaANSmNe2iaxsRG+Pr870THAx5WNDMvfKCdrGoy
	 9E7aoNUalblBYYG1aDQsTkTZ0t5FXz0eL540jMwSuM7bSYkgN5WWf3qtuX6q3CRW+P
	 r6tncOKT6vLGu1WDQmsowoyVNv/QNYN/7rHkKZYOW3kvuAMsnSBesqNqce83zZDSly
	 Y9KFGizXslgowGVca9XI3aFjtfhTatDPbUyVpc4zQ2otHxvlGKK3ymHN6KMWNWpTXe
	 TniUdByJUnBfQ==
Date: Tue, 18 Feb 2025 16:55:16 -0800
Subject: [PATCH 07/12] xfs: create fuzz tests for metadata directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992588190.4078751.15589074585657780588.stgit@frogsfrogsfrogs>
In-Reply-To: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
References: <173992588005.4078751.14049444240868988139.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create fuzz tests to make sure that all the validation works for
metadata directories and subdirectories.  The metadir fuzzer tests are
tagged 'realtime' to force creation of an interesting metadata directory
tree full of rtgroups inodes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/xfs         |   22 ++++++++++++++++++++++
 tests/xfs/1546     |   34 ++++++++++++++++++++++++++++++++++
 tests/xfs/1546.out |    4 ++++
 tests/xfs/1547     |   34 ++++++++++++++++++++++++++++++++++
 tests/xfs/1547.out |    4 ++++
 tests/xfs/1548     |   34 ++++++++++++++++++++++++++++++++++
 tests/xfs/1548.out |    4 ++++
 tests/xfs/1549     |   35 +++++++++++++++++++++++++++++++++++
 tests/xfs/1549.out |    4 ++++
 tests/xfs/1550     |   34 ++++++++++++++++++++++++++++++++++
 tests/xfs/1550.out |    4 ++++
 tests/xfs/1551     |   34 ++++++++++++++++++++++++++++++++++
 tests/xfs/1551.out |    4 ++++
 tests/xfs/1552     |   34 ++++++++++++++++++++++++++++++++++
 tests/xfs/1552.out |    4 ++++
 tests/xfs/1553     |   35 +++++++++++++++++++++++++++++++++++
 tests/xfs/1553.out |    4 ++++
 17 files changed, 328 insertions(+)
 create mode 100755 tests/xfs/1546
 create mode 100644 tests/xfs/1546.out
 create mode 100755 tests/xfs/1547
 create mode 100644 tests/xfs/1547.out
 create mode 100755 tests/xfs/1548
 create mode 100644 tests/xfs/1548.out
 create mode 100755 tests/xfs/1549
 create mode 100644 tests/xfs/1549.out
 create mode 100755 tests/xfs/1550
 create mode 100644 tests/xfs/1550.out
 create mode 100755 tests/xfs/1551
 create mode 100644 tests/xfs/1551.out
 create mode 100755 tests/xfs/1552
 create mode 100644 tests/xfs/1552.out
 create mode 100755 tests/xfs/1553
 create mode 100644 tests/xfs/1553.out


diff --git a/common/xfs b/common/xfs
index eb4d99c91a8019..771ef90633c6de 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1956,3 +1956,25 @@ _xfs_calc_hidden_quota_files() {
 		echo 0
 	fi
 }
+
+_require_xfs_mkfs_metadir()
+{
+	_scratch_mkfs_xfs_supported -m metadir=1 >/dev/null 2>&1 || \
+		_notrun "mkfs.xfs doesn't have metadir features"
+}
+
+_require_xfs_scratch_metadir()
+{
+	_require_xfs_mkfs_metadir
+	_require_scratch
+
+	_scratch_mkfs -m metadir=1 &> /dev/null
+	_require_scratch_xfs_features METADIR
+	_try_scratch_mount
+	res=$?
+	if [ $res -ne 0 ]; then
+		_notrun "mounting with metadir not supported by filesystem type: $FSTYP"
+	else
+		_scratch_unmount
+	fi
+}
diff --git a/tests/xfs/1546 b/tests/xfs/1546
new file mode 100755
index 00000000000000..482ea0ef6ea6be
--- /dev/null
+++ b/tests/xfs/1546
@@ -0,0 +1,34 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1546
+#
+# Populate a XFS filesystem and fuzz every metadir root field.
+# Use xfs_scrub to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /')
+
+echo "Fuzz metadir root"
+_scratch_xfs_fuzz_metadata '' 'online' 'path -m /' >> $seqres.full
+echo "Done fuzzing metadir root"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1546.out b/tests/xfs/1546.out
new file mode 100644
index 00000000000000..b72891a7583c04
--- /dev/null
+++ b/tests/xfs/1546.out
@@ -0,0 +1,4 @@
+QA output created by 1546
+Format and populate
+Fuzz metadir root
+Done fuzzing metadir root
diff --git a/tests/xfs/1547 b/tests/xfs/1547
new file mode 100755
index 00000000000000..799c9f355c48a3
--- /dev/null
+++ b/tests/xfs/1547
@@ -0,0 +1,34 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1547
+#
+# Populate a XFS filesystem and fuzz every metadir root field.
+# Use xfs_repair to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers repair fuzzers_repair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /')
+
+echo "Fuzz metadir root"
+_scratch_xfs_fuzz_metadata '' 'offline' 'path -m /' >> $seqres.full
+echo "Done fuzzing metadir root"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1547.out b/tests/xfs/1547.out
new file mode 100644
index 00000000000000..983cc01343e5f4
--- /dev/null
+++ b/tests/xfs/1547.out
@@ -0,0 +1,4 @@
+QA output created by 1547
+Format and populate
+Fuzz metadir root
+Done fuzzing metadir root
diff --git a/tests/xfs/1548 b/tests/xfs/1548
new file mode 100755
index 00000000000000..9175ff1e95e224
--- /dev/null
+++ b/tests/xfs/1548
@@ -0,0 +1,34 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1548
+#
+# Populate a XFS filesystem and fuzz every metadir root field.
+# Do not fix the filesystem, to test metadata verifiers.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers fuzzers_norepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /')
+
+echo "Fuzz metadir root"
+_scratch_xfs_fuzz_metadata '' 'none' 'path -m /' >> $seqres.full
+echo "Done fuzzing metadir root"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1548.out b/tests/xfs/1548.out
new file mode 100644
index 00000000000000..9e395bb059436d
--- /dev/null
+++ b/tests/xfs/1548.out
@@ -0,0 +1,4 @@
+QA output created by 1548
+Format and populate
+Fuzz metadir root
+Done fuzzing metadir root
diff --git a/tests/xfs/1549 b/tests/xfs/1549
new file mode 100755
index 00000000000000..da0312d788cc3f
--- /dev/null
+++ b/tests/xfs/1549
@@ -0,0 +1,35 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1549
+#
+# Populate a XFS filesystem and fuzz every metadir root field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /')
+
+echo "Fuzz metadir root"
+_scratch_xfs_fuzz_metadata '' 'both' 'path -m /' >> $seqres.full
+echo "Done fuzzing metadir root"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1549.out b/tests/xfs/1549.out
new file mode 100644
index 00000000000000..22b3d215e32e7b
--- /dev/null
+++ b/tests/xfs/1549.out
@@ -0,0 +1,4 @@
+QA output created by 1549
+Format and populate
+Fuzz metadir root
+Done fuzzing metadir root
diff --git a/tests/xfs/1550 b/tests/xfs/1550
new file mode 100755
index 00000000000000..cbd6c7207a36f4
--- /dev/null
+++ b/tests/xfs/1550
@@ -0,0 +1,34 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1550
+#
+# Populate a XFS filesystem and fuzz every metadir subdir field.
+# Use xfs_scrub to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers scrub fuzzers_online_repair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /rtgroups')
+
+echo "Fuzz metadir subdir"
+_scratch_xfs_fuzz_metadata '' 'online' 'path -m /rtgroups' >> $seqres.full
+echo "Done fuzzing metadir subdir"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1550.out b/tests/xfs/1550.out
new file mode 100644
index 00000000000000..7694cd670bd25b
--- /dev/null
+++ b/tests/xfs/1550.out
@@ -0,0 +1,4 @@
+QA output created by 1550
+Format and populate
+Fuzz metadir subdir
+Done fuzzing metadir subdir
diff --git a/tests/xfs/1551 b/tests/xfs/1551
new file mode 100755
index 00000000000000..ec5fd010fc7cc7
--- /dev/null
+++ b/tests/xfs/1551
@@ -0,0 +1,34 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1551
+#
+# Populate a XFS filesystem and fuzz every metadir subdir field.
+# Use xfs_repair to fix the corruption.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers repair fuzzers_repair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /rtgroups')
+
+echo "Fuzz metadir subdir"
+_scratch_xfs_fuzz_metadata '' 'offline' 'path -m /rtgroups' >> $seqres.full
+echo "Done fuzzing metadir subdir"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1551.out b/tests/xfs/1551.out
new file mode 100644
index 00000000000000..4c3360d08b34f8
--- /dev/null
+++ b/tests/xfs/1551.out
@@ -0,0 +1,4 @@
+QA output created by 1551
+Format and populate
+Fuzz metadir subdir
+Done fuzzing metadir subdir
diff --git a/tests/xfs/1552 b/tests/xfs/1552
new file mode 100755
index 00000000000000..4350f69200541e
--- /dev/null
+++ b/tests/xfs/1552
@@ -0,0 +1,34 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1552
+#
+# Populate a XFS filesystem and fuzz every metadir subdir field.
+# Do not fix the filesystem, to test metadata verifiers.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers fuzzers_norepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /rtgroups')
+
+echo "Fuzz metadir subdir"
+_scratch_xfs_fuzz_metadata '' 'none' 'path -m /rtgroups' >> $seqres.full
+echo "Done fuzzing metadir subdir"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1552.out b/tests/xfs/1552.out
new file mode 100644
index 00000000000000..6636b1b656c926
--- /dev/null
+++ b/tests/xfs/1552.out
@@ -0,0 +1,4 @@
+QA output created by 1552
+Format and populate
+Fuzz metadir subdir
+Done fuzzing metadir subdir
diff --git a/tests/xfs/1553 b/tests/xfs/1553
new file mode 100755
index 00000000000000..7591411d4b638a
--- /dev/null
+++ b/tests/xfs/1553
@@ -0,0 +1,35 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022-2025 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1553
+#
+# Populate a XFS filesystem and fuzz every metadir subdir field.
+# Try online repair and, if necessary, offline repair,
+# to test the most likely usage pattern.
+
+. ./common/preamble
+_begin_fstest dangerous_fuzzers scrub repair fuzzers_bothrepair realtime
+
+_register_cleanup "_cleanup" BUS
+
+. ./common/filter
+. ./common/populate
+. ./common/fuzzy
+
+_require_xfs_scratch_metadir
+_require_scratch_xfs_fuzz_fields
+_disable_dmesg_check
+
+echo "Format and populate"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+inode_ver=$(_scratch_xfs_get_metadata_field "core.version" 'path -m /rtgroups')
+
+echo "Fuzz metadir subdir"
+_scratch_xfs_fuzz_metadata '' 'both' 'path -m /rtgroups' >> $seqres.full
+echo "Done fuzzing metadir subdir"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1553.out b/tests/xfs/1553.out
new file mode 100644
index 00000000000000..0298fcfddbf15a
--- /dev/null
+++ b/tests/xfs/1553.out
@@ -0,0 +1,4 @@
+QA output created by 1553
+Format and populate
+Fuzz metadir subdir
+Done fuzzing metadir subdir


