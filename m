Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 792489F31C
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Aug 2019 21:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731228AbfH0TRj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Aug 2019 15:17:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39602 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731213AbfH0TRh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Aug 2019 15:17:37 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 86A2A18C892C
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2019 19:17:37 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DAED36FB
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2019 19:17:37 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: log proper length of btree block in scrub/repair
Message-ID: <f66b01bb-b4ce-8713-c3db-fbbd39703737@redhat.com>
Date:   Tue, 27 Aug 2019 14:17:36 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Tue, 27 Aug 2019 19:17:37 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_trans_log_buf() takes a final argument of the last byte to
log in the buffer; b_length is in basic blocks, so this isn't
the correct last byte.  Fix it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

just found by inspection/pattern matching, not tested TBH...

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 4cfeec57fb05..7bcc755beb40 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -351,7 +351,7 @@ xrep_init_btblock(
 	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
 	xfs_btree_init_block(mp, bp, btnum, 0, 0, sc->sa.agno);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_BTREE_BUF);
-	xfs_trans_log_buf(tp, bp, 0, bp->b_length);
+	xfs_trans_log_buf(tp, bp, 0, BBTOB(bp->b_length) - 1);
 	bp->b_ops = ops;
 	*bpp = bp;
 

