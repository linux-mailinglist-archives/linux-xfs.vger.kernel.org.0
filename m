Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B85BA8AC30
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Aug 2019 02:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfHMAwj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 20:52:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54510 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfHMAwj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 20:52:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D0ndkX183650
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 00:52:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=fP91Wlb9SVk6bmhGOLux5k5UiC0bzHeGNMsLvEw6q70=;
 b=dggRPGb+1vJcsxrpL2mDuxb3zMQqohDybOsyp+V3ZrP2hPXPScIv7Y58vSJQ79pzdUGD
 KY371ShhRvEkWy6H9x0vj6W3bSdw5m+lbnM9peTLyr7XfKc/PX7at//y6gb+JO7ZoCu2
 iwyyFsyzDUwSL1ruIQAX5SYgjB04gVw8fvDA4EvvWWtn4NJIBtEZwlb8NNnYZ6HEFtJK
 EEsWb8yQAjP3LVuKhXTk3ehR8XLFP2DgVO3r8hDracLiDjWMPOhd4RXyypSj7WL+WpkI
 7Rm/sGTYhLo3dRsypkStjmG0pVcdCst4QhouHkVqpB1eD5uPb21eWrEud1OUi3Hs4gh3 xA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=fP91Wlb9SVk6bmhGOLux5k5UiC0bzHeGNMsLvEw6q70=;
 b=Q+rxSC8iLKN3NoAh0nGoEGat0WY0L4ubDtK7CU8AZ+XHoSfg9maljukivK3n737AOg/S
 kF77SH5xLsSpkDGJ4fWIe6jhd4Gx9na+jpW1YBEgqA+o762WoIjTO8tDyflaFzdGSiKg
 02qBV3YLVsw9r5zjTPpX//fy86SLDPHdqOYFMCaSzY4WW6rsE0j5ZiL70ah0z03fjRvP
 BlJcJAlgyumUXxwJFMGKjNopmowvwfcTKA/wPDOnmDtSggs2fyqFmM+E+ZpHaEj6LQLh
 lM7+6QXNk7nZWv4AsV0BHU7ArV5NbJqgxBFUYKTcGutLR0T07UpxRKbZkWdAqVFtdMHB qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u9nvp2v3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 00:52:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D0nEbd113255
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 00:52:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2u9nreeryh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 00:52:38 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7D0qbZJ007338
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 00:52:37 GMT
Received: from [192.168.1.9] (/174.18.98.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 17:52:37 -0700
Subject: Re: [PATCH v1 1/1] xfstests: Add Delayed Attribute test
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190809213829.383-1-allison.henderson@oracle.com>
 <20190809213829.383-2-allison.henderson@oracle.com>
 <20190812165101.GG7138@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <c4fc036e-0d8e-d954-db27-0c292e8bce5b@oracle.com>
Date:   Mon, 12 Aug 2019 17:52:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812165101.GG7138@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 8/12/19 9:51 AM, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:38:29PM -0700, Allison Collins wrote:
>> This patch adds a test to exercise the delayed attribute error
>> inject and log replay
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   tests/xfs/512     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/xfs/512.out |  18 ++++++++++
>>   tests/xfs/group   |   1 +
>>   3 files changed, 121 insertions(+)
>>
>> diff --git a/tests/xfs/512 b/tests/xfs/512
>> new file mode 100644
>> index 0000000..957525c
>> --- /dev/null
>> +++ b/tests/xfs/512
>> @@ -0,0 +1,102 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
>> +#
>> +# FS QA Test No. 512
>> +#
>> +# Delayed attr log replay test
>> +#
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=0	# success is the default!
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +. ./common/attr
>> +. ./common/inject
>> +
>> +_cleanup()
>> +{
>> +	echo "*** unmount"
>> +	_scratch_unmount 2>/dev/null
>> +	rm -f $tmp.*
>> +}
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_attr()
>> +{
>> +	${ATTR_PROG} $* 2>$tmp.err >$tmp.out
>> +	exit=$?
>> +	sed \
>> +	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
>> +	    -e "s#$tmp[^ :]*#<TMPFILE>#g;" \
> 
> When does $tmp show up in the ATTR_PROG output?

I dont think it does in this case, I had started out with xfs/021 and 
gutted most of it.  So this part can probably come out.  Maybe I can get 
away with just using the _filter_scratch as you suggest :-)

> 
> Also, _filter_scratch should do most of this filtering for you, right?
> 
>> +		$tmp.out
>> +	sed \
>> +	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
>> +	    -e "s#$tmp[^ :]*#<TMPFILE>#g;" \
>> +		$tmp.err 1>&2
>> +	return $exit
>> +}
>> +
>> +do_getfattr()
>> +{
>> +	_getfattr $* 2>$tmp.err >$tmp.out
>> +	exit=$?
>> +	sed \
>> +	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
>> +	    -e "s#$tmp[^ :]*#<TMPFILE>#g;" \
>> +		$tmp.out
>> +	sed \
>> +	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
>> +	    -e "s#$tmp[^ :]*#<TMPFILE>#g;" \
>> +		$tmp.err 1>&2
>> +	return $exit
>> +}
>> +
>> +# real QA test starts here
>> +_supported_fs xfs
>> +_supported_os Linux
>> +
>> +_require_scratch
>> +_require_attrs
>> +_require_xfs_io_error_injection "delayed_attr"
>> +
>> +rm -f $seqres.full
>> +_scratch_unmount >/dev/null 2>&1
>> +
>> +echo "*** mkfs"
>> +_scratch_mkfs_xfs >/dev/null \
>> +	|| _fail "mkfs failed"
> 
> I think _scratch_mkfs_xfs does the _fail for you already, right?
I think so, I can probably trim that off

