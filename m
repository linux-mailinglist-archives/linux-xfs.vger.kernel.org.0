Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4605D95C
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Jul 2019 02:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfGCAlg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 2 Jul 2019 20:41:36 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:60413 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726963AbfGCAlg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jul 2019 20:41:36 -0400
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 78ADE3DCAF6;
        Wed,  3 Jul 2019 08:32:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hiRJA-0004Ed-FL; Wed, 03 Jul 2019 08:31:28 +1000
Date:   Wed, 3 Jul 2019 08:31:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        David Valin <dvalin@redhat.com>
Subject: Re: [PATCH] xfs: short circuit xfs_get_acl() if no acl is possible
Message-ID: <20190702223128.GO7777@dread.disaster.area>
References: <35128e32-d69b-316e-c8d6-8f109646390d@redhat.com>
 <20190508201033.GW5207@magnolia>
 <20190509130535.GB41691@bfoster>
 <20190626181206.GH5171@magnolia>
 <9146eab8-06e7-e85f-d624-aa03f4046540@sandeen.net>
 <20190701185207.GB45202@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701185207.GB45202@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=0o9FgrsRnhwA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=23cHC7jD6Nl1U3iNSywA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 01, 2019 at 02:52:07PM -0400, Brian Foster wrote:
> On Wed, Jun 26, 2019 at 01:16:27PM -0500, Eric Sandeen wrote:
> > 
> > 
> > On 6/26/19 1:12 PM, Darrick J. Wong wrote:
> > > On Thu, May 09, 2019 at 09:05:39AM -0400, Brian Foster wrote:
> > >> On Wed, May 08, 2019 at 01:10:33PM -0700, Darrick J. Wong wrote:
> > >>> On Wed, May 08, 2019 at 02:28:09PM -0500, Eric Sandeen wrote:
> > >>>> If there are no attributes on the inode, don't go through the
> > >>>> cost of memory allocation and callling xfs_attr_get when we
> > >>>> already know we'll just get -ENOATTR.
> > >>>>
> > >>>> Reported-by: David Valin <dvalin@redhat.com>
> > >>>> Suggested-by: Dave Chinner <david@fromorbit.com>
> > >>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > >>>> ---
> > >>>>
> > >>>> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> > >>>> index 8039e35147dd..b469b44e9e71 100644
> > >>>> --- a/fs/xfs/xfs_acl.c
> > >>>> +++ b/fs/xfs/xfs_acl.c
> > >>>> @@ -132,6 +132,9 @@ xfs_get_acl(struct inode *inode, int type)
> > >>>>  		BUG();
> > >>>>  	}
> > >>>>  
> > >>>> +	if (!xfs_inode_hasattr(ip))
> > >>>> +		return NULL;
> > >>>
> > >>> This isn't going to cause problems if someone's adding an ACL to the
> > >>> inode at the same time, right?
> > >>>
> > >>> I'm assuming that's the case since we only would load inodes when
> > >>> setting up a vfs inode but before any userspace can get its sticky
> > >>> fingers all over the inode, but it sure would be nice to know that
> > >>> for sure. :)
> > >>>
> > >>
> > >> Hmm, that's a good question. At first I was thinking it wouldn't matter,
> > >> but then I remembered the fairly recent issue around writing back an
> > >> empty leaf buffer on format conversion a bit too early. That has me
> > >> wondering if that would be an issue here as well. For example, suppose a
> > >> non-empty local format attr fork is being converted to extent format due
> > >> to a concurrent (and unrelated) xattr set. That involves
> > >> xfs_attr_shortform_to_leaf() -> xfs_bmap_local_to_extents_empty(), which
> > >> looks like it creates a transient empty fork state. Might
> > >> xfs_inode_hasattr() catch that as a false negative here? If so, that
> > >> would certainly be a problem if the existing xattr was the ACL the
> > >> caller happens to be interested in. It might be prudent to surround this
> > >> check with ILOCK_SHARED...
> > > 
> > > <shrug> But xfs_inode_hasattr checks forkoff > 0, so as long as the
> > 
> > It does do that ...
> > 
> > int
> > xfs_inode_hasattr(
> >         struct xfs_inode        *ip)
> > {
> >         if (!XFS_IFORK_Q(ip) ||
> > 
> > 
> > > shortform to leaf conversion doesn't zero forkoff we'd be fine, I think.
> > > AFAICT it doesn't...?
> > 
> > but there's that pesky || part :
> > 
> >             (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
> >              ip->i_d.di_anextents == 0))
> >                 return 0;
> >         return 1;
> > }
> > 
> > and I think it's the latter state Brian was concerned about?
> > 
> 
> Yep, pretty much.

/me needs to uncover the "drive allocation into attr code" patch he
wrote so this "noattr == no allocation" hack isn't necessary....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
