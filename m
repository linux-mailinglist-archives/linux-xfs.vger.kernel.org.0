Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385161DEE07
	for <lists+linux-xfs@lfdr.de>; Fri, 22 May 2020 19:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbgEVRSg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 22 May 2020 13:18:36 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22540 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730471AbgEVRSg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 13:18:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590167914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=s9nhXYl4ewDbem6zqXWAPp+atwRqCJBGAoE2u2n0pto=;
        b=ZDyDHYQM13PeqlyCf9exZOaETHY5bDffoNLQ9rDkmsehHQMG8d/zYGOH+s8J4/3fxgTpK9
        yIgoqiSFBDhMRvI330BkMkESC8ySpQqWZbVxaYd8EiEVVrp36GNrsqpzicFWj5n6KB6fx9
        GaJaV6LK0B1d3qnHIcf9CnLu10ZuSno=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-fKBrlXnhM3-dPYgQaAfwAg-1; Fri, 22 May 2020 13:18:30 -0400
X-MC-Unique: fKBrlXnhM3-dPYgQaAfwAg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B1AF1853C6F;
        Fri, 22 May 2020 17:18:29 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05D38105913F;
        Fri, 22 May 2020 17:18:28 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH] xfs: transfer freed blocks to blk res when lazy accounting
Date:   Fri, 22 May 2020 13:18:28 -0400
Message-Id: <20200522171828.53440-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Darrick mentioned on IRC a few days ago that he'd seen an issue that
looked similar to the problem with the rmapbt based extent swap
algorithm when the associated inodes happen to bounce between extent and
btree format. That problem caused repeated bmapbt block allocations and
frees that exhausted the transaction block reservation across the
sequence of transaction rolls. The workaround for that was to use an
oversized block reservation, but that is not a generic or efficient
solution.

I was originally playing around with some hacks to set an optional base
block reservation on the transaction that we would attempt to replenish
across transaction roll sequences as the block reservation depletes, but
eventually noticed that there isn't much difference between stuffing
block frees in the transaction reservation counter vs. the delta counter
when lazy sb accounting is enabled (which is required for v5 supers). As
such, the following patch seems to address the rmapbt issue in my
isolated tests.

I think one tradeoff with this logic is that chains of rolling/freeing
transactions would now aggregate freed space until the final transaction
commits vs. as transactions roll. It's not immediately clear to me how
much of an issue that is, but it sounds a bit dicey when considering
things like truncates of large files. This behavior could still be tied
to a transaction flag to restrict its use to situations like rmapbt
swapext, however. Anyways, this is mostly untested outside of the extent
swap use case so I wanted to throw this on the list as an RFC for now
and see if anybody has thoughts or other ideas.

Brian

 fs/xfs/xfs_bmap_util.c | 11 -----------
 fs/xfs/xfs_trans.c     |  4 ++++
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f37f5cc4b19f..74b3bad6c414 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1628,17 +1628,6 @@ xfs_swap_extents(
 		 */
 		resblks = XFS_SWAP_RMAP_SPACE_RES(mp, ipnext, w);
 		resblks +=  XFS_SWAP_RMAP_SPACE_RES(mp, tipnext, w);
-
-		/*
-		 * Handle the corner case where either inode might straddle the
-		 * btree format boundary. If so, the inode could bounce between
-		 * btree <-> extent format on unmap -> remap cycles, freeing and
-		 * allocating a bmapbt block each time.
-		 */
-		if (ipnext == (XFS_IFORK_MAXEXT(ip, w) + 1))
-			resblks += XFS_IFORK_MAXEXT(ip, w);
-		if (tipnext == (XFS_IFORK_MAXEXT(tip, w) + 1))
-			resblks += XFS_IFORK_MAXEXT(tip, w);
 	}
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
 	if (error)
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 28b983ff8b11..b421d27445c1 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -370,6 +370,10 @@ xfs_trans_mod_sb(
 			tp->t_blk_res_used += (uint)-delta;
 			if (tp->t_blk_res_used > tp->t_blk_res)
 				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		} else if (delta > 0 &&
+			   xfs_sb_version_haslazysbcount(&mp->m_sb)) {
+			tp->t_blk_res += delta;
+			delta = 0;
 		}
 		tp->t_fdblocks_delta += delta;
 		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
-- 
2.21.1

