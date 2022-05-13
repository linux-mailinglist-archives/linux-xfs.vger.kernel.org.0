Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99E4526B9C
	for <lists+linux-xfs@lfdr.de>; Fri, 13 May 2022 22:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358004AbiEMUeR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 13 May 2022 16:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384530AbiEMUeL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 May 2022 16:34:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1836213CC2
        for <linux-xfs@vger.kernel.org>; Fri, 13 May 2022 13:33:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6EA3622CD
        for <linux-xfs@vger.kernel.org>; Fri, 13 May 2022 20:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCB7C34113;
        Fri, 13 May 2022 20:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652474034;
        bh=cE25A0ldbYoC7cdWvZzt4A63x+UYiPAlX9oyGzS5/aY=;
        h=Subject:From:To:Cc:Date:From;
        b=fR7L0mYYNFgYNjj3VOqhPofXkMZhd3UxC3AKmBfMh//n6usB1zULQSvk7x6up5raI
         wvK9uI0lv1jkHZkyNMDxWWzBu4USq4/xOZT8rowiZ1+G3tcvsPaElbBEmsBWoPNgoY
         VFvMVuR3NIPzjNam1D1j49qzRbfNJQXS+pT7IurFIgURqAFpyKiPTMEr2cKVHsNWz6
         e1gONOwWUx0grFRJ50T5BVHEIhZGqJxHlFTx8P+ZiDAhPqzJrDXR1scZyvc0pt1mj+
         WRA8Wa1UfIg1GoJRgr/d3peOeyHCpWQsv+pru8kzh5OlKUBJdYLkK5wFLvuc7lPWoM
         6e14oovcaO24A==
Subject: [PATCHSET v2 0/4] xfs_repair: check rt bitmap and summary
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Fri, 13 May 2022 13:33:53 -0700
Message-ID: <165247403337.275439.13973873324817048674.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I was evaluating the effectiveness of xfs_repair vs. xfs_scrub with
realtime filesystems the other day, and noticed that repair doesn't
check the free rt extent count, the contents of the rt bitmap, or the
contents of the rt summary.  It'll rebuild them with whatever
observations it makes, but it doesn't actually complain about problems.
That's a bit untidy, so let's have it do that.

v2: only check the rt bitmap when the primary super claims there's a
    realtime section

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-check-rt-metadata
---
 repair/incore.c     |    2 
 repair/phase5.c     |   13 +++
 repair/protos.h     |    1 
 repair/rt.c         |  214 ++++++++++++++++++---------------------------------
 repair/rt.h         |   18 +---
 repair/xfs_repair.c |    7 +-
 6 files changed, 98 insertions(+), 157 deletions(-)

