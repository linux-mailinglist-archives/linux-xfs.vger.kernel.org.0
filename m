Return-Path: <linux-xfs+bounces-9427-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E2DD90C0C2
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2024 02:52:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 34E31B215B8
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2024 00:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 801A71C2A8;
	Tue, 18 Jun 2024 00:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b89NaJBs"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB451BF3A;
	Tue, 18 Jun 2024 00:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671919; cv=none; b=RG5mYaHKGDLEhE3BbSxN4kI2mgpLjqWUg8ans42EF0vao4mNHiJ5LxigxPssq+zSSsGyHtvyE6B0hB8elwRAFdwyXrLF4WxB96ejR2uJ6fnkoKkcUDD56isny/bWGC1YoEEcLfyHom71Rdovj4k6AFXdzoSGZavZ7o45G31z/KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671919; c=relaxed/simple;
	bh=8VC3MszTXgxplXoFUbK/Xb0oi4VFlYatnyA4UBXVwEc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R0Qycsh8nEZjknHZ54i835HiC/m/1w5wemOAAXyRKoQ9SkGSyCwgXuPFqukkYTjRe+qadLl6oRktwl17qM24Djkd8f4BEBFMeNtkY+NYNLGCE1iZ/SOH6skyeAtGZc13/FKohdjcTpzd6MpVQC4MxGIyL378FENrMERi9wki7t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b89NaJBs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEEEC4AF1D;
	Tue, 18 Jun 2024 00:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718671918;
	bh=8VC3MszTXgxplXoFUbK/Xb0oi4VFlYatnyA4UBXVwEc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b89NaJBswD65/bswnn28L891gM8txSOYLnqgpdXrz8rw/MLmjQOjywBf7ExcA7FvT
	 82do3sE/dbave36Mq2SmFabaUsAvYn2f3/na6rQ70sp1uVeiVd9oRoVQ54/uK2qEMo
	 JIXvfbHc9yYmuNMY7Pt97JObkaHpZ0Dsf9Ed6BvzH8oK28KCXsAjRw6Btg8RYij+1S
	 rYZPJQhrQ1SVsrbTCZkbM3TDpD4dV2+HxgAFwmVG3xLKrX62UU8ScvEN0FkKGA5cNQ
	 Vlsf6zFG/yRfrM9w3Y23w8J7xT3Em9f3jmEMlpS1A/Bjkf3A4btk1geeWRd/jSJUB9
	 Bgq47+12DLYpQ==
Date: Mon, 17 Jun 2024 17:51:58 -0700
Subject: [PATCH 10/11] xfs: add multi link parent pointer test
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Catherine Hoang <catherine.hoang@oracle.com>, fstests@vger.kernel.org,
 guan@eryu.me, linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
 catherine.hoang@oracle.com
Message-ID: <171867145960.793846.8382128634634633132.stgit@frogsfrogsfrogs>
In-Reply-To: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Add a test to verify parent pointers while multiple links to a file are
created and removed.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/1852     |   69 ++++
 tests/xfs/1852.out | 1002 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 1071 insertions(+)
 create mode 100755 tests/xfs/1852
 create mode 100644 tests/xfs/1852.out