> 
> (Or was it _scratch_mkfs?)
> 
>> +
>> +echo "*** mount FS"
>> +_scratch_mount
>> +
>> +testfile=$SCRATCH_MNT/testfile
>> +echo "*** make test file 1"
>> +
>> +touch $testfile.1
>> +
>> +echo "Inject error"
>> +_scratch_inject_error "delayed_attr"
>> +
>> +echo "Set attribute"
>> +echo "attr_value" | _attr -s "attr_name" $testfile.1 >/dev/null
> 
> Can we try attr recovery with a 64k value too?

Sure, I'll find some larger attrs to include here.

Thx!
Allison

> 
> --D
> 
>> +echo "FS should be shut down, touch will fail"
>> +touch $testfile.1
>> +
>> +echo "Remount to replay log"
>> +_scratch_inject_logprint >> $seqres.full
>> +
>> +echo "FS should be online, touch should succeed"
>> +touch $testfile.1
>> +
>> +echo "Verify attr recovery"
>> +do_getfattr --absolute-names $testfile.1
>> +
>> +echo "*** done"
>> +exit
>> diff --git a/tests/xfs/512.out b/tests/xfs/512.out
>> new file mode 100644
>> index 0000000..71bff79
>> --- /dev/null
>> +++ b/tests/xfs/512.out
>> @@ -0,0 +1,18 @@
>> +QA output created by 512
>> +*** mkfs
>> +*** mount FS
>> +*** make test file 1
>> +Inject error
>> +Set attribute
>> +attr_set: Input/output error
>> +Could not set "attr_name" for <TESTFILE>.1
>> +FS should be shut down, touch will fail
>> +touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
>> +Remount to replay log
>> +FS should be online, touch should succeed
>> +Verify attr recovery
>> +# file: <TESTFILE>.1
>> +user.attr_name
>> +
>> +*** done
>> +*** unmount
>> diff --git a/tests/xfs/group b/tests/xfs/group
>> index a7ad300..a9dab7c 100644
>> --- a/tests/xfs/group
>> +++ b/tests/xfs/group
>> @@ -509,3 +509,4 @@
>>   509 auto ioctl
>>   510 auto ioctl quick
>>   511 auto quick quota
>> +512 auto quick attr
>> -- 
>> 2.7.4
>>
