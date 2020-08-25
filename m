Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CF52523B5
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Aug 2020 00:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgHYWhL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Aug 2020 18:37:11 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:42271 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726466AbgHYWhJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 18:37:09 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 933DFD7C82B;
        Wed, 26 Aug 2020 08:37:07 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kAhYw-0000WR-MH; Wed, 26 Aug 2020 08:37:06 +1000
Date:   Wed, 26 Aug 2020 08:37:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Remove kmem_zalloc_large()
Message-ID: <20200825223706.GR12131@dread.disaster.area>
References: <20200825143458.41887-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825143458.41887-1-cmaiolino@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=tGE-6bYUNIfWuXT9wxAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 25, 2020 at 04:34:58PM +0200, Carlos Maiolino wrote:
> This patch aims to replace kmem_zalloc_large() with global kernel memory
> API. So, all its callers are now using kvzalloc() directly, so kmalloc()
> fallsback to vmalloc() automatically.
> 
> __GFP_RETRY_MAYFAIL has been set because according to memory documentation,
> it should be used in case kmalloc() is preferred over vmalloc().
> 
> Patch survives xfstests with large (32GiB) and small (4GiB) RAM memory amounts.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/kmem.h          | 6 ------
>  fs/xfs/scrub/symlink.c | 4 +++-
>  fs/xfs/xfs_acl.c       | 3 ++-
>  fs/xfs/xfs_ioctl.c     | 5 +++--
>  fs/xfs/xfs_rtalloc.c   | 3 ++-
>  5 files changed, 10 insertions(+), 11 deletions(-)
> 
> I'm not entirely sure passing __GFP_RETRY_MAYFAIL is the right thing to do here,
> but since current api attempts a kmalloc before falling back to vmalloc, it
> seems to be correct to pass it.

I don't think __GFP_RETRY_MAYFAIL is necessary. If the allocation is
larger than ALLOC_ORDER_COSTLY (8 pages, I think) then kmalloc()
will fail rather than retry forever and then it falls back to
vmalloc. Hence I don't think we need to tell the kmalloc() it needs
to fail large allocations if it can't make progress...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
