Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF1F3C0DEA
	for <lists+linux-xfs@lfdr.de>; Sat, 28 Sep 2019 00:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfI0WRT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 27 Sep 2019 18:17:19 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54558 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725990AbfI0WRT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Sep 2019 18:17:19 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7145643E7E3;
        Sat, 28 Sep 2019 08:17:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iDyY7-0007Yy-En; Sat, 28 Sep 2019 08:17:15 +1000
Date:   Sat, 28 Sep 2019 08:17:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jianshen Liu <ljishen@gmail.com>
Cc:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: Question: Modifying kernel to handle all I/O requests without
 page cache
Message-ID: <20190927221715.GM16973@dread.disaster.area>
References: <CAMgD0BoT82ApOQ=Fk6o5KYMsC=z7M88zkNCw9XuMtB0y-xaAmw@mail.gmail.com>
 <20190926123943.vzohbewlaz7dbfnb@pegasus.maiolino.io>
 <CAMgD0BqXq+zz46MEzZ8=pAAXZo_7s1vcpGQKJyby9EZhYOcVNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMgD0BqXq+zz46MEzZ8=pAAXZo_7s1vcpGQKJyby9EZhYOcVNw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=7-415B0cAAAA:8 a=ZgS7mAkLKAzZ30104mIA:9 a=WFFCBb-OkkvDTtq2:21
        a=JG7GwxqkErVSyUf_:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 26, 2019 at 06:42:43PM -0700, Jianshen Liu wrote:
> > But if you are trying to create benchmarks for a specific application, if your
> > benchmarks uses DIO or not, will depend on if the application uses DIO or not.
> 
> This is my main question. I want running an application without
> involving page caching effects even when the application does not
> support DIO.

LD_PRELOAD wrapper for the open() syscall. Check that the target is
a file, then add O_DIRECT to the open flags.

Won't help you for mmap() access that will always use the page
cache, though, so things like executables will always use the page
cache regardless of what tricks you try to play.

So, as Carlos has said, what you want to do is largely impossible to
acheive.

> > All I/O requests submitted using direct IO must be aligned. So, if the
> > application does not issue aligned requests, the IO requests will fail.
> 
> Yes, this is one of the difficulties in my problem. The application
> may not issue offset, length, buffer addressed aligned I/O. Thus, I
> cannot blindly convert application I/O to DIO within the kernel.

LD_PRELOAD wrapper to bounce buffer unaligned read/write() requests.

> > I will hit the same point again :) and my question is: Why? :) Will you be using
> > a custom kernel? With this modification? If not, you will not be gathering
> > trustable data anyway.
> 
> I created a loadable module to patch a vanilla kernel using the kernel
> livepatching mechanism.

That's just asking for trouble. I wouldn't trust a kernel that has
been modified in that way as far as I could throw it.

> > If you are trying to measure an application performance on solution X, well,
> > it is pointless to measure direct IO if the application does not use it or
> > vice-versa, so, modifying an application, again, is not what you will want to do
> > for benchmarking, for sure.
> 
> The point is that I'm not trying to measure the performance of an
> application on solution X. I'm trying to generate a
> platform-independent reference unit for the combination of a storage
> device and the application.

Sounds like an exercise that has no practical use to me - the model
will have to be so generic and full of compromises that it won't be
relevant to real world situations....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
