Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2872663CAE0
	for <lists+linux-xfs@lfdr.de>; Tue, 29 Nov 2022 23:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236132AbiK2WBb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 29 Nov 2022 17:01:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235867AbiK2WB2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 17:01:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4D370DEC
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 14:01:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E14E61952
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 22:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0978FC433D6;
        Tue, 29 Nov 2022 22:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669759286;
        bh=UyOu+jPqeMMPPuO+zlXTLflmjWHwDjx/2K2SkKKfwzA=;
        h=Subject:From:To:Cc:Date:From;
        b=rB4FXntTDsvErp+mieEDTYW1FG69c7leiE8CX5hXE9Q4cD3l64cGlQ5ukd57EgKkz
         wIpa8Hm6xh620RWOBBioTgIqdXDxvmiW3S3e1cVRHOZyKznFl9WfcoyxC9JJG/vdOi
         vq7u/ek0c6i0BUs58ymIeX/0A3AHA3UoRK9kGCSOm/8bS2i+lhClaqjTdkqoEF9AYt
         S4aCBbatW2reeOIwr48DovbRqq9MoEX6vrOxSoh++qZDnexelV9AvuepCRan9M4ARB
         6ACNFJAH8+xzDF7cgdD7B3SYaqCd5/Q5nSCAwQ5ndnIFF+KeinxH23AsNSaK4IOUe5
         lz1fi6PYlW/Hg==
Subject: [PATCHSET 0/2] xfs: fix broken MAXREFCOUNT handling
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Tue, 29 Nov 2022 14:01:25 -0800
Message-ID: <166975928548.3768925.15141817742859398250.stgit@magnolia>
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

This quick series fixes a bug in the refcount code where we don't merge
records correctly if the refcount is hovering around MAXREFCOUNT.  This
fixes regressions in xfs/179 when fsdax is enabled.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=maxrefcount-fixes-6.2
---
 fs/xfs/libxfs/xfs_refcount.c |  143 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 127 insertions(+), 16 deletions(-)

