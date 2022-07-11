Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6FA55EFD2
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Jun 2022 22:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiF1Us2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 28 Jun 2022 16:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiF1Us2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:48:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C6326540
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:48:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B7726184B
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56A4C341C8;
        Tue, 28 Jun 2022 20:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449306;
        bh=Fb0exsiUiARVmzhj4CNcegIfYwBuEGs9pl+KyU3zcvA=;
        h=Subject:From:To:Cc:Date:From;
        b=hbzkpaFkA2UuMcfv5Z2KQuM5fm79uJIyBxttxmC8aRY1OR7Ye//yGQ0ja5lMlXqJM
         nj2HAGj3L0DDfC/WGE7aUGWYReUA0ra4hD6sR22hXkW6Nw8FeueJv4rvVUjTRvPUL8
         Uf0K/pgZix/JGcjZYdVohAsqAUaT+gF9f1kgbkNHuYchGSFe8nu+oNhcSlbzWpikJv
         9vuHCtpVGbTgEQHKsOjKvcQEKoQuTuMmX7dXH7Dg/u2+ps785d6BV6d4i7K9HxqS7K
         Sfx6nj2ODgTHR9cV/hHWUfkCXoIEiC3ljVk6MGlmd7iIFpFBXUTMKxvwDC1kZ1EVly
         IWVdKLGUUc0sA==
Subject: [PATCHSET 0/8] xfsprogs: sync libxfs with 5.19
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:48:26 -0700
Message-ID: <165644930619.1089724.12201433387040577983.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series corrects any build errors in libxfs and backports libxfs
changes from the kernel.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-5.19-sync
---
 db/check.c               |   10 +++++++---
 db/metadump.c            |   11 +++++++----
 include/xfs_mount.h      |    7 -------
 libxfs/util.c            |    6 ------
 libxfs/xfs_attr.c        |   47 ++++++++++++++--------------------------------
 libxfs/xfs_attr.h        |   17 +----------------
 libxfs/xfs_attr_leaf.c   |   37 ++++++++++++++++++++----------------
 libxfs/xfs_attr_leaf.h   |    3 +--
 libxfs/xfs_da_btree.h    |    4 +++-
 logprint/log_print_all.c |    2 +-
 repair/attr_repair.c     |   20 ++++++++++++++++++++
 repair/dinode.c          |   14 ++++++++++----
 12 files changed, 84 insertions(+), 94 deletions(-)

