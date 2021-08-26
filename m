Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC30C3F7F78
	for <lists+linux-xfs@lfdr.de>; Thu, 26 Aug 2021 02:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbhHZAsk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Aug 2021 20:48:40 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:38485 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232139AbhHZAsk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Aug 2021 20:48:40 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id B7E1F80BC68;
        Thu, 26 Aug 2021 10:47:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mJ3YZ-004z1w-5r; Thu, 26 Aug 2021 10:47:47 +1000
Date:   Thu, 26 Aug 2021 10:47:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests <fstests@vger.kernel.org>
Subject: Re: [RFC PATCH] xfs: test DONTCACHE behavior with the inode cache
Message-ID: <20210826004747.GF2566745@dread.disaster.area>
References: <20210824023208.392670-1-david@fromorbit.com>
 <20210825230703.GH12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825230703.GH12640@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=Xd9sp4hcKj-9Yvhc1GYA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 25, 2021 at 04:07:03PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Basic testing that DONTCACHE affects the XFS inode cache in the manner
> that we expect.  The only way we can do that (for XFS, anyway) is to
> play around with the BULKSTAT ioctl.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/780     |  293 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/780.out |    7 +
>  2 files changed, 300 insertions(+)
>  create mode 100755 tests/xfs/780
>  create mode 100644 tests/xfs/780.out
> 
> diff --git a/tests/xfs/780 b/tests/xfs/780
> new file mode 100755
> index 00000000..9bf1f482
> --- /dev/null
> +++ b/tests/xfs/780
> @@ -0,0 +1,293 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 780
> +#
> +# Functional testing for the I_DONTCACHE inode flag, as set by the BULKSTAT
> +# ioctl.  This flag neuters the inode cache's tendency to try to hang on to
> +# incore inodes for a while after the last program closes the file, which
> +# is helpful for filesystem scanners to avoid trashing the inode cache.
> +#
> +# However, the inode cache doesn't always honor the DONTCACHE behavior -- the
> +# only time it really applies is to cache misses from a bulkstat scan.  If
> +# any other threads accessed the inode before or immediately after the scan,
> +# the DONTCACHE flag is ignored.  This includes other scans.
> +#
> +# Regrettably, there is no way to poke /only/ XFS inode reclamation directly,
> +# so we're stuck with setting xfssyncd_centisecs to a low value and watching
> +# the slab counters.
> +#
> +. ./common/preamble
> +_begin_fstest auto ioctl
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +	test -n "$junkdir" && rm -r -f "$junkdir"
> +	test -n "$old_centisecs" && echo "$old_centisecs" > "$xfs_centisecs_file"
> +}
> +
> +# Import common functions.
> +# . ./common/filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_test
> +
> +# Either of these need to be available to monitor slab usage
> +xfs_ino_objcount_file=/sys/kernel/slab/xfs_inode/objects
> +slabinfo_file=/proc/slabinfo
> +if [ ! -r "$xfs_ino_objcount_file" ] && [ ! -r "$slabinfo_file" ]; then
> +	_notrun "Cannot find xfs_inode slab count?"
> +fi

WE should use the either /proc/fs/xfs/stat or
/sys/fs/xfs/<dev>/stats to get this information.

$ awk '/vnodes/ { print $2}' /proc/fs/xfs/stat
245626
$ awk '/vnodes/ { print $2}' /sys/fs/xfs/dm-0/stats/stats
245648

> +# Background reclamation of disused xfs inodes is scheduled for $xfssyncd
> +# centiseconds after the first inode is tagged for reclamation.  It's not great

Actually, the background inode reclaim period $((xfssyncd / 6)),
which means it is 5 seconds by default.

> +# to encode this implementation detail in a test like this, but there isn't
> +# any means to trigger *only* inode cache reclaim -- actual memory pressure
> +# can trigger the VFS to drop non-DONTCACHE inodes, which is not what we want.
> +xfs_centisecs_file=/proc/sys/fs/xfs/xfssyncd_centisecs
> +test -w "$xfs_centisecs_file" || _notrun "Cannot find xfssyncd_centisecs?"
> +
> +# Set the syncd knob to the minimum value 100cs (aka 1s) 
> +old_centisecs="$(cat "$xfs_centisecs_file")"
> +echo 100 > "$xfs_centisecs_file" || _notrun "Cannot adjust xfssyncd_centisecs?"
> +delay_centisecs="$(cat "$xfs_centisecs_file")"
> +
> +# Sleep one second more than the xfssyncd delay to give background inode
> +# reclaim enough time to run.
> +sleep_seconds=$(( ( (99 + delay_centisecs) / 100) + 1))

I hate centiseconds.

> +
> +count_xfs_inode_objs() {
> +	if [ -r "$xfs_ino_objcount_file" ]; then
> +		cat "$xfs_ino_objcount_file" | cut -d ' ' -f 1
> +	elif [ -r "$slabinfo_file" ]; then
> +		grep -w '^xfs_inode' "$slabinfo_file" | awk '{print $2}'
> +	else
> +		echo "ERROR"
> +	fi
> +}
> +
> +junkdir=$TEST_DIR/$seq.junk
> +nr_cpus=$(getconf _NPROCESSORS_ONLN)

This would probably be much easier using the scratch device and
/sys/fs/xfs/<SCRATCH_DEV>/stats/stats, because then the baseline is
effectively zero...

