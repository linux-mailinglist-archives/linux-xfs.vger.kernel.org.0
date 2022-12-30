Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B2265A01A
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 01:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235694AbiLaA6n (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 19:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiLaA6m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:58:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B76B1C913
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:58:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED8A6B81E06
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B053EC433EF;
        Sat, 31 Dec 2022 00:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448319;
        bh=o6N0bnuKwI/6Rh4LN2ySXESVUZqMux/AhSvPZ9m3rzA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FQBz2DowEv9419Va+Q4GP3sk0IKnpaKY9pEaLlJckeZuDjero4f2Qa/mCsZINekYl
         wQzDL4hH/zilsFfqfcHdN+SPNorG1ATZeJUoVWvu7he8Q58jIamqSqXyMHLTDW8pog
         ZFu24T6Ncl8701t4ttOyxRjOdwU7lek6DUAeZgfea35KpPGPOWzq1NCRmbCZvAV2KM
         WX/sl0JJP00ZfIpnBqrOlpN68ZraVO2HhdQYisDG8/Lj7/94eEI7WusavMhD3A7B8q
         XZSuVUBtkJINvG7rH53E8klej+YIgXaWGdfgOdExLirEDP3lHBvhjj+fbfor+ZNjv4
         1X+hQYknVnnJA==
Subject: [PATCHSET v1.0 0/5] xfs: refcount log intent cleanups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:24 -0800
Message-ID: <167243870440.716629.17983217257958002785.stgit@magnolia>
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

This series cleans up the refcount intent code before we start adding
support for realtime devices.  Similar to previous intent cleanup
patchsets, we start transforming the tracepoints so that the data
extraction are done inside the tracepoint code, and then we start
passing the intent itself to the _finish_one function.  This reduces the
boxing and unboxing of parameters.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refcount-intent-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=refcount-intent-cleanups
---
 fs/xfs/libxfs/xfs_refcount.c |  122 ++++++++--------------
 fs/xfs/libxfs/xfs_refcount.h |    6 +
 fs/xfs/xfs_refcount_item.c   |   32 ++----
 fs/xfs/xfs_trace.c           |    1 
 fs/xfs/xfs_trace.h           |  229 ++++++++++++++++++++----------------------
 5 files changed, 169 insertions(+), 221 deletions(-)

