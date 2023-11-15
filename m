Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5A27DE57E
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Nov 2023 18:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbjKARnj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Nov 2023 13:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbjKARnh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2023 13:43:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F1710F;
        Wed,  1 Nov 2023 10:43:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C87EF1F750;
        Wed,  1 Nov 2023 17:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1698860606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=InyU6IkAENGRjX63BgJMYCZOVDU0Rjela/KjykemRY8=;
        b=cGvBoQWo6D5nEnFeGQgDTCi7QnT4wupD/QljAmbwDHbcZn1j72Fs027p3jgbph1PW1A1Ov
        4RGDW1H9TO1gKksQUlT2Dfv5TC1rlywu/rq+NpGM3uj8f/fWoVoq61jAxnpacxHmwRogtv
        9/Rwa1jVqfe7TEruhKZlCtnL88z5wrU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1698860606;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=InyU6IkAENGRjX63BgJMYCZOVDU0Rjela/KjykemRY8=;
        b=25+c9h+abDDuZy8BL0dq8HZ5e9TOM6rvIzab1fUAvdd5zInZqzbrBG7auy13t6iaXx6be+
        2t0bBScapqHCRUAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B9C3F13ACD;
        Wed,  1 Nov 2023 17:43:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SEVWLT6OQmUxYQAAMHmgww
        (envelope-from <jack@suse.cz>); Wed, 01 Nov 2023 17:43:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id F21E3A07C6; Wed,  1 Nov 2023 18:43:25 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Christian Brauner <brauner@kernel.org>
Cc:     <linux-fsdevel@vger.kernel.org>, <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Kees Cook <keescook@google.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Alexander Popov <alex.popov@linux.com>,
        <linux-xfs@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 7/7] ext4: Block writes to journal device
Date:   Wed,  1 Nov 2023 18:43:12 +0100
Message-Id: <20231101174325.10596-7-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231101173542.23597-1-jack@suse.cz>
References: <20231101173542.23597-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=868; i=jack@suse.cz; h=from:subject; bh=HuGESsNPSj9Qv49kiHt3CDXd9GHUB2GbWU0FnD28gkY=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBlQo4wQ8aD+R/KnoCeojDhZLI5knNBhVsl/OjJ/o0Z +jjVtsuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZUKOMAAKCRCcnaoHP2RA2bkqCA DeV0ajP8MvFxfY0SoPVdnFN+Ci0WI0FX3TtMOzHvHlDPwzVSS295Td2GrHVubbNYSOWjLVrwpGyMA4 kcw2C27bO5IRVJk1QfgND8bVdjQoUJ86gkkHIqn3DR5rWR0DrOUTI3McIIB40TyiqgLwUbFPX8AECn bqxoM3P/HvtT4+6P5fo1hHxSwo4aV8skY99gz6jtizORzxzu5wSvbhaqpcH92xUAwjlu5D5BDDDhyE iQWsrne50JSw2iZaHLv8CaB2ofc2CUNj1TvxPr5vqbVXPG/AloXQaIwtcjesSinypusiMIepQzRzXz FU/ETjwNyO43qynz7or1O0fn6F1jO+
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
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

Ask block layer to not allow other writers to open block device used
for ext4 journal.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 439e37ac219b..f96398f8aac9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5855,8 +5855,9 @@ static struct bdev_handle *ext4_get_journal_blkdev(struct super_block *sb,
 	struct ext4_super_block *es;
 	int errno;
 
-	bdev_handle = bdev_open_by_dev(j_dev, BLK_OPEN_READ | BLK_OPEN_WRITE,
-				       sb, &fs_holder_ops);
+	bdev_handle = bdev_open_by_dev(j_dev,
+		BLK_OPEN_READ | BLK_OPEN_WRITE | BLK_OPEN_RESTRICT_WRITES,
+		sb, &fs_holder_ops);
 	if (IS_ERR(bdev_handle)) {
 		ext4_msg(sb, KERN_ERR,
 			 "failed to open journal device unknown-block(%u,%u) %ld",
-- 
2.35.3

