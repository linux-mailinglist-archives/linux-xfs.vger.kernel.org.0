Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32686324623
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Feb 2021 23:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhBXWOY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Feb 2021 17:14:24 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:55838 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231335AbhBXWOX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 17:14:23 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 89CEA1AD7F7;
        Thu, 25 Feb 2021 09:13:40 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lF2Pc-002mQb-2H; Thu, 25 Feb 2021 09:13:40 +1100
Date:   Thu, 25 Feb 2021 09:13:40 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: reduce buffer log item shadow allocations
Message-ID: <20210224221340.GF4662@dread.disaster.area>
References: <20210223044636.3280862-1-david@fromorbit.com>
 <20210223044636.3280862-2-david@fromorbit.com>
 <20210224212929.GY7272@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224212929.GY7272@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8
        a=7-415B0cAAAA:8 a=ON5KFjewiYm9JY-m1v0A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 24, 2021 at 01:29:29PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 23, 2021 at 03:46:34PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When we modify btrees repeatedly, we regularly increase the size of
> > the logged region by a single chunk at a time (per transaction
> > commit). This results in the CIL formatting code having to
> > reallocate the log vector buffer every time the buffer dirty region
> > grows. Hence over a typical 4kB btree buffer, we might grow the log
> > vector 4096/128 = 32x over a short period where we repeatedly add
> > or remove records to/from the buffer over a series of running
> > transaction. This means we are doing 32 memory allocations and frees
> > over this time during a performance critical path in the journal.
> > 
> > The amount of space tracked in the CIL for the object is calculated
> > during the ->iop_format() call for the buffer log item, but the
> > buffer memory allocated for it is calculated by the ->iop_size()
> > call. The size callout determines the size of the buffer, the format
> > call determines the space used in the buffer.
> > 
> > Hence we can oversize the buffer space required in the size
> > calculation without impacting the amount of space used and accounted
> > to the CIL for the changes being logged. This allows us to reduce
> > the number of allocations by rounding up the buffer size to allow
> > for future growth. This can safe a substantial amount of CPU time in
> > this path:
> > 
> > -   46.52%     2.02%  [kernel]                  [k] xfs_log_commit_cil
> >    - 44.49% xfs_log_commit_cil
> >       - 30.78% _raw_spin_lock
> >          - 30.75% do_raw_spin_lock
> >               30.27% __pv_queued_spin_lock_slowpath
> > 
> > (oh, ouch!)
> > ....
> >       - 1.05% kmem_alloc_large
> >          - 1.02% kmem_alloc
> >               0.94% __kmalloc
> > 
> > This overhead here us what this patch is aimed at. After:
> > 
> >       - 0.76% kmem_alloc_large
> >          - 0.75% kmem_alloc
> >               0.70% __kmalloc
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> 
> Any particular reason for 512?  It looks like you simply picked an
> arbitrary power of 2, but was there a particular target in mind? i.e.
> we never need to realloc for the usual 4k filesystem?

It is based on the bitmap chunk size being 128 bytes and that random
directory entry updates almost never require more than 3-4 128 byte
regions to be logged in the directory block.

The other observation is for per-ag btrees. When we are inserting
into a new btree block, we'll pack it from the front. Hence the
first few records land in the first 128 bytes so we log only 128
bytes, the next 8-16 records land in the second region so now we log
256 bytes. And so on.  If we are doing random updates, it will only
allocate every 4 random 128 byte regions that are dirtied instead of
every single one.

Any larger than this and I noticed an increase in memory footprint
in my scalability workloads. Any less than this and I didn't really
see any significant benefit to CPU usage.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
