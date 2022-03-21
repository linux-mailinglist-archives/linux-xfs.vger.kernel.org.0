Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB4B4E1EA3
	for <lists+linux-xfs@lfdr.de>; Mon, 21 Mar 2022 02:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbiCUBZF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 20 Mar 2022 21:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244598AbiCUBZE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Mar 2022 21:25:04 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 449D4E0BB
        for <linux-xfs@vger.kernel.org>; Sun, 20 Mar 2022 18:23:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 368C65336DB
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 12:23:34 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nW6lg-007vzB-9F
        for linux-xfs@vger.kernel.org; Mon, 21 Mar 2022 12:23:32 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nW6lg-001Zuf-6j
        for linux-xfs@vger.kernel.org;
        Mon, 21 Mar 2022 12:23:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfs: more shutdown/recovery fixes
Date:   Mon, 21 Mar 2022 12:23:27 +1100
Message-Id: <20220321012329.376307-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6237d396
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=o8Y5sQTvuykA:10 a=ok0e8giGdOLxln7VH7gA:9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

These two patches are followups to my recent series of
shutdown/recovery fixes. The cluster buffer lock patch addresses a
race condition that started to show up regularly once the fixes in
the previous series were done - it is a regression from the async
inode reclaim work that was done almost 2 years ago now.

The second patch is something I'm really surprised has taken this
long to uncover. There is a check in intent recovery/cancellation
that checks that there are no intent items in the AIL after the
first non-intent item is found. This behaviour was correct back when
we only had standalone intent items (i.e. EFI/EFD), but when we
started to chain complex operations by intents, the recovery of an
incomplete intent can log and commit new intents and they can end up
in the AIL before log recovery is complete and finished processing
the deferred items. Hence the ASSERT() check that no intents
exist in the AIL after the first non-intent item is simply invalid.

With these two patches, I'm back to being able to run hundreds of
cycles of g/388 or -g recoveryloop without seeing any failures.

-Dave.

