Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C44143C57
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 17:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfFMPfV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 11:35:21 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:47163 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727627AbfFMKXu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 06:23:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=alvin@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TU3WTbg_1560421398;
Received: from 30.1.89.131(mailfrom:Alvin@linux.alibaba.com fp:SMTPD_---0TU3WTbg_1560421398)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 13 Jun 2019 18:23:18 +0800
Subject: Re: [PATCH xfsprogs manual] Inconsistency between the code and the
 manual page
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        "darrick.wong" <darrick.wong@oracle.com>,
        caspar <caspar@linux.alibaba.com>
References: <a8dbaa7f-f89c-8a78-1fc6-3626f6b3f873@linux.alibaba.com>
 <20190612221957.GF14363@dread.disaster.area>
From:   Alvin Zheng <Alvin@linux.alibaba.com>
Message-ID: <39ccf3a5-a191-847a-1d68-67e040edc4ed@linux.alibaba.com>
Date:   Thu, 13 Jun 2019 18:23:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190612221957.GF14363@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2019/6/13 6:19, Dave Chinner wrote:
> On Wed, Jun 12, 2019 at 01:20:46PM +0800, Alvin Zheng wrote:
>> Hi,
>>
>>      The manual page of mkfs.xfs (xfsprogs-5.0.0) says "When specifying
>> parameters in units of sectors or filesystem blocks, the -s option or the -b
>> option first needs to be added to the command line.  Failure to specify the
>> size of the units will result in illegal value errors when parameters are
>> quantified in those units". However, I read the code and found that if the
>> size of the block and sector is not specified, the default size (block: 4k,
>> sector: 512B) will be used. Therefore, the following commands can work
>> normally in xfsprogs-5.0.0.
>>
>>       mkfs.xfs -n size=2b /dev/vdc
>>       mkfs.xfs -d agsize=8192b /dev/vdc
>>
>>      So I think the manual of mkfs.xfs should be updated as follows. Any
>> ideas?
> The intent of the wording in the mkfs man page is "when using a
> custom sector or block size, it must be specified before any
> parameter that uses units of sector or block sizes." So just
> removing the "it must be specified first" wording is incorrect
> because mkfs should throw errors is it is not specified first.
>
>> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
>> index 4b8c78c..45d7a84 100644
>> --- a/man/man8/mkfs.xfs.8
>> +++ b/man/man8/mkfs.xfs.8
>> @@ -115,9 +115,7 @@ When specifying parameters in units of sectors or
>> filesystem blocks, the
>>   .B \-s
>>   option or the
>>   .B \-b
>> -option first needs to be added to the command line.
>> -Failure to specify the size of the units will result in illegal value
>> errors
>> -when parameters are quantified in those units.
>> +option can be used to specify the size of the sector or block. If the size
>> of the block or sector is not specified, the default size (block: 4KiB,
>> sector: 512B) will be used.
> That's fine to remove.
>
>>   .PP
>>   Many feature options allow an optional argument of 0 or 1, to explicitly
>>   disable or enable the functionality.
>> @@ -136,10 +134,6 @@ The filesystem block size is specified with a
>>   in bytes. The default value is 4096 bytes (4 KiB), the minimum is 512, and
>> the
>>   maximum is 65536 (64 KiB).
>>   .IP
>> -To specify any options on the command line in units of filesystem blocks,
>> this
>> -option must be specified first so that the filesystem block size is
>> -applied consistently to all options.
> "If a non-default filesystem block size is specified, the option
> must be specified before any options that use filesystem block size
> units so that the non-default filesystem block size is applied
> consistently to all options."
>
>> -.IP
>>   Although
>>   .B mkfs.xfs
>>   will accept any of these values and create a valid filesystem,
>> @@ -894,10 +888,6 @@ is 512 bytes. The minimum value for sector size is
>>   .I sector_size
>>   must be a power of 2 size and cannot be made larger than the
>>   filesystem block size.
>> -.IP
>> -To specify any options on the command line in units of sectors, this
>> -option must be specified first so that the sector size is
>> -applied consistently to all options.
> Same wording as for the filesystem block size applies to sector
> sizes as well.
>
> Cheers,
>
> Dave.

Thanks for your suggestions, I will send a updated patch.  :)

Best regards,

Alvin

