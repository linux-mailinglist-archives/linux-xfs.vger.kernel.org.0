Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3288B1D20A8
	for <lists+linux-xfs@lfdr.de>; Wed, 13 May 2020 23:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbgEMVJV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 May 2020 17:09:21 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:35140 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbgEMVJU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 17:09:20 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 6EB0A107917;
        Thu, 14 May 2020 07:09:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYycu-00007D-8R; Thu, 14 May 2020 07:09:16 +1000
Date:   Thu, 14 May 2020 07:09:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: fix error code in xfs_iflush_cluster()
Message-ID: <20200513210916.GF2040@dread.disaster.area>
References: <20200513094803.GF347693@mwanda>
 <20200513132904.GE44225@bfoster>
 <20200513133905.GB3041@kadam>
 <20200513151754.GC1984748@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513151754.GC1984748@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=yV3fj3RYXbjK8M9sN0wA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 13, 2020 at 08:17:54AM -0700, Darrick J. Wong wrote:
> On Wed, May 13, 2020 at 04:39:05PM +0300, Dan Carpenter wrote:
> > Oh yeah.  You're right.  This patch isn't correct.  Sorry about that.
> > 
> > I worry that there are several static analyzer's which will warn about
> > this code...
> 
> /me wonders if this particular instance ought to have a breadcrumb to
> remind future readers that we can handle the lack of memory, e.g.
> 
> cilist = kmem_alloc(..., KM_MAYFAIL...);
> if (!cilist) {
> 	/* memory is tight, so defer the inode cluster flush */
> 	goto out_put;
> }

I'm working on patches that make this memory allocation go away
altogether, so I'd suggest just ignoring it for now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
