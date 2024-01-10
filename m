Return-Path: <linux-xfs+bounces-2682-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 895FC8283DE
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jan 2024 11:21:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BC022879A2
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jan 2024 10:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5098B36B11;
	Tue,  9 Jan 2024 10:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="egkBk60W"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EC136AED;
	Tue,  9 Jan 2024 10:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0ADDC433C7;
	Tue,  9 Jan 2024 10:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704795679;
	bh=x7IgayICm6Hex/YlLffkZCic7vju9DGwjBnBDNvTxSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egkBk60WOWJBvMWhJUVbuFfNLRGhXEk0zmPta4YQXHOQh5YxTE02UgJUEoAMKHgOI
	 HaAE+CfAtSuzTwIhioUYTbrFbX8xL6n/jDpbn1buVpVZJE95HoDT7OYOsR1u4GhT/o
	 0biUQnjngV04s2AO4xPmgabh9R6q9FV/sq7PZm/VFAIpsW2GdVaRBRg613rkUgiHeI
	 doygBNkEhCl5DWOyEK13AdSgQ8UdqP8UJcbS13l+zM3iAruahiLL65b1GLdqCiiW54
	 7GHL7rewEg8FXww20nMKJdPxV5y+S16alofgMFWbAViiqMXR2zGhDsUOTOrKsnu9qx
	 4n5/sxxdR4Iyw==
From: Chandan Babu R <chandanbabu@kernel.org>
To: fstests@vger.kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	zlang@redhat.com
Subject: [PATCH V2 4/5] xfs: Add support for testing metadump v2
Date: Tue,  9 Jan 2024 15:50:46 +0530
Message-ID: <20240109102054.1668192-5-chandanbabu@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240109102054.1668192-1-chandanbabu@kernel.org>
References: <20240109102054.1668192-1-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit adds the ability to test metadump v2 to existing metadump tests.

Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 tests/xfs/129     |  97 ++++++++++++++++++++++++++++++++-----
 tests/xfs/129.out |   4 +-
 tests/xfs/234     |  97 ++++++++++++++++++++++++++++++++-----
 tests/xfs/234.out |   4 +-
 tests/xfs/253     | 118 ++++++++++++++++++++++++++++++++++++++--------
 tests/xfs/291     |  25 ++++++++--
 tests/xfs/432     |  29 +++++++++---
 tests/xfs/432.out |   3 +-
 tests/xfs/503     |  94 ++++++++++++++++++++++--------------
 tests/xfs/503.out |  12 ++---
 10 files changed, 381 insertions(+), 102 deletions(-)

diff --git a/tests/xfs/129 b/tests/xfs/129
index 6f2ef564..8a817b41 100755
--- a/tests/xfs/129
+++ b/tests/xfs/129
@@ -16,7 +16,11 @@ _cleanup()
 {
     cd /
     _scratch_unmount > /dev/null 2>&1
-    rm -rf $tmp.* $testdir $metadump_file $TEST_DIR/image
+    [[ -n $logdev && $logdev != "none" && $logdev != $SCRATCH_LOGDEV ]] && \
+	    _destroy_loop_device $logdev
+    [[ -n $datadev ]] && _destroy_loop_device $datadev
+    rm -rf $tmp.* $testdir $metadump_file $TEST_DIR/data-image \
+       $TEST_DIR/log-image
 }
 
 # Import common functions.
@@ -29,12 +33,86 @@ _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
 _require_loop
 _require_scratch_reflink
 
