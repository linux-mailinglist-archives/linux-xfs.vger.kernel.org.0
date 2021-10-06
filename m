Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE16424953
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Oct 2021 23:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239795AbhJFWAs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 Oct 2021 18:00:48 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:39391 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230213AbhJFWAr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Oct 2021 18:00:47 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 1BC04108FDD;
        Thu,  7 Oct 2021 08:58:52 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mYEw7-003Gm8-Mk; Thu, 07 Oct 2021 08:58:51 +1100
Date:   Thu, 7 Oct 2021 08:58:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: Performance regression with async inode inactivation
Message-ID: <20211006215851.GD54211@dread.disaster.area>
References: <20211004100653.GD2255@quack2.suse.cz>
 <20211004211508.GB54211@dread.disaster.area>
 <20211005081157.GA24625@quack2.suse.cz>
 <20211005212608.GC54211@dread.disaster.area>
 <20211006181001.GA4182@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006181001.GA4182@quack2.suse.cz>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=615e1c1d
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=O-SGdtmWAAAA:8 a=7-415B0cAAAA:8
        a=oLu2DbYKX3MkYjkvUikA:9 a=6IYuQBECoyV5zZui:21 a=CjuIK1q_8ugA:10
        a=WfKnyQRuveJGjnbptWa9:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 06, 2021 at 08:10:01PM +0200, Jan Kara wrote:
> On Wed 06-10-21 08:26:08, Dave Chinner wrote:
> > On Tue, Oct 05, 2021 at 10:11:57AM +0200, Jan Kara wrote:
> > > On Tue 05-10-21 08:15:08, Dave Chinner wrote:
> > > > On Mon, Oct 04, 2021 at 12:06:53PM +0200, Jan Kara wrote:
> > > > > Hello,
> > > > > 
> > > > > our performance testing grid has detected a performance regression caused
> > > > > by commit ab23a77687 ("xfs: per-cpu deferred inode inactivation queues")
> > > > > with reaim benchmark running 'disk' and 'disk-large' workloads. The
> > > > > regression has been so far detected on two machines - marvin7 (48 cpus, 64
> > > > > GB ram, SATA SSD), dobby (64 cpus, 192 GB ram, rotating disk behind
> > > > > megaraid_sas controller).
> > > > 
> > > > Yup, large cpu count, single slow disk, and the cause will likely be
> > > > exclusive rwsem lock contention on a directory inode that concurrent
> > > > openat and unlink are occuring in.
> > > > 
> > > > Basically, that commit removed a bunch of userspace overhead in
> > > > unlinks, when mean they run as fast as the unlink() call can remove
> > > > the directory entry. There is effectively nothing throttling
> > > > unlink() in XFS now except for available log space and it mostly
> > > > runs to completion without blocking. Hence the front end unlink
> > > > performance can run in much faster bursts before delayed
> > > > inactivation needs to run.
> > > > 
> > > > Given most of the added CPU overhead is in the rwsem spin_on_owner
> > > > path, it implies that the write lock holder is, indeed, not sleeping
> > > > with the lock held. Hence reaim is hitting a borderline contended
> > > > rwsem much harder and with different behaviour, resulting in
> > > > catastrophic breakdown of lock performance and hence unlink
> > > > performance goes backwards.
> > > > 
> > > > I can't see any other new sleeping lock contention in the workload
> > > > profiles - the context switch rate goes down substantially (by 35%!)
> > > > with commit ab23a77687, which also implies that the lock contention
> > > > is resulting in much longer spin and/or sleep times on the lock.
> > > > 
> > > > I'm not sure we can do anything about this in the filesystem. The
> > > > contended lock is a core, high level VFS lock which is the first
> > > > point of unlinkat() syscall serialisation. This is the lock that is
> > > > directly exposed to userspace concurrency, so the scalability of
> > > > this lock determines concurrency performance of the userspace
> > > > application.....
> > > 
> > > Thanks for explanation! It makes sense, except one difference I can see in
> > > vmstat on both marvin7 and dobby which I don't understand:
> > > 
> > > Dobby:
> > > Ops Sector Reads                     1009081.00     1009081.00
> > > Ops Sector Writes                   11550795.00    18753764.00
> > > 
> > > Marvin7:
> > > Ops Sector Reads                      887951.00      887951.00
> > > Ops Sector Writes                    8248822.00    11135086.00
> > > 
> > > So after the change reaim ends up doing noticeably more writes. I had a
> > > look at iostat comparison as well but there wasn't anything particular
> > > standing out besides higher amount of writes on the test disk. I guess,
> > > I'll limit the number of clients to a single number showing the regression,
> > > enable some more detailed monitoring and see whether something interesting
> > > pops up.
> > 
> > Interesting.
> > 
> > There weren't iostats in the original intel profiles given. I
> > can see a couple of vmstats that give some indications -
> > vmstat.io.bo went up from ~2500 to ~6000, and proc-vmstat.pgpgout
> > went up from ~90k to 250k.
> > 
> > Looking at another more recent profile, there are more IO related
> > stats in the output vmstat.nr_written went up by 2.5x and
> > vmstat.pgpgout went up by a factor of 6 (50k -> 300k) but otherwise
> > everything else was fairly constant in the VM. The resident size of
> > the file cache is small, and vmstat.nr_dirtied went up by a small
> > ammount by it's 4 orders of magnitude larger than nr_written.
> > 
> > Hmmm. That implies a *lot* of overwrite of cached files.
> > 
> > I wonder if we've just changed the memory pressure enough to trigger
> > more frequent writeback? We're delaying the inactivation (and hence
> > page cache invalidation) of up to 256 inodes per CPU, and the number
> > of cached+dirty inodes appears to have increased a small amount
> > (from ~3000 to ~4000). With slow disks, a small change in writeback
> > behaviour could cause seek-bound related performance regressions.
> > 
> > Also worth noting is that there's been some recent variance in reaim
> > numbers recently because of the journal FUA/flush optimisations
> > we've made.  Some machines report +20% from that change, some report
> > -20%, and there's no pattern to it. It's just another indication
> > that the reaim scalability and perf on these large CPU count, single
> > spinning disk setups is highly dependent on disk performance and
> > seek optimisation...
> > 
> > Have you run any tests on a system that isn't stupidly overpowered
> > for it's disk subsystem? e.g. has an SSD rather than spinning rust?
> 
> So marvin7 actually has SSD. I was experimenting some more. Attached is a
> simple reproducer that demonstrates the issue for me - it just creates 16k
> file, fsync it, delete it in a loop from given number processes (I run with
> 48). The reproducer runs ~25% slower after the commit ab23a77687. Note that
> the reproducer makes each process use a different directory so i_rwsem
> contention is out of question.
> 
> From blktrace I can see that indeed after the commit we do ~25% more
> writes.  Each stress-unlink process does the same amount of IO, the extra
> IO comes solely from the worker threads.

