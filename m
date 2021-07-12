Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FBB3C65EF
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Jul 2021 00:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhGLWKJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Jul 2021 18:10:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230376AbhGLWKJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Jul 2021 18:10:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 458EA611C1;
        Mon, 12 Jul 2021 22:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626127640;
        bh=UiHLhQjLj4ZcpAbwkngbgvlWCca6AukgPXxfdpSr93M=;
        h=Subject:From:To:Cc:Date:From;
        b=LeQCclaoorGg3D7TuziD/00F92SDoeJwY96ntQuKH6jTMLrhitCIxt2FNBlJpX4Gl
         APKWkrb2RhEUt5IhptC7xR93wpMGLGUNnu2E/cG6bhx/zfxHr+7BLt2+6i669vx/Dt
         XdMeqMU+AyMbBNknGKiRoDNCjdO5HumXR42wpY+rdUnJb1C1C30x1UYBDes3VQys6U
         Rq47IjA1cUEN243Mi333PKl8+ALxUChy5rLE20TT12TVW6q+XNgo08KepFosG0dRH8
         sVXZoBpfNIo9DH7TkzCpSoDIF+q0IQFNUoaswFFM8nHjML7KxhSfgnuPELMWoVeo6J
         oJimhxuH+yX2A==
Subject: [PATCHSET 0/2] xfs: small fixes to realtime growfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 12 Jul 2021 15:07:19 -0700
Message-ID: <162612763990.39052.10884597587360249026.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While auditing the GROWFSRT ioctl, I noticed that there are a few things
missing in the argument validation code that could lead to invalid fs
geometry.  Fix the validation and overflow errors.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=growfsrt-fixes
---
 fs/xfs/xfs_rtalloc.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

