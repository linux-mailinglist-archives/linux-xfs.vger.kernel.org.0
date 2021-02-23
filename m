Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9E7322DEA
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Feb 2021 16:49:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbhBWPsh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Feb 2021 10:48:37 -0500
Received: from sandeen.net ([63.231.237.45]:33972 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233390AbhBWPrY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Feb 2021 10:47:24 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 1F5A55A10B8;
        Tue, 23 Feb 2021 09:46:25 -0600 (CST)
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
References: <83696ce6-4054-0e77-b4b8-e82a1a9fbbc3@redhat.com>
 <896a0202-aac8-e43f-7ea6-3718591e32aa@sandeen.net>
 <20180324162049.GP4818@magnolia> <20180326124649.GD34912@bfoster.bfoster>
 <20180327211728.GP18129@dastard>
 <20210223134256.GA1327978@xiangao.remote.csb>
 <a3a02b9b-656a-7284-d1b1-befbafc3e9f9@sandeen.net>
 <20210223150341.GA1341686@xiangao.remote.csb>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/2] xfs: don't dirty snapshot logs for unlinked inode
 recovery
Message-ID: <97534412-b95d-48f8-0a5a-3eafe47d72a6@sandeen.net>
Date:   Tue, 23 Feb 2021 09:46:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210223150341.GA1341686@xiangao.remote.csb>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/23/21 9:03 AM, Gao Xiang wrote:
> On Tue, Feb 23, 2021 at 08:40:56AM -0600, Eric Sandeen wrote:
>> On 2/23/21 7:42 AM, Gao Xiang wrote:
>>> Hi folks,
>>>
>>> On Wed, Mar 28, 2018 at 08:17:28AM +1100, Dave Chinner wrote:
>>>> On Mon, Mar 26, 2018 at 08:46:49AM -0400, Brian Foster wrote:
>>>>> On Sat, Mar 24, 2018 at 09:20:49AM -0700, Darrick J. Wong wrote:
>>>>>> On Wed, Mar 07, 2018 at 05:33:48PM -0600, Eric Sandeen wrote:
>>>>>>> Now that unlinked inode recovery is done outside of
>>>>>>> log recovery, there is no need to dirty the log on
>>>>>>> snapshots just to handle unlinked inodes.  This means
>>>>>>> that readonly snapshots can be mounted without requiring
>>>>>>> -o ro,norecovery to avoid the log replay that can't happen
>>>>>>> on a readonly block device.
>>>>>>>
>>>>>>> (unlinked inodes will just hang out in the agi buckets until
>>>>>>> the next writable mount)
>>>>>>
>>>>>> FWIW I put these two in a test kernel to see what would happen and
>>>>>> generic/311 failures popped up.  It looked like the _check_scratch_fs
>>>>>> found incorrect block counts on the snapshot(?)
>>>>>>
>>>>>
>>>>> Interesting. Just a wild guess, but perhaps it has something to do with
>>>>> lazy sb accounting..? I see we call xfs_initialize_perag_data() when
>>>>> mounting an unclean fs.
>>>>
>>>> The freeze is calls xfs_log_sbcount() which should update the
>>>> superblock counters from the in-memory counters and write them to
>>>> disk.
>>>>
>>>> If they are out, I'm guessing it's because the in-memory per-ag
>>>> reservations are not being returned to the global pool before the
>>>> in-memory counters are summed during a freeze....
>>>>
>>>> Cheers,
>>>>
>>>> Dave.
>>>> -- 
>>>> Dave Chinner
>>>> david@fromorbit.com
>>>
>>> I spend some time on tracking this problem. I've made a quick
>>> modification with per-AG reservation and tested with generic/311
>>> it seems fine. My current question is that how such fsfreezed
>>> images (with clean mount) work with old kernels without [PATCH 1/1]?
>>> I'm afraid orphan inodes won't be freed with such old kernels....
>>> Am I missing something?
>>
>> It's true, a snapshot created with these patches will not have their unlinked
>> inodes processed if mounted on an older kernel. I'm not sure how much of a
>> problem that is; the filesystem is not inconsistent, but some space is lost,
>> I guess. I'm not sure it's common to take a snapshot of a frozen filesystem on
>> one kernel and then move it back to an older kernel.  Maybe others have
>> thoughts on this.
> 
> My current thought might be only to write clean mount without
> unlinked inodes when freezing, but leave log dirty if any
> unlinked inodes exist as Brian mentioned before and don't
> handle such case (?). I'd like to hear more comments about
> this as well.

I don't know if I had made this comment before ;) but I feel like that's even
more "surprise" (as in: gets further from the principle of least surprise)
and TBH I would rather not have that somewhat unpredictable behavior.

I think I'd rather /always/ make a dirty log than sometimes do it, other
times not. It'd just be more confusion for the admin IMHO.

Thanks,
-Eric

> Thanks,
> Gao Xiang
> 
>>
>> -Eric
>>
> 
