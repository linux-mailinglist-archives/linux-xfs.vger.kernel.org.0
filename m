Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A70711B29
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 02:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbjEZA2y (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 20:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbjEZA2u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:28:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA491A7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B91164C01
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2063C433D2;
        Fri, 26 May 2023 00:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685060920;
        bh=QW2zjwJlT64ePwtqmXqMuC0+ODivFZt6bWphVRpUre8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=uc5VwgEfYP7kRJU0LmXHDZnrFOE2SQILkZACPjsfsofw68JRPJ5ODpfV9ycfETkBF
         JdtoBgQDX/BInof/zJoEY/JAuo3jgh62HEa1lxhGkPOtcQPuzGyGiL1tINzjYRdvly
         Zm2CBevshBDmCncloKNYOq4Nh+Bvb09ngbt6Cu1uG1Qg2cAKPFYkOcbpQh7bC9D5xm
         Yn2XGxRwgO+LA6hvT+aLvlBeDZY6d+4BeTgQnRoWPSZHwgoDtYncCm71Aujw4nZbk7
         5RZRV4M3hkkdWd364V52vd8svtU7YuUMOTwx/A2yysjLMnO95h5PVqKylCcLIv8hvn
         EP+pzHHVwsKzQ==
Date:   Thu, 25 May 2023 17:28:40 -0700
Subject: [PATCHSET v25.0 0/6] xfs: prepare repair for bulk loading
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506056054.3728458.14583795170430652277.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
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

Before we start merging the online repair functions, let's improve the
bulk loading code a bit.  First, we need to fix a misinteraction between
the AIL and the btree bulkloader wherein the delwri at the end of the
bulk load fails to queue a buffer for writeback if it happens to be on
the AIL list.

Second, we introduce EFIs in the btree bulkloader block allocator to to
guarantee that staging blocks are freed if the filesystem goes down
before committing the new btree.

Third, we change the bulkloader itself to copy multiple records into a
block if possible, and add some debugging knobs so that developers can
control the slack factors, just like they can do for xfs_repair.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-prep-for-bulk-loading

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-prep-for-bulk-loading
---
 fs/xfs/Makefile                   |    1 
 fs/xfs/libxfs/xfs_btree.c         |    2 
 fs/xfs/libxfs/xfs_btree.h         |    3 
 fs/xfs/libxfs/xfs_btree_staging.c |   67 +++-
 fs/xfs/libxfs/xfs_btree_staging.h |   32 +-
 fs/xfs/scrub/agheader_repair.c    |    1 
 fs/xfs/scrub/common.c             |    1 
 fs/xfs/scrub/newbt.c              |  622 +++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.h              |   66 ++++
 fs/xfs/scrub/repair.c             |   10 +
 fs/xfs/scrub/repair.h             |    1 
 fs/xfs/scrub/scrub.c              |    2 
 fs/xfs/scrub/trace.h              |   37 ++
 fs/xfs/xfs_buf.c                  |   31 ++
 fs/xfs/xfs_buf.h                  |    1 
 fs/xfs/xfs_globals.c              |   12 +
 fs/xfs/xfs_sysctl.h               |    2 
 fs/xfs/xfs_sysfs.c                |   54 +++
 18 files changed, 912 insertions(+), 33 deletions(-)
 create mode 100644 fs/xfs/scrub/newbt.c
 create mode 100644 fs/xfs/scrub/newbt.h

