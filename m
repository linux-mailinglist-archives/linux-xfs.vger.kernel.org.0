Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8C9250A1C
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Aug 2020 22:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgHXUiD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Aug 2020 16:38:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:42478 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXUiD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Aug 2020 16:38:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2D840AC8B;
        Mon, 24 Aug 2020 20:38:32 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] mkfs: remove redundant assignment of cli sb options on failure
Date:   Mon, 24 Aug 2020 22:37:23 +0200
Message-Id: <20200824203724.13477-6-ailiop@suse.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824203724.13477-1-ailiop@suse.com>
References: <20200824203724.13477-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

rmapbt and reflink are incompatible with realtime devices and mkfs bails
out on such configurations.  Switching them off in the cli params after
exit is dead code, remove it.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 mkfs/xfs_mkfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 75e910dd4a30..1f142f78e677 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1995,14 +1995,12 @@ _("cowextsize not supported without reflink support\n"));
 		fprintf(stderr,
 _("reflink not supported with realtime devices\n"));
 		usage();
-		cli->sb_feat.reflink = false;
 	}
 
 	if (cli->sb_feat.rmapbt && cli->xi->rtname) {
 		fprintf(stderr,
 _("rmapbt not supported with realtime devices\n"));
 		usage();
-		cli->sb_feat.rmapbt = false;
 	}
 
 	if (cli->sb_feat.reflink && ft->dax) {
-- 
2.28.0