So the question is "which worker thread?".

> Also I'd note that before the
> commit we were reusing blocks much more (likely inode blocks getting
> reused) - before the commit we write to ~88 MB worth of distinct disk
> blocks, after the commit we write to ~296 MB worth of distinct disk blocks.

Hmmm, I didn't see this at first.  What's the filesystem layout
(xfs_info) and the CLI for the test that you ran? How many CPUs was
the test run on?

Running a test with 100 procs across 32p, so creating 100 dirs and
10000 files, on a 1.4TB SSD:

$ xfs_info /mnt/scratch
meta-data=/dev/mapper/fast       isize=512    agcount=67, agsize=5467072 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=366292480, imaxpct=5
         =                       sunit=64     swidth=256 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=512000, version=2
         =                       sectsz=512   sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ ./stress-unlink 100 /mnt/scratch
0.301
$


The total number of inode cluster writes is:

$ pminfo -f xfs.icluster_flushcnt

xfs.icluster_flushcnt
    value 68

That's 68 * 32kB or about 2MB.

[pminfo is part of Performance Co-Pilot - https://pcp.io/]

We did this many user writes:

$ pminfo -f xfs.write xfs.write_bytes

xfs.write
    value 10000

    xfs.write_bytes
        value 163840000

which is 160MB in 10000 writes.

Metadata writeback was:

$ pminfo -f xfs.log_tail.push_ail.success 

xfs.log_tail.push_ail.success
    value 473

473 buffers, part of which was 68 inode clusters so the total is
about ~400 x 4kB + 2MB = 3.6MB.

So, really, there isn't a potential for 25% growth in these numbers
that would make any sort of difference. The only remaining source of
IO differential is log writes:

$ pminfo -f xfs.log

xfs.log.writes
    value 1055

    xfs.log.blocks
        value 28212
....

Which indicates another ~1000 IOs and ~28MB written.

And that's it. We've got a total of about 195MB written to disk for
100 concurrent runs, and it's no different before and after deferred
inactivation. Other tests that I commonly run that do lots of file
creates and unlinks along with sync writes (e.g. dbench) didn't show
any regressions up to 512 concurrent processes, either. So there's
no obvious regression on this filesystem layout....

But it made me wonder - there are two things that could influence
background inactivation here: the AG count (which determines unlink
concurrency) and log size (which determines transaction
concurrency). So I remade the filesystem with a tiny 32MB log and 2
AGs, and that changed a -lot-:

xfs.icluster_flushcnt
    value 40420

xfs.log_tail.push_ail.success
    value 46098

Yeah, we did 40,000 inode cluster writes for only 10000 inode
modifications. Basically, we wrote every inode cluster once for
every inode modification (post create, post write, post unlink, post
deferred activation). Normally create/unlink loops the inode doesn't
even touch the disk - it's cancelled in the log before it gets
flushed to disk and so this is where a chunk of the difference in
disk space consumed comes from. It can be expected behaviour.

xfs.log_tail.push_ail.pinned
    value 84381

And we hit pinned items in the AIL 85,000 times instead of 0. This
triggers more log forces, but fsync is already doing that so it's
not a big deal. However:

xfs.log_tail.try_logspace
    value 80392

xfs.log_tail.sleep_logspace
     value 59938

75% of the operations had to wait on log space, which means it's
forcing the log tail to flush metadata to make space. That's where
all the inode cluster writes are coming from - the transactions are
lock stepping on log space. i.e. every time we want to modify an
inode, we have to flush a dirty inode to make space in the log.

This also means that the CIL can't perform efficient in-memory
transaction aggregation because it's always being forced out to
disk. As a result:

xfs.log.writes
    value 6504

    xfs.log.blocks
        value 65784

6x as many log writes, for 65MB of log writes. IOWs, the smaller log
reduced CIL aggregation efficiency substantially and so we wrote
twice as much to the log just because we had a small log.

So, the question needs to be asked: is this a function of a small
log, or is this behaviour of low AG count?

Increasing AG count back out to > CPU count resulted in the number
of inode cluster flushes dropping to ~3000, and the log writes
dropping back down to 1000 and 28MB of log writes. Performance went
way up, too (from 1.8s down to 0.35s), indicating that AG
concurrency is a factor here.

OTOH, leaving the AG count at 2 and increasing the log back out to
2GB removed all the log space waiting, all the inode cluster
flushing, and everything to do with waiting on log space. But
performance barely changed (1.8s down to 1.5s) and log bandwidth
*went up*:

xfs.log.writes
    value 6528

xfs.log.blocks
    value 135452

6,500 log writes, 130MB written to the log. IOWs, both too-small log
space and too-low AG count for the given workload concurrency will
adversely affect performance of concurrent workloads.

But we already knew that, didn't we? :/

Bumping the AG count from 2 to 16 and using a moderately sized log
(i.e. > 100MB) largely erases the bad behaviour. Indeed, agcount=16,
log size=100MB drops runtime to 0.30s and pretty much returns inode
write count and log write/bw back down to minimums on this 100
process workload.

But to point out that this isn't perfect for everything, if I run
the same test with 1000 processes on that config, it takes 6.2s,
writes 400MB to the log and flushes 153,000 inode clusters. We're
back to not having enough log space for the workload. Bumping out to
agcount=67 (2x CPU count) and max log size(2GB) results in runtime
of 3.5s (largely linear from the 100 process count), no inode
writeback and only 200MB of log throughput.

So, yeah, I suspect that if you change the mkfs parameters for the
reaim tests to have more AGs and significantly increased log space
over the defaults, the regression should disappear...

Can you run these experiments with reaim on your test machines and
see if they are influenced by filesystem level concurrency
parameters like AG count and log size as these tests suggest?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
