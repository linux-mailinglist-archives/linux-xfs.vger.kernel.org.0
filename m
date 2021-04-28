Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A628536D116
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Apr 2021 06:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhD1EJM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Apr 2021 00:09:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhD1EJM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 00:09:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04FA0613ED;
        Wed, 28 Apr 2021 04:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619582908;
        bh=E5t/w9RouMJ1x9U9/4LAvFJLHySKaltObjoHjEuJvmc=;
        h=Subject:From:To:Cc:Date:From;
        b=n+ZUM4Qk0mqkA2KhoFTUKokTZ7b4mKuPWDEL5414TGwMgHg1DcaHFIsnnpU6rx0sJ
         hlpCYsh2jGTnfjeFoLWejHSBN/+Kk1hXZNWURMz5NppGF6lAfV4l2h9+KmfOu/Sxcx
         542dZVbhZEZ88JH4QM93xtVSJvQsbpnsN+YAT/VgH3fk4tptv1DNlnd5fbbsEVYu/A
         ntrCwIOsw25g93c/MKFKvVxtmmMy8gE/GENrLQ459aYq7bfVSMOmFZ2nSlHHPPupqE
         RGTwnhEFYXD34d1fpg3g6Yn48tHgODGsZ0Lf3X1tDt3nvSL2imly8ZWKD7ZXPq+SsP
         zgkr81SXspxRg==
Subject: [PATCHSET v5 0/1] fstests: widen timestamps to deal with y2038+
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Apr 2021 21:08:27 -0700
Message-ID: <161958290730.3452177.6561083366863602897.stgit@magnolia>
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

v1: Initial RFC.
v2: Expand explanations due to questions from Amir.
v3: Fix a bunch more things that Amir pointed out.
v4: Fix some review comments from Amir and Eryu.
v5: Note quota-tools v4.06 requirement and fix the quota grace expiry timer
    test not to run on old quota-tools.

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
 common/xfs        |   16 +++++
 tests/xfs/908     |  117 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/908.out |   29 ++++++++++
 tests/xfs/909     |  157 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/909.out |    6 ++
 tests/xfs/group   |    2 +
 6 files changed, 327 insertions(+)
 create mode 100755 tests/xfs/908
 create mode 100644 tests/xfs/908.out
 create mode 100755 tests/xfs/909
 create mode 100644 tests/xfs/909.out