diff --git a/tests/xfs/1852 b/tests/xfs/1852
new file mode 100755
index 0000000000..a5a9c75552
--- /dev/null
+++ b/tests/xfs/1852
@@ -0,0 +1,69 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022-2024 Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 1852
+#
+# multi link parent pointer test
+#
+. ./common/preamble
+_begin_fstest auto quick parent
+
+# get standard environment, filters and checks
+. ./common/parent
+
+# Modify as appropriate
+_supported_fs xfs
+_require_scratch
+_require_xfs_sysfs debug/larp
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
+file1 ---755 3 1 /dev/null
+: done
+$
+EOF
+
+_scratch_mkfs -f -n parent=1 -p $protofile >>$seqresres.full 2>&1 \
+	|| _fail "mkfs failed"
+_check_scratch_fs
+
+_scratch_mount >>$seqres.full 2>&1 \
+	|| _fail "mount failed"
+
+testfolder1="testfolder1"
+file1="file1"
+file1_ln="file1_link"
+
+echo ""
+# Multi link parent pointer test
+NLINKS=100
+for (( j=0; j<$NLINKS; j++ )); do
+	ln $SCRATCH_MNT/$testfolder1/$file1 $SCRATCH_MNT/$testfolder1/$file1_ln.$j
+	_verify_parent "$testfolder1" "$file1_ln.$j" "$testfolder1/$file1"
+	_verify_parent "$testfolder1" "$file1" "$testfolder1/$file1_ln.$j"
+done
+# Multi unlink parent pointer test
+for (( j=$NLINKS-1; j<=0; j-- )); do
+	ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder1/$file1_ln.$j)"
+	rm $SCRATCH_MNT/$testfolder1/$file1_ln.$j
+	_verify_no_parent "$file1_ln.$j" "$ino" "$testfolder1/$file1"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1852.out b/tests/xfs/1852.out
new file mode 100644
index 0000000000..a13664d481
--- /dev/null
+++ b/tests/xfs/1852.out
@@ -0,0 +1,1002 @@
+QA output created by 1852
+
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.0 OK
+*** Verified parent pointer: name:file1_link.0, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.0 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.0
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.1 OK
+*** Verified parent pointer: name:file1_link.1, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.1 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.1
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.2 OK
+*** Verified parent pointer: name:file1_link.2, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.2 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.2
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.3 OK
+*** Verified parent pointer: name:file1_link.3, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.3 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.3
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.4 OK
+*** Verified parent pointer: name:file1_link.4, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.4 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.4
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.5 OK
+*** Verified parent pointer: name:file1_link.5, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.5 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.5
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.6 OK
+*** Verified parent pointer: name:file1_link.6, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.6 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.6
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.7 OK
+*** Verified parent pointer: name:file1_link.7, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.7 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.7
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.8 OK
+*** Verified parent pointer: name:file1_link.8, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.8 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.8
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.9 OK
+*** Verified parent pointer: name:file1_link.9, namelen:12
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.9 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.9
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.10 OK
+*** Verified parent pointer: name:file1_link.10, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.10 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.10
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.11 OK
+*** Verified parent pointer: name:file1_link.11, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.11 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.11
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.12 OK
+*** Verified parent pointer: name:file1_link.12, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.12 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.12
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.13 OK
+*** Verified parent pointer: name:file1_link.13, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.13 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.13
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.14 OK
+*** Verified parent pointer: name:file1_link.14, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.14 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.14
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.15 OK
+*** Verified parent pointer: name:file1_link.15, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.15 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.15
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.16 OK
+*** Verified parent pointer: name:file1_link.16, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.16 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.16
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.17 OK
+*** Verified parent pointer: name:file1_link.17, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.17 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.17
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.18 OK
+*** Verified parent pointer: name:file1_link.18, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.18 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.18
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.19 OK
+*** Verified parent pointer: name:file1_link.19, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.19 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.19
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.20 OK
+*** Verified parent pointer: name:file1_link.20, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.20 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.20
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.21 OK
+*** Verified parent pointer: name:file1_link.21, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.21 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.21
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.22 OK
+*** Verified parent pointer: name:file1_link.22, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.22 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.22
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.23 OK
+*** Verified parent pointer: name:file1_link.23, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.23 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.23
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.24 OK
+*** Verified parent pointer: name:file1_link.24, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.24 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.24
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.25 OK
+*** Verified parent pointer: name:file1_link.25, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.25 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.25
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.26 OK
+*** Verified parent pointer: name:file1_link.26, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.26 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.26
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.27 OK
+*** Verified parent pointer: name:file1_link.27, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.27 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.27
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.28 OK
+*** Verified parent pointer: name:file1_link.28, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.28 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.28
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.29 OK
+*** Verified parent pointer: name:file1_link.29, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.29 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.29
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.30 OK
+*** Verified parent pointer: name:file1_link.30, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.30 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.30
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.31 OK
+*** Verified parent pointer: name:file1_link.31, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.31 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.31
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.32 OK
+*** Verified parent pointer: name:file1_link.32, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.32 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.32
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.33 OK
+*** Verified parent pointer: name:file1_link.33, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.33 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.33
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.34 OK
+*** Verified parent pointer: name:file1_link.34, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.34 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.34
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.35 OK
+*** Verified parent pointer: name:file1_link.35, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.35 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.35
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.36 OK
+*** Verified parent pointer: name:file1_link.36, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.36 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.36
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.37 OK
+*** Verified parent pointer: name:file1_link.37, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.37 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.37
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.38 OK
+*** Verified parent pointer: name:file1_link.38, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.38 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.38
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.39 OK
+*** Verified parent pointer: name:file1_link.39, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.39 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.39
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.40 OK
+*** Verified parent pointer: name:file1_link.40, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.40 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.40
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.41 OK
+*** Verified parent pointer: name:file1_link.41, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.41 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.41
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.42 OK
+*** Verified parent pointer: name:file1_link.42, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.42 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.42
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.43 OK
+*** Verified parent pointer: name:file1_link.43, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.43 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.43
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.44 OK
+*** Verified parent pointer: name:file1_link.44, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.44 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.44
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.45 OK
+*** Verified parent pointer: name:file1_link.45, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.45 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.45
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.46 OK
+*** Verified parent pointer: name:file1_link.46, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.46 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.46
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.47 OK
+*** Verified parent pointer: name:file1_link.47, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.47 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.47
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.48 OK
+*** Verified parent pointer: name:file1_link.48, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.48 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.48
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.49 OK
+*** Verified parent pointer: name:file1_link.49, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.49 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.49
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.50 OK
+*** Verified parent pointer: name:file1_link.50, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.50 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.50
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.51 OK
+*** Verified parent pointer: name:file1_link.51, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.51 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.51
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.52 OK
+*** Verified parent pointer: name:file1_link.52, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.52 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.52
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.53 OK
+*** Verified parent pointer: name:file1_link.53, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.53 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.53
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.54 OK
+*** Verified parent pointer: name:file1_link.54, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.54 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.54
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.55 OK
+*** Verified parent pointer: name:file1_link.55, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.55 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.55
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.56 OK
+*** Verified parent pointer: name:file1_link.56, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.56 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.56
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.57 OK
+*** Verified parent pointer: name:file1_link.57, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.57 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.57
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.58 OK
+*** Verified parent pointer: name:file1_link.58, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.58 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.58
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.59 OK
+*** Verified parent pointer: name:file1_link.59, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.59 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.59
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.60 OK
+*** Verified parent pointer: name:file1_link.60, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.60 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.60
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.61 OK
+*** Verified parent pointer: name:file1_link.61, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.61 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.61
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.62 OK
+*** Verified parent pointer: name:file1_link.62, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.62 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.62
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.63 OK
+*** Verified parent pointer: name:file1_link.63, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.63 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.63
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.64 OK
+*** Verified parent pointer: name:file1_link.64, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.64 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.64
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.65 OK
+*** Verified parent pointer: name:file1_link.65, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.65 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.65
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.66 OK
+*** Verified parent pointer: name:file1_link.66, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.66 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.66
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.67 OK
+*** Verified parent pointer: name:file1_link.67, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.67 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.67
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.68 OK
+*** Verified parent pointer: name:file1_link.68, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.68 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.68
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.69 OK
+*** Verified parent pointer: name:file1_link.69, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.69 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.69
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.70 OK
+*** Verified parent pointer: name:file1_link.70, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.70 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.70
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.71 OK
+*** Verified parent pointer: name:file1_link.71, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.71 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.71
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.72 OK
+*** Verified parent pointer: name:file1_link.72, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.72 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.72
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.73 OK
+*** Verified parent pointer: name:file1_link.73, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.73 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.73
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.74 OK
+*** Verified parent pointer: name:file1_link.74, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.74 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.74
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.75 OK
+*** Verified parent pointer: name:file1_link.75, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.75 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.75
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.76 OK
+*** Verified parent pointer: name:file1_link.76, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.76 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.76
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.77 OK
+*** Verified parent pointer: name:file1_link.77, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.77 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.77
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.78 OK
+*** Verified parent pointer: name:file1_link.78, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.78 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.78
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.79 OK
+*** Verified parent pointer: name:file1_link.79, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.79 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.79
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.80 OK
+*** Verified parent pointer: name:file1_link.80, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.80 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.80
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.81 OK
+*** Verified parent pointer: name:file1_link.81, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.81 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.81
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.82 OK
+*** Verified parent pointer: name:file1_link.82, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.82 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.82
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.83 OK
+*** Verified parent pointer: name:file1_link.83, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.83 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.83
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.84 OK
+*** Verified parent pointer: name:file1_link.84, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.84 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.84
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.85 OK
+*** Verified parent pointer: name:file1_link.85, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.85 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.85
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.86 OK
+*** Verified parent pointer: name:file1_link.86, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.86 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.86
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.87 OK
+*** Verified parent pointer: name:file1_link.87, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.87 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.87
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.88 OK
+*** Verified parent pointer: name:file1_link.88, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.88 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.88
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.89 OK
+*** Verified parent pointer: name:file1_link.89, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.89 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.89
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.90 OK
+*** Verified parent pointer: name:file1_link.90, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.90 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.90
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.91 OK
+*** Verified parent pointer: name:file1_link.91, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.91 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.91
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.92 OK
+*** Verified parent pointer: name:file1_link.92, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.92 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.92
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.93 OK
+*** Verified parent pointer: name:file1_link.93, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.93 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.93
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.94 OK
+*** Verified parent pointer: name:file1_link.94, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.94 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.94
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.95 OK
+*** Verified parent pointer: name:file1_link.95, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.95 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.95
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.96 OK
+*** Verified parent pointer: name:file1_link.96, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.96 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.96
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.97 OK
+*** Verified parent pointer: name:file1_link.97, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.97 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.97
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.98 OK
+*** Verified parent pointer: name:file1_link.98, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.98 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.98
+*** testfolder1 OK
+*** testfolder1/file1 OK
+*** testfolder1/file1_link.99 OK
+*** Verified parent pointer: name:file1_link.99, namelen:13
+*** Parent pointer OK for child testfolder1/file1
+*** testfolder1 OK
+*** testfolder1/file1_link.99 OK
+*** testfolder1/file1 OK
+*** Verified parent pointer: name:file1, namelen:5
+*** Parent pointer OK for child testfolder1/file1_link.99


