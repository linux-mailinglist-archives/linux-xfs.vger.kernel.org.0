Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23AB34F5BD
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Mar 2021 03:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhCaBIw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Mar 2021 21:08:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232878AbhCaBIi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 21:08:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 367716190A;
        Wed, 31 Mar 2021 01:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617152918;
        bh=Oy0nE5ckJq1teOov4URT760baS7wnJ4Wxs3H0yzwL3g=;
        h=Subject:From:To:Cc:Date:From;
        b=k9Kph/IBFLoQlMsc2+U/oBqz3hfJ0e9EsD9ZPs6RbAFX4WWjUm5MU+xikHSCOde6V
         VLkSuhA6OeWvRCsk+aGUR/OVJPV+ynYP+iuDpzVo4gbZm/tIwz4TV2b1OQVUOYFAPs
         hooGlIZGFskI7jfVgmfmxQw6zXv9kme0PWodmgun940Tbechfqo0i8hdJMaRKKD43b
         xVvHq44S3S2BP4ME42s2A0cwQqZfVC+PQNJiPQVOgGvFgb9FKJ7hv5Rwg1qcSwqXI2
         Q2JTfnCu92DyCe8s7isTq4QNhuvp9UBHybYvnMceSVsfk/W4QsuD7GK48LDyzYgHPt
         Ch2pw82KJeNiw==
Subject: [PATCHSET 0/4] fstests: widen timestamps to deal with y2038+
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 30 Mar 2021 18:08:35 -0700
Message-ID: <161715291588.2703979.11541640936666929011.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series performs some refactoring of our timestamp and inode
encoding functions, then retrofits the timestamp union to handle
timestamps as a 64-bit nanosecond counter.  Next, it adds bit shifting
to the non-root dquot timer fields to boost their effective size to 34
bits.  These two changes enable correct time handling on XFS through the
year 2486.

On a current V5 filesystem, inodes timestamps are a signed 32-bit
seconds counter, with 0 being the Unix epoch.  Quota timers are an
unsigned 32-bit seconds counter, with 0 also being the Unix epoch.

This means that inode timestamps can range from:
-(2^31-1) (13 Dec 1901) through (2^31-1) (19 Jan 2038).

And quota timers can range from:
0 (1 Jan 1970) through (2^32-1) (7 Feb 2106).

With the bigtime encoding turned on, inode timestamps are an unsigned
64-bit nanoseconds counter, with 0 being the 1901 epoch.  Quota timers
are a 34-bit unsigned second counter right shifted two bits, with 0
being the Unix epoch, and capped at the maximum inode timestamp value.

This means that inode timestamps can range from:
0 (13 Dec 1901) through (2^64-1 / 1e9) (2 Jul 2486)

Quota timers could theoretically range from:
0 (1 Jan 1970) through (((2^34-1) + (2^31-1)) & ~3) (16 Jun 2582).

But with the capping in place, the quota timers maximum is:
max((2^64-1 / 1e9) - (2^31-1), (((2^34-1) + (2^31-1)) & ~3) (2 Jul 2486).

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=bigtime

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bigtime

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=bigtime
---
 common/rc             |    2 -
 common/xfs            |   32 +++++++++++
 tests/generic/721     |  123 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/721.out |    2 +
 tests/generic/722     |  125 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/722.out |    1 
 tests/generic/group   |    6 +-
 tests/xfs/122         |    1 
 tests/xfs/122.out     |    1 
 tests/xfs/908         |   97 ++++++++++++++++++++++++++++++++
 tests/xfs/908.out     |   20 +++++++
 tests/xfs/909         |  149 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/909.out     |    6 ++
 tests/xfs/911         |   44 ++++++++++++++
 tests/xfs/911.out     |   15 +++++
 tests/xfs/group       |    3 +
 16 files changed, 624 insertions(+), 3 deletions(-)
 create mode 100755 tests/generic/721
 create mode 100644 tests/generic/721.out
 create mode 100755 tests/generic/722
 create mode 100644 tests/generic/722.out
 create mode 100755 tests/xfs/908
 create mode 100644 tests/xfs/908.out
 create mode 100755 tests/xfs/909
 create mode 100644 tests/xfs/909.out
 create mode 100755 tests/xfs/911
 create mode 100644 tests/xfs/911.out

