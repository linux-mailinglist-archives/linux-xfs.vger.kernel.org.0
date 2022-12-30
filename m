Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28FD0659CB4
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Dec 2022 23:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbiL3WYm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 17:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3WYj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:24:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB2F1D0CF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:24:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 780BF60CF0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A51C433EF;
        Fri, 30 Dec 2022 22:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439077;
        bh=wxExVhdbpxzSAlGaZQuXb4ruu2HfsoXjQ0CBQgF382s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CXe+J0jpMj0uYdbEMzBR1OMsnY439aKTb6sVywFCzJjpA7lA7eWytZKvw3QZKgePP
         1BZ0a/ltPZ1XmRNphcZIVO3aX8cONoSMRxIKiVLJW9yOBrFlEMM9Mz/k1NfVex0Zmi
         P0eyKOyDAUalye9P1k9RZ0M1RA2Povp72aa5IZvSJ3tpztCnKp5UeXoSIOgtMMKRTl
         3SstWo3bUr6o0fLkVM48GgMxOGLlJrRdPn66ix6aAt9slR17peKz+86iZHNXj4lfjz
         qWCh1HP0rItM3kMQ/plzC29g/Djrv9jqRd6QlZ+4zJlcvvz1plnQgpVVcEGEvHnDzd
         +4zrRrhCsYTdg==
Subject: [PATCHSET v24.0 0/1] xfs: pass perag references around when possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:04 -0800
Message-ID: <167243826436.683615.15521013040575221575.stgit@magnolia>
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

Avoid the cost of perag radix tree lookups by passing around active perag
references when possible.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pass-perag-refs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pass-perag-refs
---
 fs/xfs/libxfs/xfs_ag.c             |   15 +++++++++++++++
 fs/xfs/libxfs/xfs_ag.h             |    1 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |    4 +---
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    4 +---
 fs/xfs/libxfs/xfs_refcount_btree.c |    5 +----
 fs/xfs/libxfs/xfs_rmap_btree.c     |    5 +----
 fs/xfs/xfs_iunlink_item.c          |    4 +---
 fs/xfs/xfs_iwalk.c                 |    3 +--
 fs/xfs/xfs_trace.h                 |    1 +
 9 files changed, 23 insertions(+), 19 deletions(-)

