Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D18242CCF1
	for <lists+linux-xfs@lfdr.de>; Tue, 28 May 2019 19:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfE1RDj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 28 May 2019 13:03:39 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60888 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbfE1RDj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 May 2019 13:03:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4SH1FT1008750;
        Tue, 28 May 2019 17:03:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=soecN+QVvp57JnOcIkBC4sLBdw0MNQUBwpDWB+owhJE=;
 b=lYyeYPgdToBZRAIMb2mVGoyMH/Z7m+a/IxKtCTtPuHv7e82QiTKZA8ij+WcQcZgkUjeU
 Gyy7ERB4BfyNugPR9teXCghfzPou9VwqEVpt47lvBVCzC+7YmmjI6yUCBYIx2fuHreLa
 d/vtgoxCOORXv30Wkxgvu5agDFtH7LZKZrm2eX7BwLN20sWJBIw6tg30h2D+qdOivktx
 8SKqn8uanmyfnt9sWAv8eJ2xv38VSNhOzTRVn4IyBkcRaq4tNB5K6UJfm5lmRKQeUN01
 xoOPBROaPuJ7oLfRhpjDIyvycA3c03NStsJyy3FY09SeWv5RplhIxhP5uL7MMx5dTij5 +Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2spxbq4hqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 May 2019 17:03:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4SGxwn3034334;
        Tue, 28 May 2019 17:01:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2sr31usdk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 May 2019 17:01:34 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4SH1XPR031872;
        Tue, 28 May 2019 17:01:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 May 2019 10:01:32 -0700
Date:   Tue, 28 May 2019 10:01:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH ] xfs: check for COW overflows in i_delayed_blks
Message-ID: <20190528170132.GA5231@magnolia>
References: <155839150599.62947.16097306072591964009.stgit@magnolia>
 <155839151219.62947.9627045046429149685.stgit@magnolia>
 <20190526142735.GP15846@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190526142735.GP15846@desktop>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9270 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905280107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9271 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905280108
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 26, 2019 at 10:27:35PM +0800, Eryu Guan wrote:
> On Mon, May 20, 2019 at 03:31:52PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > With the new copy on write functionality it's possible to reserve so
> > much COW space for a file that we end up overflowing i_delayed_blks.
> > The only user-visible effect of this is to cause totally wrong i_blocks
> > output in stat, so check for that.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I hit xfs_db killed by OOM killer (2 vcpu, 8G memory kvm guest) when
> trying this test and the test takes too long time (I changed the fs size
> from 300T to 300G and tried a test run), perhaps that's why you don't
> put it in auto group?

Oh.  Right.  I forget that I patched out xfs_db from
check_xfs_filesystem on my dev tree years ago.

Um... do we want to remove xfs_db from the check function?  Or just open
code a call to xfs_repair $SCRATCH_MNT/a.img at the end of the test?

As for the 300T size, the reason I picked that is to force the
filesystem to have large enough AGs to support the maximum cowextsize
hint.  I'll see if it still works with a 4TB filesystem.

> > ---
> >  tests/xfs/907     |  180 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/907.out |    8 ++
> >  tests/xfs/group   |    1 
> >  3 files changed, 189 insertions(+)
> >  create mode 100755 tests/xfs/907
> >  create mode 100644 tests/xfs/907.out
> > 
> > 
> > diff --git a/tests/xfs/907 b/tests/xfs/907
> > new file mode 100755
> > index 00000000..2c21ac8e
> > --- /dev/null
> > +++ b/tests/xfs/907
> > @@ -0,0 +1,180 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0+
> > +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 907
> > +#
> > +# Try to overflow i_delayed_blks by setting the largest cowextsize hint
> > +# possible, creating a sparse file with a single byte every cowextsize bytes,
> > +# reflinking it, and retouching every written byte to see if we can create
> > +# enough speculative COW reservations to overflow i_delayed_blks.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 7 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> 
> Need to '_destroy_loop_device $loop_dev' too
> 
> > +	umount $loop_mount > /dev/null 2>&1
> 
> $UMOUNT_PROG
> 
> > +	rm -rf $tmp.*
> > +}
> 
> And loop_dev and loop_mount should be defined before _cleanup()?

Fixed all three.

> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/reflink
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_supported_fs xfs
> > +_require_scratch_reflink
> > +_require_loop
> > +_require_xfs_debug	# needed for xfs_bmap -c
> 
> _require_cp_reflink

...all four.

> 
> > +
> > +MAXEXTLEN=2097151	# cowextsize can't be more than MAXEXTLEN
> > +
> > +# Create a huge sparse filesystem on the scratch device because that's what
> > +# we're going to need to guarantee that we have enough blocks to overflow in
> > +# the first place.  In the worst case we have a 64k-block filesystem in which
> > +# we have to be able to reserve 2^32 blocks.  Adding in 20% overhead and a
> > +# 128M log, we get about 300T.
> > +echo "Format and mount"
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +_require_fs_space $SCRATCH_MNT 200000	# 300T fs requires ~200MB of space
> 
> I noticed the 'a.img' file consumed more than 5G space, is 200MB
> enough?

Hmm, I tried it on a 64k block filesystem and evidently now we need a
~200M log to satisfy minimum log size requirements, and the filesystem
image needs ~660MB of space on the scratch fs.

> > +
> > +loop_file=$SCRATCH_MNT/a.img
> > +loop_mount=$SCRATCH_MNT/a
> > +truncate -s 300T $loop_file
> 
> $XFS_IO_PROG -fc "truncate 300T" $loop_file
> 
> > +loop_dev=$(_create_loop_device $loop_file)
> > +
> > +# Now we have to create the source file.  The goal is to overflow a 32-bit
> > +# i_delayed_blks, which means that we have to create at least that many delayed
> > +# allocation block reservations.  Take advantage of the fact that a cowextsize
> > +# hint causes creation of large speculative delalloc reservations in the cow
> > +# fork to reduce the amount of work we have to do.
> > +#
> > +# The maximum cowextsize is going to be MAXEXTLEN fs blocks on a 100T
> > +# filesystem, so start by setting up the hint.  Note that the current fsxattr
> > +# interface specifies its u32 cowextsize hint in units of bytes and therefore
> > +# can't handle MAXEXTLEN * blksz on most filesystems, so we set it via mkfs
> > +# because mkfs takes units of fs blocks, not bytes.
> > +
> > +_mkfs_dev -d cowextsize=$MAXEXTLEN -l size=128m $loop_dev >> $seqres.full
> > +mkdir $loop_mount
> > +mount -t xfs $loop_dev $loop_mount
> 
> _mount $loop_dev $loop_mount
> 
> > +
> > +echo "Create crazy huge file"
> > +huge_file="$loop_mount/a"
> > +touch "$huge_file"
> > +blksz=$(_get_file_block_size "$loop_mount")
> > +extsize_bytes="$(( MAXEXTLEN * blksz ))"
> > +
> > +# Make sure it actually set a hint.
> > +curr_cowextsize_str="$($XFS_IO_PROG -c 'cowextsize' "$huge_file")"
> > +echo "$curr_cowextsize_str" >> $seqres.full
> > +cowextsize_bytes="$(echo "$curr_cowextsize_str" | sed -e 's/^.\([0-9]*\).*$/\1/g')"
> > +test "$cowextsize_bytes" -eq 0 && echo "could not set cowextsize?"
> > +
> > +# Now we have to seed the file with sparse contents.  Remember, the goal is to
> > +# create a little more than 2^32 delayed allocation blocks in the COW fork with
> > +# as little effort as possible.  We know that speculative COW preallocation
> > +# will create MAXEXTLEN-length reservations for us, so that means we should
> > +# be able to get away with touching a single byte every extsize_bytes.  We
> > +# do this backwards to avoid having to move EOF.
> > +nr="$(( ((2 ** 32) / MAXEXTLEN) + 100 ))"
> > +seq $nr -1 0 | while read n; do
> > +	off="$((n * extsize_bytes))"
> > +	$XFS_IO_PROG -c "pwrite $off 1" "$huge_file" > /dev/null
> > +done
> > +
> > +echo "Reflink crazy huge file"
> > +_cp_reflink "$huge_file" "$huge_file.b"
> > +
> > +# Now that we've shared all the blocks in the file, we touch them all again
> > +# to create speculative COW preallocations.
> > +echo "COW crazy huge file"
> > +seq $nr -1 0 | while read n; do
> > +	off="$((n * extsize_bytes))"
> > +	$XFS_IO_PROG -c "pwrite $off 1" "$huge_file" > /dev/null
> > +done
> > +
> > +# Compare the number of blocks allocated to this file (as reported by stat)
> > +# against the number of blocks that are in the COW fork.  If either one is
> > +# less than 2^32 then we have evidence of an overflow problem.
> > +echo "Check crazy huge file"
> > +allocated_stat_blocks="$(stat -c %b "$huge_file")"
> > +stat_blksz="$(stat -c %B "$huge_file")"
> > +allocated_fsblocks=$(( allocated_stat_blocks * stat_blksz / blksz ))
> > +
> > +# Make sure we got enough COW reservations to overflow a 32-bit counter.
> > +
> > +# Return the number of delalloc & real blocks given bmap output for a fork of a
> > +# file.  Output is in units of 512-byte blocks.
> > +count_fork_blocks() {
> > +	awk "
> 
> $AWK_PROG
> 
> > +{
> > +	if (\$3 == \"delalloc\") {
> > +		x += \$4;
> > +	} else if (\$3 == \"hole\") {
> > +		;
> > +	} else {
> > +		x += \$6;
> > +	}
> > +}
> > +END {
> > +	print(x);
> > +}
> > +"
> > +}
> > +
> > +# Count the number of blocks allocated to a file based on the xfs_bmap output.
> > +# Output is in units of filesystem blocks.
> > +count_file_fork_blocks() {
> > +	local tag="$1"
> > +	local file="$2"
> > +	local args="$3"
> > +
> > +	$XFS_IO_PROG -c "bmap $args -l -p -v" "$huge_file" > $tmp.extents
> > +	echo "$tag fork map" >> $seqres.full
> > +	cat $tmp.extents >> $seqres.full
> > +	local sectors="$(count_fork_blocks < $tmp.extents)"
> > +	echo "$(( sectors / (blksz / 512) ))"
> > +}
> > +
> > +cowblocks=$(count_file_fork_blocks cow "$huge_file" "-c")
> > +attrblocks=$(count_file_fork_blocks attr "$huge_file" "-a")
> > +datablocks=$(count_file_fork_blocks data "$huge_file" "")
> > +
> > +# Did we create more than 2^32 blocks in the cow fork?
> > +echo "datablocks is $datablocks" >> $seqres.full
> > +echo "attrblocks is $attrblocks" >> $seqres.full
> > +echo "cowblocks is $cowblocks" >> $seqres.full
> > +test "$cowblocks" -lt $((2 ** 32)) && \
> > +	echo "cowblocks (${cowblocks}) should be more than 2^32!"
> > +
> > +# Does stat's block allocation count exceed 2^32?
> > +echo "stat blocks is $allocated_fsblocks" >> $seqres.full
> > +test "$allocated_fsblocks" -lt $((2 ** 32)) && \
> > +	echo "stat blocks (${allocated_fsblocks}) should be more than 2^32!"
> > +
> > +# Finally, does st_blocks match what we computed from the forks?
> > +expected_allocated_fsblocks=$((datablocks + cowblocks + attrblocks))
> > +echo "expected stat blocks is $expected_allocated_fsblocks" >> $seqres.full
> > +
> > +_within_tolerance "st_blocks" $allocated_fsblocks $expected_allocated_fsblocks 2% -v
> > +
> > +echo "Test done"
> > +_check_xfs_filesystem $loop_dev none none
> > +umount $loop_mount
> 
> $UMOUNT_PROG

Fixed all the minor changes.

--D

> 
> Thanks,
> Eryu
> 
> > +_destroy_loop_device $loop_dev
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/907.out b/tests/xfs/907.out
> > new file mode 100644
> > index 00000000..cc07d659
> > --- /dev/null
> > +++ b/tests/xfs/907.out
> > @@ -0,0 +1,8 @@
> > +QA output created by 907
> > +Format and mount
> > +Create crazy huge file
> > +Reflink crazy huge file
> > +COW crazy huge file
> > +Check crazy huge file
> > +st_blocks is in range
> > +Test done
> > 
