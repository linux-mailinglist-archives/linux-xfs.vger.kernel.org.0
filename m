Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780183C7CFB
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Jul 2021 05:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237736AbhGNDjy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 13 Jul 2021 23:39:54 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:52046 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237754AbhGNDjw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jul 2021 23:39:52 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id A79A91B0EE8
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 13:36:58 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3Vhh-006Ify-U2
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 13:36:58 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m3Vhh-00B035-M2
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 13:36:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/5 v2] xfs: strictly order log start records
Date:   Wed, 14 Jul 2021 13:36:51 +1000
Message-Id: <20210714033656.2621741-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=IGfJWdSb32bzu4Gr1ucA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


We recently found a zero-day log recovery issue where overlapping
log transactions used the wrong LSN for recovery operations despite
being replayed in the correct commit record order. The issue is that
the log recovery code uses the LSN of the start record of the log
transaction for ordering and metadata stamping, while the actual
order of transaction replay is determined by the commit record.
Hence if we pipeline CIL commits we can end up with overlapping
transactions in the log like:

Start A .. Start C .. Start B .... Commit A .. Commit B .. Commit C

The issue is that the "start B" lsn is later than the "start C" lsn.
When the same metadata block is modified in both transaction B and
C, writeback from "commit B" will correctly stamp "start B" into the
metadata.

However, when "commit C" runs, it will see the LSN in that metadata
block is "start B", which is *more recent than "Start C" and so
will, incorrectly, fail to recover that change into the metadata
block. This results in silent metadata corruption, which can then be
exposed by future recovery operations failing, runtime
inconsistencies causing shutdowns and/or xfs_scrub/xfs_repair check
failures.

We could fix log recovery to avoid this problem, but there's a
runtime problem as well: the AIL is ordered by start record LSN. We
cannot order the AIL by commit LSN as we cannot allow the tail of
the log to overwrite -any- of the log transaction until the entire
transaction has been written. As the lowest LSN of the items in the
AIL defines the current log tail, the same metadata writeback
ordering issues apply as with log recovery.

In this case, we run the callbacks for commit B first, which place
all the items at the head of the log at "start B". Then we run
callbacks for "commit C", which then do not insert at the head -
they get inserted before "start B". If the item was modified in both
B and C, then it moves *backwards* in the AIL and this screws up all
manner of things that assume relogging can only move objects
forwards in the log. One of these things it can screw up is the tail
lsn of the log. Nothing good comes from this...

Because we have both runtime and journal-based ordering requirements
for the start_lsn, we have multiple places where there is an
implicit assumption that transaction start records are strictly
ordered. Rather than play whack-a-mole with such assumptions, and to
avoid the eternal "are you running a fixed kernel" question, it's
better just to strictly order the start records in the same way we
strictly order the commit records.

This patch series takes the mechanisms of the strict commit record
ordering and utilises them for strict start record ordering. It
builds upon the shutdown rework patchset to guarantee that the CIL
context structure will not get freed from under it by a racing
shutdown, and so moves the LSN recording for ordering up into a
callback from xlog_write() once we have a guaranteed iclog write
location. This means we have one mechanism for both start and commit
record ordering, and they both work in exactly the same way.


Version 2:
- rebase on 5.14-rc1 + "xfs: shutdown is a racy mess"
- fixed typos in commit messages

Version 1:
- https://lore.kernel.org/linux-xfs/20210630072108.1752073-1-david@fromorbit.com/

