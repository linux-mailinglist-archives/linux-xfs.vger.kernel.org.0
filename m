Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D198C8D06F
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Aug 2019 12:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfHNKP3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Aug 2019 06:15:29 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:60197 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbfHNKP3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Aug 2019 06:15:29 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BB7F443CA8A;
        Wed, 14 Aug 2019 20:15:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hxqIL-0001dU-5v; Wed, 14 Aug 2019 20:14:17 +1000
Date:   Wed, 14 Aug 2019 20:14:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH 2/3] xfs: Rename __xfs_buf_submit to xfs_buf_submit
Message-ID: <20190814101417.GL6129@dread.disaster.area>
References: <20190813090306.31278-1-nborisov@suse.com>
 <20190813090306.31278-3-nborisov@suse.com>
 <20190813115658.GB37069@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813115658.GB37069@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=iox4zFpeAAAA:8 a=7-415B0cAAAA:8 a=z8SlKLqh1WW5fEYCtYUA:9
        a=CjuIK1q_8ugA:10 a=WzC6qhA0u3u7Ye7llzcV:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 13, 2019 at 07:56:58AM -0400, Brian Foster wrote:
> On Tue, Aug 13, 2019 at 12:03:05PM +0300, Nikolay Borisov wrote:
> > Since xfs_buf_submit no longer has any callers just rename its __
> > prefixed counterpart.
> > 
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> > ---
> 
> Now we have a primary submission interface that allows combinations of
> XBF_ASYNC and waiting or not while the underlying mechanisms are not so
> flexible. It looks like the current factoring exists to support delwri
> queues where we never wait in buffer submission regardless of async
> state because we are batching the submission/wait across multiple
> buffers. But what happens if a caller passes an async buffer with wait
> == true? I/O completion only completes ->b_iowait if XBF_ASYNC is clear.
> 
> I find this rather confusing because now a caller needs to know about
> implementation details to use the function properly. That's already true
> of __xfs_buf_submit(), but that's partly why it's named as an "internal"
> function. I think we ultimately need the interface flexibility so the
> delwri case can continue to work. One option could be to update
> xfs_buf_submit() such that we never wait on an XBF_ASYNC buffer and add
> an assert to flag wait == true as invalid, but TBH I'm not convinced
> this is any simpler than the current interface where most callers simply
> only need to care about the flag. Maybe others have thoughts...

Yeah, we slpit the code u plike this intentionally to separate out
the different ways of submitting IO so that we didn't end up using
invalid methods, like ASYNC + wait, which would lead to hangs
waiting for IO that has already completed.

I much prefer the code as it stands now - it may be slightly more
verbose, but it's simple to understand and hard to use
incorrectly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
