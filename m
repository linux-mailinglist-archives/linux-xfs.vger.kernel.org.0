Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0A0711B46
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 02:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbjEZAe1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 20:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234230AbjEZAe0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:34:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FBB19C
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:34:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D13A264AFD
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF55C433D2;
        Fri, 26 May 2023 00:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061264;
        bh=BnZ3K4w2M0Ac8S4PYeZnJSb9aHmKX0Cu5hTmEuxgAUk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=svyxDVTOQ7K8SUA7GjrMHjz1q7a2rnszR+0KezgdQ5CfHw5hwP8cy3yK0b4cbb9WW
         jZ04DHlAg1c/BKKcQ5tISVRv9cOQBX12qV8KElImSkFqcRVKMqX09SYjvw+X+hGyvh
         l1vnl3HG0Xv2v7WY+uFroKUZKTU8bwV8J8cusWhKZwTLrMZl8bHbj04REGPQy8RBqe
         PZXe4KMbiEgQjNPIZ6LRHdZRI6lovbppRXIEDU9y+07e7neWccwfyZX88a6LTC6RG4
         Qu6BS7RbyGIhqIdvpVlv1EiBzCJ/zwJxDKg2waSBZ7REeVjORmvcfES3dk1o+vCRII
         +SYW/VcRCOhZw==
Date:   Thu, 25 May 2023 17:34:23 -0700
Subject: [PATCHSET v25.0 0/3] xfs: clean up symbolic link code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506064562.3734314.9065396398319098452.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series cleans up a few bits of the symbolic link code as needed for
future projects.  Online repair requires the ability to commit fixed
fork-based filesystem metadata such as directories, xattrs, and symbolic
links atomically, so we need to rearrange the symlink code before we
land the atomic extent swapping.

Accomplish this by moving the remote symlink target block code and
declarations to xfs_symlink_remote.[ch].

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=symlink-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=symlink-cleanups
---
 fs/xfs/libxfs/xfs_bmap.c           |    1 
 fs/xfs/libxfs/xfs_inode_fork.c     |    1 
 fs/xfs/libxfs/xfs_shared.h         |   14 ---
 fs/xfs/libxfs/xfs_symlink_remote.c |  155 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_symlink_remote.h |   27 ++++++
 fs/xfs/scrub/inode_repair.c        |    1 
 fs/xfs/scrub/symlink.c             |    3 -
 fs/xfs/xfs_symlink.c               |  145 ++--------------------------------
 fs/xfs/xfs_symlink.h               |    1 
 9 files changed, 193 insertions(+), 155 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_symlink_remote.h

