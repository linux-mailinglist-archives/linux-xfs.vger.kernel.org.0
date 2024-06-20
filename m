Return-Path: <linux-xfs+bounces-9586-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 339839113C3
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2024 22:54:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9ED51F227E0
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2024 20:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 289F274E25;
	Thu, 20 Jun 2024 20:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8kUns2S"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DD37350E;
	Thu, 20 Jun 2024 20:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718916859; cv=none; b=q8BU/P0Hid8dYbVe7nVb6u+7cmczNnjJbVNoDqcZXhqGm9Ua7pwyQP2oa7kMNrpggIG+Cfth7Tmq5AjURi+3VZV+j+5GAfLMXu/DtPXPM6lxTHVA5CpiL49TS2472RennMNkNBMK0z5Z6vm+dFmKP9A0Bj6NT0E6WSJs5i0wHdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718916859; c=relaxed/simple;
	bh=r/B1duBFFhSb6RuPmkvzs99d3fVDJX/BzIvr3z5R1H0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eeoefK+cL7K3pnoYvj56V8DUkpaRLsleTfkB4yqglY1bKtcSps3h4O4xeRLD6lRAaDIeQJwDe3Bv7YTqvBQh/Q3VzAJ8KtJl5Y+jNsCtOhyr8WE8377TKY7D24l4Hr5wWmO8rdy5sLZKz3erCc5GfHPWMNAE9Y02Wi7o379uu4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8kUns2S; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B509EC2BD10;
	Thu, 20 Jun 2024 20:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718916859;
	bh=r/B1duBFFhSb6RuPmkvzs99d3fVDJX/BzIvr3z5R1H0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B8kUns2S/ZxrCXJYe2Q/xfx1geFCwsym3SZX9PHzDoJMSSU1VXDlwfXHLZBzndfsE
	 KyTLI6xPgUF4WCyRpHj0b19wvHxZ3NFBk9dJcOOFcmAcW2c1RYojFM6JBL+lYNgNkg
	 RcCZDh0qk3/POmi1vOq+lHMhRI+oVBQDmtRIXag9uHmBSu+btz/DRtdALDiBJTFBhp
	 rPeGp1iLmSGenM0V0Hqe486bGk7tqH5ewuDOfGUA2u5kw1+yNFbJpLJu+H0uysEQhv
	 z4o+BPz1kVp9EKppB+moxH3qyjn2+kGdj6WUTgHjXvc6V9ZXXfiutMrtcTpFOmShTr
	 vCAcC6+RhKd6g==
Date: Thu, 20 Jun 2024 13:54:19 -0700
Subject: [PATCH 01/11] misc: split swapext and exchangerange
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <171891669128.3034840.11871397344083311487.stgit@frogsfrogsfrogs>
In-Reply-To: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
References: <171891669099.3034840.18163174628307465231.stgit@frogsfrogsfrogs>
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

These two commands (and the kernel implementations) are splitting, so we
need to split the xfs_io usage.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 common/rc         |    2 +-
 common/xfs        |    2 +-
 tests/generic/709 |    2 +-
 tests/generic/710 |    2 +-
 tests/generic/711 |    2 +-
 tests/generic/712 |    2 +-
 tests/generic/713 |    4 ++--
 tests/generic/714 |    4 ++--
 tests/generic/715 |    4 ++--
 tests/generic/716 |    2 +-
 tests/generic/717 |    2 +-
 tests/generic/718 |    2 +-
 tests/generic/719 |    2 +-
 tests/generic/720 |    2 +-
 tests/generic/722 |    4 ++--
 tests/generic/723 |    6 +++---
 tests/generic/724 |    4 ++--
 tests/generic/725 |    2 +-
 tests/generic/726 |    2 +-
 tests/generic/727 |    2 +-
 tests/xfs/789     |    2 +-
 tests/xfs/790     |    2 +-
 tests/xfs/791     |    4 ++--
 tests/xfs/792     |    2 +-
 24 files changed, 32 insertions(+), 32 deletions(-)


diff --git a/common/rc b/common/rc
index 163041fea5..9e69af1527 100644
--- a/common/rc
+++ b/common/rc
@@ -2771,7 +2771,7 @@ _require_xfs_io_command()
 			_notrun "xfs_io $command $param kernel support is missing"
 		param_checked="$param"
 		;;
-	"swapext")
+	"swapext"|"exchangerange")
 		$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 128k -b 128k' $testfile > /dev/null
 		$XFS_IO_PROG -f -c 'truncate 128k' $testfile.1 > /dev/null
 		testio=`$XFS_IO_PROG -c "$command $param $testfile.1" $testfile 2>&1`
