Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A2676286C
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jul 2023 03:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjGZB5M (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jul 2023 21:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjGZB5L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2023 21:57:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB2D2D45;
        Tue, 25 Jul 2023 18:56:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D24E061159;
        Wed, 26 Jul 2023 01:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E80C433C7;
        Wed, 26 Jul 2023 01:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690336615;
        bh=pdFNWAJ8/VY98I8CDgv4gL3F5Az1bjD1Fnn3EVK4iH8=;
        h=Subject:From:To:Cc:Date:From;
        b=Rm7arkeFW6eWtOa2zrow9wYNH0jDBFY/fwWsJvd/IRcLDYZmse7GPn7rsLRgjSYoR
         82L4JrR/oX8VbQ8VJu7CNV4BdsoIW1gB/UToarXnbgFJ5HhtwbFzB9O90EisYaLXNn
         QPmMgIErsNoTkE69ci2o0h2/QfCNxlEPIvY9kmMHXYag4MwgnSxeCpcVAmoVbNudoz
         DB2/7Zv4wq5AAuY67AjmMVF8kf1gzO4FR0KB9IpcEN9P7C173VEZpb25/b0DogWSJw
         0ZCb+KvEsf+xqu3uMZtByXV3X8o1CVzdpEmGiSgSUrFYeTGHR+ICZpc29LLCdRJ0tx
         DLeb0304UL1sw==
Subject: [PATCHSET 0/1] fstests: updates for Linux 6.5
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 Jul 2023 18:56:54 -0700
Message-ID: <169033661482.3222297.18190312289773544342.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Pending fixes for things that are merged in 6.5.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs-fixes-6.5
---
 tests/xfs/122 |    8 ++++++++
 1 file changed, 8 insertions(+)

