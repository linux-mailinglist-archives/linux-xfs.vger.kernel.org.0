Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FC865A024
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 02:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbiLaBAt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 20:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiLaBAs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:00:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA60FDB0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:00:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79E7AB81E4A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39008C433EF;
        Sat, 31 Dec 2022 01:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448444;
        bh=Jl1OdfZVEjYj1LF6r6o/fJOFiUwOpzWO1oUC40mbry0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Qqd0akIkY6IYlJQZaMaFSJpw4wdF2Ia0HMi1SfkQ50ZDyBC1ywr7EUYTFx/dkWDh4
         dNLuiNcPIQ2T+RJGL4+uQ7UC+zcADsBMMTt92Bmg8PZxiJamgZHovceCADLp0wUEEX
         sIqqntp/DTMvzmF4qxUP8XjeLFTKtKWi5j32F7/5zhYByo7FiaWup7/9ijVbwU2GwB
         BWMWe59zkV9khoXSFETQpxtxbN261B5qpyuo8+q0IPckU5FId9yzo/r1jvk12LWfCd
         OQlIgIgvJ8tBal68Akp5Pl2YlicQ9FyJaRxmiNQqWwSdLBNR7DPLFQiiUftugB/1ZJ
         GiNXncR0BDp/g==
Subject: [PATCHSET v1.0 0/9] libxfs: refactor rtbitmap/summary macros
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:32 -0800
Message-ID: <167243877226.727982.8292582053571487702.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
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

In preparation for adding block headers and enforcing endian order in
rtbitmap and rtsummary blocks, replace open-coded geometry computations
and fugly macros with proper helper functions that can be typechecked.
Soon we'll be needing to add more complex logic to the helpers.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-rtbitmap-macros

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=refactor-rtbitmap-macros
---
 db/check.c               |   63 ++++++++---
 libxfs/init.c            |    8 +
 libxfs/libxfs_api_defs.h |    8 +
 libxfs/xfs_format.h      |   32 +++--
 libxfs/xfs_rtbitmap.c    |  268 +++++++++++++++++++++++++++++++++-------------
 libxfs/xfs_rtbitmap.h    |  133 +++++++++++++++++++++++
 libxfs/xfs_trans_resv.c  |    9 +-
 libxfs/xfs_types.h       |    2 
 repair/globals.c         |    4 -
 repair/globals.h         |    4 -
 repair/phase6.c          |   14 +-
 repair/rt.c              |   43 ++++---
 repair/rt.h              |    6 -
 13 files changed, 443 insertions(+), 151 deletions(-)

