Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F943CF126
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Jul 2021 03:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381570AbhGTAbt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 19 Jul 2021 20:31:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381211AbhGTA3x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jul 2021 20:29:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 188DF6115B;
        Tue, 20 Jul 2021 01:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626743336;
        bh=Qv/Pkid2UJbFphFljIMGBbdCZj2JHF+82EKdXuRxBRU=;
        h=Subject:From:To:Cc:Date:From;
        b=CH7TuWZk3X97Jqh1/m819DKzwdsbIzVu4MxXI2K/pUYTt8EDHx5j6uK+mUxHsEcHH
         MWN0x8xcWHcQl1aYf2ST7g7cx0ba2C/tJS71wY+PnFRN4IrAa1y2ahzvd0xeGkIl0P
         BbV7UIDuoAB9YaH3q1D9gzKLPD+T/izAPB7hAT8KXMSkOrNKcG8uQKJXWB5GQuOzwp
         caB7eKcNkQhMgq2diDot3EzXHbaiUa30Y0RxahJB5US4hAmVU9hMIyNrMP1ksQ4T+D
         YkBXs/GGOn+4sgPtmckWZkUpLUsheF8UXCjdFyRAO7c1auuztl5GKrhJ115UuYP88B
         kvfAApJhiqYqQ==
Subject: [PATCHSET 0/1] fstests: regression tests for 5.14 fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 19 Jul 2021 18:08:55 -0700
Message-ID: <162674333583.2650988.770205039530275517.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add a regression test for online shrink fixes that will appear in 5.14.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=shrink-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=shrink-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=shrink-fixes
---
 tests/xfs/778     |  190 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/778.out |    2 +
 2 files changed, 192 insertions(+)
 create mode 100755 tests/xfs/778
 create mode 100644 tests/xfs/778.out

