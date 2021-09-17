Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A71840F1E3
	for <lists+linux-xfs@lfdr.de>; Fri, 17 Sep 2021 08:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbhIQGJC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 Sep 2021 02:09:02 -0400
Received: from smtp1.onthe.net.au ([203.22.196.249]:56229 "EHLO
        smtp1.onthe.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbhIQGJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Sep 2021 02:09:01 -0400
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 8C90461C64;
        Fri, 17 Sep 2021 16:07:38 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id 3jrt91Gak1AL; Fri, 17 Sep 2021 16:07:38 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 5E4A161C65;
        Fri, 17 Sep 2021 16:07:38 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 48F406802FA; Fri, 17 Sep 2021 16:07:38 +1000 (AEST)
Date:   Fri, 17 Sep 2021 16:07:38 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: Mysterious ENOSPC
Message-ID: <20210917060738.GA1005340@onthe.net.au>
References: <20210826205635.GA2453892@onthe.net.au>
 <20210827025539.GA3583175@onthe.net.au>
 <20210827054956.GP3657114@dread.disaster.area>
 <20210827065347.GA3594069@onthe.net.au>
 <20210827220343.GQ3657114@dread.disaster.area>
 <20210828002137.GA3642069@onthe.net.au>
 <20210828035824.GA3654894@onthe.net.au>
 <20210829220457.GR3657114@dread.disaster.area>
 <20210830073720.GA3763165@onthe.net.au>
 <20210902014206.GN2566745@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210902014206.GN2566745@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 02, 2021 at 11:42:06AM +1000, Dave Chinner wrote:
> On Mon, Aug 30, 2021 at 08:04:57AM +1000, Dave Chinner wrote:
>> FWIW, if you are using reflink heavily and you have rmap enabled (as
>> you have), there's every chance that an AG has completely run out of
>> space and so new rmap records for shared extents can't be allocated
>> - that can give you spurious ENOSPC errors before the filesystem is
>> 100% full, too.
>>
>> i.e. every shared extent in the filesystem has a rmap record
>> pointing back to each owner of the shared extent. That means for an
>> extent shared 1000 times, there are 1000 rmap records for that
>> shared extent. If you share it again, a new rmap record needs to be
>> inserted into the rmapbt, and if the AG is completely out of space
>> this can fail w/ ENOSPC. Hence you can get ENOSPC errors attempting
>> to shared or unshare extents because there isn't space in the AG for
>> the tracking metadata for the new extent record....
...
> Ok, now I've seen the filesystem layout, I can say that the
> preconditions for per-ag ENOSPC conditions do actually exist. Hence
> we now really need to know what operation is reporting ENOSPC. I
> guess we'll just have to wait for that to occur again and hope your
> scripts capture it.

FYI, "something" seems to have changed without any particular prompting 
and there haven't been any ENOSPC events in the last 3 weeks whereas 
previously they were occurring 4-5 times a week. Sigh.

Cheers,

Chris
