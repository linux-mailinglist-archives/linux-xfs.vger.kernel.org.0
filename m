Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42EA255D4D
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 03:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfFZBSt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 21:18:49 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:26967 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726068AbfFZBSt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 21:18:49 -0400
X-IronPort-AV: E=Sophos;i="5.63,417,1557158400"; 
   d="scan'208";a="69350343"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 26 Jun 2019 09:18:47 +0800
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 2C7754CDE889;
        Wed, 26 Jun 2019 09:18:44 +0800 (CST)
Received: from [10.167.215.30] (10.167.215.30) by
 G08CNEXCHPEKD02.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 id 14.3.439.0; Wed, 26 Jun 2019 09:18:50 +0800
Message-ID: <5D12C7F5.8050502@cn.fujitsu.com>
Date:   Wed, 26 Jun 2019 09:18:45 +0800
From:   Yang Xu <xuyang2018.jy@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To:     Amir Goldstein <amir73il@gmail.com>
CC:     Theodore Ts'o <tytso@mit.edu>, darrick <darrick.wong@oracle.com>,
        Murphy Zhou <jencce.kernel@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] generic/554: test only copy to active swap file
References: <20190611153916.13360-1-amir73il@gmail.com> <20190611153916.13360-2-amir73il@gmail.com> <20190618090238.kmeocxasyxds7lzg@XZHOUW.usersys.redhat.com> <CAOQ4uxhePeTzR1t3e67xY+H0vcvh5toB3S=vdYVKm-skJrM00g@mail.gmail.com> <20190618150242.GA4576@mit.edu> <20190618151144.GB5387@magnolia> <5D11F781.4040906@cn.fujitsu.com> <CAOQ4uxgYApyiiSCWiCUJRgRoYYztMuON2d_mhLso-=DkqwNcbA@mail.gmail.com>
In-Reply-To: <CAOQ4uxgYApyiiSCWiCUJRgRoYYztMuON2d_mhLso-=DkqwNcbA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.215.30]
X-yoursite-MailScanner-ID: 2C7754CDE889.AC684
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: xuyang2018.jy@cn.fujitsu.com
X-Spam-Status: No
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2019/06/25 18:35, Amir Goldstein wrote:

> On Tue, Jun 25, 2019 at 1:29 PM Yang Xu<xuyang2018.jy@cn.fujitsu.com>  wrote:
>> on 2019/06/18 23:11, Darrick J. Wong  wrote:
>>
>>> On Tue, Jun 18, 2019 at 11:02:42AM -0400, Theodore Ts'o wrote:
>>>> On Tue, Jun 18, 2019 at 12:16:45PM +0300, Amir Goldstein wrote:
>>>>> On Tue, Jun 18, 2019 at 12:02 PM Murphy Zhou<jencce.kernel@gmail.com>   wrote:
>>>>>> Would you mind updating sha1 after it get merged to Linus tree?
>>>>>>
>>>>>> That would be helpful for people tracking this issue.
>>>>>>
>>>>> This is the commit id in linux-next and expected to stay the same
>>>>> when the fix is merged to Linus tree for 5.3.
>>>> When I talked to Darrick last week, that was *not* the sense I got
>>>> from him.  It's not necessarily guaranteed to be stable just yet...
>>> Darrick hasn't gotten any complaints about the copy-file-range-fixes
>>> branch (which has been in for-next for a week now), so he thinks that
>>> commit id (a31713517dac) should be stable from here on out.
>>>
>>> (Note that doesn't guarantee that Linus will pull said branch...)
>>>
>>> --D
>> Hi Amir
>>
>> The kernel fix commit message is right?  :-)  Because when I backport this patch into 5.2.0-rc6+ kernel,
>> generic/554(553) also fails, it should be commit a5544984af4 (vfs: add missing checks to copy_file_range).
>> By the way, a31713517dac ("vfs: introduce generic_file_rw_checks()") doesn't check for immutable and swap file.
>>
>> I think we can change this message after the fix is merged to Linus tree for 5.3.  What do you think about it?
> You are right. Documented commit is wrong.
> The correct commit in linux-next is:
> 96e6e8f4a68d ("vfs: add missing checks to copy_file_range")
>
> (Not sure where you got a5544984af4 from?)
I get a5544984af4 from Darrick.wong copy-file-range-fixes branch.

> Let's fix that after the commit is upstream.
>
> Obviously, you would need to backport the entire series and not just this
> one commit to stable kernel.
Yes. I got it.

> Thanks,
> Amir.
>
>
>



