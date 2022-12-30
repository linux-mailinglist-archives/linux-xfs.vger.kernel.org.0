Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C78C659DEF
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 00:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbiL3XQ2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 18:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbiL3XQZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:16:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2576C95B0;
        Fri, 30 Dec 2022 15:16:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6B4461C3A;
        Fri, 30 Dec 2022 23:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE75C433D2;
        Fri, 30 Dec 2022 23:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442183;
        bh=zBnHFdZ/5bpxk9LsMkIk4K0AxtYw7XjH3W407tp5gf4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lJhUY9ClocgInXcWs8P6OGIE2jojFGA31rFK3exk7Cv2TLeE7XfNR4V/6gm8uzVdl
         rwrCwVJS+3LYOe4qitXD0MmwM6wCodpW55wSZ54HQsc1R8pWS6fjxFIkevc9hBobGu
         Qx8jdqYvZ7S7VXeWRDTfOYYip/FuUtbIRvZA29UqttbOhV7ReSPrRzBf1Az4uFlDD9
         0S2Y2hthaDoe5Tnq3zOEvM0OfqJV+XSIDgjC/eFgxMuBwrvhUqgVOT/+XJnVNZZZxA
         UjpMLLOJq0vg4qWjIh15eVHgjuglShc/wP4zjplDZcGcqlnaQ3FteM26qzyv8iAmg6
         SbWLjpAsoMwig==
Subject: [PATCHSET v24.0 0/1] fstests: online repair of inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:15 -0800
Message-ID: <167243875538.724875.4064833218427202716.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
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

In this series, online repair gains the ability to repair inode records.
To do this, we must repair the ondisk inode and fork information enough
to pass the iget verifiers and hence make the inode igettable again.
Once that's done, we can perform higher level repairs on the incore
inode.  The fstests counterpart of this patchset implements stress
testing of repair.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-inodes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-inodes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-inodes
---
 tests/xfs/806     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/806.out |    2 ++
 2 files changed, 40 insertions(+)
 create mode 100755 tests/xfs/806
 create mode 100644 tests/xfs/806.out