+metadump_file=$TEST_DIR/${seq}_metadump
+
+verify_metadump_v1()
+{
+	local max_version=$1
+	local version=""
+
+	if [[ $max_version == 2 ]]; then
+		version="-v 1"
+	fi
+
+	_scratch_xfs_metadump $metadump_file $version
+
+	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV="" \
+		   _scratch_xfs_mdrestore $metadump_file
+
+	datadev=$(_create_loop_device $TEST_DIR/data-image)
+
+	SCRATCH_DEV=$datadev _scratch_mount
+	SCRATCH_DEV=$datadev _scratch_unmount
+
+	logdev=$SCRATCH_LOGDEV
+	[[ -z $logdev ]] && logdev=none
+	_check_xfs_filesystem $datadev $logdev none
+
+	_destroy_loop_device $datadev
+	datadev=""
+	rm -f $TEST_DIR/data-image
+}
+
+verify_metadump_v2()
+{
+	version="-v 2"
+
+	_scratch_xfs_metadump $metadump_file $version
+
+	# Metadump v2 files can contain contents dumped from an external log
+	# device. Use a temporary file to hold the log device contents restored
+	# from such a metadump file.
+	slogdev=""
+	if [[ -n $SCRATCH_LOGDEV ]]; then
+		slogdev=$TEST_DIR/log-image
+	fi
+
+	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV=$slogdev \
+		   _scratch_xfs_mdrestore $metadump_file
+
+	datadev=$(_create_loop_device $TEST_DIR/data-image)
+
+	logdev=${SCRATCH_LOGDEV}
+	if [[ -s $TEST_DIR/log-image ]]; then
+		logdev=$(_create_loop_device $TEST_DIR/log-image)
+	fi
+
+	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_mount
+	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_unmount
+
+	[[ -z $logdev ]] && logdev=none
+	_check_xfs_filesystem $datadev $logdev none
+
+	if [[ -s $TEST_DIR/log-image ]]; then
+		_destroy_loop_device $logdev
+		logdev=""
+		rm -f $TEST_DIR/log-image
+	fi
+
+	_destroy_loop_device $datadev
+	datadev=""
+	rm -f $TEST_DIR/data-image
+}
+
 _scratch_mkfs >/dev/null 2>&1
+
+max_md_version=1
+_scratch_metadump_v2_supported && max_md_version=2
+
 _scratch_mount
 
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
-metadump_file=$TEST_DIR/${seq}_metadump
 
 echo "Create the original file blocks"
 blksz="$(_get_file_block_size $testdir)"
@@ -47,18 +125,15 @@ seq 1 2 $((nr_blks - 1)) | while read nr; do
 			$testdir/file2 $((nr * blksz)) $blksz >> $seqres.full
 done
 
-echo "Create metadump file"
 _scratch_unmount
-_scratch_xfs_metadump $metadump_file
 
-# Now restore the obfuscated one back and take a look around
-echo "Restore metadump"
-SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
-SCRATCH_DEV=$TEST_DIR/image _scratch_mount
-SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
+echo "Create metadump file, restore it and check restored fs"
 
-echo "Check restored fs"
-_check_generic_filesystem $metadump_file
+verify_metadump_v1 $max_md_version
+
+if [[ $max_md_version == 2 ]]; then
+	verify_metadump_v2
+fi
 
 # success, all done
 status=0
diff --git a/tests/xfs/129.out b/tests/xfs/129.out
index da6f43fd..0f24c431 100644
--- a/tests/xfs/129.out
+++ b/tests/xfs/129.out
@@ -1,6 +1,4 @@
 QA output created by 129
 Create the original file blocks
 Reflink every other block
-Create metadump file
-Restore metadump
-Check restored fs
+Create metadump file, restore it and check restored fs
diff --git a/tests/xfs/234 b/tests/xfs/234
index 57d447c0..c9bdb674 100755
--- a/tests/xfs/234
+++ b/tests/xfs/234
@@ -16,7 +16,11 @@ _cleanup()
 {
     cd /
     _scratch_unmount > /dev/null 2>&1
-    rm -rf $tmp.* $metadump_file $TEST_DIR/image
+    [[ -n $logdev && $logdev != "none" && $logdev != $SCRATCH_LOGDEV ]] && \
+	    _destroy_loop_device $logdev
+    [[ -n $datadev ]] && _destroy_loop_device $datadev
+    rm -rf $tmp.* $testdir $metadump_file $TEST_DIR/image \
+       $TEST_DIR/log-image
 }
 
 # Import common functions.
@@ -29,12 +33,86 @@ _require_loop
 _require_xfs_scratch_rmapbt
 _require_xfs_io_command "fpunch"
 
