Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842692F8A53
	for <lists+linux-xfs@lfdr.de>; Sat, 16 Jan 2021 02:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbhAPBZH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 15 Jan 2021 20:25:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbhAPBZH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jan 2021 20:25:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E31E207B6;
        Sat, 16 Jan 2021 01:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610760266;
        bh=Ri2KTRIos0OhfZ8wOQ3huUm+B3sPBNIVxEWSJyhUNY8=;
        h=Subject:From:To:Cc:Date:From;
        b=TN/8enVsEM27AgLRv4fBA5voEZGurX66IMyUD+naxIXKEgXhiMxMOLCQSMjrZwF4Q
         BTjPaotPQPnW6BrkoPZBNrr3EEqkE/GRKQ1xYYg1c7r0VBvRqq+SLJ7j/qHodNra9e
         CXhYYvmgKIErk92dgWCdUntFENAqKPLLo0yvztZhd/i+7T9Ro68JeBvI5zRtZdrQXC
         kOMLNKsQAqAaLQmk3ziZYAix0FzzvalP+VUlkcRZcW1DZeGMUmu7ryulEZcysGySOv
         +K78WBX+XCbYn94zqgWH77Khcf9sDxAp/QWKZuHwEuy7QKliuaSTeZHfV/lGyKHyyZ
         rsFUA/2ejBslQ==
Subject: [PATCHSET v3 0/2] xfs_db: add minimal directory navigation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 15 Jan 2021 17:24:25 -0800
Message-ID: <161076026570.3386403.8299786881687962135.stgit@magnolia>
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
 db/namei.c               |  612 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    1 
 man/man8/xfs_db.8        |   20 ++
 6 files changed, 637 insertions(+), 1 deletion(-)
 create mode 100644 db/namei.c

