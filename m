Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6D435E7F3
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Apr 2021 23:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhDMVBV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 13 Apr 2021 17:01:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231640AbhDMVBU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 17:01:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8DB661158;
        Tue, 13 Apr 2021 21:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618347660;
        bh=Lx8IKenAWeblb/zHN2qf3ylBdwUNVWu4Z1gIavUzJP4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JUF/BOZ8GP8sBQyJ4pin5GWwrtfjWI2jD30mtg+oBcb1QdHIAYUK2Ww/szRv9ul60
         j7VwB0W84v3LWNeengN9PXLL5R6UQ1ajDqoGAz0n93xFEh/4l/vHrn94ZFjE0QgjBt
         891b2kl6wcEMLqpJ7/1gOGeK/pxNJehgKMdcLNMUjlYN22BqaCYs1rTbCC4q1FTTqB
         6KU7gM9Nb5tFP1orJWaYREBiKtJvm8joHiI56b7DMTLj7tH685Hq5vN3RLcCCsUU5h
         yWj42Dv4PGMXUN+FfcN62e4ZqJ8o6XkgUV5C50Z+g1ocxHzMxnlgpcJJ9XLFgRZ9ln
         xwnK7Z4kC+yqw==
Subject: [PATCH 2/2] xfs_admin: pick up log arguments correctly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 13 Apr 2021 14:00:59 -0700
Message-ID: <161834765914.2607077.678191068662384784.stgit@magnolia>
In-Reply-To: <161834764606.2607077.6884775882008256887.stgit@magnolia>
References: <161834764606.2607077.6884775882008256887.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit ab9d8d69, we added support to xfs_admin to pass an external
log to xfs_db and xfs_repair.  Unfortunately, we didn't do this
correctly -- by appending the log arguments to DB_OPTS, we now guarantee
an invocation of xfs_db when we don't have any work for it to do.

Brian Foster noticed that this results in xfs/764 hanging fstests
because xfs_db (when not compiled with libeditline) will wait for input
on stdin.  I didn't notice because my build includes libeditline and my
test runner script does silly things with pipes such that xfs_db would
exit immediately.

Reported-by: Brian Foster <bfoster@redhat.com>
Fixes: ab9d8d69 ("xfs_admin: support adding features to V5 filesystems")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/xfs_admin.sh |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index 916050cb..409975b2 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -8,7 +8,7 @@ status=0
 DB_OPTS=""
 REPAIR_OPTS=""
 REPAIR_DEV_OPTS=""
-DB_LOG_OPTS=""
+LOG_OPTS=""
 USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
 
 while getopts "c:efjlL:O:pr:uU:V" c
@@ -40,19 +40,18 @@ case $# in
 	1|2)
 		# Pick up the log device, if present
 		if [ -n "$2" ]; then
-			DB_OPTS=$DB_OPTS" -l '$2'"
-			REPAIR_DEV_OPTS=$REPAIR_DEV_OPTS" -l '$2'"
+			LOG_OPTS=" -l '$2'"
 		fi
 
 		if [ -n "$DB_OPTS" ]
 		then
-			eval xfs_db -x -p xfs_admin $DB_OPTS "$1"
+			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_OPTS "$1"
 			status=$?
 		fi
 		if [ -n "$REPAIR_OPTS" ]
 		then
 			echo "Running xfs_repair to upgrade filesystem."
-			eval xfs_repair $REPAIR_DEV_OPTS $REPAIR_OPTS "$1"
+			eval xfs_repair $LOG_OPTS $REPAIR_DEV_OPTS $REPAIR_OPTS "$1"
 			status=`expr $? + $status`
 		fi
 		;;

