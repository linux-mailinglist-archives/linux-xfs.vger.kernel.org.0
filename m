Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9086D6EB3
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Apr 2023 23:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbjDDVKK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Apr 2023 17:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236529AbjDDVKD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Apr 2023 17:10:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A6410CC
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 14:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E07BA638C3
        for <linux-xfs@vger.kernel.org>; Tue,  4 Apr 2023 21:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48602C433EF;
        Tue,  4 Apr 2023 21:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680642600;
        bh=CyBjQTOaTQIwssqC0ZZWsIBKpxzyEnwVlLUEyKuQhfQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IFQltXBdd+DeqvhDTL1l5p+i0vciUE6dyWBDyPbVu1M8eK4k0G+nXUM/ANOh1BCri
         BPfwDkfKUZzsXjldcfQfS17taJwobUOF0To0eg7DHdTAtTAoq8r8D/Eu0WBseiReQL
         ojIoTw1ovJrOrbxMu2OCxPO8DPxn9UK2d6X2FKo0lyQubq8ANLPuw79MPOJ/+GOf4C
         JoTsLVmaB8hoQdud5lEyDrXoVAxMSgURinnHVQRR3pIkaMaY4mJjRa7lLUUxZEOtMS
         EaUWlpiME9cOHm8sgUaw4hmiZfFcql7M0ZOlzqTMYQNfM9hQ3/s7LnBVP/kiiO+G61
         YrCDBcFmu5PXQ==
Date:   Tue, 4 Apr 2023 14:09:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: [PATCH] xfstests: add a couple more tests for ascii-ci problems
Message-ID: <20230404210959.GB303486@frogsfrogsfrogs>
References: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168062802052.174368.10967543545284986225.stgit@frogsfrogsfrogs>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add some tests to make sure that userspace and the kernel actually
agree on how to do ascii case-insensitive directory lookups, and that
metadump can actually obfuscate such filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/859     |   63 ++++++++++++++++++++++++++++++++++
 tests/xfs/859.out |   24 +++++++++++++
 tests/xfs/860     |   99 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/860.out |    9 +++++
 tests/xfs/861     |   90 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/861.out |    2 +
 6 files changed, 287 insertions(+)
 create mode 100755 tests/xfs/859
 create mode 100644 tests/xfs/859.out
 create mode 100755 tests/xfs/860
 create mode 100644 tests/xfs/860.out
 create mode 100755 tests/xfs/861
 create mode 100644 tests/xfs/861.out

