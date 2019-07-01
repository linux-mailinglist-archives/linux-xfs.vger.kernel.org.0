Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDB82AA3D
	for <lists+linux-xfs@lfdr.de>; Sun, 26 May 2019 16:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbfEZO1n (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 May 2019 10:27:43 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43225 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbfEZO1n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 May 2019 10:27:43 -0400
Received: by mail-pf1-f193.google.com with SMTP id c6so8036557pfa.10;
        Sun, 26 May 2019 07:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ehzEoKrdphjbMIq46vXKlTqXVZHQFCCkBe4ZfsYtVyo=;
        b=BZVDAP2Ju18aX/D7jxcxaRzgI+aE3qLPGLXzTXEdgN0f+fpqwtrSXhQXycoxgiLURR
         ymo8+3oxDMwcd8MBxMYmoLn+9XIV6MiWT19zNPK8ASIxXAMydv2fsCm+ShqAT3ul2KkF
         dJEOApBCRsRNZEzjC/TdfQzc78CpmX1iZTtZcsVUB6mx1O/hlMPXXb3kM0cvusRFKHmQ
         ELsWbeJJeqZhP9st6rQGEjU/7FZxI90sVSXUzvohHkXkC8H8OTNXc0S85ipm6Z24D9HO
         SAp5yHNSTz0C4MQrSetejxT7tA3yrAtshe93qmXdNjijbXBdIDIZaxT1S7wWQlbp/2rd
         7vWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ehzEoKrdphjbMIq46vXKlTqXVZHQFCCkBe4ZfsYtVyo=;
        b=r03kmiWy0VOzzHzrTG4maYfSUdUWSG4vyerv2KLxh6ujZwKUwouT/DHy+7i02mRjQW
         sN3EMROL49ovapr60mI+DmJ/AMUC15C7wvn1RW/U9yQwoUcgYT/DCgP6lTU2UGlHyqZm
         3ZTbR8Y3NG0xy7CzAJ2nBj9uISkXt1YxfrOpNuK5oYotkRdMMIf9VKWm5nL3LjK1wija
         nWR2LqH2YEU+HQelfEIeqw/qT9TFmmd4OQNxaaApMkb+GQL+EML3NSfiCtRKLboDkXst
         MAvxEogDHE+9EQs5bt1WTA9uhPhfyWisAoRf0eMjAZvbCOvG/68YxRrz17gFXeb1Y0sn
         YPQg==
X-Gm-Message-State: APjAAAW6elBjPBqFX5MgrJ521UdACrAl0V1zVZQZaytKLh+1BqO33hiR
        gGm75q5slFihXzOcroJlgCE=
X-Google-Smtp-Source: APXvYqwkiFciwcA+9phfINhMkOW0UI46bKoTN/4rhUyc8rc171XlnlVXEH8fh7z09doIpjhnN9kvTw==
X-Received: by 2002:a65:420a:: with SMTP id c10mr52213992pgq.376.1558880862256;
        Sun, 26 May 2019 07:27:42 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id s2sm8563359pfe.105.2019.05.26.07.27.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 26 May 2019 07:27:41 -0700 (PDT)
Date:   Sun, 26 May 2019 22:27:35 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH ] xfs: check for COW overflows in i_delayed_blks
Message-ID: <20190526142735.GP15846@desktop>
References: <155839150599.62947.16097306072591964009.stgit@magnolia>
 <155839151219.62947.9627045046429149685.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155839151219.62947.9627045046429149685.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 03:31:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> With the new copy on write functionality it's possible to reserve so
> much COW space for a file that we end up overflowing i_delayed_blks.
> The only user-visible effect of this is to cause totally wrong i_blocks
> output in stat, so check for that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I hit xfs_db killed by OOM killer (2 vcpu, 8G memory kvm guest) when
trying this test and the test takes too long time (I changed the fs size
from 300T to 300G and tried a test run), perhaps that's why you don't
put it in auto group?

