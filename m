Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96284234A4B
	for <lists+linux-xfs@lfdr.de>; Fri, 31 Jul 2020 19:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733194AbgGaRhu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 31 Jul 2020 13:37:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57201 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1733055AbgGaRhu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Jul 2020 13:37:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596217069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dGVvhJ4J0WHSd0jnbBtPOzqYG7qcOSeT1PgeJXBIuzw=;
        b=A3LSsSgAwZf8kMzeL2fFxODZT5KCcbu4Ht/TUrDT6nrGOkIEaCt49AOOdw7aPKO7rAC0PC
        kkYzFaIZazzXTGzViwxyAJTfDSm1D22Z21WRysdvaik27St2GeOkpuRPIW0a5FJRuilJQl
        uHAMfz0pgRUrMppBYrijqMSitiLqgTI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-sRe_LAa_M1Cq_iy38zGCQA-1; Fri, 31 Jul 2020 13:37:45 -0400
X-MC-Unique: sRe_LAa_M1Cq_iy38zGCQA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 232E58014D7;
        Fri, 31 Jul 2020 17:37:44 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-244.rdu2.redhat.com [10.10.116.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EFBD60BF1;
        Fri, 31 Jul 2020 17:37:40 +0000 (UTC)
From:   Bill O'Donnell <billodo@redhat.com>
To:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Cc:     darrick.wong@oracle.com, sandeen@redhat.com
Subject: [PATCH] xfs/518: modify timer/state commands to remove new g,p timer output
Date:   Fri, 31 Jul 2020 12:37:39 -0500
Message-Id: <20200731173739.390649-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

New xfs_quota kernel and xfsprogs add grace timers for group and project,
in addition to existing user quota. Adjust xfs/518 to accommodate those
changes, and avoid regression.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 tests/xfs/518 | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/xfs/518 b/tests/xfs/518
index da39d8dc..c49c4e4d 100755
--- a/tests/xfs/518
+++ b/tests/xfs/518
@@ -41,12 +41,12 @@ _qmount_option "usrquota"
 _scratch_mount >> $seqres.full
 
 $XFS_QUOTA_PROG -x -c 'timer -u 300m' $SCRATCH_MNT
-$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
+$XFS_QUOTA_PROG -x -c 'state -u' $SCRATCH_MNT | grep 'grace time'
 _scratch_unmount
 
 # Remount and check the limits
 _scratch_mount >> $seqres.full
-$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
+$XFS_QUOTA_PROG -x -c 'state -u' $SCRATCH_MNT | grep 'grace time'
 _scratch_unmount
 
 # Run repair to force quota check
@@ -57,12 +57,12 @@ _scratch_xfs_repair >> $seqres.full 2>&1
 # while the incore copy stays at whatever was read in prior to quotacheck.
 # This will show up after the /next/ remount.
 _scratch_mount >> $seqres.full
-$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
+$XFS_QUOTA_PROG -x -c 'state -u' $SCRATCH_MNT | grep 'grace time'
 _scratch_unmount
 
 # Remount and check the limits
 _scratch_mount >> $seqres.full
-$XFS_QUOTA_PROG -x -c 'state' $SCRATCH_MNT | grep 'grace time'
+$XFS_QUOTA_PROG -x -c 'state -u' $SCRATCH_MNT | grep 'grace time'
 _scratch_unmount
 
 # success, all done
-- 
2.26.2

