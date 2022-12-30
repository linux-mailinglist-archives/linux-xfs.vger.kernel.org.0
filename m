Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F371659DD5
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 00:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbiL3XKl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 18:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiL3XKk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:10:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF0D2DC7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:10:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9644961C37
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE78C433D2;
        Fri, 30 Dec 2022 23:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441839;
        bh=rbis/b0qtA8ytpcsC4BInT0sWPulWznOQeu94UBDor4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IIYlvAkplx4RGZpqdr+5eafg2kT57Mz5J8DjrCCUOVMycy6lXZ2zJXUVij/Y9zKlU
         ZgWeiOowLQOr1aaTM+JQy9yv4J8ViCCBSsYU0IPEkGs+QTzZvtdWv2WrqObNv03+s4
         Eket8TsfnhHu9hB7NZx2jIiMOVtqJQxdtJn9lzGUZle9FvPdUdlPe7t2I4ynNALJFt
         PCt0DIblUProatRgTPH20x6iENa6ZYgnTeL+fD0nYzbOrnBI10TY3XO+RvCHwninDC
         RNs/Qy8+H0mjbEWxoTXrQkjEtnxiiPl/0M142wtVkL6W7dhBo6lUu57kUU2zpXSCFD
         /X5rHWVpVsbxg==
Subject: [PATCHSET v24.0 0/4] libxfs: indirect health reporting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:38 -0800
Message-ID: <167243865816.711359.1865490497957941966.stgit@magnolia>
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

This series enables the XFS health reporting infrastructure to remember
indirect health concerns when resources are scarce.  For example, if a
scrub notices that there's something wrong with an inode's metadata but
memory reclaim needs to free the incore inode, we want to record in the
perag data the fact that there was some inode somewhere with an error.
The perag structures never go away.

The first two patches in this series set that up, and the third one
provides a means for xfs_scrub to tell the kernel that it can forget the
indirect problem report.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=indirect-health-reporting

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=indirect-health-reporting
---
 libfrog/scrub.c                     |    5 ++++
 libxfs/xfs_fs.h                     |    4 ++-
 libxfs/xfs_health.h                 |   45 +++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_buf.c              |    2 +-
 man/man2/ioctl_xfs_scrub_metadata.2 |    6 +++++
 scrub/phase1.c                      |   38 ++++++++++++++++++++++++++++++
 scrub/repair.c                      |   15 ++++++++++++
 scrub/repair.h                      |    1 +
 scrub/scrub.c                       |   16 ++++++++----
 scrub/scrub.h                       |    1 +
 spaceman/health.c                   |    4 +++
 11 files changed, 129 insertions(+), 8 deletions(-)