> ---
>  tests/xfs/907     |  180 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/907.out |    8 ++
>  tests/xfs/group   |    1 
>  3 files changed, 189 insertions(+)
>  create mode 100755 tests/xfs/907
>  create mode 100644 tests/xfs/907.out
> 
> 
> diff --git a/tests/xfs/907 b/tests/xfs/907
> new file mode 100755
> index 00000000..2c21ac8e
> --- /dev/null
> +++ b/tests/xfs/907
> @@ -0,0 +1,180 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 907
> +#
> +# Try to overflow i_delayed_blks by setting the largest cowextsize hint
> +# possible, creating a sparse file with a single byte every cowextsize bytes,
> +# reflinking it, and retouching every written byte to see if we can create
> +# enough speculative COW reservations to overflow i_delayed_blks.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 7 15
> +
> +_cleanup()
> +{
> +	cd /

Need to '_destroy_loop_device $loop_dev' too

> +	umount $loop_mount > /dev/null 2>&1

$UMOUNT_PROG

> +	rm -rf $tmp.*
> +}

And loop_dev and loop_mount should be defined before _cleanup()?

> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/reflink
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_os Linux
> +_supported_fs xfs
> +_require_scratch_reflink
> +_require_loop
> +_require_xfs_debug	# needed for xfs_bmap -c

_require_cp_reflink

> +
> +MAXEXTLEN=2097151	# cowextsize can't be more than MAXEXTLEN
> +
> +# Create a huge sparse filesystem on the scratch device because that's what
> +# we're going to need to guarantee that we have enough blocks to overflow in
> +# the first place.  In the worst case we have a 64k-block filesystem in which
> +# we have to be able to reserve 2^32 blocks.  Adding in 20% overhead and a
> +# 128M log, we get about 300T.
> +echo "Format and mount"
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_fs_space $SCRATCH_MNT 200000	# 300T fs requires ~200MB of space

I noticed the 'a.img' file consumed more than 5G space, is 200MB
enough?

> +
> +loop_file=$SCRATCH_MNT/a.img
> +loop_mount=$SCRATCH_MNT/a
> +truncate -s 300T $loop_file

$XFS_IO_PROG -fc "truncate 300T" $loop_file

> +loop_dev=$(_create_loop_device $loop_file)
> +
> +# Now we have to create the source file.  The goal is to overflow a 32-bit
> +# i_delayed_blks, which means that we have to create at least that many delayed
> +# allocation block reservations.  Take advantage of the fact that a cowextsize
> +# hint causes creation of large speculative delalloc reservations in the cow
> +# fork to reduce the amount of work we have to do.
> +#
> +# The maximum cowextsize is going to be MAXEXTLEN fs blocks on a 100T
> +# filesystem, so start by setting up the hint.  Note that the current fsxattr
> +# interface specifies its u32 cowextsize hint in units of bytes and therefore
> +# can't handle MAXEXTLEN * blksz on most filesystems, so we set it via mkfs
> +# because mkfs takes units of fs blocks, not bytes.
> +
> +_mkfs_dev -d cowextsize=$MAXEXTLEN -l size=128m $loop_dev >> $seqres.full
> +mkdir $loop_mount
> +mount -t xfs $loop_dev $loop_mount

_mount $loop_dev $loop_mount

