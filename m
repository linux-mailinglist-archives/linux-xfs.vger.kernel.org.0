Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BD335B495
	for <lists+linux-xfs@lfdr.de>; Sun, 11 Apr 2021 15:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhDKNWi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 11 Apr 2021 09:22:38 -0400
Received: from out20-50.mail.aliyun.com ([115.124.20.50]:40551 "EHLO
        out20-50.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhDKNWh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Apr 2021 09:22:37 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436282|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0535335-0.00142055-0.945046;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047212;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.JyK5W6v_1618147338;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.JyK5W6v_1618147338)
          by smtp.aliyun-inc.com(10.147.42.197);
          Sun, 11 Apr 2021 21:22:19 +0800
Date:   Sun, 11 Apr 2021 21:22:18 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: test that the needsrepair feature works as
 advertised
Message-ID: <YHL4CnofzF9JHcJw@desktop>
References: <161715288469.2703773.13448230101596914371.stgit@magnolia>
 <161715290127.2703773.4292037416016401516.stgit@magnolia>
 <YGSmKk88waono99E@bfoster>
 <20210402012402.GV1670408@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402012402.GV1670408@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 01, 2021 at 06:24:02PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 31, 2021 at 12:41:14PM -0400, Brian Foster wrote:
> > On Tue, Mar 30, 2021 at 06:08:21PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Make sure that the needsrepair feature flag can be cleared only by
> > > repair and that mounts are prohibited when the feature is set.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  common/xfs        |   21 +++++++++++
> > >  tests/xfs/768     |   82 +++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/768.out |    4 ++
> > >  tests/xfs/770     |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/770.out |    2 +
> > >  tests/xfs/group   |    2 +
> > >  6 files changed, 212 insertions(+)
> > >  create mode 100755 tests/xfs/768
> > >  create mode 100644 tests/xfs/768.out
> > >  create mode 100755 tests/xfs/770
> > >  create mode 100644 tests/xfs/770.out
> > > 
> > > 
> > ...
> > > diff --git a/tests/xfs/768 b/tests/xfs/768
> > > new file mode 100755
> > > index 00000000..7b909b76
> > > --- /dev/null
> > > +++ b/tests/xfs/768
> > > @@ -0,0 +1,82 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0-or-later
> > > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 768
> > > +#
> > > +# Make sure that the kernel won't mount a filesystem if repair forcibly sets
> > > +# NEEDSREPAIR while fixing metadata.  Corrupt a directory in such a way as
> > > +# to force repair to write an invalid dirent value as a sentinel to trigger a
> > > +# repair activity in a later phase.  Use a debug knob in xfs_repair to abort
> > > +# the repair immediately after forcing the flag on.
> > > +
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=`pwd`
> > > +tmp=/tmp/$$
> > > +status=1    # failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +
> > > +# real QA test starts here
> > > +_supported_fs xfs
> > > +_require_scratch
> > > +grep -q LIBXFS_DEBUG_WRITE_CRASH $XFS_REPAIR_PROG || \
> > > +		_notrun "libxfs write failure injection hook not detected?"
> > > +
> > > +rm -f $seqres.full
> > > +
> > > +# Set up a real filesystem for our actual test
> > > +_scratch_mkfs -m crc=1 >> $seqres.full
> > > +
> > > +# Create a directory large enough to have a dir data block.  2k worth of
> > > +# dirent names ought to do it.
> > > +_scratch_mount
> > > +mkdir -p $SCRATCH_MNT/fubar
> > > +for i in $(seq 0 256 2048); do
> > > +	fname=$(printf "%0255d" $i)
> > > +	ln -s -f urk $SCRATCH_MNT/fubar/$fname
> > > +done
> > > +inum=$(stat -c '%i' $SCRATCH_MNT/fubar)
> > > +_scratch_unmount
> > > +
> > > +# Fuzz the directory
> > > +_scratch_xfs_db -x -c "inode $inum" -c "dblock 0" \
> > > +	-c "fuzz -d bu[2].inumber add" >> $seqres.full
> > > +
> > > +# Try to repair the directory, force it to crash after setting needsrepair
> > > +LIBXFS_DEBUG_WRITE_CRASH=ddev=2 _scratch_xfs_repair 2>> $seqres.full
> > > +test $? -eq 137 || echo "repair should have been killed??"
> > > +_scratch_xfs_db -c 'version' >> $seqres.full
> > > +
> > > +# We can't mount, right?
> > > +_check_scratch_xfs_features NEEDSREPAIR
> > > +_try_scratch_mount &> $tmp.mount
> > > +res=$?
> > > +_filter_scratch < $tmp.mount
> > > +if [ $res -eq 0 ]; then
> > > +	echo "Should not be able to mount after needsrepair crash"
> > > +	_scratch_unmount
> > > +fi
> > > +
> > > +# Repair properly this time and retry the mount
> > > +_scratch_xfs_repair 2>> $seqres.full
> > > +_scratch_xfs_db -c 'version' >> $seqres.full
> > 
> > This _scratch_xfs_db() call and the same one a bit earlier both seem
> > spurious. Otherwise this test LGTM.
> 
> Ok, I'll get rid of those.
> 
> > 
> > > +_check_scratch_xfs_features NEEDSREPAIR
> > > +
> > > +_scratch_mount
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/768.out b/tests/xfs/768.out
> > > new file mode 100644
> > > index 00000000..1168ba25
> > > --- /dev/null
> > > +++ b/tests/xfs/768.out
> > > @@ -0,0 +1,4 @@
> > > +QA output created by 768
> > > +FEATURES: NEEDSREPAIR:YES
> > > +mount: SCRATCH_MNT: mount(2) system call failed: Structure needs cleaning.
> > > +FEATURES: NEEDSREPAIR:NO
> > > diff --git a/tests/xfs/770 b/tests/xfs/770
> > > new file mode 100755
> > > index 00000000..1d0effd9
> > > --- /dev/null
> > > +++ b/tests/xfs/770
> > > @@ -0,0 +1,101 @@
> > 
> > Can we have one test per patch in the future please?
> 
> No.  That will cost me a fortune in wasted time rebasing my fstests tree
> every time someone adds something to tests/*/group.
> 
> $ stg ser | wc -l
> 106
> 
> 106 patches total...
> 
> $ grep -l 'create mode' patches-djwong-dev/ | wc -l
> 29
> 
> 29 of which add a test case of some kind...
> 
> $ grep 'create mode.*out' patches-djwong-dev/* | wc -l
> 119
> 
> ...for a total of 119 new tests.  My fstests dev tree would double in
> size to 196 patches if I implemented that suggestion.  Every Sunday I
> rebase my fstests tree, and if it takes ~1min to resolve each merge
> error in tests/*/group, it'll now take me two hours instead of thirty

