Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241F8659DD2
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 00:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbiL3XJw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 18:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiL3XJv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:09:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF791D0EC
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:09:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B1B761C2F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45FBC433D2;
        Fri, 30 Dec 2022 23:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441789;
        bh=31vavd5aDjewBWWZ2/i4a8EX/+MPFrweI3n8uIHpXhg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YYkVG8ekK/EzsVXvVQn5z9SbsMd6TAVNtsOxRHcrxsmZwDXjlzVlTqm4TuxDvUBdo
         Eo/DW8vdJtqh2fbQ35KVnR/HirGT2iLNYZoxCQ9IJ5hmNsYrOJ2m3GTYh6yGd5k2iy
         cWs4R4PnTXZYEf6XnpuCc4UEsrS7T2LpVPOqLsAQqgk9L90Nx8EVJcuuNZbXpg77V0
         UfPytzoTcq8ZQgVUH3xapn9Zh67rU+1hO+jiFWfThsvfEOgnZ5fazyZzIUE239ycIq
         YHwXmPpKUegSZjPjkbfFEVwbZQSyc1ldWmwzc/dad9Jw1u31Xuy2cviwJTJp4OLbS9
         JICZdrc9bbPyg==
Subject: [PATCHSET v24.0 0/3] libxfs: online repair of quota counters
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:28 -0800
Message-ID: <167243864892.708814.13943121883358066158.stgit@magnolia>
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

This series uses the inode scanner and live update hook functionality
introduced in the last patchset to implement quotacheck on a live
filesystem.  The quotacheck scrubber builds an incore copy of the
dquot resource usage counters and compares it to the live dquots to
report discrepancies.

If the user chooses to repair the quota counters, the repair function
visits each incore dquot to update the counts from the live information.
The live update hooks are key to keeping the incore copy up to date.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-quotacheck

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-quotacheck

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-quotacheck
---
 io/scrub.c                      |    3 +++
 libfrog/scrub.c                 |    5 +++++
 libfrog/scrub.h                 |    1 +
 libxfs/xfs_fs.h                 |    4 +++-
 libxfs/xfs_health.h             |    4 +++-
 man/man2/ioctl_xfs_fsgeometry.2 |    3 +++
 scrub/phase4.c                  |   17 ++++++++++++++++
 scrub/phase5.c                  |   22 +++++++++++++++++++-
 scrub/repair.c                  |    3 +++
 scrub/scrub.c                   |   42 +++++++++++++++++++++++++++++++++++++++
 scrub/scrub.h                   |    2 ++
 scrub/xfs_scrub.h               |    1 +
 spaceman/health.c               |    4 ++++
 13 files changed, 107 insertions(+), 4 deletions(-)

