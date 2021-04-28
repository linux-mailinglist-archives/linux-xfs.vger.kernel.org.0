Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF6236D122
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Apr 2021 06:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbhD1EKO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Apr 2021 00:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234376AbhD1EKO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 00:10:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B180C60720;
        Wed, 28 Apr 2021 04:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619582969;
        bh=iBcpvoy8DiENV8OYu+hi0UP28nQ/LbcJ13ZrSZgK7Hg=;
        h=Subject:From:To:Cc:Date:From;
        b=udcBPx4tedYgba3pfxml4HOJiqAMAxXaE4zYHd3jO/uXGYxWmMq0Y7d7gYGgutiXL
         eIBORpwKwH3fy8KT+t4PJZtvuHUKbzjluP0FH3Vx5yNbQDHgCIzTjmdWNCAbsRBqpM
         U3ElGfVXTKYrz8523Bl12BNcribX1kcE4ppaE2BC99lIKxLJWKkUE4YgOEEhZax9aW
         /bZ2IDhaQCPu//Ic4Qf235dMpio0QyeLkHmo9qf2KwFPCkbqkKeS4PXkIXNGrCg4Kh
         SiDEJgAuVSSQN4fQ/z+8yctLP/yCS2rT2LnPUo5mm2RE1UnKYYDKNhIgyayxzhtAdU
         Vk2TvPiHcUfMw==
Subject: [PATCHSET 0/3] fstests: fix swapfile tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Apr 2021 21:09:29 -0700
Message-ID: <161958296906.3452499.12678290296714187590.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are a handful of fixes for various swapfile-related regression tests.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=swapfile-fixes
---
 common/rc         |    8 +++++--
 tests/xfs/419     |   58 -----------------------------------------------------
 tests/xfs/419.out |    5 -----
 tests/xfs/group   |    1 -
 4 files changed, 6 insertions(+), 66 deletions(-)
 delete mode 100755 tests/xfs/419
 delete mode 100644 tests/xfs/419.out

