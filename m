Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B72387B7FF
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Jul 2019 04:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfGaCaD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Jul 2019 22:30:03 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:16800 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725877AbfGaCaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jul 2019 22:30:03 -0400
X-IronPort-AV: E=Sophos;i="5.64,328,1559491200"; 
   d="scan'208";a="72556697"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 31 Jul 2019 10:30:00 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 235E54B4041E;
        Wed, 31 Jul 2019 10:29:56 +0800 (CST)
Received: from iridescent.g08.fujitsu.local (10.167.225.140) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Wed, 31 Jul 2019 10:30:04 +0800
From:   Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To:     <guaneryu@gmail.com>, <darrick.wong@oracle.com>
CC:     <ruansy.fnst@cn.fujitsu.com>, <fstests@vger.kernel.org>,
        <linux-xfs@vger.kernel.org>
Subject: [PATCH v2] common/rc: check 'chattr +/-x' on dax device.
Date:   Wed, 31 Jul 2019 10:29:49 +0800
Message-ID: <20190731022949.2463-1-ruansy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.17.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.140]
X-yoursite-MailScanner-ID: 235E54B4041E.A2D65
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
it's better to do the check on a dax device.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 common/rc | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/common/rc b/common/rc
index e0b087c1..91ab2900 100644
--- a/common/rc
+++ b/common/rc
@@ -2094,11 +2094,23 @@ _require_xfs_io_command()
 		if [ -z "$param" ]; then
 			param=s
 		fi
+
+		# Attribute "x" should be tested on a dax device
+		if [ "$param" = "x" ]; then
+			_require_scratch_dax
+			_scratch_mount
+			testfile=$SCRATCH_MNT/$$.xfs_io
+		fi
+
 		# Test xfs_io chattr support AND
 		# filesystem FS_IOC_FSSETXATTR support
 		testio=`$XFS_IO_PROG -F -f -c "chattr +$param" $testfile 2>&1`
 		$XFS_IO_PROG -F -f -r -c "chattr -$param" $testfile 2>&1
 		param_checked="+$param"
+
+		if [ "$param" = "x" ]; then
+			_scratch_unmount
+		fi
 		;;
 	"chproj")
 		testio=`$XFS_IO_PROG -F -f -c "chproj 0" $testfile 2>&1`
-- 
2.17.0



