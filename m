Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DC722BB9D
	for <lists+linux-xfs@lfdr.de>; Fri, 24 Jul 2020 03:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgGXBkQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 Jul 2020 21:40:16 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:40070 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726381AbgGXBkQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jul 2020 21:40:16 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 88B1FD5A3A4;
        Fri, 24 Jul 2020 11:40:13 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jymh1-00028q-ID; Fri, 24 Jul 2020 11:40:11 +1000
Date:   Fri, 24 Jul 2020 11:40:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: Remove kmem_zone_alloc() usage
Message-ID: <20200724014011.GI2005@dread.disaster.area>
References: <20200722090518.214624-1-cmaiolino@redhat.com>
 <20200722090518.214624-2-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722090518.214624-2-cmaiolino@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=a9V-P2yfxTLrWrZOPYcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 22, 2020 at 11:05:14AM +0200, Carlos Maiolino wrote:
> Use kmem_cache_alloc() directly.
> 
> All kmem_zone_alloc() users pass 0 as flags, which are translated into:
> GFP_KERNEL | __GFP_NOWARN, and kmem_zone_alloc() loops forever until the
> allocation succeeds.
> 
> We can use __GFP_NOFAIL to tell the allocator to loop forever rather
> than doing it ourself, and because the allocation will never fail, we do
> not need to use __GFP_NOWARN anymore. Hence, all callers can be
> converted to use GFP_KERNEL | __GFP_NOFAIL
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> Changelog:
> 	V2:
> 		- Wire up xfs_inode_alloc to use __GFP_NOFAIL
> 		  if it's called inside a transaction
> 		- Rewrite changelog in a more decent way.
> 	V3:
> 		- Use __GFP_NOFAIL unconditionally in xfs_inode_alloc(),
> 		  use of PF_FSTRANS will be added when the patch re-adding
> 		  it is moved to mainline.
> 
>  fs/xfs/libxfs/xfs_alloc.c |  3 ++-
>  fs/xfs/libxfs/xfs_bmap.c  |  3 ++-
>  fs/xfs/xfs_icache.c       | 10 ++--------
>  3 files changed, 6 insertions(+), 10 deletions(-)

Looks fine with or without the comment as christoph noted.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
