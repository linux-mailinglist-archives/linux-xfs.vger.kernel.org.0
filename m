Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4571665A025
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 02:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbiLaBBC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 20:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiLaBBB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:01:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF87F1DDE4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:01:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C33961D6A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB500C433D2;
        Sat, 31 Dec 2022 01:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448459;
        bh=QAMMZMURKLrOwMn7IowdItAQTDbt1S4hxGTcgqUDtNU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DcKBW8VOvNi5JIksHipsQgXJxGLHYVSEkZ0Ip8Y4KY/jgL8UuvC98U6owUFnr/570
         UaWd5xAqM4fDb2Wipivj5AN5E5plEhBNVwPBeSXj1BH67PWWDPgzVCQhZXYs4lIGCZ
         9QScsI52xtLbIXC0twSx7a1sj81Y9zp5ZLpgf8nUzvx3fGZhQ7VlksRs1sjc9b5hyC
         rEdcCDF8PFB6no0KXMb4BniML0Imiz606nSOvKeSUkjZqAOJHbhoc/F9g4rCOGxmIb
         5McorqFv7TQefoQfC44wZcRjMiHk+qAGkQRe/s7d4fP9vSAtx/7oySEuOCRJTzHmNy
         emKDuRfGs2wBA==
Subject: [PATCHSET v1.0 0/8] xfs_db: debug realtime geometry
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:36 -0800
Message-ID: <167243877610.728317.12510123562097453242.stgit@magnolia>
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

Before we start modernizing the realtime device, let's first make a few
improvements to the XFS debugger to make our lives easier.  First up is
making it so that users can point the debugger at the block device
containing the realtime section, and augmenting the io cursor code to be
able to read blocks from the rt device.  Next, we add a new geometry
conversion command (rtconvert) to make it easier to go back and forth
between rt blocks, rt extents, and the corresponding locations within
the rt bitmap and summary files.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=debug-realtime-geometry
---
 db/block.c        |  183 +++++++++++++++++++++++--
 db/convert.c      |  395 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 db/faddr.c        |    4 -
 db/init.c         |    7 +
 db/io.c           |   89 +++++++++++-
 db/io.h           |    6 +
 db/xfs_admin.sh   |    5 -
 man/man8/xfs_db.8 |  129 +++++++++++++++++
 8 files changed, 772 insertions(+), 46 deletions(-)

