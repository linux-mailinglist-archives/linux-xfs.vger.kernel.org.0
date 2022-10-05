Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E2B5F5CBC
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Oct 2022 00:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiJEWbO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Oct 2022 18:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiJEWbN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2022 18:31:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAD083F2C;
        Wed,  5 Oct 2022 15:31:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F3A4B81F6B;
        Wed,  5 Oct 2022 22:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482BDC433D6;
        Wed,  5 Oct 2022 22:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665009070;
        bh=cqohOG2iWyqitJZQUv4EOSEu7lAzbt/s9GYk76Bi524=;
        h=Subject:From:To:Cc:Date:From;
        b=ZsTtBsj4C3sB2g66SRKSFOEHFSgHKOw16BGTHsMRPOJquhrizFvsuBr3B3jWFAFck
         CHSGu1lf6WCQFil0lCnNT1++bxkksR5bWa8NJplhDRIQxLqUBnZIghkZKxKTHQ9wmK
         Lnhfi5NHkZM94YoqZ7lNgUUH7pMHalCdoLKUvg77JuVC9Kqygm5vfnLUBxRdl3sA6O
         8VzVUY7vM8VqNlARrLJQEFGfYiNPeF6urdSJkyV3dY/bSuTyzIszmgqz/AgRPx1oL0
         vk3hLizAVzHarEeS9yidJ+3hRwC/2WXjyfviaxIpdARBHVV1thOzwNB7mCTZfvM9dq
         qWAJsqy98v0AQ==
Subject: [PATCHSET 0/2] fstests: improve coredump capture and storage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 05 Oct 2022 15:31:09 -0700
Message-ID: <166500906990.887104.14293889638885406232.stgit@magnolia>
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

While I was debugging some core dumps resulting from xfs_repair fuzz
testing, I noticed that fstests was no longer putting core dumps into
the test results directory.  The root cause of this turned out to be
that systemd enables kernel.core_uses_pid, which changes the core
pattern from "core" to "core.$pid".  This is a good change since we can
now capture *all* the coredumps produced by a test, but bad in that the
check script doesn't know about this.

Therefore, fix check to detect multiple corefiles and preserve them, and
compress coredumps if desired.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=compress-core-dumps
---
 README    |    1 +
 check     |   26 ++++++++++++++++++++++----
 common/rc |   29 +++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 4 deletions(-)

