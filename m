Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34CA346125
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Mar 2021 15:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbhCWONg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Mar 2021 10:13:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27733 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232266AbhCWONd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Mar 2021 10:13:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616508812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hTxZYORWLljeU8gkqlzXfd7jSD/b/63szrd4iojaJmk=;
        b=UMWjf6V6xwAuY9zmzfnSe4zUWiMqfyG+QPvLuCP5Mk1iu6Z5TLb38cKCme+b6cf0mf+bxx
        ly/L8xVSPPT4DQJ2EgDGtO2L8RhyIdbzjTEZ5JgKcBEAY/uDON42pL7KZd5gDYeUhh7Y7+
        OYlRrrUFajyDs4OGFbNj/LfM9aRpCoM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-gJuI9SXzMneNDJOulH4nqw-1; Tue, 23 Mar 2021 10:13:30 -0400
X-MC-Unique: gJuI9SXzMneNDJOulH4nqw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C60D7108BD0D;
        Tue, 23 Mar 2021 14:13:28 +0000 (UTC)
Received: from bfoster (ovpn-113-24.rdu2.redhat.com [10.10.113.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C8CAE5C1C5;
        Tue, 23 Mar 2021 14:13:27 +0000 (UTC)
Date:   Tue, 23 Mar 2021 10:13:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/3] xfs: test inobtcount upgrade
Message-ID: <YFn3hck7nYCwhfK3@bfoster>
References: <161647324459.3431131.16341235245632737552.stgit@magnolia>
 <161647326120.3431131.9588272913557202987.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161647326120.3431131.9588272913557202987.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 22, 2021 at 09:21:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure we can actually upgrade filesystems to support inode btree
> counters.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/xfs        |   20 ++++++
>  tests/xfs/764     |  190 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/764.out |   27 ++++++++
>  tests/xfs/910     |   84 +++++++++++++++++++++++
>  tests/xfs/910.out |   12 +++
>  tests/xfs/group   |    2 +
>  6 files changed, 335 insertions(+)
>  create mode 100755 tests/xfs/764
>  create mode 100644 tests/xfs/764.out
>  create mode 100755 tests/xfs/910
>  create mode 100644 tests/xfs/910.out
> 
> 
> diff --git a/common/xfs b/common/xfs
> index 9cb373ba..a316f384 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1085,3 +1085,23 @@ _require_xfs_copy()
>  	[ "$USE_EXTERNAL" = yes ] && \
>  		_notrun "Cannot xfs_copy with external devices"
>  }
> +
> +_require_xfs_repair_upgrade()
> +{
> +	local type="$1"
> +
> +	$XFS_REPAIR_PROG -c "$type=narf" 2>&1 | \

narf?

> +		grep -q 'unknown option' && \
> +		_notrun "xfs_repair does not support upgrading fs with $type"
> +}
> +
> +_require_xfs_scratch_inobtcount()
> +{
> +	_require_scratch
> +
> +	_scratch_mkfs -m inobtcount=1 &> /dev/null || \
> +		_notrun "mkfs.xfs doesn't have inobtcount feature"
> +	_try_scratch_mount || \
> +		_notrun "inobtcount not supported by scratch filesystem type: $FSTYP"
> +	_scratch_unmount
> +}
> diff --git a/tests/xfs/764 b/tests/xfs/764
> new file mode 100755
> index 00000000..cf6784d2
> --- /dev/null
> +++ b/tests/xfs/764
> @@ -0,0 +1,190 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 764
> +#
> +# Functional testing for xfs_admin -O, which is a new switch that enables us to
> +# add features to an existing filesystem.  In these test scenarios, we try to
> +# add the inode btree counter 'feature' to the filesystem, and make sure that
> +# NEEDSREPAIR (aka the thing that prevents us from mounting after an upgrade
> +# fails) is clear if the upgraded succeeds and set if it fails.
> +#
> +# The first scenario tests that we can't add inobtcount to the V4 format,
> +# which is now deprecated.
> +#
> +# The middle five scenarios ensure that xfs_admin -O works even when external
> +# log devices and realtime volumes are specified.  This part is purely an
> +# exerciser for the userspace tools; kernel support for those features is not
> +# required.
> +#
> +# The last scenario uses a xfs_repair debug knob to simulate failure during an
> +# inobtcount upgrade, then checks that mounts fail when the flag is enabled,
> +# that repair clears the flag, and mount works after repair.
> +

