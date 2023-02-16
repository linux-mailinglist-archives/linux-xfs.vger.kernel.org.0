Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0EC0699DB7
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Feb 2023 21:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBPUai (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Feb 2023 15:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBPUah (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:30:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E3B196A9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:30:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2601E60A65
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F8DC433EF;
        Thu, 16 Feb 2023 20:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579435;
        bh=oVKw5E6AwduIylvBkDvQ/VqZWBNer8Rl4y3cXfU0CKw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=kQMAWKlx/G8T4NyLU5U0NS9JS/CS+DgP4LikhxQlo5q7q4YWw9PvioBxnloM3wpqd
         k6INezHaRdAipWEnfe8q29u8bp5DAJzRAlxQkXspDANm0VGpLhFZ/sOFu+958gnvfy
         GASeFIFFh/18zYvMd/gmEjXZD9fSTWMgb98kBtGfw2WB/8/9RWyXvaUz4Rn+4iN5ev
         KNvF1Mf1E+OJKMrJNXuFyvjjIPM2vUHv5FJZK3Esa3y+y2HPZptbebSAWgFbzVFFac
         p8QFT4niQqQsok55phRgHEq54L8RkqWV01wILu29Axv/3lzEW7k4DqMEK8ywja2I+I
         iry4LNFY7Avsg==
Date:   Thu, 16 Feb 2023 12:30:35 -0800
Subject: [PATCHSET v9r2d1 0/1] xfsprogs: online checking of parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657881358.3477633.3415293053198592445.stgit@magnolia>
In-Reply-To: <Y+6MxEgswrJMUNOI@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
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

Update the existing online parent pointer checker to confirm the
directory entries that should also exist.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-parent-check

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-online-parent-check
---
 libxfs/xfs_parent.c |   38 ++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h |   10 ++++++++++
 2 files changed, 48 insertions(+)

