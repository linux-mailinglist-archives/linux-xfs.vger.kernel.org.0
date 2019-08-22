Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A45398B77
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Aug 2019 08:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfHVGgj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 22 Aug 2019 02:36:39 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35430 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbfHVGgj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 02:36:39 -0400
Received: by mail-pl1-f194.google.com with SMTP id gn20so2848402plb.2
        for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2019 23:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pSoXR2D2OnLHuNyUMSsWbUEVN/S2NcVhjAAS1QkJJUI=;
        b=IWFIdsICc5kxcOtVOBfbTOXBLowRYnxDYtv+J2GfXglgaGIhQXFJDJIty7Rm+0S+t0
         AEufwmslfh3MjgY8F5IkWQIUGPvH0oXlv3avTJSBOfzwVV9zLmSWgvWzSAhCD+/6spSn
         2LeKVL01BfuPHjbtZPlr2G3HdYPmfivCNXgqNe3d49cXtq0JFKHEY8C6wB8j0gR23hhy
         euSzSGQbgaIQoB//u7CTN8iFzad7brU2YntHQnM4/DG5xGOVKSFo8nOMq2WNAUG61w9Z
         ZeBu/Yc7BpIUUhIpY2a87UfKyFeNtDqCJwfOQOuY9DmJx6fVHYqhzw+zLTJ5S7mFXJIS
         zvEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pSoXR2D2OnLHuNyUMSsWbUEVN/S2NcVhjAAS1QkJJUI=;
        b=Fe0XLmff4Cbc2q63FWhtzOK+OglUWPAD0nRkKwUkZzX5Ua46czsuFTJ0boJ2a2c3k2
         8wsBbZs5Em2UgHK9lPzpHCpBfsvfX9rpfZCePeY/WbElDnTAWWPqKH9UYBvjPjkSQioQ
         iOHlqiAScKxaxyn7Dk6Ceoo8zCAE22TXsuiRRGJReynq7pwlhu5kS+RP4Yx+N3G5LiiS
         e+fjcEHKJ2pgQjekuHD96Hab3iPh2Vq575n2tS4x4HYiHaWHbop1updSSvosxey3otaE
         kAvU7E4lSzziJXUoVZQF9uQwoaI7PUpa0U3RvKuacGGs8xNOThKMEgnL3Pd8pVUozU3f
         bLFw==
X-Gm-Message-State: APjAAAWF1nZO+IvxKCqArifEg874pedruXdegDa/2b9kDngUwyazxo0k
        8I0rL4FSETc3U05HrsGADQ==
X-Google-Smtp-Source: APXvYqxa7Zb5lXQqntvA0o5d/6nscoHIC/yfx64GrvxIkn9J+tFBH2N27M7HKczLdZlYjpPT5r63zQ==
X-Received: by 2002:a17:902:288b:: with SMTP id f11mr11069796plb.13.1566455798861;
        Wed, 21 Aug 2019 23:36:38 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id s20sm25112769pfe.169.2019.08.21.23.36.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 23:36:38 -0700 (PDT)
Subject: Re: [PATCH v4] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>, newtongao@tencent.com,
        jasperwang@tencent.com
References: <72adde91-556c-8af3-e217-5a658697972e@gmail.com>
 <20190822050143.GV1119@dread.disaster.area>
 <3d6e190f-f88e-ef75-8dc1-9b0958706e38@gmail.com>
 <20190822060648.GX1119@dread.disaster.area>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <ba9a37ff-bdfd-d5b1-c882-27afe2bd5a88@gmail.com>
Date:   Thu, 22 Aug 2019 14:36:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822060648.GX1119@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2019/8/22 14:06, Dave Chinner wrote:
> On Thu, Aug 22, 2019 at 01:45:48PM +0800, kaixuxia wrote:
>> On 2019/8/22 13:01, Dave Chinner wrote:
>>> On Thu, Aug 22, 2019 at 12:33:23PM +0800, kaixuxia wrote:
>>>
>>>> @@ -3419,25 +3431,15 @@ struct xfs_iunlink {
>>>>  
>>>>  	/*
>>>>  	 * For whiteouts, we need to bump the link count on the whiteout inode.
>>>
>>> Shouldn't this line be removed as well?
>>
>> Because the xfs_bumplink() call below will do this.
> 
> Oh, yeah, I just assumed that from the "we have a real link" part of
> the new comment :P
> 
>>>> -	 * This means that failures all the way up to this point leave the inode
>>>> -	 * on the unlinked list and so cleanup is a simple matter of dropping
>>>> -	 * the remaining reference to it. If we fail here after bumping the link
>>>> -	 * count, we're shutting down the filesystem so we'll never see the
>>>> -	 * intermediate state on disk.
>>>> +	 * The whiteout inode has been removed from the unlinked list and log
>>>> +	 * recovery will clean up the mess for the failures up to this point.
>>>> +	 * After this point we have a real link, clear the tmpfile state flag
>>>> +	 * from the inode so it doesn't accidentally get misused in future.
>>>>  	 */
>>>>  	if (wip) {
>>>>  		ASSERT(VFS_I(wip)->i_nlink == 0);
>>>>  		xfs_bumplink(tp, wip);
>>>> -		error = xfs_iunlink_remove(tp, wip);
>>>> -		if (error)
>>>> -			goto out_trans_cancel;
>>>>  		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
>>>> -
>>>> -		/*
>>>> -		 * Now we have a real link, clear the "I'm a tmpfile" state
>>>> -		 * flag from the inode so it doesn't accidentally get misused in
>>>> -		 * future.
>>>> -		 */
>>>>  		VFS_I(wip)->i_state &= ~I_LINKABLE;
>>>>  	}
>>>
>>> Why not move all this up into the same branch that removes the
>>> whiteout from the unlinked list? Why separate this logic as none of
>>> what is left here could cause a failure even if it is run earlier?
>>
>> Yep, it could not cause a failure if we move all this into the same
>> branch that xfs_iunlink_remove() call. We move the xfs_iunlink_remove()
>> first to preserve correct AGI/AGF locking order, and maybe it is better
>> we bump the link count after using the whiteout inode really, such as
>> xfs_dir_replace(...,wip,...) ...
> 
> It makes no difference where we bump the link count as long as we do
> it after the xfs_iunlink_remove() call. At that point, any failure
> will result in a shutdown and so it doesn't matter that we've
> already bumped the link count because the shutdown with prevent
> it from reaching the disk...

Yeah, so it can be like this:

	/*
	 * For whiteouts, we need to bump the link count on the whiteout inode.
	 * The whiteout inode is removed from the unlinked list and log recovery
	 * will clean up the mess for the failures after this point. After this
 	 * point we have a real link, clear the tmpfile state flag from the inode
	 * so it doesn't accidentally get misused in future.
	 */
	if (wip) {
		ASSERT(VFS_I(wip)->i_nlink == 0);
		error = xfs_iunlink_remove(tp, wip);
		if (error)
			...
		xfs_bumplink(tp, wip);
		xfs_trans_log_inode(tp, wip, XFS_ILOG_CORE);
		VFS_I(wip)->i_state &= ~I_LINKABLE;
	}

Right?

> 
> Cheers,
> 
> Dave.
> 

-- 
kaixuxia
