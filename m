Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06883017DC
	for <lists+linux-xfs@lfdr.de>; Sat, 23 Jan 2021 19:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbhAWSxu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 23 Jan 2021 13:53:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:35622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbhAWSxn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:53:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FC55230FC;
        Sat, 23 Jan 2021 18:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611427981;
        bh=HOzr9CGOWABANpGhJJOeYoSsS3TD5zuvLFcPw8G4o1k=;
        h=Subject:From:To:Cc:Date:From;
        b=Ey1iM8MWQdqM6Y87sJRzFDA4dYzl1bAzYmqY5yROROMNgUF0BGGQ8stVXTnoCo0Vh
         oNCXl8fap+KOiXpniaNoQKUCBp8kd+d2/hGaHvbs3oHOkxh62nBXWjKfHvmqIIuUzT
         J4vCkwPIrf/P5XN2u04oMrYK8o3RWEwo4YR+/UwXunxNr+MQGBhJs3fGcs2MEcPqNb
         houjmyEnfG2oDYx8P3kkUWxrwR7iWIbyE/nSilJWs1bio2lD01d+lDfOxuRTCLPNjO
         86bsrPk73wUC2h9udIwyotJY8TN1ilfs5Ri2SGk95tRlU0pxk2XiEXnL2g8OdMr7Ta
         oaA3TQ2MEjQFw==
Subject: [PATCHSET 0/3] xfs: speed up parallel workqueues
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:53:02 -0800
Message-ID: <161142798284.2173328.11591192629841647898.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

After some discussion on IRC with Dave, we came to the conclusion that
our background workqueue behavior could use some tweaking.  Kernel
worker threads that scan the filesystem and/or run their own
transactions more closely fit the definition of an unbound workqueue --
the work items can take a long time, they don't have much in common with
the submitter thread, the submitter isn't waiting hotly for a response,
and we the process scheduler should deal with scheduling them.
Furthermore, we don't want to place artificial limits on workqueue
scaling because that can leave unused capacity while we're blocking
(pwork is currently used for mount time quotacheck).

Therefore, we switch pwork to use an unbound workqueue, and now we let
the workqueue code figure out the relevant concurrency.

The final tweak is to enable WQ_SYSFS on all workqueues so that we can
monitor their concurrency management (or lack thereof) via sysfs.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=workqueue-speedups-5.12
---
 fs/xfs/xfs_iwalk.c     |    5 +----
 fs/xfs/xfs_log.c       |    4 ++--
 fs/xfs/xfs_mru_cache.c |    2 +-
 fs/xfs/xfs_pwork.c     |   21 ++-------------------
 fs/xfs/xfs_pwork.h     |    1 -
 fs/xfs/xfs_super.c     |   23 ++++++++++++++---------
 6 files changed, 20 insertions(+), 36 deletions(-)

