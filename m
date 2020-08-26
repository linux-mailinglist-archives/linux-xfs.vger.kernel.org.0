Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F282F253182
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Aug 2020 16:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgHZOi0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Aug 2020 10:38:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43363 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726818AbgHZOiW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 10:38:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598452700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BAjoWMEzpDcrIGtK3T9GxKod+8xS53mLbcVkLV2jYWg=;
        b=OORTDeT22ykWiiNVN8H3tywzXORgA374p19ISLHC1uchSuwieYW6HCGNzFJVqifrIx4a5T
        t9WdCRiylN15sLRv84xTv2R8tw1hjHAo1ApHk2qqk6ImxS79P5oQ2CNlPViuga9rpRLy90
        xAduYZh7jSFdtWsuDojm5KXiitrO/Ds=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-EhX-zQ3ZOkuG_GCbG5XXHg-1; Wed, 26 Aug 2020 10:38:17 -0400
X-MC-Unique: EhX-zQ3ZOkuG_GCbG5XXHg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A307385C731;
        Wed, 26 Aug 2020 14:38:16 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 557877049D;
        Wed, 26 Aug 2020 14:38:16 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] generic/455: use thin volume for dmlogwrites target device
Date:   Wed, 26 Aug 2020 10:38:13 -0400
Message-Id: <20200826143815.360002-3-bfoster@redhat.com>
In-Reply-To: <20200826143815.360002-1-bfoster@redhat.com>
References: <20200826143815.360002-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

dmlogwrites support for XFS depends on discard zeroing support of
the intended target device. Update the test to use a thin volume and
allow it to run consistently and reliably on XFS.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/generic/455 | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/tests/generic/455 b/tests/generic/455
index 05621220..72a44fda 100755
--- a/tests/generic/455
+++ b/tests/generic/455
@@ -16,12 +16,14 @@ status=1	# failure is the default!
 _cleanup()
 {
 	_log_writes_cleanup
+	_dmthin_cleanup
 }
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/dmthin
 . ./common/dmlogwrites
 
 # real QA test starts here
@@ -30,6 +32,7 @@ _supported_os Linux
 _require_test
 _require_scratch_nocheck
 _require_log_writes
+_require_dm_target thin-pool
 
 rm -f $seqres.full
 
@@ -42,13 +45,12 @@ check_files()
 		local filename=$(basename $i)
 		local mark="${filename##*.}"
 		echo "checking $filename" >> $seqres.full
-		_log_writes_replay_log $filename $SCRATCH_DEV
-		_scratch_mount
+		_log_writes_replay_log $filename $DMTHIN_VOL_DEV
+		_dmthin_mount
 		local expected_md5=$(_md5_checksum $i)
 		local md5=$(_md5_checksum $SCRATCH_MNT/$name)
 		[ "${md5}" != "${expected_md5}" ] && _fail "$filename md5sum mismatched"
-		_scratch_unmount
-		_check_scratch_fs
+		_dmthin_check_fs
 	done
 }
 
@@ -56,8 +58,16 @@ SANITY_DIR=$TEST_DIR/fsxtests
 rm -rf $SANITY_DIR
 mkdir $SANITY_DIR
 
+devsize=$((1024*1024*200 / 512))        # 200m phys/virt size
+csize=$((1024*64 / 512))                # 64k cluster size
+lowspace=$((1024*1024 / 512))           # 1m low space threshold
+
+# Use a thin device to provide deterministic discard behavior. Discards are used
+# by the log replay tool for fast zeroing to prevent out-of-order replay issues.
+_dmthin_init $devsize $devsize $csize $lowspace
+
 # Create the log
-_log_writes_init $SCRATCH_DEV
+_log_writes_init $DMTHIN_VOL_DEV
 
 _log_writes_mkfs >> $seqres.full 2>&1
 
@@ -88,14 +98,13 @@ _log_writes_mark last
 _log_writes_unmount
 _log_writes_mark end
 _log_writes_remove
-_check_scratch_fs
+_dmthin_check_fs
 
 # check pre umount
 echo "checking pre umount" >> $seqres.full
-_log_writes_replay_log last $SCRATCH_DEV
-_scratch_mount
-_scratch_unmount
-_check_scratch_fs
+_log_writes_replay_log last $DMTHIN_VOL_DEV
+_dmthin_mount
+_dmthin_check_fs
 
 for j in `seq 0 $((NUM_FILES-1))`; do
 	check_files testfile$j
@@ -103,14 +112,13 @@ done
 
 # Check the end
 echo "checking post umount" >> $seqres.full
-_log_writes_replay_log end $SCRATCH_DEV
-_scratch_mount
+_log_writes_replay_log end $DMTHIN_VOL_DEV
+_dmthin_mount
 for j in `seq 0 $((NUM_FILES-1))`; do
 	md5=$(_md5_checksum $SCRATCH_MNT/testfile$j)
 	[ "${md5}" != "${test_md5[$j]}" ] && _fail "testfile$j end md5sum mismatched"
 done
-_scratch_unmount
-_check_scratch_fs
+_dmthin_check_fs
 
 echo "Silence is golden"
 status=0
-- 
2.25.4

