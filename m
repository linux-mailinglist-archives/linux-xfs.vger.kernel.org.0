Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD4E141C28
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 08:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731025AbfFLGYl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 02:24:41 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:58540 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731018AbfFLGYl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:24:41 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04391;MF=alvin@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0TTyt5Yb_1560320678;
Received: from alinux2-6.system.alibaba-inc.com(mailfrom:Alvin@linux.alibaba.com fp:SMTPD_---0TTyt5Yb_1560320678)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 12 Jun 2019 14:24:39 +0800
From:   Alvin@linux.alibaba.com
To:     linux-xfs@vger.kernel.org
Cc:     caspar@linux.alibaba.com, Alvin Zheng <Alvin@linux.alibaba.com>
Subject: [PATCH] Fix the inconsistency between the code and the manual page of mkfs.xfs
Date:   Wed, 12 Jun 2019 14:23:29 +0800
Message-Id: <1560320609-6336-1-git-send-email-Alvin@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Alvin Zheng <Alvin@linux.alibaba.com>

Signed-off-by: Alvin Zheng <Alvin@linux.alibaba.com>
---
 man/man8/mkfs.xfs.8 | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 4b8c78c..45d7a84 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -115,9 +115,7 @@ When specifying parameters in units of sectors or filesystem blocks, the
 .B \-s
 option or the
 .B \-b
-option first needs to be added to the command line.
-Failure to specify the size of the units will result in illegal value errors
-when parameters are quantified in those units.
+option can be used to specify the size of the sector or block. If the size of the block or sector is not specified, the default size (block: 4KiB, sector: 512B) will be used.
 .PP
 Many feature options allow an optional argument of 0 or 1, to explicitly
 disable or enable the functionality.
@@ -136,10 +134,6 @@ The filesystem block size is specified with a
 in bytes. The default value is 4096 bytes (4 KiB), the minimum is 512, and the
 maximum is 65536 (64 KiB).
 .IP
-To specify any options on the command line in units of filesystem blocks, this
-option must be specified first so that the filesystem block size is
-applied consistently to all options.
-.IP
 Although
 .B mkfs.xfs
 will accept any of these values and create a valid filesystem,
@@ -894,10 +888,6 @@ is 512 bytes. The minimum value for sector size is
 .I sector_size
 must be a power of 2 size and cannot be made larger than the
 filesystem block size.
-.IP
-To specify any options on the command line in units of sectors, this
-option must be specified first so that the sector size is
-applied consistently to all options.
 .RE
 .TP
 .BI \-L " label"
-- 
1.8.3.1