> +
> +echo "Create crazy huge file"
> +huge_file="$loop_mount/a"
> +touch "$huge_file"
> +blksz=$(_get_file_block_size "$loop_mount")
> +extsize_bytes="$(( MAXEXTLEN * blksz ))"
> +
> +# Make sure it actually set a hint.
> +curr_cowextsize_str="$($XFS_IO_PROG -c 'cowextsize' "$huge_file")"
> +echo "$curr_cowextsize_str" >> $seqres.full
> +cowextsize_bytes="$(echo "$curr_cowextsize_str" | sed -e 's/^.\([0-9]*\).*$/\1/g')"
> +test "$cowextsize_bytes" -eq 0 && echo "could not set cowextsize?"
> +
> +# Now we have to seed the file with sparse contents.  Remember, the goal is to
> +# create a little more than 2^32 delayed allocation blocks in the COW fork with
> +# as little effort as possible.  We know that speculative COW preallocation
> +# will create MAXEXTLEN-length reservations for us, so that means we should
> +# be able to get away with touching a single byte every extsize_bytes.  We
> +# do this backwards to avoid having to move EOF.
> +nr="$(( ((2 ** 32) / MAXEXTLEN) + 100 ))"
> +seq $nr -1 0 | while read n; do
> +	off="$((n * extsize_bytes))"
> +	$XFS_IO_PROG -c "pwrite $off 1" "$huge_file" > /dev/null
> +done
> +
> +echo "Reflink crazy huge file"
> +_cp_reflink "$huge_file" "$huge_file.b"
> +
> +# Now that we've shared all the blocks in the file, we touch them all again
> +# to create speculative COW preallocations.
> +echo "COW crazy huge file"
> +seq $nr -1 0 | while read n; do
> +	off="$((n * extsize_bytes))"
> +	$XFS_IO_PROG -c "pwrite $off 1" "$huge_file" > /dev/null
> +done
> +
> +# Compare the number of blocks allocated to this file (as reported by stat)
> +# against the number of blocks that are in the COW fork.  If either one is
> +# less than 2^32 then we have evidence of an overflow problem.
> +echo "Check crazy huge file"
> +allocated_stat_blocks="$(stat -c %b "$huge_file")"
> +stat_blksz="$(stat -c %B "$huge_file")"
> +allocated_fsblocks=$(( allocated_stat_blocks * stat_blksz / blksz ))
> +
> +# Make sure we got enough COW reservations to overflow a 32-bit counter.
> +
> +# Return the number of delalloc & real blocks given bmap output for a fork of a
> +# file.  Output is in units of 512-byte blocks.
> +count_fork_blocks() {
> +	awk "

$AWK_PROG

> +{
> +	if (\$3 == \"delalloc\") {
> +		x += \$4;
> +	} else if (\$3 == \"hole\") {
> +		;
> +	} else {
> +		x += \$6;
> +	}
> +}
> +END {
> +	print(x);
> +}
> +"
> +}
> +
> +# Count the number of blocks allocated to a file based on the xfs_bmap output.
> +# Output is in units of filesystem blocks.
> +count_file_fork_blocks() {
> +	local tag="$1"
> +	local file="$2"
> +	local args="$3"
> +
> +	$XFS_IO_PROG -c "bmap $args -l -p -v" "$huge_file" > $tmp.extents
> +	echo "$tag fork map" >> $seqres.full
> +	cat $tmp.extents >> $seqres.full
> +	local sectors="$(count_fork_blocks < $tmp.extents)"
> +	echo "$(( sectors / (blksz / 512) ))"
> +}
> +
> +cowblocks=$(count_file_fork_blocks cow "$huge_file" "-c")
> +attrblocks=$(count_file_fork_blocks attr "$huge_file" "-a")
> +datablocks=$(count_file_fork_blocks data "$huge_file" "")
> +
> +# Did we create more than 2^32 blocks in the cow fork?
> +echo "datablocks is $datablocks" >> $seqres.full
> +echo "attrblocks is $attrblocks" >> $seqres.full
> +echo "cowblocks is $cowblocks" >> $seqres.full
> +test "$cowblocks" -lt $((2 ** 32)) && \
> +	echo "cowblocks (${cowblocks}) should be more than 2^32!"
> +
> +# Does stat's block allocation count exceed 2^32?
> +echo "stat blocks is $allocated_fsblocks" >> $seqres.full
> +test "$allocated_fsblocks" -lt $((2 ** 32)) && \
> +	echo "stat blocks (${allocated_fsblocks}) should be more than 2^32!"
> +
> +# Finally, does st_blocks match what we computed from the forks?
> +expected_allocated_fsblocks=$((datablocks + cowblocks + attrblocks))
> +echo "expected stat blocks is $expected_allocated_fsblocks" >> $seqres.full
> +
> +_within_tolerance "st_blocks" $allocated_fsblocks $expected_allocated_fsblocks 2% -v
> +
> +echo "Test done"
> +_check_xfs_filesystem $loop_dev none none
> +umount $loop_mount

$UMOUNT_PROG

Thanks,
Eryu

> +_destroy_loop_device $loop_dev
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/907.out b/tests/xfs/907.out
> new file mode 100644
> index 00000000..cc07d659
> --- /dev/null
> +++ b/tests/xfs/907.out
> @@ -0,0 +1,8 @@
> +QA output created by 907
> +Format and mount
> +Create crazy huge file
> +Reflink crazy huge file
> +COW crazy huge file
> +Check crazy huge file
> +st_blocks is in range
> +Test done
> 