diff --git a/common/xfs b/common/xfs
index 11481180bd..0b0863f1dc 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1823,7 +1823,7 @@ _require_xfs_scratch_atomicswap()
 {
 	_require_xfs_mkfs_atomicswap
 	_require_scratch
-	_require_xfs_io_command swapext '-v exchrange -a'
+	_require_xfs_io_command exchangerange
 	_scratch_mkfs -m reflink=1 > /dev/null
 	_try_scratch_mount || \
 		_notrun "atomicswap dependencies not supported by scratch filesystem type: $FSTYP"
diff --git a/tests/generic/709 b/tests/generic/709
index 4bd591b873..4fc938bb6a 100755
--- a/tests/generic/709
+++ b/tests/generic/709
@@ -14,7 +14,7 @@ _begin_fstest auto quick fiexchange swapext quota
 . ./common/quota
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v exchrange'
+_require_xfs_io_command swapext
 _require_user
 _require_nobody
 _require_quota
diff --git a/tests/generic/710 b/tests/generic/710
index c7fca05d4c..6c6aa08f63 100755
--- a/tests/generic/710
+++ b/tests/generic/710
@@ -14,7 +14,7 @@ _begin_fstest auto quick fiexchange swapext quota
 . ./common/quota
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v exchrange'
+_require_xfs_io_command swapext
 _require_user
 _require_nobody
 _require_quota
diff --git a/tests/generic/711 b/tests/generic/711
index f1318b30dd..b107f976ef 100755
--- a/tests/generic/711
+++ b/tests/generic/711
@@ -21,7 +21,7 @@ _cleanup()
 . ./common/filter
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v exchrange'
+_require_xfs_io_command swapext
 _require_test
 
 dir=$TEST_DIR/test-$seq
diff --git a/tests/generic/712 b/tests/generic/712
index d4a705478e..f2862c3f8e 100755
--- a/tests/generic/712
+++ b/tests/generic/712
@@ -21,7 +21,7 @@ _cleanup()
 
 # real QA test starts here
 _require_test_program punch-alternating
-_require_xfs_io_command swapext '-v exchrange'
+_require_xfs_io_command exchangerange
 _require_test
 
 dir=$TEST_DIR/test-$seq
diff --git a/tests/generic/713 b/tests/generic/713
index 9b742ee0cb..b2d3260806 100755
--- a/tests/generic/713
+++ b/tests/generic/713
@@ -21,7 +21,7 @@ _cleanup()
 . ./common/reflink
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v exchrange -s 64k -l 64k'
+_require_xfs_io_command exchangerange ' -s 64k -l 64k'
 _require_xfs_io_command "falloc"
 _require_test
 
@@ -36,7 +36,7 @@ filesnap() {
 
 test_swapext_once() {
 	filesnap "$1: before swapext" $dir/$3 $dir/$4
-	$XFS_IO_PROG -c "swapext -v exchrange $2 $dir/$3" $dir/$4
+	$XFS_IO_PROG -c "exchangerange $2 $dir/$3" $dir/$4
 	filesnap "$1: after swapext" $dir/$3 $dir/$4
 	_test_cycle_mount
 	filesnap "$1: after cycling mount" $dir/$3 $dir/$4
diff --git a/tests/generic/714 b/tests/generic/714
index b48a4b7d31..ea963fdfa7 100755
--- a/tests/generic/714
+++ b/tests/generic/714
@@ -22,7 +22,7 @@ _cleanup()
 . ./common/reflink
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v exchrange'
+_require_xfs_io_command exchangerange
 _require_xfs_io_command "falloc"
 _require_test_reflink
 
@@ -37,7 +37,7 @@ filesnap() {
 
 test_swapext_once() {
 	filesnap "$1: before swapext" $dir/$3 $dir/$4
-	$XFS_IO_PROG -c "swapext -v exchrange $2 $dir/$3" $dir/$4
+	$XFS_IO_PROG -c "exchangerange $2 $dir/$3" $dir/$4
 	filesnap "$1: after swapext" $dir/$3 $dir/$4
 	_test_cycle_mount
 	filesnap "$1: after cycling mount" $dir/$3 $dir/$4
diff --git a/tests/generic/715 b/tests/generic/715
index 595953dfcf..eb164a848a 100755
--- a/tests/generic/715
+++ b/tests/generic/715
@@ -21,7 +21,7 @@ _cleanup()
 . ./common/reflink
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v exchrange -s 64k -l 64k'
+_require_xfs_io_command exchangerange ' -s 64k -l 64k'
 _require_test
 
 filesnap() {
@@ -51,7 +51,7 @@ test_swapext_once() {
 	_pwrite_byte 0x59 0 $((blksz * b_len)) $dir/b >> $seqres.full
 	filesnap "$tag: before swapext" $dir/a $dir/b
 
-	cmd="swapext -v exchrange -s $((blksz * a_off)) -d $((blksz * b_off)) $len $dir/a"
+	cmd="exchangerange -s $((blksz * a_off)) -d $((blksz * b_off)) $len $dir/a"
 	echo "$cmd" >> $seqres.full
 	$XFS_IO_PROG -c "$cmd" $dir/b
 	filesnap "$tag: after swapext" $dir/a $dir/b
diff --git a/tests/generic/716 b/tests/generic/716
index 25976ab898..5d3fa5e721 100755
--- a/tests/generic/716
+++ b/tests/generic/716
@@ -24,7 +24,7 @@ _cleanup()
 . ./common/reflink
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v exchrange'
+_require_xfs_io_command exchangerange
 _require_xfs_io_command startupdate
 _require_test_reflink
 _require_test
diff --git a/tests/generic/717 b/tests/generic/717
index 2c45e715f4..dd2f3dcdc4 100755
--- a/tests/generic/717
+++ b/tests/generic/717
@@ -21,7 +21,7 @@ _cleanup()
 . ./common/reflink
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v exchrange'
+_require_xfs_io_command exchangerange
 _require_xfs_io_command startupdate
 _require_test
 _require_scratch
diff --git a/tests/generic/718 b/tests/generic/718
index f53d1840d0..23e092df4d 100755
--- a/tests/generic/718
+++ b/tests/generic/718
@@ -21,7 +21,7 @@ _cleanup()
 . ./common/reflink
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v exchrange'
+_require_xfs_io_command exchangerange
 _require_test
 
 dir=$TEST_DIR/test-$seq
diff --git a/tests/generic/719 b/tests/generic/719
index fe0b9d082e..70d1ae5d0c 100755
--- a/tests/generic/719
+++ b/tests/generic/719
@@ -23,7 +23,7 @@ _cleanup()
 . ./common/filter
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v exchrange'
+_require_xfs_io_command exchangerange
 _require_xfs_io_command startupdate '-e'
 _require_test
 
diff --git a/tests/generic/720 b/tests/generic/720
index 4db69c6921..25253968a2 100755
--- a/tests/generic/720
+++ b/tests/generic/720
@@ -20,7 +20,7 @@ _cleanup()
 . ./common/filter
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v exchrange'
+_require_xfs_io_command exchangerange
 _require_test_program punch-alternating
 _require_test
 
diff --git a/tests/generic/722 b/tests/generic/722
index 40eab9bbb3..3ec831e708 100755
--- a/tests/generic/722
+++ b/tests/generic/722
@@ -23,7 +23,7 @@ _cleanup()
 
 # real QA test starts here
 _require_test_program "punch-alternating"
-_require_xfs_io_command swapext '-v exchrange -a'
+_require_xfs_io_command exchangerange
 _require_scratch
 _require_scratch_shutdown
 
@@ -43,7 +43,7 @@ od -tx1 -Ad -c $SCRATCH_MNT/a > /tmp/a0
 od -tx1 -Ad -c $SCRATCH_MNT/b > /tmp/b0
 
 echo swap >> $seqres.full
-$XFS_IO_PROG -c "swapext -v exchrange -a -e -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
+$XFS_IO_PROG -c "exchangerange -e -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
 _scratch_shutdown
 _scratch_cycle_mount
 
diff --git a/tests/generic/723 b/tests/generic/723
index b452de0208..0e1de3ec1f 100755
--- a/tests/generic/723
+++ b/tests/generic/723
@@ -22,7 +22,7 @@ _cleanup()
 
 # real QA test starts here
 _require_test_program "punch-alternating"
-_require_xfs_io_command swapext '-v exchrange'
+_require_xfs_io_command exchangerange
 _require_scratch
 
 _scratch_mkfs >> $seqres.full
@@ -41,7 +41,7 @@ echo "md5 a: $old_a md5 b: $old_b" >> $seqres.full
 # Test swapext with the -n option, which will do all the input parameter
 # checking and return 0 without changing anything.
 echo dry run swap >> $seqres.full
-$XFS_IO_PROG -c "swapext -v exchrange -n -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
+$XFS_IO_PROG -c "exchangerange -n -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
 _scratch_cycle_mount
 
 new_a=$(md5sum $SCRATCH_MNT/a | awk '{print $1}')
@@ -54,7 +54,7 @@ test $old_b = $new_b || echo "scratch file B should not have swapped"
 # Do it again, but without the -n option, to prove that we can actually
 # swap the file contents.
 echo actual swap >> $seqres.full
-$XFS_IO_PROG -c "swapext -v exchrange -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
+$XFS_IO_PROG -c "exchangerange -f -u $SCRATCH_MNT/a" $SCRATCH_MNT/b
 _scratch_cycle_mount
 
 new_a=$(md5sum $SCRATCH_MNT/a | awk '{print $1}')
diff --git a/tests/generic/724 b/tests/generic/724
index 12324fb156..9536705503 100755
--- a/tests/generic/724
+++ b/tests/generic/724
@@ -22,7 +22,7 @@ _cleanup()
 . ./common/filter
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v exchrange -a'
+_require_xfs_io_command exchangerange
 _require_scratch
 
 _scratch_mkfs >> $seqres.full
@@ -42,7 +42,7 @@ md5sum $SCRATCH_MNT/b | _filter_scratch
 
 # Test swapext.  -h means skip holes in /b, and -e means operate to EOF
 echo swap | tee -a $seqres.full
-$XFS_IO_PROG -c "swapext -v exchrange -f -u -h -e -a $SCRATCH_MNT/b" $SCRATCH_MNT/a
+$XFS_IO_PROG -c "exchangerange -f -u -h -e $SCRATCH_MNT/b" $SCRATCH_MNT/a
 _scratch_cycle_mount
 
 md5sum $SCRATCH_MNT/a | _filter_scratch
diff --git a/tests/generic/725 b/tests/generic/725
index bf60127b39..3c6180fcbb 100755
--- a/tests/generic/725
+++ b/tests/generic/725
@@ -22,7 +22,7 @@ _cleanup()
 . ./common/filter
 
 # real QA test starts here
-_require_xfs_io_command swapext '-v exchrange -a'
+_require_xfs_io_command exchangerange
 _require_xfs_io_command startupdate '-e'
 _require_scratch
 
diff --git a/tests/generic/726 b/tests/generic/726
index 4cf18bd0e5..05d8a2372a 100755
--- a/tests/generic/726
+++ b/tests/generic/726
@@ -25,7 +25,7 @@ _begin_fstest auto fiexchange swapext quick
 # Modify as appropriate.
 _supported_fs generic
 _require_user
-_require_xfs_io_command swapext '-v exchrange -a'
+_require_xfs_io_command exchangerange
 _require_xfs_io_command startupdate
 _require_scratch
 
diff --git a/tests/generic/727 b/tests/generic/727
index af9612c967..4b0d5bd372 100755
--- a/tests/generic/727
+++ b/tests/generic/727
@@ -28,7 +28,7 @@ _supported_fs generic
 _require_user
 _require_command "$GETCAP_PROG" getcap
 _require_command "$SETCAP_PROG" setcap
-_require_xfs_io_command swapext '-v exchrange -a'
+_require_xfs_io_command exchangerange
 _require_xfs_io_command startupdate
 _require_scratch
 _require_attrs security
diff --git a/tests/xfs/789 b/tests/xfs/789
index b966c65119..00b98020f2 100755
--- a/tests/xfs/789
+++ b/tests/xfs/789
@@ -21,7 +21,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_require_xfs_io_command swapext '-v exchrange'
+_require_xfs_io_command swapext
 _require_test
 
 # We can't do any reasonable swapping if the files we're going to create are
diff --git a/tests/xfs/790 b/tests/xfs/790
index db6ce741d7..62bbd1fea6 100755
--- a/tests/xfs/790
+++ b/tests/xfs/790
@@ -24,7 +24,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_require_xfs_io_command swapext '-v exchrange -a'
+_require_xfs_io_command exchangerange
 _require_test_program "punch-alternating"
 _require_xfs_io_command startupdate
 _require_xfs_io_error_injection "bmap_finish_one"
diff --git a/tests/xfs/791 b/tests/xfs/791
index 84e3bee9b9..b4ded88d68 100755
--- a/tests/xfs/791
+++ b/tests/xfs/791
@@ -25,7 +25,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_require_xfs_io_command swapext '-v exchrange -a'
+_require_xfs_io_command exchangerange
 _require_xfs_scratch_atomicswap
 _require_xfs_io_error_injection "bmap_finish_one"
 
@@ -48,7 +48,7 @@ md5sum $SCRATCH_MNT/b | _filter_scratch
 # Test swapext.  -h means skip holes in /b, and -e means operate to EOF
 echo swap | tee -a $seqres.full
 $XFS_IO_PROG -x -c 'inject bmap_finish_one' \
-	-c "swapext -v exchrange -f -u -h -e -a $SCRATCH_MNT/b" $SCRATCH_MNT/a
+	-c "exchangerange -f -u -h -e $SCRATCH_MNT/b" $SCRATCH_MNT/a
 _scratch_cycle_mount
 
 md5sum $SCRATCH_MNT/a | _filter_scratch
diff --git a/tests/xfs/792 b/tests/xfs/792
index bfbfbce4aa..fded7a5a52 100755
--- a/tests/xfs/792
+++ b/tests/xfs/792
@@ -25,7 +25,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_fs xfs
-_require_xfs_io_command swapext '-v exchrange -a'
+_require_xfs_io_command exchangerange
 _require_xfs_io_command startupdate '-e'
 _require_xfs_scratch_atomicswap
 _require_xfs_io_error_injection "bmap_finish_one"


