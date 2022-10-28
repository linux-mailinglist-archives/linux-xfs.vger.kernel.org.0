Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BC661197C
	for <lists+linux-xfs@lfdr.de>; Fri, 28 Oct 2022 19:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiJ1Rm1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Oct 2022 13:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiJ1RmJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Oct 2022 13:42:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFF723478D;
        Fri, 28 Oct 2022 10:41:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E7B4B82C0F;
        Fri, 28 Oct 2022 17:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAEAC433D6;
        Fri, 28 Oct 2022 17:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666978908;
        bh=xIZNq5GHDnIyAeLCpKGXb8hMyrBDhvSg7RyAGcZexHc=;
        h=Subject:From:To:Cc:Date:From;
        b=QXXXjf5LVVjE63RhbY04k90EveVoofRSNtw/nzSoRTxORT1G1SeJIPOJc4C0jA5/n
         7JXQGhbz0h6QnJtfZNr6f8vtvViO4s9kLpVSa7SHV0FF2HzC2+YES+cCkaA8Xp5Sxr
         wh4us1EvY0OIk3ui9vv3Kkp1BrdzAvo0uzGQT4sXOXHR39I9/CJq4lw93eOjwD5LN5
         A0hjdM68Qo/oQyCPgahF0t0/bRil8c9h8iYaM5wbQijjzQR2I7ZzG++DjJgOOsJLpC
         EHWf4t64cPqziuLbewT09aG7f+M2lwncMGk27jEqbUF/RX0YWRej/+uIxud8CQx8FV
         wg3ZBZxyGUI1Q==
Subject: [PATCHSET v23.3 0/4] fstests: refactor xfs geometry computation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 28 Oct 2022 10:41:48 -0700
Message-ID: <166697890818.4183768.10822596619783607332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

There are numerous tests that do things based on the geometry of a
mounted filesystem.  Before we start adding more tests that do this
(e.g. online fsck stress tests), refactor them into common/xfs helpers.

v23.2: refactor more number extraction grep/sed patterns
v23.3: rebase per maintainer request

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=refactor-xfs-geometry
---
 common/ext4     |    9 +++++
 common/populate |   24 ++++++-------
 common/rc       |    2 +
 common/xfs      |  104 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 tests/xfs/097   |    2 +
 tests/xfs/099   |    2 +
 tests/xfs/100   |    2 +
 tests/xfs/101   |    2 +
 tests/xfs/102   |    2 +
 tests/xfs/105   |    2 +
 tests/xfs/112   |    2 +
 tests/xfs/113   |    2 +
 tests/xfs/146   |    2 +
 tests/xfs/147   |    2 +
 tests/xfs/151   |    3 +-
 tests/xfs/271   |    2 +
 tests/xfs/307   |    2 +
 tests/xfs/308   |    2 +
 tests/xfs/348   |    2 +
 tests/xfs/530   |    3 +-
 20 files changed, 129 insertions(+), 44 deletions(-)

