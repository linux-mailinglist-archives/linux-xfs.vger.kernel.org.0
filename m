Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C088D52C2D3
	for <lists+linux-xfs@lfdr.de>; Wed, 18 May 2022 21:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241646AbiERSzH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 May 2022 14:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241676AbiERSzF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:55:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035A322DA35
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:55:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92CFA61866
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029C6C385A5;
        Wed, 18 May 2022 18:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900103;
        bh=MYOTvQLSH4jqORaFbLSjpZIACK2SpAI1HZfysPB+gHQ=;
        h=Subject:From:To:Cc:Date:From;
        b=RgLEm94rkVhTuBm8KLtUkvSU/Y6itwdaSd5UYbn7lGjSAg2mG5eeW1X4ZHQQ11A4s
         l7AHTt0s/lFwICqvECxbMxkff2rlXsRNn/MhkOMKOTia2yTF1k44773SQHAe4hdi0L
         H/OeuGuwkv0aSsMt2Ed3eb6+TrCcDJDa5buKZNePxFe9j/6yiyEG5MvGmmPW9we8Sz
         ZgfOQUOvZFRl7cEZY7AMDxVieHiLBDr3/bL/zNzS5mhfligwG48imqO/7GIsTrNJ9o
         J/TxJJ0+IG3y8N9SjMaB2iw4TgEo/dZox1/fDtUbqVjwGqXkh/e6X4d8ApBXl0anvG
         K4wlu8dUPvDGQ==
Subject: [PATCHSET 0/3] xfs: fix name/value buffer lifetime errrors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 18 May 2022 11:55:02 -0700
Message-ID: <165290010248.1646163.12346986876716116665.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

As part of kicking the tires on the new logged extended attributes
(LARP) code, I observed a crash in the xattr intent log item relogging
function.  A quick code inspection led to me noticing that the logging
code repeatedly allocates and frees space for the name and value
buffers, which is unnecessary.  Replace all that with a shared
refcounted buffer to hold the name and the value across all the log
items involved in the transaction, and as long as is necessary for the
log to process all work.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=attr-intent-uaf-fixes-5.19
---
 fs/xfs/libxfs/xfs_attr.h |    8 +
 fs/xfs/xfs_attr_item.c   |  296 +++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_attr_item.h   |   13 +-
 3 files changed, 191 insertions(+), 126 deletions(-)