+metadump_file=$TEST_DIR/${seq}_metadump
+
+verify_metadump_v1()
+{
+	local max_version=$1
+	local version=""
+
+	if [[ $max_version == 2 ]]; then
+		version="-v 1"
+	fi
+
+	_scratch_xfs_metadump $metadump_file $version
+
+	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV="" \
+		   _scratch_xfs_mdrestore $metadump_file
+
+	datadev=$(_create_loop_device $TEST_DIR/data-image)
+
+	SCRATCH_DEV=$datadev _scratch_mount
+	SCRATCH_DEV=$datadev _scratch_unmount
+
+	logdev=$SCRATCH_LOGDEV
+	[[ -z $logdev ]] && logdev=none
+	_check_xfs_filesystem $datadev $logdev none
+
+	_destroy_loop_device $datadev
+	datadev=""
+	rm -f $TEST_DIR/data-image
+}
+
+verify_metadump_v2()
+{
+	version="-v 2"
+
+	_scratch_xfs_metadump $metadump_file $version
+
+	# Metadump v2 files can contain contents dumped from an external log
+	# device. Use a temporary file to hold the log device contents restored
+	# from such a metadump file.
+	slogdev=""
+	if [[ -n $SCRATCH_LOGDEV ]]; then
+		slogdev=$TEST_DIR/log-image
+	fi
+
+	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV=$slogdev \
+		   _scratch_xfs_mdrestore $metadump_file
+
+	datadev=$(_create_loop_device $TEST_DIR/data-image)
+
+	logdev=${SCRATCH_LOGDEV}
+	if [[ -s $TEST_DIR/log-image ]]; then
+		logdev=$(_create_loop_device $TEST_DIR/log-image)
+	fi
+
+	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_mount
+	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_unmount
+
+	[[ -z $logdev ]] && logdev=none
+	_check_xfs_filesystem $datadev $logdev none
+
+	if [[ -s $TEST_DIR/log-image ]]; then
+		_destroy_loop_device $logdev
+		logdev=""
+		rm -f $TEST_DIR/log-image
+	fi
+
+	_destroy_loop_device $datadev
+	datadev=""
+	rm -f $TEST_DIR/data-image
+}
+
 _scratch_mkfs >/dev/null 2>&1
+
+max_md_version=1
+_scratch_metadump_v2_supported && max_md_version=2
+
 _scratch_mount
 
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
-metadump_file=$TEST_DIR/${seq}_metadump
 
 echo "Create the original file blocks"
 blksz="$(_get_block_size $testdir)"
@@ -47,18 +125,15 @@ seq 1 2 $((nr_blks - 1)) | while read nr; do
 	$XFS_IO_PROG -c "fpunch $((nr * blksz)) $blksz" $testdir/file1 >> $seqres.full
 done
 
-echo "Create metadump file"
 _scratch_unmount
-_scratch_xfs_metadump $metadump_file
 
-# Now restore the obfuscated one back and take a look around
-echo "Restore metadump"
-SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
-SCRATCH_DEV=$TEST_DIR/image _scratch_mount
-SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
+echo "Create metadump file, restore it and check restored fs"
 
-echo "Check restored fs"
-_check_generic_filesystem $metadump_file
+verify_metadump_v1 $max_md_version
+
+if [[ $max_md_version == 2 ]]; then
+	verify_metadump_v2
+fi
 
 # success, all done
 status=0
diff --git a/tests/xfs/234.out b/tests/xfs/234.out
index 463d4660..fc2ddd77 100644
--- a/tests/xfs/234.out
+++ b/tests/xfs/234.out
@@ -1,6 +1,4 @@
 QA output created by 234
 Create the original file blocks
 Punch every other block
-Create metadump file
-Restore metadump
-Check restored fs
+Create metadump file, restore it and check restored fs
diff --git a/tests/xfs/253 b/tests/xfs/253
index ce902477..8e18ddb8 100755
--- a/tests/xfs/253
+++ b/tests/xfs/253
@@ -27,6 +27,9 @@ _cleanup()
     rm -f $tmp.*
     rm -rf "${OUTPUT_DIR}"
     rm -f "${METADUMP_FILE}"
+    [[ -n $logdev && $logdev != $SCRATCH_LOGDEV ]] && \
+	    _destroy_loop_device $logdev
+    [[ -n $datadev ]] && _destroy_loop_device $datadev
 }
 
 # Import common functions.
@@ -49,21 +52,101 @@ function create_file() {
 	touch $(printf "$@")
 }
 
