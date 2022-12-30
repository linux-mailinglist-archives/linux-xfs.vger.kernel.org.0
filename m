Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6C465A035
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 02:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbiLaBFL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 20:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbiLaBFK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:05:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9061D1DDF0;
        Fri, 30 Dec 2022 17:05:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B9FC61BCD;
        Sat, 31 Dec 2022 01:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FB4C433EF;
        Sat, 31 Dec 2022 01:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448708;
        bh=u22oIUrmWpFAk+833/kVqXnTX1os+CRw5/50FPwKL9o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NoeTci2PlNsIB+Y1hkXjY3/+NZNO+BTJEKtGBYh3JnL34iP4C6HEGQNyBmcMiEKB9
         Z7+4AbLl66I/rw4BsPbz/EGMzNu1BL7BeEIQfLw/sO6iDg+fdEebp89SwoTnf1B1j9
         Yz3LkoJHloAWglRDe3cDezEG9yerBzg97botsMg0wZtrjFv2nei8lib7rxqWUiNkA1
         w7xl9rgaCpxQ5uGHTq7I7XfxGQZLy35NHO84dLCudBGjOO5ZdP3V682Z90UVC/vcbY
         pxAAKbKyEq83Rz+3cGJ9YqpgKsOnKDwHOufmEFI4QVWZKDdCS2/T/sy2/G997iIRsf
         g096n4jGrEFEA==
Subject: [PATCHSET v1.0 0/1] fstests: functional tests for rt quota
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:56 -0800
Message-ID: <167243885607.740668.16615332202838475736.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

The sole patch in this series sets up functional testing for quota on
the xfs realtime device.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-quotas

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-quotas

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-quotas
---
 common/quota      |   30 ++++++++++
 tests/xfs/767     |  167 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/767.out |   41 +++++++++++++
 3 files changed, 238 insertions(+)
 create mode 100755 tests/xfs/767
 create mode 100644 tests/xfs/767.out

