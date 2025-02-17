Return-Path: <linux-xfs+bounces-19467-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 11928A31CF6
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Feb 2025 04:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF7A91685F0
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Feb 2025 03:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 844191D86E8;
	Wed, 12 Feb 2025 03:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKxAw3/D"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE87271839;
	Wed, 12 Feb 2025 03:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331557; cv=none; b=svtRy6ldaRI1rGDkxFJTzeGcarS+LEorVg6tOeslkhSLCQtardvg23lT6l7QvXa27oZ6SJKH8K9Xb4fy5Zz8f8VbvHtKVaf9JZYDgBAlA8HiGbqLb4yqphq0LOE/n5wUAHUzw4+yIj7qqIWY8WLOxAAAyNcKaLxzBdzyDu3cWyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331557; c=relaxed/simple;
	bh=8k0FkAeNa+jJz12erU6AIlHr/RpdVqMRaP5knOkcUZI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U1V9AeSYBnyMSSD7sr7cqwYDcBcw4GY0V3RlNUVmp4Dcwz4je4R1WK2LPmeCXM9RnHJtZpnrhG6l6VkoP36LW3wXEQTxclL9Rfvkrs7wZjVYawk9vQ8G2Xy98bOXSu9nFEoexQdAFgNwDgw1B069OBcBbMf/JsCVTUMHbncm+o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OKxAw3/D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169B6C4CEDF;
	Wed, 12 Feb 2025 03:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331557;
	bh=8k0FkAeNa+jJz12erU6AIlHr/RpdVqMRaP5knOkcUZI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OKxAw3/DKwGcsPzo7xTZ/cV8+t9lRhMyhOpHmmkddLzwUJrpMZo8lw1JmTLg3FprE
	 CvhKPsPb40PrwU0mXgpprp800w2MnGM6amQqbCuUVdgM2jJgbYZBoBwU0WDYj3nTkK
	 Ohss1FwE757nUei/A2WVjRkAlVU0130Y/HtYycswoHgQw2xlaoQY/yCKrG3CRdwjCy
	 aJPnr6Sgl/J3d9d9KfoieFvylUD3wCo6eWzuTBxwzwPzRXWrGGaNdAQkyLRxWv1QOf
	 CpPsFCuTTR+PQa3qWFgAecxnVUn4aLPAOpzJaFSXC7BK+HYkqdQ10OMO6uLj5vzTRL
	 1DEzc3wUri15A==
Date: Tue, 11 Feb 2025 19:39:16 -0800
Subject: [PATCH 33/34] config: add FSX_PROG variable
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094859.1758477.11576502305621375347.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Replace the open-coded $here/ltp/fsx and ./ltp/fsx variants with a
single variable.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 common/config     |    3 +++
 common/fuzzy      |    6 +++---
 common/rc         |    4 ++--
 tests/generic/075 |    2 +-
 tests/generic/112 |    2 +-
 tests/generic/127 |   16 ++++++++--------
 tests/generic/231 |    4 ++--
 tests/generic/455 |    2 +-
 tests/generic/456 |    2 +-
 tests/generic/457 |    2 +-
 tests/generic/469 |    2 +-
 tests/generic/499 |    2 +-
 tests/generic/511 |    2 +-
 13 files changed, 26 insertions(+), 23 deletions(-)


diff --git a/common/config b/common/config
index ae9aa3f4b0b8fc..193b7af432dc2b 100644
--- a/common/config
+++ b/common/config
@@ -131,6 +131,9 @@ export UMOUNT_PROG="$(type -P umount)"
 export FSSTRESS_PROG="$here/ltp/fsstress"
 [ ! -x $FSSTRESS_PROG ] && _fatal "fsstress not found or executable"
 
+export FSX_PROG="$here/ltp/fsx"
+[ ! -x $FSX_PROG ] && _fatal "fsx not found or executable"
+
 export PERL_PROG="$(type -P perl)"
 [ "$PERL_PROG" = "" ] && _fatal "perl not found"
 
