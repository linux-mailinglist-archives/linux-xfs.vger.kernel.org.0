Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4598426AD67
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Sep 2020 21:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgIOTVp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 15 Sep 2020 15:21:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45606 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727579AbgIOTVk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Sep 2020 15:21:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FG3ZHe133880;
        Tue, 15 Sep 2020 16:05:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=lyvU4v7amMXQTFyOYZMnZH3TZTiX7S3hG+kfb9JFSgU=;
 b=U5rRpS8PE1TuN6+blvddhUbrJs7HQpdBy815o/B+snlYUHiqiIxFmC5YZ1JjV9p2h26f
 fKOjcwPtCQ1h7VW+l0H3kV2fthFvyVMdMQjWnTcLmtl/zAlIeOLVRgm7EBVq6T+Qa3N8
 6aL2X0yO5gMlVuZ/XRFjlzZBk+xqmpueuv8AORRL+3QERGvDnOE2JFv207aptNMEpEYO
 /Dv8ZtZewmoiZ8GleTF8Y5D+0zVxGoee88ofFOxX8KnCRbkqawOTYXpaNQ2aygdedfb9
 tlZBaLdt5I8iACaFEJWbURZeJlpE//1Dja4SKOLKvjfjM52oZuj3BW631XE6qlAFQQUP ZA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33gnrqx37m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 16:05:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FFjpvX091003;
        Tue, 15 Sep 2020 16:05:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 33hm30tdbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 16:05:34 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08FG5X3p029431;
        Tue, 15 Sep 2020 16:05:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 16:05:33 +0000
Date:   Tue, 15 Sep 2020 09:05:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        guaneryu@gmail.com, zlang@redhat.com
Subject: Re: [PATCH V2] xfs: Check if rt summary/bitmap buffers are logged
 with correct xfs_buf type
Message-ID: <20200915160532.GC7955@magnolia>
References: <20200915054748.1765-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915054748.1765-1-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1011 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 15, 2020 at 11:17:48AM +0530, Chandan Babu R wrote:
> This commit adds a test to check if growing a real-time device can end
> up logging an xfs_buf with the "type" subfield of
> bip->bli_formats->blf_flags set to XFS_BLFT_UNKNOWN_BUF. When this
> occurs the following call trace is printed on the console,
> 
> XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 331
> Call Trace:
>  xfs_buf_item_format+0x632/0x680
>  ? kmem_alloc_large+0x29/0x90
>  ? kmem_alloc+0x70/0x120
>  ? xfs_log_commit_cil+0x132/0x940
>  xfs_log_commit_cil+0x26f/0x940
>  ? xfs_buf_item_init+0x1ad/0x240
>  ? xfs_growfs_rt_alloc+0x1fc/0x280
>  __xfs_trans_commit+0xac/0x370
>  xfs_growfs_rt_alloc+0x1fc/0x280
>  xfs_growfs_rt+0x1a0/0x5e0
>  xfs_file_ioctl+0x3fd/0xc70
>  ? selinux_file_ioctl+0x174/0x220
>  ksys_ioctl+0x87/0xc0
>  __x64_sys_ioctl+0x16/0x20
>  do_syscall_64+0x3e/0x70
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> The kernel patch "xfs: Set xfs_buf type flag when growing summary/bitmap
> files" is required to fix this issue.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good to me
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  tests/xfs/260     | 53 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/260.out |  2 ++
>  tests/xfs/group   |  1 +
>  3 files changed, 56 insertions(+)
>  create mode 100755 tests/xfs/260
>  create mode 100644 tests/xfs/260.out
> 
> diff --git a/tests/xfs/260 b/tests/xfs/260
> new file mode 100755
> index 00000000..078d4a11
> --- /dev/null
> +++ b/tests/xfs/260
> @@ -0,0 +1,53 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
> +#
> +# FS QA Test 260
> +#
> +# Test to check if growing a real-time device can end up logging an xfs_buf with
> +# the "type" subfield of bip->bli_formats->blf_flags set to
> +# XFS_BLFT_UNKNOWN_BUF.
> +#
> +# This is a regression test for the kernel patch "xfs: Set xfs_buf type flag
> +# when growing summary/bitmap files".
> +
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
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_realtime
> +
> +_scratch_mkfs -r size=10M  >> $seqres.full
> +
> +_scratch_mount >> $seqres.full
> +
> +$XFS_GROWFS_PROG $SCRATCH_MNT >> $seqres.full
> +
> +_scratch_unmount
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/260.out b/tests/xfs/260.out
> new file mode 100644
> index 00000000..18ca517c
> --- /dev/null
> +++ b/tests/xfs/260.out
> @@ -0,0 +1,2 @@
> +QA output created by 260
> +Silence is golden
> diff --git a/tests/xfs/group b/tests/xfs/group
> index ed0d389e..68676064 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -257,6 +257,7 @@
>  257 auto quick clone
>  258 auto quick clone
>  259 auto quick
> +260 auto quick growfs realtime
>  261 auto quick quota
>  262 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>  263 auto quick quota
> -- 
> 2.28.0
> 
