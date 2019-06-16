Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D29475F7
	for <lists+linux-xfs@lfdr.de>; Sun, 16 Jun 2019 18:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfFPQuI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 16 Jun 2019 12:50:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37150 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfFPQuI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Jun 2019 12:50:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5GGnM5r049606;
        Sun, 16 Jun 2019 16:49:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=et8auwxWD5g6MgmRjFeiMyCO7v5iHMPDsGz/kZ48SY0=;
 b=OeRQCZMRMhaCMKWsRikEwAxXLNJd+pHpg3cVpI4jDBItw1uAHsWro4/bboCG+byKAjEV
 e78i9GXS+qtZcX5x+xVoB4V6AbaLwESH5AC4p9gcCOeYsdQYW8KbyRGJ3sRBafrNbVr3
 izOAyGAfGm6yqE1JgOjAGdPiDUPjfRcoG/sF/wjWIa8E2bX4Wiuw7YQX5dP5NkozoIUu
 GILv2wNk1O5U7Jfo24Suxs8xezFLJ090rNtaG8LYa2CqFNq0L/8TCZ76BZPA1b0W1aza
 x4Ozc19tV4i2yb7zKz3RGDPEDjElRc0mL8HUFtHil754GxRQMKD77a1VifOM7nxth2F4 Ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t4saq35hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Jun 2019 16:49:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5GGn2wZ186868;
        Sun, 16 Jun 2019 16:49:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2t5h5stsrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Jun 2019 16:49:51 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5GGnovO024075;
        Sun, 16 Jun 2019 16:49:50 GMT
Received: from localhost (/70.95.137.242)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 16 Jun 2019 09:49:50 -0700
Date:   Sun, 16 Jun 2019 09:49:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test xfs_info on block device and mountpoint
Message-ID: <20190616164948.GD1872778@magnolia>
References: <20190614044954.22022-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614044954.22022-1-zlang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9290 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906160162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9290 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906160162
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 14, 2019 at 12:49:54PM +0800, Zorro Lang wrote:
> There was a bug, xfs_info fails on a mounted block device:
> 
>   # xfs_info /dev/mapper/testdev
>   xfs_info: /dev/mapper/testdev contains a mounted filesystem
> 
>   fatal error -- couldn't initialize XFS library
> 
> xfsprogs has fixed it, this case is used to cover this bug.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  tests/xfs/1000     | 65 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1000.out |  2 ++
>  tests/xfs/group    |  1 +
>  3 files changed, 68 insertions(+)
>  create mode 100755 tests/xfs/1000
>  create mode 100644 tests/xfs/1000.out
> 
> diff --git a/tests/xfs/1000 b/tests/xfs/1000
> new file mode 100755
> index 00000000..689fe9e7
> --- /dev/null
> +++ b/tests/xfs/1000
> @@ -0,0 +1,65 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 1000
> +#
> +# test xfs_info on block device and mountpoint
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
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch
> +
> +test_xfs_info()
> +{
> +	local target="$1"
> +	local file=$tmp.$seq.info
> +
> +	$XFS_INFO_PROG $target > $file 2>&1
> +	if [ $? -ne 0 ];then
> +		echo "$XFS_INFO_PROG $target fails:"
> +		cat $file

Should we compare the contents between the two xfs_info invocations?

> +	else
> +		cat $file >> $seqres.full
> +	fi
> +}
> +
> +_scratch_mkfs > $seqres.full 2>&1
> +# test unmounted block device(contains XFS)
> +# Due to old xfsprogs doesn't support xfs_info a unmounted device, skip it
> +$XFS_DB_PROG -c "info" $SCRATCH_DEV | grep -q "command info not found"

Does _require_xfs_db_command not work here?

--D

> +if [ $? -ne 0 ]; then
> +	test_xfs_info $SCRATCH_DEV
> +fi
> +
> +_scratch_mount
> +# test mounted block device and mountpoint
> +test_xfs_info $SCRATCH_DEV
> +test_xfs_info $SCRATCH_MNT
> +
> +echo "Silence is golden"
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/1000.out b/tests/xfs/1000.out
> new file mode 100644
> index 00000000..681b3b48
> --- /dev/null
> +++ b/tests/xfs/1000.out
> @@ -0,0 +1,2 @@
> +QA output created by 1000
> +Silence is golden
> diff --git a/tests/xfs/group b/tests/xfs/group
> index ffe4ae12..047fe332 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -504,3 +504,4 @@
>  504 auto quick mkfs label
>  505 auto quick spaceman
>  506 auto quick health
> +1000 auto quick
> -- 
> 2.17.2
> 
