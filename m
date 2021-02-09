Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55BA314761
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Feb 2021 05:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhBIEPm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Feb 2021 23:15:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:48560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230319AbhBIENq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:13:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AF9764E4F;
        Tue,  9 Feb 2021 04:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843863;
        bh=23GjxwIAk435cQf23Nn9z838hvpyMRJ+UQGw3cYe6pk=;
        h=Subject:From:To:Cc:Date:From;
        b=GK2fbaNKT96RNiRiaNPXpmw6f38AJLfLGRq1moU/A+CiTePy3/6ZieU7jp2aYYaD3
         G/BuU0QhIRRPJBU2/dfS9uERVxOnRpwrN/ZbrTSovpweQCCfQAPI/G7B+p67lVfYRM
         RPMRJmehMhW1QlNH2ydwYOerUn0siF+163vOyRpvu/d5HvTSqvZwbAFiwvWpeB8rmQ
         dzIv9m5Nr1VgEMW6YqWHKmWzueiqw6a8ZRcNdDfIubVrsM+IQhS9qwIPGAnl2+nTo+
         jP/8sXDHyM7mHZDoqR0jaT5EAdwUHs12DfjluE72ztjplDiOUk+EMD9s0L5gN5OPPB
         BiBoZNAWHx9ig==
Subject: [PATCHSET v5 0/2] xfs_admin: support upgrading v5 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, bfoster@redhat.com
Date:   Mon, 08 Feb 2021 20:11:02 -0800
Message-ID: <161284386265.3058138.14199712814454514885.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This submission extends xfs_db and xfs_admin to support adding the inode
btree counter and bigtime features to an existing v5 filesystem.

v2: Rebase to 5.10-rc0
v3: respond to reviewer comments
v4: document which kernel version these new features showed up in
v5: move all the upgrader code to xfs_repair per Eric suggestion, which
    eliminates a bunch of fragile db/admin/repair coordination.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=fs-upgrades
---
 man/man8/xfs_admin.8 |   17 +++++++++++++++-
 repair/globals.c     |    2 ++
 repair/globals.h     |    2 ++
 repair/phase1.c      |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/xfs_repair.c  |   22 +++++++++++++++++++++
 5 files changed, 94 insertions(+), 1 deletion(-)

