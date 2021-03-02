Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF5232B0C9
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Mar 2021 04:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245635AbhCCDPj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 2 Mar 2021 22:15:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2360755AbhCBW25 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Mar 2021 17:28:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0847864F2D;
        Tue,  2 Mar 2021 22:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614724097;
        bh=FjskEvYplbKdhenQBBVULE7ZCzxo9WPNcKopjHKmxtM=;
        h=Subject:From:To:Cc:Date:From;
        b=POP0036p2sVNbChjci8nMbv8ZriRikmNz4QdlsPZ0BUE7fbRATOuUQmFeQatxMnF6
         vzFnDZ1JqweEtPyU9c/molQT+hsYrO6cAfgAWqeNjHtVsrpjsCQd4EnE5ULqyUI1LO
         qmap2xJB04E7ajDtny38dlhYyEQLL1Cxm55cHklTdlFZ7uIMPNF4ujYSOyhG5WZq6l
         dxtprqR2oJvBHA6PzDyt7O9Ta68S79uu2llLi/usqHBhAFoJuRPmhbZ8nAWfNXSA+k
         WqB35qgdPO3hlWtKKLcxccTUGi4mKWSsMGKW/+EFjxcyLw+mzaia5APOnpNtJcgHsE
         UHP+4lmcKgZ3A==
Subject: [PATCHSET 0/3] xfs: small fixes for 5.12
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Date:   Tue, 02 Mar 2021 14:28:16 -0800
Message-ID: <161472409643.3421449.2100229515469727212.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a handful of bug fixes for 5.12.  The first one fixes a bug in
quota accounting on idmapped mounts; the second avoids a buffer deadlock
in bulkstat/inumbers if the inobt is corrupt; and the third fixes a
mount hang if mount fails after creating (or otherwise dirtying) the
quota inodes.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes-5.12
---
 fs/xfs/xfs_inode.c   |   14 ++++++++------
 fs/xfs/xfs_itable.c  |   46 ++++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_mount.c   |   10 ++++++++++
 fs/xfs/xfs_symlink.c |    3 ++-
 4 files changed, 62 insertions(+), 11 deletions(-)

