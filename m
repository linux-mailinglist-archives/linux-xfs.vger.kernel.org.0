Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F9B4204A
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 11:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405666AbfFLJKE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 05:10:04 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:22536 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2405024AbfFLJKE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 05:10:04 -0400
X-IronPort-AV: E=Sophos;i="5.63,363,1557158400"; 
   d="scan'208";a="67069444"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 12 Jun 2019 17:10:01 +0800
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id D1F744CDD0CA
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 17:09:59 +0800 (CST)
Received: from localhost.localdomain (10.167.215.30) by
 G08CNEXCHPEKD02.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Wed, 12 Jun 2019 17:09:57 +0800
From:   Yang Xu <xuyang2018.jy@cn.fujitsu.com>
To:     <linux-xfs@vger.kernel.org>
CC:     Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Subject: [PATCH] mkfs: remove useless log options in usage
Date:   Wed, 12 Jun 2019 17:09:35 +0800
Message-ID: <1560330575-2209-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.215.30]
X-yoursite-MailScanner-ID: D1F744CDD0CA.AF8CF
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: xuyang2018.jy@cn.fujitsu.com
X-Spam-Status: No
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since commit 2cf637cf(mkfs: remove logarithm based CLI options),
xfsprogs has discarded log options in node_options, remove it in usage.

Signed-off-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
---
 mkfs/xfs_mkfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index db3ad38e..91391b72 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -858,7 +858,7 @@ usage( void )
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectsize=num\n\
 /* force overwrite */	[-f]\n\
-/* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
+/* inode size */	[-i perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
 			    projid32bit=0|1,sparse=0|1]\n\
 /* no discard */	[-K]\n\
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
-- 
2.18.1



