Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03867322466
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Feb 2021 04:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhBWDBu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Feb 2021 22:01:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:47642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231284AbhBWDBq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 22:01:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCEAB64E62;
        Tue, 23 Feb 2021 03:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049261;
        bh=E83Ie6t7GaBcL4XXeoyU1X2tEKTcQdXWhQvizV4u4VA=;
        h=Subject:From:To:Cc:Date:From;
        b=b/Bb0VnEbpuOUJVREV+GGLH+khXmtYD6DJnAt8X3laW2bHZRa+nFBtAiM2VHG03ak
         nTfP5xnt6mmoIU79Rax60RCu1oSKUSxVD8ZK2TT0FqtfrvPUQqd7mg2LXC6kJs5Fsl
         bMYcrnVTw7Gq/t3gEVx76EOLo4xYo9ZdknZq8ztzA3cy5L911CZuACC8ISUN2qbPn5
         xj+z2ES4fhg06BWAVSJXJI8b9YDzhD+x8G9uBEWUTekgwnfvH4sxN4ndFd9w+ughaD
         ep1FlvE9j8tafcYbwDDfhmS1igjlm1Qp5NRj8qZdnppdpHWKnNYYqcGHNTxXPvcYfv
         iHCYsQIY408mQ==
Subject: [PATCHSET v3 0/4] xfs_repair: set needsrepair when dirtying
 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Mon, 22 Feb 2021 19:01:00 -0800
Message-ID: <161404926046.425602.766097344183886137.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In the base needsrepair patchset, we set up the basics of handling the
new NEEDSREPAIR flag in xfsprogs.  This second series enables repair to
protect users against the system going down after repair begins to dirty
the filesystem but before it completes.  We start by adding a write hook
to the xfs_mount so that repair can intercept the first write to set
NEEDSREPAIR on the filesystem and the ondisk super, and finish off by
inserting error injection points into libxfs and xfs_repair so that
fstests can verify that this actually works.

v2: Improve documentation per reviewer request, fix some minor bugs,
    refactor repair's phase end function.
v3: fix some comments

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-set-needsrepair
---
 include/linux.h     |   13 +++++
 include/xfs_mount.h |    4 ++
 libxfs/init.c       |   68 +++++++++++++++++++++++++-
 libxfs/libxfs_io.h  |   19 +++++++
 libxfs/rdwr.c       |   10 +++-
 repair/globals.c    |    3 +
 repair/globals.h    |    3 +
 repair/xfs_repair.c |  132 ++++++++++++++++++++++++++++++++++++++++++++++++---
 8 files changed, 239 insertions(+), 13 deletions(-)

