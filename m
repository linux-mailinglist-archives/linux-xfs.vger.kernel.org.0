Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9EC603631
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Oct 2022 00:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiJRWpg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Oct 2022 18:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiJRWpf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2022 18:45:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E885600A;
        Tue, 18 Oct 2022 15:45:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2993C61716;
        Tue, 18 Oct 2022 22:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8459AC433D6;
        Tue, 18 Oct 2022 22:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666133133;
        bh=qrHimkfpB18sMOElNhiaurTTeLbXNgfGQzLygwWG86k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lqK1mEYrjMANuuK8dX1wJ4xPiJCFpOY5QJ4QzCXa6OriqAC/hhctT4T1jsy7H/1XP
         YIEkJj6mzdozUQNOkFrB3iQcL7JuPVod5kQtNtY6a2KRjzVLaf6QhOtrsxRXcOuTJg
         rXq5RVQKsnRKPlPpSotmq85ohCxZ+88MIzdnCadgGNIl4cS0gZsBrk2MqkNAX1TBFf
         nkf2NZqgBE/51h0+kZcf8R7S8U3QW/0ZK+PPypWdiWqnXGfStiFtf/IwvSVurtuLbd
         Jy6jjEF9pLkwi71qhk7DMVPzbRYQcYkPi9bX7JUJPXHbbGwa4K42YOxualubm84u59
         6BviaLxDaHEJA==
Subject: [PATCH 2/3] xfs: refactor filesystem directory block size extraction
 logic
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 18 Oct 2022 15:45:33 -0700
Message-ID: <166613313311.868141.4422818901647278371.stgit@magnolia>
In-Reply-To: <166613312194.868141.5162859918517610030.stgit@magnolia>
References: <166613312194.868141.5162859918517610030.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There are a lot of places where we open-code determining the directory
block size for a specific filesystem.  Refactor this into a single
helper to clean up existing tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    4 ++--
 common/xfs      |    9 +++++++++
 tests/xfs/099   |    2 +-
 tests/xfs/100   |    2 +-
 tests/xfs/101   |    2 +-
 tests/xfs/102   |    2 +-
 tests/xfs/105   |    2 +-
 tests/xfs/112   |    2 +-
 tests/xfs/113   |    2 +-
 9 files changed, 18 insertions(+), 9 deletions(-)


diff --git a/common/populate b/common/populate
index 9fa1a06798..23b2fecf69 100644
--- a/common/populate
+++ b/common/populate
@@ -175,7 +175,7 @@ _scratch_xfs_populate() {
 	_xfs_force_bdev data $SCRATCH_MNT
 
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
-	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
 	crc="$(_xfs_has_feature "$SCRATCH_MNT" crc -v)"
 	if [ $crc -eq 1 ]; then
 		leaf_hdr_size=64
@@ -602,7 +602,7 @@ _scratch_xfs_populate_check() {
 	is_reflink=$(_xfs_has_feature "$SCRATCH_MNT" reflink -v)
 
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
-	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+	dblksz="$(_xfs_get_dir_blocksize "$SCRATCH_MNT")"
 	leaf_lblk="$((32 * 1073741824 / blksz))"
 	node_lblk="$((64 * 1073741824 / blksz))"
 	umount "${SCRATCH_MNT}"
diff --git a/common/xfs b/common/xfs
index c7496bce3f..6445bfd9db 100644
--- a/common/xfs
+++ b/common/xfs
@@ -203,6 +203,15 @@ _xfs_is_realtime_file()
 	$XFS_IO_PROG -c 'stat -v' "$1" | grep -q -w realtime
 }
 
+# Get the directory block size of a mounted filesystem.
+_xfs_get_dir_blocksize()
+{
+	local fs="$1"
+
+	$XFS_INFO_PROG "$fs" | grep 'naming.*bsize' | \
+		sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g'
+}
+
 # Set or clear the realtime status of every supplied path.  The first argument
 # is either 'data' or 'realtime'.  All other arguments should be paths to
 # existing directories or empty regular files.
diff --git a/tests/xfs/099 b/tests/xfs/099
index a7eaff6e0c..82bef8ad26 100755
--- a/tests/xfs/099
+++ b/tests/xfs/099
@@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
 nr="$((dblksz / 40))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/100 b/tests/xfs/100
index 79da8cb02c..e638b4ba17 100755
--- a/tests/xfs/100
+++ b/tests/xfs/100
@@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
 nr="$((dblksz / 12))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/101 b/tests/xfs/101
index 64f4705aca..11ed329110 100755
--- a/tests/xfs/101
+++ b/tests/xfs/101
@@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
 nr="$((dblksz / 12))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/102 b/tests/xfs/102
index 24dce43058..43f4539181 100755
--- a/tests/xfs/102
+++ b/tests/xfs/102
@@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
 nr="$((16 * dblksz / 40))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/105 b/tests/xfs/105
index 22a8bf9fb0..002a712883 100755
--- a/tests/xfs/105
+++ b/tests/xfs/105
@@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
 nr="$((16 * dblksz / 40))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/112 b/tests/xfs/112
index bc1ab62895..e2d5932da6 100755
--- a/tests/xfs/112
+++ b/tests/xfs/112
@@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
 nr="$((16 * dblksz / 40))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/113 b/tests/xfs/113
index e820ed96da..9bb2cd304b 100755
--- a/tests/xfs/113
+++ b/tests/xfs/113
@@ -37,7 +37,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
 nr="$((128 * dblksz / 40))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"

