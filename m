Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E4734F5C3
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Mar 2021 03:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbhCaBJY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Mar 2021 21:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233013AbhCaBJC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 21:09:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E06A761935;
        Wed, 31 Mar 2021 01:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617152942;
        bh=rVe6z2Wv+fqFTOMnMfKh0akufG+rCsA5P08Nlzz2HWo=;
        h=Subject:From:To:Cc:Date:From;
        b=j+twZL3d9PgVmYbwSh+baNPdqUi98qJuKlWkxARKkQt2ZGccxiSak+Y4CdEzOFs05
         CUpNzfmUh84qNUtCzHlL/S17No5IWfeSbzyAqjDD/vnPLX/MRpfNO+IXaketjRs8TC
         VNc1viEosNIKB0nvRTDX3TDZdn2HU8/q/dEut68M2EpKVWbTMlCQFQi/ujxL42lJui
         Aadr5LRWuPcMiVvIQp5SWN7Th61O+iQWJBL4kX9h0o5PVa51+HxbcVUMuQZXFCZGod
         Gxihqk1JMg+3oRixSqJMaWKfOBmPvU+z1XXOtIU2zv9PNQKRVLr34Ppn2RSWu5yGfo
         F33ylIjVEReIg==
Subject: [PATCHSET 0/1] fstests: consolidate posteof and cowblocks cleanup
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 30 Mar 2021 18:08:59 -0700
Message-ID: <161715293961.2704105.12379656102061134645.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Currently, we treat the garbage collection of post-EOF preallocations
and copy-on-write preallocations as totally separate tasks -- different
incore inode tags, different workqueues, etc.  This is wasteful of radix
tree tags and workqueue resources since we effectively have parallel
code paths to do the same thing.

Therefore, consolidate both functions under one radix tree bit and one
workqueue function that scans an inode for both things at the same time.
At the end of the series we make the scanning per-AG instead of per-fs
so that the scanning can run in parallel.

Note that this is a fixup for a single sysfs change that appeared in
5.12.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=eofblocks-consolidation

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=eofblocks-consolidation
---
 common/xfs    |   23 +++++++++++++++++++++++
 tests/xfs/231 |   13 +++++++------
 tests/xfs/232 |   13 +++++++------
 3 files changed, 37 insertions(+), 12 deletions(-)