By and large the test seems reasonable, though it hangs somewhere in
xfs_db for me on a quick run, not sure why. The runtime state is as
follows:

# ps | grep xfs_db:
... xfs_db -x -p xfs_admin -l /mnt/test/scratch.log /dev/mapper/test-scratch

# cat /proc/12489/stack 
[<0>] wait_woken+0x67/0x80
[<0>] n_tty_read+0x4f9/0x5c0
[<0>] tty_read+0x135/0x240
[<0>] new_sync_read+0x105/0x180
[<0>] vfs_read+0x14b/0x1a0
[<0>] ksys_read+0x4f/0xc0
[<0>] do_syscall_64+0x33/0x40
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

# cat /tmp/11671.out 
QA output created by 764
S1: Cannot add inobtcount to a V4 fs
Running xfs_repair to upgrade filesystem.
Inode btree count feature only supported on V5 filesystems.
S2: Check that setting with xfs_admin + logdev works

Looks like xfs_db might be waiting for input on the terminal..?

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
> +	rm -f $tmp.* $fake_logfile $fake_rtfile
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_test
> +_require_xfs_scratch_inobtcount
> +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> +_require_xfs_repair_upgrade inobtcount
> +
> +rm -f $seqres.full
> +
> +note() {
> +	echo "$@" | tee -a $seqres.full
> +}
> +
> +note "S1: Cannot add inobtcount to a V4 fs"
> +_scratch_mkfs -m crc=0 >> $seqres.full
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +
> +# Middle five scenarios: Make sure upgrades work with various external device
> +# configurations.
> +note "S2: Check that setting with xfs_admin + logdev works"
> +fake_logfile=$TEST_DIR/scratch.log
> +rm -f $fake_logfile
> +truncate -s 500m $fake_logfile
> +
> +old_external=$USE_EXTERNAL
> +old_logdev=$SCRATCH_LOGDEV
> +USE_EXTERNAL=yes
> +SCRATCH_LOGDEV=$fake_logfile
> +
> +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> +	echo "xfs_admin should have cleared needsrepair?"
> +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> +	echo "xfs_admin should have set inobtcount?"
> +
> +note "Check clean"
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +USE_EXTERNAL=$old_external
> +SCRATCH_LOGDEV=$old_logdev
> +
> +note "S3: Check that setting with xfs_admin + realtime works"
> +fake_rtfile=$TEST_DIR/scratch.rt
> +rm -f $fake_rtfile
> +truncate -s 500m $fake_rtfile
> +
> +old_external=$USE_EXTERNAL
> +old_rtdev=$SCRATCH_RTDEV
> +USE_EXTERNAL=yes
> +SCRATCH_RTDEV=$fake_rtfile
> +
> +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> +	echo "xfs_admin should have cleared needsrepair?"
> +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> +	echo "xfs_admin should have set inobtcount?"
> +
> +note "Check clean"
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +USE_EXTERNAL=$old_external
> +SCRATCH_RTDEV=$old_rtdev
> +
> +note "S4: Check that setting with xfs_admin + realtime + logdev works"
> +old_external=$USE_EXTERNAL
> +old_logdev=$SCRATCH_LOGDEV
> +old_rtdev=$SCRATCH_RTDEV
> +USE_EXTERNAL=yes
> +SCRATCH_LOGDEV=$fake_logfile
> +SCRATCH_RTDEV=$fake_rtfile
> +
> +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> +	echo "xfs_admin should have cleared needsrepair?"
> +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> +	echo "xfs_admin should have set inobtcount?"
> +
> +note "Check clean"
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +USE_EXTERNAL=$old_external
> +SCRATCH_LOGDEV=$old_logdev
> +SCRATCH_RTDEV=$old_rtdev
> +
> +note "S5: Check that setting with xfs_admin + nortdev + nologdev works"
> +old_external=$USE_EXTERNAL
> +old_logdev=$SCRATCH_LOGDEV
> +old_rtdev=$SCRATCH_RTDEV
> +USE_EXTERNAL=
> +SCRATCH_LOGDEV=
> +SCRATCH_RTDEV=
> +
> +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> +	echo "xfs_admin should have cleared needsrepair?"
> +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> +	echo "xfs_admin should have set inobtcount?"
> +
> +note "Check clean"
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +USE_EXTERNAL=$old_external
> +SCRATCH_LOGDEV=$old_logdev
> +SCRATCH_RTDEV=$old_rtdev
> +

