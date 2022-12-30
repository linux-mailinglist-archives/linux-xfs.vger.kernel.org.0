Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890F0659DCD
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 00:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbiL3XIf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 18:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235644AbiL3XIe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:08:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369D35FFD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:08:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDB5DB81D67
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05A1C433EF;
        Fri, 30 Dec 2022 23:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441711;
        bh=qZGNUK/bHdOv+D9Cls8s5MTHz5vVTthe+tw8/pgpMnA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uwdAkC6OLLmhgBZRhy5ZCKwcaZfMTabNSDdhthBXHCJOG+SYYSf7lZCxz1qeQNqNm
         OnknS5w9gNZ1xqL55G/0ZKhJHhchEDRQCNBl1lV/zp7rPH29yThfh/SxQPaKHp1ohm
         k7xfZrs07Q60wNlvol5FpbZ79Zs+0NXoHPVBUMmYUYwvBcH0HXiQKCA1RS+HJ0d9hl
         Jqww4DfW9GLBlO3+RT2BvV8Z60YBRkkPXWqoQMjrsCz3nE5jCW4tFzlMqMZSyB942Q
         c9Q/qV96T86ToKW9ypzsShHQoINuj4BP4icgzTva+tFXha1MmUbFjCXTs48RdFSnQu
         SUKrIyFxOp+uA==
Subject: [PATCHSET v24.0 0/4] xfs: online fsck of iunlink buckets
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:29 -0800
Message-ID: <167243846905.701054.601680294547998738.stgit@magnolia>
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

This series enhances the AGI scrub code to check the unlinked inode
bucket lists for errors, and fixes them if necessary.  Now that iunlink
pointer updates are virtual log items, we can batch updates pretty
efficiently in the logging code.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-iunlink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-iunlink
---
 fs/xfs/scrub/agheader.c        |   40 +++
 fs/xfs/scrub/agheader_repair.c |  576 +++++++++++++++++++++++++++++++++++++---
 fs/xfs/scrub/trace.h           |  128 +++++++++
 fs/xfs/xfs_icache.c            |    2 
 fs/xfs/xfs_inode.c             |    5 
 fs/xfs/xfs_inode.h             |   11 +
 6 files changed, 712 insertions(+), 50 deletions(-)

