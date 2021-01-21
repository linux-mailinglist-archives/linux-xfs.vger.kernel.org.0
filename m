Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402AF2FF140
	for <lists+linux-xfs@lfdr.de>; Thu, 21 Jan 2021 18:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387528AbhAUPtr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 21 Jan 2021 10:49:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42775 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387532AbhAUPq6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 10:46:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611243932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MzNM66mKM06rILbVuXuUisiuKJGX6/G4765nUjUW8Xg=;
        b=CagIqiDkyfnHOEver1ymCNw6KrDJizr1NIom7Qn/s0ci9czNmJIXAITKdVkQ+VQHsGREce
        0XbBU0BYVh1QW0QqF9A7hmc2CfMP5MqzC9NKnjKI3d7OqGhPUomeXlgYJxuoSTmQ55s2xi
        mCyc2YI4uCWVXVlK9E89Sh+nXGyHz4U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-74yiS1QGOSOsvmzK80lFcQ-1; Thu, 21 Jan 2021 10:45:31 -0500
X-MC-Unique: 74yiS1QGOSOsvmzK80lFcQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BEEF801817
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jan 2021 15:45:30 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F197A46
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jan 2021 15:45:29 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 7/9] xfs: remove duplicate wq cancel and log force from attr quiesce
Date:   Thu, 21 Jan 2021 10:45:24 -0500
Message-Id: <20210121154526.1852176-8-bfoster@redhat.com>
In-Reply-To: <20210121154526.1852176-1-bfoster@redhat.com>
References: <20210121154526.1852176-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

These two calls are repeated at the beginning of xfs_log_quiesce().
Drop them from xfs_quiesce_attr().

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 75ada867c665..8fc9044131fc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -884,11 +884,6 @@ void
 xfs_quiesce_attr(
 	struct xfs_mount	*mp)
 {
-	cancel_delayed_work_sync(&mp->m_log->l_work);
-
-	/* force the log to unpin objects from the now complete transactions */
-	xfs_log_force(mp, XFS_LOG_SYNC);
-
 	xfs_log_clean(mp);
 }
 
-- 
2.26.2

