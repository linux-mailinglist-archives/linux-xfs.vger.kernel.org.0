Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580DFA96C5
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Sep 2019 00:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfIDW5V (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Sep 2019 18:57:21 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41985 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727125AbfIDW5V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 18:57:21 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9D34143E78B;
        Thu,  5 Sep 2019 08:57:18 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5eDE-0008Ep-Lf; Thu, 05 Sep 2019 08:57:16 +1000
Date:   Thu, 5 Sep 2019 08:57:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/7] xfs: log race fixes and cleanups
Message-ID: <20190904225716.GM1119@dread.disaster.area>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904052600.GA27276@infradead.org>
 <20190904055619.GA2279@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904055619.GA2279@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=7-415B0cAAAA:8 a=nUVinjYgH7fI6QFPfPIA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 03, 2019 at 10:56:19PM -0700, Christoph Hellwig wrote:
> On Tue, Sep 03, 2019 at 10:26:00PM -0700, Christoph Hellwig wrote:
> > On Wed, Sep 04, 2019 at 02:24:44PM +1000, Dave Chinner wrote:
> > > HI folks,
> > > 
> > > This series of patches contain fixes for the generic/530 hangs that
> > > Chandan and Jan reported recently. The first patch in the series is
> > > the main fix for this, though in theory the last patch in the series
> > > is necessary to totally close the problem off.
> > 
> > While I haven't been active in the thread I already reported this weeks
> > ago as well..

Ok, I didn't know that, and now that I look there's no information
that I can use to determine what went wrong...

> And unfortunately generic/530 still hangs for me with this series.

Where does it hang?

> This is an x86-64 VM with 4G of RAM and virtio-blk, default mkfs.xfs
> options from current xfsprogs, 20G test and scratch fs.

That's pretty much what one of my test rigs is, except iscsi luns
rather than virtio-blk. I haven't been able to reproduce the issues,
so I'm kinda flying blind w.r.t. to testing them here. Can you
get a trace of what is happening (xfs_trans*, xfs_log*, xfs_ail*
tracepoints) so I can have a deeper look?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
