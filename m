Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F2B7C5AB6
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Oct 2023 20:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbjJKSBF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Oct 2023 14:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbjJKSBE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:01:04 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96319E
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:01:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D42C433C8;
        Wed, 11 Oct 2023 18:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047261;
        bh=YCfSDBCfz/8PYAa0OOtWsNSBFj7+YyBf8/SPm8Q31x0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=aDaRDGHhJqlDRhsg6uRsBDgINi36Mh3Zk7R6dCG0Y6CoINZmwy+FIY1VG3rt6v1D3
         4t0cM5DAVFbiu4+tg2c6hzNPAmScVfosnnHRq+YgRgnspv8cLkeq78HqZJrtfM1tat
         S8OVKtHYEGqYNbqp4ehLBnOj6214WdSRY7JQx2AUsW6268MXjr0i894D/fLVTliDHO
         NZAxJ/eerhAa0JpwKBEw3czvRbYZM80Mvb+kMHcQrh5GTqd+TUoMAZDjYXRH9LuMav
         FTBgsuDWRpNo597P1XNimoIe4RERg6rdb+eY+3Zoztb51sK8QnbM2Z+VZsvbyR4ugf
         sCGy3ymKz9mCA==
Date:   Wed, 11 Oct 2023 11:01:00 -0700
Subject: [PATCHSET RFC v1.0 0/3] xfs: minor bugfixes for rt stuff
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704720334.1773263.7733376994081793895.stgit@frogsfrogsfrogs>
In-Reply-To: <20231011175711.GM21298@frogsfrogsfrogs>
References: <20231011175711.GM21298@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a preparatory patchset that fixes a few miscellaneous bugs
before we start in on larger cleanups of realtime units usage.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-fixes
---
 fs/xfs/libxfs/xfs_sb.h |    2 +-
 fs/xfs/xfs_rtalloc.c   |    2 +-
 fs/xfs/xfs_rtalloc.h   |   24 ++++++++++++------------
 3 files changed, 14 insertions(+), 14 deletions(-)

