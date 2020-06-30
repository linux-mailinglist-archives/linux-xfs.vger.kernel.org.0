Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23118210028
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Jul 2020 00:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgF3WrB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Jun 2020 18:47:01 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:48020 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725763AbgF3WrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jun 2020 18:47:01 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 9FA435EC4F3;
        Wed,  1 Jul 2020 08:46:57 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqP1k-0000k1-LT; Wed, 01 Jul 2020 08:46:56 +1000
Date:   Wed, 1 Jul 2020 08:46:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: use MMAPLOCK around filemap_map_pages()
Message-ID: <20200630224656.GN2005@dread.disaster.area>
References: <20200623052059.1893966-1-david@fromorbit.com>
 <20200623211910.GG7606@magnolia>
 <20200623221431.GB2005@dread.disaster.area>
 <20200629170048.GR7606@magnolia>
 <CAOQ4uxiuEVW=d+g_3kj+zdTc_ngEkF+nGnJ+M2g1aU3SqsFa+w@mail.gmail.com>
 <20200630182645.GQ7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630182645.GQ7606@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=qXUg56Y5tQMzsJdrzuoA:9 a=4OnWGMq-xsf1szJI:21 a=Kt2tf_Rw1VT9IwKP:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 11:26:45AM -0700, Darrick J. Wong wrote:
> On Tue, Jun 30, 2020 at 06:23:12PM +0300, Amir Goldstein wrote:
> > > /me wonders if someone could please check all the *_ops that point to
> > > generic helpers to see if we're missing obvious things like lock
> > > taking.  Particularly someone who wants to learn about xfs' locking
> > > strategy; I promise it won't let out a ton of bees.
> > >
> > 
> > The list was compiled manually by auditing 'git grep '_operations.*=' fs/xfs'
> > structs for non xfs_/iomap_/noop_ functions.
> > I am not sure if all iomap_ functions are safe in that respect, but I suppose
> > those were done recently with sufficient xfs developers review...
> 
> The iomap functions shouldn't be taking/releasing any locks at all; it's
> up to the filesystem to provide the concurrency controls.
> 
> > fs/xfs/xfs_aops.c:const struct address_space_operations
> > xfs_address_space_operations = {
> >         .error_remove_page      = generic_error_remove_page,
> > 
> > generic_error_remove_page() calls truncate_inode_page() without MMAPLOCK
> > Is that safe? not sure
> 
> /me has a funny feeling it isn't, since this does the same thing to the
> pagecache as a holepunch.

And I really can't tell, because this comes from the convoluted 
hardware memory error path. We know that path is completely screwed
up w.r.t. memory errors in pmem and DAX filesystems. Hence I think
there's a good chance it's completely screwed up for cached
file-backed page cache pages, too.

Indeed, look at the comment in me_pagecache_clean():

        /*
         * Truncation is a bit tricky. Enable it per file system for now.
         *
         * Open: to take i_mutex or not for this? Right now we don't.
         */
        return truncate_error_page(p, pfn, mapping);

the call path is:

me_pagecache_clean()
  truncate_error_page()
    ->error_remove_page()

IOWs, the authors of this code did not know what to do, and like the
DAX failure stuff, merged the code without having resolving the
fundamental issues around interfacing with filesystem owned pages
directly...

I don't really have the time to look at it in any more depth right
now. I also suspect the memory failure code is a path we simply
cannot exercise in any useful manner so it's unlikely that we'll
ever be able to tell if this stuff works correctly or not....

Cheers,

-Dave.
-- 
Dave Chinner
david@fromorbit.com
