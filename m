Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6EF52C2DE
	for <lists+linux-xfs@lfdr.de>; Wed, 18 May 2022 21:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241712AbiERSzt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 May 2022 14:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241725AbiERSzs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:55:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF11CE0D4
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:55:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F05A6189A
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA655C385A5;
        Wed, 18 May 2022 18:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900144;
        bh=AcUVWV/hlvbrPrXZOJRi8RKoH74FKrzirOWd9fVxkhY=;
        h=Subject:From:To:Cc:Date:From;
        b=B/eBBq20jh9apcWUowwolEuvvGlDeBrvxP77zXe34QrAH6d7qIyaQsMeC+r9TX0DP
         3n29GJWcwMQibK4bF5059IPLCSI/0xlQH0W09s6YIxxAYTHbbabxc758vLJxpwY798
         EZizlX7JoEMV4LRydQ5xX7uGktTzodO0jvGqGxTIDAMLpLFOn47GoTwhUXLWhRQ/Oe
         PiSZM0FjBBe1NQTfxB/LFPg0kwl4e1w9XWrpdoZuhBV5d3VHKNj+1z9qd1Jef2Qwdf
         +RmFgWEEWmrtfJBHHBCKTws+IQbWgWkQS9et3GrQo7FJGqevhEDuf5nha3ExMnMSbF
         lu5GKKhK1txOQ==
Subject: [PATCHSET v2 0/7] xfs: cleanups for logged xattr updates
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 18 May 2022 11:55:44 -0700
Message-ID: <165290014409.1647637.4876706578208264219.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are a bunch of cleanups to the logged xattr code to use slab caches
for better memory efficiency, reduce the size of the attr intent
tracking structure, fix some wonkinessin the attri/attrd cache
constructors, and give things more appropriate names.

v2: add RVB tags, rebase off of the other fixes

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=attr-intent-cleanups-5.19
---
 fs/xfs/libxfs/xfs_attr.c        |  172 +++++++++++++++++----------------------
 fs/xfs/libxfs/xfs_attr.h        |   54 +++++-------
 fs/xfs/libxfs/xfs_attr_remote.c |    6 +
 fs/xfs/libxfs/xfs_attr_remote.h |    6 +
 fs/xfs/libxfs/xfs_da_btree.c    |   11 ++
 fs/xfs/libxfs/xfs_da_btree.h    |    1 
 fs/xfs/libxfs/xfs_defer.c       |    8 --
 fs/xfs/libxfs/xfs_log_format.h  |    8 +-
 fs/xfs/xfs_attr_item.c          |   54 +++++++-----
 fs/xfs/xfs_attr_item.h          |    9 +-
 fs/xfs/xfs_super.c              |   19 ++++
 11 files changed, 177 insertions(+), 171 deletions(-)