If the group files are the only confliction source, I think you could
leave that to me, as for these 7xx or 9xx tests, I'll always need to
re-number them and edit group files anyway. Or maybe you could just omit
the group file changes? Just leave a note in patch (after the three
dashes "---") on which groups it belongs to?

BTW, I've applied the first two patches in this patchset.

Thanks,
Eryu

> minutes to do this.
> 
> Please stop making requests of developers that increase their overhead
> while doing absolutely nothing to improve code quality.  The fstests
> maintainers have never required one test per patch, and it doesn't make
> sense to scatter related tests into multiple patches.
> 
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0-or-later
> > > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 770
> > > +#
> > > +# Populate a filesystem with all types of metadata, then run repair with the
> > > +# libxfs write failure trigger set to go after a single write.  Check that the
> > > +# injected error trips, causing repair to abort, that needsrepair is set on the
> > > +# fs, the kernel won't mount; and that a non-injecting repair run clears
> > > +# needsrepair and makes the filesystem mountable again.
> > > +#
> > > +# Repeat with the trip point set to successively higher numbers of writes until
> > > +# we hit ~200 writes or repair manages to run to completion without tripping.
> > > +
> > 
> > Nice test..
> > 
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=`pwd`
> > > +tmp=/tmp/$$
> > > +status=1    # failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/populate
> > > +. ./common/filter
> > > +
> > > +# real QA test starts here
> > > +_supported_fs xfs
> > > +
> > > +_require_scratch_xfs_crc		# needsrepair only exists for v5
> > > +_require_populate_commands
> > > +
> > > +rm -f ${RESULT_DIR}/require_scratch	# we take care of checking the fs
> > > +rm -f $seqres.full
> > > +
> > > +max_writes=200			# 200 loops should be enough for anyone
> > > +nr_incr=$((13 / TIME_FACTOR))
> > 
> > I'm not sure how time factor is typically used, but perhaps we should
> > sanity check that nr_incr > 0.
> 
> Good catch.
> 
> > Also, could we randomize the increment value a bit to add some variance
> > to the test? That could be done here or we could turn this into a min
> > increment value or something based on time factor and randomize the
> > increment in the loop, which might be a little more effective of a test.
> > 
> > > +test $nr_incr -lt 1 && nr_incr=1
> > > +for ((nr_writes = 1; nr_writes < max_writes; nr_writes += nr_incr)); do
> > > +	test -w /dev/ttyprintk && \
> > > +		echo "fail after $nr_writes writes" >> /dev/ttyprintk
> > > +	echo "fail after $nr_writes writes" >> $seqres.full
> > 
> > What is this for?
> 
> This synchronizes the kernel output with whatever step we're on of the
> loop.
> 
> > 
> > > +
> > > +	# Populate the filesystem
> > > +	_scratch_populate_cached nofill >> $seqres.full 2>&1
> > > +
> > 
> > If I understand this correctly, this will fill up the fs and populate
> > some kind of background cache with a metadump to facilitate restoring
> > the state on repeated calls. I see this speeds things up a bit from the
> > initial run, but I'm also wondering if we really need to reset this
> > state on every iteration. Would we expect much difference in behavior if
> > we populated once at the start of the test and then just bumped up the
> > write count until we get to the max or the repair completes?
> 
> Probably not?  You're probably right that there's no need to repopulate
> each time... provided that repair going down doesn't corrupt the fs and
> thereby screw up each further iteration.
> 
> (I noticed that repair can really mess things up if it dies in just the
> wrong places...)
> 
> > FWIW, a quick hack to test that out reduces my (cache cold, cache hot)
> > run times of this test from something like (~4m, ~1m) to (~3m, ~12s).
> > That's probably not quite quick group territory, but still a decent
> > time savings.
> 
> I mean ... I could just run fsstress for ~1000 ops to populate the
> filesystem.
> 
> > 
> > > +	# Start a repair and force it to abort after some number of writes
> > > +	LIBXFS_DEBUG_WRITE_CRASH=ddev=$nr_writes _scratch_xfs_repair 2>> $seqres.full
> > > +	res=$?
> > > +	if [ $res -ne 0 ] && [ $res -ne 137 ]; then
> > > +		echo "repair failed with $res??"
> > > +		break
> > > +	elif [ $res -eq 0 ]; then
> > > +		[ $nr_writes -eq 1 ] && \
> > > +			echo "ran to completion on the first try?"
> > > +		break
> > > +	fi
> > > +
> > > +	_scratch_xfs_db -c 'version' >> $seqres.full
> > 
> > Why?
> > 
> > > +	if _check_scratch_xfs_features NEEDSREPAIR > /dev/null; then
> > > +		# NEEDSREPAIR is set, so check that we can't mount.
> > > +		_try_scratch_mount &>> $seqres.full
> > > +		if [ $? -eq 0 ]; then
> > > +			echo "Should not be able to mount after repair crash"
> > > +			_scratch_unmount
> > > +		fi
> > 
> > Didn't the previous test verify that the filesystem doesn't mount if
> > NEEDSREPAIR?
> 
> Yes.  I'll remove them both.
> 
> --D
> 
> > > +	elif _scratch_xfs_repair -n &>> $seqres.full; then
> > > +		# NEEDSREPAIR was not set, but repair -n didn't find problems.
> > > +		# It's possible that the write failure injector triggered on
> > > +		# the write that clears NEEDSREPAIR.
> > > +		true
> > > +	else
> > > +		# NEEDSREPAIR was not set, but there are errors!
> > > +		echo "NEEDSREPAIR should be set on corrupt fs"
> > > +	fi
> > > +
> > > +	# Repair properly this time and retry the mount
> > > +	_scratch_xfs_repair 2>> $seqres.full
> > > +	_scratch_xfs_db -c 'version' >> $seqres.full
> > > +	_check_scratch_xfs_features NEEDSREPAIR > /dev/null && \
> > > +		echo "Repair failed to clear NEEDSREPAIR on the $nr_writes writes test"
> > > +
> > 
> > Same here. It probably makes sense to test that NEEDSREPAIR remains set
> > throughout the test sequence until repair completes cleanly, but I'm not
> > sure we need to repeat the mount cycle every go around.
> > 
> > Brian
> > 
> > > +	# Make sure all the checking tools think this fs is ok
> > > +	_scratch_mount
> > > +	_check_scratch_fs
> > > +	_scratch_unmount
> > > +done
> > > +
> > > +# success, all done
> > > +echo Silence is golden.
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/770.out b/tests/xfs/770.out
> > > new file mode 100644
> > > index 00000000..725d740b
> > > --- /dev/null
> > > +++ b/tests/xfs/770.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 770
> > > +Silence is golden.
> > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > index fe83f82d..09fddb5a 100644
> > > --- a/tests/xfs/group
> > > +++ b/tests/xfs/group
> > > @@ -520,3 +520,5 @@
> > >  537 auto quick
> > >  538 auto stress
> > >  539 auto quick mount
> > > +768 auto quick repair
> > > +770 auto repair
> > > 
> > 
