Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D89C23679B
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Jun 2019 00:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfFEWvM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 18:51:12 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:41057 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726532AbfFEWvM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 18:51:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0TTWbVmc_1559775068;
Received: from JosephdeMacBook-Pro.local(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0TTWbVmc_1559775068)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 06 Jun 2019 06:51:09 +0800
Subject: Re: [bug report][stable] xfstests:generic/538 failed on xfs
To:     Brian Foster <bfoster@redhat.com>,
        gregkh <gregkh@linuxfoundation.org>
Cc:     Alvin Zheng <Alvin@linux.alibaba.com>,
        "darrick.wong" <darrick.wong@oracle.com>, axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        caspar <caspar@linux.alibaba.com>
References: <f9a7b0c4-178a-4a7c-8ac6-aec79b06b810.Alvin@linux.alibaba.com>
 <20190605124227.GC17558@kroah.com> <20190605135756.GA15671@bfoster>
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
Message-ID: <d644a3a9-f05e-ccde-967b-2e9e9b8cb66a@linux.alibaba.com>
Date:   Thu, 6 Jun 2019 06:51:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190605135756.GA15671@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 19/6/5 21:57, Brian Foster wrote:
> On Wed, Jun 05, 2019 at 02:42:27PM +0200, gregkh wrote:
>> On Wed, Jun 05, 2019 at 08:21:44PM +0800, Alvin Zheng wrote:
>>> Hi,
>>>   I was using kernel v4.19.48 and found that it cannot pass the generic/538 on xfs. The error output is as follows:
>>
>> Has 4.19 ever been able to pass that test?  If not, I wouldn't worry
>> about it :)
>>
> 
> FWIW, the fstests commit references the following kernel patches for
> fixes in XFS and ext4:
> 
>   xfs: serialize unaligned dio writes against all other dio writes
>   ext4: fix data corruption caused by unaligned direct AIO

IIUC, the corresponding ext4 fix is:
ext4: fix data corruption caused by overlapping unaligned and aligned IO
It was backported in 4.19.45.

Thanks,
Joseph

> 
> It looks like both of those patches landed in 5.1.
> 
> Brian
> 
>>>
>>>   FSTYP         -- xfs (non-debug)
>>>   PLATFORM      -- Linux/x86_64 alinux2-6 4.19.48
>>>   MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdc
>>>   MOUNT_OPTIONS -- /dev/vdc /mnt/testarea/scra
>>>   generic/538 0s ... - output mismatch (see /root/usr/local/src/xfstests/results//generic/538.out.bad)
>>>       --- tests/generic/538.out   2019-05-27 13:57:06.505666465 +0800
>>>       +++ /root/usr/local/src/xfstests/results//generic/538.out.bad       2019-06-05 16:43:14.702002326 +0800
>>>       @@ -1,2 +1,10 @@
>>>        QA output created by 538
>>>       +Data verification fails
>>>       +Find corruption
>>>       +00000000  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>       +*
>>>       +00000200  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
>>>       +00002000
>>>       ...
>>>       (Run 'diff -u /root/usr/local/src/xfstests/tests/generic/538.out /root/usr/local/src/xfstests/results//generic/538.out.bad'  to see the entire diff)
>>>   Ran: generic/538
>>>   Failures: generic/538
>>>   Failed 1 of 1 tests
>>>   
>>> I also found that the latest kernel (v5.2.0-rc2) of upstream can pass the generic/538 test. Therefore, I bisected and found the first good commit is 3110fc79606. This commit adds the hardware queue into the sort function. Besides, the sort function returns a negative value when the offset and queue (software and hardware) of two I/O requests are same. I think the second part of the change make senses. The kernel should not change the relative position of two I/O requests when their offset and queue are same. So I made the following changes and merged it into the kernel 4.19.48. After the modification, we can pass the generic/538 test on xfs. The same case can be passed on ext4, since ext4 has corresponding fix 0db24122bd7f ("ext4: fix data corruption caused by overlapping unaligned and aligned IO"). Though I think xfs should be responsible for this issue, the block layer code below is also problematic. Any ideas?
>>>
>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>> index 4e563ee..a7309cd 100644
>>> --- a/block/blk-mq.c
>>> +++ b/block/blk-mq.c
>>> @@ -1610,7 +1610,7 @@ static int plug_ctx_cmp(void *priv, struct list_head *a, struct list_head *b)
>>>
>>>         return !(rqa->mq_ctx < rqb->mq_ctx ||
>>>                  (rqa->mq_ctx == rqb->mq_ctx &&
>>> -                 blk_rq_pos(rqa) < blk_rq_pos(rqb)));
>>> +                 blk_rq_pos(rqa) <= blk_rq_pos(rqb)));
>>>  }
>>>
>>>  void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
>>
>> I would not like to take a patch that is not upstream, but rather take
>> the original commit.
>>
>> Can 3110fc79606f ("blk-mq: improve plug list sorting") on its own
>> resolve this issue for 4.19.y?
>>
>> thanks,
>>
>> greg k-h
