Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7B637CA06
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Jul 2019 19:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfGaRMv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 31 Jul 2019 13:12:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbfGaRMv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Jul 2019 13:12:51 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9DF34C01DE0D;
        Wed, 31 Jul 2019 17:12:50 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 18164600D1;
        Wed, 31 Jul 2019 17:12:50 +0000 (UTC)
Date:   Wed, 31 Jul 2019 13:12:48 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: test new v5 bulkstat commands
Message-ID: <20190731171248.GG34040@bfoster>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
 <156394161882.1850833.4351446431166375360.stgit@magnolia>
 <20190731114306.GC34040@bfoster>
 <20190731164419.GU1561054@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731164419.GU1561054@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 31 Jul 2019 17:12:50 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 31, 2019 at 09:44:19AM -0700, Darrick J. Wong wrote:
> On Wed, Jul 31, 2019 at 07:43:07AM -0400, Brian Foster wrote:
> > On Tue, Jul 23, 2019 at 09:13:38PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Check that the new v5 bulkstat commands do everything the old one do,
> > > and then make sure the new functionality actually works.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  common/xfs                 |    6 +
> > >  src/Makefile               |    2 
> > >  src/bulkstat_null_ocount.c |   61 +++++++++
> > >  tests/xfs/085              |    2 
> > >  tests/xfs/086              |    2 
> > >  tests/xfs/087              |    2 
> > >  tests/xfs/088              |    2 
> > >  tests/xfs/089              |    2 
> > >  tests/xfs/091              |    2 
> > >  tests/xfs/093              |    2 
> > >  tests/xfs/097              |    2 
> > >  tests/xfs/130              |    2 
> > >  tests/xfs/235              |    2 
> > >  tests/xfs/271              |    2 
> > >  tests/xfs/744              |  212 +++++++++++++++++++++++++++++++
> > >  tests/xfs/744.out          |  297 ++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/745              |   44 +++++++
> > >  tests/xfs/745.out          |    2 
> > >  tests/xfs/group            |    2 
> > >  19 files changed, 636 insertions(+), 12 deletions(-)
> > >  create mode 100644 src/bulkstat_null_ocount.c
> > >  create mode 100755 tests/xfs/744
> > >  create mode 100644 tests/xfs/744.out
> > >  create mode 100755 tests/xfs/745
> > >  create mode 100644 tests/xfs/745.out
> > > 
> > > 
...
> > > +# print the number of inodes counted by inumbers
> > > +inumbers_count()
> > > +{
> > > +	local expect="$1"
> > > +
> > > +	# There probably aren't more than 10 hidden inodes, right?
> > > +	local tolerance=10
> > > +
> > > +	# Force all background inode cleanup
> > 
> > Comment took me a second to grok. This refers to unlinked inode cleanup,
> > right?
> 
> Yes.  I think it's only needed to force deferred inode inactivation to
> run... which means that we don't necessarily need it now, but it doesn't
> hurt to have it.
> 

Yep, could we just clarify the comment then to refer to cleaning up
unlinked inodes?

> > > +	_scratch_cycle_mount
> > > +
> > > +	bstat_versions | while read v_tag v_flag; do
> > > +		echo -n "inumbers all($v_tag): "
> > > +		nr=$(inumbers_fs $SCRATCH_MNT $v_flag)
> > > +		_within_tolerance "inumbers" $nr $expect $tolerance -v
> > > +
> > > +		local agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
> > > +		for batchsize in 64 2 1; do
> > 
> > Perhaps we should stuff a value > than the per-record inode count in
> > here as well.
> 
> I'm confused about this comment -- inumbers returns (cooked) inobt
> records, not inode records themselves.  The 64>2>1 sequence here asks
> inumbers to return 64 inobt records per call, then 2 per call, then 1.
> 
> Maybe this should be 71 or some other prime number...
> 

Er, disregard.. I was thinking in terms of inode count when I read this.

Brian

> > > +			echo -n "inumbers $batchsize($v_tag): "
> > > +			nr=$(inumbers_ag $agcount $batchsize $SCRATCH_MNT $v_flag)
> > > +			_within_tolerance "inumbers" $nr $expect $tolerance -v
> > > +		done
> > > +	done
> > > +}
> > > +
> > > +# compare the src/bstat output against the xfs_io bstat output
> > 
> > This compares actual inode numbers, right? If so, I'd point that out in
> > the comment.
> 
> Ok.
> 
> > > +bstat_compare()
> > > +{
> > > +	bstat_versions | while read v_tag v_flag; do
> > > +		diff -u <(./src/bstat $SCRATCH_MNT | grep ino | awk '{print $2}') \
> > > +			<($XFS_IO_PROG -c "bulkstat $v_flag" $SCRATCH_MNT | grep ino | awk '{print $3}')
> > > +	done
> > > +}
> > > +
> > ...
> > > diff --git a/tests/xfs/745 b/tests/xfs/745
> > > new file mode 100755
> > > index 00000000..6931d46b
> > > --- /dev/null
> > > +++ b/tests/xfs/745
> > > @@ -0,0 +1,44 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0+
> > > +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 745
> > > +#
> > > +# Regression test for a long-standing bug in BULKSTAT and INUMBERS where
> > > +# the kernel fails to write thew new @lastip value back to userspace if
> > > +# @ocount is NULL.
> > > +#
> > 
> > I think it would be helpful to reference the upstream fix here, which
> > IIRC is commit f16fe3ecde62 ("xfs: bulkstat should copy lastip whenever
> > userspace supplies one"). Otherwise this test looks fine to me.
> 
> Ok, will update.
> 
> --D
> 
> > Brian
> > 
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=`pwd`
> > > +tmp=/tmp/$$
> > > +status=1	# failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +    cd /
> > > +    rm -f $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +
> > > +_require_test_program "bulkstat_null_ocount"
> > > +
> > > +# real QA test starts here
> > > +
> > > +_supported_fs xfs
> > > +_supported_os Linux
> > > +
> > > +rm -f $seqres.full
> > > +
> > > +echo "Silence is golden."
> > > +src/bulkstat_null_ocount $TEST_DIR
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/745.out b/tests/xfs/745.out
> > > new file mode 100644
> > > index 00000000..ce947de2
> > > --- /dev/null
> > > +++ b/tests/xfs/745.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 745
> > > +Silence is golden.
> > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > index 270d82ff..ef0cf92c 100644
> > > --- a/tests/xfs/group
> > > +++ b/tests/xfs/group
> > > @@ -506,3 +506,5 @@
> > >  506 auto quick health
> > >  507 clone
> > >  508 auto quick quota
> > > +744 auto ioctl quick
> > > +745 auto ioctl quick
> > > 
