Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD144699DB2
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Feb 2023 21:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjBPU3V (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Feb 2023 15:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjBPU3U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:29:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D35B196A9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:29:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0C11B829A7
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931DAC433D2;
        Thu, 16 Feb 2023 20:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579357;
        bh=OUc6tjdvSqKYzHpUvC7B8FXnmZLEMcmeK0fdE1+Kvdk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Sz7SpUituqDlMgc791bDtW4/UOXPHL6UPqZ6ix3gRJ3fKGAer5FzShO/AXCSJ0fhj
         xUm9mlTizvA9z2BsmXjxGmpX6Ury+EUJHT7T91CGnloDMhD9IcdnopQK4S0GrBvSy/
         uO/uZXsFoFyfcBTIRts6jZY+pBxrEkVrZgGzYMR57os9zc9QM3BoLl+V0QtQn9P49X
         sVryUfGtNNoCQSWBoZnU3c/4YccvlPyWdOaaCm70LMl6WKgUJBT6bpc0uu+yVkxJn9
         dDTW0cCczEh6bjUE6cFv3XMAPynYXeo8iFVAQF4kOnbe8YKMZ7UaqoqNAJtwS8RVko
         B7hQJ78ObQ4Nw==
Date:   Thu, 16 Feb 2023 12:29:16 -0800
Subject: [PATCHSET v9r2d1 0/6] xfsprogs: bug fixes before parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879533.3476725.4672667573997149436.stgit@magnolia>
In-Reply-To: <Y+6MxEgswrJMUNOI@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
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

This series contains the accumulated bug fixes from Darrick to make
fstests pass and online repair work.  None of these are bug fixes for
parent pointers itself.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-bugfixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-bugfixes
---
 include/libxfs.h        |    1 +
 libxfs/init.c           |    3 ++
 libxfs/xfs_attr.c       |   61 +++++++---------------------------
 libxfs/xfs_attr.h       |    7 ++--
 libxfs/xfs_attr_leaf.c  |    6 ++-
 libxfs/xfs_attr_sf.h    |    1 +
 libxfs/xfs_dir2_block.c |    2 +
 libxfs/xfs_dir2_leaf.c  |    2 +
 libxfs/xfs_dir2_node.c  |    2 +
 libxfs/xfs_dir2_sf.c    |    4 ++
 libxfs/xfs_parent.c     |   84 +++++++++++++++++++++++++++++++++++++++++------
 libxfs/xfs_parent.h     |   28 +++++++++++++++-
 12 files changed, 136 insertions(+), 65 deletions(-)

