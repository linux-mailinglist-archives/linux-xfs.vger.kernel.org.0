Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB35346F42
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Mar 2021 03:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbhCXCK1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Mar 2021 22:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231267AbhCXCKU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 22:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16ABC619F3;
        Wed, 24 Mar 2021 02:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616551820;
        bh=NvG2VrPqtaLvm7XDSALaBDEiHwsoMUkCGCayCTwxLQQ=;
        h=Date:From:To:Cc:Subject:From;
        b=VegzxjwS/2Wha0Rp6M/hn+YV1vWb1PCo0bYS4T6s40Esx/oRNHjoMtDMDLdrrUZhL
         wtL3lH8RovpzH80uPKyNjnPRAhJk7NDj6vdtma/w4UR7i/VpB4EidqNqqw30tx7ajI
         RpOgTei7R0HtYGdMsbbbhGGt3HI08AOwhvyfYaGhA4K9fAwNycJx+mxP3cm6XP5YWl
         S93v+1qopLGS92SStRw7/WMzBbgBq1c8eATh0BEPjxgfNxqYjV8vaz5dCabJU1m0vr
         ihf+yv30A7cXs1rqbTh/evoWyhsjWchyDNDXY2I1iywtHfk/PiAogF2HiUWQNgjKEs
         5R5Gy3IOJFGxw==
Date:   Tue, 23 Mar 2021 19:10:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs_admin: pick up log arguments correctly
Message-ID: <20210324021018.GQ22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
