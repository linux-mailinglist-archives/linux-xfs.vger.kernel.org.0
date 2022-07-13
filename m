Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F09572A7B
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Jul 2022 02:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiGMA4i (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 Jul 2022 20:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiGMA4i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 20:56:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9B1BEB56;
        Tue, 12 Jul 2022 17:56:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC35FB81C94;
        Wed, 13 Jul 2022 00:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9121BC3411E;
        Wed, 13 Jul 2022 00:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657673794;
        bh=J5ZqoZ8/A1m2Ae6CoBVdCmDT0QviPZnWfWsv7+ytVL0=;
        h=Subject:From:To:Cc:Date:From;
        b=LSN0hbfrqhrdXz/e7hkYZfTazc9wPoYOEPm8+ThXaFPE7Ob6HIGWkw/csXDehWKY5
         eWOp6xG0qyOx1K3OnOtlqUKD3LzlMUjw0biSjNAg2EA7Ss7rYaJbqFPkcetSktacfB
         7oAqPGqbvMCjDR0mTnfJWiVV+VBDWG+hCPuptrcX5TzNqhivxmLCnZFRzn0w8OyXJY
         mTw02NkotLQxNj8PauISUEoou1c5wz6PDWZ1OZQApMXATllNe1xIseIYqhsLmqpeQb
         RZ7VmYR5NChw+ysFbyEb9vjvxNE7JQAGWiJZKpkD9tSGauygVJ0Xo+b2FgxhUhbnE7
         FDj9B54LZIUVw==
Subject: [PATCHSET 0/8] fstests: check file block congruency of file range
 operations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 12 Jul 2022 17:56:34 -0700
Message-ID: <165767379401.869123.10167117467658302048.stgit@magnolia>
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

I started running fstests with XFS filesystems that don't have the usual
file geometry characteristics -- block sizes larger than 4k, realtime
filesystems with extent sizes that aren't a power of two, etc.  What I
found is that many file operation tests (fallocate, reflink, etc.) that
operate on disk blocks assume that aligning the arguments to 64k is
sufficient to avoid EINVAL.  Unfortunately, this just means that these
tests fail left and right on realtime filesystems where the file
allocation unit is large (~2MB, anyone?) or a weird number (28K).

Add a predicate to all of these tests so that we can _notrun them if
they make assumptions about file size /and/ encode something (usually
file hashes) in the golden output that mean we can't easily accomodate
these corner cases without redesigning each test.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=check-blocksize-congruency
---
 common/filter     |    4 ++--
 common/punch      |    3 ++-
 common/rc         |   18 +++++++++++++++++-
 tests/generic/017 |    2 +-
 tests/generic/031 |    1 +
 tests/generic/064 |    2 +-
 tests/generic/116 |    1 +
 tests/generic/118 |    1 +
 tests/generic/119 |    1 +
 tests/generic/121 |    1 +
 tests/generic/122 |    1 +
 tests/generic/134 |    1 +
 tests/generic/136 |    1 +
 tests/generic/137 |    1 +
 tests/generic/144 |    1 +
 tests/generic/149 |    1 +
 tests/generic/153 |    2 +-
 tests/generic/158 |    2 +-
 tests/generic/162 |    1 +
 tests/generic/163 |    1 +
 tests/generic/164 |    1 +
 tests/generic/165 |    1 +
 tests/generic/168 |    1 +
 tests/generic/170 |    1 +
 tests/generic/181 |    1 +
 tests/generic/183 |    1 +
 tests/generic/185 |    1 +
 tests/generic/186 |    1 +
 tests/generic/187 |    1 +
 tests/generic/188 |    1 +
 tests/generic/189 |    1 +
 tests/generic/190 |    1 +
 tests/generic/191 |    1 +
 tests/generic/194 |    1 +
 tests/generic/195 |    1 +
 tests/generic/196 |    1 +
 tests/generic/197 |    1 +
 tests/generic/199 |    1 +
 tests/generic/200 |    1 +
 tests/generic/201 |    1 +
 tests/generic/284 |    1 +
 tests/generic/287 |    1 +
 tests/generic/289 |    1 +
 tests/generic/290 |    1 +
 tests/generic/291 |    1 +
 tests/generic/292 |    1 +
 tests/generic/293 |    1 +
 tests/generic/295 |    1 +
 tests/generic/352 |    1 +
 tests/generic/358 |    1 +
 tests/generic/359 |    1 +
 tests/generic/372 |    1 +
 tests/generic/404 |    2 +-
 tests/generic/414 |    1 +
 tests/generic/483 |    4 ++++
 tests/generic/495 |    4 ++++
 tests/generic/501 |    1 +
 tests/generic/503 |    4 ++++
 tests/generic/515 |    1 +
 tests/generic/516 |    1 +
 tests/generic/540 |    1 +
 tests/generic/541 |    1 +
 tests/generic/542 |    1 +
 tests/generic/543 |    1 +
 tests/generic/544 |    1 +
 tests/generic/546 |    1 +
 tests/generic/578 |    1 +
 tests/generic/588 |    2 ++
 tests/generic/673 |    1 +
 tests/generic/674 |    1 +
 tests/generic/675 |    1 +
 tests/generic/677 |    4 ++++
 tests/generic/683 |    1 +
 tests/generic/684 |    1 +
 tests/generic/685 |    1 +
 tests/generic/686 |    1 +
 tests/generic/687 |    1 +
 tests/generic/688 |    1 +
 tests/xfs/069     |    1 +
 tests/xfs/114     |    2 ++
 tests/xfs/166     |    4 ++++
 tests/xfs/180     |    1 +
 tests/xfs/182     |    1 +
 tests/xfs/184     |    1 +
 tests/xfs/192     |    1 +
 tests/xfs/193     |    1 +
 tests/xfs/198     |    1 +
 tests/xfs/200     |    1 +
 tests/xfs/203     |    4 ++++
 tests/xfs/204     |    1 +
 tests/xfs/208     |    1 +
 tests/xfs/209     |    1 +
 tests/xfs/210     |    1 +
 tests/xfs/211     |    1 +
 tests/xfs/212     |    1 +
 tests/xfs/215     |    1 +
 tests/xfs/218     |    1 +
 tests/xfs/219     |    1 +
 tests/xfs/221     |    1 +
 tests/xfs/223     |    1 +
 tests/xfs/224     |    1 +
 tests/xfs/225     |    1 +
 tests/xfs/226     |    1 +
 tests/xfs/228     |    1 +
 tests/xfs/230     |    1 +
 tests/xfs/231     |    1 +
 tests/xfs/232     |    1 +
 tests/xfs/237     |    1 +
 tests/xfs/239     |    1 +
 tests/xfs/240     |    1 +
 tests/xfs/241     |    1 +
 tests/xfs/248     |    1 +
 tests/xfs/249     |    1 +
 tests/xfs/251     |    1 +
 tests/xfs/254     |    1 +
 tests/xfs/255     |    1 +
 tests/xfs/256     |    1 +
 tests/xfs/257     |    1 +
 tests/xfs/258     |    1 +
 tests/xfs/280     |    1 +
 tests/xfs/312     |    1 +
 tests/xfs/315     |    1 +
 tests/xfs/322     |    1 +
 tests/xfs/326     |    1 +
 tests/xfs/329     |    1 +
 tests/xfs/346     |    1 +
 tests/xfs/347     |    1 +
 tests/xfs/436     |    1 +
 tests/xfs/507     |    3 +++
 tests/xfs/537     |    2 +-
 130 files changed, 170 insertions(+), 10 deletions(-)

