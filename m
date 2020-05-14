Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AAC1D2B57
	for <lists+linux-xfs@lfdr.de>; Thu, 14 May 2020 11:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgENJ0H (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 14 May 2020 05:26:07 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:33124 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725935AbgENJ0G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 05:26:06 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 71931D78D5D;
        Thu, 14 May 2020 19:26:04 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jZA7u-0004Ny-FM; Thu, 14 May 2020 19:26:02 +1000
Date:   Thu, 14 May 2020 19:26:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/5] Remove/convert more kmem_* wrappers
Message-ID: <20200514092602.GK2040@dread.disaster.area>
References: <20191120104425.407213-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120104425.407213-1-cmaiolino@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=P2sWjoT70lxd8KZmE0IA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 20, 2019 at 11:44:20AM +0100, Carlos Maiolino wrote:
> Hi,
> 
> in this new series, we remove most of the remaining kmem_* wrappers.
> 
> All of the wrappers being removed in this series can be directly replaced by
> generic kernel kmalloc()/kzalloc() interface.
> 
> Only interface kept is kmem_alloc() but has been converted into a local helper.
> 
> This series should be applied on top of my previous series aiming to clean up
> our memory allocation interface.
> 
> 
> Darrick, I believe this is slightly different from what you suggested
> previously, about converting kmem_* interfaces to use GFP flags directly. At
> least I read that as keeping current kmem_* interface, and getting rid of KM_*
> flags now.
> 
> But, I believe these patches does not change any allocation logic, and after the
> series we are left with fewer users of KM_* flags users to get rid of, which
> IMHO will be easier. And also I already had the patches mostly done :)
> 
> Let me know if this is ok for you.
> 
> 
> Carlos Maiolino (5):
>   xfs: remove kmem_zone_zalloc()
>   xfs: Remove kmem_zone_alloc() wrapper
>   xfs: remove kmem_zalloc() wrapper
>   xfs: Remove kmem_realloc
>   xfs: Convert kmem_alloc() users

Hmmm, just noticed that this never got merged. Whatever happened to
this patchset?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
