Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75D2399871
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Jun 2021 05:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhFCDO0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 2 Jun 2021 23:14:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhFCDOZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 23:14:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7A4761360;
        Thu,  3 Jun 2021 03:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622689961;
        bh=fcRPVj1lP7RXFUhJd5LsKJPJqLO5gbDjlO+SZPw91i0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DnrMfTa24PwSMhUCZZBGgovcF0hySwpJPad1JH/MvZ9Dm2yUGCBFrOS2Y7hn/l0UQ
         FuN+RGl4iq+TBwZ9q+zZoVX5L3TIWZO+GMz+6IFHVVqUZ2pk5Ny4SoWBzx0Km52waW
         nqolgtTrvqSbqD1PgTOtBzF9lmVic9aJil6m/QyQ3QyQ7LOPMKscqjOIWFV+cMWBIm
         gKgou01zdP8FmJfNNcmknkbWqK9pUMkp8LKyhS92tYeAqWsCkwEupP/OHMTum5A+aq
         pI4A8qXB9ny8g3RQCa6oE76/Kp1hfTG6ChkiM/GUwa9S731i9ufpQDCK99MNLDx91p
         c8eGj/eVNgxhA==
Subject: [PATCH 1/3] xfs: only reset incore inode health state flags when
 reclaiming an inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 02 Jun 2021 20:12:41 -0700
Message-ID: <162268996135.2724138.14276025100886638786.stgit@locust>
In-Reply-To: <162268995567.2724138.15163777746481739089.stgit@locust>
References: <162268995567.2724138.15163777746481739089.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While running some fuzz tests on inode metadata, I noticed that the
filesystem health report (as provided by xfs_spaceman) failed to report
the file corruption even when spaceman was run immediately after running
xfs_scrub to detect the corruption.  That isn't the intended behavior;
one ought to be able to run scrub to detect errors in the ondisk
metadata and be able to access to those reports for some time after the
scrub.

After running the same sequence through an instrumented kernel, I
discovered the reason why -- scrub igets the file, scans it, marks it
sick, and ireleases the inode.  When the VFS lets go of the incore
inode, it moves to RECLAIMABLE state.  If spaceman igets the incore
inode before it moves to RECLAIM state, iget reinitializes the VFS
state, clears the sick and checked masks, and hands back the inode.  At
this point, the caller has the exact same incore inode, but with all the
health state erased.

In other words, we're erasing the incore inode's health state flags when
we've decided NOT to sever the link between the incore inode and the
ondisk inode.  This is wrong, so we need to remove the lines that zero
the fields from xfs_iget_cache_hit.

As a precaution, we add the same lines into xfs_reclaim_inode just after
we sever the link between incore and ondisk inode.  Strictly speaking
this isn't necessary because once an inode has gone through reclaim it
must go through xfs_inode_alloc (which also zeroes the state) and
xfs_iget is careful to check for mismatches between the inode it pulls
out of the radix tree and the one it wants.

Fixes: 6772c1f11206 ("xfs: track metadata health status")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 396cc54ca03f..c3f912a9231b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -523,9 +523,6 @@ xfs_iget_cache_hit(
 				XFS_INO_TO_AGINO(pag->pag_mount, ino),
 				XFS_ICI_RECLAIM_TAG);
 		inode->i_state = I_NEW;
-		ip->i_sick = 0;
-		ip->i_checked = 0;
-
 		spin_unlock(&ip->i_flags_lock);
 		spin_unlock(&pag->pag_ici_lock);
 	} else {
@@ -979,6 +976,8 @@ xfs_reclaim_inode(
 	spin_lock(&ip->i_flags_lock);
 	ip->i_flags = XFS_IRECLAIM;
 	ip->i_ino = 0;
+	ip->i_sick = 0;
+	ip->i_checked = 0;
 	spin_unlock(&ip->i_flags_lock);
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);

