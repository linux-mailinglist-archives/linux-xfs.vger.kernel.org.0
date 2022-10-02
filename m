Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7CA35F24A3
	for <lists+linux-xfs@lfdr.de>; Sun,  2 Oct 2022 20:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiJBSYc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 2 Oct 2022 14:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiJBSYb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:24:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB7025295
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:24:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A55060EDB
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A87C433C1;
        Sun,  2 Oct 2022 18:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735069;
        bh=pTRnwiyY2AQpNyn/S6sc20GAhk2lejRaOMtPjQEQ4vw=;
        h=Subject:From:To:Cc:Date:From;
        b=SX5BSI/yDl5yI4meNUpIL0xFW6POkFtm53BcCuvxwt5oHiu9nbtD7dTr5cD0z1BXE
         MW5461ypB2IfOgYO0NJjL6wNFpNhztne2j1dep0b3rT+3XmiABLdScEM9KDCgS8eos
         EQoRyFd8gmtcppZh7UeFl9QTP5S525tmeru2zSqWEqce9sY5fVWWvHQUpqJ8Mzs6Qx
         KUeF+sVpzAVbrLrYp3DFkiiceBUYFxcp+RWybhCuaLAlIja2VJxlpK8OxnOTTrmFdO
         5925xsr4zgXRzqU8Ye0RYZQEekd79C/91a2pLvlyaUHxfaFBVsaglxkeIkahWKqR70
         uynEgwxyQ6NzA==
Subject: [PATCHSET v23.1 0/2] xfs: scrub inode core when checking metadata
 files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:26 -0700
Message-ID: <166473482605.1084588.1965700384229898125.stgit@magnolia>
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

Running the online fsck QA fuzz tests, I noticed that we were
consistently missing fuzzed records in the inode cores of the realtime
freespace files and the quota files.  This patch adds the ability to
check inode cores in xchk_metadata_inode_forks.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-check-metadata-inode-records
---
 fs/xfs/scrub/common.c |   40 ++++++++++++++++++++++++++++++++++------
 fs/xfs/scrub/inode.c  |    2 +-
 2 files changed, 35 insertions(+), 7 deletions(-)

