Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF29635059D
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Mar 2021 19:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbhCaRgw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 31 Mar 2021 13:36:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37792 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234583AbhCaRgk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Mar 2021 13:36:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617212199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M8X2z8wT/cJTgJML3e89BcPFnkcCKOdzolbiTQTLLm8=;
        b=MhGiiD1HvAHIdLkdU9zEhn3ZcYyhOgMJHiaYws2F4ozpw2DVrZ+c+xHQu0db/yn7qlgdOK
        RJuSRKpvEE7zwL4twU7YRsDptkGWkEtbTHu9lktL7CepEhr7gr7xkB3JHSpskz5A/13qBD
        P3fdfAz1o7al9j31c89uZFc6qoT5wYc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-5PvtE8aJO_6IOWZtf9gc7w-1; Wed, 31 Mar 2021 13:36:34 -0400
X-MC-Unique: 5PvtE8aJO_6IOWZtf9gc7w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59E7F501F8;
        Wed, 31 Mar 2021 17:36:33 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B114C5C649;
        Wed, 31 Mar 2021 17:36:29 +0000 (UTC)
Date:   Wed, 31 Mar 2021 13:36:21 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] xfs: functional testing of V5-relevant options
Message-ID: <YGSzFRxcGuu3GR4I@bfoster>
References: <161715290311.2703879.6182444659830603450.stgit@magnolia>
 <161715290858.2703879.2364659698245587140.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161715290858.2703879.2364659698245587140.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 06:08:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, the only functional testing for xfs_admin is xfs/287, which
> checks that one can add 32-bit project ids to a V4 filesystem.  This
> obviously isn't an exhaustive test of all the CLI arguments, and
> historically there have been xfs configurations that don't even work.
> 
> Therefore, introduce a couple of new tests -- one that will test the
> simple options with the default configuration, and a second test that
> steps a bit outside of the test run configuration to make sure that we
> do the right thing for external devices.  The second test already caught
> a nasty bug in xfsprogs 5.11.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/xfs        |   21 ++++++++++
>  tests/xfs/764     |   91 ++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/764.out |   17 ++++++++
>  tests/xfs/773     |  114 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/773.out |   19 +++++++++
>  tests/xfs/group   |    2 +
>  6 files changed, 264 insertions(+)
>  create mode 100755 tests/xfs/764
>  create mode 100644 tests/xfs/764.out
>  create mode 100755 tests/xfs/773
>  create mode 100644 tests/xfs/773.out
> 
> 
...
> diff --git a/tests/xfs/764 b/tests/xfs/764
> new file mode 100755
> index 00000000..c710ad4e
> --- /dev/null
> +++ b/tests/xfs/764
> @@ -0,0 +1,91 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 764
> +#
> +# Functional testing for xfs_admin to make sure that it handles option parsing
> +# correctly, at least for functionality that's relevant to V5 filesystems.

This test doesn't seem to depend on v5..?

> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch
> +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> +
> +rm -f $seqres.full
> +
> +note() {
> +	echo "$@" | tee -a $seqres.full
> +}
> +
> +note "S0: Initialize filesystem"
> +_scratch_mkfs -L origlabel -m uuid=babababa-baba-baba-baba-babababababa >> $seqres.full
> +_scratch_xfs_db -c label -c uuid
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +note "S1: Set a filesystem label"
> +_scratch_xfs_admin -L newlabel >> $seqres.full
> +_scratch_xfs_db -c label
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +note "S2: Clear filesystem label"
> +_scratch_xfs_admin -L -- >> $seqres.full
> +_scratch_xfs_db -c label
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +note "S3: Try to set oversized label"
> +_scratch_xfs_admin -L thisismuchtoolongforxfstohandle >> $seqres.full
> +_scratch_xfs_db -c label
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +note "S4: Set filesystem UUID"
> +_scratch_xfs_admin -U deaddead-dead-dead-dead-deaddeaddead >> $seqres.full
> +_scratch_xfs_db -c uuid
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +note "S5: Zero out filesystem UUID"
> +_scratch_xfs_admin -U nil >> $seqres.full
> +_scratch_xfs_db -c uuid
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +note "S6: Randomize filesystem UUID"
> +old_uuid="$(_scratch_xfs_db -c uuid)"
> +_scratch_xfs_admin -U generate >> $seqres.full
> +new_uuid="$(_scratch_xfs_db -c uuid)"
> +if [ "$new_uuid" = "$old_uuid" ]; then
> +	echo "UUID randomization failed? $old_uuid == $new_uuid"
> +fi
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +

Can we drop all these intermediate repair invocations and just rely on
the post-test device check? Otherwise the rest LGTM.

Brian

