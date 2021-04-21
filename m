Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428B836743F
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Apr 2021 22:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245676AbhDUUjr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 21 Apr 2021 16:39:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245672AbhDUUjp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Apr 2021 16:39:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30D9961425;
        Wed, 21 Apr 2021 20:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619037552;
        bh=y+/ULmL1epK8QFs0J4iAe1mClcMQlRJZlN/CjvBYZI4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QVGVZPkcaFeVPKWpF/ihnE9jauYem/F8vVQlQRH76f6sZAh/jb24THBEotMta0Ilm
         ZDuaRnOTA8hE3vU/vEeaUUQqMzpuvkWdqItsLKJj4byLQsOT6ep3Y8Xwdkpzr+pmld
         RBKWKXCGIlKWsw246bbmKj4MNhIctawk27E0/MCaqzlZJUMM68mN8DY5otOalbhR4x
         KrfQPtAqC+jf36wdyTmBPNpctM85uCCLfjrI5Z84fn0xMxXUYXtc+IX013mT3ZnZHv
         ybBZ3uyRux5cnGpQ9Ln1/HNtfblqkwsRRvOzXP3AXNFqRzUq8EGaRkLmyc8qAH4j1q
         UIKKTkvV9de0w==
Date:   Wed, 21 Apr 2021 13:39:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] xfs: functional testing of V5-relevant options
Message-ID: <20210421203911.GF3122235@magnolia>
References: <161896456467.776366.1514131340097986327.stgit@magnolia>
 <161896457076.776366.1740320523459442249.stgit@magnolia>
 <YIBoRixSehw0C+Km@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIBoRixSehw0C+Km@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 02:00:38PM -0400, Brian Foster wrote:
> On Tue, Apr 20, 2021 at 05:22:50PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Currently, the only functional testing for xfs_admin is xfs/287, which
> > checks that one can add 32-bit project ids to a V4 filesystem.  This
> > obviously isn't an exhaustive test of all the CLI arguments, and
> > historically there have been xfs configurations that don't even work.
> > 
> > Therefore, introduce a couple of new tests -- one that will test the
> > simple options with the default configuration, and a second test that
> > steps a bit outside of the test run configuration to make sure that we
> > do the right thing for external devices.  The second test already caught
> > a nasty bug in xfsprogs 5.11.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/xfs        |   21 ++++++++++
> >  tests/xfs/764     |   93 +++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/764.out |   17 ++++++++
> >  tests/xfs/773     |  114 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/773.out |   19 +++++++++
> >  tests/xfs/group   |    2 +
> >  6 files changed, 266 insertions(+)
> >  create mode 100755 tests/xfs/764
> >  create mode 100644 tests/xfs/764.out
> >  create mode 100755 tests/xfs/773
> >  create mode 100644 tests/xfs/773.out
> > 
> > 
> ...
> > diff --git a/tests/xfs/773 b/tests/xfs/773
> > new file mode 100755
> > index 00000000..f184962a
> > --- /dev/null
> > +++ b/tests/xfs/773
> > @@ -0,0 +1,114 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 773
> > +#
> > +# Functional testing for xfs_admin to ensure that it parses arguments correctly
> > +# with regards to data devices that are files, external logs, and realtime
> > +# devices.
> > +#
> > +# Because this test synthesizes log and rt devices (by modifying the test run
> > +# configuration), it does /not/ require the ability to mount the scratch
> > +# filesystem.  This increases test coverage while isolating the weird bits to a
> > +# single test.
> > +#
> > +# This is partially a regression test for "xfs_admin: pick up log arguments
> > +# correctly", insofar as the issue fixed by that patch was discovered with an
> > +# earlier revision of this test.
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.* $fake_logfile $fake_rtfile $fake_datafile
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_test
> > +_require_scratch_nocheck
> > +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> > +
> > +rm -f $seqres.full
> > +
> > +# Create some fake sparse files for testing external devices and whatnot
> > +fake_datafile=$TEST_DIR/scratch.data
> > +rm -f $fake_datafile
> > +truncate -s 500m $fake_datafile
> > +
> > +fake_logfile=$TEST_DIR/scratch.log
> > +rm -f $fake_logfile
> > +truncate -s 500m $fake_logfile
> > +
> > +fake_rtfile=$TEST_DIR/scratch.rt
> > +rm -f $fake_rtfile
> > +truncate -s 500m $fake_rtfile
> > +
> 
> I think it's usually good practice to incorporate $seq into filenames
> created on the test device.

