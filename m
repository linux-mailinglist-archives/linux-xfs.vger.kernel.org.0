Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8DB6DA0D7
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Apr 2023 21:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240194AbjDFTQd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 Apr 2023 15:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjDFTQd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:16:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B65BF2;
        Thu,  6 Apr 2023 12:16:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB2D8644AC;
        Thu,  6 Apr 2023 19:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5569AC433D2;
        Thu,  6 Apr 2023 19:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808591;
        bh=Pw7hg/VCzok4Z0lC/uX8EjP0vsrjRxUryABK015JjMM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=j10S8ZruxeMF/54fAtMzOifGisSKvFdA+ttjBTpGaianhLdwnLXP46sUrHIYBJUbJ
         03IB6v6Bda2bu33muHynSPFmE/o6VyQ9W1XpodCVeFCRSKAANcPyulT8UFuOFaCSRP
         +HhlKrNgYu6YZ9xC1CtKUKuUkNUTgkHi+SCxoSVT18DoMmKFfN1LlgjGh/I61UNOIu
         azuiqH/IUsk2JTEk3UZ5FTrmSI+I4iTe9On60FbAxtyOo0xWWE2zAw5OyxciUR/YCL
         88qyWwIZ9OgVq/6kqA1qBM/PmbEUq1mdXU0J3znNb8A5jeAUBqLP48DawIQ9PSpCHX
         hzGjGfuBx424Q==
Date:   Thu, 06 Apr 2023 12:16:30 -0700
Subject: [PATCHSET v11 00/11] fstests: adjust tests for xfs parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <168080829003.618488.1769223982280364994.stgit@frogsfrogsfrogs>
In-Reply-To: <20230406181038.GA360889@frogsfrogsfrogs>
References: <20230406181038.GA360889@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These are the test adjustments that are required for parent pointers.
There's also a few new tests to ensure that the GETPARENTS ioctl (and
hence the ondisk parent pointers) work the way they're supposed to.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs
---
 common/parent                        |  209 +++++++
 common/populate                      |   38 +
 common/rc                            |    7 
 common/xfs                           |   12 
 doc/group-names.txt                  |    1 
 src/popdir.pl                        |   11 
 tests/generic/050                    |   10 
 tests/generic/050.cfg                |    1 
 tests/generic/050.out.xfsquotaparent |   23 +
 tests/xfs/018                        |    7 
 tests/xfs/021                        |   15 -
 tests/xfs/021.cfg                    |    1 
 tests/xfs/021.out.default            |    0 
 tests/xfs/021.out.parent             |   62 ++
 tests/xfs/122.out                    |    3 
 tests/xfs/191                        |    7 
 tests/xfs/206                        |    3 
 tests/xfs/288                        |    7 
 tests/xfs/306                        |    9 
 tests/xfs/851                        |  116 ++++
 tests/xfs/851.out                    |   69 ++
 tests/xfs/852                        |   69 ++
 tests/xfs/852.out                    | 1002 ++++++++++++++++++++++++++++++++++
 tests/xfs/853                        |   85 +++
 tests/xfs/853.out                    |   14 
 25 files changed, 1770 insertions(+), 11 deletions(-)
 create mode 100644 common/parent
 create mode 100644 tests/generic/050.out.xfsquotaparent
 create mode 100644 tests/xfs/021.cfg
 rename tests/xfs/{021.out => 021.out.default} (100%)
 create mode 100644 tests/xfs/021.out.parent
 create mode 100755 tests/xfs/851
 create mode 100644 tests/xfs/851.out
 create mode 100755 tests/xfs/852
 create mode 100644 tests/xfs/852.out
 create mode 100755 tests/xfs/853
 create mode 100644 tests/xfs/853.out

