Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D1A32246E
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Feb 2021 04:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhBWDCV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Feb 2021 22:02:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:47812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231185AbhBWDCK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 22:02:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E60764E77;
        Tue, 23 Feb 2021 03:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049285;
        bh=Z7yAS51Eh3Y/ByY9Y4sTAfFCpTBQ9D7sFjr+kx18lBQ=;
        h=Subject:From:To:Cc:Date:From;
        b=Q+7PxK5SGrjaMa1bm88TGrI1fn11J6/v7d6ZfTQHFKz5tFf1ygtB/uW0z7Yuudf5P
         NOpArJNAnaHlrgi0QU8wnJQsednyqYdmyC+J0aLda11NYSMLltzraacwM4DotHP5V2
         dOcVgsC1dsjHioNGrpvKssCaprSI2kVebtDJviQETwnjOF3QyTPf5NOFL8C6dHqsEh
         nox9RDVgUkQaFQ+j4NQxZok1ahaMeovklKNzB0HCoh+l5jrFKPZl0nUrI2SuxyhUTF
         cOW7ROoYpAYR1Wd/p/mqRuz2UyXrFT18tdSSeSMIMhQNMtzfcB8GoN8DVCQZEBBGka
         zpJu/pGOExXHw==
Subject: [PATCHSET v6.1 0/5] xfs_admin: support upgrading v5 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@lst.de, bfoster@redhat.com
Date:   Mon, 22 Feb 2021 19:01:25 -0800
Message-ID: <161404928523.425731.7157248967184496592.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This submission extends xfs_repair and xfs_admin to support adding the
inode btree counter and bigtime features to an existing v5 filesystem.
The first three patches lay the groundwork in both tools for performing
upgrades, and the last two patches add the ability to add features.

v2: Rebase to 5.10-rc0
v3: respond to reviewer comments
v4: document which kernel version these new features showed up in
v5: move all the upgrader code to xfs_repair per Eric suggestion, which
    eliminates a bunch of fragile db/admin/repair coordination.
v6: update mkfs/admin/repair manpages to identify CLI options that apply
    only to V4 fses and are therefore deprecated
v6.1: repost after rebasing the previous two series

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=fs-upgrades
---
 db/xfs_admin.sh      |    6 ++-
 man/man8/mkfs.xfs.8  |   16 +++++++++
 man/man8/xfs_admin.8 |   47 +++++++++++++++++++++++++
 repair/globals.c     |    2 +
 repair/globals.h     |    2 +
 repair/phase2.c      |   93 ++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/xfs_repair.c  |   22 ++++++++++++
 7 files changed, 186 insertions(+), 2 deletions(-)

