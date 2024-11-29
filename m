Return-Path: <linux-xfs+bounces-15585-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2881E9D1EB1
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Nov 2024 04:09:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCC6A280E65
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Nov 2024 03:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31EF8145FFF;
	Tue, 19 Nov 2024 03:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KdF0HW6w"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A8D1448DF;
	Tue, 19 Nov 2024 03:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731985718; cv=none; b=T4q6bnplfgnvZHnxPqNSt3JJ3MfdQ5p6V9BzjnCcA5pgKeHEMpBSHNMbFQHluPtacYpqnQ+Kj1Nmu5zk5exKrq4KA8ni5IoHNJ/mAf6S9diDKSP3eg2ByoThl1xKuFzVqRmm6Xi/CO0B6MDYMhRrehEfJcrNg+ZWiobNikya2GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731985718; c=relaxed/simple;
	bh=8ZabNXsDrBcNUZppMyLQtzjqPk8FE9P4vx1WXOCnOrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QPbsYm0pUb+nStptT0xhcRsBUhsXFcEOBKYU4nyHEHI0FQnNKhYCahkxyR3qmkwxYilWaOZ51+lQSJOkcjUgu+/DBY5yrxL1ja6psVSZ3RwfusOgymX3fUj7wUx9hDMGcqx07sqelN3acTzE6CXsxKscOXXs5gVO8wWKnQEMfaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KdF0HW6w; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AILHgtd020645;
	Tue, 19 Nov 2024 03:08:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=pBrpAm
	UTaZywMOz9d3Lt2e1QrRuIusKbP6FYSjEZQKs=; b=KdF0HW6wB/+9ZcSv+7fP+9
	DPma1wpUYNsXpMVt6q25r4DWb1V/Zv/QW0dDjIUn4FHElEzSH98GStv7jlLXZapJ
	w2dFPrS71U6rz300tBS8Q/rFa+7i6rW2WkAdZrHd65L2dJtNc+qyqxzdX6ig3LRn
	d8CvTj7V8JE4soPDdcUAqi26nVV5S8/oS/Fs6WyCSxygSPq5W3Xd0WX+ppe82xco
	mX8dYfHZ2Ru2XoWdutlhN5zg4kOuEHqsUjtqXZ+qaLkUmbd3I8u5MQJUCr/E4Dml
	W5N3zhot1/if9XHS6B0SF+HfewXyDomE4P59frnfEC9UH6vB5u80D9ZboZ5MY+pw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42xyu1kbjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 03:08:32 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4AJ38WGv009930;
	Tue, 19 Nov 2024 03:08:32 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42xyu1kbjj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 03:08:32 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJ2FZLA000579;
	Tue, 19 Nov 2024 03:08:30 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42y77ktt76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 03:08:30 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AJ38SN353150132
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 03:08:28 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF16520043;
	Tue, 19 Nov 2024 03:08:28 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B060C20040;
	Tue, 19 Nov 2024 03:08:26 +0000 (GMT)
Received: from [9.39.28.249] (unknown [9.39.28.249])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Nov 2024 03:08:26 +0000 (GMT)
Message-ID: <be99ea4a-d036-46b3-a16b-a9348487bcc4@linux.ibm.com>
Date: Tue, 19 Nov 2024 08:38:25 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] generic: Addition of new tests for extsize hints
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, zlang@kernel.org
References: <cover.1731597226.git.nirjhar@linux.ibm.com>
 <373a7e378ba4a76067dc7da5835ac722248144f9.1731597226.git.nirjhar@linux.ibm.com>
 <20241115165054.GF9425@frogsfrogsfrogs>
 <c6ca5784-de55-43ec-ba6a-3afbf6b2aa53@linux.ibm.com>
 <20241118162209.GH9425@frogsfrogsfrogs>
From: Nirjhar Roy <nirjhar@linux.ibm.com>
In-Reply-To: <20241118162209.GH9425@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cKlEHHN_BTFKwDpWIODiiSCtgPXJf8yk
X-Proofpoint-ORIG-GUID: y-6-mtQENC1lZgNc7xzDxIF8OXEc77k4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411190024


