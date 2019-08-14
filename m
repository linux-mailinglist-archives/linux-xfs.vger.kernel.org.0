Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D428D258
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Aug 2019 13:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbfHNLjY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Aug 2019 07:39:24 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43043 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725800AbfHNLjX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Aug 2019 07:39:23 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4D35443D5DD;
        Wed, 14 Aug 2019 21:39:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hxrbW-0002CL-QK; Wed, 14 Aug 2019 21:38:10 +1000
Date:   Wed, 14 Aug 2019 21:38:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>,
        John Hubbard <jhubbard@nvidia.com>,
        Michal Hocko <mhocko@suse.com>, linux-xfs@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 01/19] fs/locks: Export F_LAYOUT lease to user
 space
Message-ID: <20190814113810.GJ7777@dread.disaster.area>
References: <20190809225833.6657-1-ira.weiny@intel.com>
 <20190809225833.6657-2-ira.weiny@intel.com>
 <20190809235231.GC7777@dread.disaster.area>
 <20190812173626.GB19746@iweiny-DESK2.sc.intel.com>
 <20190814080547.GJ6129@dread.disaster.area>
 <1ba29bfa22f82e6d880ab31c3835047f3353f05a.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ba29bfa22f82e6d880ab31c3835047f3353f05a.camel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=QyXUC8HyAAAA:8 a=7-415B0cAAAA:8 a=ZoWuoDdl_XJqS1jHo3MA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 14, 2019 at 07:21:34AM -0400, Jeff Layton wrote:
> On Wed, 2019-08-14 at 18:05 +1000, Dave Chinner wrote:
> > On Mon, Aug 12, 2019 at 10:36:26AM -0700, Ira Weiny wrote:
> > > On Sat, Aug 10, 2019 at 09:52:31AM +1000, Dave Chinner wrote:
> > > > On Fri, Aug 09, 2019 at 03:58:15PM -0700, ira.weiny@intel.com wrote:
> > > > > +	/*
> > > > > +	 * NOTE on F_LAYOUT lease
> > > > > +	 *
> > > > > +	 * LAYOUT lease types are taken on files which the user knows that
> > > > > +	 * they will be pinning in memory for some indeterminate amount of
> > > > > +	 * time.
> > > > 
> > > > Indeed, layout leases have nothing to do with pinning of memory.
> > > 
> > > Yep, Fair enough.  I'll rework the comment.
> > > 
> > > > That's something an application taht uses layout leases might do,
> > > > but it largely irrelevant to the functionality layout leases
> > > > provide. What needs to be done here is explain what the layout lease
> > > > API actually guarantees w.r.t. the physical file layout, not what
> > > > some application is going to do with a lease. e.g.
> > > > 
> > > > 	The layout lease F_RDLCK guarantees that the holder will be
> > > > 	notified that the physical file layout is about to be
> > > > 	changed, and that it needs to release any resources it has
> > > > 	over the range of this lease, drop the lease and then
> > > > 	request it again to wait for the kernel to finish whatever
> > > > 	it is doing on that range.
> > > > 
> > > > 	The layout lease F_RDLCK also allows the holder to modify
> > > > 	the physical layout of the file. If an operation from the
> > > > 	lease holder occurs that would modify the layout, that lease
> > > > 	holder does not get notification that a change will occur,
> > > > 	but it will block until all other F_RDLCK leases have been
> > > > 	released by their holders before going ahead.
> > > > 
> > > > 	If there is a F_WRLCK lease held on the file, then a F_RDLCK
> > > > 	holder will fail any operation that may modify the physical
> > > > 	layout of the file. F_WRLCK provides exclusive physical
> > > > 	modification access to the holder, guaranteeing nothing else
> > > > 	will change the layout of the file while it holds the lease.
> > > > 
> > > > 	The F_WRLCK holder can change the physical layout of the
> > > > 	file if it so desires, this will block while F_RDLCK holders
> > > > 	are notified and release their leases before the
> > > > 	modification will take place.
> > > > 
> > > > We need to define the semantics we expose to userspace first.....
> 
> Absolutely.
> 
> > > 
> > > Agreed.  I believe I have implemented the semantics you describe above.  Do I
> > > have your permission to use your verbiage as part of reworking the comment and
> > > commit message?
> > 
> > Of course. :)
> > 
> > Cheers,
> > 
> 
> I'll review this in more detail soon, but subsequent postings of the set
> should probably also go to linux-api mailing list. This is a significant
> API change. It might not also hurt to get the glibc folks involved here
> too since you'll probably want to add the constants to the headers there
> as well.

Sure, but lets first get it to the point where we have something
that is actually workable, much more complete and somewhat validated
with unit tests before we start involving too many people. Wide
review of prototype code isn't really a good use of resources given
how much it's probably going to change from here...

> Finally, consider going ahead and drafting a patch to the fcntl(2)
> manpage if you think you have the API mostly nailed down. This API is a
> little counterintuitive (i.e. you can change the layout with an F_RDLCK
> lease), so it will need to be very clearly documented. I've also found
> that when creating a new API, documenting it tends to help highlight its
> warts and areas where the behavior is not clearly defined.

I find writing unit tests for xfstests to validate the new APIs work
as intended finds far more problems with the API than writing the
documentation. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
