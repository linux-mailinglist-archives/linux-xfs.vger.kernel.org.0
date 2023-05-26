Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB94711B5D
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 02:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbjEZAhe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 20:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbjEZAhd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:37:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88972195
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:37:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CAC061B68
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFF5C433EF;
        Fri, 26 May 2023 00:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061451;
        bh=NCQcXmAjfMZQ6YRqDD2g7CiMqLsxU8PGZecntAsGgUQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Yu509nsGwpiZbH8iuKqjLi8spxor596d+79YzMpr82L6HztEGHDDhWvqpTMNTpiy/
         sxiSbYBPp0vZQwtOi7UnIkDob4qzX+KaESqhxOopo1H8aplPZSyKzQx3huXgMYgaiI
         5u+CNKGuTGJQg9KC1YaKL5CjapD5HibQsC+sl7UAvQHKViXt5tuh3yRe/+yUuXhHSf
         SfI5QGzpJUod1mNcqV1WY3qM+/roV8DTvhYwFnPWrPduKY+SoxS0QMPRvomySPQtWC
         83ynOPagWxMSzHKoSnVEcyEgA9kM101vdVHCD839PCrFWayPH/wp3G+GR2QRR5iEPt
         6p8xZscm+s7GQ==
Date:   Thu, 25 May 2023 17:37:31 -0700
Subject: [PATCHSET v25.0 0/3] xfs: inode-related repair fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506069368.3738323.11092090063491926432.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While doing QA of the online fsck code, I made a few observations:
First, nobody was checking that the di_onlink field is actually zero;
Second, that allocating a temporary file for repairs can fail (and
thus bring down the entire fs) if the inode cluster is corrupt; and
Third, that file link counts do not pin at ~0U to prevent integer
overflows.

This scattered patchset fixes those three problems.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=inode-repair-improvements

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=inode-repair-improvements
---
 fs/xfs/libxfs/xfs_format.h    |    6 ++++++
 fs/xfs/libxfs/xfs_ialloc.c    |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_buf.c |    8 ++++++++
 fs/xfs/scrub/inode_repair.c   |   11 +++++++++++
 fs/xfs/scrub/nlinks.c         |    8 ++++----
 fs/xfs/scrub/repair.c         |   12 ++++++------
 fs/xfs/xfs_inode.c            |   16 ++++++++++++----
 7 files changed, 87 insertions(+), 14 deletions(-)

