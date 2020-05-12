Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F861D032D
	for <lists+linux-xfs@lfdr.de>; Wed, 13 May 2020 01:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgELXkz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 May 2020 19:40:55 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:47113 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725938AbgELXky (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 19:40:54 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 0F3141A843E;
        Wed, 13 May 2020 09:40:50 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYeVz-0000uM-B6; Wed, 13 May 2020 09:40:47 +1000
Date:   Wed, 13 May 2020 09:40:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: remove the libxfs_* API redirections
Message-ID: <20200512234047.GX2040@dread.disaster.area>
References: <20200512170303.1949761-1-hch@lst.de>
 <cd8e6065-3eba-0033-6c48-f01bbb2852b8@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd8e6065-3eba-0033-6c48-f01bbb2852b8@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=PDsQQsCPsZuFtj1DX0gA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 12:06:46PM -0500, Eric Sandeen wrote:
> On 5/12/20 12:03 PM, Christoph Hellwig wrote:
> > For historical reasons xfsprogs tries to renamed xfs_* symbols used
> > by tools (but not those used inside libxfs) to libxfs_.  Remove this
> > indirection to make it clear what function is being called, and to
> > avoid having to keep the renaming header uptodate.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I'm fine with this.  I'll wait a bit to see if Dave has a strong argument
> against it, but TBH I have never understood the point of the renaming.

It was done so there was a clear delineation between the functions
that return negative errors (from the libxfs core) and anything else
that was named "xfs_<foo>" in xfsprogs that returned positive
errors. This was needed back when I had to bring xfsprogs up to date
with the kernel after years of neglect and the kernel had moved to
negative errnos....

If that's no longer a useful distinction, then it doesn't bother me
if we get rid of it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
