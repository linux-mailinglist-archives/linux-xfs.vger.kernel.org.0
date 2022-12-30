Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFCF659CC8
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Dec 2022 23:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbiL3W2v (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 17:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbiL3W2u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:28:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867A51C90C;
        Fri, 30 Dec 2022 14:28:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 417CBB81C22;
        Fri, 30 Dec 2022 22:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDA2C433D2;
        Fri, 30 Dec 2022 22:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439327;
        bh=Y6DVwqkfI3wrgqShxAwmMGjTVnowALHirCWuZFTxQNk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sYI3vL31oGzDeNH5vSUAHPNxsP/FUegUiNAtq9RlJfJJMynS1LRQPjBEU2bUGapE/
         yJfIQvx6UlQxQ2Kcw9RSs6KkFUOBTDMjJ75FwA27OmQ53csEZBuD7o0/ZJOHOL97hi
         XfmHd8sPxFfJ75/DmcODMXB6Trff2/d6uIpM3R3wBy2jF5yXYLTQya2Ds4OIgxTfhN
         VzhcvG8eUpjDh54TqmO9EEmtUY13Mps5QQGo9PnhKG28rcZ0rKjm0d42vLeNAuWIBZ
         o4lZCe0LMtUS11OQDORSE3Gmlv6xOzfW8UCrgUktmWDK0EP7SBp0Pl8rVpxnPR+tjU
         WyKrY3swBmICw==
Subject: [PATCHSET v24.0 00/16] fstests: refactor online fsck stress tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:53 -0800
Message-ID: <167243837296.694541.13203497631389630964.stgit@magnolia>
In-Reply-To: <Y69UceeA2MEpjMJ8@magnolia>
References: <Y69UceeA2MEpjMJ8@magnolia>
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

This series prepares us to begin creating stress tests for the XFS
online fsck feature.  We start by hoisting the loop control code out of
the one existing test (xfs/422) into common/fuzzy, and then we commence
rearranging the code to make it easy to generate more and more tests.
Eventually we will race fsstress against online scrub and online repair
to make sure that xfs_scrub running on a correct filesystem cannot take
it down by accident.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=refactor-scrub-stress
---
 common/fuzzy        |  272 +++++++++++++++++++++++++++++++++++++++++++++++++++
 doc/group-names.txt |    1 
 tests/xfs/422       |  109 ++------------------
 tests/xfs/422.out   |    4 -
 4 files changed, 285 insertions(+), 101 deletions(-)

