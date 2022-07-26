Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA34581A7B
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Jul 2022 21:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239688AbiGZTst (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 26 Jul 2022 15:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiGZTss (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 15:48:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399A932D98;
        Tue, 26 Jul 2022 12:48:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA2F561564;
        Tue, 26 Jul 2022 19:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F560C433C1;
        Tue, 26 Jul 2022 19:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658864926;
        bh=xAfF7kUNC7tl+cwd7PTaoimlAb+lkA9z44pC7EuZrDQ=;
        h=Subject:From:To:Cc:Date:From;
        b=kumH2fXIRC/5KPqPay/N14Ho6c+aMCloNQ+xkhlgJG+0TiB6Yop/MGnRiiNuDr7Bo
         6nXX/tri1NjHlnPqQBTPpIjhAjom7IdsRjZ+WQ1l/VS6mrUWVgLV0qf59GKY+n5qJ7
         eyT2+yOJXfGsqCNU+gXVv3VGpqiRQmeMJEhoXBEwehPXPVB0IRtPgEbYjkpg6bz72q
         eXuxUu5tvmJjAN1b2HUBzkWX2xKgxvDuX99Ks1ebv9ZG1kCq2jLnsYiNQIB+OPcv1r
         AIWV+djIe3RbryXkgyXKpbiJYGqsjXDyGgzk3K2zLTwRxLAvy96ZuKDYc6+aIJDHgr
         8InC4RgcvW7Fg==
Subject: [PATCHSET 0/1] fstests: _notrun dmlogwrites tests when external log
 devices in use
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 26 Jul 2022 12:48:45 -0700
Message-ID: <165886492580.1585149.760428651537119015.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I started running the dmlogwrites tests on filesystems with multiple
devices (e.g. xfs with external log devices) and discovered that the
tests fail.  It doesn't look like dm-logwrites has a way to coordinate
mark numbers across a bunch of devices, so I'm guessing it just doesn't
work and should be disabled.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=dmlogwrites-multidisk
---
 common/rc         |    8 ++++++++
 tests/generic/455 |    1 +
 tests/generic/457 |    1 +
 tests/generic/470 |    1 +
 tests/generic/482 |    1 +
 5 files changed, 12 insertions(+)

