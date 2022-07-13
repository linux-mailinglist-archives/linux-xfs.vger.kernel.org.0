Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F48572A9E
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Jul 2022 03:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbiGMBJl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 Jul 2022 21:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbiGMBJl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 21:09:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AFFC9100
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jul 2022 18:09:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3AD2B81C84
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 01:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FA4C3411E;
        Wed, 13 Jul 2022 01:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657674577;
        bh=gMjR466wUEqySqYj5Jo9Kl3929bmrn9SQVsweoKinAY=;
        h=Subject:From:To:Cc:Date:From;
        b=dgRDCc938nKj8EQtrq0u/fCP/VZBw3/qaHSar1jhK0xHu8B0VcCX5ezsVTxLL6u9S
         tawN8+dK2gDBznT3Z+dwRnL/mao8jtlV1VMZgVCyDEjexX3V8eVE7TFimaThwFRmN0
         npta12+W1NyuhWkHtF9h05x58Q0zo49Fd793N+rhCr5vUOse5sfbV/5C74uZJaY6Sv
         4AD8fgeLA62BWM9fR16ZaE+MrJoe5XGeeT72OzKcCwIvqXql0EMAY8HmswQkWCFY42
         qy7MNMYD5vkxm++3r52+Vv7REFHwnzrTgN1FJGVt1eepRbzfTeMYOgIRNYZZ2G+xJy
         HKMQYKKNxHLbQ==
Subject: [PATCHSET 0/4] xfsprogs: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Date:   Tue, 12 Jul 2022 18:09:37 -0700
Message-ID: <165767457703.891854.2108521135190969641.stgit@magnolia>
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

This is a rollup of all the random fixes I've collected for xfsprogs
5.19.  At this point it's just an assorted collection, no particular
theme.  Some of them are leftovers from last week's posting.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 mkfs/xfs_mkfs.c      |    9 ++++++++-
 repair/attr_repair.c |   20 ++++++++++++++++++++
 repair/dino_chunks.c |    3 +--
 3 files changed, 29 insertions(+), 3 deletions(-)