There's a lot of eye crossing copy-paste going on here. Do we really
need to always test these varying configurations? My general expectation
for fstests has always been to primarily test the configuration
specified in the config file. ISTM this test could be legitimately
reduced to S1, S6 and S7. That might also mitigate the need for 'note'
markers in the golden output, fwiw.

> +# Run our test with the test runner's config last so that the post-test check
> +# won't trip over our artificial log/rt devices
> +note "S6: Check that setting with xfs_admin testrunner config works"
> +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> +	echo "xfs_admin should have cleared needsrepair?"
> +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> +	echo "xfs_admin should have set inobtcount?"
> +

Perhaps the above xfs_db commands could be wrapped in a helper that
filters on the expected version values..? I.e., even something really
simple that executed the grep and manually constructed a string would
improve readability:

_filter_version()
{
	str="version "
	_scratch_xfs_db -c "version" | grep -q $1 &&
		str="$str $1"
	echo $str
}

_scratch_mkfs ...
_scratch_xfs_admin ...
_filter_version NEEDSREPAIR
_filter_version INOBTCNT

Then the test dumps the filter output directly to the golden output such
that there's no need for '&& echo "didn't expect this"' logic on every
test.

> +note "Check clean"
> +_scratch_xfs_repair -n &>> $seqres.full || echo "Check failed?"
> +
> +note "S7: Simulate failure during upgrade process"
> +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> +XFS_REPAIR_FAIL_AFTER_PHASE=2 _scratch_xfs_repair -c inobtcount=1 2>> $seqres.full
> +test $? -eq 137 || echo "repair should have been killed??"
> +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR || \
> +	echo "needsrepair should have been set on fs"
> +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> +	echo "inobtcount should have been set on fs"
> +_try_scratch_mount &> $tmp.mount
> +res=$?
> +_filter_scratch < $tmp.mount
> +if [ $res -eq 0 ]; then
> +	echo "needsrepair should have prevented mount"
> +	_scratch_unmount
> +fi
> +_scratch_xfs_repair 2>> $seqres.full
> +_scratch_xfs_db -c 'version' | grep -q NEEDSREPAIR && \
> +	echo "xfs_repair should have cleared needsrepair?"
> +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> +	echo "xfs_admin should have set inobtcount?"
> +_scratch_mount
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/764.out b/tests/xfs/764.out
> new file mode 100644
> index 00000000..067639c9
> --- /dev/null
> +++ b/tests/xfs/764.out
> @@ -0,0 +1,27 @@
> +QA output created by 764
> +S1: Cannot add inobtcount to a V4 fs
> +Running xfs_repair to upgrade filesystem.
> +Inode btree count feature only supported on V5 filesystems.
> +S2: Check that setting with xfs_admin + logdev works
> +Running xfs_repair to upgrade filesystem.
> +Adding inode btree counts to filesystem.
> +Check clean
> +S3: Check that setting with xfs_admin + realtime works
> +Running xfs_repair to upgrade filesystem.
> +Adding inode btree counts to filesystem.
> +Check clean
> +S4: Check that setting with xfs_admin + realtime + logdev works
> +Running xfs_repair to upgrade filesystem.
> +Adding inode btree counts to filesystem.
> +Check clean
> +S5: Check that setting with xfs_admin + nortdev + nologdev works
> +Running xfs_repair to upgrade filesystem.
> +Adding inode btree counts to filesystem.
> +Check clean
> +S6: Check that setting with xfs_admin testrunner config works
> +Running xfs_repair to upgrade filesystem.
> +Adding inode btree counts to filesystem.
> +Check clean
> +S7: Simulate failure during upgrade process
> +Adding inode btree counts to filesystem.
> +mount: SCRATCH_MNT: mount(2) system call failed: Structure needs cleaning.
> diff --git a/tests/xfs/910 b/tests/xfs/910
> new file mode 100755
> index 00000000..4bf79db2
> --- /dev/null
> +++ b/tests/xfs/910
> @@ -0,0 +1,84 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 910
> +#
> +# Check that we can upgrade a filesystem to support inobtcount and that
> +# everything works properly after the upgrade.
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
> +_require_xfs_scratch_inobtcount
> +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> +_require_xfs_repair_upgrade inobtcount
> +
> +rm -f $seqres.full
> +
> +# Make sure we can't format a filesystem with inobtcount and not finobt.
> +_scratch_mkfs -m crc=1,inobtcount=1,finobt=0 &> $seqres.full && \
> +	echo "Should not be able to format with inobtcount but not finobt."
> +
> +# Make sure we can't upgrade a V4 filesystem
> +_scratch_mkfs -m crc=0,inobtcount=0,finobt=0 >> $seqres.full
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +_scratch_xfs_db -c 'version' | grep -q INOBTCNT && \
> +	echo "Should not be able to upgrade to inobtcount without V5."
> +
> +# Make sure we can't upgrade a filesystem to inobtcount without finobt.
> +_scratch_mkfs -m crc=1,inobtcount=0,finobt=0 >> $seqres.full
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +_scratch_xfs_db -c 'version' | grep -q INOBTCNT && \
> +	echo "Should not be able to upgrade to inobtcount without finobt."
> +
> +# Format V5 filesystem without inode btree counter support and populate it
> +_scratch_mkfs -m crc=1,inobtcount=0 >> $seqres.full
> +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +echo moo > $SCRATCH_MNT/urk
> +
> +_scratch_unmount
> +_check_scratch_fs
> +
> +# Now upgrade to inobtcount support
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +_scratch_xfs_db -c 'version' | grep -q INOBTCNT || \
> +	echo "Cannot detect new feature?"
> +_check_scratch_fs
> +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' -c 'agi 0' -c 'p' >> $seqres.full
> +

