Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F43350822
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Mar 2021 22:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236438AbhCaUXZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 31 Mar 2021 16:23:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:32856 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236441AbhCaUXQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Mar 2021 16:23:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617222195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=aQCCFPFFDKmuQfqBjbvwASzlhLWQzEsG+/db46wEao8=;
        b=YxzRW9oxXOFHBsXf307g96PCyP4doyTX81uEN/dbfKx+COSiLXeqwILejNnt5Kk/WKNG4p
        y0LMaK4KbW9I+76YT0j3sbffMs1gBoJ3jAVGSppMayxPqhlyAHOYQNA9U+IEKSdZL3YwEE
        DO2nKc54/9l3SbRIqCSem26od+tXTfM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3A9B6B3D7
        for <linux-xfs@vger.kernel.org>; Wed, 31 Mar 2021 20:23:15 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3] xfs: deprecate BMV_IF_NO_DMAPI_READ flag
Date:   Wed, 31 Mar 2021 22:26:37 +0200
Message-Id: <20210331202637.26012-1-ailiop@suse.com>
X-Mailer: git-send-email 2.31.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use of the flag has had no effect since kernel commit 288699fecaff
("xfs: drop dmapi hooks"), which removed all dmapi related code, so
deprecate it.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
changes since v1:
 - retain flag definition to prevent reuse and not break kabi, per
   Darrick's suggestion.

changes since v2:
 - leave flag in BMV_IF_VALID so that we won't break userspace.

 fs/xfs/libxfs/xfs_fs.h | 2 +-
 fs/xfs/xfs_ioctl.c     | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index fa06a52c67fd..7439a8c317be 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -65,7 +65,7 @@ struct getbmapx {
 
 /*	bmv_iflags values - set by XFS_IOC_GETBMAPX caller.	*/
 #define BMV_IF_ATTRFORK		0x1	/* return attr fork rather than data */
-#define BMV_IF_NO_DMAPI_READ	0x2	/* Do not generate DMAPI read event  */
+#define BMV_IF_NO_DMAPI_READ	0x2	/* Deprecated */
 #define BMV_IF_PREALLOC		0x4	/* rtn status BMV_OF_PREALLOC if req */
 #define BMV_IF_DELALLOC		0x8	/* rtn status BMV_OF_DELALLOC if req */
 #define BMV_IF_NO_HOLES		0x10	/* Do not return holes */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 99dfe89a8d08..9d3f72ef1efe 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1669,8 +1669,6 @@ xfs_ioc_getbmap(
 		bmx.bmv_iflags = BMV_IF_ATTRFORK;
 		/*FALLTHRU*/
 	case XFS_IOC_GETBMAP:
-		if (file->f_mode & FMODE_NOCMTIME)
-			bmx.bmv_iflags |= BMV_IF_NO_DMAPI_READ;
 		/* struct getbmap is a strict subset of struct getbmapx. */
 		recsize = sizeof(struct getbmap);
 		break;
-- 
2.31.1.dirty
