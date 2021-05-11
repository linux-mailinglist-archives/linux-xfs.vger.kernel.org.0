Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67B737A82D
	for <lists+linux-xfs@lfdr.de>; Tue, 11 May 2021 15:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbhEKNyO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 May 2021 09:54:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21172 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231649AbhEKNyI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 09:54:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620741181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sgR+KIH4Hh42mvX+JEPtWztncyfXaw3i5mewpbhkXkM=;
        b=dBpDa7Zd5uUFmIVpn3rj1qCjUYN7RiIc+1f66ry+uoEyJcIEu+ox9WEzwUABmTrDVL5AlP
        rM27GoHQgeAPjEPp4IfJ01wCh3s2w0EEihZLy7uD90AatWJ6gq83WdXPSvt0Rdx4Kg3GJr
        vZYQibx1FEd+16Ceh0S3iEvIZaFUyZk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-EBRxvhNXMI6lrekBCDy_cw-1; Tue, 11 May 2021 09:52:59 -0400
X-MC-Unique: EBRxvhNXMI6lrekBCDy_cw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FFEE107ACF4
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 13:52:58 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-80.rdu2.redhat.com [10.10.113.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43A0619CBF
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 13:52:58 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: remove dead stale buf unpin handling code
Date:   Tue, 11 May 2021 09:52:57 -0400
Message-Id: <20210511135257.878743-3-bfoster@redhat.com>
In-Reply-To: <20210511135257.878743-1-bfoster@redhat.com>
References: <20210511135257.878743-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This code goes back to a time when transaction commits wrote
directly to iclogs. The associated log items were pinned, written to
the log, and then "uncommitted" if some part of the log write had
failed. This uncommit sequence called an ->iop_unpin_remove()
handler that was eventually folded into ->iop_unpin() via the remove
parameter. The log subsystem has since changed significantly in that
transactions commit to the CIL instead of direct to iclogs, though
log items must still be aborted in the event of an eventual log I/O
error. However, the context for a log item abort is now asynchronous
from transaction commit, which means the committing transaction has
been freed by this point in time and the transaction uncommit
sequence of events is no longer relevant.

Further, since stale buffers remain locked at transaction commit
through unpin, we can be certain that the buffer is not associated
with any transaction when the unpin callback executes. Remove this
unused hunk of code and replace it with an assertion that the buffer
is disassociated from transaction context.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 7ff31788512b..634abf30b5bc 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -517,28 +517,10 @@ xfs_buf_item_unpin(
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(bp->b_flags & XBF_STALE);
 		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+		ASSERT(list_empty(&lip->li_trans) && !bp->b_transp);
 
 		trace_xfs_buf_item_unpin_stale(bip);
 
-		if (remove) {
-			/*
-			 * If we are in a transaction context, we have to
-			 * remove the log item from the transaction as we are
-			 * about to release our reference to the buffer.  If we
-			 * don't, the unlock that occurs later in
-			 * xfs_trans_uncommit() will try to reference the
-			 * buffer which we no longer have a hold on.
-			 */
-			if (!list_empty(&lip->li_trans))
-				xfs_trans_del_item(lip);
-
-			/*
-			 * Since the transaction no longer refers to the buffer,
-			 * the buffer should no longer refer to the transaction.
-			 */
-			bp->b_transp = NULL;
-		}
-
 		/*
 		 * If we get called here because of an IO error, we may or may
 		 * not have the item on the AIL. xfs_trans_ail_delete() will
-- 
2.26.3

