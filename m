Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22784FFC7D
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Nov 2019 01:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbfKRAkD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 17 Nov 2019 19:40:03 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49874 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726304AbfKRAkD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Nov 2019 19:40:03 -0500
Received: from dread.disaster.area (pa49-181-255-80.pa.nsw.optusnet.com.au [49.181.255.80])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 441FA7EA04F;
        Mon, 18 Nov 2019 11:40:00 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iWV5C-0004Hg-W9; Mon, 18 Nov 2019 11:39:59 +1100
Date:   Mon, 18 Nov 2019 11:39:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, dchinner@redhat.com
Subject: Re: [PATCH 4/4] xfs: Remove kmem_free()
Message-ID: <20191118003958.GQ4614@dread.disaster.area>
References: <20191114200955.1365926-1-cmaiolino@redhat.com>
 <20191114200955.1365926-5-cmaiolino@redhat.com>
 <20191114210000.GL6219@magnolia>
 <20191115142055.asqudktld7eblfea@orion>
 <20191115172322.GO6219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115172322.GO6219@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=XqaD5fcB6dAc7xyKljs8OA==:117 a=XqaD5fcB6dAc7xyKljs8OA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=MeAgGD-zjQ4A:10
        a=7-415B0cAAAA:8 a=C9sM0GcT2bnk4k31wBYA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 15, 2019 at 09:23:22AM -0800, Darrick J. Wong wrote:
> On Fri, Nov 15, 2019 at 03:20:55PM +0100, Carlos Maiolino wrote:
> > Btw, Dave mentioned in a not so far future, kmalloc() requests will be
> > guaranteed to be aligned, so, I wonder if we will be able to replace both
> > kmem_alloc_large() and kmem_alloc_io() by simple calls to kvmalloc() which does
> > the job of falling back to vmalloc() if kmalloc() fails?!
> 
> Sure, but I'll believe that when I see it.  And given that Christoph
> Lameter seems totally opposed to the idea, I think we should keep our
> silly wrapper for a while to see if they don't accidentally revert it or
> something.

It's already been merged, see this commit 59bb47985c1d ("mm,
sl[aou]b: guarantee natural alignment for kmalloc(power-of-two)").

So in 5.6/5.7 if it's still there, we can remove kmem_alloc_io().

kmem_alloc_large() may need to remain because of the
memalloc_nofs_*() wrappers vmalloc requires in GFP_NOFS context.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
