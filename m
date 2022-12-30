Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 416EE65A033
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 02:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbiLaBEo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 20:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235910AbiLaBEj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:04:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920A31DF10;
        Fri, 30 Dec 2022 17:04:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 208FC61D73;
        Sat, 31 Dec 2022 01:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC68C433D2;
        Sat, 31 Dec 2022 01:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448677;
        bh=QoB1WqfriMtAgWZWG/26Ep0Nys7EGFWCbjBeYr+oBNw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=u2fTyNEoD3jQRrT4512txSU5g01nej8CUUrfs57Ep+gQZSNVC/PGo9AA2G4LZCgUW
         3RfYedyjeWihASEh/lMZDkdCFP1E/rhNCNdCaSOqfyhLTPsWnVltTAwxAQpbyrrCg0
         +2faKRlX5W1ONnTd//k3OmtHsFU9mu+mxJNDYT9hpYnvGpP2AshYvuwwp4FjOZbOo9
         MMqgTLYNXFc7YALO95SQFnTq//1R0exbisoTJBzK9U+W5WbKZBKbhd3GVQ6fhtuHyg
         zWANDBxD/jCy6S+GJULv8INBoH+DEHt4YRpf4n0MZZvRNd9+a9riMYAHk6PcHFq4aj
         DoP15vfbKfdgg==
Subject: [PATCHSET v1.0 00/10] fstests: reflink on the realtime device
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:48 -0800
Message-ID: <167243884850.740253.18400210873595872110.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
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

This patchset enables use of the file data block sharing feature (i.e.
reflink) on the realtime device.  It follows the same basic sequence as
the realtime rmap series -- first a few cleanups; then widening of the
API parameters; and introduction of the new btree format and inode fork
format.  Next comes enabling CoW and remapping for the rt device; new
scrub, repair, and health reporting code; and at the end we implement
some code to lengthen write requests so that rt extents are always CoWed
fully.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-reflink
---
 common/populate       |   26 ++++++++++++++++++---
 common/xfs            |   15 ++++++++++++
 tests/generic/331     |   12 ++++++++-
 tests/generic/331.out |    2 +-
 tests/xfs/122.out     |    3 ++
 tests/xfs/131         |   48 --------------------------------------
 tests/xfs/131.out     |    5 ----
 tests/xfs/1538        |   41 ++++++++++++++++++++++++++++++++
 tests/xfs/1538.out    |    4 +++
 tests/xfs/1539        |   41 ++++++++++++++++++++++++++++++++
 tests/xfs/1539.out    |    4 +++
 tests/xfs/1540        |   41 ++++++++++++++++++++++++++++++++
 tests/xfs/1540.out    |    4 +++
 tests/xfs/1541        |   42 +++++++++++++++++++++++++++++++++
 tests/xfs/1541.out    |    4 +++
 tests/xfs/1542        |   41 ++++++++++++++++++++++++++++++++
 tests/xfs/1542.out    |    4 +++
 tests/xfs/1543        |   40 ++++++++++++++++++++++++++++++++
 tests/xfs/1543.out    |    4 +++
 tests/xfs/1544        |   40 ++++++++++++++++++++++++++++++++
 tests/xfs/1544.out    |    4 +++
 tests/xfs/1545        |   41 ++++++++++++++++++++++++++++++++
 tests/xfs/1545.out    |    4 +++
 tests/xfs/240         |   13 +++++++++-
 tests/xfs/240.out     |    2 +-
 tests/xfs/243         |    5 ++++
 tests/xfs/272         |   40 +++++++++++++++++++++-----------
 tests/xfs/274         |   62 ++++++++++++++++++++++++++++++++++---------------
 tests/xfs/769         |    3 ++
 tests/xfs/818         |   43 ++++++++++++++++++++++++++++++++++
 tests/xfs/818.out     |    2 ++
 tests/xfs/819         |   43 ++++++++++++++++++++++++++++++++++
 tests/xfs/819.out     |    2 ++
 33 files changed, 590 insertions(+), 95 deletions(-)
 delete mode 100755 tests/xfs/131
 delete mode 100644 tests/xfs/131.out
 create mode 100755 tests/xfs/1538
 create mode 100644 tests/xfs/1538.out
 create mode 100755 tests/xfs/1539
 create mode 100644 tests/xfs/1539.out
 create mode 100755 tests/xfs/1540
 create mode 100644 tests/xfs/1540.out
 create mode 100755 tests/xfs/1541
 create mode 100644 tests/xfs/1541.out
 create mode 100755 tests/xfs/1542
 create mode 100644 tests/xfs/1542.out
 create mode 100755 tests/xfs/1543
 create mode 100644 tests/xfs/1543.out
 create mode 100755 tests/xfs/1544
 create mode 100644 tests/xfs/1544.out
 create mode 100755 tests/xfs/1545
 create mode 100644 tests/xfs/1545.out
 create mode 100755 tests/xfs/818
 create mode 100644 tests/xfs/818.out
 create mode 100755 tests/xfs/819
 create mode 100644 tests/xfs/819.out

