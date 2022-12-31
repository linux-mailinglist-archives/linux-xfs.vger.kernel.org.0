Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0812665A269
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 04:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbiLaDUI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 22:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiLaDUH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:20:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B51A2733
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:20:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 037E561D5F
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600E5C433D2;
        Sat, 31 Dec 2022 03:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456806;
        bh=+VPNufuSwWc+T8ZhonzMZOZbJZBYFXgNd3uOSmJOIO8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uEoOYXKqRTUlnfiiDEvarg7o2o6gBn9EbKvqRk5t3aEqRTl+paHGasBxw1K9+WLMT
         QMYhI5NZF+nsxqoIqH46wJ9t6pB+7BYl/BEZOtOHlvL02w4JQvb1DbzeAAsAUjM+qo
         U11+LdbWu9yu9BXT4gZO3GWcfQ1aCvbdvYdzZyun0SRGWZ4z/i5loB+lm1YU4rjomP
         sjGJ2rpivudeEhlpc1bZSU4xlOcQIpTaNnsVakVkluRC/Vxr/yZzKleJZR6aktdnFB
         rGFqAwweae9HFokacGoAZSkFukkJW4QP+xhHXCHXJ3AQFDB57oCwouxihTADGBk/kx
         cUTaVnZJyp1bw==
Subject: [PATCHSET 0/3] xfs: improve post-close eofblocks gc behavior
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:20 -0800
Message-ID: <167243876021.726374.15071907725836376245.stgit@magnolia>
In-Reply-To: <Y69Uw6W5aclS115x@magnolia>
References: <Y69Uw6W5aclS115x@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a few patches mostly from Dave to make XFS more aggressive about
keeping post-eof speculative preallocations when closing files.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reduce-eofblocks-gc-on-close
---
 fs/xfs/xfs_bmap_util.c |    9 ++++++---
 fs/xfs/xfs_file.c      |   14 ++++++++++++--
 fs/xfs/xfs_inode.c     |   13 ++++++-------
 fs/xfs/xfs_inode.h     |    2 +-
 4 files changed, 25 insertions(+), 13 deletions(-)

