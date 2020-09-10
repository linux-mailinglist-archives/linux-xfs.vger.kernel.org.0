Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D4C2653A2
	for <lists+linux-xfs@lfdr.de>; Thu, 10 Sep 2020 23:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgIJVim (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 10 Sep 2020 17:38:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20415 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730276AbgIJN3b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Sep 2020 09:29:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599744569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1hXURNUX7MS+7jhA1iFxmKgg5GWwg9ioRsIa/XmKfI0=;
        b=KkDnnZ4ebPl6kcHYPyqC18VuQ9YOenwWxLPd1qu0Dy8pOtDOCsk4h7XBarg7GswPc14YXr
        /p2CvNQIsIuKeQ/OsAWUyyZpss5a+wLydJhL3rCqcdTgD5QXAFaf8dh5D02mvA0O3lb32j
        CTJjqUzBYnNgHw5gTG9Xv6TqeGhoX0M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-UmwqbCcOPNimTzFBtgEHog-1; Thu, 10 Sep 2020 09:29:27 -0400
X-MC-Unique: UmwqbCcOPNimTzFBtgEHog-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10DDE8010EB
        for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2020 13:29:27 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C475F81C4A
        for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2020 13:29:26 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: drop extra transaction roll from inode extent truncate
Date:   Thu, 10 Sep 2020 09:29:26 -0400
Message-Id: <20200910132926.1147266-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The inode extent truncate path unmaps extents from the inode block
mapping, finishes deferred ops to free the associated extents and
then explicitly rolls the transaction before processing the next
extent. The latter extent roll is spurious as xfs_defer_finish()
always returns a clean transaction and automatically relogs inodes
attached to the transaction (with lock_flags == 0). This can
unnecessarily increase the number of log ticket regrants that occur
during a long running truncate operation. Remove the explicit
transaction roll.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Just something I noticed when reading through the code based on Dave's
recent EFI recovery reservation patches..

Brian

 fs/xfs/xfs_inode.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c06129cffba9..7af99c7a2821 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1532,17 +1532,10 @@ xfs_itruncate_extents_flags(
 		if (error)
 			goto out;
 
-		/*
-		 * Duplicate the transaction that has the permanent
-		 * reservation and commit the old transaction.
-		 */
+		/* free the just unmapped extents */
 		error = xfs_defer_finish(&tp);
 		if (error)
 			goto out;
-
-		error = xfs_trans_roll_inode(&tp, ip);
-		if (error)
-			goto out;
 	}
 
 	if (whichfork == XFS_DATA_FORK) {
-- 
2.25.4

