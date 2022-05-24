Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E300F532287
	for <lists+linux-xfs@lfdr.de>; Tue, 24 May 2022 07:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbiEXFgK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 May 2022 01:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234277AbiEXFgI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 01:36:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8407DF11
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 22:36:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 644DD6147C
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 05:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48CBC385AA;
        Tue, 24 May 2022 05:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653370565;
        bh=bburmVjGbA+4XZl3uNU03OTpNcpeGb2KER4SDDVrDPQ=;
        h=Subject:From:To:Cc:Date:From;
        b=FZDLzQwHuOScgIA2OhVnSOO105loy/xX5PO+hS1hNttyoZr6dAHDPArAkN0n7KdbM
         w3c3lSOvtlF1On3kVbPGcXtWfePetGCvEoLWuQ8wsKzOWPFDOcESfAPJcYO3GinJDy
         GxkjALA0tHLJqCj8o5Ex+AHtG8COXCp3xCrAEWV6YRsCxPqu0IOVnVlRs8R3+6J+aA
         /o9ySYDYFc+lxr3wtbcffoWAqINTbF13uK9fo8gBiL5zm2QRfmgE1oBwPHEkw1ABdF
         ZvZpiRkNq9YtruigL2VgunVTx6umBWI9IVQ/69s4Zj0J4UZp1kufo6EYKdwIOmiMT/
         jg0h4vuL72/ZQ==
Subject: [PATCHSET v2 0/2] xfs: random fixes for 5.19
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Mon, 23 May 2022 22:36:05 -0700
Message-ID: <165337056527.993079.1232300816023906959.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are a few more fixes for 5.19 -- now that the LARP fixes have
landed, now we just have the quotacheck fix, a btree cursor leak fix,
and a fix to the deferred ops manager so that ->create_intent can return
errors.

v2: older larp cleanups were picked up by for-next, and fix a leak when
    btree inserts fail and debugging is enabled

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes-5.19
---
 fs/xfs/libxfs/xfs_btree.c |    8 +++++---
 fs/xfs/xfs_qm.c           |    9 ++++++++-
 2 files changed, 13 insertions(+), 4 deletions(-)

