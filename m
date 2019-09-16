Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A00DB3A1A
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Sep 2019 14:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731514AbfIPMQj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Sep 2019 08:16:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50722 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732374AbfIPMQj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Sep 2019 08:16:39 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 25B3910C093A
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 12:16:39 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6F565C258
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 12:16:38 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 07/11] xfs: refactor allocation tree fixup code
Date:   Mon, 16 Sep 2019 08:16:31 -0400
Message-Id: <20190916121635.43148-8-bfoster@redhat.com>
In-Reply-To: <20190916121635.43148-1-bfoster@redhat.com>
References: <20190916121635.43148-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Mon, 16 Sep 2019 12:16:39 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Both algorithms duplicate the same btree allocation code. Eliminate
the duplication and reuse the fallback algorithm codepath.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index edcec975c306..3eacc799c4cb 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1333,23 +1333,8 @@ xfs_alloc_ag_vextent_near(
 		if (acur.len == 0)
 			break;
 
-		/*
-		 * Allocate at the bno/len tracked in the cursor.
-		 */
-		args->agbno = acur.bno;
-		args->len = acur.len;
-		ASSERT(acur.bno >= acur.rec_bno);
-		ASSERT(acur.bno + acur.len <= acur.rec_bno + acur.rec_len);
-		ASSERT(acur.rec_bno + acur.rec_len <=
-		       be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
-
-		error = xfs_alloc_fixup_trees(acur.cnt, acur.bnolt,
-				acur.rec_bno, acur.rec_len, acur.bno, acur.len,
-				0);
-		if (error)
-			goto out;
 		trace_xfs_alloc_near_first(args);
-		goto out;
+		goto alloc;
 	}
 
 	/*
@@ -1434,6 +1419,7 @@ xfs_alloc_ag_vextent_near(
 		goto out;
 	}
 
+alloc:
 	args->agbno = acur.bno;
 	args->len = acur.len;
 	ASSERT(acur.bno >= acur.rec_bno);
-- 
2.20.1

