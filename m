Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BA3711B6C
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 02:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjEZAj6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 20:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242018AbjEZAjy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:39:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F10195
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:39:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFB7364BE0
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF5EC433D2;
        Fri, 26 May 2023 00:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061592;
        bh=ZpOueLkN/GC4bKhnR2P1IjhuxuzEn34XsHhU2qaemp0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qTWOIoX2j21xCv17hZokg/yyNiBYivfK5Bo0x4j1m0/SlZNZD2i4ZKxO/tEdSo6Ca
         6PeCnBMCfFzOMLclurayRRgmfejGzBPY0f7XzPbcl1JloShNKSRHbvjJd9MQF8KQ5a
         u0yoNZVo64UcBRdHixXcV+uGQlb5/KHkrQHuXUJjw20ovpvbf2odwLPsqujrSIdBk+
         HqPuhs950g58CY2iRwj4f977sf3uy6E4e2JiA4I+STQb0REyAOwBYvWPM3mDtwG/kp
         9CWmjsx86+55uhey1tFBhA7YJwz3b3rqNufgwaA2mLKDZ4sw0HpgKRH9N886GVwRgk
         +L7/dhr429B2g==
Date:   Thu, 25 May 2023 17:39:51 -0700
Subject: [PATCHSET v25.0 0/5] xfs_scrub: fixes for systemd services
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073832.3745766.10929690168821459226.stgit@frogsfrogsfrogs>
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

This series fixes deficiencies in the systemd services that were created
to manage background scans.  First, improve the debian packaging so that
services get installed at package install time.  Next, fix copyright and
spdx header omissions.

Finally, fix bugs in the mailer scripts so that scrub failures are
reported effectively.  Finally, fix xfs_scrub_all to deal with systemd
restarts causing it to think that a scrub has finished before the
service actually finishes.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-service-fixes
---
 debian/rules                     |    1 +
 scrub/Makefile                   |   19 ++++++++++++---
 scrub/xfs_scrub@.service.in      |    6 ++---
 scrub/xfs_scrub_all.in           |   49 ++++++++++++++++----------------------
 scrub/xfs_scrub_fail.in          |    9 +++++--
 scrub/xfs_scrub_fail@.service.in |    4 ++-
 6 files changed, 48 insertions(+), 40 deletions(-)
 rename scrub/{xfs_scrub_fail => xfs_scrub_fail.in} (70%)

