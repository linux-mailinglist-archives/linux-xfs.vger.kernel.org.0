Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1E14FE6E
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 03:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfFXBlf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 23 Jun 2019 21:41:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46724 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfFXBld (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jun 2019 21:41:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5NLn23A190101;
        Sun, 23 Jun 2019 21:49:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=TYfvtmLZDI2VUSDmJTYmUN0usVUIgyi/HkSfeeMF2uo=;
 b=mk4N1VNfI4onYn9mCnE4pqbPVmsX9d16PPztDLIW7jj9Z47dLmH6H+h21HiFS+CD+R41
 9wnoZ+uxcIlVpWn42aNN7Nz9bvhIQeGY8KXQ+bg8AxBrg1B/Vl0NsyIxoJBpULcV2aBs
 xFAiDU0xPvp8Zvn1KIU86Ye5cjAegey5Pxum2vH96RQ06E8p9zJGxWtG1u4hKL8g/hdA
 SBoR2196ixNIsHigwqKzCtLzCiACPv2EYiv1+rYB/dPc6ADJG4gj6pn64mtXKbVsz/ss
 l0SL/BItdJVRcwtryVl2QMnjwJ1bWHv4q8uUnt+o6s9aWnD+LVMiAYqiIG6Dcc9KPJI8 5A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t9c9pb90w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jun 2019 21:49:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5NLmFWj176703;
        Sun, 23 Jun 2019 21:49:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t99f2yv1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jun 2019 21:49:22 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5NLnKQR026556;
        Sun, 23 Jun 2019 21:49:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Jun 2019 14:49:20 -0700
Date:   Sun, 23 Jun 2019 14:49:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: test xfs_info on block device and mountpoint
Message-ID: <20190623214919.GD5387@magnolia>
References: <20190622153827.4448-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190622153827.4448-1-zlang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9297 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906230188
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9297 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906230188
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 22, 2019 at 11:38:27PM +0800, Zorro Lang wrote:
> There was a bug, xfs_info fails on a mounted block device:
> 
>   # xfs_info /dev/mapper/testdev
>   xfs_info: /dev/mapper/testdev contains a mounted filesystem
> 
>   fatal error -- couldn't initialize XFS library
> 
> xfsprogs has fixed it by:
> 
>   bbb43745 xfs_info: use findmnt to handle mounted block devices
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Aha!  I remembered something -- xfs/449 already checks for consistency
in the various xfs geometry reports that each command provides, so why
not just add the $XFS_INFO_PROG $SCRATCH_DEV case at the end?

--D

> ---
> 
> Thanks the reviewing from Darrick and Eryu,
> 
> V2 did below changes:
> 1) Compare the contents between the two xfs_info invocations in test_xfs_info()
> 2) document the commit that the case cover
> 3) Add more comments
> 4) Move the test on unmounted device to the end
> 
> Sorry Eryu, I'll keep the case number next time :)
> 
> Thanks,
> Zorro
> 
>  tests/xfs/1000     | 82 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1000.out |  2 ++
>  tests/xfs/group    |  1 +
>  3 files changed, 85 insertions(+)
>  create mode 100755 tests/xfs/1000
>  create mode 100644 tests/xfs/1000.out
> 
> diff --git a/tests/xfs/1000 b/tests/xfs/1000
> new file mode 100755
> index 00000000..721bcdf2
> --- /dev/null
> +++ b/tests/xfs/1000
> @@ -0,0 +1,82 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 1000
> +#
> +# test xfs_info on block device and mountpoint, uncover xfsprogs commit:
> +#    bbb43745 xfs_info: use findmnt to handle mounted block devices
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
> +info_file=$tmp.$seq.info
> +
> +test_xfs_info()
> +{
> +	local target="$1"
> +	local tmpfile=$tmp.$seq.info.tmp
> +	local need_cmp=0
> +
> +	# save the *old* xfs_info file, to compare with the new one later
> +	if [ -f $info_file ]; then
> +		cat $info_file > $tmpfile
> +		need_cmp=1
> +	fi
> +
> +	$XFS_INFO_PROG $target > $info_file 2>&1
> +	if [ $? -ne 0 ];then
> +		echo "$XFS_INFO_PROG $target fails:"
> +		cat $info_file
> +	else
> +		cat $info_file >> $seqres.full
> +	fi
> +	# compare the contents between the two xfs_info invocations
> +	if [ $need_cmp -eq 1 ]; then
> +		diff $tmpfile $info_file
> +	fi
> +}
> +
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount
> +# test mounted block device and mountpoint
> +test_xfs_info $SCRATCH_DEV
> +test_xfs_info $SCRATCH_MNT
> +
> +# test on unmounted block device
> +_scratch_unmount
> +# Due to new xfsprogs use xfs_db 'info' command to get the information of
> +# offline XFS, it supports running on a unmounted device. But old xfsprogs
> +# doesn't support it, so skip that.
> +$XFS_DB_PROG -c "info" $SCRATCH_DEV | grep -q "command info not found"
> +if [ $? -ne 0 ]; then
> +	test_xfs_info $SCRATCH_DEV
> +fi
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
