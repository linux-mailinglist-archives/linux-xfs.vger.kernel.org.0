Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C8F2B2980
	for <lists+linux-xfs@lfdr.de>; Sat, 14 Nov 2020 01:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgKNAIk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 13 Nov 2020 19:08:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41728 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgKNAIk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 19:08:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0422i169098;
        Sat, 14 Nov 2020 00:08:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=4anXfsMzl466In0jjz6zFTjDXm4fAVtuQxbcYXqK73I=;
 b=Vr/aQOHp3R9Nz5smMkS9ys+9d42n9kHRwKj1MDdsAkQzhlkaMNguLqYZtp7662z+47lV
 Gz891sC6Bt4FhX/wZsKGfwRa9zTnmuYrKQ5SSvnjix/V8xwR2V6eFCIGEN6o8fzzeQqd
 g0Tu3GSJhu1e5KUD7KvIvtKfDgX7VY5uaf2RcIc4EHuvwrpQQrr6Gh42yKao/EcPw33+
 b5ew4xD3XvoZDI+9+IRLRCEDgaT7LnzOSxC9n9EcAfBTyeSkkbri40YIGdPrfTDb98ij
 /sBdX2XZjOLwgSTXUb5ThJeCx8Bf8UTssWBXmCmnyw7ozi+k5XGH1kW4fOGGyaC9Hkwo pg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34nkhmcq9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 00:08:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE06IOs119341;
        Sat, 14 Nov 2020 00:08:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34t4bs876k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 00:08:36 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AE08alZ014679;
        Sat, 14 Nov 2020 00:08:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 16:08:35 -0800
Date:   Fri, 13 Nov 2020 16:08:35 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/11] xfs: Check for extent overflow when swapping
 extents
Message-ID: <20201114000835.GA9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
 <20201113112704.28798-11-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113112704.28798-11-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011130155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130155
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 13, 2020 at 04:57:02PM +0530, Chandan Babu R wrote:
> This test verifies that XFS does not cause inode fork's extent count to
> overflow when swapping forks across two files.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  tests/xfs/530     | 115 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/530.out |  13 ++++++
>  tests/xfs/group   |   1 +
>  3 files changed, 129 insertions(+)
>  create mode 100755 tests/xfs/530
>  create mode 100644 tests/xfs/530.out
> 
> diff --git a/tests/xfs/530 b/tests/xfs/530
> new file mode 100755
> index 00000000..fccc6de7
> --- /dev/null
> +++ b/tests/xfs/530
> @@ -0,0 +1,115 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 530
> +#
> +# Verify that XFS does not cause inode fork's extent count to overflow when
> +# swapping forks between files
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
> +. ./common/inject
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_debug
> +_require_xfs_scratch_rmapbt
> +_require_xfs_io_command "fcollapse"
> +_require_xfs_io_command "swapext"

FWIW it's going to be a while before the swapext command goes upstream.
Right now it's a part of the atomic file range exchange patchset.

Do you want me to try to speed that up?

--D

> +_require_xfs_io_error_injection "reduce_max_iextents"
> +
> +echo "* Swap extent forks"
> +
> +echo "Format and mount fs"
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +bsize=$(_get_block_size $SCRATCH_MNT)
> +
> +srcfile=${SCRATCH_MNT}/srcfile
> +donorfile=${SCRATCH_MNT}/donorfile
> +
> +echo "Create \$donorfile having an extent of length 17 blocks"
> +xfs_io -f -c "pwrite -b $((17 * bsize)) 0 $((17 * bsize))" -c fsync $donorfile \
> +       >> $seqres.full
> +
> +# After the for loop the donor file will have the following extent layout
> +# | 0-4 | 5 | 6 | 7 | 8 | 9 | 10 |
> +echo "Fragment \$donorfile"
> +for i in $(seq 5 10); do
> +	start_offset=$((i * bsize))
> +	xfs_io -f -c "fcollapse $start_offset $bsize" $donorfile >> $seqres.full
> +done
> +donorino=$(stat -c "%i" $donorfile)
> +
> +echo "Create \$srcfile having an extent of length 18 blocks"
> +xfs_io -f -c "pwrite -b $((18 * bsize)) 0 $((18 * bsize))" -c fsync $srcfile \
> +       >> $seqres.full
> +
> +echo "Fragment \$srcfile"
> +# After the for loop the src file will have the following extent layout
> +# | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7-10 |
> +for i in $(seq 1 7); do
> +	start_offset=$((i * bsize))
> +	xfs_io -f -c "fcollapse $start_offset $bsize" $srcfile >> $seqres.full
> +done
> +srcino=$(stat -c "%i" $srcfile)
> +
> +_scratch_unmount >> $seqres.full
> +
> +echo "Collect \$donorfile's extent count"
> +donor_nr_exts=$(_scratch_get_iext_count $donorino data || \
> +		_fail "Unable to obtain inode fork's extent count")
> +
> +echo "Collect \$srcfile's extent count"
> +src_nr_exts=$(_scratch_get_iext_count $srcino data || \
> +		_fail "Unable to obtain inode fork's extent count")
> +
> +_scratch_mount >> $seqres.full
> +
> +echo "Inject reduce_max_iextents error tag"
> +xfs_io -x -c 'inject reduce_max_iextents' $SCRATCH_MNT
> +
> +echo "Swap \$srcfile's and \$donorfile's extent forks"
> +xfs_io -f -c "swapext $donorfile" $srcfile >> $seqres.full 2>&1
> +
> +_scratch_unmount >> $seqres.full
> +
> +echo "Check for \$donorfile's extent count overflow"
> +nextents=$(_scratch_get_iext_count $donorino data || \
> +		_fail "Unable to obtain inode fork's extent count")
> +if (( $nextents == $src_nr_exts )); then
> +	echo "\$donorfile: Extent count overflow check failed"
> +fi
> +
> +echo "Check for \$srcfile's extent count overflow"
> +nextents=$(_scratch_get_iext_count $srcino data || \
> +		_fail "Unable to obtain inode fork's extent count")
> +if (( $nextents == $donor_nr_exts )); then
> +	echo "\$srcfile: Extent count overflow check failed"
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/530.out b/tests/xfs/530.out
> new file mode 100644
> index 00000000..996af959
> --- /dev/null
> +++ b/tests/xfs/530.out
> @@ -0,0 +1,13 @@
> +QA output created by 530
> +* Swap extent forks
> +Format and mount fs
> +Create $donorfile having an extent of length 17 blocks
> +Fragment $donorfile
> +Create $srcfile having an extent of length 18 blocks
> +Fragment $srcfile
> +Collect $donorfile's extent count
> +Collect $srcfile's extent count
> +Inject reduce_max_iextents error tag
> +Swap $srcfile's and $donorfile's extent forks
> +Check for $donorfile's extent count overflow
> +Check for $srcfile's extent count overflow
> diff --git a/tests/xfs/group b/tests/xfs/group
> index bc3958b3..81a15582 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -527,3 +527,4 @@
>  527 auto quick
>  528 auto quick reflink
>  529 auto quick reflink
> +530 auto quick
> -- 
> 2.28.0
> 
