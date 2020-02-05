Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 889D5153B50
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Feb 2020 23:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgBEWs2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Feb 2020 17:48:28 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37489 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727562AbgBEWs2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Feb 2020 17:48:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580942907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZEYBcodEQheuhpFfEN+YUYsb4nlhPnB2q7hb4r/C62E=;
        b=aU/RCYNaPNoUHFEjgXjgdy5CWfN/ux5AzI+RW7vpF6/qukQFol/aZtV7oND+gm4munvW5+
        P0hDTDYzMM/7HjfiCbTP/II3AY0VsZ2FOC1cLgL8DC93iEoFn0dyp5c5oqwFG2/b2hzkh+
        z9z87hA+kIYnwC1KQLXw2w1N9pti6Vo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-LpAcnSVCMFS29N8Prp6DAA-1; Wed, 05 Feb 2020 17:48:22 -0500
X-MC-Unique: LpAcnSVCMFS29N8Prp6DAA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6444E190D340;
        Wed,  5 Feb 2020 22:48:21 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 497C45DA75;
        Wed,  5 Feb 2020 22:48:21 +0000 (UTC)
Received: by segfault.boston.devel.redhat.com (Postfix, from userid 3734)
        id 4841520675C6; Wed,  5 Feb 2020 17:48:20 -0500 (EST)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 1/3] dax/dm: disable testing on devices that don't support dax
Date:   Wed,  5 Feb 2020 17:48:16 -0500
Message-Id: <20200205224818.18707-2-jmoyer@redhat.com>
In-Reply-To: <20200205224818.18707-1-jmoyer@redhat.com>
References: <20200205224818.18707-1-jmoyer@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move the hack out of dmflakey and put it into _require_dm_target.  This
fixes up a lot of missed tests that are failing due to the lack of dax
support (such as tests on dm-thin, snapshot, etc).

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 common/dmflakey |  5 -----
 common/rc       | 11 +++++++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/common/dmflakey b/common/dmflakey
index 2af3924d..b4e11ae9 100644
--- a/common/dmflakey
+++ b/common/dmflakey
@@ -8,11 +8,6 @@ FLAKEY_ALLOW_WRITES=3D0
 FLAKEY_DROP_WRITES=3D1
 FLAKEY_ERROR_WRITES=3D2
=20
-echo $MOUNT_OPTIONS | grep -q dax
-if [ $? -eq 0 ]; then
-	_notrun "Cannot run tests with DAX on dmflakey devices"
-fi
-
 _init_flakey()
 {
 	local BLK_DEV_SIZE=3D`blockdev --getsz $SCRATCH_DEV`
diff --git a/common/rc b/common/rc
index eeac1355..785f34c6 100644
--- a/common/rc
+++ b/common/rc
@@ -1874,6 +1874,17 @@ _require_dm_target()
 	_require_sane_bdev_flush $SCRATCH_DEV
 	_require_command "$DMSETUP_PROG" dmsetup
=20
+	echo $MOUNT_OPTIONS | grep -q dax
+	if [ $? -eq 0 ]; then
+		case $target in
+		stripe|linear|error)
+			;;
+		*)
+			_notrun "Cannot run tests with DAX on $target devices."
+			;;
+		esac
+	fi
+
 	modprobe dm-$target >/dev/null 2>&1
=20
 	$DMSETUP_PROG targets 2>&1 | grep -q ^$target
--=20
2.19.1

