Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 308EB782BF
	for <lists+linux-xfs@lfdr.de>; Mon, 29 Jul 2019 02:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfG2AOR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 28 Jul 2019 20:14:17 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53596 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726247AbfG2AOR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Jul 2019 20:14:17 -0400
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4D89E43DFA5;
        Mon, 29 Jul 2019 10:14:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hrtHo-0000Hv-BU; Mon, 29 Jul 2019 10:13:08 +1000
Date:   Mon, 29 Jul 2019 10:13:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org
Subject: Re: xfs quota test xfs/050 fails with dax mount option and "-d
 su=2m,sw=1" mkfs option
Message-ID: <20190729001308.GX7689@dread.disaster.area>
References: <20190724094317.4yjm4smk2z47cwmv@XZHOUW.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724094317.4yjm4smk2z47cwmv@XZHOUW.usersys.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=0o9FgrsRnhwA:10
        a=7-415B0cAAAA:8 a=btMhTgiUG6S1lTvPJdgA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 24, 2019 at 05:43:17PM +0800, Murphy Zhou wrote:
> Hi,
> 
> As subject.
> 
> -d su=2m,sw=1     && -o dax  fail
> -d su=2m,sw=1     && NO dax  pass
> no su mkfs option && -o dax  pass
> no su mkfs option && NO dax  pass
> 
> On latest Linus tree. Reproduce every time.
> 
> Testing on older kernels are going on to see if it's a regression.
> 
> Is this failure expected ?

I'm not sure it's actually a failure at all. DAX does not do delayed
allocation, so if the write is aligned to sunit and at EOF it will
round the allocation up to a full stripe unit. IOWs, for this test
once the file size gets beyond sunit on DAX, writes will allocate in
sunit chunks.

And, well, xfs/050 has checks in it for extent size hints, and
notruns if:

        [ $extsize -ge 512000 ] && \
                _notrun "Extent size hint is too large ($extsize bytes)"

Because EDQUOT occurs when:

>     + URK 99: 2097152 is out of range! [3481600,4096000]

the file has less than 3.5MB or > 4MB allocated to it, and for a
stripe unit of > 512k, EDQUOT will occur at  <3.5MB. That's what
we are seeing here - a 2MB allocation at offset 2MB is > 4096000
bytes, and so it gets EDQUOT at that point....

IOWs, this looks like a test problem, not a code failure...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
