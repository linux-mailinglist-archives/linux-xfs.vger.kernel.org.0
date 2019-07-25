Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2374B75A64
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Jul 2019 00:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfGYWIh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Jul 2019 18:08:37 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33007 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726635AbfGYWIh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 18:08:37 -0400
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DCBD82AD871;
        Fri, 26 Jul 2019 08:08:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hqltW-0006dB-Ey; Fri, 26 Jul 2019 08:07:26 +1000
Date:   Fri, 26 Jul 2019 08:07:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs: garbage file data inclusion bug under memory pressure
Message-ID: <20190725220726.GW7689@dread.disaster.area>
References: <f7c3d69e-bbd4-244c-41d7-b03c923c5344@i-love.sakura.ne.jp>
 <20190725113231.GV7689@dread.disaster.area>
 <804d24cb-5b7c-4620-5a5f-4ec039472086@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804d24cb-5b7c-4620-5a5f-4ec039472086@i-love.sakura.ne.jp>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=0o9FgrsRnhwA:10
        a=7-415B0cAAAA:8 a=2GznwsGOIACdh93bGC4A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 25, 2019 at 09:44:35PM +0900, Tetsuo Handa wrote:
> On 2019/07/25 20:32, Dave Chinner wrote:
> > You've had writeback errors. This is somewhat expected behaviour for
> > most filesystems when there are write errors - space has been
> > allocated, but whatever was to be written into that allocated space
> > failed for some reason so it remains in an uninitialised state....
> 
> This is bad for security perspective. The data I found are e.g. random
> source file, /var/log/secure , SQL database server's access log
> containing secret values...

The results of a read after a write error are undefined. In this
case, the test is doing enough IO to evict the cached pages that
failed the write so the followup read is pulling them from disk, not
from the page cache. i.e. if the test read back immediately after
the failure, it would get whatever the write put into the page cache
but writeback failed to write to disk....

Perhaps we need the write retry mechanisms we use for metadata in
the data IO path, too, so that a single writeback failure doesn't
cause this sort of thing to occur.

> > For XFS and sequential writes, the on-disk file size is not extended
> > on an IO error, hence it should not expose stale data.  However,
> > your test code is not checking for errors - that's a bug in your
> > test code - and that's why writeback errors are resulting in stale
> > data exposure.  i.e. by ignoring the fsync() error,
> > the test continues writing at the next offset and the fsync() for
> > that new data write exposes the region of stale data in the
> > file where the previous data write failed by extending the on-disk
> > EOF past it....
> > 
> > So in this case stale data exposure is a side effect of not
> > handling writeback errors appropriately in the application.
> 
> But blaming users regarding not handling writeback errors is pointless
> when thinking from security perspective.

I'm not blaming anyone. I'm just explaining how the problem was
exposed and pointing out that the responsibility for writing data
correctly falls on *both* the filesystem and userspace applications.
i.e. when the kernel fails it is userspace's responsibility to clean
up the mess to ensure the /application's data/ is correctly on
stable storage and not corrupt, missing, stale, etc.

So forget security - fsync is a data integrity operation. Not
checking that that it failed is extremely poor behaviour from a data
integrity point of view. Fix the data integrity problems in the
application and the security issues that data integrity failures
/may/ expose are very effectively mitigated.

> A bad guy might be trying to
> steal data from inaccessible files.

Which won't happen if user-triggered OOM does not cause writeback
failures. i.e. the bug we need to find and fix is whatever is
causing writeback to error out under OOM conditions.
Writeback is a key component of memory reclaim, and it it fails
under memory pressure we have much bigger problems...

> > But I have to ask: what is causing the IO to fail? OOM conditions
> > should not cause writeback errors - XFS will retry memory
> > allocations until they succeed, and the block layer is supposed to
> > be resilient against memory shortages, too. Hence I'd be interested
> > to know what is actually failing here...
> 
> Yeah. It is strange that this problem occurs when close-to-OOM.
> But no failure messages at all (except OOM killer messages and writeback
> error messages).

Perhaps using things like trace_kmalloc and friends to isolate the
location of memory allocation failures would help....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
