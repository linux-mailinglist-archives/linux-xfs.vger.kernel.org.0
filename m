Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8453224B1
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Feb 2021 04:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhBWDfb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Feb 2021 22:35:31 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:55333 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231387AbhBWDf3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Feb 2021 22:35:29 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 985A3FA9D5D
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 14:34:46 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEOTF-0001kU-No
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 14:34:45 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lEOTF-00Di07-Dq
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 14:34:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: various log stuff...
Date:   Tue, 23 Feb 2021 14:34:34 +1100
Message-Id: <20210223033442.3267258-1-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=UJXOo9il10s96M3_xfEA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

HI folks,

Version 2 of this set of changes to the log code. First version
was posted here:

https://lore.kernel.org/linux-xfs/20210128044154.806715-1-david@fromorbit.com/

"Quick patch dump for y'all. A couple of minor cleanups to the
log behaviour, a fix for the CIL throttle hang and a couple of
patches to rework the cache flushing that journal IO does to reduce
the number of cache flushes by a couple of orders of magnitude."

Version 2:
- fix ticket reservation roundoff to include 2 roundoffs
- removed stale copied comment from roundoff initialisation.
- clarified "separation" to mean "separation for ordering purposes" in commit
  message.
- added comment that newly activated, clean, empty iclogs have a LSN of 0 so are
  captured by the "iclog lsn < start_lsn" case that avoids needing to wait
  before releasing the commit iclog to be written.
- added async cache flush infrastructure
- convert CIL checkpoint push work it issue an unconditional metadata device
  cache flush rather than asking the first iclog write to issue it via
  REQ_PREFLUSH.
- cleaned up xlog_write() to remove a redundant parameter and prepare the logic
  for setting flags on the iclog based on the type of operational data is being
  written to the log.
- added XLOG_ICL_NEED_FUA flag to complement the NEED_FLUSH flag, allowing
  callers to issue explicit flushes and clear the NEED_FLUSH flag before the
  iclog is written without dropping the REQ_FUA requirement in /dev/null...
- added CIL commit-in-start-iclog optimisation that clears the NEED_FLUSH flag
  to avoid an unnecessary cache flush when issuing the iclog.
- fixed typo in CIL throttle bugfix comment.
- fixed trailing whitespace in commit message.


