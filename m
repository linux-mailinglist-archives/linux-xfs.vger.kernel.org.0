Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE65A7AE123
	for <lists+linux-xfs@lfdr.de>; Mon, 25 Sep 2023 23:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjIYV7o (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 25 Sep 2023 17:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbjIYV7n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:59:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3901FAF
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:59:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7C0C433C8;
        Mon, 25 Sep 2023 21:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679176;
        bh=1UkchxutMF70HWiAFFqLIbBg32AvOYLo7EmS+MEHgSA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dXWNibzIvsiUC+e4wS8iGkauZdfLieKBLFGk3KouvCDx3qkTVE9ApVCFR+AVMsKMD
         aIZL6RCEStfWWGo7zeYXRE47NCe8ZU+HWC35PPZPU3tUEmSixsRQCcBtjcF5u1T363
         XUAy8r+n7pjVHotESfA+zn3vvXyI9OEnAZJCYljADtNCBSS6LnyXT67Ny4s4HABTr8
         4u1VSwHZDckG/B4Mpb+kRRQsYdpsEbMhdC9wSZck7GN+B5e8q7Zq3Pa4GlSbdnc5jH
         WLYeeuWuo+5I35RPPX75beLrrx75bHxmSj72ShwwwiCgw6Rpk+hcZasleyl7NxceJU
         +lh1vkRXv6PYQ==
Subject: [PATCH 3/3] mkfs: add a config file for 6.6 LTS kernels
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:59:36 -0700
Message-ID: <169567917637.2320343.16837668277109787768.stgit@frogsfrogsfrogs>
In-Reply-To: <169567915945.2320343.12838353246024459529.stgit@frogsfrogsfrogs>
References: <169567915945.2320343.12838353246024459529.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enable 64-bit extent counts and reverse mapping for 6.6.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/Makefile     |    3 ++-
 mkfs/lts_6.6.conf |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)
 create mode 100644 mkfs/lts_6.6.conf


diff --git a/mkfs/Makefile b/mkfs/Makefile
index 6c7ee186fa2..a0c168e3815 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -15,7 +15,8 @@ CFGFILES = \
 	lts_5.4.conf \
 	lts_5.10.conf \
 	lts_5.15.conf \
-	lts_6.1.conf
+	lts_6.1.conf \
+	lts_6.6.conf
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
 	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
diff --git a/mkfs/lts_6.6.conf b/mkfs/lts_6.6.conf
new file mode 100644
index 00000000000..244f8eaf764
--- /dev/null
+++ b/mkfs/lts_6.6.conf
@@ -0,0 +1,14 @@
+# V5 features that were the mkfs defaults when the upstream Linux 6.6 LTS
+# kernel was released at the end of 2023.
+
+[metadata]
+bigtime=1
+crc=1
+finobt=1
+inobtcount=1
+reflink=1
+rmapbt=1
+
+[inode]
+sparse=1
+nrext64=1

