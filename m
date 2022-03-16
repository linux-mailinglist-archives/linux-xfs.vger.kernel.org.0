Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3F94DA638
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Mar 2022 00:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244865AbiCOXYZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 15 Mar 2022 19:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236358AbiCOXYY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 19:24:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B2F1FA4F
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 16:23:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DC16B81744
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 23:23:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A52C340F3;
        Tue, 15 Mar 2022 23:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647386588;
        bh=YvcI5WPJLgstNiH9soMCuSOhJeqGtOw4g+j3IFjoLDg=;
        h=Subject:From:To:Cc:Date:From;
        b=DZkRzZp0yoJeAB4hEpROQR/bd+XbieNaBo6f9/SFMklCmH1h+tNIxBClxCOMBz0hp
         JD7MusrV4jbP8OPwT288JmUNf6iYNqwsDE7FXfV2lsRKQbVA4nwbbdWwx6Y43KcR0l
         Axnx6y/BrIxbE5A3nJ8mYOe7GJz35S1LAYyD+gh4ARK/8sVsKsPFGGBITh5me0SL1Q
         d7pozjb2lE89zmZ1fQ+OS2Yi6QuUAtDSDLXvNdbqLO6crx3cAJo0nkLC7Y0ioHDq5+
         C0YxK3BDygoJUm87UzUq58Pb6/Koad0TIbmTmFn6ayWpL6YimaowpvWlke/pxc4Qy6
         JUvPF78RJ5ASw==
Subject: [PATCHSET 0/2] xfsprogs: various 5.15 fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Tue, 15 Mar 2022 16:23:07 -0700
Message-ID: <164738658769.3191772.13386518564409172970.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's the last couple of bug fixes for 5.15 -- merely a couple of
omissions from xfs-scrub.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.15-fixes
---
 scrub/scrub.c |   33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

