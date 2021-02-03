Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D7F30E374
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Feb 2021 20:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhBCTnj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 3 Feb 2021 14:43:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230122AbhBCTnj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 14:43:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7046E64F51;
        Wed,  3 Feb 2021 19:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612381378;
        bh=szy2Mt3m4jvNRs2XK/pL11kr+8RfDaoYk524ahspNhc=;
        h=Subject:From:To:Cc:Date:From;
        b=h5gu5teo4BDgiAk8zsaEBNvgDpU0vr+JwROZuIar/ohtewi59QT8YRLNBWH38HpE5
         RSIVAvH56FzPg1vt9fXc0fKGqT5GT/H71mDB0zUNV4Uff55Rg8GPdABcjkjxjDYBGR
         aeoY8dXtCBtKWsS2yv54D6QSJWHLzsX6JyMurjj0Wf81DLzMEEEiE7Vx9gH0WAK0B9
         K5M50URjG+vhR3rooSS2GbOpMw9OE0acn5P/d9TGAxVX4YiBojNkZZkYxoPNpfGlsK
         Dbf5MmgjbbHeKI+ghdhpQfpoFDAXcjlxeKFbWPuXYoWou3tlOi9+YaozAwqJyaJ6Pa
         9rmHGdSMNmgGQ==
Subject: [PATCHSET v4 0/2] xfs_db: add minimal directory navigation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, chandanrlinux@gmail.com
Date:   Wed, 03 Feb 2021 11:42:57 -0800
Message-ID: <161238137774.1278216.17346983364750025070.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset improves the usability of xfs_db by enabling users to
navigate to inodes by path and to list the contents of directories.

v2: Various cleanups and reorganizing suggested by dchinner
v3: Rebase to 5.10-rc0
v4: fix memory leak

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfs_db-directory-navigation

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs_db-directory-navigation
---
 db/Makefile              |    3 
 db/command.c             |    1 
 db/command.h             |    1 
 db/namei.c               |  609 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    1 
 man/man8/xfs_db.8        |   20 ++
 6 files changed, 634 insertions(+), 1 deletion(-)
 create mode 100644 db/namei.c