> +# Sample the baseline count of cached inodes after a fresh remount.
> +_test_cycle_mount
> +baseline_count=$(count_xfs_inode_objs)
> +
> +# Create a junk directory with about a thousand files.
> +nr_files=1024
> +mkdir -p $junkdir
> +for ((i = 0; i < nr_files; i++)); do
> +	touch "$junkdir/$i"
> +done
> +new_files=$(find $junkdir | wc -l)
> +echo "created $new_files files" >> $seqres.full
> +test "$new_files" -gt "$nr_files" || \
> +	echo "created $new_files files, expected $nr_files"
> +
> +# Sanity check: Make sure that all those new inodes are still in the cache.
> +# We assume that memory limits are not so low that reclaim started for a bunch
> +# of empty files.
> +work_count=$(count_xfs_inode_objs)
> +test "$work_count" -ge "$new_files" || \
> +	echo "found $work_count cached inodes after creating $new_files files?"

Might be better as:

_within_tolerance "Cached inode after creating new files" $work_count $new_files 5

> +
> +# Round 1: Check the DONTCACHE behavior when it is invoked once per inode.
> +# The inodes should be reclaimed if we wait long enough.
> +echo "Round 1"
> +
> +# Sample again to see if we're still within the baseline.
> +_test_cycle_mount
> +fresh_count=$(count_xfs_inode_objs)
> +
> +# Run bulkstat to exercise DONTCACHE behavior, and sample again.
> +$here/src/bstat -q $junkdir
> +post_count=$(count_xfs_inode_objs)

Can we use xfs_io -c "bulkstat" here?

I'd like to get rid of $here/src/bstat now that we have bulkstat
functionality in xfs_io....

> +
> +# Let background reclaim run
> +sleep $sleep_seconds
> +end_count=$(count_xfs_inode_objs)
> +
> +# Even with our greatly reduced syncd value, the inodes should still be in
> +# memory immediately after the second bulkstat concludes.
> +test "$post_count" -ge "$new_files" || \
> +	echo "found $post_count cached inodes after bulkstat $new_files files?"
> +
> +# After we've let memory reclaim run, the inodes should no longer be cached
> +# in memory.
> +test "$end_count" -le "$new_files" || \
> +	echo "found $end_count cached inodes after letting $new_files DONTCACHE files expire?"
> +
> +# Dump full results for debugging
> +cat >> $seqres.full << ENDL
> +round1 baseline: $baseline_count
> +work: $work_count
> +fresh: $fresh_count
> +post: $post_count
> +end: $end_count
> +ENDL

Wrap this in a function to reduce verbosity?

debug_output()
{
	cat >> $seqres.full << ENDL
round $1 baseline: $2
work: $3
fresh: $4
post: $5
end: $6
ENDL
}

debug_output 1 $baseline_count $work_count $fresh_count $post_count $end_count

> +
> +# Round 2: Check the DONTCACHE behavior when it is invoked multiple times per
> +# inode in rapid succession.  The inodes should remain in memory even after
> +# reclaim because the cache gets wise to repeated scans.
> +echo "Round 2"
> +
> +# Sample again to see if we're still within the baseline.
> +_test_cycle_mount
> +fresh_count=$(count_xfs_inode_objs)
> +
> +# Run bulkstat twice in rapid succession to exercise DONTCACHE behavior.
> +# The first bulkstat run will bring the inodes into memory (marked DONTCACHE).
> +# The second bulkstat causes cache hits before the inodes can reclaimed, which
> +# means that they should stay in memory.  Sample again afterwards.
> +$here/src/bstat -q $junkdir
> +$here/src/bstat -q $junkdir
> +post_count=$(count_xfs_inode_objs)
> +
> +# Let background reclaim run
> +sleep $sleep_seconds
> +end_count=$(count_xfs_inode_objs)
> +
> +# Even with our greatly reduced syncd value, the inodes should still be in
> +# memory immediately after the second bulkstat concludes.
> +test "$post_count" -ge "$new_files" || \
> +	echo "found $post_count cached inodes after bulkstat $new_files files?"
> +
> +# After we've let memory reclaim run and cache hits happen, the inodes should
> +# still be cached in memory.
> +test "$end_count" -ge "$new_files" || \
> +	echo "found $end_count cached inodes after letting $new_files DONTCACHE files expire?"
> +
> +# Dump full results for debugging
> +cat >> $seqres.full << ENDL
> +round2 baseline: $baseline_count
> +work: $work_count
> +fresh: $fresh_count
> +post: $post_count
> +end: $end_count
> +ENDL

I'm struggling to see what is being tested amongst all the comments.
Can you chop down the comments to a single "round X" comment per
test?

[...]

> +# Even with our greatly reduced syncd value, the inodes should still be in
> +# memory immediately after the second bulkstat concludes.
> +test "$post_count" -ge "$new_files" || \
> +	echo "found $post_count cached inodes after bulkstat $new_files files?"
> +
> +# After we've let memory reclaim run, the inodes should stll be cached in
> +# memory because we opened everything.
> +test "$end_count" -ge "$new_files" || \
> +	echo "found $end_count cached inodes after letting $new_files DONTCACHE files expire?"
> +
> +# Dump full results for debugging
> +cat >> $seqres.full << ENDL
> +round5 baseline: $baseline_count
> +work: $work_count
> +fresh: $fresh_count
> +post: $post_count
> +end: $end_count
> +ENDL
> +
> +echo Silence is golden

There is output on success, so no need for this.

But overall it looks like you've captured the behaviour that should
be occurring with bulkstat and DONTCACHE.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
