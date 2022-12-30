Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422C965A00F
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 01:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbiLaAzv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 19:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235815AbiLaAzu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:55:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3FACF3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:55:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16E6361D5B
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73764C433D2;
        Sat, 31 Dec 2022 00:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448148;
        bh=NU1jqoDUKyW2hgjaKWLOqlRzoqTU+l/Cbp3CEEmHUtk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JqegUbiZSRs0YbIr21g2pGDHzFlfKEjy4nDsI59uvC72vPq8eEeVWgVuZ4tac7Qqt
         JZsWn1vccqGr8oV8h+ZmxxlI3cYq3oi/qeDuiEfJPYwY0GPrM77IZqOl0NqrUtEFSx
         6oxNlAH+s8YkhO9i/LVFqkogYpKMn8uu6iP1TX613FgSbnF29/Nn1szXehJNNIatrh
         fOBwrgA9Pe+aSgam0W/Hidj5NlPlivZKMO1FVJypG3YN8ehEJ+2Es586zl458PdrzP
         iEREDHg0IW4oFDPxKnonejG+ibCBQVlrqElKPJyjWjMktuyFm/b41+7SR3gL4jyTdS
         2KyVJsoV7XwVg==
Subject: [PATCHSET v1.0 00/11] xfs: clean up realtime type usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:36 -0800
Message-ID: <167243865605.709511.15650588946095003543.stgit@magnolia>
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

The realtime code uses xfs_rtblock_t and xfs_fsblock_t in a lot of
places, and it's very confusing.  Clean up all the type usage so that an
xfs_rtblock_t is always a block within the realtime volume, an
xfs_fileoff_t is always a file offset within a realtime metadata file,
and an xfs_rtxnumber_t is always a rt extent within the realtime volume.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=clean-up-realtime-units

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=clean-up-realtime-units
---
 fs/xfs/libxfs/xfs_bmap.c     |    4 -
 fs/xfs/libxfs/xfs_format.h   |    2 
 fs/xfs/libxfs/xfs_rtbitmap.c |  121 ++++++++++-----------
 fs/xfs/libxfs/xfs_rtbitmap.h |   79 ++++++++++++++
 fs/xfs/libxfs/xfs_sb.h       |    2 
 fs/xfs/libxfs/xfs_types.c    |    4 -
 fs/xfs/libxfs/xfs_types.h    |    8 +
 fs/xfs/scrub/bmap.c          |    4 +
 fs/xfs/scrub/common.c        |   58 ++++++++++
 fs/xfs/scrub/common.h        |   17 +++
 fs/xfs/scrub/fscounters.c    |    2 
 fs/xfs/scrub/rtbitmap.c      |   23 ++--
 fs/xfs/scrub/rtsummary.c     |   30 ++---
 fs/xfs/scrub/scrub.c         |    1 
 fs/xfs/scrub/scrub.h         |    9 ++
 fs/xfs/scrub/trace.h         |    7 +
 fs/xfs/xfs_bmap_item.c       |    2 
 fs/xfs/xfs_bmap_util.c       |   18 +--
 fs/xfs/xfs_fsmap.c           |    2 
 fs/xfs/xfs_rtalloc.c         |  245 ++++++++++++++++++++++--------------------
 fs/xfs/xfs_rtalloc.h         |   99 ++---------------
 21 files changed, 417 insertions(+), 320 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtbitmap.h

