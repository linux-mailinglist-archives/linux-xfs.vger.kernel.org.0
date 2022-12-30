Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44D9659DDA
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 00:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbiL3XMB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 18:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiL3XMA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:12:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9511DE81
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:11:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D7D6B81DAD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49197C433D2;
        Fri, 30 Dec 2022 23:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441917;
        bh=M45RYdqbcLfATIfeRDHrFbrkyl64OjiXVIQSW1eEK/U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=seOM3JEt4Kyw1nNLtlnLSpWMU9xpAGEu8mlY7GlKNT7ZBw93RBVTbNdHhMmyeOl9V
         cjb9uPTh//q+WS6dkeFzemQAvPM9DDkIlVy5WY0+Fkakfr0x9b0uBUaoMI57vmMLNQ
         M0PEoKerWWtnRB/I5JGYlCvJ1JGr4vVOzO3MsjoeyeZ0Rd0YYqOeWWVu8Oh/xYynv7
         OOI+xxeWV/wEHqgpexks777ifc/HoLAaCIl65ymS4V39JbG4PWFp4C/uPm+s2zOVnw
         ZYuZZtabmfz1gotzrHGUSyU1cXeUcY6zlg4Llt1EVGsm21b2ofZybOXAEo06XtfnxP
         gUtdrd87cF16g==
Subject: [PATCHSET v24.0 0/4] libxfs: clean up symbolic link code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:55 -0800
Message-ID: <167243867587.713532.17037228277541976894.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
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
 include/libxfs.h            |    1 
 libxfs/libxfs_api_defs.h    |    1 
 libxfs/xfs_bmap.c           |    1 
 libxfs/xfs_inode_fork.c     |    1 
 libxfs/xfs_shared.h         |   14 ----
 libxfs/xfs_symlink_remote.c |  155 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_symlink_remote.h |   27 +++++++
 mkfs/proto.c                |   72 +++++++++++---------
 8 files changed, 223 insertions(+), 49 deletions(-)
 create mode 100644 libxfs/xfs_symlink_remote.h

