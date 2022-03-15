Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71EFD4D94BE
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Mar 2022 07:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345238AbiCOGoE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 15 Mar 2022 02:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345265AbiCOGoC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 02:44:02 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D9A9C6F
        for <linux-xfs@vger.kernel.org>; Mon, 14 Mar 2022 23:42:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B322210E444E
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 17:42:44 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nU0tH-005elE-GM
        for linux-xfs@vger.kernel.org; Tue, 15 Mar 2022 17:42:43 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nU0tH-00D9Ju-Ep
        for linux-xfs@vger.kernel.org;
        Tue, 15 Mar 2022 17:42:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/7 v3] xfs: log recovery fixes
Date:   Tue, 15 Mar 2022 17:42:34 +1100
Message-Id: <20220315064241.3133751-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62303565
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=AmCRXBs-6vWbMaXcZSAA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Willy reported generic/530 had started hanging on his test machines
and I've tried to reproduce the problem he reported. While I haven't
reproduced the exact hang he's been having, I've found a couple of
others while running g/530 in a tight loop on a couple of test
machines.

The first 3 patches are defensive fixes - the log worker acts as a
watchdog, and the issues in patch 2 and 3 were triggered on my
testing of g/530 and lead to 30s delays that the log worker watchdog
caught. Without the watchdog, these may actually be deadlock
triggers.

The 4th patch is the one that fixes the problem Willy reported.
It is a regression from conversion of the AIL pushing to use
non-blocking CIL flushes. It is unknown why this suddenly started
showing up on Willy's test machine right now, and why only on that
machine, but it is clearly a problem. This patch catches the state
that leads to the deadlock and breaks it with an immediate log
force to flush any pending iclogs.

In testing these patches, I found generic/388 was causing frequent
failures with recovery failing because inode clusters were being
found uninitialised in log recovery. That turns out to be a zero day
race condition in the forced shutdown code, and that is fixed over
the patches 5-7. In short, we can't abort writeback of log items
before we shut down the log (because that's separate to -mount-
shutdown) as removing aborted log items can move the tail of the log
forward and that can be propagated to the on-disk log and corrupt it
if timing is just right.

Fixing this takes failures of g/388 from 1 in 5-10 runs to 1 in 100
runs. There is a change in patch 7 that I mention "I'm not sure how
this can happen here, but it's handled elsewhere like this" that
avoids a double remove of an aborted inode from the AIL that results
in an ASSERT failure. I *think* I now know how that can occur, but
fixing it is another set of patches, and it may be a recent
regression rather than a long standing issue.

Version 3:
- added fixes for generic/388 failures.

Version 2:
- https://lore.kernel.org/linux-xfs/20220309015512.2648074-1-david@fromorbit.com/
- updated to 5.17-rc7
- tested by Willy.

Version 1:
- https://lore.kernel.org/linux-xfs/20220307053252.2534616-1-david@fromorbit.com/