+verify_metadump_v1()
+{
+	local max_version=$1
+	local version=""
+
+	if [[ $max_version == 2 ]]; then
+		version="-v 1"
+	fi
+
+	_scratch_xfs_metadump $METADUMP_FILE $version
+
+	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV="" \
+		   _scratch_xfs_mdrestore $METADUMP_FILE
+
+	datadev=$(_create_loop_device $TEST_DIR/data-image)
+
+	SCRATCH_DEV=$datadev _scratch_mount
+
+	cd "${SCRATCH_MNT}"
+
+	# Get a listing of all the files after obfuscation
+	echo "Metadump v1" >> $seqres.full
+	ls -R >> $seqres.full
+	ls -R | od -c >> $seqres.full
+
+	cd /
+
+	SCRATCH_DEV=$datadev _scratch_unmount
+
+	_destroy_loop_device $datadev
+	datadev=""
+	rm -f $TEST_DIR/data-image
+}
+
+verify_metadump_v2()
+{
+	version="-v 2"
+
+	_scratch_xfs_metadump $METADUMP_FILE $version
+
+	# Metadump v2 files can contain contents dumped from an external log
+	# device. Use a temporary file to hold the log device contents restored
+	# from such a metadump file.
+	slogdev=""
+	if [[ -n $SCRATCH_LOGDEV ]]; then
+		slogdev=$TEST_DIR/log-image
+	fi
+
+	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV=$slogdev \
+		   _scratch_xfs_mdrestore $METADUMP_FILE
+
+	datadev=$(_create_loop_device $TEST_DIR/data-image)
+
+	logdev=${SCRATCH_LOGDEV}
+	if [[ -s $TEST_DIR/log-image ]]; then
+		logdev=$(_create_loop_device $TEST_DIR/log-image)
+	fi
+
+	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_mount
+
+	cd "${SCRATCH_MNT}"
+
+	# Get a listing of all the files after obfuscation
+	echo "Metadump v2" >> $seqres.full
+	ls -R >> $seqres.full
+	ls -R | od -c >> $seqres.full
+
+	cd /
+
+	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_unmount
+
+	if [[ -s $TEST_DIR/log-image ]]; then
+		_destroy_loop_device $logdev
+		logdev=""
+		rm -f $TEST_DIR/log-image
+	fi
+
+	_destroy_loop_device $datadev
+	datadev=""
+	rm -f $TEST_DIR/data-image
+}
+
 echo "Disciplyne of silence is goed."
 
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
-# Initialize and mount the scratch filesystem, then create a bunch
-# of files that exercise the original problem.
+# Initialize and mount the scratch filesystem, then create a bunch of
+# files that exercise the original problem.
 #
 # The problem arose when a file name produced a hash that contained
-# either 0x00 (string terminator) or 0x27 ('/' character) in a
-# spot used to determine a character in an obfuscated name.  This
-# occurred in one of 5 spots at the end of the name, at position
-# (last-4), (last-3), (last-2), (last-1), or (last).
-
-rm -f "${METADUMP_FILE}"
+# either 0x00 (string terminator) or 0x27 ('/' character) in a spot used
+# to determine a character in an obfuscated name.  This occurred in one
+# of 5 spots at the end of the name, at position (last-4), (last-3),
+# (last-2), (last-1), or (last).
 
 mkdir -p "${OUTPUT_DIR}"
 
@@ -78,8 +161,8 @@ create_file 'lmno'		# hash 0x0d9b776f (4-byte name)
 create_file 'pqrstu'		# hash 0x1e5cf9f2 (6-byte name)
 create_file 'abcdefghijklmnopqrstuvwxyz' # a most remarkable word (0x55004ae3)
 
-# Create a short directory name; it won't be obfuscated.  Populate
-# it with some longer named-files.  The first part of the obfuscated
+# Create a short directory name; it won't be obfuscated.  Populate it
+# with some longer named-files.  The first part of the obfuscated
 # filenames should use printable characters.
 mkdir foo
 create_file 'foo/longer_file_name_1'	# hash 0xe83634ec
@@ -149,22 +232,19 @@ ls -R | od -c >> $seqres.full
 cd $here
 
 _scratch_unmount
-_scratch_xfs_metadump $METADUMP_FILE
 
-# Now restore the obfuscated one back and take a look around
-_scratch_xfs_mdrestore "$METADUMP_FILE"
+max_md_version=1
+_scratch_metadump_v2_supported && max_md_version=2
 
-_scratch_mount
+verify_metadump_v1 $max_md_version
 
-# Get a listing of all the files after obfuscation
-cd ${SCRATCH_MNT}
-ls -R >> $seqres.full
-ls -R | od -c >> $seqres.full
+if [[ $max_md_version == 2 ]]; then
+	verify_metadump_v2
+fi
 
 # Finally, re-make the filesystem since to ensure we don't
 # leave a directory with duplicate entries lying around.
 cd /
-_scratch_unmount
 _scratch_mkfs >/dev/null 2>&1
 
 # all done