Isn't this essentially the same core feature upgrade test as 764 with
some minor additional logic (i.e., create a file, check counters)? From
the group update below it seems like maybe 764 is intended to be a
generic repair test while this is intended to target inobtcount, but
there seems to be quite a lot of overlap here...

Brian

> +# Make sure we have nonzero counters
> +_scratch_xfs_db -c 'agi 0' -c 'print ino_blocks fino_blocks' | \
> +	sed -e 's/= [1-9]*/= NONZERO/g'
> +
> +# Mount again, look at our files
> +_scratch_mount >> $seqres.full
> +cat $SCRATCH_MNT/urk
> +
> +# Make sure we can't re-add inobtcount
> +_scratch_unmount
> +_scratch_xfs_admin -O inobtcount=1 2>> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +status=0
> +exit
> diff --git a/tests/xfs/910.out b/tests/xfs/910.out
> new file mode 100644
> index 00000000..c3cfbb80
> --- /dev/null
> +++ b/tests/xfs/910.out
> @@ -0,0 +1,12 @@
> +QA output created by 910
> +Running xfs_repair to upgrade filesystem.
> +Inode btree count feature only supported on V5 filesystems.
> +Running xfs_repair to upgrade filesystem.
> +Inode btree count feature requires free inode btree.
> +Running xfs_repair to upgrade filesystem.
> +Adding inode btree counts to filesystem.
> +ino_blocks = NONZERO
> +fino_blocks = NONZERO
> +moo
> +Running xfs_repair to upgrade filesystem.
> +Filesystem already has inode btree counts.
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 6aa7883e..28176409 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -517,7 +517,9 @@
>  538 auto stress
>  759 auto quick rw realtime
>  760 auto quick rw realtime collapse insert unshare zero prealloc
> +764 auto quick repair
>  768 auto quick repair
>  770 auto repair
> +910 auto quick inobtcount
>  917 auto quick db
>  918 auto quick db
> 

