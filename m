Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A068E7A338
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2019 10:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbfG3IkS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Jul 2019 04:40:18 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:35739 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728354AbfG3IkR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jul 2019 04:40:17 -0400
X-IronPort-AV: E=Sophos;i="5.64,326,1559491200"; 
   d="scan'208";a="72514497"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 30 Jul 2019 16:40:15 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 2675A4CDD99E;
        Tue, 30 Jul 2019 16:40:20 +0800 (CST)
Received: from iridescent.g08.fujitsu.local (10.167.225.140) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Tue, 30 Jul 2019 16:40:23 +0800
From:   Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To:     <guaneryu@gmail.com>, <darrick.wong@oracle.com>
CC:     <ruansy.fnst@cn.fujitsu.com>, <fstests@vger.kernel.org>,
        <linux-xfs@vger.kernel.org>
Subject: [PATCH] common/rc: check 'chattr +/-x' on dax device.
Date:   Tue, 30 Jul 2019 16:40:09 +0800
Message-ID: <20190730084009.26257-1-ruansy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.17.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.140]
X-yoursite-MailScanner-ID: 2675A4CDD99E.A732C
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-Spam-Status: No
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

'chattr +/-x' only works on a dax device.  When checking if the 'x'
attribute is supported by XFS_IO_PROG:
    _require_xfs_io_command "chattr" "x"    (called by xfs/260)
it's better to do the check on a dax device mounted with dax option.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 common/rc | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/common/rc b/common/rc
index e0b087c1..73ee5563 100644
--- a/common/rc
+++ b/common/rc
@@ -2094,11 +2094,22 @@ _require_xfs_io_command()
 		if [ -z "$param" ]; then
 			param=s
 		fi
+
+		# Attribute "x" should be tested on a dax device
+		if [ "$param" == "x" ]; then
+			_scratch_mount "-o dax"
+			testfile=$SCRATCH_MNT/$$.xfs_io
+		fi
+
 		# Test xfs_io chattr support AND
 		# filesystem FS_IOC_FSSETXATTR support
 		testio=`$XFS_IO_PROG -F -f -c "chattr +$param" $testfile 2>&1`
 		$XFS_IO_PROG -F -f -r -c "chattr -$param" $testfile 2>&1
 		param_checked="+$param"
+
+		if [ "$param" == "x" ]; then
+			_scratch_unmount
+		fi
 		;;
 	"chproj")
 		testio=`$XFS_IO_PROG -F -f -c "chproj 0" $testfile 2>&1`
-- 
2.17.0



