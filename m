Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AB6659FB2
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 01:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbiLaAdd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 19:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235694AbiLaAda (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:33:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAD319C37
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:33:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA89A61D26
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D377C433EF;
        Sat, 31 Dec 2022 00:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446809;
        bh=jUXEojGOsW4JZrfCxw/g2xzgb5VvOAN7ZOUhjvB9g9U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=njVvq1klKD1JWKAk81XfbRPATbZyye9GuRzwipJ2oCsEWIurrjzw2JXB5PdvTLm6f
         jj/YLYiDOA/qcgTZvugbO3MIKFMTzhxR7jAWJMM0ci+xNj8xUbUk2fyF30u+KbSUlR
         dZRpRNvOFd6KoLmQ12hvARUsB+bE3Sqe1hhLv2CHvkOKEexgI59J1KdYhAXIWNQAIf
         fQWw7J2KWgTFdvz+5mN5bNX7K/IBmg9krfNENrjDldwgbe8uoRVbfHgQ0rvRUf22Dw
         zfHuer8O8TCjIZt/DksEbtzP2XVCcOZa87566PLG6GnOiRJ5MlMfy83iihfvK7EVFi
         6YMCevQUreL9g==
Subject: [PATCH 6/7] xfs_scrub: don't call FITRIM after runtime errors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:28 -0800
Message-ID: <167243870825.716924.6948944810784996751.stgit@magnolia>
In-Reply-To: <167243870748.716924.8460607901853339412.stgit@magnolia>
References: <167243870748.716924.8460607901853339412.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Don't call FITRIM if there have been runtime errors -- we don't want to
touch anything after any kind of unfixable problem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index c54f2cc738b..ac667fc91fb 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -39,6 +39,9 @@ fstrim_ok(
 	if (ctx->unfixable_errors != 0)
 		return false;
 
+	if (ctx->runtime_errors != 0)
+		return false;
+
 	return true;
 }
 

