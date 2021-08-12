Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3CF3EA71B
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Aug 2021 17:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237830AbhHLPIF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Aug 2021 11:08:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232351AbhHLPIF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 11:08:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 398906044F;
        Thu, 12 Aug 2021 15:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628780860;
        bh=D+AE1MKE15hkAZjWKIVlKGyrILbUxIihZBxVt7gH6fc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ikcsmZCKK/PRujjwj0qABwQx8NiR/sdZDfUXIEM5vjdVxbWNHYVZuK93zLgVzl5uK
         sKAN3RmO6mp0rmoDGESxYjtBC9k3dLVwnm66ag61nmlYlgD7zQPGT66N6MdDMUtSc6
         E3n1tgC3ir/vwbYqwx20m45IdMpd3lP4QVWjZYDAbHqoFUlBArt8cbYSlKjOFdg5oS
         wZlq0H3WIfY+A+rj7eBYobtls4FbgKjaiVXxnhC5kUIInoJoJCV9X+lIJuqutYrE7v
         ijoovseeG3RvqAgeDcPHco0uHXviJWpIyBmXSxUJ9/aOeHxqcVaLsX+9FASV0A1Fkh
         pcrTLf9DFImnQ==
Date:   Thu, 12 Aug 2021 08:07:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: make xfs_rtalloc_query_range input parameters
 const
Message-ID: <20210812150739.GN3601443@magnolia>
References: <162872991654.1220643.136984377220187940.stgit@magnolia>
 <162872992222.1220643.2988115020171417694.stgit@magnolia>
 <YRTcKcK1z430Y+Lg@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRTcKcK1z430Y+Lg@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 12, 2021 at 09:30:33AM +0100, Christoph Hellwig wrote:
> On Wed, Aug 11, 2021 at 05:58:42PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In commit 8ad560d2565e, we changed xfs_rtalloc_query_range to constrain
> > the range of bits in the realtime bitmap file that would actually be
> > searched.  In commit a3a374bf1889, we changed the range again
> > (incorrectly), leading to the fix in commit d88850bd5516, which finally
> > corrected the range check code.  Unfortunately, the author never noticed
> > that the function modifies its input parameters, which is a totaly no-no
> > since none of the other range query functions change their input
> > parameters.
> > 
> > So, fix this function yet again to stash the upper end of the query
> > range (i.e. the high key) in a local variable and hope this is the last
> > time I have to fix my own function.  While we're at it, mark the key
> > inputs const so nobody makes this mistake again. :(
> 
> Heh.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> > Not-fixed-by: a3a374bf1889 ("xfs: fix off-by-one error in xfs_rtalloc_query_range")
> > Not-fixed-by: d88850bd5516 ("xfs: fix high key handling in the rt allocator's query_range function")
> 
> Are these tags a thing now or is this just a grumpy Darrick?

Just grumpy me.  If you click on the commits in gitk you can see the
long stream of me trying to wrap his head around the weirdness of
rtbitmap. :/

Thanks for the review though. :)

--D
