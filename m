Return-Path: <linux-xfs+bounces-14021-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A1959999A3
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2024 03:39:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FFF32851C5
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2024 01:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B843FDF59;
	Fri, 11 Oct 2024 01:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OGllhbG1"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7314BD299;
	Fri, 11 Oct 2024 01:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610781; cv=none; b=ZyMVRVzV8+2/rsq2cU8l9pOZbBswv6Gr4XCWZQ+tBKDfwgvzpznt8QwayM8z8mfmE8dA1oKoXeGxBHJoXFWESYDjfnxEJZ7/zwPMhPaXUol9Zi4ONL6HlLAcfHrV7Yy8eEruKSccYYh/Mh5hSDOjfvLuukJoQvdwzZxHv8XNpok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610781; c=relaxed/simple;
	bh=iW2B/Ed1s1NWQsPBl0AWYn2XHxnQCdibQ4fvROy2dSg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yo4S28sAnlT8LxtsFk64Uxsu3AFz13PUe1lipTK06S0JmM5lzOK8GMhdo891hvxIGPnlu5mTZ8VK8LGVqXSiDTIL9XYCs16GmoVufu6vuA3vJOejnQcBwbL87jHYFyYCWxRQQGUxEGnufGJ2mCF34/8nCXZdXu6dnPHtTVYIR0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OGllhbG1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D978C4CEC5;
	Fri, 11 Oct 2024 01:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610781;
	bh=iW2B/Ed1s1NWQsPBl0AWYn2XHxnQCdibQ4fvROy2dSg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OGllhbG1l86XTdT8B0tJrBOsbcgpQvYifJ2Fk7Pzss6Nz/JtYkMVJJTlFwLHKtMpU
	 IKEcMHHt5DFnMCyYhjCIODfpP6ACbQGjvAZPamWNcx40CmoNq23Yo3JA0YMLMcrW98
	 OnOl0MmP/1TXubm4LnWXXipv11mhwKJwwtmkj0HFxQQxBFgziZwe0PHBFsK7Lq36s7
	 G06EmmeYnvCXLBSrTQ66LJvWrkEZfpI2TCpmdXnX+aPXL1B18KJtx2pEs55RZ7xbrB
	 ZyoQjrrgRiqD3yxHaW2lprL0YtkM+VE0tMFsrUEE2yM3y+l71gxQTejqLDMewqctcT
	 7zh/pF7sZRfhw==
Date: Thu, 10 Oct 2024 18:39:40 -0700
Subject: [PATCH 06/11] xfs/{050,144,153,299,330}: update quota reports to
 handle metadir trees
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, fstests@vger.kernel.org
Message-ID: <172860658088.4187056.15515963882798325572.stgit@frogsfrogsfrogs>
In-Reply-To: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
References: <172860657983.4187056.5472629319415849070.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Prior to the new metadir feature in XFS, the rtbitmap and rtsummary
files were included in icount, though their bcount contribution is zero
due to rt and quota not being supported together.  With the new metadir
feature in XFS, no files in the metadata directory tree are counted in
quota.

Hence we must adjust the icount of any quota report down by two to avoid
breaking golden outputs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/filter |    7 +++++--
 common/xfs    |   29 +++++++++++++++++++++++++++++
 tests/xfs/050 |    5 +++++
 tests/xfs/153 |    5 +++++
 tests/xfs/299 |    1 +
 tests/xfs/330 |    6 +++++-
 6 files changed, 50 insertions(+), 3 deletions(-)


diff --git a/common/filter b/common/filter
index 36d51bd957dd53..03f60672c0e106 100644
--- a/common/filter
+++ b/common/filter
@@ -618,11 +618,14 @@ _filter_getcap()
 
 # Filter user/group/project id numbers out of quota reports, and standardize
 # the block counts to use filesystem block size.  Callers must set the id and
-# bsize variables before calling this function.
+# bsize variables before calling this function.  The HIDDEN_QUOTA_FILES variable
+# (by default zero) is the number of root files to filter out of the inode
+# count part of the quota report.
 _filter_quota_report()
 {
 	test -n "$id" || echo "id must be set"
 	test -n "$bsize" || echo "block size must be set"
+	test -n "$HIDDEN_QUOTA_FILES" || HIDDEN_QUOTA_FILES=0
 
 	tr -s '[:space:]' | \
 	perl -npe '
@@ -630,7 +633,7 @@ _filter_quota_report()
 		s/^\#0 \d+ /[ROOT] 0 /g;
 		s/6 days/7 days/g' |
 	perl -npe '
-		$val = 0;
+		$val = '"$HIDDEN_QUOTA_FILES"';
 		if ($ENV{'LARGE_SCRATCH_DEV'}) {
 			$val = $ENV{'NUM_SPACE_FILES'};
 		}
diff --git a/common/xfs b/common/xfs
index 20217ea7365a4d..f95a5a6d1d970e 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1900,3 +1900,32 @@ _scratch_xfs_force_no_metadir()
 		MKFS_OPTIONS="-m metadir=0 $MKFS_OPTIONS"
 	fi
 }
