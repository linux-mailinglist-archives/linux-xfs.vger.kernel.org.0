Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9170F4DD016
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Mar 2022 22:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiCQVWS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Mar 2022 17:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiCQVWR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 17:22:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE832185945
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 14:20:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BD8FB8200A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 21:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCD5C340E9;
        Thu, 17 Mar 2022 21:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647552055;
        bh=Pj+su6doAeGyNIwaNzrxS7vEWWfJNlvleNHh0VH9T54=;
        h=Subject:From:To:Cc:Date:From;
        b=QMwdkWPAdKpsgFU3Eh7zVW2LslAfh5qdwWmyIEuYbuhJL2jFYGwHyAOTTofl/gYZV
         V0FnTngbYs4lNWn56xnDmV26ujR8tZ3XA8hRg3vMq/NWuMMo8i9uFKexqptChCTd2M
         w3tNy07qUuQyc3LIJN/6ortgyoqoYE8IxmYZfGIMrmJlUZ+h07uQsoCwz4MKjdCEbg
         eeh/zLfaXU7hPj74DXFQODu71Y7FpamlULN4Oz1E2kls3Wn1sebLDjfv6axvok3uQc
         Sd3GRcz622I0sip/ecMcZp1dFYxLExHlhPUv5coX7y6py4B5vb18ARSPxhM6CjJu3T
         clZO6yL2/O2Wg==
Subject: [PATCHSET v2 0/6] xfs: fix incorrect reserve pool calculations and
 reporting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com, david@fromorbit.com
Date:   Thu, 17 Mar 2022 14:20:55 -0700
Message-ID: <164755205517.4194202.16256634362046237564.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Last week, I was running xfs/306 (which formats a single-AG 20MB
filesystem) with an fstests configuration that specifies a 1k blocksize
and a specially crafted log size that will consume 7/8 of the space
(17920 blocks, specifically) in that AG.  This resulted mount hanging on
the infinite loop in xfs_reserve_blocks because we overestimate the
number of blocks that xfs_mod_fdblocks will give us, and the code
retries forever.

Initially, this was a single patch that fixed the calculation and
transformed the loop into a finite loop.  However, further discussion
revealed several more issues:

 * People had a hard time grokking that the "alloc_set_aside" is
   actually the amount of space we hide so that a bmbt split will always
   succeed;
 * The author didn't understand what XFS_ALLOC_AGFL_RESERVE actually
   mean or whether it was correctly calculated;
 * The "alloc_set_aside" underestimated the blocks needed to handle any
   bmap btree split;
 * Both statfs and XFS_IOC_FSCOUNTS forgot to exclude the amount of
   space used by the free space btrees on behalf of per-AG reservations,
   leading to overreporting of available space;
 * The loop control change really should have been separate.

Hence, this patchset has now grown to six patches to address each of
these issues separately.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reserve-block-fixes-5.18
---
 fs/xfs/libxfs/xfs_alloc.c |   30 +++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_alloc.h |    3 +--
 fs/xfs/libxfs/xfs_sb.c    |    2 --
 fs/xfs/xfs_fsops.c        |   24 +++++++++++++++++-------
 fs/xfs/xfs_log_recover.c  |    2 +-
 fs/xfs/xfs_mount.c        |    9 ++++++++-
 fs/xfs/xfs_mount.h        |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_super.c        |    4 +---
 8 files changed, 95 insertions(+), 24 deletions(-)

