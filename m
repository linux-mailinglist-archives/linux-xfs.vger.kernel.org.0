Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D208B507699
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Apr 2022 19:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353501AbiDSRe7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 Apr 2022 13:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347669AbiDSRew (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 13:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC2C39153;
        Tue, 19 Apr 2022 10:32:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F748B81992;
        Tue, 19 Apr 2022 17:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E215EC385A9;
        Tue, 19 Apr 2022 17:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650389526;
        bh=G3NlJ7RVaWZ521R4W7Wx5y0NDcwtb5tYNZC4SweAIYE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y9n5zrx2NiCQJr0tAIRzcc4irGMmw4xRXxuST7H+eK2/9cp6ZE4ZI4d+LFX+mfWzx
         BZaYB+e6nMYdU42YWqtfMTuy+CUj/XMnmcoxz+GVOFUXFa4KBrg6LUW+jm7RtJZ3l7
         4N6O1hstViXEOpXrwxwIzdHeW9g3qJ6ZafH2E5t5fDMm5wMHEuT/bPqquxvLYQ5Vca
         +j9SipILd6vVceHE8MDPsQSBjnH8el0eY4iwvik8wa8qCN5oagMMTjCSgE+uL4DHT2
         rQfQtnOTxBt4lrDAmlTWetXZo21tauvFi4nyrs1JvzLA6CwqXuPfCGM63Oxqah9Mt+
         mlcxIo9SZhbkw==
Subject: [PATCH 2/2] generic/019: fix incorrect unset statements
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 19 Apr 2022 10:32:06 -0700
Message-ID: <165038952637.1677615.2651496553218188517.stgit@magnolia>
In-Reply-To: <165038951495.1677615.10687913612774985228.stgit@magnolia>
References: <165038951495.1677615.10687913612774985228.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix incorrect usage of unset -- one passes the name of the variable, not
the *value* contained within it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/019 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/generic/019 b/tests/generic/019
index 854ba57d..45c91624 100755
--- a/tests/generic/019
+++ b/tests/generic/019
@@ -140,8 +140,8 @@ _workout()
 	kill $fs_pid &> /dev/null
 	wait $fs_pid
 	wait $fio_pid
-	unset $fs_pid
-	unset $fio_pid
+	unset fs_pid
+	unset fio_pid
 
 	# We expect that broken FS still can be umounted
 	run_check _scratch_unmount

