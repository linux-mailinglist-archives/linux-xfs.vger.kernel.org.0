Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094F157A928
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Jul 2022 23:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234972AbiGSVpA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 Jul 2022 17:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235209AbiGSVo7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 17:44:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70ED1550E2
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 14:44:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E09961A7E
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 21:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAC7C341C6;
        Tue, 19 Jul 2022 21:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658267098;
        bh=60WoRsIgfvjPEKJt7lYUpiR4vWWoxMee/TdrZmayxK4=;
        h=Subject:From:To:Cc:Date:From;
        b=ArJWgnJBDFLbknTyLtAvDA4OIkn5h3kEpQ3aTx69Lyk5/PK2C+SYEdgTbQxYQxN4s
         HY4e+DEN01WnZ2bXnTpwNfy46esl4jtGnkVqDB0sQ5XlAQ7sJCM5Jxr9gT5C/8GeSl
         M47i3SRa2ytaFgAhWmqNQ3jixcUrMjbQA8uQaxhALCyk/M/dS9+HERR7HVTWKmhhJy
         ygoaPxsmy7YGigwyeRNA/3nj/lgMKBCOkd9SJwyTn6Xz2mxe1moIdfk9uGHB7l2E4p
         RE1JKjanTvnY5sOJGE4Bv/TwiOxpVcbyvwXVhOmtbOi+08HH9GmW5IswD4x2kO49ia
         45bAk3h33v3mA==
Subject: [PATCHSET v3 0/2] mkfs: stop allowing tiny filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 19 Jul 2022 14:44:58 -0700
Message-ID: <165826709801.3268874.7256134380224140720.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The maintainers have been besieged by a /lot/ of complaints recently
from people who format tiny filesystems and growfs them into huge ones,
and others who format small filesystems.  We don't really want people to
have filesystems with no backup superblocks, and there are myriad
performance problems on modern-day filesystems when the log gets too
small.

Empirical evidence shows that increasing the minimum log size to 64MB
eliminates most of the stalling problems and other unwanted behaviors,
so this series makes that change and then disables creation of small
filesystems, which are defined as single-AGs fses, fses with a log size
smaller than 64MB, and fses smaller than 300MB.

v2: rebase to 5.19
v3: disable automatic detection of raid stripes when the device is less
    than 1G to avoid formatting failures

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-forbid-tiny-fs
---
 mkfs/xfs_mkfs.c |   96 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 1 deletion(-)

