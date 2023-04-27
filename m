Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C61F96F0E80
	for <lists+linux-xfs@lfdr.de>; Fri, 28 Apr 2023 00:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344248AbjD0WsW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Apr 2023 18:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjD0WsV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 18:48:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7E22685
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 15:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AFED64033
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 22:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939D5C433EF;
        Thu, 27 Apr 2023 22:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682635698;
        bh=PZYyEQ8m+t7g4aoKIHxXgCOdm0hjbqvRad1FRQj/Qn0=;
        h=Subject:From:To:Cc:Date:From;
        b=buCL5//AZuNvknnA3MN9qNewQmJDLohz8x8gAWNgZGNeL7nlpolqDYnD4JHl/Rvob
         ZZAWJ/kRtDOD6D6u2RyA8GGD5P7x3zh3tCBDPuv6tqDA3YDm8mS4lfc0tGIR/8gGxh
         UuOPl5hvYfYUlGu8Phk6NYl4UP8sx+wG+PbRvyzvCS2WxyurP/1EHJo7wshJAaxFnE
         ZZZV+liQVrgZRdTKiUeYd+cuqkgg/7vJs8ZP9dH3s7b1DoyTbm5dpZRnOhnlOR7Snc
         IMJWhQl81XAZJ5uXbJC4dMUWv6JpxAowJMUSlAi23gj/wbdSh47H7gDxLfoco8I93T
         e5jEeycQp45sA==
Subject: [PATCHSET 0/4] xfs: bug fixes for 6.4-rc1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     dchinner@fromorbit.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Thu, 27 Apr 2023 15:48:18 -0700
Message-ID: <168263569804.1717447.12960771904502687107.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are some assorted bug fixes for 6.4:

 * A regression fix for the allocator refactoring that we did in 6.3.
 * Fix a bug that occurs when formatting an internal log with a stripe
   alignment such that there's free space before the start of the log
   but not after.
 * Make scrub actually take the MMAPLOCK (to lock out page faults) when
   scrubbing the COW fork
 * If we call FUNSHARE on a hole in the data fork, don't create a
   delalloc reservation in the cow fork for that hole.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=kernel-fixes-6.4
---
 fs/xfs/libxfs/xfs_ag.c   |   10 +++++-----
 fs/xfs/libxfs/xfs_bmap.c |    5 +++--
 fs/xfs/scrub/bmap.c      |    4 ++--
 fs/xfs/xfs_iomap.c       |    5 +++--
 4 files changed, 13 insertions(+), 11 deletions(-)

