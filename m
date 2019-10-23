Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBBCE181B
	for <lists+linux-xfs@lfdr.de>; Wed, 23 Oct 2019 12:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404447AbfJWKhY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 23 Oct 2019 06:37:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:50362 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404332AbfJWKhY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Oct 2019 06:37:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 017CAAFC1;
        Wed, 23 Oct 2019 10:37:23 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id B3EED1E4A89; Wed, 23 Oct 2019 12:37:22 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-xfs@vger.kernel.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Yang Xu <xuyang2018.jy@cn.fujitsu.com>,
        Eric Sandeen <sandeen@sandeen.net>, Jan Kara <jack@suse.cz>
Subject: [PATCH] xfs: Sanity check flags of Q_XQUOTARM call
Date:   Wed, 23 Oct 2019 12:37:19 +0200
Message-Id: <20191023103719.28117-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Flags passed to Q_XQUOTARM were not sanity checked for invalid values.
Fix that.

Fixes: 9da93f9b7cdf ("xfs: fix Q_XQUOTARM ioctl")
Reported-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_quotaops.c | 3 +++
 1 file changed, 3 insertions(+)

Strictly speaking this may cause user visible regression
(invalid flags are no longer getting ignored) but in this particular
case I think we could get away with it.


diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index cd6c7210a373..c7de17deeae6 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -201,6 +201,9 @@ xfs_fs_rm_xquota(
 	if (XFS_IS_QUOTA_ON(mp))
 		return -EINVAL;
 
+	if (uflags & ~(FS_USER_QUOTA | FS_GROUP_QUOTA | FS_PROJ_QUOTA))
+		return -EINVAL;
+
 	if (uflags & FS_USER_QUOTA)
 		flags |= XFS_DQ_USER;
 	if (uflags & FS_GROUP_QUOTA)
-- 
2.16.4

