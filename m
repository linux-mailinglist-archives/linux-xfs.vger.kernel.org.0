Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8786A699DAD
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Feb 2023 21:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBPU2E (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Feb 2023 15:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjBPU2E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:28:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C753A876
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:28:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EC254CE24A9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7E8C433D2;
        Thu, 16 Feb 2023 20:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579279;
        bh=dM6+900KuTlcnqX2CVePuzlnNYYOhqPDY9FSISVIsuw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=d1t7954OHVcrBFN5mJ14QGOpu+k2fzr75JzA0jumQ6YNVBLmEQ/kUJkF8rJxtfojf
         vW6IZmDhI/ZwmqxbhV85YYthE6gjIb0vhqpxZqkTOyurZ1kMM9T/LJ6Vf+jmRTdhjl
         788Xw82kjy7w327YoMo6Uu4LSmcOeD7OJLdhwLBFX3DzjnkPeQsWegD2fQ45KhKv5x
         ZckWnhLiG41qkLXsm8O1R/4U32doCildBRFZB0MeCnrecFsVs+kGnD+9wIhiyRjspt
         +INBLbKjN5XJIyoKb4BR6lMp0fgRVVj5o+WJtPuoVQRsACloPSk+CBny3ux2ppT20s
         Q3o88j0pZ5HEg==
Date:   Thu, 16 Feb 2023 12:27:58 -0800
Subject: [PATCHSET v9r2d1 0/3] xfs: online checking of parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657875195.3475204.16384027586557102765.stgit@magnolia>
In-Reply-To: <Y+6MxEgswrJMUNOI@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

With this patchset, we implement online repairs for parent pointers.
This is structured similarly to the directory repair code in that we
scan the entire filesystem looking for dirents and use them to
reconstruct the parent pointer information.

Note that the atomic swapext and block reaping code is NOT ported for
this PoC, so we do not commit any repairs.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-parent-repair

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-online-parent-repair
---
 fs/xfs/Makefile              |    1 
 fs/xfs/libxfs/xfs_parent.c   |   56 +++
 fs/xfs/libxfs/xfs_parent.h   |    8 
 fs/xfs/scrub/parent.c        |   10 +
 fs/xfs/scrub/parent_repair.c |  739 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h        |    4 
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/trace.c         |    2 
 fs/xfs/scrub/trace.h         |   80 +++++
 fs/xfs/xfs_inode.h           |    6 
 10 files changed, 905 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/parent_repair.c

