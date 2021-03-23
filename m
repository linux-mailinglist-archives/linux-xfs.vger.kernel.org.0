Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4CC3456B7
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Mar 2021 05:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhCWEVG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Mar 2021 00:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhCWEUu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 00:20:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FF8B6198E;
        Tue, 23 Mar 2021 04:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616473250;
        bh=GDWjU4DCIze5DwS4eYYYPuxPlGnlspEYDBe52dhwOH8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UqBkY2vVm08AEoCJW29uqVwHyXC43heW3b0CtBn7PMZ6fZD1CyRPaUoa4PQ9L1ws1
         2UHEdbHl+azbMGjhPTu8d7C1bmW9PPR6c+5mra4igZcZkrW+JoLfrvX45qx50sKJIO
         l0wox21CfvxikDAAJ56FcgBdN+DKfr+pUlL1epcxYHUHz/GQg1GJOdH3Rcp68k4tyt
         DnTIPzk5n0fCp/JylkLyB5M96SEiZPu2Y5SGJDPuPgGHx/FTR49Y3CHBEm8/1in58t
         NZmI/wC3yGcJH6PuO9TsiDc00etm51RE9NbTfkqJ5zonnmLq/fWORwEFACXIamCMWl
         j5AKaqXhYuq1g==
Subject: [PATCH 1/3] xfs/{010,030}: update repair output to deal with
 inobtcount feature
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 22 Mar 2021 21:20:50 -0700
Message-ID: <161647325010.3431131.10019758464943956019.stgit@magnolia>
In-Reply-To: <161647324459.3431131.16341235245632737552.stgit@magnolia>
References: <161647324459.3431131.16341235245632737552.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update both of these tests to filter out the new error messages from
repair when the inode btree counter feature is enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/010 |    3 ++-
 tests/xfs/030 |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/010 b/tests/xfs/010
index 1f9bcdff..95cc2555 100755
--- a/tests/xfs/010
+++ b/tests/xfs/010
@@ -113,7 +113,8 @@ _check_scratch_fs
 _corrupt_finobt_root $SCRATCH_DEV
 
 filter_finobt_repair() {
-	sed -e '/^agi has bad CRC/d' | \
+	sed -e '/^agi has bad CRC/d' \
+	    -e '/^bad finobt block/d' | \
 		_filter_repair_lostblocks
 }
 
diff --git a/tests/xfs/030 b/tests/xfs/030
index 04440f9c..906d9019 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -44,6 +44,8 @@ _check_ag()
 			    -e '/^bad agbno AGBNO for refcntbt/d' \
 			    -e '/^agf has bad CRC/d' \
 			    -e '/^agi has bad CRC/d' \
+			    -e '/^bad inobt block count/d' \
+			    -e '/^bad finobt block count/d' \
 			    -e '/^Missing reverse-mapping record.*/d' \
 			    -e '/^bad levels LEVELS for [a-z]* root.*/d' \
 			    -e '/^unknown block state, ag AGNO, block.*/d'

