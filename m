Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEEE7ADBA6
	for <lists+linux-xfs@lfdr.de>; Mon, 25 Sep 2023 17:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjIYPiM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 25 Sep 2023 11:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjIYPiL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 11:38:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9948A90
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 08:38:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174D2C433C7;
        Mon, 25 Sep 2023 15:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695656285;
        bh=8VtkmPnQlDWANyTfzJCiHnmPXqfHONscO79MneZ9/Fc=;
        h=Subject:From:To:Cc:Date:From;
        b=Z31WWS2uSvZHZwOzWY76QP9Tf9ldI9TS+tOQPe4AMbnQh7e/urxmvOGXTx5k17DcT
         cCObiIM5zYcR8HhWkQNgipEbnjDXjyx9NCgoUMUVlHZKHZ8ossPomLkSKrm+PtTSST
         TUjle89nLU/HKnpe2awcfrvKqWH6FXb/O5SZGsOqg1gTv/79RDxvRupr2joxOu4Evu
         NytMQBVLP1h46l+idnNKq2WWDlrph4b8CD7j64Aie90qdxg7DOXkRgF4kKJwSIuYjV
         Tyn/jwCbAl3dNYTqMZUj9cCkXp7jOo2T4csrh77vNvFvNcJKsDwTe7uMd8qros2v8u
         Te/Uy6QfOdxmw==
Subject: [PATCHSET 0/1] xfs: fix reloading the last iunlink item
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandanbabu@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Date:   Mon, 25 Sep 2023 08:38:04 -0700
Message-ID: <169565628450.1982077.8839912830345775826.stgit@frogsfrogsfrogs>
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

It's not a good idea to be trying to send bug fixes to the mailing list
while also trying to take a vacation.  Dave sent some review comments
about the iunlink reloading patches, I changed them in djwong-dev, and
forgot to backport those changes to my -fixes tree.

As a result, the patch is missing some important pieces.  Perhaps
manually copying code diffs between email and two separate git trees
is archaic and stupid^W^W^W^Wisn't really a good idea?

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-fix-iunlink-6.6
---
 fs/xfs/xfs_export.c |   16 ++++++++++++----
 fs/xfs/xfs_inode.c  |   48 +++++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_itable.c |    2 ++
 fs/xfs/xfs_qm.c     |   15 ++++++++++++---
 4 files changed, 61 insertions(+), 20 deletions(-)

