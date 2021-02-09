Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4284314768
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Feb 2021 05:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhBIERE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Feb 2021 23:17:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:48558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230329AbhBIENr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:13:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 512FB64EC8;
        Tue,  9 Feb 2021 04:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843861;
        bh=BE0Xuc6MpJBj7P96gIU9iko52AIbq+5qJW2aRKUIXGc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ic627t3GZcZb5PId+JmWVbMuizXimQb5ATuB5bcMPuhtMh46SGRYwbryqIwEURUUy
         y33MO/NWz8kFpcoUu1LedHZVT0qt3GvX9BAmVcVSkGhxNIgQ2gxhJ6p/QRqCMhMzY6
         pDBhN2tD5IJhuwO6JM28/OtEtNsNPWU5/mjaHW5oKGTRVOLT6VVy9jPcsXLvtKpByn
         NT68Av5CEIK5znwpxfgQGMNTC3vwlf0qUeifsKSOLJrZZow/ezWuRdToXhZgq1aVNv
         As0JSCmLhl9uVlWu5VchwG/rQ9CCokWdt7Mqq0c/cTykUIilKmIXzXX133xuYhhZ5n
         i+B1AYudIRwUQ==
Subject: [PATCH 10/10] xfs_admin: support adding features to V5 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 08 Feb 2021 20:11:00 -0800
Message-ID: <161284386088.3057868.16559496991921219277.stgit@magnolia>
In-Reply-To: <161284380403.3057868.11153586180065627226.stgit@magnolia>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the xfs_admin script how to add features to V5 filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/xfs_admin.sh      |    6 ++++--
 man/man8/xfs_admin.8 |   22 ++++++++++++++++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)


diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index 430872ef..7a467dbe 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -8,9 +8,10 @@ status=0
 DB_OPTS=""
 REPAIR_OPTS=""
 REPAIR_DEV_OPTS=""
-USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-r rtdev] [-U uuid] device [logdev]"
+DB_LOG_OPTS=""
+USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
 
-while getopts "c:efjlL:pr:uU:V" c
+while getopts "c:efjlL:O:pr:uU:V" c
 do
 	case $c in
 	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG;;
@@ -19,6 +20,7 @@ do
 	j)	DB_OPTS=$DB_OPTS" -c 'version log2'";;
 	l)	DB_OPTS=$DB_OPTS" -r -c label";;
 	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
+	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG=1";;
 	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
 	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'";;
 	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index cccbb224..3f3aeea8 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -6,6 +6,8 @@ xfs_admin \- change parameters of an XFS filesystem
 [
 .B \-eflpu
 ] [
+.BI \-O " featurelist"
+] [
 .BR "\-c 0" | 1
 ] [
 .B \-L
@@ -106,6 +108,26 @@ The filesystem label can be cleared using the special "\c
 " value for
 .IR label .
 .TP
+.BI \-O " feature1" = "status" , "feature2" = "status..."
+Add or remove features on an existing a V5 filesystem.
+The features should be specified as a comma-separated list.
+.I status
+should be either 0 to disable the feature or 1 to enable the feature.
+Note, however, that most features cannot be disabled.
+.IP
+.B NOTE:
+Administrators must ensure the filesystem is clean by running
+.B xfs_repair -n
+to inspect the filesystem before performing the upgrade.
+If corruption is found, recovery procedures (e.g. reformat followed by
+restoration from backup; or running
+.B xfs_repair
+without the
+.BR -n )
+must be followed to clean the filesystem.
+.IP
+There are currently no feature options.
+.TP
 .BI \-U " uuid"
 Set the UUID of the filesystem to
 .IR uuid .

