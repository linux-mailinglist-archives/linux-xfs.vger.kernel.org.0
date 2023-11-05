Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39B17E1606
	for <lists+linux-xfs@lfdr.de>; Sun,  5 Nov 2023 20:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjKETXg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 5 Nov 2023 14:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjKETXf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Nov 2023 14:23:35 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26E3DD
        for <linux-xfs@vger.kernel.org>; Sun,  5 Nov 2023 11:23:32 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 827B0216DA;
        Sun,  5 Nov 2023 19:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1699212211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=tW43SNGKSFZqI7sgMsy2WBfShIH8DE6e9suqejvdpqU=;
        b=dZ5iQDJiJwFBsCKp6PHr/e3QbTK/L/nzMZn3E0T2n6zuTg6j8cC0t25HugW+R3FMbJLMrt
        FyGVda8jPVOOzK/OFoV2lJRHrf5MeIfWfkefEZgvGF/MybKPalPvANi5bTjxx/YN4QLLza
        qJnZW2lzOeC8FAUUPOyh9OSJpszw/s8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6F9FC13463;
        Sun,  5 Nov 2023 19:23:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id D6ZsGrPrR2V+PgAAMHmgww
        (envelope-from <ailiop@suse.com>); Sun, 05 Nov 2023 19:23:31 +0000
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     linux-xfs@vger.kernel.org
Cc:     =?UTF-8?q?Holger=20Hoffst=C3=A4tte?= 
        <holger@applied-asynchrony.com>
Subject: [PATCH] xfs: fix again select in kconfig XFS_ONLINE_SCRUB_STATS
Date:   Sun,  5 Nov 2023 20:23:18 +0100
Message-ID: <20231105192318.121783-1-ailiop@suse.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Commit 57c0f4a8ea3a attempted to fix the select in the kconfig entry
XFS_ONLINE_SCRUB_STATS by selecting XFS_DEBUG, but the original
intention was to select DEBUG_FS, since the feature relies on debugfs to
export the related scrub statistics.

Fixes: 57c0f4a8ea3a ("xfs: fix select in config XFS_ONLINE_SCRUB_STATS")

Reported-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 fs/xfs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index ed0bc8cbc703..567fb37274d3 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -147,7 +147,7 @@ config XFS_ONLINE_SCRUB_STATS
 	bool "XFS online metadata check usage data collection"
 	default y
 	depends on XFS_ONLINE_SCRUB
-	select XFS_DEBUG
+	select DEBUG_FS
 	help
 	  If you say Y here, the kernel will gather usage data about
 	  the online metadata check subsystem.  This includes the number
-- 
2.42.0

