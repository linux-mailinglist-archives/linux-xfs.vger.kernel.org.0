Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC351659CBC
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Dec 2022 23:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbiL3W0F (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 17:26:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiL3W0A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:26:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12332672
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:25:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6A67CCE19B8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6D7C433D2;
        Fri, 30 Dec 2022 22:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439155;
        bh=TPClS8NSM5hzoBGPrw2PTVtisfemfDoEcF5TjNksBrw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YwldmAX7LEmtaHENjmWG+7mIOccoT4rQ7ulHCYVpBjNweTxP+mCBBKeGXuxAbMChb
         Gc+lxlWsueDvaIwOPvqMZtj0GX2MPWbLKQTliN9yLhYB2JlwRU+lauEJxhqUQO7Rfj
         tsK58yxmqL5RqWc2W8Zls/Sy7I/nl3OhSTFsO3Z1cjFpoUPH2ZtVVt6dUlC6GMwf4e
         IqvFur7QIMdONzXhBhfDRDBHmo0KsFt9gSSum1/WCY4ZrZvi1QLmFGONYDFtfQEAob
         dJZBWvxRkPF1e5eOGi0tcNyZAwCapZqxsinfRkOq84MmCpmJp3q4Yr+MDEGX8tisRr
         HFKDlylYXobJA==
Subject: [PATCHSET v24.0 0/2] xfs: enhance btree key scrubbing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:21 -0800
Message-ID: <167243828182.684307.10793765593002840378.stgit@magnolia>
In-Reply-To: <Y69UceeA2MEpjMJ8@magnolia>
References: <Y69UceeA2MEpjMJ8@magnolia>
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

This series fixes the scrub btree block checker to ensure that the keys
in the parent block accurately represent the block, and check the
ordering of all interior key records.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-btree-key-enhancements
---
 fs/xfs/scrub/btree.c |   63 ++++++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/scrub/btree.h |    8 ++++++
 2 files changed, 63 insertions(+), 8 deletions(-)

