Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6AB652A6C
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Dec 2022 01:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbiLUAVj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 20 Dec 2022 19:21:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiLUAVi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 19:21:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004815FD8;
        Tue, 20 Dec 2022 16:21:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89A6D61629;
        Wed, 21 Dec 2022 00:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2393C433EF;
        Wed, 21 Dec 2022 00:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671582096;
        bh=rbGg1TnqTwosrtn0hG9wHcC+xtKwJHIwbzLVx+G7icI=;
        h=Subject:From:To:Cc:Date:From;
        b=WaQJhmIo4aU/TJ631Yiohne20CX3c8Wg8u06hLK//C/+sBjsCW8KIoV1EE7pWcgkO
         GsBFhU62vd9cn/U0cdLBNgzOsKYiyvNctf98JpbvcxggxcE4Q5qYJ4KSQSt9ft0drb
         fevJFZ/Htsu1FpuA1RvtKPivc3EEZacBoT+0znxKH/YarsFMiTVKPPspJA6Pf7XKQ0
         r3I+iCmLmMafBIJPwWeu7f6Vun31ahZOUdqsIZEbJ51nBU8GS1y0RHhevH4NQ+MEts
         1tXi9wa+jabgRgWF3QtIr6q/W//iWR2atxcolZS/ttz/3iRhS9iui/r1xkURDWG4pR
         Tmjq0gVj6lyPw==
Subject: [PATCHSET 0/1] fstests: fix tests for kernel 6.1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 20 Dec 2022 16:21:36 -0800
Message-ID: <167158209640.235360.13061162358544554094.stgit@magnolia>
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

Adjust filesystem tests to accomodate bug fixes merged for kernel 6.1.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs-fixes-6.1
---
 common/rc         |   15 +++++++++++++++
 tests/xfs/122     |    5 +++++
 tests/xfs/122.out |    8 ++++----
 3 files changed, 24 insertions(+), 4 deletions(-)

