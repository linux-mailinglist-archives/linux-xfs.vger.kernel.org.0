Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5703D7006
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jul 2021 09:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235409AbhG0HKW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Jul 2021 03:10:22 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50455 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235695AbhG0HKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 03:10:21 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C828586409C
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 17:10:17 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m8HEG-00BI3d-LK
        for linux-xfs@vger.kernel.org; Tue, 27 Jul 2021 17:10:16 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m8HEG-00E5ah-Al
        for linux-xfs@vger.kernel.org; Tue, 27 Jul 2021 17:10:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/11 v3] xfs: fix log cache flush regressions and bugs
Date:   Tue, 27 Jul 2021 17:10:01 +1000
Message-Id: <20210727071012.3358033-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=m-B9G8uOmJ6nOEA8dm0A:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

tl;dr: I may have found all the cache flush problems that I'm
reproducing with generic/482. The last two failures I've RCA'd have
been repair complaining about invalid attribute because attr fork
setup is non-atomic (xfs_attr_shortform_to_leaf() on an empty attr
fork). I'm still running tests to see if another cache flush related
failure occurs, but I'm more confident than I was yesterday that the
light I see isn't another train...

The first seven patches in this series fix regressions introduced by
commit eef983ffeae7 ("xfs: journal IO cache flush reductions") and
exposed by generic/482. I have one test machine that reproduces
the failures, and in general a failure occurs 1 in every 30 test
iterations.

The first two patches are related to external logs. These were found
by code inspection while looking for the cause of the generic/482
failures.

The third and fourth patch addresses a race condition between the
new unconditional async data device cache flush run by the CIL push
and the log tail changing between that flush completing and the
commit iclog being synced. In this situation, if the commit_iclog
doesn't issue a REQ_PREFLUSH, we fail to guarantee that the metadata
IO completions that moved the log tail are on stable storage. The
fix for this issue is to sample the log tail before we issue the
async cache flush, and if the log tail has changed when we release
the commit_iclog we set the XLOG_ICL_NEED_FLUSH flag on the iclog to
guarantee a cache flush is issued before the commit record that
moves the tail of the log forward is written to the log.

The fifth and sixth patches address an oversight about log forces.
Log forces imply a cache flush if they result in iclog IO being
issued, allowing the caller to elide cache flushes that they might
require for data integrity. The change to requiring the iclog owner
to signal that a cache flush is required completely missed the log
force code. This patch ensures that all ACTIVE and WANT_SYNC iclogs
that we either flush or wait on issue cache flushes and so guarantee
that they are on stable storage at IO completion before they signal
completion to log force waiters.

The seventh patch is not a regression, but a fix for another log
force iclog related flush problem I noticed and found while triaging
the above problems. Occasionally the tests would sit idle doing
nothing for up to 30s waiting on a xfs_log_force_seq() call to
complete. The trigger for them to wake up was the background log
worker issuing a new log force. This appears to be another
"incorrectly wait on future iclog state changes" situation, and it's
notable that xfs_log_force() specifically handles this situation
while xfs_log_force_seq() does not. Changing xfs_log_force_seq() to
use the same "iclog IO already completed" detection as
xfs_log_force() made those random delays go away.

The eighth patch is a fix for inode logging being able to make the
on-disk LSN in the inode go backwards in time. This is a regression
from 2016 when we shrunk the inode by not tracking the on-disk inode
LSN in memory any more. This can cause inodes to be replayed
incorrectly, leading to silent corruption during log recovery.

The ninth patch is a fix for a zero-day bug in the on-disk LSN log
recovery ordering for attribute leaf blocks. We fail to recognise
them and extract their LSN, so they are always recovered
immediately. This can result in recovery taking them backwards in
time, leading to silent corruption during log recovery. This has
been around since recovery ordering was introduced for v5
filesystems way back in 2013....

The tenth patch is an addition to the iclog state tracing that dumps
the iclog flags which tells me whether the NEED_FLUSH/NEED_FUA flags
are set on the iclog as it is released for IO. This helps validate
whether the iclog flushing is doing the right thing when a g/482
failure occurs with a suspected cache flushing issue.

The last patch is a fix for the new race condition found. It's
tricky and complex and requires a commit record in the iclog left in
ACTIVE state with NEED_FUA set on it, then to have a log tail update
occur after the next CIL push flush is done but before the iclog is
flushed when the checkpoint overruns the remaining iclog space.

Please consider this patchset for a 5.14-rc4 merge, because we need
to get the obvious failures and regressions fixed sooner rather
later.

Version 3:
- fixed typos in commits
- Updated tail lsn vs flush comments on xlog_state_release_iclog()
- Added new patch to fix another tail lsn vs iclog write race

Version 2:
- rebased on 5.14-rc3
- https://lore.kernel.org/linux-xfs/20210726060716.3295008-1-david@fromorbit.com/T/#t
- split __xlog_state_release_iclog() folding into separate patch (Christoph)
- Reinstated lost trace_xlog_iclog_syncing tracepoint.
- split xlog_force_iclog() helper into separate patch.
- In xlog_force_lsn(), don't set log_flushed for the WANT_SYNC case as there is
  no guarantee that the log has been flushed when we return if we are not
  waiting.
- appended inode LSN logging fix to series from
  https://lore.kernel.org/linux-xfs/20210722015335.3063274-1-david@fromorbit.com/T/#t
- Fixed inode recovery failure when two checkpoints have the same recovery LSN
  (start records in the same iclog) and an inode is logged in both checkpoints.
  The second transaction would see an equal LSN to the inode on disk and skip
  replay, even though it was required.
- added more comments to indicate the LSN in the xfs_log_dinode is never valid
  for recovery or replay purposes
- added new patch for ATTR3_LEAF magic number detection and recovery (yet
  another zero day!).

Version 1:
- based on 5.14-rc1
- https://lore.kernel.org/linux-xfs/20210722015335.3063274-1-david@fromorbit.com/T/#t

