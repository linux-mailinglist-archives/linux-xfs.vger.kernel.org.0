Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68117396AB2
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Jun 2021 03:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbhFABs2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 31 May 2021 21:48:28 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54090 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231714AbhFABs2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 May 2021 21:48:28 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id EAC8F1043684;
        Tue,  1 Jun 2021 11:46:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lntUR-007XRL-Nz; Tue, 01 Jun 2021 11:46:43 +1000
Date:   Tue, 1 Jun 2021 11:46:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 06/10] xfs: remove ->b_offset handling for page backed
 buffers
Message-ID: <20210601014643.GB664593@dread.disaster.area>
References: <20210526224722.1111377-1-david@fromorbit.com>
 <20210526224722.1111377-7-david@fromorbit.com>
 <20210527230958.GG2402049@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527230958.GG2402049@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=7tGYVfG8Jl-GJ3kmL8oA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 04:09:58PM -0700, Darrick J. Wong wrote:
> On Thu, May 27, 2021 at 08:47:18AM +1000, Dave Chinner wrote:
> > From : Christoph Hellwig <hch@lst.de>
> > 
> > ->b_offset can only be non-zero for _XBF_KMEM backed buffers, so
> > remove all code dealing with it for page backed buffers.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > [dgc: modified to fit this patchset]
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> I think it's the case that the only time we'd end up with a nonzero
> b_offset is if the kmem_alloc returns a slab object in the middle of a
> page, right?  i.e. vmalloc is supposed to give us full pages, and we
> hope that nobody ever sells a device with a 64k dma alignment...?

So much would break with such a device :/

> Assuming that's right,

Yup, it is.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Ta.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
