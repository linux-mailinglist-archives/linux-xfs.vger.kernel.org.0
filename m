Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0DB268404
	for <lists+linux-xfs@lfdr.de>; Mon, 14 Sep 2020 07:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgINFW2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 14 Sep 2020 01:22:28 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:6058 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726026AbgINFW2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 01:22:28 -0400
X-IronPort-AV: E=Sophos;i="5.76,424,1592841600"; 
   d="scan'208";a="99192375"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 14 Sep 2020 13:22:23 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
        by cn.fujitsu.com (Postfix) with ESMTP id E07F948990EE;
        Mon, 14 Sep 2020 13:22:22 +0800 (CST)
Received: from G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.203) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Mon, 14 Sep 2020 13:22:23 +0800
Received: from Fedora-30.g08.fujitsu.local (10.167.220.106) by
 G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Mon, 14 Sep 2020 13:22:23 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
To:     <fstests@vger.kernel.org>
CC:     <darrick.wong@oracle.com>, <david@fromorbit.com>,
        <ira.weiny@intel.com>, <linux-xfs@vger.kernel.org>, <guan@eryu.me>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH v2 1/2] common/rc: Check 'tPnE' flags on a directory instead of a regilar file
Date:   Mon, 14 Sep 2020 13:13:59 +0800
Message-ID: <20200914051400.32057-1-yangx.jy@cn.fujitsu.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: E07F948990EE.A9F67
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
X-Spam-Status: No
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

'tPnE' flags are only valid for a directory so check them on a directory.

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 common/rc | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index aa5a7409..6487b9f2 100644
--- a/common/rc
+++ b/common/rc
@@ -2163,14 +2163,23 @@ _require_xfs_io_command()
 	local testio
 	case $command in
 	"chattr")
+		local testdir=$TEST_DIR/$$.attr_dir
+		mkdir $TEST_DIR/$$.attr_dir
 		if [ -z "$param" ]; then
 			param=s
 		fi
 		# Test xfs_io chattr support AND
 		# filesystem FS_IOC_FSSETXATTR support
-		testio=`$XFS_IO_PROG -F -f -c "chattr +$param" $testfile 2>&1`
-		$XFS_IO_PROG -F -f -r -c "chattr -$param" $testfile 2>&1
+		# 'tPnE' flags are only valid for a directory so check them on a directory.
+		if echo "$param" | egrep -q 't|P|n|E'; then
+			testio=`$XFS_IO_PROG -F -c "chattr +$param" $testdir 2>&1`
+			$XFS_IO_PROG -F -r -c "chattr -$param" $testdir 2>&1
+		else
+			testio=`$XFS_IO_PROG -F -f -c "chattr +$param" $testfile 2>&1`
+			$XFS_IO_PROG -F -r -c "chattr -$param" $testfile 2>&1
+		fi
 		param_checked="+$param"
+		rm -rf $testdir 2>&1 > /dev/null
 		;;
 	"chproj")
 		testio=`$XFS_IO_PROG -F -f -c "chproj 0" $testfile 2>&1`
-- 
2.21.0



