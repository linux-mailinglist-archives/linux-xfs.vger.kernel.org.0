Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EA03FD02F
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Sep 2021 02:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243021AbhIAAMu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 31 Aug 2021 20:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242976AbhIAAMk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 20:12:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F24D06103D;
        Wed,  1 Sep 2021 00:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630455105;
        bh=5Mzr3KkNCQkEBBDDNvmN4YFc9/754PodPWHeAK221N0=;
        h=Subject:From:To:Cc:Date:From;
        b=Xc6zZg80mL6NpZGP86+r/hLhlN1iLr33BaGuwcBiQ2z26UqXrV1qf8mZZhbRmwxAj
         22sVvJPGZ4hcrRL136KF9HcI6VKjuXXLQJwMyTMbhUfxnFYWznPhFmn7TsJW7pq5F6
         ICJudGqk8B7lFls3Ml7TXsz8ehIEiL6LYQekLrhhtNbdyL0vjN4eU0fT87bcvSXlkE
         CoBT2pTyREcgIRjnGVDJAegjW+76HqGABNDFmBEcnzcBxMKIbXWfjcSLahI/bP6R0o
         dESXe+6o9RMPpE9mCsXH+bNc8w0WKv8ArVkuuI9z/c8VqjXw6KLSgAcK9cse6/GWR/
         8O05AcroMwEYA==
Subject: [PATCHSET v2 0/3] fstests: exercise code refactored in 5.14
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Aug 2021 17:11:44 -0700
Message-ID: <163045510470.770026.14067376159951420121.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add new tests to exercise code that got refactored in 5.14.  The
nested shutdown test simulates the process of recovering after a VM host
filesystem goes down and the guests have to recover.

v2: fix some bugs pointed out by the maintainer, add cpu offlining stress test

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=new-tests-for-5.14
---
 common/rc             |   24 +++++++++
 tests/generic/725     |  136 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/725.out |    2 +
 tests/generic/726     |   69 +++++++++++++++++++++++++
 tests/generic/726.out |    2 +
 tests/xfs/449         |    2 -
 6 files changed, 234 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/725
 create mode 100644 tests/generic/725.out
 create mode 100755 tests/generic/726
 create mode 100644 tests/generic/726.out

