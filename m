Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA87765F32
	for <lists+linux-xfs@lfdr.de>; Fri, 28 Jul 2023 00:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjG0WTi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Jul 2023 18:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjG0WTh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:19:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FD42D68
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:19:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FF0761F57
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAA5C433C8;
        Thu, 27 Jul 2023 22:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496375;
        bh=6sGq6D2gHzUQ4s1uMD1uiqhGeQr/cI4N3KfwCooM0i4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=p0f8phywVU5qRmCOwMikfWwIoXk4qZ97QfJX4FS9BZmwwgJOrvmT3Xrlf9jzUI92f
         lRbX4/y7gAa9oxyxQjzxvZ8ueF/RNfKcr7ljTC/lGxBfWbnUSibKPeYdMTlUUonXH5
         oOSjOCkH4+qhen//vnoB8Jc/eouosuDK4II/fspHr+JMPEsitk1nRGaZzpPZ0lAT+j
         OuS7OFqL39pHGkPGTMvC6pUxYnf/LaJdV/+1+C6+YTAnVNgd9h4HnsXQfbOFAAcfE6
         s7Jq61SxcuLVjSab+HDP+jqMesEPFqliMmV0skaBrPVfFrAdUj6B7IOh4QZn2jTp3A
         hL2ZgzXpTbPJA==
Date:   Thu, 27 Jul 2023 15:19:34 -0700
Subject: [PATCHSET v26.0 0/4] xfs: online scrubbing of realtime summary files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <169049624299.921804.11447029742535329810.stgit@frogsfrogsfrogs>
In-Reply-To: <20230727221158.GE11352@frogsfrogsfrogs>
References: <20230727221158.GE11352@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset implements an online checker for the realtime summary
file.  The first few changes are some general cleanups -- scrub should
get its own references to all inodes, and we also wrap the inode lock
functions so that we can standardize unlocking and releasing inodes that
are the focus of a scrub.

With that out of the way, we move on to constructing a shadow copy of
the rtsummary information from the rtbitmap, and compare the new copy
against the ondisk copy.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-rtsummary

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-rtsummary
---
 fs/xfs/Makefile          |    7 +
 fs/xfs/scrub/bmap.c      |    9 +-
 fs/xfs/scrub/common.c    |   63 +++++++++--
 fs/xfs/scrub/common.h    |   24 ++++
 fs/xfs/scrub/inode.c     |   11 +-
 fs/xfs/scrub/parent.c    |    4 -
 fs/xfs/scrub/quota.c     |   15 +--
 fs/xfs/scrub/rtbitmap.c  |   48 +-------
 fs/xfs/scrub/rtsummary.c |  264 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c     |   17 ++-
 fs/xfs/scrub/scrub.h     |    4 +
 fs/xfs/scrub/trace.h     |   34 ++++++
 fs/xfs/xfs_trace.h       |    3 +
 13 files changed, 421 insertions(+), 82 deletions(-)
 create mode 100644 fs/xfs/scrub/rtsummary.c

