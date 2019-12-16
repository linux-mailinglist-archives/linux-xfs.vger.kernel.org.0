Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 470A5121C30
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Dec 2019 22:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfLPVws (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Dec 2019 16:52:48 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:51416 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbfLPVws (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Dec 2019 16:52:48 -0500
Received: from dread.disaster.area (pa49-195-139-249.pa.nsw.optusnet.com.au [49.195.139.249])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BF8EC3A224B
        for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2019 08:52:46 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1igyIH-0005FW-Ik
        for linux-xfs@vger.kernel.org; Tue, 17 Dec 2019 08:52:45 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1igyIH-0003Z9-Gy
        for linux-xfs@vger.kernel.org; Tue, 17 Dec 2019 08:52:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfsprogs: don't warn about packed members
Date:   Tue, 17 Dec 2019 08:52:45 +1100
Message-Id: <20191216215245.13666-1-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=KoypXv6BqLCQNZUs2nCMWg==:117 a=KoypXv6BqLCQNZUs2nCMWg==:17
        a=IkcTkHD0fZMA:10 a=pxVhFHJ0LMsA:10 a=20KFwNOVAAAA:8
        a=aV8J6cUeWbv0LNGr7ZEA:9 a=SzMMtkAavwR9pTa-:21 a=VeY296wEGKNYUTWX:21
        a=QEXdDO2ut3YA:10
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

gcc 9.2.1 throws lots of new warnings during the build like this:

xfs_format.h:790:3: warning: taking address of packed member of ‘struct xfs_agfl’ may result in an unaligned pointer value [-Waddress-of-packed-member]
  790 |   &(XFS_BUF_TO_AGFL(bp)->agfl_bno[0]) : \
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
xfs_alloc.c:3149:13: note: in expansion of macro ‘XFS_BUF_TO_AGFL_BNO’
 3149 |  agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
      |             ^~~~~~~~~~~~~~~~~~~

We know this packed structure aligned correctly, so turn off this
warning to shut gcc up.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/builddefs.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/builddefs.in b/include/builddefs.in
index 4700b52706a7..6fdc9ebb70c7 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -13,7 +13,7 @@ OPTIMIZER = @opt_build@
 MALLOCLIB = @malloc_lib@
 LOADERFLAGS = @LDFLAGS@
 LTLDFLAGS = @LDFLAGS@
-CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64
+CFLAGS = @CFLAGS@ -D_FILE_OFFSET_BITS=64 -Wno-address-of-packed-member
 BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64
 
 LIBRT = @librt@
-- 
2.24.0.rc0

