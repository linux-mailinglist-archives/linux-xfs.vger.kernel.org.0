Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850ED4DA63B
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Mar 2022 00:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236358AbiCOXYi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 15 Mar 2022 19:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352569AbiCOXYi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 19:24:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D01B31239
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 16:23:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F4EAB8190D
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 23:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C93C340ED;
        Tue, 15 Mar 2022 23:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647386602;
        bh=ZBOkI7I+5TDQ+QlqH9ZFcrIcjhMXWxUk1BbPApChngg=;
        h=Subject:From:To:Cc:Date:From;
        b=l/Wh7rWR5cDRu/REwldcqc3aIYJFSFAoi9inbmvbZXFz2qEoNb+To5y0kdOEf/Vm5
         dSVhoPL9NreqFlF7sIY9peqLoby80r401kvBal9Y9qMEjHFqbGwSYx5IKWJGMqMxnj
         kG09GMCu5ps3aW0SYUMXQNF8olhMO3mzud4MN+W86fGfDdJdcCOtLIHNnx/iY+XX9c
         eTkeuatAUHdB/TUjKSQsOeiJktzjZiYFR2+w0Ac/ZKbPnfTpjAFQ/U1gVDZuolNNS6
         VFCc+ujz0A/yad11IWTNcGJxhrMdXLIT3aTaAcWDpmASzNEe+rDRTfNJzcBOSU0AIs
         y+cWNqzXzgpAw==
Subject: [PATCHSET 0/5] xfsprogs: stop allowing tiny filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Tue, 15 Mar 2022 16:23:22 -0700
Message-ID: <164738660248.3191861.2400129607830047696.stgit@magnolia>
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

The maintainers have been besieged by a /lot/ of complaints recently
from people who format tiny filesystems and growfs them into huge ones,
and others who format small filesystems.  We don't really want people to
have filesystems with no backup superblocks, and there are myriad
performance problems on modern-day filesystems when the log gets too
small.

Empirical evidence shows that increasing the minimum log size to 64MB
eliminates most of the stalling problems and other unwanted behaviors,
so this series makes that change and then disables creation of small
filesystems, which are defined as single-AGs fses, fses with a log size
smaller than 64MB, and fses smaller than 300MB.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-forbid-tiny-fs
---
 mkfs/xfs_mkfs.c |  192 +++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 151 insertions(+), 41 deletions(-)

