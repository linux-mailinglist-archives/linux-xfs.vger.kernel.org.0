Return-Path: <linux-xfs+bounces-9025-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E8DC48D8AC9
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 22:13:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 746161F25700
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 20:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8700A13B297;
	Mon,  3 Jun 2024 20:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E4JR5csA"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4397A135A5A;
	Mon,  3 Jun 2024 20:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717445579; cv=none; b=PI+IumIEMWEm8h0EkWd3EqUoG1Oi/hUfWf4E2aocTApQM2HcYjskJjoAaud4iVtO4cUBcus8H3CV6eNumZAYZBMXZZ1+K/NMV3btPX2j7vQ5+WftoB2xgXuICt5V070al5fW3/cRdfDTYU4vpnzEJ2UBSxlQ+z0AzMWVX1Xprrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717445579; c=relaxed/simple;
	bh=ZVimQVAloOqafW58RB0wIcmRVU9xwk2tnDHvv8k+Ufc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cIMYXMns1wy5wfi3sm7D1IK7Luk2mKRzPDdQKEAtXVdeN+Hkuok7zlNtLvCx4r1v3py7j/btWrm3i5mTnBNVB7VXmHohjM7IKJlO0bpN2TsLheIZs1aZ8WxWRNbcwA0Tq2VNJSAjfV1/bZJFpiMtRX00HMUq9PxPv/0XW1ZHetQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E4JR5csA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A85BC2BD10;
	Mon,  3 Jun 2024 20:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717445579;
	bh=ZVimQVAloOqafW58RB0wIcmRVU9xwk2tnDHvv8k+Ufc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E4JR5csAi/qq8mIfcmT8o6qP5sjQ04eDXUfhAzvPf6IzvIORqc9VZkF+INJd2rdtM
	 hQ/uRRnLLizy1n44hlbS71P9PVpSHnLnokuQ6rEV2wD9wuuKTEydWMSSjbwterzSIa
	 GkRqdHDGJbALFQ1l/DQ/6V8Dhsz3f3uvEwYcE4b3QsriVg1nd94p8UY4HPW9a0Pk+Z
	 N5R64isIZYZNZfnCCqPgKYLgRfJxYTSuXCRTEq8Pm91Em59I6+IRQgSjy6W6rLPcD/
	 ni2Rof6FIKxv2kCqj3pgEvaVcl7Rg3XZb1zeO+b5caQsWdLXfeXs8QL+gdCz6DEH3D
	 6vPdfIH0e8bkw==
Date: Mon, 03 Jun 2024 13:12:58 -0700
Subject: [PATCH 3/3] fuzzy: test other dquot ids
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <171744525469.1532034.305765196235167428.stgit@frogsfrogsfrogs>
In-Reply-To: <171744525419.1532034.11916603461335062550.stgit@frogsfrogsfrogs>
References: <171744525419.1532034.11916603461335062550.stgit@frogsfrogsfrogs>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/fuzzy    |   14 ++++++++++++++
 common/populate |   14 ++++++++++++++
 tests/xfs/425   |   10 +++++++---
 tests/xfs/426   |   10 +++++++---
 tests/xfs/427   |   10 +++++++---
 tests/xfs/428   |   10 +++++++---
 tests/xfs/429   |   10 +++++++---
 tests/xfs/430   |   10 +++++++---
 tests/xfs/487   |   10 +++++++---
 tests/xfs/488   |   10 +++++++---
 tests/xfs/489   |   10 +++++++---
 tests/xfs/779   |   10 +++++++---
 tests/xfs/780   |   10 +++++++---
 tests/xfs/781   |   10 +++++++---
 14 files changed, 112 insertions(+), 36 deletions(-)


diff --git a/common/fuzzy b/common/fuzzy
index ed79dbc7e5..5621b98b7f 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -680,6 +680,20 @@ _scratch_xfs_set_xattr_fuzz_types() {
 	SCRATCH_XFS_XATTR_FUZZ_TYPES=(EXTENTS_REMOTE3K EXTENTS_REMOTE4K LEAF NODE)
 }
 
