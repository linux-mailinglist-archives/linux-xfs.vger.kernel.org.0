Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580996BD8C1
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Mar 2023 20:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjCPTR6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Mar 2023 15:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjCPTR4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:17:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350D2B53F8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:17:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD468B82290
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C2DC433A8;
        Thu, 16 Mar 2023 19:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994271;
        bh=RaylY5X10T117LCAWSLxahk2Nte+YXAUhv07PBI6v+A=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Kmz6zINTcb5DicFyfGLERLGuRoaCCqEStKXYJXAgKfYff463S9mgDmdtedpIHy6As
         zaD0AdY+eMGfeStAB8PHmZhwjYMMHNvUwxLNaEMBPNyWMpQpwLbO9ZT7VRKtPnDzYq
         qLvBWupA7VFfQFGruuCNVZSWZb4Gi38l6KMegum8/C+KdNX1dMc7wzp1SBsakgnlDi
         0dC5nRI3YD84dEzogT/8yZgnJ0jVyqLx69VyXMPXqwDmLaNcStC00fnvj30ixXXN3W
         7hRuilAvWQLcz2FY1g1T4jObbBP5kQi7u/AOAjflV0iSX3+UHAqgJUI4X8C47kGV75
         Do6JgfKCBRSZA==
Date:   Thu, 16 Mar 2023 12:17:51 -0700
Subject: [PATCHSET v10r1d2 0/9] xfsprogs: tool fixes for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899415375.16278.9528475200288521209.stgit@frogsfrogsfrogs>
In-Reply-To: <20230316185414.GH11394@frogsfrogsfrogs>
References: <20230316185414.GH11394@frogsfrogsfrogs>
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

Here are a bunch of tooling changes for the parent pointers code.  The
only new feature here is to decode the parent pointer xattr name in
xfs_db so that we can interpret (and someday fuzz) them.  Everything
else are bug fixes.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-toolfixes
---
 db/attr.c                |   31 ++++++++++++++++++++++
 db/attrshort.c           |   25 ++++++++++++++++++
 db/metadump.c            |   34 +++++++++++++++++-------
 include/libxfs.h         |    1 +
 io/parent.c              |    5 ++--
 libxfs/init.c            |    7 +++++
 libxfs/libxfs_api_defs.h |    4 +++
 libxfs/util.c            |   14 ++++++++++
 mkfs/proto.c             |   65 +++++++++++++++++++++++++++++++++-------------
 repair/da_util.c         |    2 +
 10 files changed, 157 insertions(+), 31 deletions(-)

