Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A09D250A1A
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Aug 2020 22:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbgHXUh6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Aug 2020 16:37:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:42428 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXUh5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Aug 2020 16:37:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 90533AC8B;
        Mon, 24 Aug 2020 20:38:26 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/6] mkfs: warn if reflink option is enabled on dax-capable devices
Date:   Mon, 24 Aug 2020 22:37:21 +0200
Message-Id: <20200824203724.13477-4-ailiop@suse.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824203724.13477-1-ailiop@suse.com>
References: <20200824203724.13477-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reflink is currently not supported in conjunction with dax. Warn if this
config is enabled during mkfs to make it clear that the filesystem will
not be mountable with reflinks and dax enabled.

Make the option overridable so that incompatible fs configurations can
still be created, e.g. for testing or for cases where the filesystem is
not intended to be mounted with the dax option switched on.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 mkfs/xfs_mkfs.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4fe0bbdcc40c..b8739c2b9093 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1883,7 +1883,9 @@ _("log stripe unit specified, using v2 logs\n"));
 static void
 validate_sb_features(
 	struct mkfs_params	*cfg,
-	struct cli_params	*cli)
+	struct cli_params	*cli,
+	struct fs_topology	*ft,
+	int			force)
 {
 	/*
 	 * Now we have blocks and sector sizes set up, check parameters that are
@@ -2003,6 +2005,16 @@ _("rmapbt not supported with realtime devices\n"));
 		cli->sb_feat.rmapbt = false;
 	}
 
+	if (cli->sb_feat.reflink && ft->dax) {
+		fprintf(stderr, _("reflink not supported with dax devices\n"));
+
+		if (!force) {
+			fprintf(stderr,
+				_("Use -f to force enabling reflink\n"));
+			usage();
+		}
+	}
+
 	/*
 	 * Copy features across to config structure now.
 	 */
@@ -3714,7 +3726,7 @@ main(
 	sectorsize = cfg.sectorsize;
 
 	validate_log_sectorsize(&cfg, &cli, &dft);
-	validate_sb_features(&cfg, &cli);
+	validate_sb_features(&cfg, &cli, &ft, force_overwrite);
 
 	/*
 	 * we've now completed basic validation of the features, sector and
-- 
2.28.0

