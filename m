Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CF628544D
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Oct 2020 00:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgJFWGr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Oct 2020 18:06:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:49850 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbgJFWGr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Oct 2020 18:06:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1602022006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4yRh0a+eWD/ES+DYsBkZ4AncL3tCTaI67eKD635YvN8=;
        b=tqGiYK2fhvUc6ddMr9WFxzjnY7J74SuJiOn9CaDIat/Ky8K4Jh21s43uzSz8PuAhZ1s2YY
        lDjMA4o7O7DlRhhHPH1Jaa6CnPZQN5sZUuNgsOgHkBBn2s8XXima1vVG+zFQl/PDAjJY7f
        LHN4rrbDtyi6lEoXjp2dx6bH33K0nOU=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 887D4B031;
        Tue,  6 Oct 2020 22:06:46 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfsdump: remove obsolete code for handling mountpoint inodes
Date:   Wed,  7 Oct 2020 00:07:03 +0200
Message-Id: <20201006220704.31157-2-ailiop@suse.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201006220704.31157-1-ailiop@suse.com>
References: <20201006220704.31157-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The S_IFMNT file type was never supported in Linux, remove the last
vestiges.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 doc/xfsdump.html | 5 ++---
 dump/content.c   | 3 ---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/doc/xfsdump.html b/doc/xfsdump.html
index d4d157fa62c5..9d06129a5e1d 100644
--- a/doc/xfsdump.html
+++ b/doc/xfsdump.html
@@ -102,9 +102,8 @@ or stdout. The dump includes all the filesystem objects of:
 <li>named pipes (S_FIFO)
 <li>XENIX named pipes (S_IFNAM) 
 </ul>
-but not mount point types (S_IFMNT).
-It also does not dump files from <i>/var/xfsdump</i> which
-is where the xfsdump inventory is located.
+It does not dump files from <i>/var/xfsdump</i> which is where the
+xfsdump inventory is located.
 Other data which is stored:
 <ul>
 <li> file attributes (stored in stat data) of owner, group, permissions,
diff --git a/dump/content.c b/dump/content.c
index 30232d422206..7637fe89609e 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -3913,9 +3913,6 @@ dump_file(void *arg1,
 			contextp->cc_stat_lastino = statp->bs_ino;
 		}
 		return RV_OK;
-	/* not yet implemented
-	case S_IFMNT:
-	 */
 	}
 
 	if (rv == RV_OK
-- 
2.28.0

