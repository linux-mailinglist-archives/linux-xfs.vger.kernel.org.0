Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF707C5ABB
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Oct 2023 20:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbjJKSBu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Oct 2023 14:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbjJKSBt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:01:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D168C94
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:01:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73633C433C9;
        Wed, 11 Oct 2023 18:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697047308;
        bh=vKvX8EZHeHwyRkj3CNhM9WuQze178n9qSNmSnDWVZWI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=CX5DuqQ6hI/e3sS4NDsg1Ggflw8FRA8jj8Qk009Y4Oq75bVhlY6oMzVuscnZSkmFr
         hrr32ztsuJhZa2Plk1QDOIrnTTVl37seTJohwTL8MH4jG0MTnI3eqgbNuTJn2kUuzn
         nGc+UKVMGLoRBjU6fvvQDCWJgfJyeaDXVPtIIlsUSWtTd3n8ruBcUH1BNvsBrGleeS
         BkICILyMutl3gmLI2HsAdNe3eTlUlicvZEbM+grTwRwvVkdbb1+Is7XUFfvQnTz3hD
         1XI6yIJ4ifAGF6PCUXuovyC5GZh8sX1mLN2xbIxx6PqiaybrGVdf86hUc2IO629LeC
         08vwLXHEL7ALQ==
Date:   Wed, 11 Oct 2023 11:01:47 -0700
Subject: [PATCHSET RFC v1.0 0/8] xfs: refactor rtbitmap/summary macros
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Message-ID: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
In-Reply-To: <20231011175711.GM21298@frogsfrogsfrogs>
References: <20231011175711.GM21298@frogsfrogsfrogs>
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

In preparation for adding block headers and enforcing endian order in
rtbitmap and rtsummary blocks, replace open-coded geometry computations
and fugly macros with proper helper functions that can be typechecked.
Soon we'll be needing to add more complex logic to the helpers.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-rtbitmap-macros

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=refactor-rtbitmap-macros
---
 fs/xfs/libxfs/xfs_format.h      |   32 ++---
 fs/xfs/libxfs/xfs_rtbitmap.c    |  268 ++++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_rtbitmap.h    |  133 +++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.c  |    9 +
 fs/xfs/libxfs/xfs_types.h       |    2 
 fs/xfs/scrub/rtsummary.c        |   50 ++++---
 fs/xfs/scrub/rtsummary.h        |    6 -
 fs/xfs/scrub/rtsummary_repair.c |    7 +
 fs/xfs/scrub/trace.c            |    1 
 fs/xfs/scrub/trace.h            |    4 -
 fs/xfs/xfs_ondisk.h             |    4 +
 fs/xfs/xfs_rtalloc.c            |   39 +++---
 12 files changed, 408 insertions(+), 147 deletions(-)

