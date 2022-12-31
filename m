Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DDD65A02A
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 02:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbiLaBCT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 20:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiLaBCT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:02:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800A41DDF0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:02:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DB1A61D68
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A5EC433EF;
        Sat, 31 Dec 2022 01:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448537;
        bh=gy7qH/jr7tSAEu0Uupp3wxZfA/M5GQye0MP5DD3QzO0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MS0BTPw1gAUbpLNgbBi90um8FSLGlyzP0fnN4yy43DAu5ww+UBjnC0mkF2YxLF2hJ
         sJoqRxEP80wtToPlgsZS5uhXSKU7IMqR/iBr9DlmSu9IiX3VlCKjYQ2U2SRR/IIQUO
         bvgpBYu3a8Vuh8LeweeNPllx78GNbPeaq93VGUMRAmTmqwUCmRqa0tfPJnLoOPtiLv
         SkKwybah3Ab9ZsPo2eDwFsxijyAo92JwLPiLoJP+wIUlT4FD09WAYJK00VxRodpQqd
         eMrq6xemaS2zLYD/q8ho+O0k43JdDZnlK3w+za4k8A6j2oPZp0e8lI4dfYlE9AVj8s
         dBKL7ubNB8hsw==
Subject: [PATCHSET v1.0 0/4] libxfs: file write utility refactoring
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:04 -0800
Message-ID: <167243880399.733953.2483387870694006201.stgit@magnolia>
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

Refactor the parts of mkfs and xfs_repair that open-code the process of
mapping disk space into files and writing data into them.  This will help
primarily with resetting of the realtime metadata, but is also used for
protofiles.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bmap-utils
---
 include/libxfs.h |    6 ++-
 libxfs/util.c    |  109 ++++++++++++++++++++++++++++++++++++++++---------
 mkfs/proto.c     |  120 ++++++++++--------------------------------------------
 repair/phase6.c  |   74 +++++----------------------------
 4 files changed, 125 insertions(+), 184 deletions(-)

