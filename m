Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28C718B82C
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Aug 2019 14:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfHMMPi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 13 Aug 2019 08:15:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:59178 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726551AbfHMMPi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Aug 2019 08:15:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DCFA2AE62;
        Tue, 13 Aug 2019 12:15:36 +0000 (UTC)
Subject: Re: [PATCH 1/3] xfs: Use __xfs_buf_submit everywhere
From:   Nikolay Borisov <nborisov@suse.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org
References: <20190813090306.31278-1-nborisov@suse.com>
 <20190813090306.31278-2-nborisov@suse.com> <20190813115544.GA37069@bfoster>
 <be8ce98d-1815-8db0-3bf2-5cda3c84e809@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <1ecc240c-13d6-4700-fe73-408d6a1a55bb@suse.com>
Date:   Tue, 13 Aug 2019 15:15:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <be8ce98d-1815-8db0-3bf2-5cda3c84e809@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 13.08.19 г. 15:06 ч., Nikolay Borisov wrote:
> 
> 
> On 13.08.19 г. 14:55 ч., Brian Foster wrote:
>> On Tue, Aug 13, 2019 at 12:03:04PM +0300, Nikolay Borisov wrote:
>>> Currently xfs_buf_submit is used as a tiny wrapper to __xfs_buf_submit.
>>> It only checks whether XFB_ASYNC flag is set and sets the second
>>> parameter to __xfs_buf_submit accordingly. It's possible to remove the
>>> level of indirection since in all contexts where xfs_buf_submit is
>>> called we already know if XBF_ASYNC is set or not.
>>>
>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>> ---
>>
>> Random nit: the use of upper case in the first word of the commit log
>> subject line kind of stands out to me. I know there are other instances
>> of this (I think I noticed one the other day), but my presumption was
>> that it was random/accidental where your patches seem to do it
>> intentionally. Do we have a common practice here? Do we care? I prefer
>> consistency of using lower case for normal text, but it's really just a
>> nit.
> 
> I consider the commit log subject and commit log body to be 2 separate
> paragraphs, hence I start each one with capital letter.
> 
>>
>>>  fs/xfs/xfs_buf.c         | 8 +++++---
>>>  fs/xfs/xfs_buf_item.c    | 2 +-
>>>  fs/xfs/xfs_log_recover.c | 2 +-
>>>  3 files changed, 7 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
>>> index ca0849043f54..a75d05e49a98 100644
>>> --- a/fs/xfs/xfs_buf.c
>>> +++ b/fs/xfs/xfs_buf.c
>>> @@ -751,13 +751,15 @@ _xfs_buf_read(
>>>  	xfs_buf_t		*bp,
>>>  	xfs_buf_flags_t		flags)
>>>  {
>>> +	bool wait = bp->b_flags & XBF_ASYNC ? false : true;
>>> +
>>
>> This doesn't look quite right. Just below we clear several flags from
>> ->b_flags then potentially reapply based on the flags parameter. Hence,
>> I think ->b_flags above may not reflect ->b_flags by the time we call
>> __xfs_buf_submit().
> 
> It's correct the flag clearing/setting ensures that the only flags we
> have in bp->b_flags are in the set: flags & (XBF_READ | XBF_ASYNC |
> XBF_READ_AHEAD);
> 
> So if XBF_ASYNC was set initially it will also be set when we call
> xfs_buf_submit.

Ah, I see what you meant, indeed the correct check would be :

flags & XBF_ASYNC ...

I will wait to see if people actually consider this series useful and
then resubmit a fixed version.

> 
> 
>>
>> Brian
>>
>>>  	ASSERT(!(flags & XBF_WRITE));
>>>  	ASSERT(bp->b_maps[0].bm_bn != XFS_BUF_DADDR_NULL);
>>>  
>>>  	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
>>>  	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
>>>  
>>> -	return xfs_buf_submit(bp);
>>> +	return __xfs_buf_submit(bp, wait);
>>>  }
>>>  
>>>  /*
>>> @@ -883,7 +885,7 @@ xfs_buf_read_uncached(
>>>  	bp->b_flags |= XBF_READ;
>>>  	bp->b_ops = ops;
>>>  
>>> -	xfs_buf_submit(bp);
>>> +	__xfs_buf_submit(bp, true);
>>>  	if (bp->b_error) {
>>>  		int	error = bp->b_error;
>>>  		xfs_buf_relse(bp);
>>> @@ -1214,7 +1216,7 @@ xfs_bwrite(
>>>  	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
>>>  			 XBF_WRITE_FAIL | XBF_DONE);
>>>  
>>> -	error = xfs_buf_submit(bp);
>>> +	error = __xfs_buf_submit(bp, true);
>>>  	if (error)
>>>  		xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
>>>  	return error;
>>> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
>>> index 7dcaec54a20b..fef08980dd21 100644
>>> --- a/fs/xfs/xfs_buf_item.c
>>> +++ b/fs/xfs/xfs_buf_item.c
>>> @@ -1123,7 +1123,7 @@ xfs_buf_iodone_callback_error(
>>>  			bp->b_first_retry_time = jiffies;
>>>  
>>>  		xfs_buf_ioerror(bp, 0);
>>> -		xfs_buf_submit(bp);
>>> +		__xfs_buf_submit(bp, false);
>>>  		return true;
>>>  	}
>>>  
>>> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
>>> index 13d1d3e95b88..64e315f80147 100644
>>> --- a/fs/xfs/xfs_log_recover.c
>>> +++ b/fs/xfs/xfs_log_recover.c
>>> @@ -5610,7 +5610,7 @@ xlog_do_recover(
>>>  	bp->b_flags |= XBF_READ;
>>>  	bp->b_ops = &xfs_sb_buf_ops;
>>>  
>>> -	error = xfs_buf_submit(bp);
>>> +	error = __xfs_buf_submit(bp, true);
>>>  	if (error) {
>>>  		if (!XFS_FORCED_SHUTDOWN(mp)) {
>>>  			xfs_buf_ioerror_alert(bp, __func__);
>>> -- 
>>> 2.17.1
>>>
>>
> 
