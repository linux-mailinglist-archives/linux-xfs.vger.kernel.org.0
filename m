Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC27137B40C
	for <lists+linux-xfs@lfdr.de>; Wed, 12 May 2021 04:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhELCDf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 May 2021 22:03:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhELCDf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 May 2021 22:03:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FED1610EA;
        Wed, 12 May 2021 02:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620784947;
        bh=E3fp73kEkXlao2VJ4FMiNW7ea9D46vQUKj9v0tATdcQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lkl7ny98wESpBHSLfOC7d7ZnD32ZqHKuEnS9E/a421tWoWvN1myttmn6QJgJVE9IC
         Z+PYSBV9YFeZmGMyncVOqU+u4XOVn6b9UipKPFL4A0V+qXQQH11K7k5QdoHknXd/8M
         yZtRyzWzX205oTx4phzWThFM0xdDOhKXpvS4BZqqCkNPCYq80DdC3bfwUdoWIzUUJz
         bKTfnjXblDKktrBz9Tb0CPfA/g2bzkSWyeZqV+kjfabjHXiJ/rzOlEjti6pyqryyDD
         ahaas7gaZ7CujQjmVH/alZs9V9Astys4K5ASorNHPfVUqsQimqri9bwp1l23DgCett
         ap2Nic1br+3pg==
Subject: [PATCH 8/8] xfs/178: fix mkfs success test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 May 2021 19:02:24 -0700
Message-ID: <162078494495.3302755.13327851823592717788.stgit@magnolia>
In-Reply-To: <162078489963.3302755.9219127595550889655.stgit@magnolia>
References: <162078489963.3302755.9219127595550889655.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix the obviously incorrect code here that wants to fail the test if
mkfs doesn't succeed.  The return value ("$?") is always the status of
the /last/ command in the pipe.  Change the checker to _notrun so that
we don't leave the scratch check files around.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/178 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/178 b/tests/xfs/178
index a24ef50c..bf72e640 100755
--- a/tests/xfs/178
+++ b/tests/xfs/178
@@ -57,8 +57,8 @@ _supported_fs xfs
 #             fix filesystem, new mkfs.xfs will be fine.
 
 _require_scratch
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs \
-        || _fail "mkfs failed!"
+_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+test "${PIPESTATUS[0]}" -eq 0 || _notrun "mkfs failed!"
 
 # By executing the followint tmp file, will get on the mkfs options stored in
 # variables

