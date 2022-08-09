Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338D458E16A
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Aug 2022 23:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiHIVBO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Aug 2022 17:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiHIVAi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 17:00:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E780A2B25F;
        Tue,  9 Aug 2022 14:00:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CBE560B98;
        Tue,  9 Aug 2022 21:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CA1C433C1;
        Tue,  9 Aug 2022 21:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660078832;
        bh=NsfOyeat7eQRBQGfIh1c6X63qvec96mHVmms0EBOupU=;
        h=Subject:From:To:Cc:Date:From;
        b=XunadNpUlCa5G1m8t0Pg6ecZ6ianWQqjt8IPyWBWbkAQLhISpkx/y8bIZjHimnJ89
         wXMBRo1d68o0sTPs7L37OWGEkfcDKCIz0kkPiRfnwJNoxwsb6FonSZgfACn2+GhgbV
         vPDW0S+T0IHI1bA8lJFWkTN676T5evOzY6HsvsTZCTyC3PMGAQUR7+HEWKL4/78yTR
         Nu5c8CWdc1VvvZk+2m8ifQLWIf5Mbpm14nbakF4ZCptbGXfmGfYFcze4Yk6zbS+IZn
         sQTl4KvuujZvtJXqIqSxNcenhhgFP7AbzHURLmyKdW285IJXTOXVSoiBHXJ92lhUz7
         IpScWENgren2g==
Subject: [PATCHSET 0/1] fstests: fix tests for kernel 5.19
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 09 Aug 2022 14:00:32 -0700
Message-ID: <166007883231.3274939.3963254355857450803.stgit@magnolia>
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

Pending fixes for new 5.19 material.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-fixes-5.19

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs-fixes-5.19
---
 tests/xfs/015     |    4 ++--
 tests/xfs/042     |   14 +++++++-------
 tests/xfs/042.out |    4 ++--
 tests/xfs/076     |    2 +-
 4 files changed, 12 insertions(+), 12 deletions(-)

