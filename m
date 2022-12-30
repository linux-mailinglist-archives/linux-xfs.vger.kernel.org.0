Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4E6659DE4
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 00:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiL3XOi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 18:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbiL3XOh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:14:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E431D0E9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:14:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3131FB81DAE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED02C433D2;
        Fri, 30 Dec 2022 23:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442073;
        bh=Cgi3kK7XWRaqnPxgK+O/gf3hWcKzjw9OfDv0wk3SC9k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G1tqBTkzh85p7P5JDSXtPKoJfNEYfUp+XYdybvaJyLuagvYEYeabv5a+cyMY2qngx
         spAqd0fwXXtsw5H1yGkFsp0rFnO1ePLoboSDuc73gloqn3RyifNpOGkAALPpNOcoYd
         q14uqvQupo++DP3OjcO0gPi+e/lPJ0HpoRzG2KIx97SPJ8cYVzaIc4ScqncsGao0zS
         WOnMrtuGhfSZFwVgAvkMDQ4lBDbx7DxHtotSyr7lnofYRUcHWJit3cdXLbxF72olUH
         qS+ruunQyX3PJMHbhLIt+rTJMCAhwrbf3qYpCZf51KExAIDhLKKOkrsXJFKudfchJv
         55NCECeMwjr6w==
Subject: [PATCHSET v24.0 0/8] xfs_scrub: fixes for systemd services
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:31 -0800
Message-ID: <167243871097.717702.15336500890922415647.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
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

Hi all,

Fix some glaring deficiencies in the systemd services that were created
to manage background scans.  First, we need to fix various errors in
pathname escaping, because systemd does /not/ like slashes in service
names.  We also need to fix small bugs in the mailer scripts so that
scrub failures are reported effectively.  Finally, fix xfs_scrub_all
to deal with systemd restarts causing it to think that a scrub has
finished before the service actually finishes.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-service-fixes
---
 debian/rules                     |    1 
 scrub/xfs_scrub@.service.in      |    5 ++
 scrub/xfs_scrub_all.cron.in      |    5 ++
 scrub/xfs_scrub_all.in           |   83 ++++++++++++++++++++++++++++++++------
 scrub/xfs_scrub_all.service.in   |    5 ++
 scrub/xfs_scrub_all.timer        |    5 ++
 scrub/xfs_scrub_fail             |   37 ++++++++++++++++-
 scrub/xfs_scrub_fail@.service.in |    5 ++
 8 files changed, 130 insertions(+), 16 deletions(-)

