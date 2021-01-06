Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706D02EC297
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Jan 2021 18:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbhAFRnA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 Jan 2021 12:43:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44192 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727022AbhAFRm7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jan 2021 12:42:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609954894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gjx49N/ITT+YnACE2GV9FfidUeKrEsXOtUOJfj371tE=;
        b=RxsMZmn7lRyTuBCXn/xgMPDUf5VJIiPkRwUFUG0ROzpLBnAbLMtSR/fqfvYeAlrJjKFbta
        BI+t3KRC/9fxUVqRswV6XVVnFdX+j2M4X6nClwkdUzMbcEFf1Ua5htXhe50Zm9BbnmXWEO
        9CI0G7dvh1wlLqz5Pn4o0TIvpiEuQ60=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-5AgY-PYUNWC7n7EQzECrxw-1; Wed, 06 Jan 2021 12:41:32 -0500
X-MC-Unique: 5AgY-PYUNWC7n7EQzECrxw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 418EF1005504
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 17:41:31 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03AC319635
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 17:41:30 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/9] xfs: remove duplicate wq cancel and log force from attr quiesce
Date:   Wed,  6 Jan 2021 12:41:25 -0500
Message-Id: <20210106174127.805660-8-bfoster@redhat.com>
In-Reply-To: <20210106174127.805660-1-bfoster@redhat.com>
References: <20210106174127.805660-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

These two calls are repeated at the beginning of xfs_log_quiesce().
Drop them from xfs_quiesce_attr().

Signed-off-by: Brian Foster <bfoster@redhat.com>
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