diff --git a/tests/xfs/859 b/tests/xfs/859
new file mode 100755
index 0000000000..da6c70632c
--- /dev/null
+++ b/tests/xfs/859
@@ -0,0 +1,63 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Oracle.  All Rights Reserved.
+#
+# FS QA Test 859
+#
+# Make sure that the kernel and userspace agree on which byte sequences are
+# ASCII uppercase letters, and how to convert them.
+#
+. ./common/preamble
+_begin_fstest auto ci dir
+
+# Override the default cleanup function.
+# _cleanup()
+# {
+# 	cd /
+# 	rm -r -f $tmp.*
+# }
+
+# Import common functions.
+. ./common/filter
+
+_fixed_by_kernel_commit XXXXXXXXXXXX "xfs: stabilize the tolower function used for ascii-ci dir hash computation"
+_fixed_by_kernel_commit XXXXXXXXXXXX "xfs: use the directory name hash function for dir scrubbing"
+
+_supported_fs xfs
+_require_scratch
+
+_scratch_mkfs -n version=ci > $seqres.full
+_scratch_mount
+
+# Create a two-block directory to force leaf format
+mkdir "$SCRATCH_MNT/lol"
+touch "$SCRATCH_MNT/lol/autoexec.bat"
+i=0
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
+nr_dirents=$((dblksz * 2 / 256))
+
+for ((i = 0; i < nr_dirents; i++)); do
+	name="$(printf "y%0254d" $i)"
+	ln "$SCRATCH_MNT/lol/autoexec.bat" "$SCRATCH_MNT/lol/$name"
+done
+
+dirsz=$(stat -c '%s' $SCRATCH_MNT/lol)
+test $dirsz -gt $dblksz || echo "dir size $dirsz, expected at least $dblksz?"
+stat $SCRATCH_MNT/lol >> $seqres.full
+
+# Create names with extended ascii characters in them to exploit the fact
+# that the Linux kernel will transform extended ASCII uppercase characters
+# but libc won't.  Need to force LANG=C here so that awk doesn't spit out utf8
+# sequences.
+old_lang="$LANG"
+LANG=C
+awk 'END { for (i = 192; i < 247; i++) printf("%c\n", i); }' < /dev/null | while read name; do
+	ln "$SCRATCH_MNT/lol/autoexec.bat" "$SCRATCH_MNT/lol/$name" 2>&1 | _filter_scratch
+done
+
+LANG=$old_lang
+
+# Now just let repair run
+
+status=0
+exit
diff --git a/tests/xfs/859.out b/tests/xfs/859.out
new file mode 100644
index 0000000000..a4939ba670
--- /dev/null
+++ b/tests/xfs/859.out
@@ -0,0 +1,24 @@
+QA output created by 859
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\340': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\341': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\342': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\343': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\344': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\345': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\346': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\347': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\350': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\351': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\352': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\353': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\354': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\355': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\356': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\357': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\360': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\361': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\362': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\363': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\364': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\365': File exists
+ln: failed to create hard link 'SCRATCH_MNT/lol/'$'\366': File exists
diff --git a/tests/xfs/860 b/tests/xfs/860
new file mode 100755
index 0000000000..524d0cfa95
--- /dev/null
+++ b/tests/xfs/860
@@ -0,0 +1,99 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Oracle.  All Rights Reserved.
+#
+# FS QA Test 860
+#
+# Make sure that metadump obfuscation works for filesystems with ascii-ci
+# enabled.
+#
+. ./common/preamble
+_begin_fstest auto dir ci
+
+_cleanup()
+{
+      cd /
+      rm -r -f $tmp.* $testdir
+}
+
+_fixed_by_git_commit xfsprogs XXXXXXXXXXX "xfs_db: fix metadump name obfuscation for ascii-ci filesystems"
+
+_supported_fs xfs
+_require_test
+_require_scratch
+
+_scratch_mkfs -n version=ci > $seqres.full
+_scratch_mount
+
+# Create a two-block directory to force leaf format
+mkdir "$SCRATCH_MNT/lol"
+touch "$SCRATCH_MNT/lol/autoexec.bat"
+i=0
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
+nr_dirents=$((dblksz * 2 / 256))
+
+for ((i = 0; i < nr_dirents; i++)); do
+	name="$(printf "y%0254d" $i)"
+	ln "$SCRATCH_MNT/lol/autoexec.bat" "$SCRATCH_MNT/lol/$name"
+done
+
+dirsz=$(stat -c '%s' $SCRATCH_MNT/lol)
+test $dirsz -gt $dblksz || echo "dir size $dirsz, expected at least $dblksz?"
+stat $SCRATCH_MNT/lol >> $seqres.full
+
+# Create a two-block attr to force leaf format
+i=0
+for ((i = 0; i < nr_dirents; i++)); do
+	name="$(printf "user.%0250d" $i)"
+	$SETFATTR_PROG -n "$name" -v 1 "$SCRATCH_MNT/lol/autoexec.bat"
+done
+stat $SCRATCH_MNT/lol/autoexec.bat >> $seqres.full
+
+_scratch_unmount
+
+testdir=$TEST_DIR/$seq.metadumps
+mkdir -p $testdir
+metadump_file=$testdir/scratch.md
+metadump_file_a=${metadump_file}.a
+metadump_file_o=${metadump_file}.o
+metadump_file_ao=${metadump_file}.ao
+
+echo metadump
+_scratch_xfs_metadump $metadump_file >> $seqres.full
+
+echo metadump a
+_scratch_xfs_metadump $metadump_file_a -a >> $seqres.full
+
+echo metadump o
+_scratch_xfs_metadump $metadump_file_o -o >> $seqres.full
+
+echo metadump ao
+_scratch_xfs_metadump $metadump_file_ao -a -o >> $seqres.full
+
+echo mdrestore
+_scratch_xfs_mdrestore $metadump_file
+_scratch_mount
+_check_scratch_fs
+_scratch_unmount
+
+echo mdrestore a
+_scratch_xfs_mdrestore $metadump_file_a
+_scratch_mount
+_check_scratch_fs
+_scratch_unmount
+
+echo mdrestore o
+_scratch_xfs_mdrestore $metadump_file_o
+_scratch_mount
+_check_scratch_fs
+_scratch_unmount
+
+echo mdrestore ao
+_scratch_xfs_mdrestore $metadump_file_ao
+_scratch_mount
+_check_scratch_fs
+_scratch_unmount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/860.out b/tests/xfs/860.out
new file mode 100644
index 0000000000..136fc5f7d6
--- /dev/null
+++ b/tests/xfs/860.out
@@ -0,0 +1,9 @@
+QA output created by 860
+metadump
+metadump a
+metadump o
+metadump ao
+mdrestore
+mdrestore a
+mdrestore o
+mdrestore ao
diff --git a/tests/xfs/861 b/tests/xfs/861
new file mode 100755
index 0000000000..7b0a37a3f1
--- /dev/null
+++ b/tests/xfs/861
@@ -0,0 +1,90 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Oracle.  All Rights Reserved.
+#
+# FS QA Test 861
+#
+# Make sure that the kernel and utilities can handle large numbers of dirhash
+# collisions in both the directory and extended attribute structures.
+#
+# This started as a regression test for the new 'hashcoll' function in xfs_db,
+# but became a regression test for an xfs_repair bug affecting hashval checks
+# applied to the second and higher node levels of a dabtree.
+#
+. ./common/preamble
+_begin_fstest auto dir
+
+_fixed_by_git_commit xfsprogs b7b81f336ac "xfs_repair: fix incorrect dabtree hashval comparison"
+
+_supported_fs xfs
+_require_xfs_db_command "hashcoll"
+_require_xfs_db_command "path"
+_require_scratch
+
+_scratch_mkfs > $seqres.full
+_scratch_mount
+
+crash_dir=$SCRATCH_MNT/lol/
+crash_attrs=$SCRATCH_MNT/hah
+
+mkdir -p "$crash_dir"
+touch "$crash_attrs"
+
+# Create enough dirents to fill two dabtree node blocks with names that all
+# hash to the same value.  Each dirent gets its own record in the dabtree,
+# so we must create enough dirents to get a dabtree of at least height 2.
+dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
+
+da_records_per_block=$((dblksz / 8))	# 32-bit hash and 32-bit before
+nr_dirents=$((da_records_per_block * 2))
+
+longname="$(mktemp --dry-run "$(perl -e 'print "X" x 255;')" | tr ' ' 'X')"
+echo "creating $nr_dirents dirents from '$longname'" >> $seqres.full
+_scratch_xfs_db -r -c "hashcoll -n $nr_dirents -p $crash_dir $longname"
+
+# Create enough xattrs to fill two dabtree nodes.  Each attribute leaf block
+# gets its own record in the dabtree, so we have to create enough attr blocks
+# (each full of attrs) to get a dabtree of at least height 2.
+blksz=$(_get_block_size "$SCRATCH_MNT")
+
+attr_records_per_block=$((blksz / 255))
+da_records_per_block=$((blksz / 8))	# 32-bit hash and 32-bit before
+nr_attrs=$((da_records_per_block * attr_records_per_block * 2))
+
+longname="$(mktemp --dry-run "$(perl -e 'print "X" x 249;')" | tr ' ' 'X')"
+echo "creating $nr_attrs attrs from '$longname'" >> $seqres.full
+_scratch_xfs_db -r -c "hashcoll -a -n $nr_attrs -p $crash_attrs $longname"
+
+_scratch_unmount
+
+# Make sure that there's one hash value dominating the dabtree block.
+# We don't require 100% because directories create dabtree records for dot
+# and dotdot.
+filter_hashvals() {
+	uniq -c | awk -v seqres_full="$seqres.full" \
+		'{print $0 >> seqres_full; tot += $1; if ($1 > biggest) biggest = $1;} END {if (biggest >= (tot - 2)) exit(0); exit(1);}'
+	test "${PIPESTATUS[1]}" -eq 0 || \
+		echo "Scattered dabtree hashes?  See seqres.full"
+}
+
+# Did we actually get a two-level dabtree for the directory?  Does it contain a
+# long run of hashes?
+echo "dir check" >> $seqres.full
+da_node_block_offset=$(( (2 ** 35) / blksz ))
+dir_db_args=(-c 'path /lol/' -c "dblock $da_node_block_offset" -c 'addr nbtree[0].before')
+dir_count="$(_scratch_xfs_db "${dir_db_args[@]}" -c 'print lhdr.count' | awk '{print $3}')"
+_scratch_xfs_db "${dir_db_args[@]}" -c "print lents[0-$((dir_count - 1))].hashval" | sed -e 's/lents\[[0-9]*\]/lents[NN]/g' | filter_hashvals
+
+# Did we actually get a two-level dabtree for the attrs?  Does it contain a
+# long run of hashes?
+echo "attr check" >> $seqres.full
+attr_db_args=(-c 'path /hah' -c "ablock 0" -c 'addr btree[0].before')
+attr_count="$(_scratch_xfs_db "${attr_db_args[@]}" -c 'print hdr.count' | awk '{print $3}')"
+_scratch_xfs_db "${attr_db_args[@]}" -c "print btree[0-$((attr_count - 1))].hashval" | sed -e 's/btree\[[0-9]*\]/btree[NN]/g' | filter_hashvals
+
+# Remount to get some coverage of xfs_scrub before seeing if xfs_repair
+# will trip over the large dabtrees.
+echo Silence is golden
+_scratch_mount
+status=0
+exit
diff --git a/tests/xfs/861.out b/tests/xfs/861.out
new file mode 100644
index 0000000000..d11b76c82e
--- /dev/null
+++ b/tests/xfs/861.out
@@ -0,0 +1,2 @@
+QA output created by 861
+Silence is golden
