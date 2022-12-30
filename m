Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A5A65A01E
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 01:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbiLaA7o (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 19:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiLaA7n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:59:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E598A1C921
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:59:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 823B961D69
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52A4C433EF;
        Sat, 31 Dec 2022 00:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448382;
        bh=OB64jsxs79BDfJVK0zbBGiuaEYiCpWdSd4nR9ApUlNg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uoZPmOBBnOjFfrfIkm8PkikvCvLdZ7g2wKyaXpbH2DafzhJDaKYLrl5SQKbp2QkZe
         sN+SSaOTXpGmOFL1dcspfwlCX3jUJwF1xbPegI78Yf8QuPqeZOZO6WFw2d3slu0OSk
         6x2750DTVHAuNdGT2DA2OFpaxGWzyKeDbIojxkpjLCzgR/4Hb39eCS7bUABeQiIost
         4hmg80HKnjMkMyjLcvSPQk141aOC06yLd3UAfU0SGsULsfgIp2tATAvw6dTa4+dyee
         XzOWJdvgrA28scoxuK17hG4bgNoMCgJwY8MlpxfhaPoXxf5TlvOg9w1PwEqGp9vBYz
         VWCuVfa001Upg==
Subject: [PATCHSET 0/4] xfs_repair: add other v5 features to filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:09 -0800
Message-ID: <167243874979.722663.18268822003736829003.stgit@magnolia>
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

This series enables xfs_repair to add select features to existing V5
filesystems.  Specifically, one can add free inode btrees, reflink
support, and reverse mapping.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=upgrade-older-features

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=upgrade-older-features
---
 include/libxfs.h     |    1 
 man/man8/xfs_admin.8 |   21 +++++
 repair/globals.c     |    3 +
 repair/globals.h     |    3 +
 repair/phase2.c      |  229 ++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/rmap.c        |    8 +-
 repair/xfs_repair.c  |   33 +++++++
 7 files changed, 294 insertions(+), 4 deletions(-)

