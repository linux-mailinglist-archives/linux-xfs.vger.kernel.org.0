Return-Path: <linux-xfs+bounces-18854-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EB98A27D54
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Feb 2025 22:27:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5214165A59
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Feb 2025 21:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D183C21A432;
	Tue,  4 Feb 2025 21:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mcRfGqkX"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5302045B8;
	Tue,  4 Feb 2025 21:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704436; cv=none; b=rv/xFbGAA6l3FrSujeRDUxtyTCr4VCftxgYVYeo/TXHek/iRAbmrx5yg0j+VerzQPO1A+DRWmtQdI0m8jWQ9akVCEcD2X9JEOiCXiaFl6U/6FYuaygiDgUetEF4JPxY2sTi0Tktr17MNlD5H2OFWuhIXhB5UhWBrpx0bzzJUYAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704436; c=relaxed/simple;
	bh=9bUbXzQebn0U292FyKJe4fVw1oR0I/uGXZ1OIsaISCY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E5wmF3UtyVdc+6iCpB8vn12jLixpiEMuYJF4LgQrK6LA3jRdkMayJRAPFhLJZTgzPy648cFVWoG754Xk9CaH3DN/y1+ZC2ETvcbSr/1BJwoSn1KCQFMTmYz+4UBa6VskLKaD0ag/L4nNIt0FiGRQy+6V4gIVz/hdvsGEde7A0iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mcRfGqkX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A02BC4CEDF;
	Tue,  4 Feb 2025 21:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704436;
	bh=9bUbXzQebn0U292FyKJe4fVw1oR0I/uGXZ1OIsaISCY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mcRfGqkXrCI+UreLTVJ50FDR/C0ylNAy4ov+tgiCTsydu13P4SyP+e8fvn4DCADnZ
	 VWbkaVFZQgRds5EA/pO+nrD3dtwwlYlN4O5XHWq8pOEAxKVxFQkxffAGDEf+cgEBWA
	 5JQHcFkIQX6PArrjx8YtbX94DFMmddxFo2RLcxooNHuoQW6cdb/CWoZ9/BmBzGZ51r
	 3qTyZOJR4oEfQGwqQgD2ZslynAyPuBYSpO40U5aY2uElMvGWLCQBY5ObHhq1u5Q6KI
	 jEh//i0EBxXd2kK/ch+1tqJiwni5XWlebKD5E9gBQD6xckxQ/wRRltBuL1VTT17W45
	 H9hFXfzyHUBiQ==
Date: Tue, 04 Feb 2025 13:27:15 -0800
Subject: [PATCH 19/34] mkfs: don't hardcode log size
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406396.546134.3531267570648312988.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Commit 000813899afb46 hardcoded a log size of 256MB into xfs/501,
xfs/502, and generic/530.  This seems to be an attempt to reduce test
run times by increasing the log size so that more background threads can
run in parallel.  Unfortunately, this breaks a couple of my test
configurations:

 - External logs smaller than 256MB
 - Internal logs where the AG size is less than 256MB

For example, here's seqres.full from a failed xfs/501 invocation:

** mkfs failed with extra mkfs options added to " -m metadir=2,autofsck=1,uquota,gquota,pquota, -d rtinherit=1," by test 501 **
** attempting to mkfs using only test 501 options: -l size=256m **
size 256m specified for log subvolume is too large, maximum is 32768 blocks
<snip>
mount -ortdev=/dev/sdb4 -ologdev=/dev/sdb2 /dev/sda4 /opt failed
umount: /dev/sda4: not mounted.

Note that there's some formatting error here, so we jettison the entire
rt configuration to force the log size option, but then mount fails
because we didn't edit out the rtdev option there too.

Fortunately, mkfs.xfs already /has/ a few options to try to improve
parallelism in the filesystem by avoiding contention on the log grant
heads by scaling up the log size.  These options are aware of log and AG
size constraints so they won't conflict with other geometry options.

Use them.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 000813899afb46 ("fstests: scale some tests for high CPU count sanity")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/rc         |   27 +++++++++++++++++++++++++++
 tests/generic/530 |    6 +-----
 tests/generic/531 |    6 +-----
 tests/xfs/501     |    2 +-
 tests/xfs/502     |    2 +-
 5 files changed, 31 insertions(+), 12 deletions(-)


