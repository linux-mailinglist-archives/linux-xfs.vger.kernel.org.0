Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92B9F55CC3D
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Jun 2022 15:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237205AbiF0Vf1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 27 Jun 2022 17:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbiF0VfZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 17:35:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC3510FF
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 14:35:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B40DB81BAF
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 21:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF7AC34115;
        Mon, 27 Jun 2022 21:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656365721;
        bh=b1SrokrhqyDkAINf+DWTY4iDTtDkYQPKubLoHghz+vI=;
        h=Subject:From:To:Cc:Date:From;
        b=eiuA36HSHMx6lTl0SNqsiO2JksXyFgscvVxCUZQcR1coqlrgimmChRtRlwV1LWqTK
         do4IavttDrX2xWNRk02dZCUdUqyTBGU6cdHk4vXhAFaRvvPiXTc4UI2lmkmlTREPF3
         3e5P0uPL12DIqTceWt2cePLzSJJlGBA3Wq8zcmjSIQPMM2Q/DsX5bw5Z0cVF39QaWJ
         vdas/l0+fQXKwT6rx1jizhp/OAY+XU+LofhuAzjXFsSmKcwbuU3JGOj9blDwpW/Llo
         lv70upT8bnBlhUxtvlM9ULXZW64wEHYWA54IVW6nO7OKLAOLyWXGDBF6Fv/TWPFHYB
         BxdiWUiVh7VfQ==
Subject: [PATCHSET v2 0/3] xfs: random fixes for 5.19-rc5
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, allison.henderson@oracle.com
Date:   Mon, 27 Jun 2022 14:35:21 -0700
Message-ID: <165636572124.355536.216420713221853575.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This week, we're fixing a log recovery regression that appeared in
5.19-rc1 due to an incorrect verifier patch, and a problem where closing
an O_RDONLY realtime file on a frozen fs incorrectly triggers eofblocks
removal.

v2: move the history of the leaf header count checks to the commit message

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-fixes-5.19
---
 fs/xfs/libxfs/xfs_attr.c      |   38 +++++++++-----------------------------
 fs/xfs/libxfs/xfs_attr.h      |    5 -----
 fs/xfs/libxfs/xfs_attr_leaf.c |   35 +++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_attr_leaf.h |    3 +--
 fs/xfs/xfs_attr_item.c        |   22 ----------------------
 fs/xfs/xfs_bmap_util.c        |    2 ++
 6 files changed, 31 insertions(+), 74 deletions(-)

