Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F95C3FD028
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Sep 2021 02:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242783AbhIAAMJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 31 Aug 2021 20:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242522AbhIAAMI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 20:12:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2CE361008;
        Wed,  1 Sep 2021 00:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630455071;
        bh=L0OyvSfeQqTJaVD4/Nx3k0FQp3vn7GwZcVWeqgTnSPI=;
        h=Subject:From:To:Cc:Date:From;
        b=Omt7sr9fZNrUHBXLdWfmso3Ftj5Agupe635arrldnnrfKResy2iYcudzTxxWK+B/9
         0K4ROaSK0KgwoXb/LCKz5QbXmQ+QnVpnecd+M72oNgN0JfmEoGeBftzugtbCvAP4GH
         AcdCA4rIFsEN3otLuybq/jdLDvqw6bAe2WzZCJl2AEJI9ERduNj46t8wkZFSgSlGUA
         cUw7du2eA1vBSGp2cHY2o2psq0CoVYxzWWebY4eFuPQGtyeZc4ycd+sHpAH64D5PYd
         0mfAGad266GhtE2kbsB3o3MMPPcSE3jkRvyjq+Xz+mqJGNuainCRcKppl7itsnG/S5
         NdmiqyxJxow6Q==
Subject: [PATCHSET 0/2] fstests: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Aug 2021 17:11:10 -0700
Message-ID: <163045507051.769821.5924414818977330640.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This week I have two random fixes:

The first update removes xfs_check from the default test configuration,
as I have finally completed my quest to make sure that xfs_repair (5.13)
catches all the corruption errors that xfs_check does.  Since xfs_check
has a tendency to OOM, let's remove the redundant code to save everyone
some run time.

The other is an update to the swapfile corruption test to add the commit
id for the kernel fix and fix some problems on arm64.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 README                |    4 ++++
 common/xfs            |   12 ++++++++----
 tests/generic/643     |   33 ++++++++++++++++++++++-----------
 tests/generic/643.out |    2 +-
 4 files changed, 35 insertions(+), 16 deletions(-)

