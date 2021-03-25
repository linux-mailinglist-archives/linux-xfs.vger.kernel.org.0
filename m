Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8ED348B51
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Mar 2021 09:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhCYIPJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Mar 2021 04:15:09 -0400
Received: from relay.herbolt.com ([37.46.208.54]:44836 "EHLO relay.herbolt.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229590AbhCYIPC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 04:15:02 -0400
Received: from ip-78-102-244-147.net.upcbroadband.cz (ip-78-102-244-147.net.upcbroadband.cz [78.102.244.147])
        by relay.herbolt.com (Postfix) with ESMTPSA id 931041034149;
        Thu, 25 Mar 2021 09:14:59 +0100 (CET)
Received: from localhost.localdomain (ip-89-176-186-13.net.upcbroadband.cz [89.176.186.13])
        by mail.herbolt.com (Postfix) with ESMTPSA id 2A7C6D34A0A;
        Thu, 25 Mar 2021 09:14:59 +0100 (CET)
From:   lukas@herbolt.com
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, Lukas Herbolt <lukas@herbolt.com>
Subject: [PATCH] xfsdocs: Small fix to correct first free inode to be 5847 not 5856.
Date:   Thu, 25 Mar 2021 09:14:16 +0100
Message-Id: <20210325081416.3190060-1-lukas@herbolt.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210324184835.GU22100@magnolia>
References: <20210324184835.GU22100@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Lukas Herbolt <lukas@herbolt.com>

Thanks for confirmation, I was not sure about it.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 design/XFS_Filesystem_Structure/allocation_groups.asciidoc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 992615d..cdc8545 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -1099,7 +1099,7 @@ recs[1-85] = [startino,freecount,free]
 Most of the inode chunks on this filesystem are totally full, since the +free+
 value is zero.  This means that we ought to expect inode 160 to be linked
 somewhere in the directory structure.  However, notice that 0xff80000000000000
-in record 85 -- this means that we would expect inode 5856 to be free.  Moving
+in record 85 -- this means that we would expect inode 5847 to be free.  Moving
 on to the free inode B+tree, we see that this is indeed the case:
 
 ----
-- 
2.26.2