+# Sets the array SCRATCH_XFS_QUOTA_FUZZ_IDS to the list of dquot ids available
+# for fuzzing.  By default, this list contains 0 (root), 4242 (non-root), and
+# 8484 (zero counts).  Users can override this by setting
+# SCRATCH_XFS_LIST_FUZZ_QUOTAIDS in the environment.
+_scratch_xfs_set_quota_fuzz_ids() {
+	if [ -n "${SCRATCH_XFS_LIST_FUZZ_QUOTAIDS}" ]; then
+		mapfile -t SCRATCH_XFS_QUOTA_FUZZ_IDS < \
+				<(echo "${SCRATCH_XFS_LIST_FUZZ_QUOTAIDS}" | tr '[ ,]' '[\n\n]')
+		return
+	fi
+
+	SCRATCH_XFS_QUOTA_FUZZ_IDS=(0 4242 8484)
+}
+
 # Grab the list of available fuzzing verbs
 _scratch_xfs_list_fuzz_verbs() {
 	if [ -n "${SCRATCH_XFS_LIST_FUZZ_VERBS}" ]; then
diff --git a/common/populate b/common/populate
index 33f2db8d4a..15f8055c2c 100644
--- a/common/populate
+++ b/common/populate
@@ -360,6 +360,20 @@ _scratch_xfs_populate() {
 	mknod "${SCRATCH_MNT}/S_IFBLK" b 1 1
 	mknod "${SCRATCH_MNT}/S_IFIFO" p
 
+	# non-root dquot
+	local nonroot_id=4242
+	echo "${nonroot_id}" > "${SCRATCH_MNT}/non_root_dquot"
+	chown "${nonroot_id}:${nonroot_id}" "${SCRATCH_MNT}/non_root_dquot"
+	$XFS_IO_PROG -c "chproj ${nonroot_id}" "${SCRATCH_MNT}/non_root_dquot"
+
+	# empty dquot
+	local empty_id=8484
+	echo "${empty_id}" > "${SCRATCH_MNT}/empty_dquot"
+	chown "${empty_id}:${empty_id}" "${SCRATCH_MNT}/empty_dquot"
+	$XFS_IO_PROG -c "chproj ${empty_id}" "${SCRATCH_MNT}/empty_dquot"
+	chown "0:0" "${SCRATCH_MNT}/empty_dquot"
+	$XFS_IO_PROG -c "chproj 0" "${SCRATCH_MNT}/empty_dquot"
+
 	# special file with an xattr
 	setfacl -P -m u:nobody:r ${SCRATCH_MNT}/S_IFCHR
 
diff --git a/tests/xfs/425 b/tests/xfs/425
index c2e16ee87e..5275e594b2 100755
--- a/tests/xfs/425
+++ b/tests/xfs/425
@@ -27,9 +27,13 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 echo "${MOUNT_OPTIONS}" | grep -q 'usrquota' || _notrun "user quota disabled"
 
-echo "Fuzz user 0 dquot"
-_scratch_xfs_fuzz_metadata '' 'offline'  "dquot -u 0" >> $seqres.full
-echo "Done fuzzing dquot"
+_scratch_xfs_set_quota_fuzz_ids
+
+for id in "${SCRATCH_XFS_QUOTA_FUZZ_IDS[@]}"; do
+	echo "Fuzz user $id dquot"
+	_scratch_xfs_fuzz_metadata '' 'offline'  "dquot -u $id" >> $seqres.full
+	echo "Done fuzzing dquot"
+done
 
 # success, all done
 status=0
diff --git a/tests/xfs/426 b/tests/xfs/426
index e52b15f28d..06f0f44b62 100755
--- a/tests/xfs/426
+++ b/tests/xfs/426
@@ -27,9 +27,13 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 echo "${MOUNT_OPTIONS}" | grep -q 'usrquota' || _notrun "user quota disabled"
 
-echo "Fuzz user 0 dquot"
-_scratch_xfs_fuzz_metadata '' 'online'  "dquot -u 0" >> $seqres.full
-echo "Done fuzzing dquot"
+_scratch_xfs_set_quota_fuzz_ids
+
+for id in "${SCRATCH_XFS_QUOTA_FUZZ_IDS[@]}"; do
+	echo "Fuzz user $id dquot"
+	_scratch_xfs_fuzz_metadata '' 'online'  "dquot -u $id" >> $seqres.full
+	echo "Done fuzzing dquot"
+done
 
 # success, all done
 status=0
diff --git a/tests/xfs/427 b/tests/xfs/427
index 19f45fbd81..327cddd879 100755
--- a/tests/xfs/427
+++ b/tests/xfs/427
@@ -27,9 +27,13 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 echo "${MOUNT_OPTIONS}" | grep -q 'grpquota' || _notrun "group quota disabled"
 
-echo "Fuzz group 0 dquot"
-_scratch_xfs_fuzz_metadata '' 'offline'  "dquot -g 0" >> $seqres.full
-echo "Done fuzzing dquot"
+_scratch_xfs_set_quota_fuzz_ids
+
+for id in "${SCRATCH_XFS_QUOTA_FUZZ_IDS[@]}"; do
+	echo "Fuzz group $id dquot"
+	_scratch_xfs_fuzz_metadata '' 'offline'  "dquot -g $id" >> $seqres.full
+	echo "Done fuzzing dquot"
+done
 
 # success, all done
 status=0
diff --git a/tests/xfs/428 b/tests/xfs/428
index 338e659df2..80b05b8450 100755
--- a/tests/xfs/428
+++ b/tests/xfs/428
@@ -27,9 +27,13 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 echo "${MOUNT_OPTIONS}" | grep -q 'grpquota' || _notrun "group quota disabled"
 
-echo "Fuzz group 0 dquot"
-_scratch_xfs_fuzz_metadata '' 'online'  "dquot -g 0" >> $seqres.full
-echo "Done fuzzing dquot"
+_scratch_xfs_set_quota_fuzz_ids
+
+for id in "${SCRATCH_XFS_QUOTA_FUZZ_IDS[@]}"; do
+	echo "Fuzz group $id dquot"
+	_scratch_xfs_fuzz_metadata '' 'online'  "dquot -g $id" >> $seqres.full
+	echo "Done fuzzing dquot"
+done
 
 # success, all done
 status=0
diff --git a/tests/xfs/429 b/tests/xfs/429
index a4aeb6e440..5fa3b2ce29 100755
--- a/tests/xfs/429
+++ b/tests/xfs/429
@@ -27,9 +27,13 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 echo "${MOUNT_OPTIONS}" | grep -q 'prjquota' || _notrun "project quota disabled"
 
-echo "Fuzz project 0 dquot"
-_scratch_xfs_fuzz_metadata '' 'offline'  "dquot -p 0" >> $seqres.full
-echo "Done fuzzing dquot"
+_scratch_xfs_set_quota_fuzz_ids
+
+for id in "${SCRATCH_XFS_QUOTA_FUZZ_IDS[@]}"; do
+	echo "Fuzz project $id dquot"
+	_scratch_xfs_fuzz_metadata '' 'offline'  "dquot -p $id" >> $seqres.full
+	echo "Done fuzzing dquot"
+done
 
 # success, all done
 status=0
diff --git a/tests/xfs/430 b/tests/xfs/430
index d94f65bd14..6f5c772dfb 100755
--- a/tests/xfs/430
+++ b/tests/xfs/430
@@ -27,9 +27,13 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 echo "${MOUNT_OPTIONS}" | grep -q 'prjquota' || _notrun "project quota disabled"
 
-echo "Fuzz project 0 dquot"
-_scratch_xfs_fuzz_metadata '' 'online'  "dquot -p 0" >> $seqres.full
-echo "Done fuzzing dquot"
+_scratch_xfs_set_quota_fuzz_ids
+
+for id in "${SCRATCH_XFS_QUOTA_FUZZ_IDS[@]}"; do
+	echo "Fuzz project $id dquot"
+	_scratch_xfs_fuzz_metadata '' 'online'  "dquot -p $id" >> $seqres.full
+	echo "Done fuzzing dquot"
+done
 
 # success, all done
 status=0
diff --git a/tests/xfs/487 b/tests/xfs/487
index 337541bbcd..a688593950 100755
--- a/tests/xfs/487
+++ b/tests/xfs/487
@@ -28,9 +28,13 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 echo "${MOUNT_OPTIONS}" | grep -q 'usrquota' || _notrun "user quota disabled"
 
-echo "Fuzz user 0 dquot"
-_scratch_xfs_fuzz_metadata '' 'none'  "dquot -u 0" >> $seqres.full
-echo "Done fuzzing dquot"
+_scratch_xfs_set_quota_fuzz_ids
+
+for id in "${SCRATCH_XFS_QUOTA_FUZZ_IDS[@]}"; do
+	echo "Fuzz user $id dquot"
+	_scratch_xfs_fuzz_metadata '' 'none'  "dquot -u $id" >> $seqres.full
+	echo "Done fuzzing dquot"
+done
 
 # success, all done
 status=0
diff --git a/tests/xfs/488 b/tests/xfs/488
index 4347768964..0d54ab8c7d 100755
--- a/tests/xfs/488
+++ b/tests/xfs/488
@@ -28,9 +28,13 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 echo "${MOUNT_OPTIONS}" | grep -q 'grpquota' || _notrun "group quota disabled"
 
-echo "Fuzz group 0 dquot"
-_scratch_xfs_fuzz_metadata '' 'none'  "dquot -g 0" >> $seqres.full
-echo "Done fuzzing dquot"
+_scratch_xfs_set_quota_fuzz_ids
+
+for id in "${SCRATCH_XFS_QUOTA_FUZZ_IDS[@]}"; do
+	echo "Fuzz group $id dquot"
+	_scratch_xfs_fuzz_metadata '' 'none'  "dquot -g $id" >> $seqres.full
+	echo "Done fuzzing dquot"
+done
 
 # success, all done
 status=0
diff --git a/tests/xfs/489 b/tests/xfs/489
index c70e674ccc..012416f989 100755
--- a/tests/xfs/489
+++ b/tests/xfs/489
@@ -28,9 +28,13 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 echo "${MOUNT_OPTIONS}" | grep -q 'prjquota' || _notrun "project quota disabled"
 
-echo "Fuzz project 0 dquot"
-_scratch_xfs_fuzz_metadata '' 'none'  "dquot -p 0" >> $seqres.full
-echo "Done fuzzing dquot"
+_scratch_xfs_set_quota_fuzz_ids
+
+for id in "${SCRATCH_XFS_QUOTA_FUZZ_IDS[@]}"; do
+	echo "Fuzz project $id dquot"
+	_scratch_xfs_fuzz_metadata '' 'none'  "dquot -p $id" >> $seqres.full
+	echo "Done fuzzing dquot"
+done
 
 # success, all done
 status=0
diff --git a/tests/xfs/779 b/tests/xfs/779
index fe0de3087a..05f2718632 100755
--- a/tests/xfs/779
+++ b/tests/xfs/779
@@ -29,9 +29,13 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 echo "${MOUNT_OPTIONS}" | grep -q 'usrquota' || _notrun "user quota disabled"
 
-echo "Fuzz user 0 dquot"
-_scratch_xfs_fuzz_metadata '' 'both'  "dquot -u 0" >> $seqres.full
-echo "Done fuzzing dquot"
+_scratch_xfs_set_quota_fuzz_ids
+
+for id in "${SCRATCH_XFS_QUOTA_FUZZ_IDS[@]}"; do
+	echo "Fuzz user $id dquot"
+	_scratch_xfs_fuzz_metadata '' 'both'  "dquot -u $id" >> $seqres.full
+	echo "Done fuzzing dquot"
+done
 
 # success, all done
 status=0
diff --git a/tests/xfs/780 b/tests/xfs/780
index 0a23473538..9dd8f4527e 100755
--- a/tests/xfs/780
+++ b/tests/xfs/780
@@ -29,9 +29,13 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 echo "${MOUNT_OPTIONS}" | grep -q 'grpquota' || _notrun "group quota disabled"
 
-echo "Fuzz group 0 dquot"
-_scratch_xfs_fuzz_metadata '' 'both'  "dquot -g 0" >> $seqres.full
-echo "Done fuzzing dquot"
+_scratch_xfs_set_quota_fuzz_ids
+
+for id in "${SCRATCH_XFS_QUOTA_FUZZ_IDS[@]}"; do
+	echo "Fuzz group $id dquot"
+	_scratch_xfs_fuzz_metadata '' 'both'  "dquot -g $id" >> $seqres.full
+	echo "Done fuzzing dquot"
+done
 
 # success, all done
 status=0
diff --git a/tests/xfs/781 b/tests/xfs/781
index ada0f8a1ca..604c9bdd87 100755
--- a/tests/xfs/781
+++ b/tests/xfs/781
@@ -29,9 +29,13 @@ echo "Format and populate"
 _scratch_populate_cached nofill > $seqres.full 2>&1
 echo "${MOUNT_OPTIONS}" | grep -q 'prjquota' || _notrun "project quota disabled"
 
-echo "Fuzz project 0 dquot"
-_scratch_xfs_fuzz_metadata '' 'both'  "dquot -p 0" >> $seqres.full
-echo "Done fuzzing dquot"
+_scratch_xfs_set_quota_fuzz_ids
+
+for id in "${SCRATCH_XFS_QUOTA_FUZZ_IDS[@]}"; do
+	echo "Fuzz project $id dquot"
+	_scratch_xfs_fuzz_metadata '' 'both'  "dquot -p $id" >> $seqres.full
+	echo "Done fuzzing dquot"
+done
 
 # success, all done
 status=0