diff --git a/common/fuzzy b/common/fuzzy
index b82884ff7d6d1d..07291bce12ebdd 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -969,7 +969,7 @@ __stress_scrub_fsx_loop() {
 	focus+=(-l $((600000 * LOAD_FACTOR)) )
 
 	local args="$FSX_AVOID ${focus[@]} ${SCRATCH_MNT}/fsx.$seq"
-	echo "Running $here/ltp/fsx $args" >> $seqres.full
+	echo "Running $FSX_PROG $args" >> $seqres.full
 
 	if [ -n "$remount_period" ]; then
 		local mode="rw"
@@ -980,7 +980,7 @@ __stress_scrub_fsx_loop() {
 			test "$mode" = "rw" && __stress_scrub_clean_scratch && continue
 
 			duration=$(___stress_scrub_duration "$end" "$remount_period")
-			$here/ltp/fsx $duration $args $rw_arg >> $seqres.full
+			$FSX_PROG $duration $args $rw_arg >> $seqres.full
 			res=$?
 			echo "$mode fsx exits with $res at $(date)" >> $seqres.full
 			test "$res" -ne 0 && break
@@ -1007,7 +1007,7 @@ __stress_scrub_fsx_loop() {
 		# Need to recheck running conditions if we cleared anything
 		__stress_scrub_clean_scratch && continue
 		duration=$(___stress_scrub_duration "$end" "$remount_period")
-		$here/ltp/fsx $duration $args >> $seqres.full
+		$FSX_PROG $duration $args >> $seqres.full
 		res=$?
 		echo "fsx exits with $res at $(date)" >> $seqres.full
 		test "$res" -ne 0 && break
diff --git a/common/rc b/common/rc
index 26b6b3029a25f7..f183837abf1445 100644
--- a/common/rc
+++ b/common/rc
@@ -5050,7 +5050,7 @@ _get_page_size()
 
 _require_hugepage_fsx()
 {
-	$here/ltp/fsx -N 0 -h $TEST_DIR 2>&1 | grep -q 'MADV_COLLAPSE not supported' && \
+	$FSX_PROG -N 0 -h $TEST_DIR 2>&1 | grep -q 'MADV_COLLAPSE not supported' && \
 		_notrun "fsx binary does not support MADV_COLLAPSE"
 }
 
@@ -5058,7 +5058,7 @@ _run_fsx()
 {
 	echo "fsx $*"
 	local args=`echo $@ | sed -e "s/ BSIZE / $bsize /g" -e "s/ PSIZE / $psize /g"`
-	set -- $here/ltp/fsx $args $FSX_AVOID $TEST_DIR/junk
+	set -- $FSX_PROG $args $FSX_AVOID $TEST_DIR/junk
 	echo "$@" >>$seqres.full
 	rm -f $TEST_DIR/junk
 	"$@" 2>&1 | tee -a $seqres.full >$tmp.fsx
diff --git a/tests/generic/075 b/tests/generic/075
index 8db58e866d0d05..94a96e3341d3e7 100755
--- a/tests/generic/075
+++ b/tests/generic/075
@@ -53,7 +53,7 @@ _do_test()
 
     # This cd and use of -P gets full debug on "$RESULT_DIR" (not TEST_DEV)
     cd $out
-    if ! $here/ltp/fsx $_param -P "$RESULT_DIR" $seq.$_n $FSX_AVOID &>/dev/null
+    if ! $FSX_PROG $_param -P "$RESULT_DIR" $seq.$_n $FSX_AVOID &>/dev/null
     then
 	echo "    fsx ($_param) failed, $? - compare $seqres.$_n.{good,bad,fsxlog}"
 	mv $out/$seq.$_n $seqres.$_n.full
diff --git a/tests/generic/112 b/tests/generic/112
index 0084b555a7f5e8..c171750055b1ee 100755
--- a/tests/generic/112
+++ b/tests/generic/112
@@ -53,7 +53,7 @@ _do_test()
 
     # This cd and use of -P gets full debug on "$RESULT_DIR" (not TEST_DEV)
     cd $out
-    if ! $here/ltp/fsx $_param -P "$RESULT_DIR" $FSX_AVOID $seq.$_n &>/dev/null
+    if ! $FSX_PROG $_param -P "$RESULT_DIR" $FSX_AVOID $seq.$_n &>/dev/null
     then
 	echo "    fsx ($_param) returned $? - see $seq.$_n.full"
 	mv "$RESULT_DIR"/$seq.$_n.fsxlog $seqres.$_n.full
diff --git a/tests/generic/127 b/tests/generic/127
index 985c99cfb5bef7..fcd535b46075e2 100755
--- a/tests/generic/127
+++ b/tests/generic/127
@@ -31,9 +31,9 @@ FSX_ARGS="-q -l $FSX_FILE_SIZE -o 65536 -S 191110531 -N 100000"
 _fsx_lite_nommap()
 {
     dd if=/dev/zero of=$TEST_DIR/fsx_lite_nommap bs=${FSX_FILE_SIZE} count=1 > /dev/null 2>&1
-    if ! ltp/fsx $FSX_ARGS -L -R -W $FSX_AVOID $TEST_DIR/fsx_lite_nommap > $tmp.output 2>&1
+    if ! $FSX_PROG $FSX_ARGS -L -R -W $FSX_AVOID $TEST_DIR/fsx_lite_nommap > $tmp.output 2>&1
     then
-        echo "ltp/fsx $FSX_ARGS -L -R -W $TEST_DIR/fsx_lite_nommap"
+        echo "$FSX_PROG $FSX_ARGS -L -R -W $TEST_DIR/fsx_lite_nommap"
         cat $tmp.output
         return 1
     fi
@@ -44,9 +44,9 @@ _fsx_lite_nommap()
 _fsx_lite_mmap()
 {
     dd if=/dev/zero of=$TEST_DIR/fsx_lite_mmap bs=${FSX_FILE_SIZE} count=1 > /dev/null 2>&1
-    if ! ltp/fsx $FSX_ARGS -L $FSX_AVOID $TEST_DIR/fsx_lite_mmap > $tmp.output 2>&1
+    if ! $FSX_PROG $FSX_ARGS -L $FSX_AVOID $TEST_DIR/fsx_lite_mmap > $tmp.output 2>&1
     then
-    	echo "ltp/fsx $FSX_ARGS -L fsx_lite_mmap"
+	echo "$FSX_PROG $FSX_ARGS -L fsx_lite_mmap"
 	cat $tmp.output
 	return 1
     fi
@@ -58,9 +58,9 @@ _fsx_std_nommap()
 {
 	local fname="$TEST_DIR/$1"
 
-	if ! ltp/fsx $FSX_ARGS -R -W $FSX_AVOID $fname > $tmp.output 2>&1
+	if ! $FSX_PROG $FSX_ARGS -R -W $FSX_AVOID $fname > $tmp.output 2>&1
 	then
-		echo "ltp/fsx $FSX_ARGS -R -W fsx_std_nommap"
+		echo "$FSX_PROG $FSX_ARGS -R -W fsx_std_nommap"
 		cat $tmp.output
 		return 1
 	fi
@@ -72,9 +72,9 @@ _fsx_std_mmap()
 {
 	local fname="$TEST_DIR/$1"
 
-	if ! ltp/fsx $FSX_ARGS $FSX_AVOID $fname > $tmp.output 2>&1
+	if ! $FSX_PROG $FSX_ARGS $FSX_AVOID $fname > $tmp.output 2>&1
 	then
-		echo "ltp/fsx $FSX_ARGS fsx_std_mmap"
+		echo "$FSX_PROG $FSX_ARGS fsx_std_mmap"
 		cat $tmp.output
 		return 1
 	fi
diff --git a/tests/generic/231 b/tests/generic/231
index 8dda926d875e88..b598a5d568bdf6 100755
--- a/tests/generic/231
+++ b/tests/generic/231
@@ -23,8 +23,8 @@ _fsx()
 	echo "=== FSX Standard Mode, Memory Mapping, $tasks Tasks ==="
 	for (( i = 1; i <= $tasks; i++ )); do
 		SEED=$RANDOM
-		echo "ltp/fsx $FSX_ARGS -S $SEED $SCRATCH_MNT/fsx_file$i" >>$seqres.full
-		_su $qa_user -c "ltp/fsx $FSX_ARGS -S $SEED \
+		echo "$FSX_PROG $FSX_ARGS -S $SEED $SCRATCH_MNT/fsx_file$i" >>$seqres.full
+		_su $qa_user -c "$FSX_PROG $FSX_ARGS -S $SEED \
 			$FSX_AVOID $SCRATCH_MNT/fsx_file$i" >$tmp.output$i 2>&1 &
 	done
 
diff --git a/tests/generic/455 b/tests/generic/455
index 31f84346daecde..a70da042f07a29 100755
--- a/tests/generic/455
+++ b/tests/generic/455
@@ -79,7 +79,7 @@ FSX_OPTS="-N $NUM_OPS -d -P $SANITY_DIR -i $LOGWRITES_DMDEV"
 seeds=(0 0 0 0)
 # Run fsx for a while
 for j in `seq 0 $((NUM_FILES-1))`; do
-	run_check $here/ltp/fsx $FSX_OPTS $FSX_AVOID -S ${seeds[$j]} -j $j $SCRATCH_MNT/testfile$j &
+	run_check $FSX_PROG $FSX_OPTS $FSX_AVOID -S ${seeds[$j]} -j $j $SCRATCH_MNT/testfile$j &
 done
 wait
 
diff --git a/tests/generic/456 b/tests/generic/456
index 0123508ce15076..32afa398f11ccc 100755
--- a/tests/generic/456
+++ b/tests/generic/456
@@ -53,7 +53,7 @@ write 0x3e5ec 0x1a14 0x21446
 zero_range 0x20fac 0x6d9c 0x40000 keep_size
 mapwrite 0x216ad 0x274f 0x40000
 EOF
-run_check $here/ltp/fsx -d --replay-ops $fsxops $SCRATCH_MNT/testfile
+run_check $FSX_PROG -d --replay-ops $fsxops $SCRATCH_MNT/testfile
 
 _flakey_drop_and_remount
 _unmount_flakey
diff --git a/tests/generic/457 b/tests/generic/457
index defa73cfb5dfcd..b59cad5672f407 100755
--- a/tests/generic/457
+++ b/tests/generic/457
@@ -82,7 +82,7 @@ FSX_OPTS="-N $NUM_OPS -d -k -P $SANITY_DIR -i $LOGWRITES_DMDEV"
 for j in `seq 0 $((NUM_FILES-1))`; do
 	# clone the clone from prev iteration which may have already mutated
 	_cp_reflink $SCRATCH_MNT/testfile$((j-1)) $SCRATCH_MNT/testfile$j
-	run_check $here/ltp/fsx $FSX_OPTS $FSX_AVOID -S 0 -j $j $SCRATCH_MNT/testfile$j &
+	run_check $FSX_PROG $FSX_OPTS $FSX_AVOID -S 0 -j $j $SCRATCH_MNT/testfile$j &
 done
 wait
 
diff --git a/tests/generic/469 b/tests/generic/469
index 1352c3243f6df6..f7718185b7114a 100755
--- a/tests/generic/469
+++ b/tests/generic/469
@@ -35,7 +35,7 @@ _require_xfs_io_command "fzero"
 
 run_fsx()
 {
-	$here/ltp/fsx $2 --replay-ops $1 $file 2>&1 | tee -a $seqres.full >$tmp.fsx
+	$FSX_PROG $2 --replay-ops $1 $file 2>&1 | tee -a $seqres.full >$tmp.fsx
 	if [ ${PIPESTATUS[0]} -ne 0 ]; then
 		cat $tmp.fsx
 		exit 1
diff --git a/tests/generic/499 b/tests/generic/499
index 9145c1c5dfdc72..868413bad698ea 100755
--- a/tests/generic/499
+++ b/tests/generic/499
@@ -35,7 +35,7 @@ ENDL
 
 victim=$SCRATCH_MNT/a
 touch $victim
-$here/ltp/fsx --replay-ops $tmp.fsxops $victim > $tmp.output 2>&1 || cat $tmp.output
+$FSX_PROG --replay-ops $tmp.fsxops $victim > $tmp.output 2>&1 || cat $tmp.output
 
 echo "Silence is golden"
 status=0
diff --git a/tests/generic/511 b/tests/generic/511
index 7c903fb0280d7f..66557ab9369059 100755
--- a/tests/generic/511
+++ b/tests/generic/511
@@ -32,7 +32,7 @@ ENDL
 
 victim=$SCRATCH_MNT/a
 touch $victim
-$here/ltp/fsx --replay-ops $tmp.fsxops $victim > $tmp.output 2>&1 || cat $tmp.output
+$FSX_PROG --replay-ops $tmp.fsxops $victim > $tmp.output 2>&1 || cat $tmp.output
 
 echo "Silence is golden"
 status=0