diff --git a/common/rc b/common/rc
index b78d903fe34ba3..03603a5198e3b6 100644
--- a/common/rc
+++ b/common/rc
@@ -688,6 +688,33 @@ _test_cycle_mount()
     _test_mount
 }
 
+# Are there mkfs options to try to improve concurrency?
+_scratch_mkfs_concurrency_options()
+{
+	local nr_cpus=$(getconf _NPROCESSORS_CONF)
+
+	case "$FSTYP" in
+	xfs)
+		# If any concurrency options are already specified, don't
+		# compute our own conflicting ones.
+		echo "$SCRATCH_OPTIONS $MKFS_OPTIONS" | \
+			grep -q 'concurrency=' &&
+			return
+
+		local sections=(d r)
+
+		# -l concurrency does not work with external logs
+		test _has_logdev || sections+=(l)
+
+		for section in "${sections[@]}"; do
+			$MKFS_XFS_PROG -$section concurrency=$nr_cpus 2>&1 | \
+				grep -q "unknown option -$section" ||
+				echo "-$section concurrency=$nr_cpus "
+		done
+		;;
+	esac
+}
+
 _scratch_mkfs_options()
 {
     _scratch_options mkfs
diff --git a/tests/generic/530 b/tests/generic/530
index f2513156a920e8..b2aab4f354e9f3 100755
--- a/tests/generic/530
+++ b/tests/generic/530
@@ -25,11 +25,7 @@ _require_test_program "t_open_tmpfiles"
 # For XFS, pushing 50000 unlinked inode inactivations through a small xfs log
 # can result in bottlenecks on the log grant heads, so try to make the log
 # larger to reduce runtime.
-if [ "$FSTYP" = "xfs" ] && ! _has_logdev; then
-    _scratch_mkfs "-l size=256m" >> $seqres.full 2>&1
-else
-    _scratch_mkfs >> $seqres.full 2>&1
-fi
+_scratch_mkfs $(_scratch_mkfs_concurrency_options) >> $seqres.full 2>&1
 _scratch_mount
 
 # Set ULIMIT_NOFILE to min(file-max / 2, 50000 files per LOAD_FACTOR)
diff --git a/tests/generic/531 b/tests/generic/531
index ed6c3f91153ecc..07dffd9fd5108d 100755
--- a/tests/generic/531
+++ b/tests/generic/531
@@ -23,11 +23,7 @@ _require_test_program "t_open_tmpfiles"
 
 # On high CPU count machines, this runs a -lot- of create and unlink
 # concurrency. Set the filesytsem up to handle this.
-if [ $FSTYP = "xfs" ]; then
-	_scratch_mkfs "-d agcount=32" >> $seqres.full 2>&1
-else
-	_scratch_mkfs >> $seqres.full 2>&1
-fi
+_scratch_mkfs $(_scratch_mkfs_concurrency_options) >> $seqres.full 2>&1
 _scratch_mount
 
 # Try to load up all the CPUs, two threads per CPU.
diff --git a/tests/xfs/501 b/tests/xfs/501
index 678c51b52948c5..c62ec443848797 100755
--- a/tests/xfs/501
+++ b/tests/xfs/501
@@ -33,7 +33,7 @@ _require_xfs_sysfs debug/log_recovery_delay
 _require_scratch
 _require_test_program "t_open_tmpfiles"
 
-_scratch_mkfs "-l size=256m" >> $seqres.full 2>&1
+_scratch_mkfs $(_scratch_mkfs_concurrency_options) >> $seqres.full 2>&1
 _scratch_mount
 
 # Set ULIMIT_NOFILE to min(file-max / 2, 30000 files per LOAD_FACTOR)
diff --git a/tests/xfs/502 b/tests/xfs/502
index 10b0017f6b2eb2..ebfb5ce883c378 100755
--- a/tests/xfs/502
+++ b/tests/xfs/502
@@ -23,7 +23,7 @@ _require_xfs_io_error_injection "iunlink_fallback"
 _require_scratch
 _require_test_program "t_open_tmpfiles"
 
-_scratch_mkfs "-l size=256m" | _filter_mkfs 2> $tmp.mkfs > /dev/null
+_scratch_mkfs $(_scratch_mkfs_concurrency_options) | _filter_mkfs 2> $tmp.mkfs > /dev/null
 cat $tmp.mkfs >> $seqres.full
 . $tmp.mkfs
 


