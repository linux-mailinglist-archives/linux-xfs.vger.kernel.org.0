Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A14399870
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Jun 2021 05:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhFCDOU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 2 Jun 2021 23:14:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhFCDOU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 23:14:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27C9461360;
        Thu,  3 Jun 2021 03:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622689956;
        bh=Qk5Q2u7ZJlwIwgD3J4Ff+4DRZJQ7tLxX8q0TLNGYeeg=;
        h=Subject:From:To:Cc:Date:From;
        b=skM+hGMKIePjvdN4D9Ula9Fb7Vw1HpWmYNZupJjd4A9gqXAto6X27/Q44Gyutikp5
         J7aoSQKsvcz5KoVb5Bw/Be+akE/12254AMaTBmhay70w6jnn5LESnYnno47CQa837y
         aontWfufpziwz6TWk/mWLH32U77azjV+gCUzhzSMOMVN9DSjFwlQDMer7Ah7Fxfb5z
         asObAzBzkoXy1aXBN9gcP6W4x5K5fV+Phrzrjhu5isH0NdCh7fvjOu4deLpV8wrVvW
         aZ6DloNel075gjthHfFkxQOoqti0ooMk5r2LXky5ZZzRTEgqu1EmyzyHls7Vyzh/kL
         rSO9k0bSaO2QA==
Subject: [PATCHSET v2 0/3] xfs: preserve inode health reports for longer
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 02 Jun 2021 20:12:35 -0700
Message-ID: <162268995567.2724138.15163777746481739089.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a quick series to make sure that inode sickness reports stick
around in memory for some amount of time.

v2: rebase to 5.13-rc4

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-inode-health-reports-5.14
---
 fs/xfs/xfs_health.c |    5 +++++
 fs/xfs/xfs_icache.c |   29 +++++++++++++++++++++--------
 2 files changed, 26 insertions(+), 8 deletions(-)

