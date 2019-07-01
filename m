Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 031D1447C3
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 19:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbfFMRBh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 13:01:37 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:43379 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729567AbfFLXeE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 19:34:04 -0400
Received: from dread.disaster.area (pa49-195-189-25.pa.nsw.optusnet.com.au [49.195.189.25])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 9269A3DC55E;
        Thu, 13 Jun 2019 09:34:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hbCjm-0003ot-S4; Thu, 13 Jun 2019 09:33:02 +1000
Date:   Thu, 13 Jun 2019 09:33:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 02/10] xfs: convert quotacheck to use the new iwalk
 functions
Message-ID: <20190612233302.GG14363@dread.disaster.area>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968498085.1657646.3518168545540841602.stgit@magnolia>
 <20190610135848.GB6473@bfoster>
 <20190611232347.GE14363@dread.disaster.area>
 <20190612003219.GV1871505@magnolia>
 <20190612125506.GE12395@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612125506.GE12395@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=K5LJ/TdJMXINHCwnwvH1bQ==:117 a=K5LJ/TdJMXINHCwnwvH1bQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=dq6fvYVFJ5YA:10
        a=7-415B0cAAAA:8 a=OyNWoYibOR24XX5vsfwA:9 a=jT7GqvZWwFC8Y1ZD:21
        a=7V8G_FsW8zfWWrG8:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 12, 2019 at 08:55:06AM -0400, Brian Foster wrote:
> On Tue, Jun 11, 2019 at 05:32:19PM -0700, Darrick J. Wong wrote:
> > On Wed, Jun 12, 2019 at 09:23:47AM +1000, Dave Chinner wrote:
> Since we're already discussing tweaks to readahead, another approach to
> this problem could be to try and readahead all the way into the inode
> cache. For example, consider a mechanism where a cluster buffer
> readahead sets a flag on the buffer that effectively triggers an iget of
> each allocated inode in the buffer. Darrick has already shown that the
> inode memory allocation and iget itself has considerable overhead even
> when the cluster buffer is already cached. We know that's not due to
> btree lookups because quotacheck isn't using IGET_UNTRUSTED, so perhaps
> we could amortize more of this cost via readahead.

The DONTCACHE inode caching semantics of bulkstat tend to conflict
with "readahead all the way to the inode cache".

> The caveats are that would probably be more involved than something that
> just caches the current cluster buffer and passes it into the iget path.
> We'd have to rectify readahead in-core inodes against DONTCACHE inodes
> used by bulkstat, for example, though I don't think that would be too
> difficult to address via a new inode readahead flag or some such
> preserve existing DONTCACHE behavior.

I did try that once, the cache thrashing was .... difficult to
contain under memory pressure. bulkstat pushes hundreds of thousands
of inodes a second through the inode cache, and under memory
pressure it will still cause working set perturbation with DONTCACHE
being set. Holding DONTCACHE inodes for some time in the cache kinda
defeats the simple purpose it has, and relying on cache hits to
convert "readahead" to "dont cache" becomes really nasty when we
try to use inode readahead for other things (like speeding up
directory traversals by having xfs_readdir() issue inode readahead).

The largest delay in bulkstat is the inode cluster IO latency.
Getting rid of that is where the biggest win is (hence cluster
read-ahead). The second largest overhead is the CPU burnt doing
inode lookups, and on filesystems with lots of inodes, a significant
amount of that is in the IGET_UNTRUSTED inobt lookup. IOWs, avoiding
GET_UNTRUSTED is relatively low hanging fruit.

The next limitation for bulkstat is the superblock inode list lock
contention. Getting rid of the IGET_UNTRUSTED overhead is likely to
push the lock contention into the severe range (the lock is already
the largest CPU consumer at 16 threads bulkstating 600,000 inodes/s
on a 16p machine) so until we get rid of that lock contention, there
isn't much point in doing major rework to the bulkstat algorithm as
it doesn't address the limitations that the current algorithm has.

> It's also likely that passing the buffer into iget would already address
> most of the overhead associated with the buffer lookup, so there might
> not be enough tangible benefit at that point. The positive is that it's
> probably an incremental step on top of an "iget from an existing cluster
> buffer" mechanism and so could be easily prototyped by hacking in a read
> side b_iodone handler or something.

We don't want to put inode cache insertion into a IO completion
routine. Tried it, caused horrible problems with metadata read IO
latency and substantially increased inode cache lock contention by
bouncing the radix trees around both submission and completion CPU
contexts...

/me has spent many, many years trying lots of different ways to make
the inode cache in XFS go faster and has failed most of the time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
