Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CB040CBA0
	for <lists+linux-xfs@lfdr.de>; Wed, 15 Sep 2021 19:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhIORY0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 Sep 2021 13:24:26 -0400
Received: from sandeen.net ([63.231.237.45]:33376 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230180AbhIORYY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 13:24:24 -0400
Received: by sandeen.net (Postfix, from userid 500)
        id 924E578C9; Wed, 15 Sep 2021 12:22:53 -0500 (CDT)
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     dan.j.williams@intel.com
Subject: [PATCH 2/3] ext4: remove dax EXPERIMENTAL warning
Date:   Wed, 15 Sep 2021 12:22:40 -0500
Message-Id: <1631726561-16358-3-git-send-email-sandeen@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1631726561-16358-1-git-send-email-sandeen@redhat.com>
References: <1631726561-16358-1-git-send-email-sandeen@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As there seems to be no significant outstanding concern about
dax on ext4 at this point, remove the scary EXPERIMENTAL
warning when in use.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext4/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0775950..82948d6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2346,8 +2346,6 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 					     "both data=journal and dax");
 				    return -1;
 			}
-			ext4_msg(sb, KERN_WARNING,
-				"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 			sbi->s_mount_opt |= EXT4_MOUNT_DAX_ALWAYS;
 			sbi->s_mount_opt2 &= ~EXT4_MOUNT2_DAX_NEVER;
 			break;
-- 
1.8.3.1