On 11/18/24 21:52, Darrick J. Wong wrote:
> On Mon, Nov 18, 2024 at 02:54:06PM +0530, Nirjhar Roy wrote:
>> On 11/15/24 22:20, Darrick J. Wong wrote:
>>> On Fri, Nov 15, 2024 at 09:45:59AM +0530, Nirjhar Roy wrote:
>>>> This commit adds new tests that checks the behaviour of xfs/ext4
>>>> filesystems when extsize hint is set on file with inode size as 0, non-empty
>>>> files with allocated and delalloc extents and so on.
>>>> Although currently this test is placed under tests/generic, it
>>>> only runs on xfs and there is an ongoing patch series[1] to enable
>>>> extsize hints for ext4 as well.
>>>>
>>>> [1] https://lore.kernel.org/linux-ext4/cover.1726034272.git.ojaswin@linux.ibm.com/
>>>>
>>>> Reviewed-by Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>>>> Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
>>>> Suggested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
>>>> Signed-off-by: Nirjhar Roy <nirjhar@linux.ibm.com>
>>>> ---
>>>>    tests/generic/366     | 172 ++++++++++++++++++++++++++++++++++++++++++
>>>>    tests/generic/366.out |  26 +++++++
>>>>    2 files changed, 198 insertions(+)
>>>>    create mode 100755 tests/generic/366
>>>>    create mode 100644 tests/generic/366.out
>>>>
>>>> diff --git a/tests/generic/366 b/tests/generic/366
>>>> new file mode 100755
>>>> index 00000000..7ff4e8e2
>>>> --- /dev/null
>>>> +++ b/tests/generic/366
>>>> @@ -0,0 +1,172 @@
>>>> +#! /bin/bash
>>>> +# SPDX-License-Identifier: GPL-2.0
>>>> +# Copyright (c) 2024 Nirjhar Roy (nirjhar@linux.ibm.com).  All Rights Reserved.
>>>> +#
>>>> +# FS QA Test 366
>>>> +#
>>>> +# This test verifies that extent allocation hint setting works correctly on files with
>>>> +# no extents allocated and non-empty files which are truncated. It also checks that the
>>>> +# extent hints setting fails with non-empty file i.e, with any file with allocated
>>>> +# extents or delayed allocation. We also check if the extsize value and the
>>>> +# xflag bit actually got reflected after setting/re-setting the extsize value.
>>>> +
>>>> +. ./common/config
>>>> +. ./common/filter
>>>> +. ./common/preamble
>>>> +
>>>> +_begin_fstest ioctl quick
>>>> +
>>>> +_supported_fs xfs
>>> Aren't you all adding extsize support for ext4?  I would've expected
>>> some kind of _require_extsize helper to _notrun on filesystems that
>>> don't support it.
>> Yes, this is a good idea. I will try to have something like this. Thank you.
>>>> +
>>>> +_fixed_by_kernel_commit "2a492ff66673 \
>>>> +                        xfs: Check for delayed allocations before setting extsize"
>>>> +
>>>> +_require_scratch
>>>> +
>>>> +FILE_DATA_SIZE=1M
>>>> +
>>>> +get_default_extsize()
>>>> +{
>>>> +    if [ -z $1 ] || [ ! -d $1 ]; then
>>>> +        echo "Missing mount point argument for get_default_extsize"
>>>> +        exit 1
>>>> +    fi
>>>> +    $XFS_IO_PROG -c "extsize" "$1" | sed 's/^\[\([0-9]\+\)\].*/\1/'
>>> Doesn't this need to check for extszinherit on $SCRATCH_MNT?
>> The above function tries to get the default extsize set on a directory
>> ($SCRATCH_MNT for this test). Even if there is an extszinherit set or
>> extsize (with -d extsize=<size> [1]), the function will get the extsize (in
>> bytes) which is what the function intends to do. In case there is
>> no extszinherit or extsize set on the directory, it will return 0.  Does
>> this answer your question, or are you asking something else?
>>
>> [1]
>> https://lore.kernel.org/all/20230929095342.2976587-7-john.g.garry@oracle.com/
> Nah, I think I got confused there.  Disregard the question. :(
>
>>>> +}
>>>> +
>>>> +filter_extsz()
>>>> +{
>>>> +    sed "s/\[$1\]/\[EXTSIZE\]/g"
>>>> +}
>>>> +
>>>> +setup()
>>>> +{
>>>> +    _scratch_mkfs >> "$seqres.full"  2>&1
>>>> +    _scratch_mount >> "$seqres.full" 2>&1
>>>> +    BLKSZ=`_get_block_size $SCRATCH_MNT`
>>>> +    DEFAULT_EXTSIZE=`get_default_extsize $SCRATCH_MNT`
>>>> +    EXTSIZE=$(( BLKSZ*2 ))
>>>> +    # Making sure the new extsize is not the same as the default extsize
>>> Er... why?
>> The test behaves a bit differently when the new and old extsizes are equal
>> and the intention of this test is to check if the kernel behaves as expected
>> when we are trying to *change* the extsize. Two of the sub-tests
>> (test_data_delayed(), test_data_allocated()) test whether extsize settting
>> fails if there are allocated extents or delayed allocation. The failure
>> doesn't take place when the new and the default extsizes are equal, i.e,
>> when the extsize is not changing. If the default and the new extsize are
>> equal, the xfs_io command succeeds, which is not what we want the test to
>> do. So we are always ensuring that the new extsize is not equal to the
>> default extsize. Does this answer your question?
> Yep.  Can you add that ("Make sure the new extsize is not the same as
> the default extsize so that we can observe it changing") to the comment?

Yes. I can modify the comment to make it more clear.

--NR

>
>>>> +    [[ "$DEFAULT_EXTSIZE" -eq "$EXTSIZE" ]] && EXTSIZE=$(( BLKSZ*4 ))
>>>> +}
>>>> +
>>>> +read_file_extsize()
>>>> +{
>>>> +    $XFS_IO_PROG -c "extsize" $1 | _filter_scratch | filter_extsz $2
>>>> +}
>>>> +
>>>> +check_extsz_and_xflag()
>>>> +{
>>>> +    local filename=$1
>>>> +    local extsize=$2
>>>> +    read_file_extsize $filename $extsize
>>>> +    _test_fsx_xflags_field $filename "e" && echo "e flag set" || echo "e flag unset"
>>> I almost asked in the last patch if the _test_fsxattr_flag function
>>> should be running xfs_io -c 'stat -v' so that you could grep for whole
>>> words instead of individual letters.
>>>
>>> "extsize flag unset"
>>>
>>> "cowextsize flag set"
>>>
>>> is a bit easier to figure out what's going wrong.
>>>
>>> The rest of the logic looks reasonable to me.
>>>
>>> --D
>> Yes, that makes sense. So do you mean something like the following?
>>
>> # Check whether a fsxattr xflags name ($2) field is set on a given file
>> ($1).
>> # e.g, fsxattr.xflags = 0x80000800 [extsize, has-xattr]
>> _test_fsxattr_flag_field()
>> {
>>      grep -q "fsxattr.xflags.*\[.*$2.*\]" <($XFS_IO_PROG -c "stat -v" "$1")
>> }
>>
>> and the call sites can be like
>>
>> _test_fsx_xflags_field $filename "extsize" && echo "e flag set" || echo "e
>> flag unset"
>>
>> THE OTHER OPTION IS:
>>
>> We can embed the "<flag name> flag set/unset" message, inside the
>> _test_fsx_xflags_field() function. Something like
>>
>> _test_fsxattr_flag_field()
>> {
>>      grep -q "fsxattr.xflags.*\[.*$2.*\]" <($XFS_IO_PROG -c "stat -v" "$1")
>> && echo "$2 flag set" || echo "$2 flag unset"
>> }
>>
>> Which one do you prefer?
> You might as well go for this second form since that's how all the
> callers behave.
>
> --D
>
>>>> +}
>>>> +
>>>> +check_extsz_xflag_across_remount()
>>>> +{
>>>> +    local filename=$1
>>>> +    local extsize=$2
>>>> +    _scratch_cycle_mount
>>>> +    check_extsz_and_xflag $filename $extsize
>>>> +}
>>>> +
>>>> +# Extsize flag should be cleared when extsize is reset, so this function
>>>> +# checks that this behavior is followed.
>>>> +reset_extsz_and_recheck_extsz_xflag()
>>>> +{
>>>> +    local filename=$1
>>>> +    echo "Re-setting extsize hint to 0"
>>>> +    $XFS_IO_PROG -c "extsize 0" $filename
>>>> +    check_extsz_xflag_across_remount $filename "0"
>>>> +}
>>>> +
>>>> +check_extsz_xflag_before_and_after_reset()
>>>> +{
>>>> +    local filename=$1
>>>> +    local extsize=$2
>>>> +    check_extsz_xflag_across_remount $filename $extsize
>>>> +    reset_extsz_and_recheck_extsz_xflag $filename
>>>> +}
>>>> +
>>>> +test_empty_file()
>>>> +{
>>>> +    echo "TEST: Set extsize on empty file"
>>>> +    local filename=$1
>>>> +    $XFS_IO_PROG \
>>>> +        -c "open -f $filename" \
>>>> +        -c "extsize $EXTSIZE" \
>>>> +
>>>> +    check_extsz_xflag_before_and_after_reset $filename $EXTSIZE
>>>> +    echo
>>>> +}
>>>> +
>>>> +test_data_delayed()
>>>> +{
>>>> +    echo "TEST: Set extsize on non-empty file with delayed allocation"
>>>> +    local filename=$1
>>>> +    $XFS_IO_PROG \
>>>> +        -c "open -f $filename" \
>>>> +        -c "pwrite -q  0 $FILE_DATA_SIZE" \
>>>> +        -c "extsize $EXTSIZE" | _filter_scratch
>>>> +
>>>> +    echo "test for default extsize setting if any"
>>>> +    read_file_extsize $filename $DEFAULT_EXTSIZE
>>>> +    echo
>>>> +}
>>>> +
>>>> +test_data_allocated()
>>>> +{
>>>> +    echo "TEST: Set extsize on non-empty file with allocated extents"
>>>> +    local filename=$1
>>>> +    $XFS_IO_PROG \
>>>> +        -c "open -f $filename" \
>>>> +        -c "pwrite -qW  0 $FILE_DATA_SIZE" \
>>>> +        -c "extsize $EXTSIZE" | _filter_scratch
>>>> +
>>>> +    echo "test for default extsize setting if any"
>>>> +    read_file_extsize $filename $DEFAULT_EXTSIZE
>>>> +    echo
>>>> +}
>>>> +
>>>> +test_truncate_allocated()
>>>> +{
>>>> +    echo "TEST: Set extsize after truncating a file with allocated extents"
>>>> +    local filename=$1
>>>> +    $XFS_IO_PROG \
>>>> +        -c "open -f $filename" \
>>>> +        -c "pwrite -qW  0 $FILE_DATA_SIZE" \
>>>> +        -c "truncate 0" \
>>>> +        -c "extsize $EXTSIZE" \
>>>> +
>>>> +    check_extsz_xflag_across_remount $filename $EXTSIZE
>>>> +    echo
>>>> +}
>>>> +
>>>> +test_truncate_delayed()
>>>> +{
>>>> +    echo "TEST: Set extsize after truncating a file with delayed allocation"
>>>> +    local filename=$1
>>>> +    $XFS_IO_PROG \
>>>> +        -c "open -f $filename" \
>>>> +        -c "pwrite -q  0 $FILE_DATA_SIZE" \
>>>> +        -c "truncate 0" \
>>>> +        -c "extsize $EXTSIZE" \
>>>> +
>>>> +    check_extsz_xflag_across_remount $filename $EXTSIZE
>>>> +    echo
>>>> +}
>>>> +
>>>> +setup
>>>> +echo -e "EXTSIZE = $EXTSIZE DEFAULT_EXTSIZE = $DEFAULT_EXTSIZE BLOCKSIZE = $BLKSZ\n" >> "$seqres.full"
>>>> +
>>>> +NEW_FILE_NAME_PREFIX=$SCRATCH_MNT/new-file-
>>>> +
>>>> +test_empty_file "$NEW_FILE_NAME_PREFIX"00
>>>> +test_data_delayed "$NEW_FILE_NAME_PREFIX"01
>>>> +test_data_allocated "$NEW_FILE_NAME_PREFIX"02
>>>> +test_truncate_allocated "$NEW_FILE_NAME_PREFIX"03
>>>> +test_truncate_delayed "$NEW_FILE_NAME_PREFIX"04
>>>> +
>>>> +status=0
>>>> +exit
>>>> diff --git a/tests/generic/366.out b/tests/generic/366.out
>>>> new file mode 100644
>>>> index 00000000..cdd2f5fa
>>>> --- /dev/null
>>>> +++ b/tests/generic/366.out
>>>> @@ -0,0 +1,26 @@
>>>> +QA output created by 366
>>>> +TEST: Set extsize on empty file
>>>> +[EXTSIZE] SCRATCH_MNT/new-file-00
>>>> +e flag set
>>>> +Re-setting extsize hint to 0
>>>> +[EXTSIZE] SCRATCH_MNT/new-file-00
>>>> +e flag unset
>>>> +
>>>> +TEST: Set extsize on non-empty file with delayed allocation
>>>> +xfs_io: FS_IOC_FSSETXATTR SCRATCH_MNT/new-file-01: Invalid argument
>>>> +test for default extsize setting if any
>>>> +[EXTSIZE] SCRATCH_MNT/new-file-01
>>>> +
>>>> +TEST: Set extsize on non-empty file with allocated extents
>>>> +xfs_io: FS_IOC_FSSETXATTR SCRATCH_MNT/new-file-02: Invalid argument
>>>> +test for default extsize setting if any
>>>> +[EXTSIZE] SCRATCH_MNT/new-file-02
>>>> +
>>>> +TEST: Set extsize after truncating a file with allocated extents
>>>> +[EXTSIZE] SCRATCH_MNT/new-file-03
>>>> +e flag set
>>>> +
>>>> +TEST: Set extsize after truncating a file with delayed allocation
>>>> +[EXTSIZE] SCRATCH_MNT/new-file-04
>>>> +e flag set
>>>> +
>>>> -- 
>>>> 2.43.5
>>>>
>>>>
>> -- 
>> ---
>> Nirjhar Roy
>> Linux Kernel Developer
>> IBM, Bangalore
>>
>>
-- 
---
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore


