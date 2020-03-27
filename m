Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66D4E194EE4
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Mar 2020 03:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgC0C1S (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 26 Mar 2020 22:27:18 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58484 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726363AbgC0C1S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 22:27:18 -0400
Received: from dread.disaster.area (pa49-179-23-206.pa.nsw.optusnet.com.au [49.179.23.206])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id AEEE47EA560;
        Fri, 27 Mar 2020 13:27:15 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jHeiI-0006tv-JL; Fri, 27 Mar 2020 13:27:14 +1100
Date:   Fri, 27 Mar 2020 13:27:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't flush the entire filesystem when a buffered
 write runs out of space
Message-ID: <20200327022714.GQ10776@dread.disaster.area>
References: <20200327014558.GG29339@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327014558.GG29339@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=n/Z79dAqQwRlp4tcgfhWYA==:117 a=n/Z79dAqQwRlp4tcgfhWYA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=5sD5YOzk50rdTkS6xSUA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 26, 2020 at 06:45:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> A customer reported rcu stalls and softlockup warnings on a computer
> with many CPU cores and many many more IO threads trying to write to a
> filesystem that is totally out of space.  Subsequent analysis pointed to
> the many many IO threads calling xfs_flush_inodes -> sync_inodes_sb,
> which causes a lot of wb_writeback_work to be queued.  The writeback
> worker spends so much time trying to wake the many many threads waiting
> for writeback completion that it trips the softlockup detector, and (in
> this case) the system automatically reboots.

That doesn't sound right. Each writeback work that is queued via
sync_inodes_sb should only have a single process waiting on it's
completion. And how many threads do you actually have to need to
wake up for it to trigger a 10s soft-lockup timeout?

More detail, please?

> In addition, they complain that the lengthy xfs_flush_inodes scan traps
> all of those threads in uninterruptible sleep, which hampers their
> ability to kill the program or do anything else to escape the situation.
> 
> Fix this by replacing the full filesystem flush (which is offloaded to a
> workqueue which we then have to wait for) with directly flushing the
> file that we're trying to write.

Which does nothing to flush -other- outstanding delalloc
reservations and allow the eofblocks/cowblock scan to reclaim unused
post-EOF speculative preallocations.

That's the purpose of the xfs_flush_inodes() - without it we can get
very premature ENOSPC, especially on small filesystems when writing
largish files in the background. So I'm not sure that dropping the
sync is a viable solution. It is actually needed.

Perhaps we need to go back to the ancient code thatonly allowed XFS
to run a single xfs_flush_inodes() at a time - everything else
waited on the single flush to complete, then all returned at the
same time...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
