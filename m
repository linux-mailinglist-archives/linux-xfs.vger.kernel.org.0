Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8048A3DCE6A
	for <lists+linux-xfs@lfdr.de>; Mon,  2 Aug 2021 02:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhHBAqN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 1 Aug 2021 20:46:13 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:53514 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230421AbhHBAqM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Aug 2021 20:46:12 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id AD89280BC36;
        Mon,  2 Aug 2021 10:46:01 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mAM5f-00DTDE-83; Mon, 02 Aug 2021 10:45:59 +1000
Date:   Mon, 2 Aug 2021 10:45:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 06/20] xfs: throttle inodegc queuing on backlog
Message-ID: <20210802004559.GE2757197@dread.disaster.area>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758426670.332903.7504844999802581902.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162758426670.332903.7504844999802581902.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=IAsHV9L0MaXson9FISwA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 29, 2021 at 11:44:26AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Track the number of inodes in each AG that are queued for inactivation,
> then use that information to decide if we're going to make threads that
> has queued an inode for inactivation wait for the background thread.
> The purpose of this high water mark is to establish a maximum bound on
> the backlog of work that can accumulate on a non-frozen filesystem.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_ag.c |    1 +
>  fs/xfs/libxfs/xfs_ag.h |    3 ++-
>  fs/xfs/xfs_icache.c    |   16 ++++++++++++++++
>  fs/xfs/xfs_trace.h     |   24 ++++++++++++++++++++++++
>  4 files changed, 43 insertions(+), 1 deletion(-)

Ok, this appears to cause fairly long latencies in unlink. I see it
overrun the throttle threshold and not throttle for some time:

rm-16440 [016]  5391.083568: xfs_inodegc_throttle_backlog: dev 251:0 agno 3 needs_inactive 65537
rm-16440 [016]  5391.083622: xfs_inodegc_throttle_backlog: dev 251:0 agno 3 needs_inactive 65538
rm-16440 [016]  5391.083689: xfs_inodegc_throttle_backlog: dev 251:0 agno 3 needs_inactive 65539
.....
rm-16440 [016]  5391.216007: xfs_inodegc_throttle_backlog: dev 251:0 agno 3 needs_inactive 67193
rm-16440 [016]  5391.216069: xfs_inodegc_throttle_backlog: dev 251:0 agno 3 needs_inactive 67194
rm-16440 [016]  5391.216179: xfs_inodegc_throttle_backlog: dev 251:0 agno 3 needs_inactive 67195
rm-16440 [016]  5391.231293: xfs_inodegc_throttle_backlog: dev 251:0 agno 3 needs_inactive 66807

You can see from the traces above that a typical
unlink() runs in about 60-70 microseconds. Notably, when background
inactivation kicks in, that blew out to 15ms for a single unlink.
Also, we can see that it has overrun 150ms past when it first hits the throttle
threshold before background inactivation kicks in (we can see the
inactive count come down). The next trace from this process is:

rm-16440 [016]  5394.335940: xfs_inodegc_throttled: dev 251:0 agno 3 caller xfs_fs_destroy_inode+0xbb

Because it now waits on flush_work() to complete the background
inactivation before it can run again. IOWs, this user process just
got blocked for over 3 seconds waiting for internal GC to do it's
stuff.

This blows out the long tail latencies that userspace sees and this
will really hurt random processes that drop the last reference to
files that are going to be reclaimed immediately. (e.g. any
unlink() that is run).

There is no reason for waiting for the entire backlog to be
processed here. This really needs to be watermarked, so that when we
hit the high watermark we immediately sleep until the background
reclaim brings it back down below the low watermark.

In this case, we run about 20,000 inactivations/s, so inactivations
take about 50us to run. We want to limit the blocking of any given
process that is throttled to something controllable and practical.
e.g. 100ms, which indicates taht the high and low watermarks should
be somewhere around 5000 operations apart.

So, when something hits the high watermark, it sets a "queue
throttling" bit, forces the perag gc work to run immediately, and
goes to sleep on the throttle bit. Any new operations that hit that
perag also sleep on the "queue throttle" bit. When the GC work
brings the queue down below the low watermark, it wakes all the
waiters and keeps running, allowing user processes to add to the
queue again while it is draining it.

With this sort of setup, we shouldn't need really deep queues -
maybe a few thousand inodes at most - and we guarantee that the
background GC has a period of time where it largely has exclusive
access to the AGI and inode cluster buffers to run batched
inactivation as quickly as possible. We also largey bound the length
of time that user processes block on the background GC work, and
that will be good for keeping long tail latencies under control.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
