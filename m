Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6B31AFEC0
	for <lists+linux-xfs@lfdr.de>; Mon, 20 Apr 2020 00:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgDSWxO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 19 Apr 2020 18:53:14 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39652 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725834AbgDSWxO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Apr 2020 18:53:14 -0400
Received: from dread.disaster.area (pa49-180-0-232.pa.nsw.optusnet.com.au [49.180.0.232])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2BEE73A3877;
        Mon, 20 Apr 2020 08:53:09 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jQIoE-0006PH-UA; Mon, 20 Apr 2020 08:53:06 +1000
Date:   Mon, 20 Apr 2020 08:53:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/12] xfs: flush related error handling cleanups
Message-ID: <20200419225306.GA9800@dread.disaster.area>
References: <20200417150859.14734-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417150859.14734-1-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=XYjVcjsg+1UI/cdbgX7I7g==:117 a=XYjVcjsg+1UI/cdbgX7I7g==:17
        a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10 a=7-415B0cAAAA:8
        a=EsSgS9FBnqeX6AKqrEwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 17, 2020 at 11:08:47AM -0400, Brian Foster wrote:
> Hi all,
> 
> This actually started as what I intended to be a cleanup of xfsaild
> error handling and the fact that unexpected errors are kind of lost in
> the ->iop_push() handlers of flushable log items. Some discussion with
> Dave on that is available here[1]. I was thinking of genericizing the
> behavior, but I'm not so sure that is possible now given the error
> handling requirements of the associated items.
> 
> While thinking through that, I ended up incorporating various cleanups
> in the somewhat confusing and erratic error handling on the periphery of
> xfsaild, such as the flush handlers. Most of these are straightforward
> cleanups except for patch 9, which I think requires careful review and
> is of debatable value. I have used patch 12 to run an hour or so of
> highly concurrent fsstress load against it and will execute a longer run
> over the weekend now that fstests has completed.
> 
> Thoughts, reviews, flames appreciated.

I'll need to do something thinking on this patchset - I have a
patchset that touches a lot of the same code I'm working on right
now to pin inode cluster buffers in memory when the inode is dirtied
so we don't get RMW cycles in AIL flushing.

That code gets rid of xfs_iflush() completely, removes dirty inodes
from the AIL and tracks only ordered cluster buffers in the AIL for
inode writeback (i.e. reduces AIL tracked log items by up to 30x).
It also only does inode writeback from the ordered cluster buffers.

The idea behind this is to make inode flushing completely
non-blocking, and to simply inode cluster flushing to simply iterate
all the dirty inodes attached to the buffer. This gets rid of radix
tree lookups and races with reclaim, and gets rid of having to
special case a locked inode in the cluster iteration code.

I was looking at this as the model to then apply to dquot flushing,
too, because it currently does not have cluster flushing, and hence
flushes dquots individually, even though there can be multiple dirty
dquots per buffer. Some of this patchset moves the dquot flushing a
bit closer to the inode code, so those parts are going to be useful
regardless of everything else....

Do you have a git tree I could pull this from to see how bad the
conflicts are?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
