Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4CB8A3CC
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 18:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfHLQvF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 12:51:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56884 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726457AbfHLQvF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:51:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGmiKm167724
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:51:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=tnxggxuCiq0UPne+lJEW8jQ2/5KFqz8ryXJS8Z4J6xQ=;
 b=RotSK2gM+D1usWzLwCunOPTpyCbZoJGa78z2yW/jFWyclvoqiRgQaTITuJ06E5P9wib/
 OD6F3XvlDqZ3+X28p8N7oRciHdKZ5yglqkTORw/JJdbDr8YLKR01v/PZ4/jyILLunV7+
 oFyTp+L2HOOYMJUcOatWF6m17GOp6deB5BkHxgZNjdONinpvhivjrWvhkYMNQQqaQ9eK
 gghCWpnr9mfKaxooVYnnaGC4FjhDj+NXu9WtNx4UKnqKWptA0K6uhYaJ5FmmO2IhUrBx
 Zw5YJ19fs3pLd50e4ETDotuPq/Sytt5Hn5PdghNN5zV1GGvIT+EJS7HOds0UICd/li5i UQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=tnxggxuCiq0UPne+lJEW8jQ2/5KFqz8ryXJS8Z4J6xQ=;
 b=olHZjeGX87h/H3ZJ9ooCQuO2ukRhnh9lf63psiaSlTH8pSzEkLWKyaKtGTbf4foi/b9W
 RBxxeGtfisce9xXTG0dg1OWPuBaunVGBgyhrZRpc4gZ0EbdblXTNUeF+oDDiR4JTp5ay
 peoGbL8F9HUr17ePuKdXc5Q6jpv0fw6d9suen1Md9A3JuX0FLZyT+U9scjYzzqoblsj4
 vRnLcFXRFFnyhrzZKLI/hGDjXU25Zns7tn3xeSVYaqub5FezbfBBRoxtFXA8sP4GolMA
 ESHKNscYYKGms1AVMfe6GYkBmeyx3oUfQauJIOOb0crUPbD/SelMkBC4N/WzuyivO6EX Gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u9nbt8wee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:51:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGm0EW130718
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:51:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2u9n9h30st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:51:03 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CGp2NK032066
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:51:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 09:51:02 -0700
Date:   Mon, 12 Aug 2019 09:51:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 1/1] xfstests: Add Delayed Attribute test
Message-ID: <20190812165101.GG7138@magnolia>
References: <20190809213829.383-1-allison.henderson@oracle.com>
 <20190809213829.383-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213829.383-2-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120188
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120188
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:38:29PM -0700, Allison Collins wrote:
> This patch adds a test to exercise the delayed attribute error
> inject and log replay
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  tests/xfs/512     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/512.out |  18 ++++++++++
>  tests/xfs/group   |   1 +
>  3 files changed, 121 insertions(+)
> 
> diff --git a/tests/xfs/512 b/tests/xfs/512
> new file mode 100644
> index 0000000..957525c
> --- /dev/null
> +++ b/tests/xfs/512
> @@ -0,0 +1,102 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 512
> +#
> +# Delayed attr log replay test
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=0	# success is the default!
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
> +. ./common/inject
> +
> +_cleanup()
> +{
> +	echo "*** unmount"
> +	_scratch_unmount 2>/dev/null
> +	rm -f $tmp.*
> +}
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_attr()
> +{
> +	${ATTR_PROG} $* 2>$tmp.err >$tmp.out
> +	exit=$?
> +	sed \
> +	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
> +	    -e "s#$tmp[^ :]*#<TMPFILE>#g;" \

When does $tmp show up in the ATTR_PROG output?

Also, _filter_scratch should do most of this filtering for you, right?

> +		$tmp.out
> +	sed \
> +	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
> +	    -e "s#$tmp[^ :]*#<TMPFILE>#g;" \
> +		$tmp.err 1>&2
> +	return $exit
> +}
> +
> +do_getfattr()
> +{
> +	_getfattr $* 2>$tmp.err >$tmp.out
> +	exit=$?
> +	sed \
> +	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
> +	    -e "s#$tmp[^ :]*#<TMPFILE>#g;" \
> +		$tmp.out
> +	sed \
> +	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
> +	    -e "s#$tmp[^ :]*#<TMPFILE>#g;" \
> +		$tmp.err 1>&2
> +	return $exit
> +}
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +
> +_require_scratch
> +_require_attrs
> +_require_xfs_io_error_injection "delayed_attr"
> +
> +rm -f $seqres.full
> +_scratch_unmount >/dev/null 2>&1
> +
> +echo "*** mkfs"
> +_scratch_mkfs_xfs >/dev/null \
> +	|| _fail "mkfs failed"

I think _scratch_mkfs_xfs does the _fail for you already, right?

(Or was it _scratch_mkfs?)

> +
> +echo "*** mount FS"
> +_scratch_mount
> +
> +testfile=$SCRATCH_MNT/testfile
> +echo "*** make test file 1"
> +
> +touch $testfile.1
> +
> +echo "Inject error"
> +_scratch_inject_error "delayed_attr"
> +
> +echo "Set attribute"
> +echo "attr_value" | _attr -s "attr_name" $testfile.1 >/dev/null

Can we try attr recovery with a 64k value too?

--D

> +echo "FS should be shut down, touch will fail"
> +touch $testfile.1
> +
> +echo "Remount to replay log"
> +_scratch_inject_logprint >> $seqres.full
> +
> +echo "FS should be online, touch should succeed" 
> +touch $testfile.1
> +
> +echo "Verify attr recovery"
> +do_getfattr --absolute-names $testfile.1
> +
> +echo "*** done"
> +exit
> diff --git a/tests/xfs/512.out b/tests/xfs/512.out
> new file mode 100644
> index 0000000..71bff79
> --- /dev/null
> +++ b/tests/xfs/512.out
> @@ -0,0 +1,18 @@
> +QA output created by 512
> +*** mkfs
> +*** mount FS
> +*** make test file 1
> +Inject error
> +Set attribute
> +attr_set: Input/output error
> +Could not set "attr_name" for <TESTFILE>.1
> +FS should be shut down, touch will fail
> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
> +Remount to replay log
> +FS should be online, touch should succeed
> +Verify attr recovery
> +# file: <TESTFILE>.1
> +user.attr_name
> +
> +*** done
> +*** unmount
> diff --git a/tests/xfs/group b/tests/xfs/group
> index a7ad300..a9dab7c 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -509,3 +509,4 @@
>  509 auto ioctl
>  510 auto ioctl quick
>  511 auto quick quota
> +512 auto quick attr
> -- 
> 2.7.4
> 