+
+# Decide if a mount filesystem has metadata directory trees.
+_xfs_mount_has_metadir() {
+	local mount="$1"
+
+	# spaceman (and its info command) predate metadir
+	test ! -e "$XFS_SPACEMAN_PROG" && return 1
+	$XFS_SPACEMAN_PROG -c "info" "$mount" | grep -q 'metadir=1'
+}
+
+# Compute the number of files that are not counted in quotas.
+_xfs_calc_hidden_quota_files() {
+	local mount="$1"
+
+	if _xfs_mount_has_metadir "$mount"; then
+		# Prior to the metadir feature, the realtime bitmap and summary
+		# file were "owned" by root and hence accounted to the root
+		# dquots.  The metadata directory feature stopped accounting
+		# metadata files to quotas, so we must subtract 2 inodes from
+		# the repquota golden outputs to keep the tests going.
+		#
+		# We needn't adjust the block counts because the kernel doesn't
+		# support rt quota and hence the rt metadata files will always
+		# be zero length.
+		echo -2
+	else
+		echo 0
+	fi
+}
diff --git a/tests/xfs/050 b/tests/xfs/050
index 7baaaeaa3efcf9..4ce56d375e945b 100755
--- a/tests/xfs/050
+++ b/tests/xfs/050
@@ -30,9 +30,14 @@ _require_scratch
 _require_xfs_quota
 
 _scratch_mkfs >/dev/null 2>&1
+orig_mntopts="$MOUNT_OPTIONS"
+_qmount_option "uquota"
 _scratch_mount
 bsize=$(_get_file_block_size $SCRATCH_MNT)
+# needs quota enabled to compute the number of metadata dir files
+HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
 _scratch_unmount
+MOUNT_OPTIONS="$orig_mntopts"
 
 bsoft=$(( 200 * $bsize ))
 bhard=$(( 1000 * $bsize ))
diff --git a/tests/xfs/153 b/tests/xfs/153
index d5e43082c1cd35..2ce22b8c44b298 100755
--- a/tests/xfs/153
+++ b/tests/xfs/153
@@ -35,9 +35,14 @@ _require_idmapped_mounts
 _require_test_program "vfs/mount-idmapped"
 
 _scratch_mkfs >/dev/null 2>&1
+orig_mntopts="$MOUNT_OPTIONS"
+_qmount_option "uquota"
 _scratch_mount
 bsize=$(_get_file_block_size $SCRATCH_MNT)
+# needs quota enabled to compute the number of metadata dir files
+HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
 _scratch_unmount
+MOUNT_OPTIONS="$orig_mntopts"
 
 bsoft=$(( 200 * $bsize ))
 bhard=$(( 1000 * $bsize ))
diff --git a/tests/xfs/299 b/tests/xfs/299
index 710eb89c2ac0e7..3986f8fb904e5d 100755
--- a/tests/xfs/299
+++ b/tests/xfs/299
@@ -155,6 +155,7 @@ _qmount_option "uquota,gquota,pquota"
 _qmount
 
 bsize=$(_get_file_block_size $SCRATCH_MNT)
+HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
 
 bsoft=$(( 100 * $bsize ))
 bhard=$(( 500 * $bsize ))
diff --git a/tests/xfs/330 b/tests/xfs/330
index d239a64085c76c..30c09ff5906e12 100755
--- a/tests/xfs/330
+++ b/tests/xfs/330
@@ -24,7 +24,10 @@ _require_nobody
 
 do_repquota()
 {
-	repquota $SCRATCH_MNT | grep -E '^(fsgqa|root|nobody)' | sort -r
+	repquota $SCRATCH_MNT | grep -E '^(fsgqa|root|nobody)' | sort -r | \
+	perl -npe '
+		$val = '"$HIDDEN_QUOTA_FILES"';
+		s/(^root\s+--\s+\S+\s+\S+\s+\S+\s+)(\S+)/$1@{[$2 - $val]}/g'
 }
 
 rm -f "$seqres.full"
@@ -33,6 +36,7 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
 _scratch_mount >> "$seqres.full" 2>&1
+HIDDEN_QUOTA_FILES=$(_xfs_calc_hidden_quota_files $SCRATCH_MNT)
 quotacheck -u -g $SCRATCH_MNT 2> /dev/null
 quotaon $SCRATCH_MNT 2> /dev/null
 