diff --git a/tests/xfs/291 b/tests/xfs/291
index 54448497..33193eb7 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -92,10 +92,27 @@ _scratch_xfs_check >> $seqres.full 2>&1 || _fail "xfs_check failed"
 
 # Yes they can!  Now...
 # Can xfs_metadump cope with this monster?
-_scratch_xfs_metadump $tmp.metadump -a -o || _fail "xfs_metadump failed"
-SCRATCH_DEV=$tmp.img _scratch_xfs_mdrestore $tmp.metadump || _fail "xfs_mdrestore failed"
-SCRATCH_DEV=$tmp.img _scratch_xfs_repair -f &>> $seqres.full || \
-	_fail "xfs_repair of metadump failed"
+max_md_version=1
+_scratch_metadump_v2_supported && max_md_version=2
+
+for md_version in $(seq 1 $max_md_version); do
+	version=""
+	if [[ $max_md_version == 2 ]]; then
+		version="-v $md_version"
+	fi
+
+	_scratch_xfs_metadump $tmp.metadump -a -o $version || \
+		_fail "xfs_metadump failed"
+
+	slogdev=$SCRATCH_LOGDEV
+	if [[ -z $version || $version == "-v 1" ]]; then
+		slogdev=""
+	fi
+	SCRATCH_DEV=$tmp.img SCRATCH_LOGDEV=$slogdev _scratch_xfs_mdrestore \
+		   $tmp.metadump || _fail "xfs_mdrestore failed"
+	SCRATCH_DEV=$tmp.img _scratch_xfs_repair -f &>> $seqres.full || \
+		_fail "xfs_repair of metadump failed"
+done
 
 # Yes it can; success, all done
 status=0
diff --git a/tests/xfs/432 b/tests/xfs/432
index dae68fb2..a215d3ce 100755
--- a/tests/xfs/432
+++ b/tests/xfs/432
@@ -50,6 +50,7 @@ echo "Format and mount"
 # block.  8187 hashes/dablk / 248 dirents/dirblock = ~33 dirblocks per
 # dablock.  33 dirblocks * 64k mean that we can expand a directory by
 # 2112k before we have to allocate another da btree block.
+
 _scratch_mkfs -b size=1k -n size=64k > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
@@ -85,13 +86,29 @@ extlen="$(check_for_long_extent $dir_inum)"
 echo "qualifying extent: $extlen blocks" >> $seqres.full
 test -n "$extlen" || _notrun "could not create dir extent > 1000 blocks"
 
-echo "Try to metadump"
-_scratch_xfs_metadump $metadump_file -a -o -w
-SCRATCH_DEV=$metadump_img _scratch_xfs_mdrestore $metadump_file
+echo "Try to metadump, restore and check restored metadump image"
+max_md_version=1
+_scratch_metadump_v2_supported && max_md_version=2
 
-echo "Check restored metadump image"
-SCRATCH_DEV=$metadump_img _scratch_xfs_repair -n &>> $seqres.full || \
-	echo "xfs_repair on restored fs returned $?"
+for md_version in $(seq 1 $max_md_version); do
+	version=""
+	if [[ $max_md_version == 2 ]]; then
+		version="-v $md_version"
+	fi
+
+	_scratch_xfs_metadump $metadump_file -a -o -w $version
+
+	slogdev=$SCRATCH_LOGDEV
+	if [[ -z $version || $version == "-v 1" ]]; then
+		slogdev=""
+	fi
+
+	SCRATCH_DEV=$metadump_img SCRATCH_LOGDEV=$slogdev \
+		   _scratch_xfs_mdrestore $metadump_file
+
+	SCRATCH_DEV=$metadump_img _scratch_xfs_repair -n &>> $seqres.full || \
+		echo "xfs_repair on restored fs returned $?"
+done
 
 # success, all done
 status=0
diff --git a/tests/xfs/432.out b/tests/xfs/432.out
index 1f135d16..37bac902 100644
--- a/tests/xfs/432.out
+++ b/tests/xfs/432.out
@@ -2,5 +2,4 @@ QA output created by 432
 Format and mount
 Create huge dir
 Check for > 1000 block extent?
-Try to metadump
-Check restored metadump image
+Try to metadump, restore and check restored metadump image
diff --git a/tests/xfs/503 b/tests/xfs/503
index 8805632d..a1479eb6 100755
--- a/tests/xfs/503
+++ b/tests/xfs/503
@@ -29,6 +29,7 @@ testdir=$TEST_DIR/test-$seq
 _supported_fs xfs
 
 _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
