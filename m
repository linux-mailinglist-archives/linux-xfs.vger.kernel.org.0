Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E848B3EF65B
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Aug 2021 01:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbhHQXxe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Aug 2021 19:53:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235369AbhHQXxe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:53:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4663461008;
        Tue, 17 Aug 2021 23:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629244380;
        bh=dhzRTV86drTUyApRRKwYTDwNL1m0ep8XEBmh5RqLysY=;
        h=Subject:From:To:Cc:Date:From;
        b=msl3Ep59xcTBl/OV4woFIMdtMHw70yl2lGgx+U5ZtJtwLmfK8MOe4nhasLzQ0o1T4
         kLUaTUSBpkILAvS0svbKUj+wmYkFSWrNhE5iFSE9b9Yp7QzQ+R/nwTO0/jgBbCU2C6
         S1dScfjl56wQclDOWYL40iJ3/Sa8NmJi05aQeI3K9t7OBCjCGgPjJHwESnup/6z6FI
         Iu2tvx3u5RFpvNwAxKa8bR6ApkUrRUQ4YEhtBnkxMoOTSS3lWjUheeqHJ4v5ia1Qlx
         Z/K2CBm0a+1pjO3CvpjzNZNOgwVi8LgBAUpVqMr6rH7RKVfH+BqdHvogWlFbPN8b+L
         m4gTtzBioB/GQ==
Subject: [PATCHSET 0/2] fstests: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 17 Aug 2021 16:52:59 -0700
Message-ID: <162924437987.779373.1973564511078951065.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are the usual weekly fixes for fstests.

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
 common/scsi_debug |    4 ++--
 tests/xfs/176     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