> +note "S7: Restore original filesystem UUID"
> +if _check_scratch_xfs_features V5 >/dev/null; then
> +	# Only V5 supports the metauuid feature that enables us to restore the
> +	# original UUID after a change.
> +	_scratch_xfs_admin -U restore >> $seqres.full
> +	_scratch_xfs_db -c uuid
> +else
> +	echo "UUID = babababa-baba-baba-baba-babababababa"
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/764.out b/tests/xfs/764.out
> new file mode 100644
> index 00000000..8da929ec
> --- /dev/null
> +++ b/tests/xfs/764.out
> @@ -0,0 +1,17 @@
> +QA output created by 764
> +S0: Initialize filesystem
> +label = "origlabel"
> +UUID = babababa-baba-baba-baba-babababababa
> +S1: Set a filesystem label
> +label = "newlabel"
> +S2: Clear filesystem label
> +label = ""
> +S3: Try to set oversized label
> +label = "thisismuchto"
> +S4: Set filesystem UUID
> +UUID = deaddead-dead-dead-dead-deaddeaddead
> +S5: Zero out filesystem UUID
> +UUID = 00000000-0000-0000-0000-000000000000
> +S6: Randomize filesystem UUID
> +S7: Restore original filesystem UUID
> +UUID = babababa-baba-baba-baba-babababababa
> diff --git a/tests/xfs/773 b/tests/xfs/773
> new file mode 100755
> index 00000000..f184962a
> --- /dev/null
> +++ b/tests/xfs/773
> @@ -0,0 +1,114 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 773
> +#
> +# Functional testing for xfs_admin to ensure that it parses arguments correctly
> +# with regards to data devices that are files, external logs, and realtime
> +# devices.
> +#
> +# Because this test synthesizes log and rt devices (by modifying the test run
> +# configuration), it does /not/ require the ability to mount the scratch
> +# filesystem.  This increases test coverage while isolating the weird bits to a
> +# single test.
> +#
> +# This is partially a regression test for "xfs_admin: pick up log arguments
> +# correctly", insofar as the issue fixed by that patch was discovered with an
> +# earlier revision of this test.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.* $fake_logfile $fake_rtfile $fake_datafile
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_test
> +_require_scratch_nocheck
> +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> +
> +rm -f $seqres.full
> +
> +# Create some fake sparse files for testing external devices and whatnot
> +fake_datafile=$TEST_DIR/scratch.data
> +rm -f $fake_datafile
> +truncate -s 500m $fake_datafile
> +
> +fake_logfile=$TEST_DIR/scratch.log
> +rm -f $fake_logfile
> +truncate -s 500m $fake_logfile
> +
> +fake_rtfile=$TEST_DIR/scratch.rt
> +rm -f $fake_rtfile
> +truncate -s 500m $fake_rtfile
> +
> +# Save the original variables
> +orig_ddev=$SCRATCH_DEV
> +orig_external=$USE_EXTERNAL
> +orig_logdev=$SCRATCH_LOGDEV
> +orig_rtdev=$SCRATCH_RTDEV
> +
> +scenario() {
> +	echo "$@" | tee -a $seqres.full
> +
> +	SCRATCH_DEV=$orig_ddev
> +	USE_EXTERNAL=$orig_external
> +	SCRATCH_LOGDEV=$orig_logdev
> +	SCRATCH_RTDEV=$orig_rtdev
> +}
> +
> +check_label() {
> +	_scratch_mkfs -L oldlabel >> $seqres.full
> +	_scratch_xfs_db -c label
> +	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
> +	_scratch_xfs_db -c label
> +	_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +}
> +
> +scenario "S1: Check that label setting with file image"
> +SCRATCH_DEV=$fake_datafile
> +check_label -f
> +
> +scenario "S2: Check that setting with logdev works"
> +USE_EXTERNAL=yes
> +SCRATCH_LOGDEV=$fake_logfile
> +check_label
> +
> +scenario "S3: Check that setting with rtdev works"
> +USE_EXTERNAL=yes
> +SCRATCH_RTDEV=$fake_rtfile
> +check_label
> +
> +scenario "S4: Check that setting with rtdev + logdev works"
> +USE_EXTERNAL=yes
> +SCRATCH_LOGDEV=$fake_logfile
> +SCRATCH_RTDEV=$fake_rtfile
> +check_label
> +
> +scenario "S5: Check that setting with nortdev + nologdev works"
> +USE_EXTERNAL=
> +SCRATCH_LOGDEV=
> +SCRATCH_RTDEV=
> +check_label
> +
> +scenario "S6: Check that setting with bdev incorrectly flagged as file works"
> +check_label -f
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/773.out b/tests/xfs/773.out
> new file mode 100644
> index 00000000..954bfb85
> --- /dev/null
> +++ b/tests/xfs/773.out
> @@ -0,0 +1,19 @@
> +QA output created by 773
> +S1: Check that label setting with file image
> +label = "oldlabel"
> +label = "newlabel"
> +S2: Check that setting with logdev works
> +label = "oldlabel"
> +label = "newlabel"
> +S3: Check that setting with rtdev works
> +label = "oldlabel"
> +label = "newlabel"
> +S4: Check that setting with rtdev + logdev works
> +label = "oldlabel"
> +label = "newlabel"
> +S5: Check that setting with nortdev + nologdev works
> +label = "oldlabel"
> +label = "newlabel"
> +S6: Check that setting with bdev incorrectly flagged as file works
> +label = "oldlabel"
> +label = "newlabel"
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 09fddb5a..5801471b 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -520,5 +520,7 @@
>  537 auto quick
>  538 auto stress
>  539 auto quick mount
> +764 auto quick repair
>  768 auto quick repair
>  770 auto repair
> +773 auto quick repair
> 