Ok fixed.

> > +# Save the original variables
> > +orig_ddev=$SCRATCH_DEV
> > +orig_external=$USE_EXTERNAL
> > +orig_logdev=$SCRATCH_LOGDEV
> > +orig_rtdev=$SCRATCH_RTDEV
> > +
> > +scenario() {
> > +	echo "$@" | tee -a $seqres.full
> > +
> > +	SCRATCH_DEV=$orig_ddev
> > +	USE_EXTERNAL=$orig_external
> > +	SCRATCH_LOGDEV=$orig_logdev
> > +	SCRATCH_RTDEV=$orig_rtdev
> > +}
> > +
> > +check_label() {
> > +	_scratch_mkfs -L oldlabel >> $seqres.full
> > +	_scratch_xfs_db -c label
> > +	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
> > +	_scratch_xfs_db -c label
> > +	_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> > +}
> > +
> > +scenario "S1: Check that label setting with file image"
> > +SCRATCH_DEV=$fake_datafile
> > +check_label -f
> > +
> > +scenario "S2: Check that setting with logdev works"
> > +USE_EXTERNAL=yes
> > +SCRATCH_LOGDEV=$fake_logfile
> > +check_label
> > +
> > +scenario "S3: Check that setting with rtdev works"
> > +USE_EXTERNAL=yes
> > +SCRATCH_RTDEV=$fake_rtfile
> > +check_label
> > +
> > +scenario "S4: Check that setting with rtdev + logdev works"
> > +USE_EXTERNAL=yes
> > +SCRATCH_LOGDEV=$fake_logfile
> > +SCRATCH_RTDEV=$fake_rtfile
> > +check_label
> > +
> > +scenario "S5: Check that setting with nortdev + nologdev works"
> > +USE_EXTERNAL=
> > +SCRATCH_LOGDEV=
> > +SCRATCH_RTDEV=
> > +check_label
> > +
> > +scenario "S6: Check that setting with bdev incorrectly flagged as file works"
> > +check_label -f
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/773.out b/tests/xfs/773.out
> > new file mode 100644
> > index 00000000..954bfb85
> > --- /dev/null
> > +++ b/tests/xfs/773.out
> > @@ -0,0 +1,19 @@
> > +QA output created by 773
> > +S1: Check that label setting with file image
> > +label = "oldlabel"
> > +label = "newlabel"
> > +S2: Check that setting with logdev works
> > +label = "oldlabel"
> > +label = "newlabel"
> > +S3: Check that setting with rtdev works
> > +label = "oldlabel"
> > +label = "newlabel"
> > +S4: Check that setting with rtdev + logdev works
> > +label = "oldlabel"
> > +label = "newlabel"
> > +S5: Check that setting with nortdev + nologdev works
> > +label = "oldlabel"
> > +label = "newlabel"
> > +S6: Check that setting with bdev incorrectly flagged as file works
> > +label = "oldlabel"
> > +label = "newlabel"
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 461ae2b2..a2309465 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -522,5 +522,7 @@
> >  537 auto quick
> >  538 auto stress
> >  539 auto quick mount
> > +764 auto quick repair
> >  768 auto quick repair
> >  770 auto repair
> > +773 auto quick repair
> > 
> 
> Both of these tests are primarily targeted at xfs_admin, right? If so,
> I'm not sure the repair group makes much sense. With the nits fixed up:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Will fix the groups; thanks for the review!

--D
