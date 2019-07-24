Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282B772E10
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 13:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfGXLsF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 07:48:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43146 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbfGXLsF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Jul 2019 07:48:05 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 546C430860D1;
        Wed, 24 Jul 2019 11:48:04 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DC9F819D71;
        Wed, 24 Jul 2019 11:48:03 +0000 (UTC)
Date:   Wed, 24 Jul 2019 07:48:02 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: allocate xattr buffer on demand
Message-ID: <20190724114801.GA64937@bfoster>
References: <20190722230518.19078-1-david@fromorbit.com>
 <20190723125205.GA59587@bfoster>
 <20190723231112.GT7689@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723231112.GT7689@dread.disaster.area>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 24 Jul 2019 11:48:04 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 24, 2019 at 09:11:12AM +1000, Dave Chinner wrote:
> On Tue, Jul 23, 2019 at 08:52:05AM -0400, Brian Foster wrote:
> > On Tue, Jul 23, 2019 at 09:05:18AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > When doing file lookups and checking for permissions, we end up in
> > > xfs_get_acl() to see if there are any ACLs on the inode. This
> > > requires and xattr lookup, and to do that we have to supply a buffer
> > > large enough to hold an maximum sized xattr.
> > > 
> > > On workloads were we are accessing a wide range of cache cold files
> > > under memory pressure (e.g. NFS fileservers) we end up spending a
> > > lot of time allocating the buffer. The buffer is 64k in length, so
> > > is a contiguous multi-page allocation, and if that then fails we
> > > fall back to vmalloc(). Hence the allocation here is /expensive/
> > > when we are looking up hundreds of thousands of files a second.
> > > 
> > > Initial numbers from a bpf trace show average time in xfs_get_acl()
> > > is ~32us, with ~19us of that in the memory allocation. Note these
> > > are average times, so there are going to be affected by the worst
> > > case allocations more than the common fast case...
> > > 
> > > To avoid this, we could just do a "null"  lookup to see if the ACL
> > > xattr exists and then only do the allocation if it exists. This,
> > > however, optimises the path for the "no ACL present" case at the
> > > expense of the "acl present" case. i.e. we can halve the time in
> > > xfs_get_acl() for the no acl case (i.e down to ~10-15us), but that
> > > then increases the ACL case by 30% (i.e. up to 40-45us).
> > > 
> > > To solve this and speed up both cases, drive the xattr buffer
> > > allocation into the attribute code once we know what the actual
> > > xattr length is. For the no-xattr case, we avoid the allocation
> > > completely, speeding up that case. For the common ACL case, we'll
> > > end up with a fast heap allocation (because it'll be smaller than a
> > > page), and only for the rarer "we have a remote xattr" will we have
> > > a multi-page allocation occur. Hence the common ACL case will be
> > > much faster, too.
> > > 
> > > The down side of this is the buffer allocation is now a GFP_NOFS
> > > allocation. This isn't a big deal for small allocations, though it
> > > might cause large xattrs (which are out of line and doing
> > > substantial GFP_NOFS allocations already) to have to do another
> > > large allocation in this context. I think, however, this is rare
> > > enough that it won't matter for the ACL path, and the common xattr
> > > paths can still provide and external buffer...
> > > 
> > 
> > Where's the NOFS allocation coming from?
> 
> As I mentioned to Darrick on #xfs, this is a stale comment from
> development of the original prototype. When I reworked the code this
> problem went away, but I forgot to remove it from the commit
> message.
> 

Ok.

> > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_attr.c      | 23 ++++------
> > >  fs/xfs/libxfs/xfs_attr.h      |  6 ++-
> > >  fs/xfs/libxfs/xfs_attr_leaf.c | 85 +++++++++++++++++++++--------------
> > >  fs/xfs/libxfs/xfs_da_btree.h  |  4 +-
> > >  fs/xfs/xfs_acl.c              | 14 ++----
> > >  fs/xfs/xfs_ioctl.c            |  2 +-
> > >  fs/xfs/xfs_xattr.c            |  2 +-
> > >  7 files changed, 72 insertions(+), 64 deletions(-)
> > > 
> > ...
> > > diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> > > index cbda40d40326..cba1ea9d6d0a 100644
> > > --- a/fs/xfs/xfs_acl.c
> > > +++ b/fs/xfs/xfs_acl.c
> > ...
> > > @@ -130,17 +130,9 @@ xfs_get_acl(struct inode *inode, int type)
> > >  		BUG();
> > >  	}
> > >  
> > > -	/*
> > > -	 * If we have a cached ACLs value just return it, not need to
> > > -	 * go out to the disk.
> > > -	 */
> > >  	len = XFS_ACL_MAX_SIZE(ip->i_mount);
> > > -	xfs_acl = kmem_zalloc_large(len, KM_SLEEP);
> > > -	if (!xfs_acl)
> > > -		return ERR_PTR(-ENOMEM);
> > > -
> > > -	error = xfs_attr_get(ip, ea_name, (unsigned char *)xfs_acl,
> > > -							&len, ATTR_ROOT);
> > > +	error = xfs_attr_get(ip, ea_name, (unsigned char **)&xfs_acl, &len,
> > > +				ATTR_ALLOC|ATTR_ROOT);
> > 
> > This looks mostly fine to me aside from an interface nit. I find it
> > strange that we need to specify a max value in len for an xattr of
> > unknown length.
> 
> That's a quirk of the on-disk format. i.e. v4 filesystems only have
> 25 ACLs at most, so if we find an xattr that contains 200 ACLs we've
> got an oversized xattr and it should return an error. The existing
> code will return a -ERANGE for this case, and the size of the buffer
> required would be returned in &len. This patch does not change that
> behaviour.
> 
> Capping the maximum length to what is valid for the given context
> also prevents corruption from triggering a massive allocation size
> that might cause other problems....
> 

Yeah, I'm not suggesting the check go away.

> > Even if we wanted to provide the caller the option to
> > specify a max, I think we should be able to pass zero here and not fail
> > with -ERANGE down in xfs_attr_copy_value().
> 
> We can change this behaviour if we even need such functionality. I
> don't see any point in changing API behaviour for things we don't
> actually need or use right now.
> 

This patch already changes the API. It explicitly changes len from "the
length of the provided buffer" to (alternatively) "the max valid size of
the xattr" without providing any validation for the new use case.

> > Of course, we can and should
> > still check the on-disk value length (against XFS_XATTR_SIZE_MAX for
> > example) to protect against overtly large allocation attempts if on-disk
> > data happens to bogus.
> 
> The max size of the xattr is context dependent, so given we have
> always passed this down into xfs_attr_get() for it to determine
> validity of the xattr that is found, I just don't see any
> reason to change it...
> 

As noted in my original comment, we could certainly retain the ability
to specify an optional max for these context specific cases (so the ACL
use here doesn't have to change at all). The problem I have is what the
API presents for the next ATTR_ALLOCVAL user that might not have a
context dependent max outside of the default.

In general, this flag essentially invites the developer to pass a zero
or unitialized length var since the use case is by definition when the
caller doesn't know the xattr size or want to look it up. That means the
call will either fail, inviting the developer to pass INT_MAX or some
such nonsense value, or provide random behavior depending on the
uninitialized value. Either of those scenarios may silently remove the
unconditional SIZE_MAX check because it's not clear nor
enforced/validated that the length value must be specified appropriately
to preserve it.

So really, ALLOCVAL mode should 1.) explicitly check that a non-zero
length parameter doesn't exceed XFS_XATTR_SIZE_MAX and 2.) IMO default
to checking the on-disk xattr length against XFS_XATTR_SIZE_MAX if the
user passes len == 0. That's a rather trivial change to avoid the
landmine and confusion described above and doesn't change the ACL
interface usage at all.

> > Somewhat related on the interface topic... should we ever return an
> > allocated buffer on error, or should the xattr layer unwind such
> > operations before it returns?
> 
> Errors can occur in different layers, having every layer know how to
> handle unwinding/freeing adds unnecessary complexity to the error
> handling. Having the top level code direct that the buffer must be
> allocated, and that if it was allocated it will free it regardless
> of success/failure greatly simplifies the rest of the code....
> 

All that is required is a single check to free the buffer in
xfs_attr_get() if it was internally allocated and we're returning an
error.

> It largely makes no difference if it's handled by xfs_attr_get()
> of the callers of that function. The only difference it makes if
> we push it into xfs_attr_get() is that if we specify
> XFS_DA_OP_ALLOCVAL the we have to unconditionally free anything in
> args.value. i.e. it just pushes the same semantics in one layer...
> 

Sure, either way removes the case where the caller needs clean up a
buffer allocated by the xattr subsystem on error, which is what I'd
prefer to avoid.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
