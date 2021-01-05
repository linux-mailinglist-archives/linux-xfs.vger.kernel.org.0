Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC2B2EAA4B
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Jan 2021 13:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbhAEMAO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 5 Jan 2021 07:00:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39484 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726074AbhAEMAO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jan 2021 07:00:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609847928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Qb8J8Y9ijZ6TqL99I9DAa9n5/16P5cL0/LvtQAx8fPg=;
        b=XKJfAj6xst1EVC5G7JMZ8rVsUhQKNIVPL4QFJIilT9/ngBkbe6kCivD84B59SM54EYPgbi
        RaqduAzKUzIrg0sZi6JEqn38NvkKvVudzULNmplTfenv9AEGa4Zks3LFAMju8sf2uxPKn+
        VKhjz1adB9BHczVVOyC+RfTynv3Fcxk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-FevQtQkwO-m4TbST9aLCIg-1; Tue, 05 Jan 2021 06:58:46 -0500
X-MC-Unique: FevQtQkwO-m4TbST9aLCIg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C50B802B40;
        Tue,  5 Jan 2021 11:58:45 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 281F65D9C6;
        Tue,  5 Jan 2021 11:58:45 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] generic/388: randomly recover via read-only mounts
Date:   Tue,  5 Jan 2021 06:58:44 -0500
Message-Id: <20210105115844.293207-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS has an issue where superblock counters may not be properly
synced when recovery occurs via a read-only mount. This causes the
filesystem to become inconsistent after unmount. To cover this test
case, update generic/388 to switch between read-only and read-write
mounts to perform log recovery.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Tweak ro -> rw mount cycle error message to be unique.
v1: https://lore.kernel.org/fstests/20201217145941.2513069-1-bfoster@redhat.com/

 tests/generic/388 | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tests/generic/388 b/tests/generic/388
index 451a6be2..2f97f266 100755
--- a/tests/generic/388
+++ b/tests/generic/388
@@ -66,8 +66,14 @@ for i in $(seq 1 $((50 * TIME_FACTOR)) ); do
 		ps -e | grep fsstress > /dev/null 2>&1
 	done
 
-	# quit if mount fails so we don't shutdown the host fs
-	_scratch_cycle_mount || _fail "cycle mount failed"
+	# Toggle between rw and ro mounts for recovery. Quit if any mount
+	# attempt fails so we don't shutdown the host fs.
+	if [ $((RANDOM % 2)) -eq 0 ]; then
+		_scratch_cycle_mount || _fail "cycle mount failed"
+	else
+		_scratch_cycle_mount "ro" || _fail "cycle ro mount failed"
+		_scratch_cycle_mount || _fail "cycle rw mount failed"
+	fi
 done
 
 # success, all done
-- 
2.26.2

