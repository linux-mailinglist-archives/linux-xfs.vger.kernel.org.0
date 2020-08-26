Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7B3253183
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Aug 2020 16:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgHZOi3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Aug 2020 10:38:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22554 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726803AbgHZOiY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 10:38:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598452699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CIqwHJ211+vRH1XPmTEpHVyEmFiSIEvhvJz/54Lnb90=;
        b=VJ7H2DxLHwJ3EuCKAiP5FCvsbGhdApHKHtUvZgVVZwOp2bEd0dQiC8jlvi9BwjarFnUB5K
        viR5Iat3aYyEMC4mPL3nQkQJdbUYAZJLJeEknANkSxSjZhNwbz4Z2PkPZPpatQTuU9yeIp
        RsJU6g43jKBwVFuN8XGnNE6btkecKbA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-ooMZ84iRMhGcS6_zyrivhQ-1; Wed, 26 Aug 2020 10:38:17 -0400
X-MC-Unique: ooMZ84iRMhGcS6_zyrivhQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 338AE189E60C;
        Wed, 26 Aug 2020 14:38:16 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA4EA50EB6;
        Wed, 26 Aug 2020 14:38:15 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] generic: require discard zero behavior for dmlogwrites on XFS
Date:   Wed, 26 Aug 2020 10:38:12 -0400
Message-Id: <20200826143815.360002-2-bfoster@redhat.com>
In-Reply-To: <20200826143815.360002-1-bfoster@redhat.com>
References: <20200826143815.360002-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Several generic fstests use dm-log-writes to test the filesystem for
consistency at various crash recovery points. dm-log-writes and the
associated replay mechanism rely on zeroing via discard to clear
stale blocks when moving to various points in time of the fs. If the
storage doesn't provide zeroing or the discard requests exceed the
hardcoded maximum (128MB) of the fallback solution to physically
write zeroes, stale blocks are left around in the target fs. This
scheme is known to cause issues on XFS v5 superblocks if recovery
observes metadata from a future variant of an fs that has been
replayed to an older point in time. This corrupts the filesystem and
leads to false test failures.

generic/482 already works around this problem by using a thin volume
as the target device, which provides consistent and efficient
discard zeroing behavior, but other tests have seen similar issues
on XFS. Add an XFS specific check to the dmlogwrites init time code
that requires discard zeroing support and otherwise skips the test
to avoid false positive failures.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 common/dmlogwrites | 10 ++++++++--
 common/rc          | 14 ++++++++++++++
 tests/generic/470  |  2 +-
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/common/dmlogwrites b/common/dmlogwrites
index 573f4b8a..92cc6ce2 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -43,9 +43,10 @@ _require_log_writes_dax_mountopt()
 	_require_test_program "log-writes/replay-log"
 
 	local ret=0
-	local mountopt=$1
+	local dev=$1
+	local mountopt=$2
 
-	_log_writes_init $SCRATCH_DEV
+	_log_writes_init $dev
 	_log_writes_mkfs > /dev/null 2>&1
 	_log_writes_mount "-o $mountopt" > /dev/null 2>&1
 	# Check options to be sure.
@@ -66,6 +67,11 @@ _log_writes_init()
 	[ -z "$blkdev" ] && _fail \
 	"block dev must be specified for _log_writes_init"
 
+	# XFS requires discard zeroing support on the target device to work
+	# reliably with dm-log-writes. Use dm-thin devices in tests that want
+	# to provide reliable discard zeroing support.
+	[ $FSTYP == "xfs" ] && _require_discard_zeroes $blkdev
+
 	local BLK_DEV_SIZE=`blockdev --getsz $blkdev`
 	LOGWRITES_NAME=logwrites-test
 	LOGWRITES_DMDEV=/dev/mapper/$LOGWRITES_NAME
diff --git a/common/rc b/common/rc
index aa5a7409..fedb5221 100644
--- a/common/rc
+++ b/common/rc
@@ -4313,6 +4313,20 @@ _require_mknod()
 	rm -f $TEST_DIR/$seq.null
 }
 
+# check that discard is supported and subsequent reads return zeroes
+_require_discard_zeroes()
+{
+	local dev=$1
+
+	_require_command "$BLKDISCARD_PROG" blkdiscard
+
+	$XFS_IO_PROG -c "pwrite -S 0xcd 0 4k" $dev > /dev/null 2>&1 ||
+		_fail "write error"
+	$BLKDISCARD_PROG -o 0 -l 1m $dev || _notrun "no discard support"
+	hexdump -n 4096 $dev | head -n 1 | grep cdcd &&
+		_notrun "no discard zeroing support"
+}
+
 init_rc
 
 ################################################################################
diff --git a/tests/generic/470 b/tests/generic/470
index fd6da563..707b6237 100755
--- a/tests/generic/470
+++ b/tests/generic/470
@@ -35,7 +35,7 @@ rm -f $seqres.full
 _supported_fs generic
 _supported_os Linux
 _require_scratch
-_require_log_writes_dax_mountopt "dax"
+_require_log_writes_dax_mountopt $SCRATCH_DEV "dax"
 _require_xfs_io_command "mmap" "-S"
 _require_xfs_io_command "log_writes"
 
-- 
2.25.4

