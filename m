Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A1B659CC6
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Dec 2022 23:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbiL3W2S (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 17:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiL3W2R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:28:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1411C90C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:28:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7781361C15
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56F6C433EF;
        Fri, 30 Dec 2022 22:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439295;
        bh=dgflBhBcktMBAPvaKEGm7q1dKAlz4XF2CRB9WD0JdZM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=spiC7Mkls7nRd/ju1W7kKFQ912g0YzzPXtXA1khE3YcsoQH/p9uAEpFZpPIrBscx9
         OZtSee/gv4+DoMSUN2nDAboqZ8Nx2ryrYbmc1lCzc9XvE31ea99xCUEUHppZzDoQvv
         4T2sBuf8cR9LxT8i+yTAOL9QBCXg57Gu7fyuDC7N6DtqV8J1sHQHpqaPxWtrGTxHBZ
         xFadJzivxsKhwPmdqpFCeYVFdzs2kFCDRvRtr+4ZRnytEsuWLmcomiZoKjOcWzYWNk
         MZZs9nPgy95tyIDEHGE1a/86cwES+JrfdAPpwFiQhYiEBru3VMuAu+7LdkvYzX7EPJ
         f2UriruhDnHOQ==
Subject: [PATCHSET v24.0 0/5] xfs: strengthen rmapbt scrubbing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:53 -0800
Message-ID: <167243831370.687445.933956691451974089.stgit@magnolia>
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

This series strengthens space allocation record cross referencing by
using AG block bitmaps to compute the difference between space used
according to the rmap records and the primary metadata, and reports
cross-referencing errors for any discrepancies.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-strengthen-rmap-checking
---
 fs/xfs/Makefile       |    2 
 fs/xfs/scrub/bitmap.c |   55 +++++++++
 fs/xfs/scrub/bitmap.h |   70 ++++++++++++
 fs/xfs/scrub/repair.h |    1 
 fs/xfs/scrub/rmap.c   |  284 +++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 410 insertions(+), 2 deletions(-)

