Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B073367F86
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Apr 2021 13:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbhDVLZr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 22 Apr 2021 07:25:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33657 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236008AbhDVLZr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Apr 2021 07:25:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619090712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SEClYM3ohj1z4q6WWZOpYnJVfezJGkYSrY6DJzb9yYQ=;
        b=PP4ke3SNd+mqvAk7i2B6HnyamrUmPds3UoFxwWs7qDPB2k4qDvoi1i6HIVbVpWnX23Ln5v
        66FD//Ukj6I8seOOJkqPzMZxVsOLpP8Bai8ugBQHeaGYHL4Jc+gPaXa8O6byaYdot5cjSS
        6C5q1DD63dp/Vq4vUjROJYIycaYnaVs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-eHiZe1RZPVykr49MuDhZmQ-1; Thu, 22 Apr 2021 07:25:08 -0400
X-MC-Unique: eHiZe1RZPVykr49MuDhZmQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B287F64149;
        Thu, 22 Apr 2021 11:25:07 +0000 (UTC)
Received: from bfoster (ovpn-112-25.rdu2.redhat.com [10.10.112.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D9071669EB;
        Thu, 22 Apr 2021 11:25:06 +0000 (UTC)
Date:   Thu, 22 Apr 2021 07:25:05 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/1] xfs: test that the needsrepair feature works as
 advertised
Message-ID: <YIFdEWV5StltoTBQ@bfoster>
References: <161896455503.776294.3492113564046201298.stgit@magnolia>
 <161896456107.776294.13840945585349427098.stgit@magnolia>
 <YIBhAPo25d9GTAC8@bfoster>
 <20210421203746.GE3122235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421203746.GE3122235@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 01:37:46PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 21, 2021 at 01:29:36PM -0400, Brian Foster wrote:
> > On Tue, Apr 20, 2021 at 05:22:41PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Make sure that the needsrepair feature flag can be cleared only by
> > > repair and that mounts are prohibited when the feature is set.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  common/xfs        |   28 ++++++++++++++++++
> > >  tests/xfs/768     |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/768.out |    4 +++
> > >  tests/xfs/770     |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/770.out |    2 +
> > >  tests/xfs/group   |    2 +
> > >  6 files changed, 199 insertions(+)
> > >  create mode 100755 tests/xfs/768
> > >  create mode 100644 tests/xfs/768.out
> > >  create mode 100755 tests/xfs/770
> > >  create mode 100644 tests/xfs/770.out
> > > 
> > > 
...
> > > diff --git a/tests/xfs/770 b/tests/xfs/770
> > > new file mode 100755
> > > index 00000000..40e67ab5
> > > --- /dev/null
> > > +++ b/tests/xfs/770
> > > @@ -0,0 +1,83 @@
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
> > > +_require_scratch_nocheck
> > > +_require_scratch_xfs_crc		# needsrepair only exists for v5
> > > +_require_populate_commands
> > > +_require_libxfs_debug_flag LIBXFS_DEBUG_WRITE_CRASH
> > > +
> > > +rm -f $seqres.full
> > > +
> > > +# Populate the filesystem
> > > +_scratch_populate_cached nofill >> $seqres.full 2>&1
> > > +
> > > +max_writes=200			# 200 loops should be enough for anyone
> > > +nr_incr=$((13 / TIME_FACTOR))
> > 
> > Could we randomize this increment so we get varying behavior run to run?
> > It might be nice to actually do that on a per-iteration basis as well
> > rather than once at the start of the test.
> 
> Ok, I'll add a little bit of randomness to each run.
> 
> How about:
> 
> 	local crash_after=$(( nr_writes + ((RANDOM % 7) - 3) ))
> 	LIBXFS_DEBUG_WRITE_CRASH=ddev=$crash_after _scratch_xfs_repair
> 
> ?
> 

Seems reasonable to me.

> > > +test $nr_incr -lt 1 && nr_incr=1
> > > +for ((nr_writes = 1; nr_writes < max_writes; nr_writes += nr_incr)); do
> > > +	# Start a repair and force it to abort after some number of writes
> > > +	LIBXFS_DEBUG_WRITE_CRASH=ddev=$nr_writes \
> > > +			_scratch_xfs_repair 2>> $seqres.full
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
> > > +	# Check the state of NEEDSREPAIR after repair fails.  If it isn't set
> > > +	# but if repair -n says the fs is clean, then it's possible that the
> > > +	# injected error caused it to abort immediately after the write that
> > > +	# cleared NEEDSREPAIR.
> > > +	if ! _check_scratch_xfs_features NEEDSREPAIR > /dev/null &&
> > > +	   ! _scratch_xfs_repair -n &>> $seqres.full; then
> > > +		echo "NEEDSREPAIR should be set on corrupt fs"
> > > +	fi
> > > +
> > > +	# Repair properly this time and retry the mount
> > 
> > We can probably drop the "retry the mount" bit since we no longer do
> > that.
> 
> Oops, yes, good catch.
> 
> > > +	_scratch_xfs_repair 2>> $seqres.full
> > > +	_check_scratch_xfs_features NEEDSREPAIR > /dev/null && \
> > > +		echo "Repair failed to clear NEEDSREPAIR on the $nr_writes writes test"
> > 
> > Maybe I'm mistaken, but I thought we were going to let repair run and
> > fail repeatedly/incrementally and then leave the full repair for the
> > end..?
> 
> Ah.  Last time you wrote:
> 
> "It probably makes sense to test that NEEDSREPAIR remains set throughout
> the test sequence until repair completes cleanly..."
> 
> and I interpreted "throughout the test sequence" to mean "until the
> end of the loop body", not the whole test.
> 

Looking back, I think I was referring to the mount cycles in that
particular comment and had the repeated failure test in mind when I
wrote:

"Would we expect much difference in behavior if we populated once at the
start of the test and then just bumped up the write count until we get
to the max or the repair completes?"

... but that was probably not clear. Anyways..

> But I guess it /would/ be more interesting to study the effects of
> multiple successive write failures. ;)
> 

Yeah, assuming it doesn't outright explode from the onset, I think it's
beneficial to take full advantage of the failure mechanism and make the
test as mean as possible. ;)

Brian

> --D
> 
> > 
> > Brian
> > 
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
> > > index d1b1456b..461ae2b2 100644
> > > --- a/tests/xfs/group
> > > +++ b/tests/xfs/group
> > > @@ -522,3 +522,5 @@
> > >  537 auto quick
> > >  538 auto stress
> > >  539 auto quick mount
> > > +768 auto quick repair
> > > +770 auto repair
> > > 
> > 
> 

