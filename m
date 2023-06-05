Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EB9722B49
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Jun 2023 17:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234680AbjFEPhB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 5 Jun 2023 11:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234726AbjFEPhA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 11:37:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A96AAF
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 08:37:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5D7261539
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 15:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2056EC433EF;
        Mon,  5 Jun 2023 15:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685979419;
        bh=sDrgSTo1KEr/Yxr3NPOVGVVGPk4fQ53he+av6JEn4s4=;
        h=Subject:From:To:Cc:Date:From;
        b=Bf/qG0ZrRg36fM2uo1L5a4ew/btnRJQtiUsZ8qrD2Fl/nX0HULqkWCTo93mcIBK4s
         ZHLxpbW0NmlgurpyUEWoLVZha8o/Fp80YLwqH3mz8gYUSb3IGyWnpItPZcQ3emdAAP
         tC0awl9IBk1tu10/PtIlOmO08clCwegbSJunJfSTxDjhJrCkzb18ftwvZ0Rc1ic3aY
         hghEI/8UNN5TN8eum+SSOXGwiHI8bJESubMCAC3cW552JPf2fp0VSYDUlwgUxHZBNh
         FPPjxDOTxFw4lbojMr4NpPS4YdPcmQZJ0uLdt2KhTYUom61HQCqBZ6cm6ot2tMRxnl
         byNpwQPPjytBA==
Subject: [PATCHSET 0/3] xfs_db: create names with colliding hashes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 05 Jun 2023 08:36:58 -0700
Message-ID: <168597941869.1226265.3314805710581551617.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While we're on the topic of directory entry naming, create a couple of
new debugger commands to create directory or xattr names that have the
same name hash.  This enables further testing of that aspect of the
dabtree code, which in turn enables us to perform worst case performance
analysis of the parent pointers code.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=db-hash-collisions
---
 db/Makefile       |    2 
 db/hash.c         |  418 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 db/metadump.c     |  383 -------------------------------------------------
 db/obfuscate.c    |  389 +++++++++++++++++++++++++++++++++++++++++++++++++
 db/obfuscate.h    |   17 ++
 man/man8/xfs_db.8 |   39 +++++
 6 files changed, 859 insertions(+), 389 deletions(-)
 create mode 100644 db/obfuscate.c
 create mode 100644 db/obfuscate.h

