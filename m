Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F787E7EED
	for <lists+linux-xfs@lfdr.de>; Tue, 29 Oct 2019 05:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfJ2ECZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 29 Oct 2019 00:02:25 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:52348 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbfJ2ECZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 00:02:25 -0400
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CA0D043FC09
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 15:02:20 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iPIhy-00005b-Oy
        for linux-xfs@vger.kernel.org; Tue, 29 Oct 2019 15:02:14 +1100
Date:   Tue, 29 Oct 2019 15:02:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: properly serialise fallocate against AIO+DIO
Message-ID: <20191029040214.GM4614@dread.disaster.area>
References: <20191029034850.8212-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029034850.8212-1-david@fromorbit.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=gSlDgGGJmhgFA1TwjlYA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 29, 2019 at 02:48:50PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> AIO+DIO can extend the file size on IO completion, and it holds
> no inode locks while the IO is in flight. Therefore, a race
> condition exists in file size updates if we do something like this:
> 
> aio-thread			fallocate-thread
> 
> lock inode
> submit IO beyond inode->i_size
> unlock inode
> .....
> 				lock inode
> 				break layouts
> 				if (off + len > inode->i_size)
> 					new_size = off + len
> 				.....
> 				inode_dio_wait()
> 				<blocks>
> .....
> completes
> inode->i_size updated
> inode_dio_done()
> ....
> 				<wakes>
> 				<does stuff no long beyond EOF>
> 				if (new_size)
> 					xfs_vn_setattr(inode, new_size)
> 
> 
> Yup, that attempt to extend the file size in the fallocate code
> turns into a truncate - it removes the whatever the aio write
> allocated and put to disk, and reduced the inode size back down to
> where the fallocate operation ends.
> 
> Fundamentally, xfs_file_fallocate()  not compatible with racing
> AIO+DIO completions, so we need to move the inode_dio_wait() call
> up to where the lock the inode and break the layouts.
> 
> Secondly, storing the inode size and then using it unchecked without
> holding the ILOCK is not safe; we can only do such a thing if we've
> locked out and drained all IO and other modification operations,
> which we don't do initially in xfs_file_fallocate.
> 
> It should be noted that some of the fallocate operations are
> compound operations - they are made up of multiple manipulations
> that may zero data, and so we may need to flush and invalidate the
> file multiple times during an operation. However, we only need to
> lock out IO and other space manipulation operations once, as that
> lockout is maintained until the entire fallocate operation has been
> completed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Just a note for anyone considering backporting this patch - I
intentionally did not mark it for stable kernel backports because it
is not just a simple backport.

i.e. while it may apply cleanly to older kernels, this is based on
the current xfs for-next tree and so is based on Christoph's
xfs_ioc_space() redirection to fallocate() patch set. That means the
changes to xfs_ioc_space() are tiny and trivial. Backporting this to
kernels that don't have Christoph's patch set will require adding
all the flush/invalidation calls that I added to
xfs_file_fallocate().

i.e. all the older XFS_IOC_UNRESVSP, XFS_IOC_ZERO_RANGE, etc
interfaces look to have the same serialisation problem against
AIO-DIO writes, and so older kernels will need them fixed as well.
That code is not in this patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
