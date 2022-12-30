Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4745659CB2
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Dec 2022 23:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbiL3WYK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 17:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3WYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:24:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34ACA1D0CF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:24:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0319B81D94
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889B0C433EF;
        Fri, 30 Dec 2022 22:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439046;
        bh=NgquzUB5QRy61I5wzZEqIRloZBsuJogSbGdvs/oNcRI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Lg0w10XnKap9UGT9fO78cZDD33IM+iQYqkG5dtY8JAYsViqM0xxRzPJ032P4dpQgQ
         KKXH9XlID3F75sjYz0zhcSQWDwxtC6Fo/3dsES1lJuJGn0TcLHvC/mOIxJhmExlAqc
         GFYHmZ5dgpmaENFFaumvM0OWmqUo8x+cruM24biN2Gujea0an+XTYHoJ9pLMx4CSPi
         82JrKbmzvki+v7E4lkffTEaKx9ullHLbS4CYg/2Zq2xL4qpi6boN+zaILnFXLvcMDJ
         /TZYoTyjcqp/TL1yl/sTqUx3wWhd3hOww6eYVUk+36e9ukyg0gcFzMzw/AGBilY9S/
         lYe+iuyL9a+Uw==
Subject: [PATCHSET v24.0 0/8] xfs: variable and naming cleanups for intent
 items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:10:56 -0800
Message-ID: <167243825653.683219.11053689306747459204.stgit@magnolia>
In-Reply-To: <Y69UceeA2MEpjMJ8@magnolia>
References: <Y69UceeA2MEpjMJ8@magnolia>
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

Before we start changing how the deferred intent items work, let us
first cut down on the repeated boxing and unboxing of intent item
parameters, and tidy up the variable naming to be consistent between
types.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=intents-naming-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=intents-naming-cleanups
---
 fs/xfs/libxfs/xfs_alloc.c    |   32 +++++----
 fs/xfs/libxfs/xfs_bmap.c     |   32 ++++-----
 fs/xfs/libxfs/xfs_bmap.h     |    5 -
 fs/xfs/libxfs/xfs_refcount.c |   96 +++++++++++++---------------
 fs/xfs/libxfs/xfs_refcount.h |    4 -
 fs/xfs/libxfs/xfs_rmap.c     |   52 +++++++--------
 fs/xfs/libxfs/xfs_rmap.h     |    6 +-
 fs/xfs/xfs_bmap_item.c       |  137 +++++++++++++++++------------------------
 fs/xfs/xfs_extfree_item.c    |   99 +++++++++++++++--------------
 fs/xfs/xfs_refcount_item.c   |  110 +++++++++++++++------------------
 fs/xfs/xfs_rmap_item.c       |  142 ++++++++++++++++++++----------------------
 fs/xfs/xfs_trace.h           |   15 +---
 12 files changed, 335 insertions(+), 395 deletions(-)

