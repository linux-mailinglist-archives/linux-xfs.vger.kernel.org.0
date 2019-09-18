Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47558B6545
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Sep 2019 15:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbfIRN7u (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Sep 2019 09:59:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57926 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfIRN7u (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Sep 2019 09:59:50 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8A9FA109EFC3;
        Wed, 18 Sep 2019 13:59:49 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C2F7A600C8;
        Wed, 18 Sep 2019 13:59:48 +0000 (UTC)
Date:   Wed, 18 Sep 2019 09:59:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH v3 2/2] xfs: test the deadlock between the AGI and AGF
 with RENAME_WHITEOUT
Message-ID: <20190918135947.GD29377@bfoster>
References: <db6c5d87-5a47-75bd-4d24-a135e6bcd783@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db6c5d87-5a47-75bd-4d24-a135e6bcd783@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Wed, 18 Sep 2019 13:59:49 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 18, 2019 at 07:49:22PM +0800, kaixuxia wrote:
> There is ABBA deadlock bug between the AGI and AGF when performing
> rename() with RENAME_WHITEOUT flag, and add this testcase to make
> sure the rename() call works well.
> 
> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> ---

FYI, for some reason your patch series isn't threaded on the mailing
list. I thought git send-email did this by default. Assuming you're not
explicitly using --no-thread, you might have to use the --thread option
so this gets posted as a proper series.

>  tests/xfs/512     | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/512.out |  2 ++
>  tests/xfs/group   |  1 +
>  3 files changed, 99 insertions(+)
>  create mode 100755 tests/xfs/512
>  create mode 100644 tests/xfs/512.out
> 
> diff --git a/tests/xfs/512 b/tests/xfs/512
> new file mode 100755
> index 0000000..a2089f0
> --- /dev/null
> +++ b/tests/xfs/512
> @@ -0,0 +1,96 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Tencent.  All Rights Reserved.
> +#
> +# FS QA Test 512
> +#
> +# Test the ABBA deadlock case between the AGI and AGF When performing
> +# rename operation with RENAME_WHITEOUT flag.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
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
> +. ./common/renameat2
> +
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +# single AG will cause default xfs_repair to fail. This test need a
> +# single AG fs, so ignore the check.
> +_require_scratch_nocheck
> +_requires_renameat2 whiteout
> +
> +filter_enospc() {
> +	sed -e '/^.*No space left on device.*/d'
> +}
> +
> +create_file()
> +{
> +	local target_dir=$1
> +	local files_count=$2
> +
> +	for i in $(seq 1 $files_count); do
> +		echo > $target_dir/f$i >/dev/null 2>&1 | filter_enospc
> +	done
> +}
> +
> +rename_whiteout()
> +{
> +	local target_dir=$1
> +	local files_count=$2
> +
> +	# a long filename could increase the possibility that target_dp
> +	# allocate new blocks(acquire the AGF lock) to store the filename
> +	longnamepre=`$PERL_PROG -e 'print "a"x200;'`
> +
> +	# now try to do rename with RENAME_WHITEOUT flag
> +	for i in $(seq 1 $files_count); do
> +		src/renameat2 -w $SCRATCH_MNT/f$i $target_dir/$longnamepre$i >/dev/null 2>&1
> +	done
> +}
> +
> +_scratch_mkfs_xfs -d agcount=1 >> $seqres.full 2>&1 ||
> +	_fail "mkfs failed"

This appears to be the only XFS specific bit. Could it be
conditionalized using FSTYP such that this test could go under
tests/generic?

> +_scratch_mount
> +
> +# set the rename and create file counts
> +file_count=50000
> +
> +# create the necessary directory for create and rename operations
> +createdir=$SCRATCH_MNT/createdir
> +mkdir $createdir
> +renamedir=$SCRATCH_MNT/renamedir
> +mkdir $renamedir
> +
> +# create many small files for the rename with RENAME_WHITEOUT
> +create_file $SCRATCH_MNT $file_count
> +
> +# try to create files at the same time to hit the deadlock
> +rename_whiteout $renamedir $file_count &
> +create_file $createdir $file_count &
> +

When I ran this test I noticed that the rename_whiteout task completed
renaming the 50k files before the create_file task created even 30k of
the 50k files. There's no risk of deadlock once one of these tasks
completes, right? If so, that seems like something that could be fixed
up.

Beyond that though, the test itself ran for almost 19 minutes on a vm
with the deadlock fix. That seems like overkill to me for a test that's
so narrowly focused on a particular bug that it's unlikely to fail in
the future. If we can't find a way to get this down to a reasonable time
while still reproducing the deadlock, I'm kind of wondering if there's a
better approach to get more rename coverage from existing tests. For
example, could we add this support to fsstress and see if any of the
existing stress tests might trigger the original problem? Even if we
needed to add a new rename/create focused fsstress test, that might at
least be general enough to provide broader coverage.

Alternatively, what if this test ran a create/rename workload (on a
smaller fileset) for a fixed time of a minute or two and then exited? I
think it would be a reasonable compromise if the test still reproduced
on some smaller frequency, it's just not clear to me how effective such
a test would be without actually trying it. Maybe Eryu has additional
thoughts..

Brian

> +wait
> +echo Silence is golden
> +
> +# Failure comes in the form of a deadlock.
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/512.out b/tests/xfs/512.out
> new file mode 100644
> index 0000000..0aabdef
> --- /dev/null
> +++ b/tests/xfs/512.out
> @@ -0,0 +1,2 @@
> +QA output created by 512
> +Silence is golden
> diff --git a/tests/xfs/group b/tests/xfs/group
> index a7ad300..ed250d6 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -509,3 +509,4 @@
>  509 auto ioctl
>  510 auto ioctl quick
>  511 auto quick quota
> +512 auto rename
> -- 
> 1.8.3.1
> 
> -- 
> kaixuxia
