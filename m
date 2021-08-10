Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED12A3D9766
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jul 2021 23:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhG1VQX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Jul 2021 17:16:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhG1VQW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 17:16:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D20126101C;
        Wed, 28 Jul 2021 21:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627506980;
        bh=zWspoGNAjXNxQ31abDnmunlP9LUtOfiatV2d5eQv4+k=;
        h=Subject:From:To:Cc:Date:From;
        b=GyHkEMZpkd9UDFvIddQcerYz6f7S8uFAMdrZzKJi5o1UymYztKA8+lYckpSuqb3Fc
         Xi3/k56liHgvj6b5kxOnw/29E1IdhsZaQQuKNU8IPmXjSz7C3eMDRjf/QzCLpfc7qL
         qFIAaUKYJTnau7L2ATouddeC09iZy5CSMTy2Eq0o2YlUUUT1DOo7qgMzUy4kcRAGxH
         Z7wTB+R6p0CQ4ukR2GEtn1FvaeVNsFFVKauzeCHkkxYeu4SLS/IeBewf3Ywg66RiPF
         5eB+FasitiXWCXZt56/RkexaQLYeQLrSj4dInEQ2NCG1AZa2fDatL/Lw90vPiseOb8
         jPh+4NjBtLtiw==
Subject: [PATCHSET 0/2] xfsprogs: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 28 Jul 2021 14:16:20 -0700
Message-ID: <162750698055.45897.6106668678411666392.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are a couple more random fixes.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 quota/state.c   |    3 ++-
 repair/phase6.c |   18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

