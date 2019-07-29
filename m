Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD8A78657
	for <lists+linux-xfs@lfdr.de>; Mon, 29 Jul 2019 09:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfG2HZF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 29 Jul 2019 03:25:05 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36552 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfG2HZF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jul 2019 03:25:05 -0400
Received: by mail-pf1-f196.google.com with SMTP id r7so27550374pfl.3;
        Mon, 29 Jul 2019 00:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=tSNkzIFA9QcwY64fazHYxcwNOWyRt8r05dSdyETBN2g=;
        b=r7MOAnrxL4083dNnRememb+aEfo+XDr7AnfSYFbsPAOygajjN+a0ArhBrK9AsNkEo9
         BWHwU0WTb9bRidG4q5URfIqaZTcHXE0DldZYUSQ+Oj0uuRyK4bBWiTTPmeBbEe+Cfm1h
         YcwHt25bDyC95u4f+xZrti5jK0L/QMMqOcC91OkdtRRTcvFmQ5eO5/9XcNCj3Z/tFxQZ
         8UEqYDBbzhu4Wwunn+kgLWMrLlfy6QIpYv7kBQbgWiA8YxJjvAmkEWLyy3zu6T08aFAf
         kV0yot4GUTUgs/VWzc8IwGs1gqHLkxMpHWFqIzbOo2JppUH5rhRCGKBaMS1YTUxXGZ2J
         PNbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tSNkzIFA9QcwY64fazHYxcwNOWyRt8r05dSdyETBN2g=;
        b=jesLxCu3Gew4uebrEAT99b6g6rehIueYKXCMyYAh/ysRUJn87HzVhJ9rTepq9Bn+ab
         swI6N8EqphkyfG7nTtZqaqE7K2YtI9wWYtqZxIyLrqkgG/kKH/VJvbwLsB+l0p436HAy
         Rf65nUI0s5kb2sgPNyLRVMa6Sn5ke8ZuncpJipAXhU2g5VI1bPR4W94hL7uqKWf9Msiq
         VALcgeznBXugVPz9aPswNrXqADmxvA2oXytKFyUVqonCjeq4ar1O/nB4YjeTOoRVHRuS
         A9lnQXKq6xqZg5NcC8VMGsCxxGbLuoABklY77NKKHoATYtft8Es91gYeEyot0s6EljC8
         ASTw==
X-Gm-Message-State: APjAAAXRijNwSaSdfoPmuAWrp7om1oXKaRFnO8TTil5I74gGWEPZTWMW
        YNrvm1IoLWO0yKcWPuXcq3N+xr4u
X-Google-Smtp-Source: APXvYqxgp5FTnNyJ/mIccgHSB4hhYCvcG013jpDvTSf7iz+qKgnLGGMUu83ceLtv9ZQD/5EsD9J5KA==
X-Received: by 2002:aa7:9531:: with SMTP id c17mr36301099pfp.130.1564385104775;
        Mon, 29 Jul 2019 00:25:04 -0700 (PDT)
Received: from ?IPv6:2402:f000:4:72:808::177e? ([2402:f000:4:72:808::177e])
        by smtp.gmail.com with ESMTPSA id i14sm93125571pfk.0.2019.07.29.00.25.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 00:25:04 -0700 (PDT)
Subject: Re: [PATCH] fs: xfs: Fix possible null-pointer dereferences in
 xchk_da_btree_block_check_sibling()
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     bfoster@redhat.com, sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190729032401.28081-1-baijiaju1990@gmail.com>
 <20190729042034.GM1561054@magnolia>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <efa37544-0402-af92-c94e-cec49701dca2@gmail.com>
Date:   Mon, 29 Jul 2019 15:25:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729042034.GM1561054@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2019/7/29 12:20, Darrick J. Wong wrote:
> On Mon, Jul 29, 2019 at 11:24:01AM +0800, Jia-Ju Bai wrote:
>> In xchk_da_btree_block_check_sibling(), there is an if statement on
>> line 274 to check whether ds->state->altpath.blk[level].bp is NULL:
>>      if (ds->state->altpath.blk[level].bp)
>>
>> When ds->state->altpath.blk[level].bp is NULL, it is used on line 281:
>>      xfs_trans_brelse(..., ds->state->altpath.blk[level].bp);
>>          struct xfs_buf_log_item	*bip = bp->b_log_item;
>>          ASSERT(bp->b_transp == tp);
>>
>> Thus, possible null-pointer dereferences may occur.
>>
>> To fix these bugs, ds->state->altpath.blk[level].bp is checked before
>> being used.
>>
>> These bugs are found by a static analysis tool STCheck written by us.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>> ---
>>   fs/xfs/scrub/dabtree.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
>> index 94c4f1de1922..33ff90c0dd70 100644
>> --- a/fs/xfs/scrub/dabtree.c
>> +++ b/fs/xfs/scrub/dabtree.c
>> @@ -278,7 +278,9 @@ xchk_da_btree_block_check_sibling(
>>   	/* Compare upper level pointer to sibling pointer. */
>>   	if (ds->state->altpath.blk[level].blkno != sibling)
>>   		xchk_da_set_corrupt(ds, level);
>> -	xfs_trans_brelse(ds->dargs.trans, ds->state->altpath.blk[level].bp);
>> +	if (ds->state->altpath.blk[level].bp)
>> +		xfs_trans_brelse(ds->dargs.trans,
>> +						ds->state->altpath.blk[level].bp);
> Indentation here (in xfs we use two spaces)

Okay, I will fix this.

>
> Also, uh, shouldn't we set ds->state->altpath.blk[level].bp to NULL
> since we've released the buffer?

So I should set ds->state->altpath.blk[level].bp to NULL at the end of 
the function xchk_da_btree_block_check_sibling()?
Like:
     if (ds->state->altpath.blk[level].bp)
         xfs_trans_brelse(ds->dargs.trans,
                 ds->state->altpath.blk[level].bp);
     ds->state->altpath.blk[level].bp = NULL;


Best wishes,
Jia-Ju Bai
