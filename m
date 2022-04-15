Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC73501EC7
	for <lists+linux-xfs@lfdr.de>; Fri, 15 Apr 2022 00:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347388AbiDNW5p (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 14 Apr 2022 18:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347383AbiDNW53 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 18:57:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A377C3BF92
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 15:55:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55539B82B9B
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 22:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E0CC385A5;
        Thu, 14 Apr 2022 22:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649976900;
        bh=Q8i6IKXMPY6MvRTtSF72xlEl8Cwlk2+DP5wTTBT1wZs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n10SDBBGvOZIPugYE5eGqkNhVhhppfVqKqk2n1HopkGJA6gicFemDUtXqvt+7xPCQ
         UqNFgSgU/JGP+xh8KGT2r6F0MUpyS46rp8JjcSjMVgzfs68Pcnb8mxyNWC+do/KtTl
         TaT5ci7X//xSNyaj/GHYfvRd8ziG9uq7aunhz9b1I98bU4CgVN/8w9cH/IUhvzYJ2y
         SSm+nHAAaSB8Py5p+YWCcBFAwWMGERnYWgwFFiCxNzoC5dgigmE/qc+UpZ8YThHCqd
         eA9mfzsUqMVE9m1/Ozte9xZXMO2ZUM/Gkr/0R8DtdIMYK2fBNpdmDKeZdSc9gZxPef
         8JQIR/7pcKyBw==
Subject: [PATCH 6/6] xfs: rewrite xfs_reflink_end_cow to use intents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Apr 2022 15:54:59 -0700
Message-ID: <164997689961.383881.592770760091459460.stgit@magnolia>
In-Reply-To: <164997686569.383881.8935566398533700022.stgit@magnolia>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, the code that performs CoW remapping after a write has this
odd behavior where it walks /backwards/ through the data fork to remap
extents in reverse order.  Earlier, we rewrote the reflink remap
function to use deferred bmap log items instead of trying to cram as
much into the first transaction that we could.  Now do the same for the
CoW remap code.  There doesn't seem to be any performance impact; we're
just making better use of code that we added for the benefit of reflink.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |   88 ++++++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_trace.h   |    3 +-
 2 files changed, 58 insertions(+), 33 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 09bedbfef01a..27f5b17d03aa 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -586,21 +586,21 @@ xfs_reflink_cancel_cow_range(
 STATIC int
 xfs_reflink_end_cow_extent(
 	struct xfs_inode	*ip,
-	xfs_fileoff_t		offset_fsb,
-	xfs_fileoff_t		*end_fsb)
+	xfs_fileoff_t		*offset_fsb,
+	xfs_fileoff_t		end_fsb)
 {
-	struct xfs_bmbt_irec	got, del;
 	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got, del, data;
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
-	xfs_filblks_t		rlen;
 	unsigned int		resblks;
+	int			nmaps;
 	int			error;
 
 	/* No COW extents?  That's easy! */
 	if (ifp->if_bytes == 0) {
-		*end_fsb = offset_fsb;
+		*offset_fsb = end_fsb;
 		return 0;
 	}
 
@@ -628,42 +628,66 @@ xfs_reflink_end_cow_extent(
 	 * left by the time I/O completes for the loser of the race.  In that
 	 * case we are done.
 	 */
-	if (!xfs_iext_lookup_extent_before(ip, ifp, end_fsb, &icur, &got) ||
-	    got.br_startoff + got.br_blockcount <= offset_fsb) {
-		*end_fsb = offset_fsb;
+	if (!xfs_iext_lookup_extent(ip, ifp, *offset_fsb, &icur, &got) ||
+	    got.br_startoff >= end_fsb) {
+		*offset_fsb = end_fsb;
 		goto out_cancel;
 	}
 
 	/*
-	 * Structure copy @got into @del, then trim @del to the range that we
-	 * were asked to remap.  We preserve @got for the eventual CoW fork
+	 * Only remap real extents that contain data.  With AIO, speculative
+	 * preallocations can leak into the range we are called upon, and we
+	 * need to skip them.  Preserve @got for the eventual CoW fork
 	 * deletion; from now on @del represents the mapping that we're
 	 * actually remapping.
 	 */
+	while (!xfs_bmap_is_written_extent(&got)) {
+		if (!xfs_iext_next_extent(ifp, &icur, &got) ||
+		    got.br_startoff >= end_fsb) {
+			*offset_fsb = end_fsb;
+			goto out_cancel;
+		}
+	}
 	del = got;
-	xfs_trim_extent(&del, offset_fsb, *end_fsb - offset_fsb);
 
-	ASSERT(del.br_blockcount > 0);
-
-	/*
-	 * Only remap real extents that contain data.  With AIO, speculative
-	 * preallocations can leak into the range we are called upon, and we
-	 * need to skip them.
-	 */
-	if (!xfs_bmap_is_written_extent(&got)) {
-		*end_fsb = del.br_startoff;
-		goto out_cancel;
-	}
-
-	/* Unmap the old blocks in the data fork. */
-	rlen = del.br_blockcount;
-	error = __xfs_bunmapi(tp, ip, del.br_startoff, &rlen, 0, 1);
+	/* Grab the corresponding mapping in the data fork. */
+	nmaps = 1;
+	error = xfs_bmapi_read(ip, del.br_startoff, del.br_blockcount, &data,
+			&nmaps, 0);
 	if (error)
 		goto out_cancel;
 
-	/* Trim the extent to whatever got unmapped. */
-	xfs_trim_extent(&del, del.br_startoff + rlen, del.br_blockcount - rlen);
-	trace_xfs_reflink_cow_remap(ip, &del);
+	/* We can only remap the smaller of the two extent sizes. */
+	data.br_blockcount = min(data.br_blockcount, del.br_blockcount);
+	del.br_blockcount = data.br_blockcount;
+
+	trace_xfs_reflink_cow_remap_from(ip, &del);
+	trace_xfs_reflink_cow_remap_to(ip, &data);
+
+	if (xfs_bmap_is_real_extent(&data)) {
+		/*
+		 * If the extent we're remapping is backed by storage (written
+		 * or not), unmap the extent and drop its refcount.
+		 */
+		xfs_bmap_unmap_extent(tp, ip, &data);
+		xfs_refcount_decrease_extent(tp, &data);
+		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
+				-data.br_blockcount);
+	} else if (data.br_startblock == DELAYSTARTBLOCK) {
+		int		done;
+
+		/*
+		 * If the extent we're remapping is a delalloc reservation,
+		 * we can use the regular bunmapi function to release the
+		 * incore state.  Dropping the delalloc reservation takes care
+		 * of the quota reservation for us.
+		 */
+		error = xfs_bunmapi(NULL, ip, data.br_startoff,
+				data.br_blockcount, 0, 1, &done);
+		if (error)
+			goto out_cancel;
+		ASSERT(done);
+	}
 
 	/* Free the CoW orphan record. */
 	xfs_refcount_free_cow_extent(tp, del.br_startblock, del.br_blockcount);
@@ -684,7 +708,7 @@ xfs_reflink_end_cow_extent(
 		return error;
 
 	/* Update the caller about how much progress we made. */
-	*end_fsb = del.br_startoff;
+	*offset_fsb = del.br_startoff + del.br_blockcount;
 	return 0;
 
 out_cancel:
@@ -712,7 +736,7 @@ xfs_reflink_end_cow(
 	end_fsb = XFS_B_TO_FSB(ip->i_mount, offset + count);
 
 	/*
-	 * Walk backwards until we're out of the I/O range.  The loop function
+	 * Walk forwards until we've remapped the I/O range.  The loop function
 	 * repeatedly cycles the ILOCK to allocate one transaction per remapped
 	 * extent.
 	 *
@@ -744,7 +768,7 @@ xfs_reflink_end_cow(
 	 * blocks will be remapped.
 	 */
 	while (end_fsb > offset_fsb && !error)
-		error = xfs_reflink_end_cow_extent(ip, offset_fsb, &end_fsb);
+		error = xfs_reflink_end_cow_extent(ip, &offset_fsb, end_fsb);
 
 	if (error)
 		trace_xfs_reflink_end_cow_error(ip, error, _RET_IP_);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d24784ab8cea..32cfc62f2777 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3421,7 +3421,8 @@ DEFINE_INODE_IREC_EVENT(xfs_reflink_convert_cow);
 
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_cancel_cow_range);
 DEFINE_SIMPLE_IO_EVENT(xfs_reflink_end_cow);
-DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap_from);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_cow_remap_to);
 
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_cancel_cow_range_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_end_cow_error);

