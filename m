Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18128753DD2
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Jul 2023 16:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236120AbjGNOmW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Jul 2023 10:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236101AbjGNOmV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jul 2023 10:42:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E2E12D
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 07:42:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA40861D32
        for <linux-xfs@vger.kernel.org>; Fri, 14 Jul 2023 14:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F18C433C7;
        Fri, 14 Jul 2023 14:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689345740;
        bh=x8APn3kFxgLL79/ay0nS2W4kQfDBHSpzSccwbqyMkOw=;
        h=Subject:From:To:Cc:Date:From;
        b=d20dhyArXbPYq69guJEPYyZpDU+Btc4Yuqkjw6eFc7X7J2gN8PmYgWdP2SODlJh7Q
         QXP76pXsmKqzb733DsMhqxxizHqnz3HBXPBIlwnYXwrCQKSU9pQ3Bp4x+JJpG/qzGP
         LHHF0URjdwSrNGpa4eGwXnupfxDqz48qkEp4wPE+yOZGCMmg8JhKC6Tis0UqF9aC2R
         Har42FV4pUHh02AFFmvFlU3rSy62YvWasEnDE0AA6VGWSldiSuUQRGtbCPNGM7c8un
         bp4MDjDc8kBxrSYBXZyG+oBLcqVuBIeeW4Ykpjl98KAMFsblG4pf5iLTvqha5MjDKJ
         Mcf09iVeb03Sw==
Subject: [PATCHSET 0/3] xfs: ubsan fixes for 6.5-rc2
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, keescook@chromium.org
Date:   Fri, 14 Jul 2023 07:42:19 -0700
Message-ID: <168934573961.3353217.18139786322840965874.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Fix some UBSAN complaints, since apparently they don't allow flex array
declarations with array[1] anymore.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=ubsan-fixes-6.5
---
 fs/xfs/libxfs/xfs_da_format.h |   75 ++++++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_fs.h        |    4 +-
 fs/xfs/xfs_ondisk.h           |    5 ++-
 3 files changed, 71 insertions(+), 13 deletions(-)

