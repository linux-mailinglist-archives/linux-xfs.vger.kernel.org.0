Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C3A2F45A7
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Jan 2021 09:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbhAMIBV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 Jan 2021 03:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbhAMIBV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 03:01:21 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DF1C061786
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 00:00:40 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id y23so698768wmi.1
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jan 2021 00:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=j+phcGccWNYx6CuN2i6dA9HCxl9zcXue5WemNAndSR0=;
        b=cARf7HljFW5Yrth+pVwecZH3HEmgbx4u7O9KacJBI+WN5tF63+X3bG0JEVmq5FhAwx
         CaZvAa7yRj7CqQ3fU5KZDbmNF4BBgwjaiVzn7ZnyJ73Df2mfI/LonkmLj/DlWWP1VCcR
         x1F8SORPdBgaL6457xIOCRZvm9XCTUJC+QBD4odwyXR/JjgPO+Rx3tUbR2HDSa7GNCzO
         EM+zmp0+7e0bYviqFCyjjWD3dIUG3amzlEsAsCwS9An2Ez6WMQwJR3Pkw9ertSXSIabW
         hmSxY4vTndp+67ctlavJkZnRTANmxzCm0oAS+7H7S3YrGZelFNcIxuZAjn2UT2AeY0G6
         WL8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=j+phcGccWNYx6CuN2i6dA9HCxl9zcXue5WemNAndSR0=;
        b=FAYKTgz4Wtk10PApR7NvUhMQpoZmm2/LvQWf1fNUPnnUl8PHLhdoQ6Jj/XwOUPnL0V
         UeEyCYXsxCFj8zOk20QN3hKGowziO5x9WGf9I+kLiVF106ayNPNT+zNlmgcB7I0hu01W
         G9fUuOTTUFrDUA6RA0uhW6gy1LiqeE01EA6T4nWZcI2h7pehuboI5rUMz49ukRMrtM0z
         S6u2rn5lggp8MCKpH+GAvEPwOdUdS6WnA2E8HpufEZ/ijv/Q1W37hAzxp65puB4w3AYt
         3OcT3UVDRFXVruagdEnpvP0ExhiQRVh0uB7gvB5VP6ziQbnmBV9luZZOJXv0MNXKonqu
         K9Yg==
X-Gm-Message-State: AOAM530bR8qL150KY1QLjhJnP+Hl3F0bRx2Ou6FK/ye2PpafvnKr3rNs
        +pic8D9g6HDLCmql4/TOuE/+0w==
X-Google-Smtp-Source: ABdhPJwGRoLRhdGi9jS2nK8zn5OEff7vam08vOEyi3454sLkZp1si8PGowRWXBGj1TqE9r/+CHVlYA==
X-Received: by 2002:a1c:68c4:: with SMTP id d187mr915864wmc.53.1610524839540;
        Wed, 13 Jan 2021 00:00:39 -0800 (PST)
Received: from tmp.scylladb.com (bzq-79-182-3-66.red.bezeqint.net. [79.182.3.66])
        by smtp.googlemail.com with ESMTPSA id z15sm1764353wrv.67.2021.01.13.00.00.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 00:00:38 -0800 (PST)
Subject: Re: [RFC] xfs: reduce sub-block DIO serialisation
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        andres@anarazel.de
References: <20210112010746.1154363-1-david@fromorbit.com>
 <32f99253-fe56-9198-e47c-7eb0e24fdf73@scylladb.com>
 <20210112221324.GU331610@dread.disaster.area>
From:   Avi Kivity <avi@scylladb.com>
Message-ID: <0f0706f9-92ab-6b38-f3ab-b91aaf4343d1@scylladb.com>
Date:   Wed, 13 Jan 2021 10:00:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210112221324.GU331610@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/13/21 12:13 AM, Dave Chinner wrote:
> On Tue, Jan 12, 2021 at 10:01:35AM +0200, Avi Kivity wrote:
>> On 1/12/21 3:07 AM, Dave Chinner wrote:
>>> Hi folks,
>>>
>>> This is the XFS implementation on the sub-block DIO optimisations
>>> for written extents that I've mentioned on #xfs and a couple of
>>> times now on the XFS mailing list.
>>>
>>> It takes the approach of using the IOMAP_NOWAIT non-blocking
>>> IO submission infrastructure to optimistically dispatch sub-block
>>> DIO without exclusive locking. If the extent mapping callback
>>> decides that it can't do the unaligned IO without extent
>>> manipulation, sub-block zeroing, blocking or splitting the IO into
>>> multiple parts, it aborts the IO with -EAGAIN. This allows the high
>>> level filesystem code to then take exclusive locks and resubmit the
>>> IO once it has guaranteed no other IO is in progress on the inode
>>> (the current implementation).
>>
>> Can you expand on the no-splitting requirement? Does it involve only
>> splitting by XFS (IO spans >1 extents) or lower layers (RAID)?
> XFS only.


Ok, that is somewhat under control as I can provide an extent hint, and 
wish really hard that the filesystem isn't fragmented.


>> The reason I'm concerned is that it's the constraint that the application
>> has least control over. I guess I could use RWF_NOWAIT to avoid blocking my
>> main thread (but last time I tried I'd get occasional EIOs that frightened
>> me off that).
> Spurious EIO from RWF_NOWAIT is a bug that needs to be fixed. DO you
> have any details?
>

I reported it in [1]. It's long since gone since I disabled RWF_NOWAIT. 
It was relatively rare, sometimes happening in continuous integration 
runs that take hours, and sometimes not.


I expect it's fixed by now since io_uring relies on it. Maybe I should 
turn it on for kernels > some_random_version.


[1] 
https://lore.kernel.org/lkml/9bab0f40-5748-f147-efeb-5aac4fd44533@scylladb.com/t/#u

