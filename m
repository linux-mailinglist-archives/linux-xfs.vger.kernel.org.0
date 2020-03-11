Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8513181511
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Mar 2020 10:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgCKJfy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Mar 2020 05:35:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:37314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgCKJfy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Mar 2020 05:35:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 46A1DACEF;
        Wed, 11 Mar 2020 09:35:53 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: Use scnprintf() for avoiding potential buffer overflow
Date:   Wed, 11 Mar 2020 10:35:52 +0100
Message-Id: <20200311093552.25354-1-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 fs/xfs/xfs_stats.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 113883c4f202..f70f1255220b 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -57,13 +57,13 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 	/* Loop over all stats groups */
 
 	for (i = j = 0; i < ARRAY_SIZE(xstats); i++) {
-		len += snprintf(buf + len, PATH_MAX - len, "%s",
+		len += scnprintf(buf + len, PATH_MAX - len, "%s",
 				xstats[i].desc);
 		/* inner loop does each group */
 		for (; j < xstats[i].endpoint; j++)
-			len += snprintf(buf + len, PATH_MAX - len, " %u",
+			len += scnprintf(buf + len, PATH_MAX - len, " %u",
 					counter_val(stats, j));
-		len += snprintf(buf + len, PATH_MAX - len, "\n");
+		len += scnprintf(buf + len, PATH_MAX - len, "\n");
 	}
 	/* extra precision counters */
 	for_each_possible_cpu(i) {
@@ -72,9 +72,9 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		xs_read_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
 	}
 
-	len += snprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
+	len += scnprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
 			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
-	len += snprintf(buf + len, PATH_MAX-len, "debug %u\n",
+	len += scnprintf(buf + len, PATH_MAX-len, "debug %u\n",
 #if defined(DEBUG)
 		1);
 #else
-- 
2.16.4

