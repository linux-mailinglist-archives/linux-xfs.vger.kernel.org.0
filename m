Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1EC7B084C
	for <lists+linux-xfs@lfdr.de>; Wed, 27 Sep 2023 17:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbjI0Pah (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 27 Sep 2023 11:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbjI0Pah (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Sep 2023 11:30:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE86E121
        for <linux-xfs@vger.kernel.org>; Wed, 27 Sep 2023 08:30:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1FDC433C8;
        Wed, 27 Sep 2023 15:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695828635;
        bh=uypf72HBg3QrcJCMwjg6GS95hTIpouHEvLQdYZfe4u0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ObxlZcFxdRtD8I9n4RHE8/hr9xfnTTRvOPH2JulxwZEkE75t0/i/t6N5G9LNcOUfA
         nKUJ/pabXgIk8PHlw88wl7Ui54QazZoHXe1yDrItIA3SHRTnrhkPiRloH3RN4IRnBp
         Z8wpGGl9jwNiF/XONGj5cyl7OzHkN8Vwq3ouuoEs=
Date:   Wed, 27 Sep 2023 08:30:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Chandan Babu R <chandanbabu@kernel.org>
Cc:     Shiyang Ruan <ruansy.fnst@fujitsu.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        nvdimm@lists.linux.dev, dan.j.williams@intel.com
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Message-Id: <20230927083034.90bd6336229dd00af601e0ef@linux-foundation.org>
In-Reply-To: <87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
        <86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
        <20230926145519.GE11439@frogsfrogsfrogs>
        <ZROC8hEabAGS7orb@dread.disaster.area>
        <20230927014632.GE11456@frogsfrogsfrogs>
        <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
        <5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
        <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
        <87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, 27 Sep 2023 13:01:25 +0530 Chandan Babu R <chandanbabu@kernel.org> wrote:

> 
> 
> 在 2023/9/27 13:17, Shiyang Ruan 写道:
> > 
> > 在 2023/9/27 11:38, Chandan Babu R 写道:
> >> On Tue, Sep 26, 2023 at 06:46:32 PM -0700, Darrick J. Wong wrote:
> >>> On Wed, Sep 27, 2023 at 11:18:42AM +1000, Dave Chinner wrote:
> >>>> On Tue, Sep 26, 2023 at 07:55:19AM -0700, Darrick J. Wong wrote:
> >>>>> On Thu, Sep 21, 2023 at 04:33:04PM +0800, Shiyang Ruan wrote:
> >>>>>> Hi,
> >>>>>>
> >>>>>> Any comments?
> >>>>>
> >>>>> I notice that xfs/55[0-2] still fail on my fakepmem machine:
> >>>>>
> >>>>> --- /tmp/fstests/tests/xfs/550.out    2023-09-23
> >>>>> 09:40:47.839521305 -0700
> >>>>> +++ /var/tmp/fstests/xfs/550.out.bad    2023-09-24
> >>>>> 20:00:23.400000000 -0700
> >>>>> @@ -3,7 +3,6 @@ Format and mount
> >>>>>   Create the original files
> >>>>>   Inject memory failure (1 page)
> >>>>>   Inject poison...
> >>>>> -Process is killed by signal: 7
> >>>>>   Inject memory failure (2 pages)
> >>>>>   Inject poison...
> >>>>> -Process is killed by signal: 7
> >>>>> +Memory failure didn't kill the process
> >>>>>
> >>>>> (yes, rmap is enabled)
> >>>>
> >>>> Yes, I see the same failures, too. I've just been ignoring them
> >>>> because I thought that all the memory failure code was still not
> >>>> complete....
> >>>
> >>> Oh, I bet we were supposed to have merged this
> >>>
> >>> https://lore.kernel.org/linux-xfs/20230828065744.1446462-1-ruansy.fnst@fujitsu.com/
> 
> FYI, this one is in Andrew's mm-unstable tree:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-unstable&id=ff048e3e2d167927634a45f4f424338411a1c4e6

I'll move this into mm-hotfixes so it gets merged into mainline during
this -rc cycle.

Should it be backported into earlier kernels, via a cc:stable?  If so,
are we able to identify a Fixes: target?

> 
> >>>
> >>> to complete the pmem media failure handling code.  Should we (by which I
> >>> mostly mean Shiyang) ask Chandan to merge these two patches for 6.7?
> >>>
> >>
> >> I can add this patch into XFS tree for 6.7. But I will need Acks
> >> from Andrew
> >> Morton and Dan Williams.
> 
> To clarify further, I will need Acked-By for the patch at
> https://lore.kernel.org/linux-xfs/20230828065744.1446462-1-ruansy.fnst@fujitsu.com/

That would be nice.
