Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB281DFBBC
	for <lists+linux-xfs@lfdr.de>; Sun, 24 May 2020 01:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388163AbgEWXX1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 23 May 2020 19:23:27 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:55373 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388047AbgEWXX1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 19:23:27 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 3AD185AAC26;
        Sun, 24 May 2020 09:23:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jcdU7-00013X-Ld; Sun, 24 May 2020 09:23:19 +1000
Date:   Sun, 24 May 2020 09:23:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/24] xfs: rework xfs_iflush_cluster() dirty inode
 iteration
Message-ID: <20200523232319.GN2040@dread.disaster.area>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-23-david@fromorbit.com>
 <20200523113131.GA1421@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523113131.GA1421@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=ZwvmMwvMBbo4siNA7CYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 23, 2020 at 04:31:31AM -0700, Christoph Hellwig wrote:
> On Fri, May 22, 2020 at 01:50:27PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that we have all the dirty inodes attached to the cluster
> > buffer, we don't actually have to do radix tree lookups to find
> > them. Sure, the radix tree is efficient, but walking a linked list
> > of just the dirty inodes attached to the buffer is much better.
> > 
> > We are also no longer dependent on having a locked inode passed into
> > the function to determine where to start the lookup. This means we
> > can drop it from the function call and treat all inodes the same.
> > 
> > We also make xfs_iflush_cluster skip inodes marked with
> > XFS_IRECLAIM. This we avoid races with inodes that reclaim is
> > actively referencing or are being re-initialised by inode lookup. If
> > they are actually dirty, they'll get written by a future cluster
> > flush....
> > 
> > We also add a shutdown check after obtaining the flush lock so that
> > we catch inodes that are dirty in memory and may have inconsistent
> > state due to the shutdown in progress. We abort these inodes
> > directly and so they remove themselves directly from the buffer list
> > and the AIL rather than having to wait for the buffer to be failed
> > and callbacks run to be processed correctly.
> 
> I suspect we should just kill off xfs_iflush_cluster with this, as it
> is best split between xfs_iflush and xfs_inode_item_push.  POC patch
> below, but as part of that I noticed some really odd error handling,
> which I'll bring up separately.

That's the exact opposite way the follow-on patchset I have goes.
xfs_inode_item_push() goes away entirely because tracking 30+ inodes
in the AIL for a single writeback IO event is amazingly inefficient
and consumes huge amounts of CPU unnecessarily.

IOWs, the original point of pinning the inode cluster buffer
directly at inode dirtying was so we could track dirty inodes in the
AIL via the cluster buffer instead of individually as inodes.  The
AIL drops by a factor of 30 in size, and instead of seeing 10,000
inode item push "success" reports and 300,000 "flushing" reports a
second, we only see the 10,000 success reports.

IOWs, the xfsaild is CPU bound in highly concurrent inode dirtying
workloads because of the massive numbers of inodes we cycle through
it. Tracking them by cluster buffer reduces the CPU over of the
xfsaild substantially. The whole "hang on, this solves the OOM kill
problem with async reclaim" was a happy accident - I didn't start
this patch set with the intent of fixing inode reclaim, it started
because inode tracking in the AIL is highly inefficient...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
