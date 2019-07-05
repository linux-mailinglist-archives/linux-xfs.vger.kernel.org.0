Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDEC560B13
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jul 2019 19:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbfGER1E (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Jul 2019 13:27:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42024 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728047AbfGER1E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jul 2019 13:27:04 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8F62C308AA11;
        Fri,  5 Jul 2019 17:27:03 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 37C30860DE;
        Fri,  5 Jul 2019 17:27:03 +0000 (UTC)
Date:   Fri, 5 Jul 2019 13:27:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: remove more ondisk directory corruption asserts
Message-ID: <20190705172701.GK37448@bfoster>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
 <156158199994.495944.4584531696054696463.stgit@magnolia>
 <20190705144904.GC37448@bfoster>
 <20190705170345.GH1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705170345.GH1404256@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 05 Jul 2019 17:27:03 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 05, 2019 at 10:03:45AM -0700, Darrick J. Wong wrote:
> On Fri, Jul 05, 2019 at 10:49:05AM -0400, Brian Foster wrote:
> > On Wed, Jun 26, 2019 at 01:46:40PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Continue our game of replacing ASSERTs for corrupt ondisk metadata with
> > > EFSCORRUPTED returns.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_da_btree.c  |   19 ++++++++++++-------
> > >  fs/xfs/libxfs/xfs_dir2_node.c |    3 ++-
> > >  2 files changed, 14 insertions(+), 8 deletions(-)
> > > 
> > > 
> > ...
> > > diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> > > index 16731d2d684b..f7f3fb458019 100644
> > > --- a/fs/xfs/libxfs/xfs_dir2_node.c
> > > +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> > > @@ -743,7 +743,8 @@ xfs_dir2_leafn_lookup_for_entry(
> > >  	ents = dp->d_ops->leaf_ents_p(leaf);
> > >  
> > >  	xfs_dir3_leaf_check(dp, bp);
> > > -	ASSERT(leafhdr.count > 0);
> > > +	if (leafhdr.count <= 0)
> > > +		return -EFSCORRUPTED;
> > 
> > This error return bubbles up to xfs_dir2_leafn_lookup_int() and
> > xfs_da3_node_lookup_int(). The latter has a direct return value as well
> > as a *result return parameter, which unconditionally carries the return
> > value from xfs_dir2_leafn_lookup_int(). xfs_da3_node_lookup_int() has
> > multiple callers, but a quick look at one (xfs_attr_node_addname())
> > suggests we might not handle corruption errors properly via the *result
> > parameter. Perhaps we also need to fix up xfs_da3_node_lookup_int() to
> > return particular errors directly?
> 
> It would be a good idea to clean up the whole return value/*retval mess
> in that function (and xfs_da3_path_shift where *retval came from) but
> that quickly turned into a bigger cleanup of magic values and dual
> returns, particularly since the dabtree shrinking code turns the
> _path_shift *retval into yet another series of magic int numbers...
> 

Hm.. sure, but in the meantime couldn't this patch just insert a check
for the obvious -EFSCORRUPTED error in xfs_da3_node_lookup_int() and
return that directly as opposed to via *result? That function already
returns -EFSCORRUPTED directly in other places.

As it is, this hunk is kind of strange because it inserts an error
return in a place where it seems more likely than not to be either
ignored or misinterpreted if it ever occurs. I'm fine with putting this
off as a broader cleanup, but in that case I'd prefer to just drop this
hunk for now and change the assert over when we know the return will be
handled correctly.

Either option seems reasonable (and FWIW the other bits in this patch
look fine to me)...

Brian

> ...so in the meantime this at least fixes the asserts I see when running
> fuzz testing.  I'll look at the broader cleanup for 5.4.
> 
> --D
> 
> > 
> > Brian
> > 
> > >  
> > >  	/*
> > >  	 * Look up the hash value in the leaf entries.
> > > 
