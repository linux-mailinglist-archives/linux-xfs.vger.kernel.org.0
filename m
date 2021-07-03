Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DE33BA6CD
	for <lists+linux-xfs@lfdr.de>; Sat,  3 Jul 2021 04:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhGCDBC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Jul 2021 23:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230490AbhGCDBC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jul 2021 23:01:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A21C613EB;
        Sat,  3 Jul 2021 02:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625281109;
        bh=CoBWTaXpCe6E96jx9A6NCAFKf1l5NnRFPGTi9b3QBCw=;
        h=Subject:From:To:Cc:Date:From;
        b=BDSWgz7Hgb2KUC1lg+cWSz6PcvZ4gqEOfK4GV4oqhmPDprec1KhDzfVUkJG+ZABvT
         0/pnMVD3aV72k5jsAUSFUgplIr/JRA2n+6DKVISp3r33KsXV5izKTeVcbQuaWrPsCR
         +Lq9DPi4dje9QBbIvMeoF3UxOEHNoGkMsNCmns9BXlgEkDo/y6+T318H1o8KX/r+YE
         8nRqA9BuE6E7l1IE7rfjRvpX62Zs+HEWLD+Y7JXhOuMALb9BlGpC2pjiPllxGLzdJT
         vIrgEHuYKfChFtGIG7SZRb3BSq0U3X1HLFxxYJAAdWMHHkRLvqNcKfs5Rryd2PJHaN
         5e6vdkrAVEHoQ==
Subject: [PATCHSET 0/1] xfs_admin: support online fs label queries
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 02 Jul 2021 19:58:29 -0700
Message-ID: <162528110904.38981.1853961990457189123.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Upgrade xfs_admin to support label queries of mounted filesystems.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=online-labelling

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=online-labelling
---
 db/xfs_admin.sh |   41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

