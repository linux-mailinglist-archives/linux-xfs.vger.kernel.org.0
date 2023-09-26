Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068FD7AF7BE
	for <lists+linux-xfs@lfdr.de>; Wed, 27 Sep 2023 03:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbjI0BqK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 26 Sep 2023 21:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235438AbjI0BoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 21:44:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187C1273A
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:29:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECF2C433C7;
        Tue, 26 Sep 2023 23:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695770973;
        bh=Qg5GmLJZRijMf7hOs+fd9D6OiRNWXlqSWN8daSw0+bs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=PbIZmRsEFY0BrVBJZuJtw9dB5AKwnZ5GpYns8ClCy/mrt1Im1mNGAjdA6hdYyD8xP
         UVNYFzKC/46Cv2pCk40wfmk1Q7K8CSKmVb+26DISiWXQuco4Nz1mmI8Wr8YFAWClY4
         Wrma5VvXQ51OjuAJJSnllFYuNIToVYuYHQ/y8RPON5HGW0MfOhyt7QukuhuDclu8z+
         NTjyH3X2Hr2f1qxOKr9HcwBmvyTiwogNc92nakClpbfMOkVsHyAzsTd5ICV0xU3dVI
         95rumur5HBncpxn9r/lIGpdovG1P/NKUlVNJ4S/5W+UvwNgI7Ccga3oIOvXoks9wBB
         8hxiUepdmB9xQ==
Date:   Tue, 26 Sep 2023 16:29:33 -0700
Subject: [PATCHSET v27.0 0/4] xfs: prepare repair for bulk loading
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577059572.3313134.3407643746555317156.stgit@frogsfrogsfrogs>
In-Reply-To: <20230926231410.GF11439@frogsfrogsfrogs>
References: <20230926231410.GF11439@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
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

Second, we introduce a defer ops barrier object so that the process of
reaping blocks after a repair cannot queue more than two extents per EFI
log item.  This increases our exposure to leaking blocks if the system
goes down during a reap, but also should prevent transaction overflows,
which result in the system going down.

Third, we change the bulkloader itself to copy multiple records into a
block if possible, and add some debugging knobs so that developers can
control the slack factors, just like they can do for xfs_repair.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-prep-for-bulk-loading

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-prep-for-bulk-loading
---
 fs/xfs/libxfs/xfs_btree.c         |    2 +
 fs/xfs/libxfs/xfs_btree.h         |    3 ++
 fs/xfs/libxfs/xfs_btree_staging.c |   67 +++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_btree_staging.h |   25 +++++++++++---
 fs/xfs/scrub/newbt.c              |   11 ++++--
 fs/xfs/xfs_buf.c                  |   47 ++++++++++++++++++++++++--
 fs/xfs/xfs_buf.h                  |    1 +
 fs/xfs/xfs_globals.c              |   12 +++++++
 fs/xfs/xfs_sysctl.h               |    2 +
 fs/xfs/xfs_sysfs.c                |   54 ++++++++++++++++++++++++++++++
 10 files changed, 189 insertions(+), 35 deletions(-)

