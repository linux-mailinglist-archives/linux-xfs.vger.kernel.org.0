Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 045357B7EE
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Jul 2019 04:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbfGaCI4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Jul 2019 22:08:56 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:56242 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727300AbfGaCIz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jul 2019 22:08:55 -0400
X-IronPort-AV: E=Sophos;i="5.64,328,1559491200"; 
   d="scan'208";a="72555442"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 31 Jul 2019 10:08:53 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id E66524CDE81D;
        Wed, 31 Jul 2019 10:08:52 +0800 (CST)
Received: from [10.167.225.140] (10.167.225.140) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Wed, 31 Jul 2019 10:09:01 +0800
Subject: Re: [PATCH] common/rc: check 'chattr +/-x' on dax device.
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     <guaneryu@gmail.com>, <fstests@vger.kernel.org>,
        <linux-xfs@vger.kernel.org>
References: <20190730084009.26257-1-ruansy.fnst@cn.fujitsu.com>
 <20190730144710.GR1561054@magnolia>
From:   Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Message-ID: <a6b963b4-e5de-e05a-a58c-0971bbfec2f8@cn.fujitsu.com>
Date:   Wed, 31 Jul 2019 10:08:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190730144710.GR1561054@magnolia>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.225.140]
X-yoursite-MailScanner-ID: E66524CDE81D.AB67D
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-Spam-Status: No
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/30/19 10:47 PM, Darrick J. Wong wrote:
> On Tue, Jul 30, 2019 at 04:40:09PM +0800, Shiyang Ruan wrote:
>> 'chattr +/-x' only works on a dax device.  When checking if the 'x'
>> attribute is supported by XFS_IO_PROG:
>>      _require_xfs_io_command "chattr" "x"    (called by xfs/260)
>> it's better to do the check on a dax device mounted with dax option.
>>
>> Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
>> ---
>>   common/rc | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/common/rc b/common/rc
>> index e0b087c1..73ee5563 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -2094,11 +2094,22 @@ _require_xfs_io_command()
>>   		if [ -z "$param" ]; then
>>   			param=s
>>   		fi
>> +
>> +		# Attribute "x" should be tested on a dax device
>> +		if [ "$param" == "x" ]; then
>> +			_scratch_mount "-o dax"
>> +			testfile=$SCRATCH_MNT/$$.xfs_io
> 
> NAK, the dax mount option is not intended to remain as a long-term
> interface.
> 
> Also, "==" is a bashism (which probably is fine for fstests)
> 
> Also, there's no _require_scratch which means this can totally blow up
> if the user doesn't specify a scratch device.

Yes, and _require_scratch_dax seems to be a better choice.

And I found that the "chattr +/-x" check could also pass on a dax device 
mounted without "-o dax".


-- 
Thanks,
Shiyang Ruan.
> 
> --D
> 
>> +		fi
>> +
>>   		# Test xfs_io chattr support AND
>>   		# filesystem FS_IOC_FSSETXATTR support
>>   		testio=`$XFS_IO_PROG -F -f -c "chattr +$param" $testfile 2>&1`
>>   		$XFS_IO_PROG -F -f -r -c "chattr -$param" $testfile 2>&1
>>   		param_checked="+$param"
>> +
>> +		if [ "$param" == "x" ]; then
>> +			_scratch_unmount
>> +		fi
>>   		;;
>>   	"chproj")
>>   		testio=`$XFS_IO_PROG -F -f -c "chproj 0" $testfile 2>&1`
>> -- 
>> 2.17.0
>>
>>
>>
> 
> 



