Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29DA164BD61
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Dec 2022 20:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbiLMTjk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 13 Dec 2022 14:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbiLMTjj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 14:39:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31C8205D8
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 11:39:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EAF761715
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 19:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DA8C433D2;
        Tue, 13 Dec 2022 19:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670960377;
        bh=WnnvQ9VslpdNLKwyfIt96BDuCFl1UWuypAhtlW+KW4c=;
        h=Subject:From:To:Cc:Date:From;
        b=Qo+iLPEJumtqU+8i+3FkYLbxA7QUXIddZgz/Bt9UwCJ5ICSOwMHjWORVnpTMZw0wp
         iSPFT4b2hU8Ww1SK1QsCMqt6gZnD6QOTrLp+yO5DSpk0t5/2qHCMu5lvR3lCysSdRf
         htKDM2f3FcRE260O9h5KN1ixeASnDSPxX5Axw4B6btt25wDRZa8mlHwsDhhpVJVyQf
         CF62YBqw60g7ejxiBTpIXLp0LSfkGzroiYUCpLlgYfsiCR4qYDBz05VZO2hvo/5KtD
         uSTa/AKBDOYs3oQv9NI31x6VXUMA/C3KGqSMrCmsFTdY+iQ2tZsiFOmVkW5sM6vhmN
         fhnOYxAUfT1Kg==
Subject: [PATCHSET 0/2] xfsprogs: random fixes for 6.1, part 2
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 13 Dec 2022 11:39:37 -0800
Message-ID: <167096037742.1739636.10785934352963408920.stgit@magnolia>
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

This is the second rollup of all the random fixes I've collected for
xfsprogs 6.1.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-fixes-6.1
---
 db/btblock.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 db/btblock.h |    6 +++++
 db/field.c   |    8 +++++++
 db/field.h   |    4 +++
 db/type.c    |    6 ++---
 io/fsmap.c   |    4 ++-
 6 files changed, 93 insertions(+), 5 deletions(-)