+_require_loop
 _require_xfs_copy
 _require_scratch_nocheck
 _require_populate_commands
@@ -40,22 +41,69 @@ _scratch_populate_cached nofill > $seqres.full 2>&1
 
 mkdir -p $testdir
 metadump_file=$testdir/scratch.md
-metadump_file_a=${metadump_file}.a
-metadump_file_g=${metadump_file}.g
-metadump_file_ag=${metadump_file}.ag
 copy_file=$testdir/copy.img
 
-echo metadump
-_scratch_xfs_metadump $metadump_file -a -o >> $seqres.full
+check_restored_metadump_image()
+{
+	local image=$1
 
-echo metadump a
-_scratch_xfs_metadump $metadump_file_a -a >> $seqres.full
+	loop_dev=$(_create_loop_device $image)
+	SCRATCH_DEV=$loop_dev _scratch_mount
+	SCRATCH_DEV=$loop_dev _check_scratch_fs
+	SCRATCH_DEV=$loop_dev _scratch_unmount
+	_destroy_loop_device $loop_dev
+}
 
-echo metadump g
-_scratch_xfs_metadump $metadump_file_g -g >> $seqres.full
+max_md_version=1
+_scratch_metadump_v2_supported && max_md_version=2
 
-echo metadump ag
-_scratch_xfs_metadump $metadump_file_ag -a -g >> $seqres.full
+echo "metadump and mdrestore"
+for md_version in $(seq 1 $max_md_version); do
+	version=""
+	if [[ $max_md_version == 2 ]]; then
+		version="-v $md_version"
+	fi
+
+	_scratch_xfs_metadump $metadump_file -a -o $version >> $seqres.full
+	SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
+	check_restored_metadump_image $TEST_DIR/image
+done
+
+echo "metadump a and mdrestore"
+for md_version in $(seq 1 $max_md_version); do
+	version=""
+	if [[ $max_md_version == 2 ]]; then
+		version="-v $md_version"
+	fi
+
+	_scratch_xfs_metadump $metadump_file -a $version >> $seqres.full
+	SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
+	check_restored_metadump_image $TEST_DIR/image
+done
+
+echo "metadump g and mdrestore"
+for md_version in $(seq 1 $max_md_version); do
+	version=""
+	if [[ $max_md_version == 2 ]]; then
+		version="-v $md_version"
+	fi
+
+	_scratch_xfs_metadump $metadump_file -g $version >> $seqres.full
+	SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
+	check_restored_metadump_image $TEST_DIR/image
+done
+
+echo "metadump ag and mdrestore"
+for md_version in $(seq 1 $max_md_version); do
+	version=""
+	if [[ $max_md_version == 2 ]]; then
+		version="-v $md_version"
+	fi
+
+	_scratch_xfs_metadump $metadump_file -a -g $version >> $seqres.full
+	SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
+	check_restored_metadump_image $TEST_DIR/image
+done
 
 echo copy
 $XFS_COPY_PROG $SCRATCH_DEV $copy_file >> $seqres.full
@@ -67,30 +115,6 @@ _scratch_mount
 _check_scratch_fs
 _scratch_unmount
 
-echo mdrestore
-_scratch_xfs_mdrestore $metadump_file
-_scratch_mount
-_check_scratch_fs
-_scratch_unmount
-
-echo mdrestore a
-_scratch_xfs_mdrestore $metadump_file_a
-_scratch_mount
-_check_scratch_fs
-_scratch_unmount
-
-echo mdrestore g
-_scratch_xfs_mdrestore $metadump_file_g
-_scratch_mount
-_check_scratch_fs
-_scratch_unmount
-
-echo mdrestore ag
-_scratch_xfs_mdrestore $metadump_file_ag
-_scratch_mount
-_check_scratch_fs
-_scratch_unmount
-
 # success, all done
 status=0
 exit
diff --git a/tests/xfs/503.out b/tests/xfs/503.out
index 8ef31dbe..496f2516 100644
--- a/tests/xfs/503.out
+++ b/tests/xfs/503.out
@@ -1,12 +1,8 @@
 QA output created by 503
 Format and populate
-metadump
-metadump a
-metadump g
-metadump ag
+metadump and mdrestore
+metadump a and mdrestore
+metadump g and mdrestore
+metadump ag and mdrestore
 copy
 recopy
-mdrestore
-mdrestore a
-mdrestore g
-mdrestore ag
-- 
2.43.0


