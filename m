Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F92394FF8
	for <lists+linux-xfs@lfdr.de>; Mon, 19 Aug 2019 23:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbfHSVjV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 19 Aug 2019 17:39:21 -0400
Received: from mga04.intel.com ([192.55.52.120]:35701 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728014AbfHSVjV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Aug 2019 17:39:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 14:39:21 -0700
X-IronPort-AV: E=Sophos;i="5.64,406,1559545200"; 
   d="scan'208";a="168879691"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.157])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 14:39:20 -0700
From:   ira.weiny@intel.com
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH] fs/xfs: Fix return code of xfs_break_leased_layouts()
Date:   Mon, 19 Aug 2019 14:39:18 -0700
Message-Id: <20190819213918.29371-1-ira.weiny@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

The parens used in the while loop would result in error being assigned
the value 1 rather than the intended errno value.

This is required to return -ETXTBSY from follow on break_layout()
changes.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 fs/xfs/xfs_pnfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 0c954cad7449..a339bd5fa260 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -32,7 +32,7 @@ xfs_break_leased_layouts(
 	struct xfs_inode	*ip = XFS_I(inode);
 	int			error;
 
-	while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
+	while ((error = break_layout(inode, false)) == -EWOULDBLOCK) {
 		xfs_iunlock(ip, *iolock);
 		*did_unlock = true;
 		error = break_layout(inode, true);
-- 
2.20.1

