Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF47947602
	for <lists+linux-xfs@lfdr.de>; Sun, 16 Jun 2019 19:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbfFPRBP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 16 Jun 2019 13:01:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbfFPRBP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 16 Jun 2019 13:01:15 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DFFFF308FEDF;
        Sun, 16 Jun 2019 17:01:14 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 575F1619D4;
        Sun, 16 Jun 2019 17:01:14 +0000 (UTC)
Date:   Mon, 17 Jun 2019 01:06:25 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test xfs_info on block device and mountpoint
Message-ID: <20190616170625.GE30864@dhcp-12-102.nay.redhat.com>
References: <20190614044954.22022-1-zlang@redhat.com>
 <20190616164948.GD1872778@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190616164948.GD1872778@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Sun, 16 Jun 2019 17:01:14 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 16, 2019 at 09:49:48AM -0700, Darrick J. Wong wrote:
> On Fri, Jun 14, 2019 at 12:49:54PM +0800, Zorro Lang wrote:
> > There was a bug, xfs_info fails on a mounted block device:
> > 
> >   # xfs_info /dev/mapper/testdev
> >   xfs_info: /dev/mapper/testdev contains a mounted filesystem
> > 
> >   fatal error -- couldn't initialize XFS library
> > 
> > xfsprogs has fixed it, this case is used to cover this bug.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> >  tests/xfs/1000     | 65 ++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/1000.out |  2 ++
> >  tests/xfs/group    |  1 +
> >  3 files changed, 68 insertions(+)
> >  create mode 100755 tests/xfs/1000
> >  create mode 100644 tests/xfs/1000.out
> > 
> > diff --git a/tests/xfs/1000 b/tests/xfs/1000
> > new file mode 100755
> > index 00000000..689fe9e7
> > --- /dev/null
> > +++ b/tests/xfs/1000
> > @@ -0,0 +1,65 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 1000
> > +#
> > +# test xfs_info on block device and mountpoint
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_supported_os Linux
> > +_require_scratch
> > +
> > +test_xfs_info()
> > +{
> > +	local target="$1"
> > +	local file=$tmp.$seq.info
> > +
> > +	$XFS_INFO_PROG $target > $file 2>&1
> > +	if [ $? -ne 0 ];then
> > +		echo "$XFS_INFO_PROG $target fails:"
> > +		cat $file
> 
> Should we compare the contents between the two xfs_info invocations?

Hmm, make sense!

> 
> > +	else
> > +		cat $file >> $seqres.full
> > +	fi
> > +}
> > +
> > +_scratch_mkfs > $seqres.full 2>&1
> > +# test unmounted block device(contains XFS)
> > +# Due to old xfsprogs doesn't support xfs_info a unmounted device, skip it
> > +$XFS_DB_PROG -c "info" $SCRATCH_DEV | grep -q "command info not found"
> 
> Does _require_xfs_db_command not work here?

Wow, I forgot it, thanks for reminding:)

> 
> --D
> 
> > +if [ $? -ne 0 ]; then
> > +	test_xfs_info $SCRATCH_DEV
> > +fi
> > +
> > +_scratch_mount
> > +# test mounted block device and mountpoint
> > +test_xfs_info $SCRATCH_DEV
> > +test_xfs_info $SCRATCH_MNT
> > +
> > +echo "Silence is golden"
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/1000.out b/tests/xfs/1000.out
> > new file mode 100644
> > index 00000000..681b3b48
> > --- /dev/null
> > +++ b/tests/xfs/1000.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 1000
> > +Silence is golden
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index ffe4ae12..047fe332 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -504,3 +504,4 @@
> >  504 auto quick mkfs label
> >  505 auto quick spaceman
> >  506 auto quick health
> > +1000 auto quick
> > -- 
> > 2.17.2
> > 
