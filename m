Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC6937F0B8
	for <lists+linux-xfs@lfdr.de>; Thu, 13 May 2021 03:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhEMBCj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 May 2021 21:02:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232632AbhEMBCh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 May 2021 21:02:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7F2961108;
        Thu, 13 May 2021 01:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620867689;
        bh=/90MyX3UNFokb/2nwHL3rSTE2l/H5g94uqVxChvorKU=;
        h=Subject:From:To:Cc:Date:From;
        b=MN2SzI+4JSSzQ9rpCNDgQ7sK5PUPVjbrjeQuZqoMAOZsRZ4B9eLXpuhZUK22ekjCf
         U8leCB+xcB777RxKZ55lAe/K7qNK6q5dv8Cyq5vtYUf1kqGYKghXdo7ZQ8Kb2sMDoJ
         W+EJ6d4fxBu31Sd+kSDm5pzw80IKx1whxO+Use2eR8/zU3e+v4xr2oTFcy8WVCQBY7
         fwhY3Kgkz1dNmLYqZTRyEg1NvaAMQmK/8MHQPitNU7bV6D4HgpmJuR8W9kZzspQleE
         VcFsXMlCZCzx/kU99c21KdwpGbTEpGgtZOE9pk1gfqmcgopoJTZNlXsZBBJqaNw9+F
         uLUX2/PYWVDGQ==
Subject: [PATCHSET 0/2] xfs: random pending stuff for 5.13
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 12 May 2021 18:01:28 -0700
Message-ID: <162086768823.3685697.11936501771461638870.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

A couple of assorted fixes for crashers and uapi regressions.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes-5.13

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes-5.13
---
 fs/xfs/libxfs/xfs_fs.h |    4 ++++
 fs/xfs/scrub/common.c  |    4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

