Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415CE26D1DB
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 05:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgIQDnS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Sep 2020 23:43:18 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:3929 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725858AbgIQDnR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:43:17 -0400
X-IronPort-AV: E=Sophos;i="5.76,434,1592841600"; 
   d="scan'208";a="99336759"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 17 Sep 2020 11:43:13 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id 8CC5A48990EB;
        Thu, 17 Sep 2020 11:43:12 +0800 (CST)
Received: from [10.167.220.69] (10.167.220.69) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 17 Sep 2020 11:43:10 +0800
Message-ID: <5F62DB4E.9040506@cn.fujitsu.com>
Date:   Thu, 17 Sep 2020 11:43:10 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.2; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     <guaneryu@gmail.com>, <linux-xfs@vger.kernel.org>,
        <fstests@vger.kernel.org>
Subject: Re: [PATCH 03/24] generic/607: don't break on filesystems that don't
 support FSGETXATTR on dirs
References: <160013417420.2923511.6825722200699287884.stgit@magnolia> <160013419510.2923511.4577521065964693699.stgit@magnolia> <5F62BEAD.3090602@cn.fujitsu.com> <20200917032730.GQ7955@magnolia>
In-Reply-To: <20200917032730.GQ7955@magnolia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.220.69]
X-ClientProxiedBy: G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) To
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206)
X-yoursite-MailScanner-ID: 8CC5A48990EB.A9E42
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

于 2020/9/17 11:27, Darrick J. Wong 写道:
> On Thu, Sep 17, 2020 at 09:41:01AM +0800, Xiao Yang wrote:
>> On 2020/9/15 9:43, Darrick J. Wong wrote:
>>> From: Darrick J. Wong<darrick.wong@oracle.com>
>>>
>>> This test requires that the filesystem support calling FSGETXATTR on
>>> regular files and directories to make sure the FS_XFLAG_DAX flag works.
>>> The _require_xfs_io_command tests a regular file but doesn't check
>>> directories, so generic/607 should do that itself.  Also fix some typos.
>>>
>>> Signed-off-by: Darrick J. Wong<darrick.wong@oracle.com>
>>> ---
>>>    common/rc         |   10 ++++++++--
>>>    tests/generic/607 |    5 +++++
>>>    2 files changed, 13 insertions(+), 2 deletions(-)
>>>
>>>
>>> diff --git a/common/rc b/common/rc
>>> index aa5a7409..f78b1cfc 100644
>>> --- a/common/rc
>>> +++ b/common/rc
>>> @@ -2162,6 +2162,12 @@ _require_xfs_io_command()
>>>    	local testfile=$TEST_DIR/$$.xfs_io
>>>    	local testio
>>>    	case $command in
>>> +	"lsattr")
>>> +		# Test xfs_io lsattr support and filesystem FS_IOC_FSSETXATTR
>>> +		# support.
>>> +		testio=`$XFS_IO_PROG -F -f -c "lsattr $param" $testfile 2>&1`
>>> +		param_checked="$param"
>>> +		;;
>>>    	"chattr")
>>>    		if [ -z "$param" ]; then
>>>    			param=s
>>> @@ -3205,7 +3211,7 @@ _check_s_dax()
>>>    	if [ $exp_s_dax -eq 0 ]; then
>>>    		(( attributes&   0x2000 ))&&   echo "$target has unexpected S_DAX flag"
>>>    	else
>>> -		(( attributes&   0x2000 )) || echo "$target doen't have expected S_DAX flag"
>>> +		(( attributes&   0x2000 )) || echo "$target doesn't have expected S_DAX flag"
>>>    	fi
>>>    }
>>>
>>> @@ -3217,7 +3223,7 @@ _check_xflag()
>>>    	if [ $exp_xflag -eq 0 ]; then
>>>    		_test_inode_flag dax $target&&   echo "$target has unexpected FS_XFLAG_DAX flag"
>>>    	else
>>> -		_test_inode_flag dax $target || echo "$target doen't have expected FS_XFLAG_DAX flag"
>>> +		_test_inode_flag dax $target || echo "$target doesn't have expected FS_XFLAG_DAX flag"
>>>    	fi
>>>    }
>>>
>>> diff --git a/tests/generic/607 b/tests/generic/607
>>> index b15085ea..14d2c05f 100755
>>> --- a/tests/generic/607
>>> +++ b/tests/generic/607
>>> @@ -38,6 +38,11 @@ _require_scratch
>>>    _require_dax_iflag
>>>    _require_xfs_io_command "lsattr" "-v"
>>>
>>> +# Make sure we can call FSGETXATTR on a directory...
>>> +output="$($XFS_IO_PROG -c "lsattr -v" $TEST_DIR 2>&1)"
>>> +echo "$output" | grep -q "Inappropriate ioctl for device"&&   \
>>> +	_notrun "$FSTYP: FSGETXATTR not supported on directories."
>> Hi Darrick,
>>
>> Could you tell me which kernel version gets the issue? :-)
> ext4.
Hi Darrick,

I didn't get the issue by v5.7.0 xfs_io on v5.8.0 kernel:
----------------------------------------------------------------------------------
# blkid /dev/pmem0
/dev/pmem0: UUID="181f4d76-bc21-45b7-a6d2-e486f6cc479b" TYPE="ext4"
# df -h | grep pmem0
/dev/pmem0 2.0G 28K 1.8G 1% /mnt/xfstests/test
# strace -e ioctl xfs_io -c "lsattr -v" /mnt/xfstests/test
ioctl(3, FS_IOC_FSGETXATTR, 0x7ffdc7061d10) = 0
[] /mnt/xfstests/test
----------------------------------------------------------------------------------
Do I miss something?

Thanks,
Xiao Yang
> --D
>
>> Best Regards,
>> Xiao Yang
>>> +
>>>    # If a/ is +x, check that a's new children
>>>    # inherit +x from a/.
>>>    test_xflag_inheritance1()
>>>
>>>
>>>
>>> .
>>>
>>
>>
>
> .
>



