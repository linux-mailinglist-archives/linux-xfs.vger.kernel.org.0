Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFAC5F5CB5
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Oct 2022 00:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiJEWak (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Oct 2022 18:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiJEWaj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2022 18:30:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634FF25591;
        Wed,  5 Oct 2022 15:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4CD8B81F6B;
        Wed,  5 Oct 2022 22:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708DFC433D6;
        Wed,  5 Oct 2022 22:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665009033;
        bh=mD3v6sBCow61XrRkx645K5vu16yemOWQy19MHb8DjHw=;
        h=Subject:From:To:Cc:Date:From;
        b=XpqGWhV7c5zk1wFks8WAhOAaMQcyPUVxEhl7j6/rY3nCizOQQstzM0DD/td5NH4tL
         7L9O/gFk+5Jix3/EvcmjX39HF7t4GdOfKTzwvRi6JlGAJ+ohjnnwrgFr7Rh2VkEARe
         1ef3J3f5Ths2XZzVpl4LPlWCMTvPEYVW+FuT3chABkh4KomVLibbNHELPgTU59IN1T
         LYExdTS5fPt2Ex9MpdiTAP8tntKXisRiO12BtplkeVMt+E0t/dxHAH9HY5LlXB9zrV
         KbdXlqyrSRPq5h6bLwOXp6ohE7PzNA7vdagvjxHmb+zdjGad92HELGPZbo8grJNqH4
         zX5i43HjdYXZg==
Subject: [PATCHSET v2 0/6] fstests: random fixes for v2022.09.25
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 05 Oct 2022 15:30:32 -0700
Message-ID: <166500903290.886939.12532028548655386973.stgit@magnolia>
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

Here's the usual batch of odd fixes for fstests.

v2: accumulate a few more fixes for problems that I've found.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 common/populate   |    3 +--
 common/xfs        |    3 +++
 tests/generic/092 |    6 ++++++
 tests/xfs/114     |    2 ++
 tests/xfs/128     |   34 ++++++++++++++++++++++++++++++----
 tests/xfs/229     |    7 ++++++-
 6 files changed, 48 insertions(+), 7 deletions(-)

