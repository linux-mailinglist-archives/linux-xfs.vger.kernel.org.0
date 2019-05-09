Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1E8018A43
	for <lists+linux-xfs@lfdr.de>; Thu,  9 May 2019 15:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfEINFo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 9 May 2019 09:05:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbfEINFn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 May 2019 09:05:43 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 924AB307CB3C;
        Thu,  9 May 2019 13:05:43 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B29821001E69;
        Thu,  9 May 2019 13:05:40 +0000 (UTC)
Date:   Thu, 9 May 2019 09:05:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        David Valin <dvalin@redhat.com>
Subject: Re: [PATCH] xfs: short circuit xfs_get_acl() if no acl is possible
Message-ID: <20190509130535.GB41691@bfoster>
References: <35128e32-d69b-316e-c8d6-8f109646390d@redhat.com>
 <20190508201033.GW5207@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508201033.GW5207@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Thu, 09 May 2019 13:05:43 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 08, 2019 at 01:10:33PM -0700, Darrick J. Wong wrote:
> On Wed, May 08, 2019 at 02:28:09PM -0500, Eric Sandeen wrote:
> > If there are no attributes on the inode, don't go through the
> > cost of memory allocation and callling xfs_attr_get when we
> > already know we'll just get -ENOATTR.
> > 
> > Reported-by: David Valin <dvalin@redhat.com>
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > 
> > diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> > index 8039e35147dd..b469b44e9e71 100644
> > --- a/fs/xfs/xfs_acl.c
> > +++ b/fs/xfs/xfs_acl.c
> > @@ -132,6 +132,9 @@ xfs_get_acl(struct inode *inode, int type)
> >  		BUG();
> >  	}
> >  
> > +	if (!xfs_inode_hasattr(ip))
> > +		return NULL;
> 
> This isn't going to cause problems if someone's adding an ACL to the
> inode at the same time, right?
> 
> I'm assuming that's the case since we only would load inodes when
> setting up a vfs inode but before any userspace can get its sticky
> fingers all over the inode, but it sure would be nice to know that
> for sure. :)
> 

Hmm, that's a good question. At first I was thinking it wouldn't matter,
but then I remembered the fairly recent issue around writing back an
empty leaf buffer on format conversion a bit too early. That has me
wondering if that would be an issue here as well. For example, suppose a
non-empty local format attr fork is being converted to extent format due
to a concurrent (and unrelated) xattr set. That involves
xfs_attr_shortform_to_leaf() -> xfs_bmap_local_to_extents_empty(), which
looks like it creates a transient empty fork state. Might
xfs_inode_hasattr() catch that as a false negative here? If so, that
would certainly be a problem if the existing xattr was the ACL the
caller happens to be interested in. It might be prudent to surround this
check with ILOCK_SHARED...

Brian

> --D
> 
> > +
> >  	/*
> >  	 * If we have a cached ACLs value just return it, not need to
> >  	 * go out to the disk.
> > 
